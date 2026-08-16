class GameCrowdAgentSkeletal extends GameCrowdAgent
    abstract
    native
    placeable
    hidecategories(Navigation,Advanced,Attachment,Collision,Object);

struct native GameCrowdAttachmentList
{
    var() name SocketName;
    var() array<GameCrowdAttachmentInfo> List;
};

struct native GameCrowdAttachmentInfo
{
    var() StaticMesh StaticMesh;
    var() float Chance;
    var() Vector Scale3D;
};

var(Rendering) export editinline SkeletalMeshComponent SkeletalMeshComponent;
var AnimNodeBlend SpeedBlendNode;
var AnimNodeSlot FullBodySlot;
var AnimNodeSequence ActionSeqNode;
var AnimNodeSequence WalkSeqNode;
var AnimNodeSequence RunSeqNode;
var AnimTree AgentTree;
var(Rendering) array<name> WalkAnimNames;
var(Rendering) array<name> RunAnimNames;
var(Rendering) array<name> IdleAnimNames;
var(Behavior) array<name> DeathAnimNames;
var(SpeedBlendAnim) float SpeedBlendStart;
var(SpeedBlendAnim) float SpeedBlendEnd;
var(SpeedBlendAnim) float AnimVelRate;
var(SpeedBlendAnim) float MaxSpeedBlendChangeSpeed;
var(SpeedBlendAnim) name MoveSyncGroupName;
var(Rendering) array<GameCrowdAttachmentList> Attachments;
var(Behavior) float MaxTargetAcquireTime;
var(Rendering) bool bUseRootMotionVelocity;
var bool bIsPlayingIdleAnimation;
var bool bIsPlayingDeathAnimation;
var bool bAnimateThisTick;
var(LOD) float MaxAnimationDistance;
var float MaxAnimationDistanceSq;

simulated function CreateAttachments()
{
    local int AttachIdx, InfoIdx, PickedInfoIdx;
    local float ChanceTotal, RandVal;
    local StaticMeshComponent StaticMeshComp;
    local bool bUseSocket, bUseBone;
    
    for (AttachIdx = 0; AttachIdx < Attachments.Length; AttachIdx++)
    {
        if (Attachments[AttachIdx].List.Length == 0)
        {
            continue;
        }
        ChanceTotal = 0.0;
        for (InfoIdx = 0; InfoIdx < Attachments[AttachIdx].List.Length; InfoIdx++)
        {
            ChanceTotal += Attachments[AttachIdx].List[InfoIdx].Chance;
        }
        RandVal = FRand() * ChanceTotal;
        ChanceTotal = 0.0;
        for (InfoIdx = 0; InfoIdx < Attachments[AttachIdx].List.Length; InfoIdx++)
        {
            ChanceTotal += Attachments[AttachIdx].List[InfoIdx].Chance;
            if (ChanceTotal >= RandVal)
            {
                PickedInfoIdx = InfoIdx;
                break;
            }
        }
        if (Attachments[AttachIdx].List[PickedInfoIdx].StaticMesh != none)
        {
            bUseSocket = SkeletalMeshComponent.GetSocketByName(Attachments[AttachIdx].SocketName) != none;
            bUseBone = SkeletalMeshComponent.MatchRefBone(Attachments[AttachIdx].SocketName) != -1;
            if (bUseSocket || bUseBone)
            {
                StaticMeshComp = new(self) class'Engine.StaticMeshComponent';
                StaticMeshComp.SetStaticMesh(Attachments[AttachIdx].List[PickedInfoIdx].StaticMesh);
                StaticMeshComp.SetActorCollision(false, false);
                StaticMeshComp.SetScale3D(Attachments[AttachIdx].List[PickedInfoIdx].Scale3D);
                StaticMeshComp.SetLightEnvironment(LightEnvironment);
                if (bUseSocket)
                {
                    SkeletalMeshComponent.AttachComponentToSocket(StaticMeshComp, Attachments[AttachIdx].SocketName);
                }
                else
                {
                    SkeletalMeshComponent.AttachComponent(StaticMeshComp, Attachments[AttachIdx].SocketName);
                }
                continue;
            }
            LogInternal("CrowdAgent: WARNING: Could not find socket or bone called '" $ string(Attachments[AttachIdx].SocketName) $ "' for mesh '" @ string(Attachments[AttachIdx].List[PickedInfoIdx].StaticMesh) $ "'");
        }
    }
}

event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
    if (CurrentBehavior != none)
    {
        CurrentBehavior.OnAnimEnd(SeqNode, PlayedTime, ExcessTime);
    }
}

simulated event StopIdleAnimation()
{
    FullBodySlot.StopCustomAnim(0.1);
    bIsPlayingIdleAnimation = false;
}

simulated event PlayIdleAnimation()
{
    bIsPlayingIdleAnimation = true;
    FullBodySlot.PlayCustomAnim(IdleAnimNames[Rand(IdleAnimNames.Length)], 1.0, 0.1, 0.1, true, false);
}

event ClearLatentAnimation()
{
    ClearLatentAction(class'SeqAct_PlayAgentAnimation', false);
}

simulated function OnPlayAgentAnimation(SeqAct_PlayAgentAnimation Action)
{
    if (Action.InputLinks[1].bHasImpulse)
    {
        Action.ActivateOutputLink(1);
        StopBehavior();
        if (CurrentDestination.ReachedByAgent(self, Location, false))
        {
            CurrentDestination.ReachedDestination(self);
        }
    }
    else
    {
        Action.SetCurrentAnimationActionFor(self);
    }
}

native function SetRootMotion(bool bRootMotionEnabled)
{
    bRootMotionEnabled;
}

native function PlayDeath(Vector KillMomentum)
{
    KillMomentum;
}

simulated function SetLighting(bool bEnableLightEnvironment, LightingChannelContainer AgentLightingChannel, bool bCastShadows)
{
    SetLighting(bEnableLightEnvironment, AgentLightingChannel, bCastShadows);
    SkeletalMeshComponent.SetLightingChannels(AgentLightingChannel);
    CreateAttachments();
    SkeletalMeshComponent.CastShadow = bCastShadows;
    SkeletalMeshComponent.bCastDynamicShadow = bCastShadows;
    SkeletalMeshComponent.ForceUpdate(false);
}

simulated function PostBeginPlay()
{
    PostBeginPlay();
    if (bDeleteMe)
    {
        return;
    }
    SpeedBlendNode = AnimNodeBlend(SkeletalMeshComponent.FindAnimNode('SpeedBlendNode'));
    FullBodySlot = AnimNodeSlot(SkeletalMeshComponent.FindAnimNode('ActionBlendNode'));
    ActionSeqNode = AnimNodeSequence(SkeletalMeshComponent.FindAnimNode('ActionSeqNode'));
    WalkSeqNode = AnimNodeSequence(SkeletalMeshComponent.FindAnimNode('WalkSeqNode'));
    RunSeqNode = AnimNodeSequence(SkeletalMeshComponent.FindAnimNode('RunSeqNode'));
    AgentTree = AnimTree(SkeletalMeshComponent.Animations);
    if (WalkSeqNode != none && WalkAnimNames.Length > 0)
    {
        WalkSeqNode.SetAnim(WalkAnimNames[Rand(WalkAnimNames.Length)]);
    }
    if (RunSeqNode != none && RunAnimNames.Length > 0)
    {
        RunSeqNode.SetAnim(RunAnimNames[Rand(RunAnimNames.Length)]);
    }
    if (ActionSeqNode != none)
    {
        ActionSeqNode.bZeroRootTranslation = true;
    }
    if (bUseRootMotionVelocity)
    {
        SkeletalMeshComponent.RootMotionMode = 3;
        WalkSeqNode.SetRootBoneAxisOption(2, 2, 2);
        RunSeqNode.SetRootBoneAxisOption(2, 2, 2);
    }
    MaxAnimationDistanceSq = MaxAnimationDistance * MaxAnimationDistance;
}

defaultproperties
{
    SkeletalMeshComponent="Default__GameCrowdAgentSkeletal.SkeletalMeshComponent0"
    SpeedBlendStart=150.0
    SpeedBlendEnd=180.0
    AnimVelRate=0.0098
    MaxSpeedBlendChangeSpeed=2.0
    MoveSyncGroupName="MoveGroup"
    MaxTargetAcquireTime=5.0
    MaxAnimationDistance=12000.0
    LightEnvironment="Default__GameCrowdAgentSkeletal.MyLightEnvironment"
    Components(0)="Default__GameCrowdAgentSkeletal.MyLightEnvironment"
    Components(1)="Default__GameCrowdAgentSkeletal.SkeletalMeshComponent0"
}

class SkeletalMeshActor extends Actor
    native
    placeable
    hidecategories(Navigation);

enum ESpeakLineBroadcastFilter
{
    SLBFilter_None,
    SLBFilter_SpeakerOnly,
    SLBFilter_SpeakerTeamOnly,
    SLBFilter_SpeakerAndAddresseeOnly,
};

enum ESpeechInterruptCondition
{
    SIC_IfHigher,
    SIC_Never,
    SIC_IfSameOrHigher,
    SIC_Always,
};

struct native SpeakLineParamStruct
{
    var Actor Addressee;
    var SoundCue Audio;
    var string DebugText;
    var bool bNoHeadTrack;
    var ESpeakLineBroadcastFilter BroadcastFilter;
    var bool bSuppressSubtitle;
    var ESpeechPriority Priority;
    var float DelayTime;
    var float ExtraHeadTrackTime;
};

struct native SkelMeshActorControlTarget
{
    var() name ControlName;
    var() Actor TargetActor;
};

var() bool bDamageAppliesImpulse;
var() bool bShouldDoAnimNotifies;
var deprecated bool bCollideActors_OldValue;
var bool bSonarActive;
var bool bSonarActor;
var transient bool bSpeaking;
var() bool bDebugSpeech;
var bool bForceDesiredRotation;
var() export editinline SkeletalMeshComponent SkeletalMeshComponent;
var() const export editconst editinline LightEnvironmentComponent LightEnvironment;
var export editinline AudioComponent FacialAudioComp;
var transient repnotify SkeletalMesh ReplicatedMesh;
var repnotify MaterialInterface ReplicatedMaterial;
var() array<SkelMeshActorControlTarget> ControlTargets;
var transient array<InterpGroup> InterpGroupList;
var(FaceFX) array<FaceFXAnimSet> FacialAnimSets;
var(FaceFX) array<FacialFaceFXAnimInfo> FacialAnimInfo;
var(FaceFX) float RandomFacialAnimDeltaTime;
var(FaceFX) float RandomFacialMinTime;
var transient float RandomFacialAnimTime;
var transient ESpeechPriority CurrentSpeechPriority;
var(Speak) float SpeakRotateRate;
var SpeakLineParamStruct ReplicatedSpeakLineParams;
var SpeakLineParamStruct QueuedSpeakLineParams;
var SpeakLineParamStruct CurrentSpeakLineParams;
var export editinline AudioComponent CurrentlySpeakingLine;
var float SpeechPitchMultiplier;
var Actor KismetHeadLookAtActor;

replication
{
    if (Role == 3)
        ReplicatedMesh, ReplicatedMaterial;
}

function updateSonarMat(float DeltaTime)
{
}

event Tick(float DeltaTime)
{
    updateSonarMat(DeltaTime);
}

function setSonarActor(bool bIsSonar)
{
    bSonarActor = bIsSonar;
}

function CreateAndSetSonarMat()
{
    local int ElementIndex;
    local MaterialInstanceConstant MatInst, newInstance;
    
    if (SkeletalMeshComponent == none)
    {
        return;
    }
    for (ElementIndex = 0; ElementIndex < SkeletalMeshComponent.GetNumElements(); ElementIndex++)
    {
        MatInst = MaterialInstanceConstant(SkeletalMeshComponent.GetMaterial(ElementIndex));
        if (MatInst != none && MatInst.bSonarMaterial)
        {
            newInstance = new(self) class'MaterialInstanceConstant';
            newInstance.SetParent(MatInst.Parent);
            newInstance.initSonarParam(MatInst);
            SkeletalMeshComponent.SetMaterial(ElementIndex, newInstance);
            setSonarActor(true);
            WorldInfo.GetLocalPlayerPawn().Controller.AddSonarDetectedActor(self);
        }
    }
}

event DisableKismetHeadLookAt()
{
    SetKismetHeadLookAtActor(none);
}

event SetKismetHeadLookAtActor(Actor ActorToTrack)
{
    local AnimTree TheAnimTree;
    local SkelControlLookAt Control;
    local int I;
    
    if (Controller(ActorToTrack) != none)
    {
        ActorToTrack = Controller(ActorToTrack).Pawn;
    }
    TheAnimTree = AnimTree(SkeletalMeshComponent.Animations);
    if (TheAnimTree != none)
    {
        for (I = 0; I < TheAnimTree.SkelControlLists.Length; I++)
        {
            Control = SkelControlLookAt(TheAnimTree.SkelControlLists[I].ControlHead);
            if (Control != none)
            {
                if (ActorToTrack != none)
                {
                    KismetHeadLookAtActor = ActorToTrack;
                    Control.TargetLocation = ActorToTrack.Location;
                    Control.SetSkelControlActive(true);
                    continue;
                }
                KismetHeadLookAtActor = ActorToTrack;
                Control.SetSkelControlActive(false);
            }
        }
    }
}

final simulated event SpeakLineFinished()
{
    local SpeakLineParamStruct EmptyLine;
    
    bSpeaking = false;
    if (CurrentlySpeakingLine != none)
    {
        WorldInfo.Game.NotifyDialogueFinish(self, CurrentlySpeakingLine.SoundCue);
        CurrentlySpeakingLine = none;
    }
    ClearTimer('SpeakLineFinished');
    if (KismetHeadLookAtActor != none && KismetHeadLookAtActor == CurrentSpeakLineParams.Addressee || KismetHeadLookAtActor == Controller(CurrentSpeakLineParams.Addressee).Pawn)
    {
        if (CurrentSpeakLineParams.ExtraHeadTrackTime > 0.0)
        {
            SetTimer(CurrentSpeakLineParams.ExtraHeadTrackTime, false, 'DisableKismetHeadLookAt');
        }
        else
        {
            DisableKismetHeadLookAt();
        }
    }
    ReplicatedSpeakLineParams = EmptyLine;
}

simulated exec event PlaySpeechGesture(name GestureAnim)
{
    local AnimNodeSequence AnimSeq;
    
    AnimSeq = AnimNodeSequence(SkeletalMeshComponent.Animations);
    if (AnimSeq != none)
    {
        AnimSeq.SetAnim(GestureAnim);
        AnimSeq.PlayAnim();
    }
}

native private final simulated function PlayQueuedSpeakLine()
{
}

function OnInterruptSpeech(SeqAct_InterruptSpeech Action)
{
    if (CurrentlySpeakingLine != none)
    {
        CurrentlySpeakingLine.FadeOut(0.2, 0.0);
        SpeakLineFinished();
    }
}

native private final simulated function bool ShouldFilterOutSpeech(ESpeakLineBroadcastFilter Filter, Actor Addressee)
{
    Filter;
    Addressee;
}

native private final simulated function bool ShouldSuppressSubtitlesForQueuedSpeakLine(bool bVersusMulti)
{
    bVersusMulti;
}

native final simulated function bool SpeakLine(Actor Addressee, SoundCue Audio, string DebugText, float DelaySec, optional ESpeechPriority Priority, optional ESpeechInterruptCondition IntCondition, optional bool bNoHeadTrack, optional int BroadcastFilter, optional bool bSuppressSubtitle, optional float InExtraHeadTrackTime, optional bool bClientSide)
{
    Addressee;
    Audio;
    DebugText;
    DelaySec;
    Priority;
    IntCondition;
    bNoHeadTrack;
    BroadcastFilter;
    bSuppressSubtitle;
    InExtraHeadTrackTime;
    bClientSide;
}

event bool CreateForceField(const AnimNotify_ForceField AnimNotifyData)
{
    local NxForceFieldComponent NewForceFieldComponent;
    
    NewForceFieldComponent = new(SkeletalMeshComponent) AnimNotifyData.ForceFieldComponent.Class(AnimNotifyData.ForceFieldComponent);
    NewForceFieldComponent.DoInitRBPhys();
    if (AnimNotifyData.SocketName != 'None')
    {
        SkeletalMeshComponent.AttachComponentToSocket(NewForceFieldComponent, AnimNotifyData.SocketName);
    }
    else if (AnimNotifyData.BoneName != 'None')
    {
        SkeletalMeshComponent.AttachComponent(NewForceFieldComponent, AnimNotifyData.BoneName);
    }
    return true;
}

simulated function SkelMeshActorOnParticleSystemFinished(ParticleSystemComponent PSC)
{
    SkeletalMeshComponent.DetachComponent(PSC);
}

event PlayParticleEffect(const AnimNotify_PlayParticleEffect AnimNotifyData, SkeletalMeshComponent SrcSkelComp)
{
    local Vector Loc;
    local Rotator Rot;
    local ParticleSystemComponent PSC;
    
    if (bShouldDoAnimNotifies == false || AnimNotifyData.bIsExtremeContent == true && WorldInfo.GRI.ShouldShowGore() == false)
    {
        return;
    }
    if (AnimNotifyData.SocketName != 'None')
    {
        SkeletalMeshComponent.GetSocketWorldLocationAndRotation(AnimNotifyData.SocketName, Loc, Rot);
    }
    else if (AnimNotifyData.BoneName != 'None')
    {
        Loc = SkeletalMeshComponent.GetBoneLocation(AnimNotifyData.BoneName);
    }
    else
    {
        Loc = Location;
    }
    if (AnimNotifyData.bAttach == true)
    {
        PSC = new(self) class'ParticleSystemComponent';
        PSC.SetTemplate(AnimNotifyData.PSTemplate);
        if (AnimNotifyData.SocketName != 'None')
        {
            SkeletalMeshComponent.AttachComponentToSocket(PSC, AnimNotifyData.SocketName);
        }
        else if (AnimNotifyData.BoneName != 'None')
        {
            SkeletalMeshComponent.AttachComponent(PSC, AnimNotifyData.BoneName);
        }
        PSC.ActivateSystem();
        PSC.__OnSystemFinished__Delegate = SkelMeshActorOnParticleSystemFinished;
    }
    else
    {
        WorldInfo.MyEmitterPool.SpawnEmitter(AnimNotifyData.PSTemplate, Loc, rot(0, 0, 1));
    }
}

event TakeDamage(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    local Vector ApplyImpulse;
    
    TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    if (bDamageAppliesImpulse && DamageType.default.default.KDamageImpulse > float(0))
    {
        if (VSize(Momentum) < 0.001)
        {
            LogInternal("Zero momentum to SkeletalMeshActor.TakeDamage");
            return;
        }
        ApplyImpulse = Normal(Momentum) * DamageType.default.default.KDamageImpulse;
        if (HitInfo.HitComponent != none)
        {
            HitInfo.HitComponent.AddImpulse(ApplyImpulse, HitLocation, HitInfo.BoneName);
        }
    }
}

function DoKismetAttachment(Actor Attachment, SeqAct_AttachToActor Action)
{
    local bool bOldCollideActors, bOldBlockActors, bValidBone, bValidSocket;
    
    if (SkeletalMeshComponent != none && Action.BoneName != 'None')
    {
        bValidSocket = SkeletalMeshComponent.GetSocketByName(Action.BoneName) != none;
        bValidBone = SkeletalMeshComponent.MatchRefBone(Action.BoneName) != -1;
        if (!bValidBone && !bValidSocket)
        {
            LogInternal(string(WorldInfo.TimeSeconds) @ string(Class) @ string(GetFuncName()) @ "bone or socket" @ string(Action.BoneName) @ "not found on actor" @ string(self) @ "with mesh" @ string(SkeletalMeshComponent));
        }
    }
    if (bValidBone || bValidSocket)
    {
        bOldCollideActors = Attachment.bCollideActors;
        bOldBlockActors = Attachment.bBlockActors;
        Attachment.SetCollision(false, false);
        Attachment.SetHardAttach(Action.bHardAttach);
        if (bValidBone && !bValidSocket)
        {
            if (Action.bUseRelativeOffset)
            {
                Attachment.SetLocation(SkeletalMeshComponent.GetBoneLocation(Action.BoneName));
            }
            if (Action.bUseRelativeRotation)
            {
                Attachment.SetRotation(QuatToRotator(SkeletalMeshComponent.GetBoneQuaternion(Action.BoneName)));
            }
        }
        Attachment.SetBase(self, , SkeletalMeshComponent, Action.BoneName);
        if (Action.bUseRelativeRotation)
        {
            Attachment.SetRelativeRotation(Attachment.RelativeRotation + Action.RelativeRotation);
        }
        if (Action.bUseRelativeOffset)
        {
            Attachment.SetRelativeLocation(Attachment.RelativeLocation + Action.RelativeOffset);
        }
        Attachment.SetCollision(bOldCollideActors, bOldBlockActors);
    }
    else
    {
        DoKismetAttachment(Attachment, Action);
    }
}

simulated event OnSetSkelControlTarget(SeqAct_SetSkelControlTarget Action)
{
    local int I;
    
    if (Action.SkelControlName == 'None' || Action.TargetActors.Length == 0)
    {
        return;
    }
    for (I = 0; I < ControlTargets.Length; I++)
    {
        if (ControlTargets[I].ControlName == Action.SkelControlName)
        {
            ControlTargets[I].TargetActor = Actor(Action.TargetActors[Rand(Action.TargetActors.Length)]);
            return;
        }
    }
    ControlTargets.Length = ControlTargets.Length + 1;
    ControlTargets[ControlTargets.Length - 1].ControlName = Action.SkelControlName;
    ControlTargets[ControlTargets.Length - 1].TargetActor = Actor(Action.TargetActors[Rand(Action.TargetActors.Length)]);
}

simulated event OnUpdatePhysBonesFromAnim(SeqAct_UpdatePhysBonesFromAnim Action)
{
    if (Action.InputLinks[0].bHasImpulse)
    {
        SkeletalMeshComponent.ForceSkelUpdate();
        SkeletalMeshComponent.UpdateRBBonesFromSpaceBases(true, true);
    }
    else if (Action.InputLinks[1].bHasImpulse)
    {
        if (SkeletalMeshComponent.PhysicsAssetInstance != none)
        {
            SkeletalMeshComponent.PhysicsAssetInstance.SetAllBodiesFixed(true);
        }
    }
    else if (Action.InputLinks[2].bHasImpulse)
    {
        if (SkeletalMeshComponent.PhysicsAssetInstance != none)
        {
            SkeletalMeshComponent.PhysicsAssetInstance.SetFullAnimWeightBonesFixed(false, SkeletalMeshComponent);
        }
    }
}

event OnSetMesh(SeqAct_SetMesh Action)
{
    if (Action.MeshType == 1)
    {
        if (Action.NewSkeletalMesh != none && Action.NewSkeletalMesh != SkeletalMeshComponent.SkeletalMesh)
        {
            SkeletalMeshComponent.SetSkeletalMesh(Action.NewSkeletalMesh);
            ReplicatedMesh = Action.NewSkeletalMesh;
        }
    }
}

simulated function bool IsActorPlayingFaceFXAnim()
{
    return GetFaceFXSkelMeshComp() != none && GetFaceFXSkelMeshComp().IsPlayingFaceFXAnim();
}

simulated event FaceFXAsset GetActorFaceFXAsset()
{
    if (GetFaceFXSkelMeshComp().SkeletalMesh != none)
    {
        return GetFaceFXSkelMeshComp().SkeletalMesh.FaceFXAsset;
    }
    else
    {
        return none;
    }
}

simulated function OnPlayFaceFXAnim(SeqAct_PlayFaceFXAnim inAction)
{
    local PlayerController PC;
    
    GetFaceFXSkelMeshComp().PlayFaceFXAnim(inAction.FaceFXAnimSetRef, inAction.FaceFXAnimName, inAction.FaceFXGroupName, inAction.SoundCueToPlay);
    foreach WorldInfo.AllControllers(class'PlayerController', PC)
    {
        if (NetConnection(PC.Player) != none)
        {
            PC.ClientPlayActorFaceFXAnim(self, inAction.FaceFXAnimSetRef, inAction.FaceFXGroupName, inAction.FaceFXAnimName, inAction.SoundCueToPlay);
        }
    }
}

simulated event AudioComponent GetFaceFXAudioComponent()
{
    return FacialAudioComp;
}

simulated event StopActorFaceFXAnim()
{
    GetFaceFXSkelMeshComp().StopFaceFXAnim();
}

simulated event bool PlayActorFaceFXAnim(FaceFXAnimSet AnimSet, string GroupName, string SeqName, SoundCue SoundCueToPlay)
{
    return GetFaceFXSkelMeshComp().PlayFaceFXAnim(AnimSet, SeqName, GroupName, SoundCueToPlay);
}

native function MAT_FinishAnimControl(InterpGroup InInterpGroup)
{
    InInterpGroup;
}

simulated event FinishAnimControl(InterpGroup InInterpGroup)
{
    MAT_FinishAnimControl(InInterpGroup);
}

simulated event SetAnimPosition(name SlotName, int ChannelIndex, name InAnimSeqName, float InPosition, bool bFireNotifies, bool bLooping, int RootMotionLevel)
{
    local AnimNodeSequence SeqNode;
    
    SeqNode = AnimNodeSequence(SkeletalMeshComponent.Animations);
    if (SeqNode != none)
    {
        if (SeqNode.AnimSeqName != InAnimSeqName)
        {
            SeqNode.SetAnim(InAnimSeqName);
        }
        SeqNode.bLooping = bLooping;
        SeqNode.SetPosition(InPosition, bFireNotifies);
    }
}

native function MAT_BeginAnimControl(InterpGroup InInterpGroup)
{
    InInterpGroup;
}

simulated event BeginAnimControl(InterpGroup InInterpGroup)
{
    MAT_BeginAnimControl(InInterpGroup);
}

function OnSetMaterial(SeqAct_SetMaterial Action)
{
    SkeletalMeshComponent.SetMaterial(Action.MaterialIndex, Action.NewMaterial);
    if (Action.MaterialIndex == 0)
    {
        ReplicatedMaterial = Action.NewMaterial;
        ForceNetRelevant();
    }
}

simulated function OnToggle(SeqAct_Toggle Action)
{
    local AnimNodeSequence SeqNode;
    
    SeqNode = AnimNodeSequence(SkeletalMeshComponent.Animations);
    if (Action.InputLinks[0].bHasImpulse)
    {
        if (!SeqNode.bPlaying)
        {
            SeqNode.PlayAnim(SeqNode.bLooping, SeqNode.Rate, 0.0);
        }
    }
    else if (Action.InputLinks[1].bHasImpulse)
    {
        if (SeqNode.bPlaying)
        {
            SeqNode.StopAnim();
        }
    }
    else if (Action.InputLinks[2].bHasImpulse)
    {
        if (SeqNode.bPlaying)
        {
            SeqNode.StopAnim();
        }
        else
        {
            SeqNode.PlayAnim(SeqNode.bLooping, SeqNode.Rate, 0.0);
        }
    }
}

simulated event ReplicatedEvent(name VarName)
{
    if (VarName == 'ReplicatedMesh')
    {
        SkeletalMeshComponent.SetSkeletalMesh(ReplicatedMesh);
    }
    else if (VarName == 'ReplicatedMaterial')
    {
        SkeletalMeshComponent.SetMaterial(0, ReplicatedMaterial);
    }
    else
    {
        ReplicatedEvent(VarName);
    }
}

native simulated function UpdateAnimSetList()
{
}

simulated event Destroyed()
{
    Destroyed();
    InterpGroupList.Length = 0;
    UpdateAnimSetList();
    if (bSonarActor)
    {
        WorldInfo.GetLocalPlayerPawn().Controller.RemoveSonarDetectedActor(self);
    }
}

simulated function MountFacialAnimSets()
{
    local int I;
    local SkeletalMeshComponent FaceFXSkelComp;
    
    FaceFXSkelComp = GetFaceFXSkelMeshComp();
    if (FaceFXSkelComp != none && FaceFXSkelComp.SkeletalMesh != none && FaceFXSkelComp.SkeletalMesh.FaceFXAsset != none)
    {
        for (I = 0; I < FacialAnimSets.Length; ++I)
        {
            FaceFXSkelComp.SkeletalMesh.FaceFXAsset.MountFaceFXAnimSet(FacialAnimSets[I]);
        }
    }
}

simulated event PostBeginPlay()
{
    SkeletalMeshComponent.SaveAnimSets();
    if (Role == 3 && SkeletalMeshComponent != none)
    {
        ReplicatedMesh = SkeletalMeshComponent.SkeletalMesh;
    }
    if (SkeletalMeshComponent != none && SkeletalMeshComponent.PhysicsAssetInstance != none)
    {
        SkeletalMeshComponent.PhysicsAssetInstance.SetFullAnimWeightBonesFixed(false, SkeletalMeshComponent);
    }
    if (SkeletalMeshComponent != none && SkeletalMeshComponent.bEnableClothSimulation)
    {
        SkeletalMeshComponent.bAlwaysUpdateMeshObject = false;
    }
    if (bHidden)
    {
        SkeletalMeshComponent.SetClothFrozen(true);
    }
    RandomFacialAnimTime = RandomFacialMinTime;
    MountFacialAnimSets();
    CreateAndSetSonarMat();
}

native function SkeletalMeshComponent GetFaceFXSkelMeshComp()
{
}

defaultproperties
{
    bSonarActive=True
    SkeletalMeshComponent="Default__SkeletalMeshActor.SkeletalMeshComponent0"
    LightEnvironment="Default__SkeletalMeshActor.MyLightEnvironment"
    FacialAudioComp="Default__SkeletalMeshActor.FaceAudioComponent"
    RandomFacialAnimDeltaTime=10.0
    RandomFacialMinTime=20.0
    SpeechPitchMultiplier=1.0
    bNoDelete=True
    bProjTarget=True
    bNoEncroachCheck=True
    bEdShouldSnap=True
    Components(0)="Default__SkeletalMeshActor.MyLightEnvironment"
    Components(1)="Default__SkeletalMeshActor.SkeletalMeshComponent0"
    Components(2)="Default__SkeletalMeshActor.FaceAudioComponent"
    CollisionType="COLLIDE_CustomDefault"
    CollisionComponent="Default__SkeletalMeshActor.SkeletalMeshComponent0"
}

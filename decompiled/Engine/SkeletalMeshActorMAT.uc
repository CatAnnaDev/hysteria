class SkeletalMeshActorMAT extends SkeletalMeshCinematicActor
    native
    placeable
    hidecategories(Navigation);

struct CheckpointRecord
{
    var Vector Location;
    var Rotator Rotation;
    var ECollisionType CollisionType;
    var bool bHidden;
    var bool bIsShutdown;
    var bool bNeedsPositionReplication;
};

var(MATCheckPoint) bool bShouldSaveForCheckpoint;
var(MATCheckPoint) const bool bCheckpointSaveRotation;
var transient array<AnimNodeSlot> SlotNodes;

simulated exec event PlaySpeechGesture(name GestureAnim)
{
    if (SlotNodes.Length > 0)
    {
        SlotNodes[0].PlayCustomAnim(GestureAnim, 1.0);
    }
}

function ApplyCheckpointRecord(out const CheckpointRecord Record)
{
    local Actor OldBase;
    local SkeletalMeshComponent OldBaseComp;
    local name OldBaseBoneName;
    local array<Actor> OldAttached;
    local array<Vector> OldLocations;
    local int I;
    
    if (Record.bIsShutdown)
    {
        ShutDown();
    }
    else
    {
        OldAttached = Attached;
        while (I < OldAttached.Length)
        {
            if (OldAttached[I] != none && OldAttached[I].bJustTeleported)
            {
                OldLocations[I] = OldAttached[I].Location;
                I++;
                continue;
            }
            OldAttached.Remove(I, 1);
        }
        OldBase = Base;
        OldBaseComp = BaseSkelComponent;
        OldBaseBoneName = BaseBoneName;
        SetLocation(Record.Location);
        SetRotation(Record.Rotation);
        SetBase(OldBase, , OldBaseComp, OldBaseBoneName);
        for (I = 0; I < OldAttached.Length; I++)
        {
            if (OldAttached[I] != none)
            {
                OldAttached[I].SetLocation(OldLocations[I]);
                OldAttached[I].SetBase(self);
            }
        }
        if (Record.CollisionType != ReplicatedCollisionType)
        {
            SetCollisionType(Record.CollisionType);
            ForceNetRelevant();
        }
        if (Record.bHidden != bHidden)
        {
            SetHidden(Record.bHidden);
            SetForcedInitialReplicatedProperty(BoolProperty'Actor.bHidden', bHidden == default.bHidden);
            ForceNetRelevant();
        }
        if (Record.bNeedsPositionReplication)
        {
            bUpdateSimulatedPosition = true;
            bReplicateMovement = true;
            ForceNetRelevant();
        }
    }
    bShouldSaveForCheckpoint = true;
}

function CreateCheckpointRecord(out CheckpointRecord Record)
{
    Record.Location = Location;
    Record.Rotation = Rotation;
    Record.bHidden = bHidden;
    Record.CollisionType = ReplicatedCollisionType;
    Record.bNeedsPositionReplication = RemoteRole == 1 && bUpdateSimulatedPosition;
    Record.bIsShutdown = Physics == 0 && bHidden;
    LogInternal(" AliceCheckPoint Debug Info: save SkeletalMeshActorMAT name " @ string(self));
}

simulated event SetSkelControlScale(name SkelControlName, float Scale)
{
    MAT_SetSkelControlScale(SkelControlName, Scale);
}

simulated event SetMorphWeight(name MorphNodeName, float MorphWeight)
{
    MAT_SetMorphWeight(MorphNodeName, MorphWeight);
}

simulated event FinishAnimControl(InterpGroup InInterpGroup)
{
    MAT_FinishAnimControl(InInterpGroup);
}

native function MAT_SetAnimPosition(name SlotName, int ChannelIndex, name InAnimSeqName, float InPosition, bool bFireNotifies, bool bLooping, int RootMotionLevel)
{
    SlotName;
    ChannelIndex;
    InAnimSeqName;
    InPosition;
    bFireNotifies;
    bLooping;
    RootMotionLevel;
}

simulated event SetAnimPosition(name SlotName, int ChannelIndex, name InAnimSeqName, float InPosition, bool bFireNotifies, bool bLooping, int RootMotionLevel)
{
    MAT_SetAnimPosition(SlotName, ChannelIndex, InAnimSeqName, InPosition, bFireNotifies, bLooping, RootMotionLevel);
}

simulated function ClearAnimNodes()
{
    SlotNodes.Length = 0;
}

simulated function CacheAnimNodes()
{
    local AnimNodeSlot SlotNode;
    
    foreach SkeletalMeshComponent.AllAnimNodes(class'AnimNodeSlot', SlotNode)
    {
        SlotNodes[SlotNodes.Length] = SlotNode;
    }
}

simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
    PostInitAnimTree(SkelComp);
    ClearAnimNodes();
    CacheAnimNodes();
}

simulated event Destroyed()
{
    Destroyed();
    ClearAnimNodes();
}

native function MAT_SetSkelControlScale(name SkelControlName, float Scale)
{
    SkelControlName;
    Scale;
}

native function MAT_SetMorphWeight(name MorphNodeName, float MorphWeight)
{
    MorphNodeName;
    MorphWeight;
}

native function MAT_AutoReduceSlotAnimWeight(array<AnimSlotInfo> SlotInfos, float RevertTime)
{
    SlotInfos;
    RevertTime;
}

native function MAT_SetAnimWeights(array<AnimSlotInfo> SlotInfos)
{
    SlotInfos;
}

defaultproperties
{
    bShouldSaveForCheckpoint=True
    bCheckpointSaveRotation=True
    SkeletalMeshComponent="Default__SkeletalMeshActorMAT.SkeletalMeshComponent0"
    LightEnvironment="Default__SkeletalMeshActorMAT.MyLightEnvironment"
    FacialAudioComp="Default__SkeletalMeshActorMAT.FaceAudioComponent"
    Components(0)="Default__SkeletalMeshActorMAT.MyLightEnvironment"
    Components(1)="Default__SkeletalMeshActorMAT.SkeletalMeshComponent0"
    Components(2)="Default__SkeletalMeshActorMAT.FaceAudioComponent"
    CollisionComponent="Default__SkeletalMeshActorMAT.SkeletalMeshComponent0"
}

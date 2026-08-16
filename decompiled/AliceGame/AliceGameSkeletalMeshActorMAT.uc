class AliceGameSkeletalMeshActorMAT extends SkeletalMeshActorMAT
    native
    placeable
    hidecategories(Navigation);

var transient array<AliceGameAnimNode_BlendBySlot> AliceGameSlotNodes;

simulated exec event PlaySpeechGesture(name GestureAnim)
{
}

simulated event AudioComponent GetFaceFXAudioComponent()
{
    return none;
}

simulated function bool IsActorPlayingFaceFXAnim()
{
    return false;
}

simulated event FaceFXAsset GetActorFaceFXAsset()
{
    return none;
}

simulated function OnPlayFaceFXAnim(SeqAct_PlayFaceFXAnim inAction)
{
}

simulated event StopActorFaceFXAnim()
{
}

simulated event bool PlayActorFaceFXAnim(FaceFXAnimSet AnimSet, string GroupName, string SeqName, SoundCue SoundCueToPlay)
{
    return false;
}

simulated function ClearAnimNodes()
{
    SlotNodes.Length = 0;
    AliceGameSlotNodes.Length = 0;
}

simulated function CacheAnimNodes()
{
    local AliceGameAnimNode_BlendBySlot SlotNode;
    
    foreach SkeletalMeshComponent.AllAnimNodes(class'AliceGameAnimNode_BlendBySlot', SlotNode)
    {
        AliceGameSlotNodes[AliceGameSlotNodes.Length] = SlotNode;
    }
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

defaultproperties
{
    SkeletalMeshComponent="Default__AliceGameSkeletalMeshActorMAT.SkeletalMeshComponent0"
    LightEnvironment="Default__AliceGameSkeletalMeshActorMAT.MyLightEnvironment"
    FacialAudioComp="Default__AliceGameSkeletalMeshActorMAT.FaceAudioComponent"
    bHidden=True
    Components(0)="Default__AliceGameSkeletalMeshActorMAT.MyLightEnvironment"
    Components(1)="Default__AliceGameSkeletalMeshActorMAT.SkeletalMeshComponent0"
    Components(2)="Default__AliceGameSkeletalMeshActorMAT.FaceAudioComponent"
    Physics="PHYS_Interpolating"
    CollisionComponent="Default__AliceGameSkeletalMeshActorMAT.SkeletalMeshComponent0"
}

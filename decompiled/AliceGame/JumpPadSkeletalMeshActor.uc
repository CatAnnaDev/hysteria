class JumpPadSkeletalMeshActor extends SkeletalMeshActor
    notplaceable
    hidecategories(Navigation);

var export editinline SkeletalMeshComponent SkelMeshComp;
var export editinline AudioComponent CatAudioComponent;
var AnimNodeSlot SlotNode;

event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
    OnAnimEnd(SeqNode, PlayedTime, ExcessTime);
}

function PlayAnim(name AnimName, optional float Rate, optional bool bLoop, optional int nActiveNumber, optional bool bRestartIfAlreadyPlaying = true)
{
    local AnimNodeSequence AnimNode;
    local AnimNodeBlendList AnimNBL;
    
    AnimNode = AnimNodeSequence(SkelMeshComp.Animations);
    if (AnimNode == none && SkelMeshComp.Animations.IsA('AnimTree'))
    {
        AnimNode = AnimNodeSequence(AnimTree(SkelMeshComp.Animations).Children[0].Anim);
    }
    if (AnimNode == none)
    {
        AnimNBL = AnimNodeBlendList(AnimTree(SkelMeshComp.Animations).Children[0].Anim);
        if (AnimNBL != none)
        {
            AnimNode = AnimNodeSequence(AnimNBL.Children[0].Anim);
            AnimNBL.SetActiveChild(nActiveNumber, 0.8);
        }
    }
    if (AnimNode == none)
    {
        WarnInternal("Base animation node is not an AnimNodeSequence (Owner:" @ string(Owner) $ ")");
    }
    else if (AnimNode.AnimSeq != none && AnimNode.AnimSeq.SequenceName == AnimName)
    {
        Rate = (Rate > 0.0 ? Rate : 1.0);
        if (bRestartIfAlreadyPlaying || !AnimNode.bPlaying)
        {
            AnimNode.PlayAnim(bLoop, Rate);
            AnimNode.bCauseActorAnimEnd = true;
            AnimNode.bCauseActorAnimPlay = true;
        }
        else
        {
            AnimNode.Rate = Rate;
            AnimNode.bLooping = bLoop;
        }
    }
    else
    {
        AnimNode.SetAnim(AnimName);
        if (AnimNode.AnimSeq != none)
        {
            Rate = (Rate > 0.0 ? Rate : 1.0);
            AnimNode.PlayAnim(bLoop, Rate);
        }
    }
}

function bool IsPlayingAnimation()
{
    if (IsActorPlayingFaceFXAnim() || SlotNode.bIsPlayingCustomAnim)
    {
        return true;
    }
    else
    {
        return false;
    }
}

function AnimNodeSlot GetAnimNodeSlot()
{
    local AnimNodeSlot SNode;
    
    if (SkeletalMeshComponent.Animations.IsA('AnimTree'))
    {
        SNode = AnimNodeSlot(AnimTree(SkeletalMeshComponent.Animations).Children[0].Anim);
    }
    if (SNode == none)
    {
        WarnInternal("Can't Find the slot Node");
    }
    return SNode;
}

function float PlayCustomAnim(name AnimName, float Rate, optional float BlendInTime, optional float BlendOutTime, optional bool bLooping, optional bool bOverride)
{
    return SlotNode.PlayCustomAnim(AnimName, Rate, BlendInTime, BlendOutTime, bLooping, bOverride);
}

simulated event PostBeginPlay()
{
    PostBeginPlay();
}

defaultproperties
{
    CatAudioComponent="Default__JumpPadSkeletalMeshActor.AC"
    SkeletalMeshComponent="Default__JumpPadSkeletalMeshActor.SkeletalMeshComponent0"
    LightEnvironment="Default__JumpPadSkeletalMeshActor.MyLightEnvironment"
    FacialAudioComp="Default__JumpPadSkeletalMeshActor.FaceAudioComponent"
    bNoDelete=False
    Components(0)="Default__JumpPadSkeletalMeshActor.MyLightEnvironment"
    Components(1)="Default__JumpPadSkeletalMeshActor.SkeletalMeshComponent0"
    Components(2)="Default__JumpPadSkeletalMeshActor.FaceAudioComponent"
    Components(3)="Default__JumpPadSkeletalMeshActor.AC"
    CollisionComponent="Default__JumpPadSkeletalMeshActor.SkeletalMeshComponent0"
}

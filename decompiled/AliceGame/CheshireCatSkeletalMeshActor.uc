class CheshireCatSkeletalMeshActor extends SkeletalMeshActor
    placeable
    hidecategories(Navigation);

var export editinline SkeletalMeshComponent CatBodyMesh;
var export editinline AudioComponent CatAudioComponent;
var AnimNodeSlot SlotNode;
var name MorphNodeName;
var float FadeInTime;
var float FadeOutTime;

function MorphOut()
{
    StartMorphing(MorphNodeName, 0.0, 1.0, FadeOutTime);
}

function MorphIn()
{
    StartMorphing(MorphNodeName, 1.0, 0.0, FadeInTime);
}

function DisableAllSkelControl()
{
    local int I;
    
    for (I = 0; I < ControlTargets.Length; I++)
    {
        SetSkelControlEnable(ControlTargets[I].ControlName, false);
    }
}

function SetSkelControlEnable(name SkelName, bool bEnable)
{
    local SkelControlLookAt LookAtControl;
    
    LookAtControl = SkelControlLookAt(SkeletalMeshComponent.FindSkelControl(SkelName));
    if (LookAtControl != none)
    {
        if (bEnable)
        {
            LookAtControl.SetSkelControlStrength(1.0, 1.0);
        }
        else
        {
            LookAtControl.SetSkelControlStrength(0.0, 1.0);
        }
    }
}

function Disappear()
{
    DisableAllSkelControl();
    StopActorFaceFXAnim();
    CatAudioComponent.Stop();
    SlotNode.StopCustomAnim(0.1);
    SetHidden(true);
}

function SetLookAtTarget(name SkelControlName, Actor TargetActor)
{
    local int I;
    
    if (SkelControlName == 'None' || TargetActor == none)
    {
        return;
    }
    for (I = 0; I < ControlTargets.Length; I++)
    {
        if (ControlTargets[I].ControlName == SkelControlName)
        {
            SetSkelControlEnable(SkelControlName, true);
            ControlTargets[I].TargetActor = TargetActor;
            return;
        }
    }
    ControlTargets.Length = ControlTargets.Length + 1;
    ControlTargets[ControlTargets.Length - 1].ControlName = SkelControlName;
    ControlTargets[ControlTargets.Length - 1].TargetActor = TargetActor;
    SetSkelControlEnable(SkelControlName, true);
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
    CatBodyMesh.SetParentAnimComponent(SkeletalMeshComponent);
    SlotNode = GetAnimNodeSlot();
}

defaultproperties
{
    CatBodyMesh="Default__CheshireCatSkeletalMeshActor.SkeletalMeshCatBody"
    CatAudioComponent="Default__CheshireCatSkeletalMeshActor.AC"
    MorphNodeName="FadeMorph"
    FadeInTime=1.5
    FadeOutTime=1.5
    SkeletalMeshComponent="Default__CheshireCatSkeletalMeshActor.SkeletalMeshComponent1"
    LightEnvironment="Default__CheshireCatSkeletalMeshActor.MyLightEnvironment"
    FacialAudioComp="Default__CheshireCatSkeletalMeshActor.FaceAudioComponent"
    bHidden=True
    bNoDelete=False
    Components(0)="Default__CheshireCatSkeletalMeshActor.MyLightEnvironment"
    Components(1)="Default__CheshireCatSkeletalMeshActor.FaceAudioComponent"
    Components(2)="Default__CheshireCatSkeletalMeshActor.SkeletalMeshCatBody"
    Components(3)="Default__CheshireCatSkeletalMeshActor.SkeletalMeshComponent1"
    Components(4)="Default__CheshireCatSkeletalMeshActor.AC"
    CollisionComponent="Default__CheshireCatSkeletalMeshActor.SkeletalMeshComponent1"
}

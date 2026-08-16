class JumpPadPhysics extends JumpPad
    native
    placeable
    hidecategories(Navigation,Lighting,LightColor,Force);

struct native JumpPadAnimation
{
    var() name Name;
    var() float Time;
    var() float Rate;
};

var JumpPadSkeletalMeshActor JumpPadSkelActor;
var AliceGamePawn P;
var(Light) const export editconst editinline LightEnvironmentComponent LightEnvironmentJumpPad;
var() interp Vector ZoneVelocity;
var() float TerminalVelocity;
var() float RotationSpeed;
var(Animation) export editinline SkeletalMeshComponent SkelMeshComp;
var(Animation) JumpPadAnimation CompressAnimation;
var(Animation) JumpPadAnimation IdleCompressedAnimation;
var(Animation) JumpPadAnimation LaunchAnimation;
var bool bEnable;
var bool bSonarActor;

simulated event Destroyed()
{
    Destroyed();
    if (bSonarActor)
    {
        WorldInfo.GetLocalPlayerPawn().Controller.RemoveSonarDetectedActor(self);
    }
}

function OnPlayIdleAnimation()
{
    JumpPadSkelActor.PlayAnim(IdleCompressedAnimation.Name, IdleCompressedAnimation.Rate, false);
}

function OnLaunchAnimOverTimer()
{
    TurnOffCollision();
    P.PendingVelocity.X = 1.0;
    P.PendingVelocity.Y = 1.0;
    P.PendingVelocity.Z = 1.0;
    P.SetPhysics(17);
    P.DoSpecialMove(50, true);
    P.Velocity = ZoneVelocity;
    if (WorldInfo.WorldGravityZ != WorldInfo.DefaultGravityZ && P.GetGravityZ() == WorldInfo.WorldGravityZ)
    {
        P.Velocity *= Sqrt(P.GetGravityZ() / WorldInfo.DefaultGravityZ);
    }
    P.Acceleration = vect(0.0, 0.0, 0.0);
    if (JumpSound != none)
    {
        P.PlaySound(JumpSound);
    }
    if (SkelMeshComp != none)
    {
        SetTimer(1.0, false, 'OnPlayIdleAnimation');
    }
}

function PlayLaunchAnimation()
{
    local float animTime;
    
    if (IsAnimationValid(LaunchAnimation))
    {
        JumpPadSkelActor.PlayAnim(LaunchAnimation.Name, LaunchAnimation.Rate, false, 2);
        animTime = JumpPadSkelActor.SkelMeshComp.GetAnimLength(LaunchAnimation.Name);
        SetTimer(animTime + LaunchAnimation.Time, false, 'OnLaunchAnimOverTimer');
    }
}

function bool IsAnimationValid(JumpPadAnimation Animation)
{
    if (JumpPadSkelActor.SkelMeshComp == none || Animation.Name == 'None' || JumpPadSkelActor.SkelMeshComp.FindAnimSequence(Animation.Name) == none)
    {
        return false;
    }
    else
    {
        return true;
    }
}

simulated event OnToggleJumpPadPhysics(SeqAct_ToggleJumpPadPhysics Action)
{
    if (Action.InputLinks[0].bHasImpulse)
    {
        bEnable = true;
    }
    else if (Action.InputLinks[1].bHasImpulse)
    {
        bEnable = false;
    }
    else if (Action.InputLinks[2].bHasImpulse)
    {
        bEnable = !bEnable;
    }
}

function TurnOnCollision()
{
    SetCollisionType(2);
}

function TurnOffCollision()
{
    CollisionComponent.SetActorCollision(false, false, false);
}

function AliceWalkOnMushroom(Actor Other)
{
    P = AliceGamePawn(Other);
    if (P == none || P.Physics == 0 || P.DrivenVehicle != none || !bEnable || P.Controller.IsInState('PlayerJumpPad'))
    {
        return;
    }
    if (P.Location.Z > Location.Z)
    {
        P.JumpPad = self;
        AlicePlayerController(P.Controller).LockOnModeDeactivated();
        P.Controller.GotoState('PlayerJumpPad');
        AlicePlayerController(P.Controller).AliceShadowModePos_X = P.Location.X;
        P.SetPhysics(2);
        PlayLaunchAnimation();
        AlicePlayerController(P.Controller).CycleFloatManager.jumpPadInit();
        AlicePawn(P).DiscardWatch();
    }
    else
    {
        SetCollisionType(1);
        SetTimer(1.0, false, 'TurnOnCollision');
    }
}

event Attach(Actor Other)
{
    Attach(Other);
    AliceWalkOnMushroom(Other);
}

function setSonarActor(bool bIsSonar)
{
    bSonarActor = bIsSonar;
}

function CreateAndSetSonarMat()
{
    local int ElementIndex;
    local MaterialInstanceConstant MatInst, newInstance;
    
    if (SkelMeshComp == none)
    {
        return;
    }
    for (ElementIndex = 0; ElementIndex < SkelMeshComp.GetNumElements(); ElementIndex++)
    {
        MatInst = MaterialInstanceConstant(SkelMeshComp.GetMaterial(ElementIndex));
        if (MatInst != none && MatInst.bSonarMaterial)
        {
            newInstance = new(self) class'Engine.MaterialInstanceConstant';
            newInstance.SetParent(MatInst.Parent);
            newInstance.initSonarParam(MatInst);
            SkelMeshComp.SetMaterial(ElementIndex, newInstance);
            setSonarActor(true);
            WorldInfo.GetLocalPlayerPawn().Controller.AddSonarDetectedActor(self);
        }
    }
}

simulated event PostBeginPlay()
{
    PostBeginPlay();
    if (JumpPadSkelActor == none)
    {
        JumpPadSkelActor = Spawn(class'JumpPadSkeletalMeshActor', self);
        if (SkelMeshComp != none)
        {
            JumpPadSkelActor.SkelMeshComp = SkelMeshComp;
        }
    }
    CreateAndSetSonarMat();
}

defaultproperties
{
    LightEnvironmentJumpPad="Default__JumpPadPhysics.MyLightEnvironment"
    ZoneVelocity=(X=0.0,Y=0.0,Z=1000.0)
    TerminalVelocity=3500.0
    RotationSpeed=1000.0
    SkelMeshComp="Default__JumpPadPhysics.SkeletalMeshCatBody"
    CompressAnimation=(Name="GloryJumpPad_ready",Time=0.0,Rate=1.0)
    IdleCompressedAnimation=(Name="GloryJumpPad_ready",Time=2.0,Rate=1.0)
    LaunchAnimation=(Name="GloryJumpPad_Launch",Time=-0.8,Rate=1.0)
    bEnable=True
    bSpecialMove=True
    CylinderComponent="Default__JumpPadPhysics.CollisionCylinder"
    GoodSprite="Default__JumpPadPhysics.Sprite"
    BadSprite="Default__JumpPadPhysics.Sprite2"
    bStatic=False
    bCollideActors=True
    bBlockActors=True
    Components(0)="Default__JumpPadPhysics.Sprite"
    Components(1)="Default__JumpPadPhysics.Sprite2"
    Components(2)="Default__JumpPadPhysics.Arrow"
    Components(3)="Default__JumpPadPhysics.CollisionCylinder"
    Components(4)="Default__JumpPadPhysics.PathRenderer"
    Components(5)="Default__JumpPadPhysics.MyLightEnvironment"
    Components(6)="Default__JumpPadPhysics.SkeletalMeshCatBody"
    CollisionType="COLLIDE_BlockAll"
    CollisionComponent="Default__JumpPadPhysics.CollisionCylinder"
}

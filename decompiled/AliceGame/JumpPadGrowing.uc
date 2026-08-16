class JumpPadGrowing extends JumpPadPhysics
    native
    placeable
    hidecategories(Navigation,Lighting,LightColor,Force);

struct CheckpointRecord
{
    var string initMostOutName;
    var string initActorFName;
    var bool bEnableRadiusCheck;
    var bool bEnable;
};

var() float ActiveRadius;
var export editinline DecalComponent Decal;
var() export editinline StaticMeshComponent BaseMesh;
var() MaterialInterface DecalMaterial;
var() float DecalWidth;
var() float DecalHeight;
var() bool bEnableRadiusCheck;
var(Animation) JumpPadAnimation GrowingAnimation;
var(Animation) JumpPadAnimation UnderGroundAnimation;
var MaterialInstanceTimeVarying MITV_Decal;
var() editinline ForceFeedbackWaveform JumpPadWaveForm;
var transient string initMostOutName;
var transient string initActorFName;

event Tick(float DeltaTime)
{
    if (IsAliceAboveMushroom())
    {
        AliceWalkOnMushroom(WorldInfo.GetLocalPlayerPawn());
    }
    if (bEnableRadiusCheck)
    {
        ActiveRadiusCheck();
    }
    Tick(DeltaTime);
}

function ActiveRadiusCheck()
{
    local Vector AliceLocation;
    local float Distance;
    
    AliceLocation = WorldInfo.GetLocalPlayerPawn().Location;
    Distance = VSize(Location - AliceLocation);
    if (Distance < ActiveRadius)
    {
        PlayGrowingAnimation();
    }
}

function bool IsAliceAboveMushroom()
{
    local Vector HitLocation, HitNormal, TraceEnd, TraceStart, Extent;
    local Actor HitActor;
    
    if (CollisionComponent != none)
    {
        Extent = CollisionComponent.Bounds.BoxExtent;
        Extent.Z = 1.0;
    }
    TraceStart = Location;
    TraceEnd = TraceStart + vect(0.0, 0.0, 100.0);
    HitActor = Trace(HitLocation, HitNormal, TraceEnd, TraceStart, , Extent);
    if (AlicePawn(HitActor) != none)
    {
        return true;
    }
    return false;
}

simulated event OnToggleJumpPadRadiusCheck(SeqAct_ToggleJumpPadRadiusCheck Action)
{
    if (Action.InputLinks[0].bHasImpulse)
    {
        bEnableRadiusCheck = true;
    }
    else if (Action.InputLinks[1].bHasImpulse)
    {
        bEnableRadiusCheck = false;
    }
    else if (Action.InputLinks[2].bHasImpulse)
    {
        bEnableRadiusCheck = !bEnableRadiusCheck;
    }
    bEnable = bEnableRadiusCheck;
    AliceCheckPointManager(WorldInfo.Game.MyCheckPointManager).UpdateRegisterWhenChange(self, initMostOutName, initActorFName);
}

simulated event OnJumpPadGrowing(SeqAct_JumpPadGrowing Action)
{
    if (Action.InputLinks[0].bHasImpulse)
    {
        PlayGrowingAnimation();
    }
}

function OnPlayIdleAnimation()
{
    local float animTime;
    
    OnPlayIdleAnimation();
    animTime = JumpPadSkelActor.SkelMeshComp.GetAnimLength(IdleCompressedAnimation.Name);
    SetTimer(animTime + 0.05, false, 'UpdateDecal');
    SetTimer(animTime + 0.1, false, 'UpdateDecal');
}

function OnLaunchAnimOverTimer()
{
    OnLaunchAnimOverTimer();
    UpdateDecal();
}

function PlayLaunchAnimation()
{
    PlayLaunchAnimation();
    UpdateDecal();
    AlicePlayerController(WorldInfo.GetLocalPlayerPawn().Controller).ClientPlayForceFeedbackWaveform(JumpPadWaveForm);
}

function GrowingAnimationOver()
{
    TurnOnCollision();
    UpdateDecal();
}

function PlayGrowingAnimation()
{
    local float animTime;
    
    bEnable = true;
    AliceCheckPointManager(WorldInfo.Game.MyCheckPointManager).UpdateRegisterWhenChange(self, initMostOutName, initActorFName);
    bEnableRadiusCheck = false;
    TurnOnCollision();
    if (IsAnimationValid(GrowingAnimation))
    {
        JumpPadSkelActor.PlayAnim(GrowingAnimation.Name, GrowingAnimation.Rate, false, 2);
        animTime = JumpPadSkelActor.SkelMeshComp.GetAnimLength(GrowingAnimation.Name);
        SetTimer(animTime + GrowingAnimation.Time, false, 'GrowingAnimationOver');
    }
}

function PlayUnderGroundAnimation()
{
    JumpPadSkelActor.PlayAnim(UnderGroundAnimation.Name, UnderGroundAnimation.Rate);
}

function TurnOnCollision()
{
}

function TurnOffCollision()
{
}

function UpdateDecal()
{
    if (Decal != none)
    {
        Decal.SetDecalMaterial(MITV_Decal);
    }
}

function CreateDecal(Vector HitLocation, Vector HitNormal)
{
    MITV_Decal = new(none) class'Engine.MaterialInstanceTimeVarying';
    MITV_Decal.SetParent(DecalMaterial);
    Decal = WorldInfo.MyDecalManager.SpawnDecal(DecalMaterial, HitLocation, rotator(-HitNormal), DecalWidth, DecalHeight, 100.0, true, , , , , , , , 1000000000.0);
}

simulated event PostBeginPlay()
{
    PostBeginPlay();
    PlayUnderGroundAnimation();
    CreateDecal(Location, vect(0.0, 0.0, 1000.0));
    if (!bEnableRadiusCheck)
    {
        bEnable = false;
    }
    AliceCheckPointManager(WorldInfo.Game.MyCheckPointManager).RegisterWhenPostBeginPlay(self);
}

event UpdateAfterAcceptPersistentDate()
{
    if (bEnable && !bEnableRadiusCheck)
    {
        PlayGrowingAnimation();
    }
}

function ApplyCheckpointRecord(out const CheckpointRecord Record)
{
    AliceCheckPointManager(WorldInfo.Game.MyCheckPointManager).UnRegisterWhenApplyRecord(self, initMostOutName, initActorFName);
    bEnable = Record.bEnable;
    bEnableRadiusCheck = Record.bEnableRadiusCheck;
    initActorFName = Record.initActorFName;
    initMostOutName = Record.initMostOutName;
    AliceCheckPointManager(WorldInfo.Game.MyCheckPointManager).RegisterWhenApplyRecord(self, initMostOutName, initActorFName);
    if (bEnable && !bEnableRadiusCheck)
    {
        PlayGrowingAnimation();
    }
}

function CreateCheckpointRecord(out CheckpointRecord Record)
{
    Record.bEnableRadiusCheck = bEnableRadiusCheck;
    Record.bEnable = bEnable;
    Record.initActorFName = initActorFName;
    Record.initMostOutName = initMostOutName;
}

function bool ShouldSaveForCheckpoint()
{
    return true;
}

defaultproperties
{
    ActiveRadius=1000.0
    BaseMesh="Default__JumpPadGrowing.StaticMeshComponent2"
    DecalWidth=1000.0
    DecalHeight=1000.0
    bEnableRadiusCheck=True
    GrowingAnimation=(Name="GrowingJumpPad_Ground",Time=0.0,Rate=1.0)
    UnderGroundAnimation=(Name="GrowingJumpPad_UnderGround",Time=0.0,Rate=1.0)
    JumpPadWaveForm="Default__JumpPadGrowing.ForceFeedbackWaveformShooting1"
    LightEnvironmentJumpPad="Default__JumpPadGrowing.MyLightEnvironment"
    ZoneVelocity=(X=0.0,Y=0.0,Z=2000.0)
    SkelMeshComp="Default__JumpPadGrowing.SkeletalMeshCatBody"
    IdleCompressedAnimation=(Name="GlowingJumpPad_ready")
    LaunchAnimation=(Name="GrowingJumpPad_Launch")
    CylinderComponent="Default__JumpPadGrowing.CollisionCylinder"
    GoodSprite="Default__JumpPadGrowing.Sprite"
    BadSprite="Default__JumpPadGrowing.Sprite2"
    bWorldGeometry=True
    Components(0)="Default__JumpPadGrowing.Sprite"
    Components(1)="Default__JumpPadGrowing.Sprite2"
    Components(2)="Default__JumpPadGrowing.Arrow"
    Components(3)="Default__JumpPadGrowing.CollisionCylinder"
    Components(4)="Default__JumpPadGrowing.PathRenderer"
    Components(5)="Default__JumpPadGrowing.MyLightEnvironment"
    Components(6)="Default__JumpPadGrowing.SkeletalMeshCatBody"
    Components(7)="Default__JumpPadGrowing.StaticMeshComponent2"
    CollisionComponent="Default__JumpPadGrowing.CollisionCylinder"
}

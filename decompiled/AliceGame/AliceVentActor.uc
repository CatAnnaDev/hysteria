class AliceVentActor extends Actor
    native
    placeable
    hidecategories(Navigation);

struct CheckpointRecord
{
    var string initMostOutName;
    var string initActorFName;
    var bool bEnabled;
    var bool bInitHideSet;
    var Vector Location;
    var Rotator Rotation;
};

var(Component) export editconst editinline CylinderComponent hoverVolumeComponent;
var(Component) export editconst editinline CylinderComponent steamVolumecomponent;
var(Component) const export editconst editinline StaticMeshComponent BaseMeshComponent;
var(Component) const export editconst editinline DynamicLightEnvironmentComponent LightEnvironment;
var(Component) const export editconst editinline ParticleSystemComponent ventParticleSystemComponent;
var(Component) export editinline AudioComponent soundComponent;
var(SteamVolume) float steamVelocityZ;
var(SteamVolume) Vector steamForce;
var(SteamVolume) Vector steamPerturbAmplitude;
var(SteamVolume) float steamDamping;
var(SteamVolume) float horizonVelDecDuration;
var(HoverVolume) Vector hoverForce;
var(HoverVolume) Vector hoverPerturbAmplitude;
var(HoverVolume) float hoverDamping;
var(HoverVolume) float hoverForwardSpeed;
var(HoverVolume) float hoverStrafeSpeed;
var(HoverVolume) float hoverRotationSpeed;
var float HoverDuration;
var float PawnEnterZSpeed;
var float AccumHoverDelay;
var float HoverDelayTime;
var float DelayCameraTimeWhenLeave;
var(HoverVolume) float HoverAmplitude;
var(HoverVolume) float HoverCycleTime;
var(HoverVolume) float HoverDist;
var(Particles) ParticleSystem ventCatchPS;
var(Particles) ParticleSystem ventIdlePS;
var(Particles) ParticleSystem ventJumpPS;
var Emitter ventIdleEmitter;
var AlicePlayerController APC;
var bool bShowDebugInfo;
var bool lastTickInSteam;
var bool lastTickInHover;
var bool bPreHover;
var bool bHovering;
var bool bAlreadyPlayedCatchPS;
var(State) bool bEnabled;
var bool bLastTickEnable;
var bool bInitHideSet;
var transient string initMostOutName;
var transient string initActorFName;
var float lastAliceZ;

function Update(float DeltaTime, AlicePlayerController aliceController)
{
}

function onAliceJump()
{
    local Emitter jumpEmitter;
    
    if (isAliceInCylinder(hoverVolumeComponent))
    {
        jumpEmitter = Spawn(class'Engine.EmitterSpawnable', self, , APC.Pawn.Location);
        if (jumpEmitter != none && ventJumpPS != none)
        {
            jumpEmitter.SetTemplate(ventJumpPS, true);
        }
    }
}

function tickParticles(float DeltaTime)
{
    ventIdleEmitter.SetLocation(APC.Pawn.Location);
}

function playIdleParticle(bool bEnable)
{
    bEnable ? ventIdleEmitter.ParticleSystemComponent.ActivateSystem() : ventIdleEmitter.ParticleSystemComponent.DeactivateSystem();
}

function playCatchParticle()
{
    local Emitter catchEmitter;
    
    if (!bAlreadyPlayedCatchPS && APC.Pawn.Velocity.Z > 0.0)
    {
        bAlreadyPlayedCatchPS = true;
        catchEmitter = Spawn(class'Engine.EmitterSpawnable', self, , APC.Pawn.Location);
        if (catchEmitter != none && ventCatchPS != none)
        {
            catchEmitter.SetTemplate(ventCatchPS, true);
        }
    }
}

function GetAlicePlayerController()
{
    local AlicePlayerController PC;
    
    if (APC != none)
    {
        return;
    }
    foreach WorldInfo.LocalPlayerControllers(class'AlicePlayerController', PC)
    {
        if (PC != none)
        {
            APC = PC;
            return;
        }
    }
}

function drawCylinderComponentInGame(CylinderComponent cylinderComp)
{
    local Vector Start, End;
    local float Radius;
    local int Segments;
    
    Start = cylinderComp.GetPosition();
    Start.Z += -cylinderComp.CollisionHeight;
    End = Start;
    End.Z += cylinderComp.CollisionHeight * 2.0;
    DrawDebugLine(Start, Start + vect(200.0, 0.0, 0.0), 255, 0, 0);
    DrawDebugLine(End, End + vect(200.0, 0.0, 0.0), 255, 0, 0);
    Radius = cylinderComp.CollisionRadius;
    Segments = 10;
    DrawDebugCylinder(Start, End, Radius, Segments, 0, 255, 0);
}

function drawDebugInfo()
{
    if (!APC.isShowVentCylinder())
    {
        return;
    }
    drawCylinderComponentInGame(steamVolumecomponent);
    drawCylinderComponentInGame(hoverVolumeComponent);
}

function bool isAliceInCylinder(CylinderComponent cylinderComp)
{
    local Vector cylinderCenter, Dist, dist2D;
    
    if (APC == none)
    {
        return false;
    }
    cylinderCenter = cylinderComp.GetPosition();
    Dist = APC.Pawn.Location - cylinderCenter;
    dist2D = Dist;
    dist2D.Z = 0.0;
    if (Abs(Dist.Z) < cylinderComp.CollisionHeight && VSize(dist2D) < cylinderComp.CollisionRadius)
    {
        return true;
    }
    return false;
}

function ApplyWind(Actor Actor)
{
    local HairComponent HairComponent;
    local ClothComponent ClothComponent;
    
    foreach Actor.AllOwnedComponents(class'Engine.HairComponent', HairComponent)
    {
        HairComponent.Force += hoverForce;
        HairComponent.Damping += hoverDamping;
        HairComponent.PerturbAmplitude += hoverPerturbAmplitude;
    }
    foreach Actor.AllOwnedComponents(class'Engine.ClothComponent', ClothComponent)
    {
        ClothComponent.Force += hoverForce;
        ClothComponent.Damping += hoverDamping;
        ClothComponent.PerturbAmplitude += hoverPerturbAmplitude;
    }
}

function GetCylinderGeometryInfo(CylinderComponent cylinderComp, out float heightMin, out float heightMax)
{
    local Vector vCenter;
    
    vCenter = cylinderComp.GetPosition();
    heightMin = vCenter.Z - cylinderComp.CollisionHeight;
    heightMax = heightMin + cylinderComp.CollisionHeight * 2.0;
}

function float GetHoverZSpeed(AlicePawn Pawn, float DeltaTime)
{
    local float ZSpeed, Accel, Angle;
    
    if (bPreHover)
    {
        ZSpeed = Pawn.Velocity.Z;
        Accel = -(PawnEnterZSpeed * PawnEnterZSpeed) / (2.0 * HoverDist) * DeltaTime;
        ZSpeed += Accel;
        if (ZSpeed <= 0.0)
        {
            bPreHover = false;
            bHovering = true;
        }
        HoverDuration = 0.0;
    }
    else if (bHovering)
    {
        HoverDuration += DeltaTime;
        Angle = 2.0 * 3.1415927 * HoverDuration / HoverCycleTime;
        ZSpeed = HoverAmplitude * Sin(Angle) * float(-1);
    }
    return ZSpeed;
}

function Vector GetAdjustVelocity(AlicePawn Pawn, float DeltaTime)
{
    local Vector NewVelocity;
    
    NewVelocity = Pawn.Velocity;
    NewVelocity.Z = GetHoverZSpeed(Pawn, DeltaTime);
    return NewVelocity;
}

function Vector GetAccel(AlicePawn Pawn)
{
    return Pawn.Acceleration;
}

function bool IsEnterFromBottom()
{
    local bool bResult;
    
    bResult = APC.Pawn.Velocity.Z > float(100) && APC.Pawn.Location.Z > lastAliceZ;
    return bResult;
}

function aliceLeaveHoverVolume()
{
    APC.ClientMessage("=== Leave Hover ===");
    if (!APC.IsInState('PlayerFloat'))
    {
        APC.GotoState('PlayerWalking');
        APC.MyAlicePawn.SetPhysics(2);
    }
    APC.MyAlicePawn.SkirtComponent.RadialForceMagnitude = 0.0;
    if (APC.ventActor != none)
    {
        APC.bDelayCameraInSteam = true;
        APC.SetTimer(DelayCameraTimeWhenLeave, false, 'ResetDelayCameraTime');
        APC.ventActor = none;
    }
    HoverDuration = 0.0;
    bPreHover = false;
    bHovering = false;
    APC.MyAlicePawn.bJustLeaveHover = true;
    if (!APC.MyAlicePawn.IsDoingSpecialMove(64))
    {
        APC.MyAlicePawn.bAfterHoverJump = false;
    }
}

function aliceEnterHoverVolume()
{
    APC.ClientMessage("=== Enter Hover ===");
    if (APC.bInFloatVolume)
    {
        aliceLeaveSteamVolume();
    }
    if (IsEnterFromBottom())
    {
        bPreHover = true;
        APC.ventActor = self;
        APC.MyAlicePawn.SetPhysics(20);
        APC.MyAlicePawn.TriggerDressPhysic(true, 1.0);
        APC.GotoState('PlayerSteamVent');
        PawnEnterZSpeed = APC.MyAlicePawn.Velocity.Z;
        APC.MyAlicePawn.bFloatAfterHover = false;
        APC.MyAlicePawn.bIsJumping = false;
        APC.MyAlicePawn.bAfterHoverJump = false;
        APC.MyAlicePawn.bJustLeaveSteam = false;
        APC.CycleFloatManager.Init();
        playIdleParticle(true);
        LogInternal("======== Enter Hover VelocityZ: " $ string(PawnEnterZSpeed) $ "========");
    }
}

function aliceLeaveSteamVolume()
{
    APC.ClientMessage("=== Leave Steam ===");
    bAlreadyPlayedCatchPS = false;
    APC.bInFloatVolume = false;
    APC.GotoState('PlayerWalking');
    APC.MyAlicePawn.DoSpecialMove(3, true);
    APC.MyAlicePawn.TriggerContextEventClass(6, 1);
    APC.MyAlicePawn.bIsJumping = false;
    APC.MyAlicePawn.bJustLeaveSteam = true;
}

function aliceEnterSteamVolume()
{
    APC.ClientMessage("=== Enter Steam ===");
    APC.bInFloatVolume = true;
    APC.GotoState('PlayerWalking');
    APC.Pawn.SetPhysics(2);
    APC.MyAlicePawn.DoSpecialMove(57, true);
    APC.MyAlicePawn.TriggerContextEventClass(6, 0);
    APC.MyAlicePawn.bIsDoubleJumping = false;
    APC.MyAlicePawn.bAfterHoverJump = false;
    APC.MyAlicePawn.bFloatDown = false;
    APC.CycleFloatManager.bDisableAfterLanded = true;
    APC.CycleFloatManager.indicatorManager.stopEffect();
}

function tickHoverVolume(float DeltaTime)
{
    local bool curretnTickInHover;
    
    curretnTickInHover = isAliceInCylinder(hoverVolumeComponent);
    if (curretnTickInHover)
    {
        if (!lastTickInHover)
        {
            aliceEnterHoverVolume();
        }
        if (APC.isShowVentCylinder())
        {
            DrawDebugSphere(APC.Pawn.Location, 90.0, 10, 255, 0, 255);
        }
    }
    else if (lastTickInHover)
    {
        aliceLeaveHoverVolume();
    }
    lastTickInHover = curretnTickInHover;
}

function tickSteamVolume(float DeltaTime)
{
    local bool curretnTickInSteam;
    local float horizonXAccel, horizonYAccel;
    
    curretnTickInSteam = isAliceInCylinder(steamVolumecomponent);
    if (curretnTickInSteam)
    {
        if (!lastTickInSteam)
        {
            aliceEnterSteamVolume();
        }
        APC.Pawn.Velocity.Z += steamVelocityZ * (DeltaTime * float(30));
        horizonXAccel = (0.0 - APC.Pawn.Velocity.X) / horizonVelDecDuration * DeltaTime;
        horizonYAccel = (0.0 - APC.Pawn.Velocity.Y) / horizonVelDecDuration * DeltaTime;
        APC.Pawn.Velocity.X += horizonXAccel;
        APC.Pawn.Velocity.Y += horizonYAccel;
        playCatchParticle();
        if (APC.isShowVentCylinder())
        {
            DrawDebugSphere(APC.Pawn.Location, 90.0, 10, 128, 255, 0);
        }
    }
    else if (lastTickInSteam)
    {
        aliceLeaveSteamVolume();
    }
    lastTickInSteam = curretnTickInSteam;
}

function DeactivateVent()
{
    soundComponent.Stop();
    ventParticleSystemComponent.DeactivateSystem();
    if (isAliceInCylinder(hoverVolumeComponent))
    {
        aliceLeaveHoverVolume();
    }
    else if (isAliceInCylinder(steamVolumecomponent))
    {
        aliceLeaveSteamVolume();
    }
}

function ActivateVent()
{
    soundComponent.Play();
    ventParticleSystemComponent.ActivateSystem();
}

function updateState()
{
    if (bLastTickEnable && !isEnable())
    {
        DeactivateVent();
    }
    else if (!bLastTickEnable && isEnable())
    {
        ActivateVent();
    }
    bLastTickEnable = isEnable();
}

event Tick(float DeltaTime)
{
    updateState();
    if (!isEnable())
    {
        return;
    }
    GetAlicePlayerController();
    tickSteamVolume(DeltaTime);
    tickHoverVolume(DeltaTime);
    tickParticles(DeltaTime);
    lastAliceZ = APC.Pawn.Location.Z;
    drawDebugInfo();
}

simulated event PostBeginPlay()
{
    PostBeginPlay();
    if (ventIdleEmitter == none)
    {
        ventIdleEmitter = Spawn(class'Engine.EmitterSpawnable', self);
        if (ventIdleEmitter != none && ventIdlePS != none)
        {
            ventIdleEmitter.SetTemplate(ventIdlePS);
            ventIdleEmitter.ParticleSystemComponent.DeactivateSystem();
        }
    }
    bInitHideSet = bHidden;
    AliceCheckPointManager(WorldInfo.Game.MyCheckPointManager).RegisterWhenPostBeginPlay(self);
    if (!isEnable())
    {
        ventParticleSystemComponent.DeactivateSystem();
    }
    AttachComponent(soundComponent);
}

simulated function OnToggleHidden(SeqAct_ToggleHidden Action)
{
    if (Action.InputLinks[1].bHasImpulse)
    {
        bInitHideSet = false;
        AliceCheckPointManager(WorldInfo.Game.MyCheckPointManager).UpdateRegisterWhenChange(self, initMostOutName, initActorFName);
    }
    OnToggleHidden(Action);
}

function setEnable(bool Enable)
{
    bEnabled = Enable;
    AliceCheckPointManager(WorldInfo.Game.MyCheckPointManager).UpdateRegisterWhenChange(self, initMostOutName, initActorFName);
}

function bool isEnable()
{
    return bEnabled;
}

function bool ShouldSaveForCheckpoint()
{
    return true;
}

event UpdateAfterAcceptPersistentDate()
{
    if (!bInitHideSet)
    {
        if (bEnabled)
        {
            SetHidden(false);
            ActivateVent();
        }
    }
}

function ApplyCheckpointRecord(out const CheckpointRecord Record)
{
    AliceCheckPointManager(WorldInfo.Game.MyCheckPointManager).UnRegisterWhenApplyRecord(self, initMostOutName, initActorFName);
    bEnabled = Record.bEnabled;
    bInitHideSet = Record.bInitHideSet;
    initActorFName = Record.initActorFName;
    initMostOutName = Record.initMostOutName;
    AliceCheckPointManager(WorldInfo.Game.MyCheckPointManager).RegisterWhenApplyRecord(self, initMostOutName, initActorFName);
    SetLocationNoCheck(Record.Location);
    SetRotation(Record.Rotation);
    if (!bInitHideSet)
    {
        if (bEnabled)
        {
            SetHidden(false);
            ActivateVent();
        }
    }
}

function CreateCheckpointRecord(out CheckpointRecord Record)
{
    Record.bEnabled = bEnabled;
    Record.bInitHideSet = bInitHideSet;
    Record.Location = Location;
    Record.Rotation = Rotation;
}

defaultproperties
{
    hoverVolumeComponent="Default__AliceVentActor.HoverComponent"
    steamVolumecomponent="Default__AliceVentActor.SteamComponent"
    BaseMeshComponent="Default__AliceVentActor.StaticMeshComponent0"
    LightEnvironment="Default__AliceVentActor.MyLightEnvironment"
    ventParticleSystemComponent="Default__AliceVentActor.ParticleSystemComponent0"
    soundComponent="Default__AliceVentActor.loopComponent"
    steamVelocityZ=200.0
    steamForce=(X=0.0,Y=0.0,Z=2000.0)
    steamPerturbAmplitude=(X=500.0,Y=500.0,Z=1500.0)
    horizonVelDecDuration=0.2
    hoverForce=(X=0.0,Y=0.0,Z=2000.0)
    hoverPerturbAmplitude=(X=500.0,Y=500.0,Z=1500.0)
    hoverForwardSpeed=500.0
    hoverStrafeSpeed=500.0
    hoverRotationSpeed=400.0
    HoverDelayTime=1.0
    DelayCameraTimeWhenLeave=1.0
    HoverAmplitude=150.0
    HoverCycleTime=3.5
    HoverDist=600.0
    bShowDebugInfo=True
    bEnabled=True
    bCollideActors=True
    Components(0)="Default__AliceVentActor.MyLightEnvironment"
    Components(1)="Default__AliceVentActor.Sprite"
    Components(2)="Default__AliceVentActor.HoverComponent"
    Components(3)="Default__AliceVentActor.SteamComponent"
    Components(4)="Default__AliceVentActor.StaticMeshComponent0"
    Components(5)="Default__AliceVentActor.ParticleSystemComponent0"
    CollisionType="COLLIDE_CustomDefault"
}

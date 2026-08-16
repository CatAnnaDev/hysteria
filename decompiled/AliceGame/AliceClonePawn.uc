class AliceClonePawn extends AliceGamePawn
    native
    placeable
    config(Game)
    hidecategories(Navigation);

enum ClonnPawnState
{
    e_ClonePawnState_Falling,
    e_ClonePawnState_Landing,
    e_ClonePawnState_Countdown,
    e_ClonePawnState_CriticalTime,
    e_ClonePawnState_Destory,
};

var AlicePawn MyAlicePawn;
var() float InitSpeed;
var Rotator InitSocketRotator;
var bool bInitSpeed;
var(Material) bool bDuplicateMaterials;
var transient bool bShouldPause;
var() float CountdownTime;
var() float CriticalTime;
var ClonnPawnState CloneState;
var() ClockBombType BombType;
var() float ExplosionDamage;
var() float ExplosionRadiusDamage;
var() int ExplosionKnockBackID;
var() int ExplosionDmgStrength;
var() editinline ForceFeedbackWaveform BombFireWaveForm;
var() ParticleSystem ExplosionParticle;
var() name ExplosionSocket;
var() float AttractedRadius;
var() AnimationParaConfig AnimCfg_Landing;
var() AnimationParaConfig AnimCfg_SetupByAlice;
var(Material) array<MaterialInstance> ChangeMaterials;
var export editinline AudioComponent AmbientSoundComponent;
var() SoundCue CountDownSound;
var() SoundCue CriticalStartSound;
var() SoundCue CriticalSound;
var() SoundCue ExplodeSound;
var() const export editconst editinline DynamicLightEnvironmentComponent LightEnvironment;
var transient float FallingTime;
var float MaxFallingTime;
var Vector vInitSpeed;
var export editinline NxForceFieldRadialComponent CylindricalForceField;

native function Detonate()
{
}

simulated event Destroyed()
{
    if (CloneState != 4)
    {
        AlicePlayerController(MyAlicePawn.Controller).DetonateClockBomb();
        MyAlicePawn.bClockBombCountingDown = false;
        MyAlicePawn.bHoldingWatch = false;
        MyAlicePawn.MyClonePawn = none;
    }
    Destroyed();
}

function AnnounceDie()
{
    CountdownTime = 0.0;
    CloneState = 3;
}

simulated function CacheAnimNodes()
{
    local AliceGameAnimNode_BlendBase Node;
    local int I;
    
    AnimTreeRootNode = AnimTree(Mesh.Animations);
    for (I = 0; I < AnimBlendNodes.Length; I++)
    {
        AnimBlendNodes[I] = none;
    }
    foreach Mesh.AllAnimNodes(class'AliceGameAnimNode_BlendBase', Node)
    {
        switch (Node.NodeName)
        {
            case 'Slot_FullBody_Main':
                AnimBlendNodes[0] = Node;
                continue;
            case 'Slot_HalfBody_Upper_Main':
                AnimBlendNodes[1] = Node;
                continue;
            case 'PerBone_BlendUpperLower_Main':
                AnimBlendNodes[2] = Node;
                continue;
            default:
                continue;
        }
    }
    CacheAnimNodes();
}

function bool Died(Controller Killer, class<DamageType> DamageType, Vector HitLocation)
{
    local AliceClonePawnDummyWeapon DummyWeapon;
    
    DummyWeapon = AliceClonePawnDummyWeapon(Weapon);
    if (DummyWeapon != none)
    {
        DummyWeapon.TriggerRadiusDamage();
        AlicePlayerController(MyAlicePawn.Controller).ClientPlayForceFeedbackWaveform(BombFireWaveForm);
    }
    if (AmbientSoundComponent != none)
    {
        AmbientSoundComponent.Stop();
    }
    AmbientSoundComponent = none;
    if (ExplodeSound != none)
    {
        PlaySound(ExplodeSound);
    }
    return Died(Killer, DamageType, HitLocation);
}

event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
    if (CloneState == 1)
    {
        SetCollisionType(2);
        CloneState = 2;
        SetTimer((CountdownTime + CriticalTime) / 360.0, true, 'NotifyGFxHUDBombCountingDown');
        if (CountDownSound != none)
        {
            AmbientSoundComponent = new(self) class'Engine.AudioComponent';
            if (AmbientSoundComponent != none)
            {
                AttachComponent(AmbientSoundComponent);
                AmbientSoundComponent.Stop();
                AmbientSoundComponent.SoundCue = CountDownSound;
                AmbientSoundComponent.Play();
            }
        }
    }
}

event SetupStart()
{
    if (BombType == 1)
    {
        SetPhysics(2);
        SetCollisionType(2);
        Velocity = InitSpeed * vect(0.0, 0.0, -1.0);
        CloneState = 0;
        PlayConfigAnim(AnimCfg_SetupByAlice);
    }
}

event Landed(Vector HitNormal, Actor FloorActor)
{
    if (BombType == 0)
    {
        TakeFallingDamage();
        if (Health > 0)
        {
            PlayLanded(Velocity.Z);
        }
        LastHitBy = none;
        SetPhysics(1);
        PlayConfigAnim(AnimCfg_Landing);
        if (CloneState != 4 && CloneState != 2)
        {
            CloneState = 1;
        }
    }
    else if (CloneState != 4 && CloneState != 2)
    {
        CloneState = 1;
    }
}

function NotifyGFxHUDBombCountingDown()
{
    AliceGameInfo(WorldInfo.Game).GFxHUDMenu.BombCount();
}

event PostBeginPlay()
{
    local Inventory Inv;
    local CylinderComponent CylComp;
    local Vector SpotLoc, CheckSize;
    
    PostBeginPlay();
    if (Controller == none)
    {
        SpawnDefaultController();
    }
    if (BombType == 0)
    {
        SetPhysics(2);
        CloneState = 0;
    }
    else if (Mesh != none)
    {
        Mesh.RootMotionMode = 3;
    }
    Inv = FindInventoryType(class'AliceClonePawnDummyWeapon');
    if (Weapon(Inv) != none)
    {
        SetActiveWeapon(Weapon(Inv));
    }
    AliceGameInfo(WorldInfo.Game).GFxHUDMenu.showBombHit(true);
    FallingTime = 0.0;
    SpotLoc = Location;
    CylComp = CylinderComponent(CollisionComponent);
    CheckSize.X = CylComp.CollisionRadius;
    CheckSize.Y = CylComp.CollisionRadius;
    CheckSize.Z = CylComp.CollisionHeight;
    FindSpot(CheckSize, SpotLoc);
    if (AliceGameInfo(WorldInfo.Game).GetGameEngine().PhysXLevel > 0)
    {
        CylindricalForceField.DoInitRBPhys();
        AttachComponent(CylindricalForceField);
    }
}

state Dying
{
    event BeginState(name PreviousStateName)
    {
        local Vector Loc;
        local Rotator Rot;
        local ParticleSystemComponent PSC;
        
        Mesh.GetSocketWorldLocationAndRotation(ExplosionSocket, Loc, Rot);
        if (Owner != none && Owner.WorldInfo != none && Owner.WorldInfo.MyEmitterPool != none)
        {
            PSC = Owner.WorldInfo.MyEmitterPool.SpawnEmitter(ExplosionParticle, Loc, Rot);
            PSC.SetAbsolute(false, false, false);
        }
        if (MyAlicePawn.MyClonePawn == self)
        {
            AlicePlayerController(MyAlicePawn.Controller).DelayNextClockBomb();
            MyAlicePawn.bClockBombCountingDown = false;
            MyAlicePawn.bHoldingWatch = false;
            MyAlicePawn.MyClonePawn = none;
        }
        MyAlicePawn = none;
        CloneState = 4;
        AliceGameInfo(WorldInfo.Game).GFxHUDMenu.showBombHit(false);
        ClearTimer('NotifyGFxHUDBombCountingDown');
        Mesh.SetHidden(true);
        SetTimer(0.6, true, 'AfterExplosion');
    }
    
    event AfterExplosion()
    {
        local Actor A;
        local array<SequenceEvent> TouchEvents;
        local int I;
        
        Controller.NotifyBeginDying(self);
        LifeSpan = 25.0;
        SetDyingPhysics();
        SetCollision(true, false);
        if (Controller != none)
        {
            if (Controller.bIsPlayer)
            {
                DetachFromController();
            }
            else
            {
                Controller.Destroy();
            }
        }
        foreach TouchingActors(class'Engine.Actor', A)
        {
            if (A.FindEventsOfClass(class'Engine.SeqEvent_Touch', TouchEvents))
            {
                for (I = 0; I < TouchEvents.Length; I++)
                {
                    SeqEvent_Touch(TouchEvents[I]).NotifyTouchingPawnDied(self);
                }
                TouchEvents.Length = 0;
            }
        }
        foreach BasedActors(class'Engine.Actor', A)
        {
            A.PawnBaseDied();
        }
        SetTimer(0.3, false);
    }
    
    event Timer()
    {
        Destroy();
    }
    
    Stop;
}

defaultproperties
{
    InitSpeed=300.0
    ExplosionKnockBackID=-1
    ExplosionDmgStrength=3
    BombFireWaveForm="Default__AliceClonePawn.ForceFeedbackWaveformShooting1"
    AttractedRadius=200.0
    AnimCfg_Landing=(AnimationNames=("Fishwoman_Greeting"),BlendNodeIndex="EABLIdx_Slot_FullBody_Main",AnimType=0,BlendInTime=0.2,BlendOutTime=0.5,PlayRate=1.0,bLoop=False,bCauseActorAnimEnd=True,bTriggerFakeRootMotion=False,bNotExtendAnimTimeForFakeRootMotion=False,AnimPlayType="ECAPT_RandomPickupOne",RootBoneTransitionOption="RBA_Discard",RootBoneTransitionOption[1]="RBA_Discard",RootBoneTransitionOption[2]="RBA_Discard",RootBoneRotationOption="RRO_Default",RootBoneRotationOption[1]="RRO_Default",RootBoneRotationOption[2]="RRO_Default",FakeRootMotionMode="RMM_Accel",AnimationDescName="")
    AnimCfg_SetupByAlice=(AnimationNames=("ClockworkBomb_Spawn_Put"),BlendNodeIndex="EABLIdx_Slot_FullBody_Main",AnimType=0,BlendInTime=0.2,BlendOutTime=0.5,PlayRate=1.0,bLoop=False,bCauseActorAnimEnd=True,bTriggerFakeRootMotion=False,bNotExtendAnimTimeForFakeRootMotion=False,AnimPlayType="ECAPT_RandomPickupOne",RootBoneTransitionOption="RBA_Discard",RootBoneTransitionOption[1]="RBA_Discard",RootBoneTransitionOption[2]="RBA_Discard",RootBoneRotationOption="RRO_Default",RootBoneRotationOption[1]="RRO_Default",RootBoneRotationOption[2]="RRO_Default",FakeRootMotionMode="RMM_Accel",AnimationDescName="")
    CountDownSound="SFX_Clockwork_Bomb.sfx_cb_tick_slow_Cue"
    CriticalStartSound="SFX_Clockwork_Bomb.sfx_cb_tick_warn_Cue"
    CriticalSound="SFX_Clockwork_Bomb.sfx_cb_tick_fast_Cue"
    ExplodeSound="SFX_Clockwork_Bomb.sfx_cb_explode01_Cue"
    LightEnvironment="Default__AliceClonePawn.MyLightEnvironment"
    MaxFallingTime=2.5
    CylindricalForceField="Default__AliceClonePawn.AttachedForceFieldComponent"
    WeaponParas(0)=(WeaponClass="AliceClonePawnDummyWeapon",bAvailable=True,DefaultAttachedSocketName="None",CollisionPhysicsAssets=(),WeaponArcheType="None",ComponentIndex=0,WeaponMeleeRange=300.0,RangeAttackSocket="None",RangeAttackSocketArray=(),ProjectileArchetype="None",bCannotBeShieldByAlice=False)
    ControllerClass="AliceGameCloneAliceAIController"
    Mesh="Default__AliceClonePawn.AlicePawnSkeletalMeshComponent"
    CylinderComponent="Default__AliceClonePawn.CollisionCylinder"
    FacialAudioComp="Default__AliceClonePawn.FaceAudioComponent"
    bPushedByEncroachers=False
    bCanStepUpOn=False
    Components(0)="Default__AliceClonePawn.CollisionCylinder"
    Components(1)="Default__AliceClonePawn.Arrow"
    Components(2)="Default__AliceClonePawn.FaceAudioComponent"
    Components(3)="Default__AliceClonePawn.MyLightEnvironment"
    Components(4)="Default__AliceClonePawn.AlicePawnSkeletalMeshComponent"
    CollisionComponent="Default__AliceClonePawn.CollisionCylinder"
}

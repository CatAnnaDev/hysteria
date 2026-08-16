class ApexDestructibleActor extends Actor
    native
    placeable
    config(Engine)
    hidecategories(Navigation);

struct CheckpointRecord
{
    var string initMostOutName;
    var string initActorFName;
    var bool bPlayed;
};

var() export editinline DynamicLightEnvironmentComponent LightEnvironment;
var() bool bFractureMaterialOverride;
var bool bPlayed;
var() const editfixedsize array<FractureMaterial> FractureMaterials;
var() const export editconst editinline ApexStaticDestructibleComponent StaticDestructibleComponent;
var array<byte> VisibilityFactors;
var transient array<SoundCue> FractureSounds;
var transient array<ParticleSystem> FractureParticleEffects;
var transient string initMostOutName;
var transient string initActorFName;

native simulated function TakeRadiusDamage(Controller InstigatedBy, float BaseDamage, float DamageRadius, class<DamageType> DamageType, float Momentum, Vector HurtOrigin, bool bFullDamage, Actor DamageCauser, optional float DamageFalloffExponent = 1.0)
{
    InstigatedBy;
    BaseDamage;
    DamageRadius;
    DamageType;
    Momentum;
    HurtOrigin;
    bFullDamage;
    DamageCauser;
    DamageFalloffExponent;
}

native simulated function TakeDamage(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    Damage;
    EventInstigator;
    HitLocation;
    Momentum;
    DamageType;
    HitInfo;
    DamageCauser;
}

event HandleTakeDamageEvent(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
}

simulated event PostBeginPlay()
{
    PostBeginPlay();
    CacheFractureEffects();
    WorldInfo.Game.MyCheckPointManager.RegisterWhenPostBeginPlayCallFromBase(self);
}

native function CacheFractureEffects()
{
}

event SpawnFractureEmitter(ParticleSystem EmitterTemplate, Vector SpawnLocation, Vector SpawnDirection)
{
    local ParticleSystemComponent PSC;
    local LightingChannelContainer Lights;
    
    PSC = WorldInfo.MyEmitterPool.SpawnEmitter(EmitterTemplate, SpawnLocation, rotator(SpawnDirection));
    Lights = PSC.LightingChannels;
    Lights.Dynamic = true;
    Lights.bInitialized = true;
    PSC.SetLightingChannels(Lights);
}

event UpdateAfterAcceptPersistentDate()
{
    if (bPlayed)
    {
    }
}

function ApplyCheckpointRecord(out const CheckpointRecord Record)
{
    WorldInfo.Game.MyCheckPointManager.UnRegisterWhenApplyRecordCallFromBase(self, initMostOutName, initActorFName);
    bPlayed = Record.bPlayed;
    initActorFName = Record.initActorFName;
    initMostOutName = Record.initMostOutName;
    WorldInfo.Game.MyCheckPointManager.RegisterWhenApplyRecordCallFromBase(self, initMostOutName, initActorFName);
    if (bPlayed)
    {
    }
}

function CreateCheckpointRecord(out CheckpointRecord Record)
{
    Record.bPlayed = bPlayed;
}

defaultproperties
{
    LightEnvironment="Default__ApexDestructibleActor.LightEnvironment0"
    StaticDestructibleComponent="Default__ApexDestructibleActor.DestructibleComponent0"
    bNoDelete=True
    bRouteBeginPlayEvenIfStatic=False
    bGameRelevant=True
    bMovable=False
    bCanBeDamaged=True
    bCollideActors=True
    bBlockActors=True
    bProjTarget=True
    bNoEncroachCheck=True
    bEdShouldSnap=True
    Components(0)="Default__ApexDestructibleActor.LightEnvironment0"
    Components(1)="Default__ApexDestructibleActor.DestructibleComponent0"
    CollisionType="COLLIDE_CustomDefault"
    CollisionComponent="Default__ApexDestructibleActor.DestructibleComponent0"
}

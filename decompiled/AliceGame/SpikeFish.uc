class SpikeFish extends AliceGameSkeletalMeshActorBase
    native
    placeable
    hidecategories(Navigation);

enum ESpikeFishState
{
    ESFS_SpikeIdle,
    ESFS_SpikeAttack,
    ESFS_FatIdle,
};

var ESpikeFishState SpikeFishAnimState;
var() EDamageStrengthType KnockBackType;
var() KnockBackParameters KnockBackParameter;
var() ParticleSystem ExplodeFX;
var() ParticleSystem CycleFxFat;
var() ParticleSystem CycleFxSpike;
var() SoundCue ExplodeSound;
var() SoundCue CylceSoundFat;
var() SoundCue CylceSoundSpike;
var() float SpikeDamageAmount;
var() float CycleMinDuration;
var() float CycleMaxDuration;
var float StateTime;
var float StateDuration;
var float MorphWeight;
var float MorphSpeed;
var float AttackingTime;
var bool bIsAttacking;
var AlicePawn Alice;

function PlayParticle(Vector Loc, Rotator Rot, ParticleSystem NewTemplate, bool bDestroyOnFinish, optional Actor MyBase = none)
{
    local Emitter ParticleEmitter;
    
    ParticleEmitter = Spawn(class'Engine.EmitterSpawnable', self, , Loc, Rot);
    if (ParticleEmitter != none)
    {
        ParticleEmitter.SetLocation(Loc);
        ParticleEmitter.SetRotation(Rot);
        ParticleEmitter.SetDrawScale(3.0);
        ParticleEmitter.SetTemplate(NewTemplate, bDestroyOnFinish);
        if (MyBase != none)
        {
            ParticleEmitter.SetBase(MyBase);
        }
    }
}

simulated function OnToggle(SeqAct_Toggle Action)
{
    if (Action.InputLinks[0].bHasImpulse)
    {
        GotoState('SpikeState');
    }
    else if (Action.InputLinks[1].bHasImpulse)
    {
        GotoState('FatState');
    }
    else if (Action.InputLinks[2].bHasImpulse)
    {
        if (IsInState('FatState'))
        {
            GotoState('SpikeState');
        }
        else
        {
            GotoState('FatState');
        }
    }
}

state ExplodeState
{
    event BeginState(name PreviousStateName)
    {
        PlayParticle(Location, Rotation, ExplodeFX, true);
        PlaySound(ExplodeSound);
        SetHidden(true);
        SetCollision(false, false);
        LifeSpan = 1.0;
    }
    
    Stop;
}

state SpikeState
{
    function StopKnockBack()
    {
        if (Alice != none)
        {
            Alice.bSwimKnockBack = false;
        }
    }
    
    event Bump(Actor Other, PrimitiveComponent OtherComp, Vector HitNormal)
    {
        local Vector KnockBackdir;
        
        if (bIsAttacking)
        {
            return;
        }
        Alice = AlicePawn(Other);
        if (Alice != none && !Alice.bSwimKnockBack)
        {
            bIsAttacking = true;
            AttackingTime = 0.0;
            Alice.CurrentDmgStrength = KnockBackType;
            Alice.bSwimKnockBack = true;
            KnockBackdir = Normal(Alice.Location - Location);
            Alice.SwimKnockBackDir = KnockBackdir;
            Alice.Mesh.SetFakeRootMotionPara(KnockBackParameter.KnockBackScale, KnockBackParameter.KnockBackTotalTime, 10, rotator(KnockBackdir));
            Alice.Mesh.ActiveFakeRootMotion();
            Alice.Mesh.FakeRootMotionMode = 3;
            Alice.TakeDamage(int(SpikeDamageAmount), none, Alice.Location, vector(Alice.Rotation), class'DmgType_SpikeFish');
            SetTimer(0.5, false, 'StopKnockBack');
        }
    }
    
    event EndState(name NextStateName)
    {
        if (Alice != none)
        {
            Alice.bSwimKnockBack = false;
        }
    }
    
    event Tick(float DeltaTime)
    {
        if (MorphWeight < 1.0)
        {
            MorphWeight += MorphSpeed * float(2) * DeltaTime / 0.0166;
            MorphWeight = FClamp(MorphWeight, 0.0, 1.0);
            SkeletalMeshComponent.SetMorphWeight('SK_SpikeFish_Spiky', MorphWeight);
        }
        StateTime += DeltaTime;
        if (StateTime >= StateDuration)
        {
            GotoState('FatState');
        }
    }
    
    event BeginState(name PreviousStateName)
    {
        StateTime = 0.0;
        StateDuration = RandRange(CycleMinDuration, CycleMaxDuration);
        SpikeFishAnimState = 1;
        bIsAttacking = false;
        AttackingTime = 0.0;
        if (CycleFxSpike != none)
        {
            PlayParticle(Location, Rotation, CycleFxSpike, true);
        }
        if (CylceSoundSpike != none)
        {
            PlaySound(CylceSoundSpike);
        }
    }
    
    Stop;
}

state FatState
{
    event TakeDamage(int DamageAmount, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
    {
        if (DamageType != class'DmgType_Electricity')
        {
            return;
        }
        GotoState('ExplodeState');
    }
    
    event Bump(Actor Other, PrimitiveComponent OtherComp, Vector HitNormal)
    {
        local AlicePawn ap;
        
        ap = AlicePawn(Other);
        if (ap != none)
        {
            if (ap.bBoostingSwim)
            {
                GotoState('ExplodeState');
            }
        }
    }
    
    event EndState(name NextStateName)
    {
    }
    
    event Tick(float DeltaTime)
    {
        if (MorphWeight > float(0))
        {
            MorphWeight -= MorphSpeed * DeltaTime / 0.0166;
            MorphWeight = FClamp(MorphWeight, 0.0, 1.0);
            SkeletalMeshComponent.SetMorphWeight('SK_SpikeFish_Spiky', MorphWeight);
        }
        StateTime += DeltaTime;
        if (StateTime >= StateDuration)
        {
            GotoState('SpikeState');
        }
    }
    
    event BeginState(name PreviousStateName)
    {
        StateTime = 0.0;
        StateDuration = RandRange(CycleMinDuration, CycleMaxDuration);
        SpikeFishAnimState = 2;
        if (CycleFxFat != none)
        {
            PlayParticle(Location, Rotation, CycleFxFat, true);
        }
        if (CylceSoundFat != none)
        {
            PlaySound(CylceSoundFat);
        }
    }
    
    Stop;
}

defaultproperties
{
    KnockBackType="EDSTR_Medium"
    KnockBackParameter=(KnockBackScale=0.0,KnockBackTotalTime=-1.0,KnockBackRefAngle=(Pitch=0,Yaw=0,Roll=0))
    SpikeDamageAmount=10.0
    CycleMinDuration=6.0
    CycleMaxDuration=10.0
    MorphSpeed=0.05
    SkeletalMeshComponent="Default__SpikeFish.SkeletalMeshComponent0"
    LightEnvironment="Default__SpikeFish.MyLightEnvironment"
    FacialAudioComp="Default__SpikeFish.FaceAudioComponent"
    bNoDelete=False
    bCollideActors=True
    bBlockActors=True
    Components(0)="Default__SpikeFish.MyLightEnvironment"
    Components(1)="Default__SpikeFish.SkeletalMeshComponent0"
    Components(2)="Default__SpikeFish.FaceAudioComponent"
    Components(3)="Default__SpikeFish.CollisionCylinder"
    CollisionType="COLLIDE_BlockAll"
    InitialState="FatState"
    CollisionComponent="Default__SpikeFish.CollisionCylinder"
}

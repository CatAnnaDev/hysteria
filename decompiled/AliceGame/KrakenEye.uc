class KrakenEye extends AliceGameSkeletalMeshActorBase
    native
    placeable
    hidecategories(Navigation);

enum EKrakenEyeState
{
    EKES_Idle,
    EKES_Charge,
    EKES_Relief,
    EKES_Close,
};

var EKrakenEyeState EyeState;
var() float HitRangeDistance;
var() export editinline AudioComponent AudioClose;
var() export editinline AudioComponent AudioIdle;
var() export editinline AudioComponent AudioCharge;
var() export editinline AudioComponent AudioRelief;
var() export editinline ParticleSystemComponent IdleParticle;
var() export editinline ParticleSystemComponent ChargeParticle;
var Emitter ParticleEmitter;
var() float DamageLimit;
var float Health;
var float StopHitTime;
var float ReliefTime;
var float HitPerShot;
var Actor Projecttile;
var MaterialInstanceConstant EyeColor;

event HitByRangeWeapon(Actor Bullet)
{
    local float dis;
    
    if (IsInState('CloseState'))
    {
        return;
    }
    if (Bullet == Projecttile)
    {
        return;
    }
    if (Bullet.IsA('PepperGrinderPrimaryProjectile'))
    {
        dis = VSize(Bullet.Location - Location);
        Health -= HitPerShot;
        StopHitTime = 0.0;
        Projecttile = Bullet;
        if (EyeColor != none)
        {
            EyeColor.SetScalarParameterValue('DamageValue', (default.Health - Health) / default.Health);
        }
        if (dis < HitRangeDistance && !IsInState('ChargeState') && !IsInState('CloseState'))
        {
            GotoState('ChargeState');
        }
    }
}

function SwitchAnimation(EKrakenEyeState Anim)
{
    local AnimNodeBlendList AnimNode;
    
    AnimNode = AnimNodeBlendList(SkeletalMeshComponent.FindAnimNode('KrakenEye'));
    if (AnimNode != none)
    {
        AnimNode.SetActiveChild(int(Anim), 0.1);
    }
}

state CloseState
{
    event BeginState(name PreviousStateName)
    {
        SwitchAnimation(3);
        ReliefTime = 0.0;
        if (AudioClose != none)
        {
            AudioClose.Play();
        }
        TriggerEventClass(class'SeqEvent_KrakenEyeClosed', self);
    }
    
    Stop;
}

state ReliefState
{
    event Tick(float DeltaTime)
    {
        ReliefTime += DeltaTime;
        if (ReliefTime > 0.05)
        {
            ReliefTime = 0.0;
            Health += HitPerShot;
            if (EyeColor != none)
            {
                EyeColor.SetScalarParameterValue('DamageValue', (default.Health - Health) / default.Health);
            }
            if (Health >= DamageLimit)
            {
                GotoState('IdleState');
            }
        }
    }
    
    event EndState(name NextStateName)
    {
        StopHitTime = 0.0;
        if (AudioRelief != none)
        {
            AudioRelief.Stop();
        }
        if (EyeColor != none)
        {
            EyeColor.SetScalarParameterValue('DamageValue', 0.0);
        }
    }
    
    event BeginState(name PreviousStateName)
    {
        SwitchAnimation(2);
        ReliefTime = 0.0;
        if (AudioRelief != none)
        {
            AudioRelief.Play();
        }
    }
    
    Stop;
}

state ChargeState
{
    event Tick(float DeltaTime)
    {
        if (Health <= float(0))
        {
            GotoState('CloseState');
        }
        StopHitTime += DeltaTime;
        if (StopHitTime > 1.5)
        {
            GotoState('ReliefState');
        }
    }
    
    event EndState(name NextStateName)
    {
        StopHitTime = 0.0;
        if (AudioCharge != none)
        {
            AudioCharge.Stop();
        }
    }
    
    event BeginState(name PreviousStateName)
    {
        SwitchAnimation(1);
        ChargeParticle.SetActive(true);
        if (AudioCharge != none)
        {
            AudioCharge.Play();
        }
    }
    
    Stop;
}

state IdleState
{
    event EndState(name NextStateName)
    {
        IdleParticle.DeactivateSystem();
        if (AudioIdle != none)
        {
            AudioIdle.Stop();
        }
    }
    
    event BeginState(name PreviousStateName)
    {
        SwitchAnimation(0);
        IdleParticle.SetActive(true);
        if (AudioIdle != none)
        {
            AudioIdle.Play();
        }
        Health = DamageLimit;
        if (EyeColor == none)
        {
            EyeColor = new(none) class'Engine.MaterialInstanceConstant';
            if (EyeColor != none)
            {
                EyeColor.SetParent(SkeletalMeshComponent.GetMaterial(1));
                SkeletalMeshComponent.SetMaterial(1, EyeColor);
            }
        }
    }
    
    Stop;
}

defaultproperties
{
    HitRangeDistance=100.0
    DamageLimit=130.0
    Health=100.0
    HitPerShot=5.0
    SkeletalMeshComponent="Default__KrakenEye.SkeletalMeshComponent0"
    LightEnvironment="Default__KrakenEye.MyLightEnvironment"
    FacialAudioComp="Default__KrakenEye.FaceAudioComponent"
    bCollideActors=True
    bCollideWorld=True
    Components(0)="Default__KrakenEye.MyLightEnvironment"
    Components(1)="Default__KrakenEye.SkeletalMeshComponent0"
    Components(2)="Default__KrakenEye.FaceAudioComponent"
    InitialState="IdleState"
    CollisionComponent="Default__KrakenEye.SkeletalMeshComponent0"
    SupportedEvents(0)="Engine.SeqEvent_Touch"
    SupportedEvents(1)="Engine.SeqEvent_Destroyed"
    SupportedEvents(2)="Engine.SeqEvent_TakeDamage"
    SupportedEvents(3)="Engine.SeqEvent_HitWall"
    SupportedEvents(4)="SeqEvent_KrakenEyeClosed"
}

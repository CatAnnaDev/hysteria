class FishNodeActor extends AliceGameSkeletalMeshActorBase
    placeable
    hidecategories(Navigation);

var() name AnimIdleOff;
var() name AnimGetHit;
var() name AnimIdleOn;
var() Material MaterialOn;
var() ParticleSystem FXHit;
var() SoundCue SoundOn;
var() class<DamageType> HitDamageType;
var Emitter FXParticleEmitter;
var bool bSwitchOn;
var float DelayTime;
var float StateTime;

event TakeDamage(int DamageAmount, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    if (DamageType != HitDamageType)
    {
        return;
    }
    if (IsInState('OffIdleState'))
    {
        GotoState('GetHitState');
    }
}

state OnIdleState
{
    event EndState(name NextStateName)
    {
    }
    
    event BeginState(name PreviousStateName)
    {
        local AnimNodeSequence SeqNode;
        
        SeqNode = AnimNodeSequence(SkeletalMeshComponent.Animations);
        SeqNode.SetAnim(AnimIdleOn);
        SeqNode.PlayAnim(true, 1.0, 0.0);
        bSwitchOn = true;
    }
    
    Stop;
}

state GetHitState
{
    event EndState(name NextStateName)
    {
        TriggerEventClass(class'SeqEvent_FishNodeActivated', self);
        SkeletalMeshComponent.SetMaterial(0, MaterialOn);
    }
    
    event Tick(float DeltaTime)
    {
        StateTime += DeltaTime;
        if (StateTime > DelayTime)
        {
            GotoState('OnIdleState');
        }
    }
    
    event BeginState(name PreviousStateName)
    {
        local AnimNodeSequence SeqNode;
        
        SeqNode = AnimNodeSequence(SkeletalMeshComponent.Animations);
        SeqNode.SetAnim(AnimGetHit);
        SeqNode.PlayAnim(true, 1.0, 0.0);
        StateTime = 0.0;
        FXParticleEmitter = Spawn(class'Engine.EmitterSpawnable', self, , Location);
        if (FXParticleEmitter != none && FXHit != none)
        {
            FXParticleEmitter.SetLocation(Location);
            FXParticleEmitter.SetTemplate(FXHit, true);
        }
    }
    
    Stop;
}

state OffIdleState
{
    event EndState(name NextStateName)
    {
    }
    
    event Tick(float DeltaTime)
    {
    }
    
    event BeginState(name PreviousStateName)
    {
        local AnimNodeSequence SeqNode;
        
        SeqNode = AnimNodeSequence(SkeletalMeshComponent.Animations);
        SeqNode.SetAnim(AnimIdleOff);
        SeqNode.PlayAnim(true, 1.0, 0.0);
        bSwitchOn = false;
    }
    
    Stop;
}

defaultproperties
{
    AnimIdleOff="CH_MusicFish_Swim"
    DelayTime=2.0
    SkeletalMeshComponent="Default__FishNodeActor.SkeletalMeshComponent0"
    LightEnvironment="Default__FishNodeActor.MyLightEnvironment"
    FacialAudioComp="Default__FishNodeActor.FaceAudioComponent"
    bCollideActors=True
    bBlockActors=True
    Components(0)="Default__FishNodeActor.MyLightEnvironment"
    Components(1)="Default__FishNodeActor.SkeletalMeshComponent0"
    Components(2)="Default__FishNodeActor.FaceAudioComponent"
    Components(3)="Default__FishNodeActor.CollisionCylinder"
    InitialState="OffIdleState"
    CollisionComponent="Default__FishNodeActor.CollisionCylinder"
    SupportedEvents(0)="Engine.SeqEvent_Touch"
    SupportedEvents(1)="Engine.SeqEvent_Destroyed"
    SupportedEvents(2)="Engine.SeqEvent_TakeDamage"
    SupportedEvents(3)="Engine.SeqEvent_HitWall"
    SupportedEvents(4)="SeqEvent_FishNodeActivated"
}

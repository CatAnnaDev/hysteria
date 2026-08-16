class AimSwitchActorBase extends SkeletalMeshActor
    abstract
    native
    placeable
    hidecategories(Navigation);

enum EAimSwitchActorAnimMode
{
    EAnimMode_Linear,
    EAnimMode_Accelerate,
};

enum EAimSwitchActorState
{
    EASAS_Idle,
    EASAS_Damage,
    EASAS_Relief,
    EASAS_Activate,
};

struct CheckpointRecord
{
    var string initMostOutName;
    var string initActorFName;
    var bool IsAvailable;
    var int Health;
};

var EAimSwitchActorState AimSwitchActorState;
var() EAimSwitchActorAnimMode DamageAnimMode;
var transient string initMostOutName;
var transient string initActorFName;
var() SoundCue IdleSound;
var() SoundCue DamageSound;
var() SoundCue ReliefSound;
var() SoundCue ActivateSound;
var export editinline AudioComponent AudioComp;
var() ParticleSystem DamageParticle;
var() ParticleSystem ActivateParticle;
var() name IdleAnimName;
var() name DamageAnimName;
var() name ReliefAnimName;
var() name ActivateAnimName;
var transient int Health;
var() int DamageLimit;
var() float ReliefTime;
var() int HealthStep;
var() float CollisionRadius;
var transient float ReliefLeftTime;
var transient float ReliefStepTime;
var() float BaseDamageAnimRate;
var float BaseReliefAnimRate;
var transient int CurrentAnimPosPara;
var float DelayTimeToDestroy;
var Actor EventInst;
var AnimNodeSlot SlotNode;
var int ClockAnimReferenceValue[12];
var() array<MaterialInstance> ActivateMaterials;
var() MaterialInstance UnavailableMaterial;
var() MaterialInstance AvailableMaterial;
var() bool bDuplicateMaterials;
var() bool IsAvailable;
var transient bool bSkipPlaySoundAfterCheckPoint;

event DamageByProjectile(Projectile Proj)
{
    if (IsInState('Unavailable'))
    {
        return;
    }
    if (Proj.IsA('PepperGrinderPrimaryProjectile'))
    {
        if (!IsInState('Relief') && !IsInState('Activate') && !IsInState('Unavailable'))
        {
            Health -= HealthStep;
            CurrentAnimPosPara = CalcAnimPosPara();
            if (Health > 0)
            {
                GotoState('Damage', 'None', true);
            }
            else
            {
                AliceCheckPointManager(WorldInfo.Game.MyCheckPointManager).UpdateRegisterWhenChange(self, initMostOutName, initActorFName);
                GotoState('Activate');
            }
        }
    }
}

event TriggerDamage()
{
}

simulated function OnToggle(SeqAct_Toggle Action)
{
    if (Action.InputLinks[0].bHasImpulse)
    {
        IsAvailable = true;
        AliceCheckPointManager(WorldInfo.Game.MyCheckPointManager).UpdateRegisterWhenChange(self, initMostOutName, initActorFName);
        GotoState('Idle');
    }
    else if (Action.InputLinks[1].bHasImpulse)
    {
        IsAvailable = false;
        AliceCheckPointManager(WorldInfo.Game.MyCheckPointManager).UpdateRegisterWhenChange(self, initMostOutName, initActorFName);
        GotoState('Unavailable');
    }
    else if (Action.InputLinks[2].bHasImpulse)
    {
        if (!IsInState('Unavailable'))
        {
            IsAvailable = false;
            AliceCheckPointManager(WorldInfo.Game.MyCheckPointManager).UpdateRegisterWhenChange(self, initMostOutName, initActorFName);
            GotoState('Unavailable');
        }
        else
        {
            IsAvailable = true;
            AliceCheckPointManager(WorldInfo.Game.MyCheckPointManager).UpdateRegisterWhenChange(self, initMostOutName, initActorFName);
            GotoState('Idle');
        }
    }
}

final simulated function PlayDamageAnim()
{
}

final simulated function PlaySlotAnim(name AnimName, optional bool bLoop = false)
{
}

simulated event PostBeginPlay()
{
    CacheAnimNodes();
    CurrentAnimPosPara = 0;
    AliceCheckPointManager(WorldInfo.Game.MyCheckPointManager).RegisterWhenPostBeginPlay(self);
}

simulated event PreBeginPlay()
{
}

simulated event SetInitialState()
{
    bScriptInitialized = true;
    if (Health <= 0)
    {
        GotoState('Activate');
        return;
    }
    if (!IsAvailable)
    {
        GotoState('Unavailable');
    }
    else
    {
        GotoState('Idle');
    }
}

simulated function CacheAnimNodes()
{
    local AnimNodeSlot TempSlotNode;
    
    foreach SkeletalMeshComponent.AllAnimNodes(class'Engine.AnimNodeSlot', TempSlotNode)
    {
        if (TempSlotNode.NodeName == 'SlotNode')
        {
            SlotNode = TempSlotNode;
            break;
        }
    }
}

final simulated function int CalcAnimPosPara()
{
    local float BloodPercent;
    local int BloodAbsValue, I;
    
    if (DamageLimit > Health)
    {
        if (DamageAnimMode == 0)
        {
            BloodPercent = float(DamageLimit - Health) * 12.0 / float(DamageLimit);
            BloodAbsValue = int(BloodPercent);
            return BloodAbsValue;
        }
        else
        {
            BloodPercent = float(DamageLimit - Health) * float(ClockAnimReferenceValue[11]) / float(DamageLimit);
            BloodAbsValue = int(BloodPercent);
            for (I = 0; I < 12; I++)
            {
                if (BloodAbsValue < ClockAnimReferenceValue[I])
                {
                    return I;
                }
            }
        }
    }
    return 0;
}

native function PlayDeathEffect()
{
}

event UpdateAfterAcceptPersistentDate()
{
    if (IsAvailable)
    {
        if (Health <= 0)
        {
            bSkipPlaySoundAfterCheckPoint = true;
            GotoState('Activate');
            bSkipPlaySoundAfterCheckPoint = false;
        }
        else
        {
            GotoState('Idle');
        }
    }
    else
    {
        GotoState('Unavailable');
    }
}

function ApplyCheckpointRecord(out const CheckpointRecord Record)
{
    AliceCheckPointManager(WorldInfo.Game.MyCheckPointManager).UnRegisterWhenApplyRecord(self, initMostOutName, initActorFName);
    Health = Record.Health;
    IsAvailable = Record.IsAvailable;
    initActorFName = Record.initActorFName;
    initMostOutName = Record.initMostOutName;
    AliceCheckPointManager(WorldInfo.Game.MyCheckPointManager).RegisterWhenApplyRecord(self, initMostOutName, initActorFName);
    if (IsAvailable)
    {
        if (Health <= 0)
        {
            bSkipPlaySoundAfterCheckPoint = true;
            GotoState('Activate');
            bSkipPlaySoundAfterCheckPoint = false;
        }
        else
        {
            GotoState('Idle');
        }
    }
    else
    {
        GotoState('Unavailable');
    }
}

function CreateCheckpointRecord(out CheckpointRecord Record)
{
    Record.Health = Health;
    Record.IsAvailable = IsAvailable;
    Record.initActorFName = initActorFName;
    Record.initMostOutName = initMostOutName;
}

state Unavailable
{
    event EndState(name NextStateName)
    {
        SkeletalMeshComponent.SetMaterial(0, AvailableMaterial);
    }
    
    event BeginState(name PreviousStateName)
    {
        if (AudioComp != none)
        {
            AudioComp.Stop();
        }
        SkeletalMeshComponent.SetMaterial(0, UnavailableMaterial);
        Health = DamageLimit;
        CurrentAnimPosPara = 0;
    }
    
    Stop;
}

state Activate
{
    event EndState(name NextStateName)
    {
    }
    
    event BeginState(name PreviousStateName)
    {
        AimSwitchActorState = 3;
        if (!bSkipPlaySoundAfterCheckPoint)
        {
            if (AudioComp != none && ActivateSound != none)
            {
                AudioComp.Stop();
                AudioComp.SoundCue = ActivateSound;
                AudioComp.Play();
            }
        }
        if (ActivateParticle != none)
        {
            WorldInfo.MyEmitterPool.SpawnEmitter(ActivateParticle, Location, Rotation);
        }
        PlayDeathEffect();
        TriggerEventClass(class'Engine.SeqEvent_Destroyed', self);
    }
    
    Stop;
}

state Relief
{
    function ReliefFinish()
    {
        Health = DamageLimit;
        CurrentAnimPosPara = 0;
        GotoState('Idle');
    }
    
    event EndState(name NextStateName)
    {
        ClearTimer('ReliefFinish');
        CurrentAnimPosPara = 0;
    }
    
    event BeginState(name PreviousStateName)
    {
        AimSwitchActorState = 2;
        ReliefStepTime = 0.05;
        if (AudioComp != none && ReliefSound != none)
        {
            AudioComp.Stop();
            AudioComp.SoundCue = ReliefSound;
            AudioComp.Play();
        }
        PlaySlotAnim(ReliefAnimName);
        SetTimer(1.0, false, 'ReliefFinish');
    }
    
    Stop;
}

state Damage
{
    function DamageToRelief()
    {
        GotoState('Relief');
    }
    
    event EndState(name NextStateName)
    {
        ClearTimer('DamageToRelief');
    }
    
    event BeginState(name PreviousStateName)
    {
        AimSwitchActorState = 1;
        if (AudioComp != none && DamageSound != none)
        {
            AudioComp.Stop();
            AudioComp.SoundCue = DamageSound;
            AudioComp.Play();
        }
        if (PreviousStateName != 'Damage')
        {
            PlaySlotAnim(DamageAnimName);
        }
        if (DamageParticle != none)
        {
            WorldInfo.MyEmitterPool.SpawnEmitter(DamageParticle, Location, Rotation);
        }
        SetTimer(ReliefTime, false, 'DamageToRelief');
    }
    
    Stop;
}

state Idle
{
    event EndState(name NextStateName)
    {
        if (AudioComp != none)
        {
            AudioComp.Stop();
        }
    }
    
    event BeginState(name PreviousStateName)
    {
        AimSwitchActorState = 0;
        if (AudioComp != none && IdleSound != none)
        {
            AudioComp.Stop();
            AudioComp.SoundCue = IdleSound;
            AudioComp.Play();
        }
        PlaySlotAnim(IdleAnimName, true);
        Health = DamageLimit;
        CurrentAnimPosPara = 0;
    }
    
    Stop;
}

defaultproperties
{
    AudioComp="Default__AimSwitchActorBase.MyAudioComponent"
    Health=20
    DamageLimit=12
    ReliefTime=3.0
    HealthStep=1
    CollisionRadius=100.0
    BaseDamageAnimRate=3.0
    DelayTimeToDestroy=5.0
    ClockAnimReferenceValue=4
    ClockAnimReferenceValue[1]=8
    ClockAnimReferenceValue[2]=12
    ClockAnimReferenceValue[3]=15
    ClockAnimReferenceValue[4]=18
    ClockAnimReferenceValue[5]=21
    ClockAnimReferenceValue[6]=23
    ClockAnimReferenceValue[7]=25
    ClockAnimReferenceValue[8]=27
    ClockAnimReferenceValue[9]=28
    ClockAnimReferenceValue[10]=29
    ClockAnimReferenceValue[11]=30
    IsAvailable=True
    SkeletalMeshComponent="Default__AimSwitchActorBase.SkeletalMeshComponent0"
    LightEnvironment="Default__AimSwitchActorBase.MyLightEnvironment"
    FacialAudioComp="Default__AimSwitchActorBase.FaceAudioComponent"
    bNoDelete=False
    bCanBeDamaged=True
    BlockRigidBody=True
    bCollideActors=True
    Components(0)="Default__AimSwitchActorBase.MyLightEnvironment"
    Components(1)="Default__AimSwitchActorBase.SkeletalMeshComponent0"
    Components(2)="Default__AimSwitchActorBase.FaceAudioComponent"
    Components(3)="Default__AimSwitchActorBase.CollisionCylinder"
    Components(4)="Default__AimSwitchActorBase.MyAudioComponent"
    InitialState="Idle"
    CollisionComponent="Default__AimSwitchActorBase.CollisionCylinder"
}

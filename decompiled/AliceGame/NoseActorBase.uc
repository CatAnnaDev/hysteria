class NoseActorBase extends AliceGameSkeletalMeshActorBase
    abstract
    native
    placeable
    hidecategories(Navigation);

enum ENoseState
{
    ENS_Idle,
    ENS_ChargeState1,
    ENS_ChargeState2,
    ENS_ChargeState3,
    ENS_ChargeState4,
    ENS_ChargeState5,
    ENS_Release,
    ENS_Action,
};

struct CheckpointRecord
{
    var string initMostOutName;
    var string initActorFName;
    var bool bEnable;
    var bool bInitHidden;
    var float Health;
};

var transient string initMostOutName;
var transient string initActorFName;
var transient bool bSkipPlaySoundAfterCheckPoint;
var bool bEnable;
var() bool bInitHidden;
var ENoseState NoseState;
var float HitRangeDistance;
var() export editinline AudioComponent AudioActive;
var() export editinline AudioComponent AudioIdle;
var() export editinline AudioComponent AudioCharge;
var() export editinline AudioComponent AudioRelief;
var() export editinline ParticleSystemComponent DestroyParticle;
var() export editinline ParticleSystemComponent IdleParticle;
var() export editinline ParticleSystemComponent ChargeParticle;
var() float DelayTimeToDestroy;
var() float DamageLimit;
var() float SoundRadius;
var float Health;
var float StopHitTime;
var float ReliefTime;
var float HitPerShot;
var Actor EventInst;
var() name SountTag;

function bool ShouldSaveForCheckpoint()
{
    return true;
}

simulated function OnToggle(SeqAct_Toggle Action)
{
    if (Action.InputLinks[0].bHasImpulse)
    {
        GotoState('IdleState');
        bEnable = true;
    }
    else if (Action.InputLinks[1].bHasImpulse)
    {
        GotoState('DisableState');
        bEnable = false;
    }
    else if (Action.InputLinks[2].bHasImpulse)
    {
        bEnable = !bEnable;
        if (bEnable)
        {
            GotoState('IdleState');
        }
        else
        {
            GotoState('DisableState');
        }
    }
}

function saveToPersistentData()
{
    local AlicePlayerController APC;
    
    APC = AlicePlayerController(WorldInfo.GetLocalPlayerPawn().Controller);
    if (APC != none)
    {
        APC.setSountActive(SountTag);
    }
}

function statistic_Trophy_And_PData()
{
    local AliceGameInfo Game;
    local string MapName;
    local int I, pos, AllSnouts, AllSnoutsPeppered;
    local AlicePlayerController APC;
    
    Game = AliceGameInfo(WorldInfo.Game);
    APC = AlicePlayerController(WorldInfo.GetLocalPlayerPawn().Controller);
    if (APC != none)
    {
        for (I = 0; I < APC.SountActive.Length; I++)
        {
            if (SountTag == name(APC.SountActive[I]))
            {
                return;
            }
        }
    }
    MapName = WorldInfo.GetMapName();
    for (I = 0; I < 6; I++)
    {
        pos = InStr(MapName, "Chapter" $ string(I + 1));
        if (pos != -1)
        {
            Game.CurrentChapterSnoutNum[I]++;
            if (Game.CurrentChapterSnoutNum[I] == Game.ChapterSnoutNum[I])
            {
                ConsoleCommand("trophy unlock=" @ string(24));
            }
            break;
        }
    }
    for (I = 0; I < 6; I++)
    {
        AllSnoutsPeppered += Game.CurrentChapterSnoutNum[I];
        AllSnouts += Game.ChapterSnoutNum[I];
    }
    Game.CurrentSnoutNum = AllSnoutsPeppered;
    if (AllSnouts == AllSnoutsPeppered)
    {
        ConsoleCommand("trophy unlock=" @ string(25));
    }
    saveToPersistentData();
}

function ShowNose()
{
    SetCollision(true, true);
    SetHidden(false);
    GotoState('IdleState');
}

function HideNose()
{
    SetCollision(false, false);
    SetHidden(true);
    GotoState('DisableState');
}

function WakeNose()
{
    if (!IsInState('ActivateState'))
    {
        GotoState('ActivateState');
        SetTimer(DelayTimeToDestroy, false, 'HideNose');
    }
}

simulated function TakeRadiusDamage(Controller InstigatedBy, float BaseDamage, float DamageRadius, class<DamageType> DamageType, float Momentum, Vector HurtOrigin, bool bFullDamage, Actor DamageCauser, optional float DamageFalloffExponent = 1.0)
{
    if (DamageCauser.IsA('PepperGrinderPrimaryProjectile'))
    {
        EventInst = InstigatedBy;
    }
}

event TakeDamage(int DamageAmount, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    if (DamageCauser.IsA('PepperGrinderPrimaryProjectile'))
    {
        EventInst = EventInstigator;
    }
}

event HitByRangeWeapon(Actor Bullet)
{
    if (Bullet.IsA('PepperGrinderPrimaryProjectile'))
    {
        if (!IsInState('ChargeState') && !IsInState('ActivateState'))
        {
            GotoState('ChargeState');
        }
        Health -= HitPerShot;
        StopHitTime = 0.0;
    }
}

simulated function OnToggleHidden(SeqAct_ToggleHidden Action)
{
    if (Action.InputLinks[1].bHasImpulse)
    {
        bInitHidden = false;
        AliceCheckPointManager(WorldInfo.Game.MyCheckPointManager).UpdateRegisterWhenChange(self, initMostOutName, initActorFName);
        if (AudioIdle != none)
        {
            AudioIdle.Play();
        }
    }
    OnToggleHidden(Action);
}

event UpdateAfterAcceptPersistentDate()
{
    if (Health <= float(0))
    {
        HideNose();
    }
    else if (!bInitHidden)
    {
        bSkipPlaySoundAfterCheckPoint = true;
        ShowNose();
        bSkipPlaySoundAfterCheckPoint = false;
    }
    else
    {
        HideNose();
    }
}

function ApplyCheckpointRecord(out const CheckpointRecord Record)
{
    AliceCheckPointManager(WorldInfo.Game.MyCheckPointManager).UnRegisterWhenApplyRecord(self, initMostOutName, initActorFName);
    Health = Record.Health;
    bEnable = Record.bEnable;
    bInitHidden = Record.bInitHidden;
    initActorFName = Record.initActorFName;
    initMostOutName = Record.initMostOutName;
    AliceCheckPointManager(WorldInfo.Game.MyCheckPointManager).RegisterWhenApplyRecord(self, initMostOutName, initActorFName);
    if (Health <= float(0))
    {
        HideNose();
    }
    else if (!bInitHidden)
    {
        bSkipPlaySoundAfterCheckPoint = true;
        ShowNose();
        bSkipPlaySoundAfterCheckPoint = false;
    }
    else
    {
        HideNose();
    }
}

function CreateCheckpointRecord(out CheckpointRecord Record)
{
    Record.Health = Health;
    Record.initActorFName = initActorFName;
    Record.initMostOutName = initMostOutName;
    Record.bEnable = bEnable;
    Record.bInitHidden = bInitHidden;
}

simulated event PostBeginPlay()
{
    PostBeginPlay();
    Health = DamageLimit;
    AliceCheckPointManager(WorldInfo.Game.MyCheckPointManager).RegisterWhenPostBeginPlay(self);
}

state ActivateState
{
    event EndState(name NextStateName)
    {
        DestroyParticle.DeactivateSystem();
    }
    
    event BeginState(name PreviousStateName)
    {
        NoseState = 7;
        DestroyParticle.SetActive(true);
        if (AudioIdle != none)
        {
            AudioIdle.Stop();
        }
        if (!bHidden && AudioActive != none)
        {
            AudioActive.Play();
        }
        TriggerEventClass(class'Engine.SeqEvent_Destroyed', EventInst);
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
    }
    
    event BeginState(name PreviousStateName)
    {
        NoseState = 6;
        ReliefTime = 0.0;
        if (!bHidden && AudioRelief != none)
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
            AliceCheckPointManager(WorldInfo.Game.MyCheckPointManager).UpdateRegisterWhenChange(self, initMostOutName, initActorFName);
            WakeNose();
            statistic_Trophy_And_PData();
        }
        else if (Health < DamageLimit * 0.2)
        {
            NoseState = 5;
        }
        else if (Health < DamageLimit * 0.4)
        {
            NoseState = 4;
        }
        else if (Health < DamageLimit * 0.6)
        {
            NoseState = 3;
        }
        else if (Health < DamageLimit * 0.8)
        {
            NoseState = 2;
        }
        StopHitTime += DeltaTime;
        if (StopHitTime > 1.5)
        {
            GotoState('ReliefState');
        }
    }
    
    event EndState(name NextStateName)
    {
        ChargeParticle.DeactivateSystem();
        StopHitTime = 0.0;
        if (AudioCharge != none)
        {
            AudioCharge.Stop();
        }
    }
    
    event BeginState(name PreviousStateName)
    {
        ChargeParticle.SetActive(true);
        NoseState = 1;
        if (!bHidden && AudioCharge != none)
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
        IdleParticle.SetActive(true);
        NoseState = 0;
        if (!bHidden && AudioIdle != none)
        {
            AudioIdle.Play();
        }
        Health = DamageLimit;
    }
    
    Stop;
}

state DisableState
{
    event BeginState(name PreviousStateName)
    {
        if (AudioIdle != none)
        {
            AudioIdle.Stop();
        }
        if (AudioCharge != none)
        {
            AudioCharge.Stop();
        }
        if (AudioRelief != none)
        {
            AudioRelief.Stop();
        }
        if (AudioActive != none)
        {
            AudioActive.Stop();
        }
    }
    
    Stop;
}

defaultproperties
{
    bEnable=True
    HitRangeDistance=100.0
    AudioActive="Default__NoseActorBase.Active"
    AudioIdle="Default__NoseActorBase.Idle"
    AudioCharge="Default__NoseActorBase.Charge"
    AudioRelief="Default__NoseActorBase.Relief"
    DestroyParticle="Default__NoseActorBase.DP"
    IdleParticle="Default__NoseActorBase.IP"
    ChargeParticle="Default__NoseActorBase.CP"
    DelayTimeToDestroy=2.5
    DamageLimit=130.0
    SoundRadius=500.0
    Health=100.0
    HitPerShot=5.0
    SkeletalMeshComponent="Default__NoseActorBase.SkeletalMeshComponent0"
    LightEnvironment="Default__NoseActorBase.MyLightEnvironment"
    FacialAudioComp="Default__NoseActorBase.FaceAudioComponent"
    bNoDelete=False
    bCanBeDamaged=True
    BlockRigidBody=True
    bCollideActors=True
    bCollideWorld=True
    Components(0)="Default__NoseActorBase.MyLightEnvironment"
    Components(1)="Default__NoseActorBase.SkeletalMeshComponent0"
    Components(2)="Default__NoseActorBase.FaceAudioComponent"
    Components(3)="Default__NoseActorBase.CollisionCylinder"
    Components(4)="Default__NoseActorBase.Active"
    Components(5)="Default__NoseActorBase.Idle"
    Components(6)="Default__NoseActorBase.Relief"
    Components(7)="Default__NoseActorBase.Charge"
    Components(8)="Default__NoseActorBase.DP"
    Components(9)="Default__NoseActorBase.IP"
    Components(10)="Default__NoseActorBase.CP"
    InitialState="IdleState"
    CollisionComponent="Default__NoseActorBase.CollisionCylinder"
}

class ShrinkFlowerInteractive extends SkeletalMeshActor
    native
    placeable
    hidecategories(Navigation);

struct CheckpointRecord
{
    var string initMostOutName;
    var string initActorFName;
    var bool bPickedSaveInPdata;
};

var() float ActiveRadius;
var() float InteractiveRadius;
var() name IdleAnim;
var() name ActivedAnim;
var() name CloseAnim;
var() name EatAliceAnim;
var() name ShootingAnim;
var() ParticleSystem ActivedParticle;
var() ParticleSystem ShootingPetalsParticle;
var() string UITextToDisplay;
var AlicePawn Alice;
var float curShootAnimTime;
var float curCloseAnimTime;
var export editinline ParticleSystemComponent ShootingParticleComponent;
var DropItemsFactory DropFactory;
var(HP) HealthPickup LargeHealthPickupArchetype;
var(HP) HealthPickup SmallHealthPickupArchetype;
var(HP) int ManualHPAmountEasy;
var(HP) int ManualHPAmountNormal;
var(HP) int ManualHPAmountHard;
var(HP) int ManualHPAmountVeryHard;
var(HP) bool UseSmartHealthSpawn;
var(XP) bool CanSpawnXP;
var bool bPickedSaveInPdata;
var(XP) XPPickup LargeXPPickupArchetype;
var(XP) XPPickup SmallXPPickupArchetype;
var(XP) int ManualXPAmountEasy;
var(XP) int ManualXPAmountNormal;
var(XP) int ManualXPAmountHard;
var(XP) int ManualXPAmountVeryHard;
var export editinline DecalComponent Decal;
var() MaterialInterface DecalMaterial;
var() float DecalWidth;
var() float DecalHeight;
var transient string initMostOutName;
var transient string initActorFName;

function int GetManualXPAmount()
{
    switch (AliceGameInfo(WorldInfo.Game).getCurrentGameDifficulty())
    {
        case 0:
            return ManualXPAmountEasy;
            break;
        case 1:
            return ManualXPAmountNormal;
            break;
        case 2:
            return ManualXPAmountHard;
            break;
        case 3:
            return ManualXPAmountVeryHard;
            break;
        default:
    }
}

function int GetManualHPAmount()
{
    switch (AliceGameInfo(WorldInfo.Game).getCurrentGameDifficulty())
    {
        case 0:
            return ManualHPAmountEasy;
            break;
        case 1:
            return ManualHPAmountNormal;
            break;
        case 2:
            return ManualHPAmountHard;
            break;
        case 3:
            return ManualHPAmountVeryHard;
            break;
        default:
    }
}

function DropPickup(class<Actor> ClassType)
{
    if (DropFactory == none)
    {
        DropFactory = Spawn(class'DropItemsFactory');
    }
    if (DropFactory != none)
    {
        DropFactory.SetHealthArchetype(LargeHealthPickupArchetype, SmallHealthPickupArchetype);
        DropFactory.SetXPArchetype(LargeXPPickupArchetype, SmallXPPickupArchetype);
        DropFactory.DropPickupsForGBA(true, true, UseSmartHealthSpawn, GetManualHPAmount(), GetManualXPAmount(), 0, 100);
    }
}

function float DistanceToAlice()
{
    local float dis;
    local Vector Loc;
    
    Loc = Alice.Location;
    if (!Alice.bShrinkingModeActive)
    {
        Loc.Z -= float(70);
    }
    else
    {
        Loc.Z -= float(35);
    }
    dis = VSize(Loc - Location);
    return dis;
}

function CreateDecal(Vector Loc, Vector Normal)
{
    if (DecalMaterial != none)
    {
        Decal = WorldInfo.MyDecalManager.SpawnDecal(DecalMaterial, Loc, rotator(-Normal), DecalWidth, DecalHeight, 100.0, true);
    }
}

simulated event PostBeginPlay()
{
    PostBeginPlay();
    CreateDecal(Location, vect(0.0, 0.0, 1000.0));
    AliceCheckPointManager(WorldInfo.Game.MyCheckPointManager).RegisterWhenPostBeginPlay(self);
}

event UpdateAfterAcceptPersistentDate()
{
    if (bPickedSaveInPdata)
    {
        GotoState('Finished');
    }
    else
    {
        GotoState('Idle');
    }
}

function ApplyCheckpointRecord(out const CheckpointRecord Record)
{
    AliceCheckPointManager(WorldInfo.Game.MyCheckPointManager).UnRegisterWhenApplyRecord(self, initMostOutName, initActorFName);
    bPickedSaveInPdata = Record.bPickedSaveInPdata;
    initActorFName = Record.initActorFName;
    initMostOutName = Record.initMostOutName;
    AliceCheckPointManager(WorldInfo.Game.MyCheckPointManager).RegisterWhenApplyRecord(self, initMostOutName, initActorFName);
    if (bPickedSaveInPdata)
    {
        GotoState('Finished');
    }
    else
    {
        GotoState('Idle');
    }
}

function CreateCheckpointRecord(out CheckpointRecord Record)
{
    Record.bPickedSaveInPdata = bPickedSaveInPdata;
    Record.initActorFName = initActorFName;
    Record.initMostOutName = initMostOutName;
}

state Finished
{
    event BeginState(name PreviousStateName)
    {
        SetHidden(true);
        bPickedSaveInPdata = true;
        AliceCheckPointManager(WorldInfo.Game.MyCheckPointManager).UpdateRegisterWhenChange(self, initMostOutName, initActorFName);
    }
    
    Stop;
}

state Shooting
{
    event EndState(name NextStateName)
    {
        DropPickup(class'HealthPickup');
        DropPickup(class'XPPickup');
    }
    
    event Tick(float DeltaTime)
    {
        local AnimNodeSequence SeqNode;
        
        SeqNode = AnimNodeSequence(SkeletalMeshComponent.Animations);
        if (SeqNode != none)
        {
            curShootAnimTime += DeltaTime;
            if (curShootAnimTime >= SeqNode.AnimSeq.SequenceLength * 0.5)
            {
                GotoState('Finished');
            }
        }
    }
    
    event BeginState(name PreviousStateName)
    {
        local AnimNodeSequence SeqNode;
        
        curShootAnimTime = 0.0;
        SeqNode = AnimNodeSequence(SkeletalMeshComponent.Animations);
        if (SeqNode != none)
        {
            SeqNode.SetAnim(ShootingAnim);
            SeqNode.PlayAnim(false, SeqNode.Rate, 0.0);
        }
        SkeletalMeshComponent.SetHidden(true);
        ShootingParticleComponent.SetTemplate(ShootingPetalsParticle);
        ShootingParticleComponent.ActivateSystem();
    }
    
    Stop;
}

state Eating
{
    event Tick(float DeltaTime)
    {
        if (!Alice.bShrinkingModeActive)
        {
            Alice.DoSpecialMove(69, true);
            PlayerController(Alice.Controller).IgnoreMoveInput(false);
            Alice.bJumpCapable = true;
            Alice.SetPhysics(2);
            Alice.Velocity = vect(0.0, 0.0, 750.0);
            Alice.Acceleration = vect(0.0, 0.0, 0.0);
            GotoState('Shooting');
        }
    }
    
    event EndState(name NextStateName)
    {
        Alice.bShrinkFlowerEating = false;
    }
    
    event BeginState(name PreviousStateName)
    {
        local AnimNodeSequence SeqNode;
        
        SeqNode = AnimNodeSequence(SkeletalMeshComponent.Animations);
        if (SeqNode != none)
        {
            SeqNode.SetAnim(EatAliceAnim);
            SeqNode.PlayAnim(true, SeqNode.Rate, 0.0);
        }
        Alice.bShrinkFlowerEating = true;
    }
    
    Stop;
}

state FlowerClose
{
    event Tick(float DeltaTime)
    {
        local AnimNodeSequence SeqNode;
        
        SeqNode = AnimNodeSequence(SkeletalMeshComponent.Animations);
        if (SeqNode != none)
        {
            curCloseAnimTime += DeltaTime;
            if (curCloseAnimTime >= SeqNode.AnimSeq.SequenceLength)
            {
                GotoState('Eating');
            }
        }
    }
    
    event BeginState(name PreviousStateName)
    {
        local Vector Loc;
        local AnimNodeSequence SeqNode;
        
        SeqNode = AnimNodeSequence(SkeletalMeshComponent.Animations);
        if (SeqNode != none)
        {
            SeqNode.SetAnim(CloseAnim);
            SeqNode.PlayAnim(false, SeqNode.Rate, 0.0);
        }
        curCloseAnimTime = 0.0;
        Loc.X = Location.X;
        Loc.Y = Location.Y;
        Loc.Z = Alice.Location.Z;
        Alice.SetLocation(Loc);
        PlayerController(Alice.Controller).IgnoreMoveInput(true);
        Alice.bJumpCapable = false;
    }
    
    Stop;
}

state Actived
{
    event Tick(float DeltaTime)
    {
        local float dis;
        
        dis = DistanceToAlice();
        if (dis < InteractiveRadius && Alice.bShrinkingModeActive)
        {
            GotoState('FlowerClose');
        }
        if (dis > ActiveRadius)
        {
            GotoState('Idle');
        }
    }
    
    event BeginState(name PreviousStateName)
    {
        local AnimNodeSequence SeqNode;
        
        SeqNode = AnimNodeSequence(SkeletalMeshComponent.Animations);
        if (SeqNode != none)
        {
            SeqNode.SetAnim(ActivedAnim);
            SeqNode.PlayAnim(true, SeqNode.Rate, 0.0);
        }
    }
    
    Stop;
}

state Idle
{
    event EndState(name NextStateName)
    {
    }
    
    event Tick(float DeltaTime)
    {
        local AlicePawn A;
        
        A = AlicePawn(WorldInfo.GetLocalPlayerPawn());
        if (A != none && VSize(A.Location - Location) < ActiveRadius)
        {
            Alice = A;
            GotoState('Actived');
        }
    }
    
    event BeginState(name PreviousStateName)
    {
        local AnimNodeSequence SeqNode;
        
        SeqNode = AnimNodeSequence(SkeletalMeshComponent.Animations);
        if (SeqNode != none)
        {
            SeqNode.SetAnim(IdleAnim);
            SeqNode.PlayAnim(true, SeqNode.Rate, 0.0);
        }
    }
    
    Stop;
}

defaultproperties
{
    ActiveRadius=512.0
    InteractiveRadius=36.0
    ShootingParticleComponent="Default__ShrinkFlowerInteractive.spc"
    LargeHealthPickupArchetype="Pickup_ArcheType.HealthPickup_Large_Archetype"
    SmallHealthPickupArchetype="Pickup_ArcheType.HealthPickup_Small_Archetype"
    ManualHPAmountEasy=10
    ManualHPAmountNormal=10
    ManualHPAmountHard=10
    ManualHPAmountVeryHard=10
    UseSmartHealthSpawn=True
    LargeXPPickupArchetype="Pickup_ArcheType.XPPickup_Large_Breakable"
    SmallXPPickupArchetype="Pickup_ArcheType.XPPickup_Small_Breakable"
    ManualXPAmountEasy=10
    ManualXPAmountNormal=10
    ManualXPAmountHard=10
    ManualXPAmountVeryHard=10
    DecalWidth=1000.0
    DecalHeight=1000.0
    SkeletalMeshComponent="Default__ShrinkFlowerInteractive.SkeletalMeshComponent0"
    LightEnvironment="Default__ShrinkFlowerInteractive.MyLightEnvironment"
    FacialAudioComp="Default__ShrinkFlowerInteractive.FaceAudioComponent"
    bNoDelete=False
    Components(0)="Default__ShrinkFlowerInteractive.MyLightEnvironment"
    Components(1)="Default__ShrinkFlowerInteractive.SkeletalMeshComponent0"
    Components(2)="Default__ShrinkFlowerInteractive.FaceAudioComponent"
    Components(3)="Default__ShrinkFlowerInteractive.spc"
    InitialState="Idle"
    CollisionComponent="Default__ShrinkFlowerInteractive.SkeletalMeshComponent0"
}

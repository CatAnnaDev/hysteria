class DoomGameBreakableActor extends GameBreakableActor
    native
    placeable
    config(Game);

var() bool bBreakable;
var bool bEnableMaterialChange;
var() bool bAchievement34DoomBarrier;
var() float ParameterMaxValue;
var() float ParameterMinValue;
var() float MaterialChangeTime;
var() name ParameterName;
var float CurrentTime;

simulated function TakeRadiusDamage(Controller InstigatedBy, float BaseDamage, float DamageRadius, class<DamageType> DamageType, float Momentum, Vector HurtOrigin, bool bFullDamage, Actor DamageCauser, optional float DamageFalloffExponent = 1.0)
{
    if (bBreakable)
    {
        TakeRadiusDamage(InstigatedBy, BaseDamage, DamageRadius, DamageType, Momentum, HurtOrigin, bFullDamage, DamageCauser, DamageFalloffExponent);
    }
}

event TakeDamage(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    if (bBreakable)
    {
        TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
        if (bAchievement34DoomBarrier)
        {
            if (!bSkipPlaySoundAfterCheckPoint)
            {
                if (DamageType == class'DmgType_TeapotCannon_RangeProjectile')
                {
                    AlicePlayerController(EventInstigator).DestroyedDoomBarriers++;
                    LogInternal("Barriesr add to " @ string(AlicePlayerController(EventInstigator).DestroyedDoomBarriers));
                    if (AlicePlayerController(EventInstigator).DestroyedDoomBarriers >= 10)
                    {
                        ConsoleCommand("trophy unlock=34");
                    }
                }
                else if (DamageType == class'DmgType_HobbyHorse_Melee' && Damage > 0)
                {
                    AlicePlayerController(EventInstigator).DestroyedDoomBarriers++;
                    LogInternal("Barriesr add to " @ string(AlicePlayerController(EventInstigator).DestroyedDoomBarriers));
                    if (AlicePlayerController(EventInstigator).DestroyedDoomBarriers >= 10)
                    {
                        ConsoleCommand("trophy unlock=34");
                    }
                }
            }
        }
    }
}

event Tick(float DeltaTime)
{
    Tick(DeltaTime);
    if (bEnableMaterialChange)
    {
        ChangingMaterail(DeltaTime);
    }
}

function ChangingMaterail(float DeltaTime)
{
    local int I;
    local MaterialInstance Mat;
    
    CurrentTime += DeltaTime;
    for (I = 0; I < StaticMeshComponent.GetNumElements(); I++)
    {
        Mat = StaticMeshComponent.CreateAndSetMaterialInstanceConstant(I);
        if (Mat != none)
        {
            Mat.SetScalarParameterValue(ParameterName, CurrentTime / MaterialChangeTime * (ParameterMaxValue - ParameterMinValue) + ParameterMinValue);
        }
    }
    if (CurrentTime >= MaterialChangeTime)
    {
        EndChangeMaterial();
    }
}

function EndChangeMaterial()
{
    bBreakable = true;
    bEnableMaterialChange = false;
}

function BeginChangeMaterial()
{
    if (CurrentTime < MaterialChangeTime)
    {
        bEnableMaterialChange = true;
    }
}

simulated event OnToggleDoomGameBreakable(SeqAct_ToggleDoomGameBreakable Action)
{
    if (Action.InputLinks[0].bHasImpulse)
    {
        bBreakable = true;
        BeginChangeMaterial();
    }
    else if (Action.InputLinks[1].bHasImpulse)
    {
        bBreakable = false;
    }
    else if (Action.InputLinks[2].bHasImpulse)
    {
        bBreakable = !bBreakable;
    }
}

simulated event PostBeginPlay()
{
    PostBeginPlay();
}

event UpdateAfterAcceptPersistentDate()
{
    if (bDestoryed)
    {
        CanSpawnHealth = false;
        CanSpawnXP = false;
        TakeDamage(10000, none, vect(0.0, 0.0, 0.0), vect(0.0, 0.0, 0.0), class'Engine.DmgType_Crushed');
        TakeDamage(10000, none, vect(0.0, 0.0, 0.0), vect(0.0, 0.0, 0.0), class'DmgType_HobbyHorse_Melee');
    }
    if (bBreakable)
    {
        BeginChangeMaterial();
    }
}

function ApplyCheckpointRecord(out const CheckpointRecord Record)
{
    AliceCheckPointManager(WorldInfo.Game.MyCheckPointManager).UnRegisterWhenApplyRecord(self, initMostOutName, initActorFName);
    bDestoryed = Record.bDestoryed;
    bBreakable = Record.Breakable;
    initActorFName = Record.initActorFName;
    initMostOutName = Record.initMostOutName;
    AliceCheckPointManager(WorldInfo.Game.MyCheckPointManager).RegisterWhenApplyRecord(self, initMostOutName, initActorFName);
    InitialLocation = Record.Location;
    InitialRotation = Record.Rotation;
    InitialPhysics = Record.InitialPhysics;
    CanSpawnHealth = Record.CanSpawnHealth;
    CanSpawnXP = Record.CanSpawnXP;
    StaticMeshComponent.WakeRigidBody();
    StaticMeshComponent.SetRBLinearVelocity(vect(0.0, 0.0, 0.0));
    StaticMeshComponent.SetRBAngularVelocity(vect(0.0, 0.0, 0.0));
    StaticMeshComponent.SetRBPosition(InitialLocation);
    StaticMeshComponent.SetRBRotation(InitialRotation);
    StaticMeshComponent.PutRigidBodyToSleep();
    StaticMeshComponent.SetHidden(true);
    SetHidden(false);
    StaticMeshComponent.SetStaticMesh(InitialStaticMesh);
    StaticMeshComponent.SetHidden(false);
    StaticMeshComponent.SetRBLinearVelocity(vect(0.0, 0.0, 0.0));
    StaticMeshComponent.SetRBAngularVelocity(vect(0.0, 0.0, 0.0));
    StaticMeshComponent.SetRBPosition(InitialLocation);
    StaticMeshComponent.SetRBRotation(InitialRotation);
    SetPhysics(InitialPhysics);
    ResolveRBState();
    if (CollisionComponent != none)
    {
        CollisionComponent.SetBlockRigidBody(true);
    }
    LastImpactDamageTime = 0.0;
    CurrentBreakableStep = 0;
    GotoState('None');
    if (bDestoryed)
    {
        TakeDamage(10000, none, vect(0.0, 0.0, 0.0), vect(0.0, 0.0, 0.0), class'Engine.DmgType_Crushed');
        TakeDamage(10000, none, vect(0.0, 0.0, 0.0), vect(0.0, 0.0, 0.0), class'DmgType_HobbyHorse_Melee');
    }
    if (bBreakable)
    {
        BeginChangeMaterial();
    }
}

function bool GetIsBreakAble()
{
    return bBreakable;
}

defaultproperties
{
    bAchievement34DoomBarrier=True
    ParameterMaxValue=1.0
    MaterialChangeTime=3.0
    ParameterName="DBAMorph"
    ImpulseComponent="Default__DoomGameBreakableActor.ImpulseComponent0"
    RenderComponent="Default__DoomGameBreakableActor.DrawSphere0"
    StaticMeshComponent="Default__DoomGameBreakableActor.StaticMeshComponent0"
    LightEnvironment="Default__DoomGameBreakableActor.MyLightEnvironment"
    Components(0)="Default__DoomGameBreakableActor.MyLightEnvironment"
    Components(1)="Default__DoomGameBreakableActor.StaticMeshComponent0"
    Components(2)="Default__DoomGameBreakableActor.Sprite"
    Components(3)="Default__DoomGameBreakableActor.DrawSphere0"
    Components(4)="Default__DoomGameBreakableActor.ImpulseComponent0"
    CollisionComponent="Default__DoomGameBreakableActor.StaticMeshComponent0"
}

class Turret2DManager extends Actor
    native
    placeable
    hidecategories(Navigation);

enum ECycleMode
{
    ECM_Random,
    ECM_Cycle,
};

var() float RateOfFire;
var() float ProjLifeTime;
var() float projSpeed;
var() int MaxProjOnScreen;
var() array<Alice2DTurret> Turret2D_Array;
var() ECycleMode CycleMode;
var AlicePlayerController MyPC;
var AlicePawn MyTrigger;
var bool bActive;
var bool bLoadReady;
var bool bKeepFiring;
var bool bAutoFire;
var int NumberOfProj;
var int curTurretIndex;
var float NextFireTime;

event Tick(float DeltaTime)
{
    Tick(DeltaTime);
    if (NextFireTime > float(0))
    {
        NextFireTime -= DeltaTime;
        if (NextFireTime <= float(0))
        {
            bLoadReady = true;
        }
    }
    if (!bAutoFire)
    {
        return;
    }
    bAutoFire = bKeepFiring;
    Fire();
}

function bool CheckActorType(Actor Obj)
{
    local BounceVolume BV;
    local SkeletalMeshActor sma;
    local InterpActor ipa;
    local RailRideActor Boat;
    local Alice2DTurret Turret2D;
    
    Turret2D = Alice2DTurret(Obj);
    if (Turret2D != none)
    {
        return true;
    }
    BV = BounceVolume(Obj);
    if (BV != none)
    {
        return true;
    }
    Boat = RailRideActor(Obj);
    if (Boat != none)
    {
        return false;
    }
    sma = SkeletalMeshActor(Obj);
    if (sma != none)
    {
        return true;
    }
    ipa = InterpActor(Obj);
    if (ipa != none)
    {
        return true;
    }
    return false;
}

function OnLoadReady()
{
    bLoadReady = true;
}

function Fire()
{
    if (!bActive)
    {
        return;
    }
    if (Turret2D_Array.Length <= 0)
    {
        return;
    }
    if (NumberOfProj >= MaxProjOnScreen || !bLoadReady)
    {
        return;
    }
    if (CycleMode == 0)
    {
        curTurretIndex = int(RandRange(0.0, float(Turret2D_Array.Length) - 0.01));
    }
    Turret2D_Array[curTurretIndex].Fire(self);
    NextFireTime = RateOfFire;
    if (CycleMode != 0)
    {
        curTurretIndex++;
        if (curTurretIndex >= Turret2D_Array.Length)
        {
            curTurretIndex = 0;
        }
    }
    bLoadReady = false;
}

simulated function OnToggle(SeqAct_Toggle Action)
{
    if (Action.InputLinks[0].bHasImpulse)
    {
        bActive = true;
    }
    else if (Action.InputLinks[1].bHasImpulse)
    {
        bActive = false;
    }
    else if (Action.InputLinks[2].bHasImpulse)
    {
        bActive = !bActive;
    }
    SetActive(bActive);
    if (bActive)
    {
        MyPC.AliceTurret2DManager.AddItem(self);
    }
    else
    {
        MyPC.AliceTurret2DManager.RemoveItem(self);
    }
}

native function SetActive(bool _bActive)
{
    _bActive;
}

defaultproperties
{
    RateOfFire=1.0
    ProjLifeTime=3.0
    projSpeed=10.0
    MaxProjOnScreen=3
    bLoadReady=True
    Components(0)="Default__Turret2DManager.Sprite"
    CollisionType="COLLIDE_CustomDefault"
}

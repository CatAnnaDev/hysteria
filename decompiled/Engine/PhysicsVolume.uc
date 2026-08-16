class PhysicsVolume extends Volume
    native
    nativereplication
    placeable
    hidecategories(Navigation,Object,Movement,Display);

struct CheckpointRecord
{
    var bool bPainCausing;
};

var() interp Vector ZoneVelocity;
var() bool bVelocityAffectsWalking;
var() bool bPainCausing;
var() bool bAIShouldIgnorePain;
var() bool bEntryPain;
var bool BACKUP_bPainCausing;
var() bool bDestructive;
var() bool bNoInventory;
var() bool bMoveProjectiles;
var() bool bBounceVelocity;
var() bool bNeutralZone;
var() bool bCrowdAgentsPlayDeathAnim;
var() bool bPhysicsOnContact;
var bool bWaterVolume;
var() float GroundFriction;
var() float TerminalVelocity;
var() float DamagePerSec;
var() class<DamageType> DamageType;
var() int Priority;
var() float FluidFriction;
var() float PainInterval;
var() float RigidBodyDamping;
var() float MaxDampingForce;
var Info PainTimer;
var Controller DamageInstigator;
var PhysicsVolume NextPhysicsVolume;

function ApplyCheckpointRecord(out const CheckpointRecord Record)
{
    bPainCausing = Record.bPainCausing;
}

function CreateCheckpointRecord(out CheckpointRecord Record)
{
    Record.bPainCausing = bPainCausing;
}

function bool ShouldSaveForCheckpoint()
{
    return bPainCausing != BACKUP_bPainCausing;
}

function OnSetDamageInstigator(SeqAct_SetDamageInstigator Action)
{
    DamageInstigator = Action.GetController(Action.DamageInstigator);
}

function NotifyPawnBecameViewTarget(Pawn P, PlayerController PC)
{
}

function ModifyPlayer(Pawn PlayerPawn)
{
}

function CausePainTo(Actor Other)
{
    if (DamagePerSec > float(0))
    {
        if (WorldInfo.bSoftKillZ && Other.Physics != 1)
        {
            return;
        }
        if (DamageType == none || DamageType == class'DamageType')
        {
            LogInternal("No valid damagetype (" $ string(DamageType) $ ") specified for " $ PathName(self));
        }
        Other.TakeDamage(int(DamagePerSec * PainInterval), DamageInstigator, Location, vect(0.0, 0.0, 0.0), DamageType, , self);
    }
    else
    {
        Other.HealDamage(int(-DamagePerSec * PainInterval), DamageInstigator, DamageType);
    }
}

simulated event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    Touch(Other, OtherComp, HitLocation, HitNormal);
    if (Other == none || Other.bStatic)
    {
        return;
    }
    if (bNoInventory && DroppedPickup(Other) != none && Other.Owner == none)
    {
        Other.LifeSpan = 1.5;
        return;
    }
    if (bMoveProjectiles && ZoneVelocity != vect(0.0, 0.0, 0.0))
    {
        if (Other.Physics == 6)
        {
            Other.Velocity += ZoneVelocity;
        }
        else if (Other.Base == none && Other.IsA('Emitter') && Other.Physics == 0)
        {
            Other.SetPhysics(6);
            Other.Velocity += ZoneVelocity;
        }
    }
    if (bPainCausing)
    {
        if (Other.bDestroyInPainVolume)
        {
            Other.VolumeBasedDestroy(self);
            return;
        }
        if (bEntryPain && Other.bCanBeDamaged)
        {
            CausePainTo(Other);
        }
    }
}

function TimerPop(VolumeTimer T)
{
    local Actor A;
    
    if (T == PainTimer)
    {
        if (!bPainCausing)
        {
            return;
        }
        foreach TouchingActors(class'Actor', A)
        {
            if (A.bCanBeDamaged && !A.bStatic)
            {
                CausePainTo(A);
            }
        }
    }
}

simulated event CollisionChanged()
{
}

simulated function OnToggle(SeqAct_Toggle inAction)
{
    if (!bStatic || RemoteRole > 0)
    {
        OnToggle(inAction);
    }
    if (inAction.InputLinks[0].bHasImpulse)
    {
        bPainCausing = BACKUP_bPainCausing;
    }
    else if (inAction.InputLinks[1].bHasImpulse)
    {
        bPainCausing = false;
    }
    else if (inAction.InputLinks[2].bHasImpulse)
    {
        bPainCausing = !bPainCausing && BACKUP_bPainCausing;
    }
}

event PawnLeavingVolume(Pawn Other)
{
}

event PawnEnteredVolume(Pawn Other)
{
}

event ActorLeavingVolume(Actor Other)
{
}

event ActorEnteredVolume(Actor Other)
{
}

event PhysicsChangedFor(Actor Other)
{
}

function Reset()
{
    bPainCausing = BACKUP_bPainCausing;
    bForceNetUpdate = true;
}

simulated event PostBeginPlay()
{
    PostBeginPlay();
    BACKUP_bPainCausing = bPainCausing;
    if (Role < 3)
    {
        return;
    }
    if (bPainCausing)
    {
        PainTimer = Spawn(class'VolumeTimer', self);
    }
}

native function Vector GetZoneVelocityForActor(Actor TheActor)
{
    TheActor;
}

native function float GetGravityZ()
{
}

defaultproperties
{
    bVelocityAffectsWalking=True
    bEntryPain=True
    GroundFriction=8.0
    TerminalVelocity=3500.0
    DamageType="DamageType"
    FluidFriction=0.3
    PainInterval=1.0
    MaxDampingForce=1000000.0
    BrushComponent="Default__PhysicsVolume.BrushComponent0"
    bAlwaysRelevant=True
    bOnlyDirtyReplication=True
    bForceAllowKismetModification=True
    Components(0)="Default__PhysicsVolume.BrushComponent0"
    NetUpdateFrequency=0.1
    CollisionComponent="Default__PhysicsVolume.BrushComponent0"
}

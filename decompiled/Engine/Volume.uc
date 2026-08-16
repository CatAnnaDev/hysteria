class Volume extends Brush
    native
    nativereplication
    notplaceable
    hidecategories(Navigation,Object,Movement,Display);

var Actor AssociatedActor;
var(Location) int LocationPriority;
var(Location) const localized string LocationName;
var() bool bForcePawnWalk;
var() bool bProcessAllActors;

event ProcessActorSetVolume(Actor Other)
{
}

simulated event CollisionChanged()
{
    CollisionComponent.SetBlockRigidBody(bCollideActors && bBlockActors);
}

simulated function OnToggle(SeqAct_Toggle Action)
{
    if (Action.InputLinks[0].bHasImpulse)
    {
        if (!bCollideActors)
        {
            SetCollision(true, bBlockActors);
        }
    }
    else if (Action.InputLinks[1].bHasImpulse)
    {
        if (bCollideActors)
        {
            SetCollision(false, bBlockActors);
        }
    }
    else if (Action.InputLinks[2].bHasImpulse)
    {
        SetCollision(!bCollideActors, bBlockActors);
    }
    ForceNetRelevant();
    SetForcedInitialReplicatedProperty(BoolProperty'Actor.bCollideActors', bCollideActors == default.bCollideActors);
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
    DisplayDebug(HUD, out_YL, out_YPos);
    HUD.Canvas.DrawText("AssociatedActor " $ string(AssociatedActor), false);
    out_YPos += out_YL;
    HUD.Canvas.SetPos(4.0, out_YPos);
}

simulated function string GetLocationStringFor(PlayerReplicationInfo PRI)
{
    return LocationName;
}

event PostBeginPlay()
{
    PostBeginPlay();
    if (AssociatedActor != none)
    {
        GotoState('AssociatedTouch');
        InitialState = GetStateName();
    }
}

function ApplyWind(Actor Actor)
{
}

native function bool EncompassesPoint(Vector Loc)
{
    Loc;
}

native function bool Encompasses(Actor Other)
{
    Other;
}

state AssociatedTouch
{
    event BeginState(name PreviousStateName)
    {
        local Actor A;
        
        foreach TouchingActors(class'Actor', A)
        {
            Touch(A, none, A.Location, vect(0.0, 0.0, 1.0));
        }
    }
    
    event UnTouch(Actor Other)
    {
        AssociatedActor.UnTouch(Other);
    }
    
    event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
    {
        AssociatedActor.Touch(Other, OtherComp, HitLocation, HitNormal);
    }
    
    Stop;
}

defaultproperties
{
    BrushComponent="Default__Volume.BrushComponent0"
    bSkipActorPropertyReplication=True
    bCollideActors=True
    Components(0)="Default__Volume.BrushComponent0"
    CollisionComponent="Default__Volume.BrushComponent0"
}

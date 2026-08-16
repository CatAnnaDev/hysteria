class ReachSpec extends Object
    native
    notplaceable;

const BLOCKEDPATHCOST = 10000000;

var const native transient editconst Pointer NavOctreeObject;
var int Distance;
var Vector Direction;
var() const editconst NavigationPoint Start;
var() const editconst ActorReference End;
var() const editconst int CollisionRadius;
var() const editconst int CollisionHeight;
var int reachFlags;
var int MaxLandingVelocity;
var byte bPruned;
var byte PathColorIndex;
var const editconst bool bAddToNavigationOctree;
var bool bCanCutCorners;
var bool bCheckForObstructions;
var const bool bSkipPrune;
var() editconst bool bDisabled;
var const array<class<ReachSpec>> PruneSpecList;
var Actor BlockedBy;

function bool IsBlockedFor(Pawn P)
{
    return CostFor(P) >= 10000000;
}

native final function Vector GetDirection()
{
}

native final function NavigationPoint GetEnd()
{
}

native final function int CostFor(Pawn P)
{
    P;
}

defaultproperties
{
    bAddToNavigationOctree=True
    bCanCutCorners=True
    bCheckForObstructions=True
}

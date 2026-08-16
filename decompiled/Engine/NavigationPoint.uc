class NavigationPoint extends Actor
    native
    notplaceable
    hidecategories(Navigation,Lighting,LightColor,Force);

const INFINITE_PATH_COST = 10000000;

struct native DebugNavCost
{
    var string Desc;
    var int Cost;
};

struct native NavigationOctreeObject
{
    var Box BoundingBox;
    var Vector BoxCenter;
    var const native transient Pointer OctreeNode;
    var const noexport Object Owner;
    var const noexport byte OwnerType;
};

var transient bool bEndPoint;
var transient bool bTransientEndPoint;
var transient bool bHideEditorPaths;
var transient bool bCanReach;
var() bool bBlocked;
var() bool bOneWayPath;
var bool bNeverUseStrafing;
var bool bAlwaysUseStrafing;
var const bool bForceNoStrafing;
var const bool bAutoBuilt;
var bool bSpecialMove;
var bool bNoAutoConnect;
var const bool bNotBased;
var const bool bPathsChanged;
var bool bDestinationOnly;
var bool bSourceOnly;
var bool bSpecialForced;
var bool bMustBeReachable;
var bool bBlockable;
var bool bFlyingPreferred;
var bool bMayCausePain;
var transient bool bAlreadyVisited;
var() bool bVehicleDestination;
var() bool bMakeSourceOnly;
var bool bMustTouchToReach;
var bool bCanWalkOnToReach;
var bool bBuildLongPaths;
var(VehicleUsage) bool bBlockedForVehicles;
var(VehicleUsage) bool bPreferredVehiclePath;
var const bool bHasCrossLevelPaths;
var transient bool bShouldSaveForCheckpoint;
var const native transient NavigationOctreeObject NavOctreeObject;
var() const duplicatetransient editconst editinline array<ReachSpec> PathList;
var duplicatetransient editoronly array<ActorReference> EditorProscribedPaths;
var duplicatetransient editoronly array<ActorReference> EditorForcedPaths;
var() const editconst array<ActorReference> Volumes;
var int visitedWeight;
var const int bestPathWeight;
var const NavigationPoint nextNavigationPoint;
var const NavigationPoint nextOrdered;
var const NavigationPoint prevOrdered;
var const NavigationPoint previousPath;
var int Cost;
var() int ExtraCost;
var transient int TransientCost;
var transient int FearCost;
var transient array<DebugNavCost> CostArray;
var DroppedPickup InventoryCache;
var float InventoryDist;
var const float LastDetourWeight;
var export editinline CylinderComponent CylinderComponent;
var() const editconst Cylinder MaxPathSize;
var() const duplicatetransient editconst Guid NavGuid;
var const transient export editinline SpriteComponent GoodSprite;
var const transient export editinline SpriteComponent BadSprite;
var() const editconst int NetworkID;
var transient Pawn AnchoredPawn;
var transient float LastAnchoredPawnTime;

simulated event string GetDebugAbbrev()
{
    return "NP?";
}

function bool ShouldSaveForCheckpoint()
{
    return bShouldSaveForCheckpoint;
}

simulated event ShutDown()
{
    ShutDown();
    bBlocked = true;
    WorldInfo.Game.NotifyNavigationChanged(self);
    bShouldSaveForCheckpoint = true;
}

function OnToggle(SeqAct_Toggle inAction)
{
    if (inAction.InputLinks[0].bHasImpulse)
    {
        bBlocked = false;
    }
    else if (inAction.InputLinks[1].bHasImpulse)
    {
        bBlocked = true;
    }
    else if (inAction.InputLinks[2].bHasImpulse)
    {
        bBlocked = !bBlocked;
    }
    WorldInfo.Game.NotifyNavigationChanged(self);
    bShouldSaveForCheckpoint = true;
}

native final function bool IsOnDifferentNetwork(NavigationPoint Nav)
{
    Nav;
}

native static final function bool GetAllNavInRadius(Actor ChkActor, Vector ChkPoint, float Radius, out array<NavigationPoint> out_NavList, optional bool bSkipBlocked, optional int inNetworkID = -1, optional Cylinder MinSize)
{
    ChkActor;
    ChkPoint;
    Radius;
    out_NavList;
    bSkipBlocked;
    inNetworkID;
    MinSize;
}

static final function NavigationPoint GetNearestNavToPoint(Actor ChkActor, Vector ChkPoint, optional class<NavigationPoint> RequiredClass, optional array<NavigationPoint> ExcludeList)
{
    local NavigationPoint Nav, BestNav;
    local float Dist, bestDist;
    
    if (ChkActor != none)
    {
        foreach ChkActor.WorldInfo.AllNavigationPoints(class'NavigationPoint', Nav)
        {
            if ((RequiredClass == none || Nav.Class == RequiredClass) && ExcludeList.Find(Nav) == -1)
            {
                Dist = VSize(Nav.Location - ChkPoint);
                if (BestNav == none || Dist < bestDist)
                {
                    BestNav = Nav;
                    bestDist = Dist;
                }
            }
        }
    }
    return BestNav;
}

static final function NavigationPoint GetNearestNavToActor(Actor ChkActor, optional class<NavigationPoint> RequiredClass, optional array<NavigationPoint> ExcludeList, optional float MinDist)
{
    local NavigationPoint Nav, BestNav;
    local float Dist, bestDist;
    
    if (ChkActor != none)
    {
        foreach ChkActor.WorldInfo.AllNavigationPoints(class'NavigationPoint', Nav)
        {
            if ((RequiredClass == none || Nav.Class == RequiredClass) && ExcludeList.Find(Nav) == -1)
            {
                Dist = VSize(Nav.Location - ChkActor.Location);
                if (Dist > MinDist)
                {
                    if (BestNav == none || Dist < bestDist)
                    {
                        BestNav = Nav;
                        bestDist = Dist;
                    }
                }
            }
        }
    }
    return BestNav;
}

function bool ProceedWithMove(Pawn Other)
{
    return true;
}

event bool SuggestMovePreparation(Pawn Other)
{
    return Other.SpecialMoveTo(Other.Anchor, self, Other.Controller.MoveTarget);
}

event float DetourWeight(Pawn Other, float PathWeight)
{
}

event bool Accept(Actor Incoming, Actor Source)
{
    local bool bResult;
    
    bResult = Incoming.SetLocation(Location);
    if (bResult)
    {
        Incoming.Velocity = vect(0.0, 0.0, 0.0);
        Incoming.SetRotation(Rotation);
    }
    Incoming.PlayTeleportEffect(true, false);
    return bResult;
}

event int SpecialCost(Pawn Seeker, ReachSpec Path)
{
}

native function bool CanTeleport(Actor A)
{
    A;
}

native function bool IsUsableAnchorFor(Pawn P)
{
    P;
}

native final function ReachSpec GetReachSpecTo(NavigationPoint Nav, optional class<ReachSpec> SpecClass)
{
    Nav;
    SpecClass;
}

native function GetBoundingCylinder(out float CollisionRadius, out float CollisionHeight)
{
    CollisionRadius;
    CollisionHeight;
}

defaultproperties
{
    bMayCausePain=True
    bMustTouchToReach=True
    bBuildLongPaths=True
    CylinderComponent="Default__NavigationPoint.CollisionCylinder"
    GoodSprite="Default__NavigationPoint.Sprite"
    BadSprite="Default__NavigationPoint.Sprite2"
    NetworkID=-1
    bStatic=True
    bNoDelete=True
    bCollideWhenPlacing=True
    bForceAllowKismetModification=True
    Components(0)="Default__NavigationPoint.Sprite"
    Components(1)="Default__NavigationPoint.Sprite2"
    Components(2)="Default__NavigationPoint.Arrow"
    Components(3)="Default__NavigationPoint.CollisionCylinder"
    Components(4)="Default__NavigationPoint.PathRenderer"
    CollisionComponent="Default__NavigationPoint.CollisionCylinder"
}

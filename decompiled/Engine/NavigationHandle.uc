class NavigationHandle extends Object
    native
    notplaceable
    within Actor;

const NUM_PATHFINDING_PARAMS = 8;
const LINECHECK_GRANULARITY = 768.f;

struct native NavMeshPathParams
{
    var native Pointer Interface;
    var bool bCanMantle;
    var bool bNeedsMantleValidityTest;
    var bool bAbleToSearch;
    var Vector SearchExtent;
    var Vector SearchStart;
    var float MaxDropHeight;
    var float MinWalkableZ;
    var float MaxHoverDistance;
};

struct native PathStore
{
    var const native array<EdgePointer> EdgeList;
};

struct EdgePointer
{
    var const native Pointer Dummy;
};

struct native PolySegmentSpan
{
    var native Pointer Poly;
    var Vector P1;
    var Vector P2;
};

var Pylon AnchorPylon;
var native Pointer AnchorPoly;
var PathStore PathCache;
var native transient Pointer BestUnfinishedPathPoint;
var const native Pointer CurrentEdge;
var const native Pointer SubGoal_DestPoly;
var BasedPosition FinalDestination;
var bool bSkipRouteCacheUpdates;
var bool bUseORforEvaluateGoal;
var(PathDebug) bool bDebugConstraintsAndGoalEvals;
var(PathDebug) bool bUltraVerbosePathDebugging;
var NavMeshPathConstraint PathConstraintList;
var NavMeshPathGoalEvaluator PathGoalList;
var NavMeshPathParams CachedPathParams;

native static function Vector MoveToDesiredHeightAboveMesh(Vector Point, float Height)
{
    Point;
    Height;
}

native function float CalculatePathDistance(optional Vector FinalDest)
{
    FinalDest;
}

native function Vector GetFirstMoveLocation()
{
}

native function bool IsAnchorInescapable()
{
}

native function LimitPathCacheDistance(float MaxDist)
{
    MaxDist;
}

native function GetValidPositionsForBox(Vector pos, float Radius, Vector Extent, bool bMustBeReachableFromStartPos, out array<Vector> out_ValidPositions, optional int MaxPositions = -1, optional float MinRadius, optional Vector ValidBoxAroundStartPos = vect(0.0, 0.0, 0.0))
{
    pos;
    Radius;
    Extent;
    bMustBeReachableFromStartPos;
    out_ValidPositions;
    MaxPositions;
    MinRadius;
    ValidBoxAroundStartPos;
}

native function GetAllPolyCentersWithinBounds(Vector pos, Vector Extent, out array<Vector> out_PolyCtrs)
{
    pos;
    Extent;
    out_PolyCtrs;
}

native function DrawPathCache(optional Vector DrawOffset, optional bool bPersistent, optional Color DrawColor)
{
    DrawOffset;
    bPersistent;
    DrawColor;
}

native function bool ActorReachable(Actor A)
{
    A;
}

native function bool PointReachable(Vector Point, optional Vector OverrideStartPoint)
{
    Point;
    OverrideStartPoint;
}

native function bool PointCheck(Vector Pt, Vector Extent)
{
    Pt;
    Extent;
}

native function bool LineCheck(Vector Start, Vector End, Vector Extent, optional out Vector out_HitLocation, optional out Vector out_HitNormal)
{
    Start;
    End;
    Extent;
    out_HitLocation;
    out_HitNormal;
}

native static final function bool ObstaclePointCheck(Vector Pt, Vector Extent)
{
    Pt;
    Extent;
}

native static final function bool ObstacleLineCheck(Vector Start, Vector End, Vector Extent, optional out Vector out_HitLoc, optional out Vector out_HitNorm)
{
    Start;
    End;
    Extent;
    out_HitLoc;
    out_HitNorm;
}

native function bool SuggestMovePreparation(Vector MovePt, Controller C)
{
    MovePt;
    C;
}

native function bool FindPath(optional out Actor out_DestActor, optional out int out_DestItem)
{
    out_DestActor;
    out_DestItem;
}

native function bool ComputeValidFinalDestination(out Vector out_ComputedPosition)
{
    out_ComputedPosition;
}

native function bool SetFinalDestination(Vector FinalDest)
{
    FinalDest;
}

native function bool GetNextMoveLocation(out Vector out_MoveDest, float ArrivalDistance)
{
    out_MoveDest;
    ArrivalDistance;
}

native static function Pylon GetPylonFromPos(Vector Position)
{
    Position;
}

native function bool FindPylon()
{
}

native function Vector GetBestUnfinishedPathPoint()
{
}

native function PathCache_RemoveIndex(int InIdx, optional int Count = 1)
{
    InIdx;
    Count;
}

native function Vector PathCache_GetGoalPoint()
{
}

native function PathCache_Empty()
{
}

function int GetPathCacheLength()
{
    return PathCache.EdgeList.Length;
}

function NavMeshPathGoalEvaluator CreatePathGoalEvaluator(class<NavMeshPathGoalEvaluator> GoalEvalClass)
{
    return Outer.WorldInfo.GetNavMeshPathGoalEvaluatorFromCache(GoalEvalClass, self);
}

function NavMeshPathConstraint CreatePathConstraint(class<NavMeshPathConstraint> ConstraintClass)
{
    return Outer.WorldInfo.GetNavMeshPathConstraintFromCache(ConstraintClass, self);
}

native function AddGoalEvaluator(NavMeshPathGoalEvaluator Evaluator)
{
    Evaluator;
}

native function AddPathConstraint(NavMeshPathConstraint Constraint)
{
    Constraint;
}

native function ClearConstraints()
{
}

defaultproperties
{
}

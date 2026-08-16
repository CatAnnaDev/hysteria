class Scout extends Pawn
    native
    notplaceable
    transient
    config(Game)
    hidecategories(Navigation);

struct native PathSizeInfo
{
    var name Desc;
    var float Radius;
    var float Height;
    var float CrouchHeight;
    var byte PathColor;
};

var array<PathSizeInfo> PathSizes;
var float TestJumpZ;
var float TestGroundSpeed;
var float TestMaxFallSpeed;
var float TestFallSpeed;
var const float MaxLandingVelocity;
var int MinNumPlayerStarts;
var class<ReachSpec> DefaultReachSpecClass;
var float NavMeshGen_StepSize;
var float NavMeshGen_EntityHalfHeight;
var float NavMeshGen_StartingHeightOffset;
var float NavMeshGen_MaxDropHeight;
var float NavMeshGen_MaxStepHeight;
var float NavMeshGen_VertZDeltaSnapThresh;
var float NavMeshGen_MinPolyArea;
var float NavMeshGen_BorderBackfill_CheckDist;
var float NavMeshGen_MinMergeDotAreaThreshold;
var float NavMeshGen_MinMergeDotSmallArea;
var float NavMeshGen_MinMergeDotLargeArea;
var float NavMeshGen_MaxPolyHeight;
var float NavMeshGen_HeightMergeThreshold;
var float NavMeshGen_EdgeMaxDelta;
var float NavMeshGen_MaxGroundCheckSize;
var float NavMeshGen_MinEdgeLength;
var() bool bHightlightOneWayReachSpecs;

simulated event PreBeginPlay()
{
    if (bCollideActors)
    {
        SetCollision(false, false);
    }
}

defaultproperties
{
    PathSizes(0)=(Desc="Human",Radius=48.0,Height=80.0,CrouchHeight=0.0,PathColor=0)
    PathSizes(1)=(Desc="Common",Radius=72.0,Height=100.0,CrouchHeight=0.0,PathColor=0)
    PathSizes(2)=(Desc="Max",Radius=120.0,Height=120.0,CrouchHeight=0.0,PathColor=0)
    PathSizes(3)=(Desc="Vehicle",Radius=260.0,Height=120.0,CrouchHeight=0.0,PathColor=0)
    TestJumpZ=420.0
    TestGroundSpeed=600.0
    TestMaxFallSpeed=2500.0
    TestFallSpeed=1200.0
    MinNumPlayerStarts=1
    DefaultReachSpecClass="ReachSpec"
    NavMeshGen_StepSize=30.0
    NavMeshGen_EntityHalfHeight=72.0
    NavMeshGen_StartingHeightOffset=150.0
    NavMeshGen_MaxDropHeight=60.0
    NavMeshGen_MaxStepHeight=35.0
    NavMeshGen_VertZDeltaSnapThresh=20.0
    NavMeshGen_MinPolyArea=25.0
    NavMeshGen_BorderBackfill_CheckDist=70.0
    NavMeshGen_MinMergeDotAreaThreshold=2.0
    NavMeshGen_MinMergeDotLargeArea=0.95
    NavMeshGen_MaxPolyHeight=120.0
    NavMeshGen_HeightMergeThreshold=10.0
    NavMeshGen_EdgeMaxDelta=2.0
    NavMeshGen_MaxGroundCheckSize=30.0
    NavMeshGen_MinEdgeLength=25.0
    AccelRate=1.0
    CylinderComponent="Default__Scout.CollisionCylinder"
    bCollideActors=False
    bCollideWorld=False
    bBlockActors=False
    bProjTarget=False
    bPathColliding=True
    Components(0)="Default__Scout.CollisionCylinder"
    RemoteRole="ROLE_None"
    CollisionType="COLLIDE_CustomDefault"
    CollisionComponent="Default__Scout.CollisionCylinder"
}

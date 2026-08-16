class KMeshProps extends Object
    native
    noexport
    notplaceable;

struct KAggregateGeom
{
    var() editfixedsize array<KSphereElem> SphereElems;
    var() editfixedsize array<KBoxElem> BoxElems;
    var() editfixedsize array<KSphylElem> SphylElems;
    var() editfixedsize array<KConvexElem> ConvexElems;
    var native nontransactional Pointer RenderInfo;
    var() bool bSkipCloseAndParallelChecks;
};

struct KConvexElem
{
    var array<Vector> VertexData;
    var array<Plane> PermutedVertexData;
    var array<int> FaceTriData;
    var array<Vector> EdgeDirections;
    var array<Vector> FaceNormalDirections;
    var array<Plane> FacePlaneData;
    var Box ElemBox;
};

struct KSphylElem
{
    var() editconst Matrix TM;
    var() editconst float Radius;
    var() editconst float Length;
    var() bool bNoRBCollision;
    var() bool bPerPolyShape;
};

struct KBoxElem
{
    var() editconst Matrix TM;
    var() editconst float X;
    var() editconst float Y;
    var() editconst float Z;
    var() bool bNoRBCollision;
    var() bool bPerPolyShape;
};

struct KSphereElem
{
    var() editconst Matrix TM;
    var() editconst float Radius;
    var() bool bNoRBCollision;
    var() bool bPerPolyShape;
};

var() Vector COMNudge;
var() KAggregateGeom AggGeom;

defaultproperties
{
}

class Hair extends Object
    native
    notplaceable
    editinlinenew;

struct native Patch
{
    var int StrandIndices[3];
};

struct native Strand
{
    var int StartNodeIndex;
    var int NodeCount;
};

struct native Node
{
    var Vector Position;
    var float GuideRestitution;
};

var() SkeletalMesh SkeletalMesh;
var(Bounds) Box FixedRelativeBoundingBox;
var array<Node> Nodes;
var array<Strand> Strands;
var() int SubdivisionStep;
var() float GuideRestitutionRoot;
var() float GuideRestitutionDecay;
var transient array<Patch> Patches;

native function UpdateStrands()
{
}

defaultproperties
{
    FixedRelativeBoundingBox=(Min=(X=-100.0,Y=-100.0,Z=-100.0),Max=(X=100.0,Y=100.0,Z=100.0),IsValid=0)
    SubdivisionStep=2
    GuideRestitutionRoot=1000.0
    GuideRestitutionDecay=0.7
}

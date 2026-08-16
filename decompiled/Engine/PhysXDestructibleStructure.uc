class PhysXDestructibleStructure extends Object
    native
    notplaceable;

enum EPhysXDestructibleChunkState
{
    DCS_StaticRoot,
    DCS_StaticChild,
    DCS_DynamicRoot,
    DCS_DynamicChild,
    DCS_Hidden,
};

struct native PhysXDestructibleOverlap
{
    var int ChunkIndex0;
    var int ChunkIndex1;
    var int Adjacent;
};

struct native PhysXDestructibleChunk
{
    var bool WorldCentroidValid;
    var bool WorldMatrixValid;
    var bool bCrumble;
    var bool IsEnvironmentSupported;
    var bool IsRouting;
    var bool IsRouteValid;
    var bool IsRouteBlocker;
    var int ActorIndex;
    var int FragmentIndex;
    var int Index;
    var int MeshIndex;
    var int BoneIndex;
    var name BoneName;
    var int BodyIndex;
    var Vector RelativeCentroid;
    var Vector WorldCentroid;
    var Matrix RelativeMatrix;
    var Matrix WorldMatrix;
    var float Radius;
    var int ParentIndex;
    var int FirstChildIndex;
    var int NumChildren;
    var int Depth;
    var float Age;
    var float Damage;
    var float Size;
    var EPhysXDestructibleChunkState CurrentState;
    var native Pointer Structure;
    var native int FIFOIndex;
    var int FirstOverlapIndex;
    var int NumOverlaps;
    var int ShortestRoute;
    var int NumSupporters;
    var int NumChildrenDup;
};

var native Pointer Manager;
var native transient array<PhysXDestructibleActor> Actors;
var native transient array<PhysXDestructibleActor> ActorKillList;
var native transient array<PhysXDestructibleChunk> Chunks;
var native transient array<PhysXDestructibleOverlap> Overlaps;
var native transient array<int> Active;
var native transient array<int> PseudoSupporterFifo;
var native transient int PseudoSupporterFifoStart;
var native transient array<int> FractureOriginFifo;
var native transient int FractureOriginFifoStart;
var native transient array<int> FractureOriginChunks;
var native transient array<int> RouteUpdateArea;
var const native transient int PerFrameProcessBudget;
var native transient array<int> PassiveFractureChunks;
var native transient array<int> RouteUpdateFifo;
var native transient int RouteUpdateFifoStart;
var native transient int SupportDepth;

native function Vector GetChunkCentroid(int ChunkIndex)
{
    ChunkIndex;
}

native function Matrix GetChunkMatrix(int ChunkIndex)
{
    ChunkIndex;
}

native function CrumbleChunk(int ChunkIndex)
{
    ChunkIndex;
}

native function FractureChunk(int ChunkIndex, Vector Point, Vector Impulse, bool bInheritRootVel)
{
    ChunkIndex;
    Point;
    Impulse;
    bInheritRootVel;
}

native function bool DamageChunk(int ChunkIndex, Vector Point, float BaseDamage, float Radius, bool bFullDamage, float DamageFalloffExp, out array<int> Output)
{
    ChunkIndex;
    Point;
    BaseDamage;
    Radius;
    bFullDamage;
    DamageFalloffExp;
    Output;
}

defaultproperties
{
}

class PhysXDestructibleAsset extends Object
    native
    notplaceable;

struct native PhysXDestructibleAssetChunk
{
    var int Index;
    var int FragmentIndex;
    var float Volume;
    var float Size;
    var int Depth;
    var int ParentIndex;
    var int FirstChildIndex;
    var int NumChildren;
    var int MeshIndex;
    var int BoneIndex;
    var name BoneName;
    var int BodyIndex;
};

var array<PhysXDestructibleAssetChunk> ChunkTree;
var() const array<SkeletalMesh> Meshes;
var() const array<PhysicsAsset> Assets;
var() const int MaxDepth;

defaultproperties
{
}

class SeqAct_SetMesh extends SequenceAction
    native
    notplaceable
    hidecategories(Object);

enum EMeshType
{
    MeshType_StaticMesh,
    MeshType_SkeletalMesh,
};

var() SkeletalMesh NewSkeletalMesh;
var() StaticMesh NewStaticMesh;
var() EMeshType MeshType;
var() bool bIsAllowedToMove;
var() bool bAllowDecalsToReattach;

defaultproperties
{
    ObjName="Set Mesh"
    ObjCategory="Actor"
}

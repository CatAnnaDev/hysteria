class InterpGroupAI extends InterpGroup
    native
    notplaceable
    collapsecategories
    hidecategories(Object,Object);

var() editconst editoronly SkeletalMesh PreviewSkeletalMesh;
var() editoronly class<Pawn> PreviewPawnClass;
var() name StageMarkGroup;
var transient editoronly Pawn PreviewPawn;
var Actor StageMarkActor;

defaultproperties
{
    GroupName="AIGroup"
}

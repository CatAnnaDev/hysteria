class SeqAct_SetMaterial extends SequenceAction
    native
    notplaceable
    hidecategories(Object);

var() MaterialInterface NewMaterial;
var() int MaterialIndex;

defaultproperties
{
    ObjName="Set Material"
    ObjCategory="Actor"
}

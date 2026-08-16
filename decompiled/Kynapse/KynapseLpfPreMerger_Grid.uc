class KynapseLpfPreMerger_Grid extends KynapseLpfPreMerger
    native
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object);

var() const float MaxGridWidth;
var() const float MaxPrecision;
var() const int MaxVertexCount;
var() const int MaxContourCount;

defaultproperties
{
    MaxGridWidth=30.0
    MaxPrecision=0.1
    MaxVertexCount=1024
    MaxContourCount=64
    ClassName="CLpfPreMerger_Grid"
}

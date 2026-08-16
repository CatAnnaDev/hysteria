class LineBatchComponent extends PrimitiveComponent
    native
    noexport
    notplaceable;

var const native noexport Pointer FPrimitiveDrawInterfaceVfTable;
var const native noexport Pointer FPrimitiveDrawInterfaceView;
var const native transient array<Pointer> BatchedLines;
var const native transient array<Pointer> BatchedPoints;
var const native transient float DefaultLifeTime;

defaultproperties
{
    ReplacementPrimitive="None"
}

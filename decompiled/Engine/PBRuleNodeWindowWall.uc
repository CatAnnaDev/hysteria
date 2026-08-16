class PBRuleNodeWindowWall extends PBRuleNodeBase
    native
    notplaceable
    editinlinenew
    collapsecategories
    hidecategories(Object,Object);

var() float CellMaxSizeX;
var() float CellMaxSizeZ;
var() float WindowSizeX;
var() float WindowSizeZ;
var() float WindowPosX;
var() float WindowPosZ;
var() bool bScaleWindowWithCell;
var() float YOffset;
var() MaterialInterface Material;

defaultproperties
{
    CellMaxSizeX=512.0
    CellMaxSizeZ=512.0
    WindowSizeX=128.0
    WindowSizeZ=232.0
    WindowPosX=0.5
    WindowPosZ=0.5
}

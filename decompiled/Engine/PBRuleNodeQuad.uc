class PBRuleNodeQuad extends PBRuleNodeBase
    native
    notplaceable
    editinlinenew
    collapsecategories
    hidecategories(Object,Object);

var() MaterialInterface Material;
var() float RepeatMaxSizeX;
var() float RepeatMaxSizeZ;
var() int QuadLightmapRes;
var() float YOffset;
var() bool bDisableMaterialRepeat;

defaultproperties
{
    RepeatMaxSizeX=512.0
    RepeatMaxSizeZ=512.0
    QuadLightmapRes=32
}

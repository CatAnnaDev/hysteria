class SpeedTree extends Object
    native
    notplaceable;

var const bool bLegacySpeedTree;
var const native duplicatetransient Pointer SRH;
var(Lighting) float LeafStaticShadowOpacity;
var(Material) MaterialInterface Branch1Material;
var(Material) MaterialInterface Branch2Material;
var(Material) MaterialInterface FrondMaterial;
var(Material) MaterialInterface LeafCardMaterial;
var(Material) MaterialInterface LeafMeshMaterial;
var(Material) MaterialInterface BillboardMaterial;
var(Wind) float WindStrength;
var(Wind) Vector WindDirection;
var const Guid LightingGuid;

defaultproperties
{
    LeafStaticShadowOpacity=0.5
    WindStrength=0.2
    WindDirection=(X=1.0,Y=0.0,Z=0.0)
}

class ShadowMap2D extends Object
    native
    noexport
    notplaceable;

var const ShadowMapTexture2D Texture;
var const Vector2D CoordinateScale;
var const Vector2D CoordinateBias;
var const Guid LightGuid;
var const bool bIsShadowFactorTexture;
var transient export editinline InstancedStaticMeshComponent Component;
var transient int InstanceIndex;

defaultproperties
{
    bIsShadowFactorTexture=True
}

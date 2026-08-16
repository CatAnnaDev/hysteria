class StaticLightCollectionActor extends Light
    native
    notplaceable
    config(Engine)
    hidecategories(Navigation);

var const export editinline array<LightComponent> LightComponents;
var config int MaxLightComponents;

defaultproperties
{
    MaxLightComponents=100
}

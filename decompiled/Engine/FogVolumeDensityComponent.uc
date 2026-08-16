class FogVolumeDensityComponent extends ActorComponent
    abstract
    native
    notplaceable
    editinlinenew
    hidecategories(Object);

var() MaterialInterface FogMaterial;
var MaterialInterface DefaultFogVolumeMaterial;
var() const bool bEnabled;
var() bool bAffectsTranslucency;
var() interp LinearColor SimpleLightColor;
var() interp LinearColor ApproxFogLightColor;
var() interp float StartDistance;
var() array<Actor> FogVolumeActors;

native final function SetEnabled(bool bSetEnabled)
{
    bSetEnabled;
}

defaultproperties
{
    DefaultFogVolumeMaterial="EngineMaterials.FogVolumeMaterial"
    bEnabled=True
    bAffectsTranslucency=True
    SimpleLightColor=(R=0.5,G=0.5,B=0.7,A=1.0)
    ApproxFogLightColor=(R=0.5,G=0.5,B=0.7,A=1.0)
}

class ParticleLightEnvironmentComponent extends DynamicLightEnvironmentComponent
    native
    notplaceable;

var const transient int ReferenceCount;
var bool bAllowDLESharing;

defaultproperties
{
    ReferenceCount=1
    InvisibleUpdateTime=10.0
    MinTimeBetweenFullUpdates=3.0
    bForceCompositeAllLights=True
    bDynamic=False
    BoundsMethod="DLEB_ActiveComponents"
}

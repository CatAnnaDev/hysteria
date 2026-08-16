class ParticleModuleUberRainDrops extends ParticleModuleUberBase
    native
    notplaceable
    editinlinenew
    collapsecategories
    hidecategories(Object,Object,Object);

var(Lifetime) float LifetimeMin;
var(Lifetime) float LifetimeMax;
var(Size) Vector StartSizeMin;
var(Size) Vector StartSizeMax;
var(Velocity) Vector StartVelocityMin;
var(Velocity) Vector StartVelocityMax;
var(Velocity) float StartVelocityRadialMin;
var(Velocity) float StartVelocityRadialMax;
var(Color) Vector ColorOverLife;
var(Color) float AlphaOverLife;
var(Location) bool bIsUsingCylinder;
var(Location) bool bPositive_X;
var(Location) bool bPositive_Y;
var(Location) bool bPositive_Z;
var(Location) bool bNegative_X;
var(Location) bool bNegative_Y;
var(Location) bool bNegative_Z;
var(Location) bool bSurfaceOnly;
var(Location) bool bVelocity;
var(Location) bool bRadialVelocity;
var(Location) float PC_VelocityScale;
var(Location) Vector PC_StartLocation;
var(Location) float PC_StartRadius;
var(Location) float PC_StartHeight;
var(Location) CylinderHeightAxis PC_HeightAxis;
var(Location) Vector StartLocationMin;
var(Location) Vector StartLocationMax;

defaultproperties
{
    LifetimeMin=1.0
    LifetimeMax=1.0
    StartSizeMin=(X=1.0,Y=1.0,Z=1.0)
    StartSizeMax=(X=1.0,Y=1.0,Z=1.0)
    StartVelocityMin=(X=1.0,Y=1.0,Z=1.0)
    StartVelocityMax=(X=1.0,Y=1.0,Z=1.0)
    ColorOverLife=(X=255.9,Y=255.9,Z=255.9)
    AlphaOverLife=255.9
    bPositive_X=True
    bPositive_Y=True
    bPositive_Z=True
    bNegative_X=True
    bNegative_Y=True
    bNegative_Z=True
    bRadialVelocity=True
    PC_VelocityScale=1.0
    PC_StartRadius=50.0
    PC_StartHeight=50.0
    PC_HeightAxis="PMLPC_HEIGHTAXIS_Z"
    bSpawnModule=True
    bUpdateModule=True
    bSupported3DDrawMode=True
}

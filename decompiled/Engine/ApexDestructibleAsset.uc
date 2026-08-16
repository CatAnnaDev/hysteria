class ApexDestructibleAsset extends ApexAsset
    native
    notplaceable
    hidecategories(Object,Object);

struct native NxDestructibleParameters
{
    var() float DamageThreshold;
    var() float DamageToRadius;
    var() float DamageCap;
    var() float ForceToDamage;
    var() float ImpactVelocityThreshold;
    var() float MaterialStrength;
    var() float DamageToPercentDeformation;
    var() float DeformationPercentLimit;
    var() bool bFormExtendedStructures;
    var() int SupportDepth;
    var() int DebrisDepth;
    var() int EssentialDepth;
    var() float DebrisLifetimeMin;
    var() float DebrisLifetimeMax;
    var() float DebrisMaxSeparationMin;
    var() float DebrisMaxSeparationMax;
    var() Box ValidBounds;
    var() float MaxChunkSpeed;
    var() float MassScaleExponent;
    var() NxDestructibleParametersFlag Flags;
    var() float GrbVolumeLimit;
    var() float GrbParticleSpacing;
    var() float FractureImpulseScale;
    var() editfixedsize array<NxDestructibleDepthParameters> DepthParameters;
};

struct native NxDestructibleParametersFlag
{
    var() bool ACCUMULATE_DAMAGE;
    var() bool ASSET_DEFINED_SUPPORT;
    var() bool WORLD_SUPPORT;
    var() bool DEBRIS_TIMEOUT;
    var() bool DEBRIS_MAX_SEPARATION;
    var() bool CRUMBLE_SMALLEST_CHUNKS;
    var() bool ACCURATE_RAYCASTS;
    var() bool USE_VALID_BOUNDS;
};

struct native NxDestructibleDepthParameters
{
    var() bool TAKE_IMPACT_DAMAGE;
    var() bool IGNORE_POSE_UPDATES;
    var() bool IGNORE_RAYCAST_CALLBACKS;
    var() bool IGNORE_CONTACT_CALLBACKS;
    var() bool USER_FLAG_0;
    var() bool USER_FLAG_1;
    var() bool USER_FLAG_2;
    var() bool USER_FLAG_3;
};

var native Pointer MApexAsset;
var() const editfixedsize array<MaterialInterface> Materials;
var() const editfixedsize array<FractureMaterial> FractureMaterials;
var() PhysicalMaterial DefaultPhysMaterial;
var native Pointer MDestructibleThumbnailComponent;
var bool bHasUniqueAssetMaterialNames;
var() bool bDynamic;
var() string CrumbleEmitterName;
var() string DustEmitterName;
var() NxDestructibleParameters DestructibleParameters;

defaultproperties
{
    DestructibleParameters=(DamageThreshold=0.0,DamageToRadius=0.0,DamageCap=0.0,ForceToDamage=0.0,ImpactVelocityThreshold=0.0,MaterialStrength=0.0,DamageToPercentDeformation=0.0,DeformationPercentLimit=0.0,bFormExtendedStructures=False,SupportDepth=0,DebrisDepth=0,EssentialDepth=0,DebrisLifetimeMin=0.0,DebrisLifetimeMax=0.0,DebrisMaxSeparationMin=0.0,DebrisMaxSeparationMax=0.0,ValidBounds=(Min=(X=-500000.0,Y=-500000.0,Z=-500000.0),Max=(X=500000.0,Y=500000.0,Z=500000.0),IsValid=0),MaxChunkSpeed=0.0,MassScaleExponent=0.0,Flags=(ACCUMULATE_DAMAGE=False,ASSET_DEFINED_SUPPORT=False,WORLD_SUPPORT=False,DEBRIS_TIMEOUT=False,DEBRIS_MAX_SEPARATION=False,CRUMBLE_SMALLEST_CHUNKS=False,ACCURATE_RAYCASTS=False,USE_VALID_BOUNDS=False),GrbVolumeLimit=0.0,GrbParticleSpacing=0.0,FractureImpulseScale=0.0,DepthParameters=())
}

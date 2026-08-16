class LensFlare extends Object
    native
    notplaceable
    hidecategories(Object);

struct native LensFlareElement
{
    var() name ElementName;
    var() float RayDistance;
    var() bool bIsEnabled;
    var() bool bUseSourceDistance;
    var() bool bNormalizeRadialDistance;
    var() bool bModulateColorBySource;
    var() Vector Size;
    var(Material) array<MaterialInterface> LFMaterials;
    var(Material) RawDistributionFloat LFMaterialIndex;
    var(Scaling) RawDistributionFloat Scaling;
    var(Scaling) RawDistributionVector AxisScaling;
    var(Rotation) RawDistributionFloat Rotation;
    var(Color) RawDistributionVector Color;
    var(Color) RawDistributionFloat Alpha;
    var(Offset) RawDistributionVector Offset;
    var(Scaling) RawDistributionVector DistMap_Scale;
    var(Scaling) RawDistributionVector DistMap_Color;
    var(Scaling) RawDistributionFloat DistMap_Alpha;
};

struct native transient LensFlareElementCurvePair
{
    var string CurveName;
    var Object CurveObject;
};

var export editinline LensFlareElement SourceElement;
var(Source) StaticMesh SourceMesh;
var(Source) const ESceneDepthPriorityGroup SourceDPG;
var(Reflections) const ESceneDepthPriorityGroup ReflectionsDPG;
var export editinline array<LensFlareElement> Reflections;
var(Visibility) float OuterCone;
var(Visibility) float InnerCone;
var(Visibility) float ConeFudgeFactor;
var(Visibility) float Radius;
var(Occlusion) RawDistributionFloat ScreenPercentageMap;
var(Bounds) bool bUseFixedRelativeBoundingBox;
var(Debug) bool bRenderDebugLines;
var bool ThumbnailImageOutOfDate;
var(Bounds) Box FixedRelativeBoundingBox;
var export InterpCurveEdSetup CurveEdSetup;
var transient int ReflectionCount;
var Rotator ThumbnailAngle;
var float ThumbnailDistance;
var Texture2D ThumbnailImage;

defaultproperties
{
    SourceElement=(ElementName="Source",RayDistance=0.0,bIsEnabled=True,bUseSourceDistance=False,bNormalizeRadialDistance=False,bModulateColorBySource=False,Size=(X=75.0,Y=75.0,Z=75.0),LFMaterials=(),LFMaterialIndex=(Distribution="Default__LensFlare.DistributionLFMaterialIndex",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=1,LookupTable=// [raw] 00000000000000000000000000000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0),Scaling=(Distribution="Default__LensFlare.DistributionScaling",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=1,LookupTable=// [raw] 0000803f0000803f0000803f0000803f,LookupTableTimeScale=0.0,LookupTableStartTime=0.0),AxisScaling=(Distribution="Default__LensFlare.DistributionAxisScaling",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=3,LookupTable=// [raw] 000000000000803f0000803f0000803f000000000000803f0000803f00000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0),Rotation=(Distribution="Default__LensFlare.DistributionRotation",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=1,LookupTable=// [raw] 00000000000000000000000000000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0),Color=(Distribution="Default__LensFlare.DistributionColor",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=3,LookupTable=// [raw] 0000803f0000803f0000803f0000803f0000803f0000803f0000803f0000803f,LookupTableTimeScale=0.0,LookupTableStartTime=0.0),Alpha=(Distribution="Default__LensFlare.DistributionAlpha",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=1,LookupTable=// [raw] 0000803f0000803f0000803f0000803f,LookupTableTimeScale=0.0,LookupTableStartTime=0.0),Offset=(Distribution="Default__LensFlare.DistributionOffset",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=3,LookupTable=// [raw] 0000000000000000000000000000000000000000000000000000000000000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0),DistMap_Scale=(Distribution="Default__LensFlare.DistributionDistMap_Scale",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=3,LookupTable=// [raw] 0000803f0000803f0000803f0000803f0000803f0000803f0000803f0000803f,LookupTableTimeScale=0.0,LookupTableStartTime=0.0),DistMap_Color=(Distribution="Default__LensFlare.DistributionDistMap_Color",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=3,LookupTable=// [raw] 0000803f0000803f0000803f0000803f0000803f0000803f0000803f0000803f,LookupTableTimeScale=0.0,LookupTableStartTime=0.0),DistMap_Alpha=(Distribution="Default__LensFlare.DistributionDistMap_Alpha",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=1,LookupTable=// [raw] 0000803f0000803f0000803f0000803f,LookupTableTimeScale=0.0,LookupTableStartTime=0.0))
    SourceDPG="SDPG_World"
    ReflectionsDPG="SDPG_Foreground"
    ConeFudgeFactor=0.5
    ScreenPercentageMap=(Distribution="Default__LensFlare.DistributionScreenPercentageMap",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=1,LookupTable=// [raw] 000000000000803f000000000000803f,LookupTableTimeScale=1.0,LookupTableStartTime=0.0)
}

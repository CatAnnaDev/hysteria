class LensFlareComponent extends PrimitiveComponent
    native
    notplaceable
    editinlinenew
    hidecategories(Object,Physics,Collision);

struct LensFlareElementInstance
{
};

var() const LensFlare Template;
var const export editinline DrawLightConeComponent PreviewInnerCone;
var const export editinline DrawLightConeComponent PreviewOuterCone;
var const export editinline DrawLightRadiusComponent PreviewRadius;
var() bool bAutoActivate;
var transient bool bIsActive;
var transient bool bHasTranslucency;
var transient bool bHasUnlitTranslucency;
var transient bool bHasUnlitDistortion;
var transient bool bUsesSceneColor;
var transient float OuterCone;
var transient float InnerCone;
var transient float ConeFudgeFactor;
var transient float Radius;
var(Rendering) LinearColor SourceColor;
var const native Pointer ReleaseResourcesFence;

native function SetIsActive(bool bInIsActive)
{
    bInIsActive;
}

native function SetSourceColor(LinearColor InSourceColor)
{
    InSourceColor;
}

native final function SetTemplate(LensFlare NewTemplate)
{
    NewTemplate;
}

defaultproperties
{
    bAutoActivate=True
    SourceColor=(R=1.0,G=1.0,B=1.0,A=1.0)
    ReplacementPrimitive="None"
    bFirstFrameOcclusion=True
    bIgnoreNearPlaneIntersection=True
    bTickInEditor=True
    TickGroup="TG_PostAsyncWork"
}

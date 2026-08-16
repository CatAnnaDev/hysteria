class Material extends MaterialInterface
    native
    notplaceable
    collapsecategories
    hidecategories(Object);

enum EMaterialLightingModel
{
    MLM_Phong,
    MLM_NonDirectional,
    MLM_Unlit,
    MLM_SHPRT,
    MLM_Custom,
    MLM_Anisotropic,
};

enum EBlendMode
{
    BLEND_Opaque,
    BLEND_Masked,
    BLEND_Translucent,
    BLEND_Additive,
    BLEND_Modulate,
    BLEND_SoftMasked,
    BLEND_AlphaComposite,
};

struct Vector2MaterialInput extends MaterialInput
{
    var bool UseConstant;
    var float ConstantX;
    var float ConstantY;
};

struct VectorMaterialInput extends MaterialInput
{
    var bool UseConstant;
    var Vector Constant;
};

struct ScalarMaterialInput extends MaterialInput
{
    var bool UseConstant;
    var float Constant;
};

struct ColorMaterialInput extends MaterialInput
{
    var bool UseConstant;
    var Color Constant;
};

struct MaterialInput
{
    var MaterialExpression Expression;
    var int Mask;
    var int MaskR;
    var int MaskG;
    var int MaskB;
    var int MaskA;
    var int GCC64_Padding;
};

var() PhysicalMaterial PhysMaterial;
var class<PhysicalMaterial> PhysicalMaterial;
var(PhysicalMaterialMask) Texture2D PhysMaterialMask;
var(PhysicalMaterialMask) int PhysMaterialMaskUVChannel;
var(PhysicalMaterialMask) PhysicalMaterial BlackPhysicalMaterial;
var(PhysicalMaterialMask) PhysicalMaterial WhitePhysicalMaterial;
var ColorMaterialInput DiffuseColor;
var ScalarMaterialInput DiffusePower;
var ColorMaterialInput SpecularColor;
var ScalarMaterialInput SpecularPower;
var VectorMaterialInput Normal;
var ColorMaterialInput EmissiveColor;
var ScalarMaterialInput Opacity;
var ScalarMaterialInput OpacityMask;
var() float OpacityMaskClipValue;
var Vector2MaterialInput Distortion;
var() EBlendMode BlendMode;
var() EMaterialLightingModel LightingModel;
var ColorMaterialInput CustomLighting;
var ColorMaterialInput CustomSkylightDiffuse;
var VectorMaterialInput AnisotropicDirection;
var ScalarMaterialInput TwoSidedLightingMask;
var ColorMaterialInput TwoSidedLightingColor;
var VectorMaterialInput WorldPositionOffset;
var() bool TwoSided;
var() bool TwoSidedSeparatePass;
var(Translucency) bool bDisableDepthTest;
var(Translucency) bool bAllowFog;
var(Translucency) bool bTranslucencyReceiveDominantShadowsFromStatic;
var(Translucency) bool bTranslucencyInheritDominantShadowsFromOpaque;
var(Translucency) bool bAllowTranslucencyDoF;
var(Translucency) bool bUseOneLayerDistortion;
var(Translucency) bool bUseLitTranslucencyDepthPass;
var(Translucency) bool bUseLitTranslucencyPostRenderDepthPass;
var(Translucency) bool bCastLitTranslucencyShadowAsMasked;
var(MutuallyExclusiveUsage) const bool bUsedAsLightFunction;
var(MutuallyExclusiveUsage) const bool bUsedWithFogVolumes;
var const duplicatetransient bool bUsedAsSpecialEngineMaterial;
var(Usage) const bool bUsedWithSkeletalMesh;
var(Usage) const bool bUsedWithFracturedMeshes;
var const bool bUsedWithParticleSystem;
var(Usage) const bool bUsedWithParticleSprites;
var(Usage) const bool bUsedWithBeamTrails;
var(Usage) const bool bUsedWithParticleSubUV;
var(Usage) const bool bUsedWithFoliage;
var(Usage) const bool bUsedWithSpeedTree;
var(Usage) const bool bUsedWithStaticLighting;
var(Usage) const bool bUsedWithLensFlare;
var(Usage) const bool bUsedWithGammaCorrection;
var(Usage) const bool bUsedWithInstancedMeshParticles;
var(Usage) const bool bUsedWithFluidSurfaces;
var(MutuallyExclusiveUsage) const bool bUsedWithDecals;
var(Usage) const bool bUsedWithMaterialEffect;
var(Usage) const bool bUsedWithMorphTargets;
var(Usage) const bool bUsedWithRadialBlur;
var(Usage) const bool bUsedWithInstancedMeshes;
var(Usage) const bool bUsedWithSplineMeshes;
var(Usage) const bool bUsedWithAPEXMeshes;
var(Usage) const bool bUsedWithSPHFluid;
var(Usage) const bool bUsedWithHair;
var(Usage) const bool bUsedWithVertexDisturbance;
var(Usage) const bool bUsedWithScreenDoorFade;
var() bool Wireframe;
var() bool bPerPixelCameraVector;
var() bool bAllowLightmapSpecular;
var bool bIsFallbackMaterial;
var bool bUsesDistortion;
var bool bIsMasked;
var transient duplicatetransient bool bIsPreviewMaterial;
var duplicatetransient notforconsole Material FallbackMaterial;
var const native duplicatetransient Pointer MaterialResources[2];
var const native duplicatetransient Pointer DefaultMaterialInstances[2];
var int EditorX;
var int EditorY;
var int EditorPitch;
var int EditorYaw;
var array<MaterialExpression> Expressions;
var editoronly array<MaterialExpressionComment> EditorComments;
var editoronly array<MaterialExpressionCompound> EditorCompounds;
var native map<int, int> EditorParameters;
var const deprecated array<Texture> ReferencedTextures;
var const editoronly array<Guid> ReferencedTextureGuids;

defaultproperties
{
    DiffuseColor=(UseConstant=False,Constant=(B=128,G=128,R=128,A=0),Expression="None",Mask=0,MaskR=0,MaskG=0,MaskB=0,MaskA=0,GCC64_Padding=0)
    DiffusePower=(UseConstant=False,Constant=1.0,Expression="None",Mask=0,MaskR=0,MaskG=0,MaskB=0,MaskA=0,GCC64_Padding=0)
    SpecularColor=(UseConstant=False,Constant=(B=128,G=128,R=128,A=0),Expression="None",Mask=0,MaskR=0,MaskG=0,MaskB=0,MaskA=0,GCC64_Padding=0)
    SpecularPower=(UseConstant=False,Constant=15.0,Expression="None",Mask=0,MaskR=0,MaskG=0,MaskB=0,MaskA=0,GCC64_Padding=0)
    Opacity=(UseConstant=False,Constant=1.0,Expression="None",Mask=0,MaskR=0,MaskG=0,MaskB=0,MaskA=0,GCC64_Padding=0)
    OpacityMask=(UseConstant=False,Constant=1.0,Expression="None",Mask=0,MaskR=0,MaskG=0,MaskB=0,MaskA=0,GCC64_Padding=0)
    OpacityMaskClipValue=0.3333
    TwoSidedLightingColor=(UseConstant=False,Constant=(B=255,G=255,R=255,A=0),Expression="None",Mask=0,MaskR=0,MaskG=0,MaskB=0,MaskA=0,GCC64_Padding=0)
    bAllowFog=True
    bAllowLightmapSpecular=True
}

class Texture extends Surface
    abstract
    native
    notplaceable;

enum TextureMipGenSettings
{
    TMGS_FromTextureGroup,
    TMGS_SimpleAverage,
    TMGS_Sharpen0,
    TMGS_Sharpen1,
    TMGS_Sharpen2,
    TMGS_Sharpen3,
    TMGS_Sharpen4,
    TMGS_Sharpen5,
    TMGS_Sharpen6,
    TMGS_Sharpen7,
    TMGS_Sharpen8,
    TMGS_Sharpen9,
    TMGS_Sharpen10,
    TMGS_NoMipmaps,
};

enum TextureGroup
{
    TEXTUREGROUP_World,
    TEXTUREGROUP_WorldNormalMap,
    TEXTUREGROUP_WorldSpecular,
    TEXTUREGROUP_Character,
    TEXTUREGROUP_CharacterNormalMap,
    TEXTUREGROUP_CharacterSpecular,
    TEXTUREGROUP_Weapon,
    TEXTUREGROUP_WeaponNormalMap,
    TEXTUREGROUP_WeaponSpecular,
    TEXTUREGROUP_Vehicle,
    TEXTUREGROUP_VehicleNormalMap,
    TEXTUREGROUP_VehicleSpecular,
    TEXTUREGROUP_Cinematic,
    TEXTUREGROUP_Effects,
    TEXTUREGROUP_EffectsNotFiltered,
    TEXTUREGROUP_Skybox,
    TEXTUREGROUP_UI,
    TEXTUREGROUP_Lightmap,
    TEXTUREGROUP_RenderTarget,
    TEXTUREGROUP_MobileFlattened,
    TEXTUREGROUP_ProcBuilding_Face,
    TEXTUREGROUP_ProcBuilding_LightMap,
    TEXTUREGROUP_Shadowmap,
    TEXTUREGROUP_ColorLookupTable,
    TEXTUREGROUP_WorldImportant,
    TEXTUREGROUP_WorldImportantNormalMap,
    TEXTUREGROUP_WorldImportantSpecular,
};

enum TextureAddress
{
    TA_Wrap,
    TA_Clamp,
    TA_Mirror,
};

enum TextureFilter
{
    TF_Nearest,
    TF_Linear,
};

enum EPixelFormat
{
    PF_Unknown,
    PF_A32B32G32R32F,
    PF_A8R8G8B8,
    PF_G8,
    PF_G16,
    PF_DXT1,
    PF_DXT3,
    PF_DXT5,
    PF_UYVY,
    PF_FloatRGB,
    PF_FloatRGBA,
    PF_DepthStencil,
    PF_ShadowDepth,
    PF_FilteredShadowDepth,
    PF_R32F,
    PF_G16R16,
    PF_G16R16F,
    PF_G16R16F_FILTER,
    PF_G32R32F,
    PF_A2B10G10R10,
    PF_A16B16G16R16,
    PF_D24,
    PF_R16F,
    PF_R16F_FILTER,
    PF_BC5,
    PF_V8U8,
    PF_A1,
};

enum TextureCompressionSettings
{
    TC_Default,
    TC_Normalmap,
    TC_Displacementmap,
    TC_NormalmapAlpha,
    TC_Grayscale,
    TC_HighDynamicRange,
    TC_OneBitAlpha,
    TC_NormalmapUncompressed,
    TC_NormalmapBC5,
    TC_OneBitMonochrome,
};

struct native TextureGroupContainer
{
    var() const bool TEXTUREGROUP_World;
    var() const bool TEXTUREGROUP_WorldNormalMap;
    var() const bool TEXTUREGROUP_WorldSpecular;
    var() const bool TEXTUREGROUP_Character;
    var() const bool TEXTUREGROUP_CharacterNormalMap;
    var() const bool TEXTUREGROUP_CharacterSpecular;
    var() const bool TEXTUREGROUP_Weapon;
    var() const bool TEXTUREGROUP_WeaponNormalMap;
    var() const bool TEXTUREGROUP_WeaponSpecular;
    var() const bool TEXTUREGROUP_Vehicle;
    var() const bool TEXTUREGROUP_VehicleNormalMap;
    var() const bool TEXTUREGROUP_VehicleSpecular;
    var() const bool TEXTUREGROUP_Cinematic;
    var() const bool TEXTUREGROUP_Effects;
    var() const bool TEXTUREGROUP_EffectsNotFiltered;
    var() const bool TEXTUREGROUP_Skybox;
    var() const bool TEXTUREGROUP_UI;
    var() const bool TEXTUREGROUP_Lightmap;
    var() const bool TEXTUREGROUP_RenderTarget;
    var() const bool TEXTUREGROUP_MobileFlattened;
    var() const bool TEXTUREGROUP_ProcBuilding_Face;
    var() const bool TEXTUREGROUP_ProcBuilding_LightMap;
    var() const bool TEXTUREGROUP_Shadowmap;
    var() const bool TEXTUREGROUP_ColorLookupTable;
};

var() bool SRGB;
var bool RGBE;
var bool bIsSourceArtUncompressed;
var() bool CompressionNoAlpha;
var bool CompressionNone;
var deprecated bool CompressionNoMipmaps;
var() bool CompressionFullDynamicRange;
var() bool DeferCompression;
var bool NeverStream;
var() bool bDitherMipMapAlpha;
var() bool bPreserveBorderR;
var() bool bPreserveBorderG;
var() bool bPreserveBorderB;
var() bool bPreserveBorderA;
var const bool bNoTiling;
var const transient bool bAsyncResourceReleaseHasBeenStarted;
var const transient bool bUseCinematicMipLevels;
var() float UnpackMin[4];
var() float UnpackMax[4];
var const native UntypedBulkData_Mirror SourceArt;
var() TextureCompressionSettings CompressionSettings;
var() TextureFilter Filter;
var() TextureGroup LODGroup;
var() TextureMipGenSettings MipGenSettings;
var() int LODBias;
var transient int CachedCombinedLODBias;
var() int NumCinematicMipLevels;
var() editconst editoronly string SourceFilePath;
var() editconst editoronly string SourceFileTimestamp;
var const native Pointer Resource;
var const editoronly Guid LightingGuid;
var() float AdjustBrightness;
var() float AdjustBrightnessCurve;
var() float AdjustVibrance;
var() float AdjustSaturation;
var() float AdjustRGBCurve;
var() float AdjustHue;
var const int InternalFormatLODBias;

defaultproperties
{
    SRGB=True
    UnpackMax=1.0
    UnpackMax[1]=1.0
    UnpackMax[2]=1.0
    UnpackMax[3]=1.0
    Filter="TF_Linear"
    AdjustBrightness=1.0
    AdjustBrightnessCurve=1.0
    AdjustSaturation=1.0
    AdjustRGBCurve=1.0
}

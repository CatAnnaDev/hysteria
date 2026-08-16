class ParticleModule extends Object
    abstract
    native
    notplaceable
    editinlinenew
    hidecategories(Object);

enum EParticleSourceSelectionMethod
{
    EPSSM_Random,
    EPSSM_Sequential,
};

enum EModuleType
{
    EPMT_General,
    EPMT_TypeData,
    EPMT_Beam,
    EPMT_Trail,
    EPMT_Spawn,
    EPMT_Required,
    EPMT_Event,
};

struct native transient ParticleCurvePair
{
    var string CurveName;
    var Object CurveObject;
};

var bool bSpawnModule;
var bool bUpdateModule;
var bool bFinalUpdateModule;
var bool bCurvesAsColor;
var(Cascade) bool b3DDrawMode;
var bool bSupported3DDrawMode;
var bool bEnabled;
var bool bEditable;
var bool LODDuplicate;
var const byte LODValidity;
var(Cascade) Color ModuleEditorColor;

defaultproperties
{
    bEnabled=True
    bEditable=True
    LODDuplicate=True
}

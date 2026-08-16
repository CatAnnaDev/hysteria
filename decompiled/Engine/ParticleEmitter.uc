class ParticleEmitter extends Object
    abstract
    native
    notplaceable
    editinlinenew
    hidecategories(Object);

enum EEmitterRenderMode
{
    ERM_Normal,
    ERM_Point,
    ERM_Cross,
    ERM_None,
};

enum EParticleSubUVInterpMethod
{
    PSUVIM_None,
    PSUVIM_Linear,
    PSUVIM_Linear_Blend,
    PSUVIM_Random,
    PSUVIM_Random_Blend,
};

enum EParticleBurstMethod
{
    EPBM_Instant,
    EPBM_Interpolated,
};

struct native ParticleBurst
{
    var() int Count;
    var() int CountLow;
    var() float Time;
};

var(Particle) name EmitterName;
var transient int SubUVDataOffset;
var(Cascade) EEmitterRenderMode EmitterRenderMode;
var(Cascade) Color EmitterEditorColor;
var export editinline array<ParticleLODLevel> LODLevels;
var bool ConvertedModules;
var(Cascade) editoronly bool bCollapsed;
var transient bool bIsSoloing;
var bool bCookedOut;
var int PeakActiveParticles;
var(Particle) int InitialAllocationCount;

defaultproperties
{
    EmitterName="Particle Emitter"
    EmitterEditorColor=(B=150,G=150,R=0,A=255)
    ConvertedModules=True
}

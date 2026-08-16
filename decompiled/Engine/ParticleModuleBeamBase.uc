class ParticleModuleBeamBase extends ParticleModule
    abstract
    native
    notplaceable
    editinlinenew
    hidecategories(Object,Object);

enum Beam2SourceTargetTangentMethod
{
    PEB2STTM_Direct,
    PEB2STTM_UserSet,
    PEB2STTM_Distribution,
    PEB2STTM_Emitter,
};

enum Beam2SourceTargetMethod
{
    PEB2STM_Default,
    PEB2STM_UserSet,
    PEB2STM_Emitter,
    PEB2STM_Particle,
    PEB2STM_Actor,
};

defaultproperties
{
}

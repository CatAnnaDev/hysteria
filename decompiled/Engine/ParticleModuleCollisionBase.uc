class ParticleModuleCollisionBase extends ParticleModule
    abstract
    native
    notplaceable
    editinlinenew
    hidecategories(Object,Object);

enum EParticleCollisionComplete
{
    EPCC_Kill,
    EPCC_Freeze,
    EPCC_HaltCollisions,
    EPCC_FreezeTranslation,
    EPCC_FreezeRotation,
    EPCC_FreezeMovement,
};

defaultproperties
{
}

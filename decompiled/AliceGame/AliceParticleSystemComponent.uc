class AliceParticleSystemComponent extends ParticleSystemComponent
    native
    notplaceable
    editinlinenew
    hidecategories(Object,Physics,Collision);

var const float FOV;
var const bool bHasSavedScale3D;
var const Vector SavedScale3D;

native final function SetFOV(float NewFOV)
{
    NewFOV;
}

defaultproperties
{
    bOverrideLODMethod=True
    LODMethod="PARTICLESYSTEMLODMETHOD_DirectSet"
    ReplacementPrimitive="None"
}

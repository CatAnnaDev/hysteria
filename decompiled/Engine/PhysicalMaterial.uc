class PhysicalMaterial extends Object
    native
    notplaceable
    collapsecategories
    hidecategories(Object);

enum EPhysEffectType
{
    EPMET_Impact,
    EPMET_Slide,
};

var transient int MaterialIndex;
var() float Friction;
var() float Restitution;
var() bool bForceConeFriction;
var(Advanced) bool bEnableAnisotropicFriction;
var(Slide) bool bSlide;
var(Ragdoll) bool EnableRagdollEffect;
var(Advanced) Vector AnisoFrictionDir;
var(Advanced) float FrictionV;
var() float Density;
var() float AngularDamping;
var() float LinearDamping;
var() float MagneticResponse;
var() float WindResponse;
var(Impact) float ImpactThreshold;
var(Impact) float ImpactReFireDelay;
var(Impact) ParticleSystem ImpactEffect;
var(Impact) SoundCue ImpactSound;
var(Slide) float SlideThreshold;
var(Slide) float SlideReFireDelay;
var(Slide) ParticleSystem SlideEffect;
var(Slide) SoundCue SlideSound;
var(Fracture) SoundCue FractureSoundExplosion;
var(Fracture) SoundCue FractureSoundSingle;
var(Parent) PhysicalMaterial Parent;
var(PhysicalProperties) export editinline PhysicalMaterialPropertyBase PhysicalMaterialProperty;
var(Ragdoll) ParticleSystem RagdollImpactParticle;
var(Ragdoll) SoundCue RagdollImpactSound;

simulated function PhysicalMaterialPropertyBase GetPhysicalMaterialProperty(class<PhysicalMaterialPropertyBase> DesiredClass)
{
    if (PhysicalMaterialProperty != none && ClassIsChildOf(PhysicalMaterialProperty.Class, DesiredClass))
    {
        return PhysicalMaterialProperty;
    }
    else if (Parent != none)
    {
        return Parent.GetPhysicalMaterialProperty(DesiredClass);
    }
    else
    {
        return none;
    }
}

simulated function FindFractureSounds(out SoundCue OutSoundExplosion, out SoundCue OutSoundSingle)
{
    local PhysicalMaterial TestMat;
    
    OutSoundExplosion = none;
    OutSoundSingle = none;
    TestMat = self;
    while ((OutSoundExplosion == none || OutSoundSingle == none) && TestMat != none)
    {
        if (OutSoundSingle == none)
        {
            OutSoundSingle = TestMat.FractureSoundSingle;
        }
        if (OutSoundExplosion == none)
        {
            OutSoundExplosion = TestMat.FractureSoundExplosion;
        }
        TestMat = TestMat.Parent;
    }
    return;
}

native function PhysEffectInfo FindPhysEffectInfo(EPhysEffectType Type)
{
    Type;
}

defaultproperties
{
    Friction=0.7
    Restitution=0.3
    Density=1.0
    LinearDamping=0.01
}

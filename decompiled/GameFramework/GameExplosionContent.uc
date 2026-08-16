class GameExplosionContent extends Object
    notplaceable
    editinlinenew;

var() const bool bAutoControllerVibration;
var(Camera) const bool bOrientCameraShakeTowardsEpicenter;
var(Audio) const SoundCue ExplosionSound;
var(Camera) const CameraShake CamShake;
var(Camera) const CameraShake CamShake_Left;
var(Camera) const CameraShake CamShake_Right;
var(Camera) const CameraShake CamShake_Rear;
var(Camera) const float CamShakeInnerRadius;
var(Camera) const float CamShakeOuterRadius;
var(Camera) const float CamShakeFalloff;
var(Camera) const class<EmitterCameraLensEffectBase> CameraLensEffect;
var(Camera) const float CameraLensEffectRadius;
var(Light) const export editinline PointLightComponent ExploLight;
var(Light) const float ExploLightFadeOutTime;
var(Blur) const export editinline RadialBlurComponent ExploRadialBlur;
var(Blur) const float ExploRadialBlurFadeOutTime;
var(Blur) const float ExploRadialBlurMaxBlur;
var(Particle) const ParticleSystem ParticleEmitterTemplate;
var(Fog) const FogVolumeSphericalDensityInfo FogVolumeArchetype;

defaultproperties
{
}

class EmitterCameraLensEffectBase extends Emitter
    abstract
    native
    placeable
    hidecategories(Navigation);

var ParticleSystem PS_CameraEffect;
var ParticleSystem PS_CameraEffectNonExtremeContent;
var float BaseFOV;
var() const float DistFromCamera;
var() const protectedwrite bool bAllowMultipleInstances;
var transient Camera BaseCamera;

native simulated function UpdateLocation(out const Vector CamLoc, out const Rotator CamRot, float CamFOVDeg)
{
    CamLoc;
    CamRot;
    CamFOVDeg;
}

simulated function ActivateLensEffect()
{
    local ParticleSystem PSToActuallySpawn;
    
    if (WorldInfo.NetMode != 1)
    {
        if (WorldInfo.GRI.ShouldShowGore())
        {
            PSToActuallySpawn = PS_CameraEffect;
        }
        else
        {
            PSToActuallySpawn = PS_CameraEffectNonExtremeContent;
        }
        if (PSToActuallySpawn != none)
        {
            SetTemplate(PS_CameraEffect, bDestroyOnSystemFinish);
        }
    }
}

simulated function PostBeginPlay()
{
    ParticleSystemComponent.SetDepthPriorityGroup(2);
    PostBeginPlay();
    ActivateLensEffect();
}

function NotifyRetriggered()
{
}

function RegisterCamera(Camera C)
{
    BaseCamera = C;
}

function Destroyed()
{
    if (BaseCamera != none)
    {
        BaseCamera.RemoveCameraLensEffect(self);
    }
    Destroyed();
}

defaultproperties
{
    BaseFOV=80.0
    DistFromCamera=90.0
    ParticleSystemComponent="Default__EmitterCameraLensEffectBase.ParticleSystemComponent0"
    bDestroyOnSystemFinish=True
    bNoDelete=False
    bNetInitialRotation=True
    Components(0)="Default__EmitterCameraLensEffectBase.ParticleSystemComponent0"
    TickGroup="TG_PostAsyncWork"
    LifeSpan=10.0
}

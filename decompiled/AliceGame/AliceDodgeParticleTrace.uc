class AliceDodgeParticleTrace extends Actor
    native
    notplaceable
    hidecategories(Navigation);

var transient ParticleSystem DodgeFlightEffectsTemplate;
var export editinline ParticleSystemComponent DodgeFlightEffects;
var transient AlicePawn Alice;
var transient float FlightTotalTime;
var transient float FlightTime;
var transient float MaxHeight;

event FinishFlightEffects()
{
    DodgeFlightEffects.DeactivateSystem();
    DetachComponent(DodgeFlightEffects);
    DodgeFlightEffects.SetHidden(true);
}

event SpawnFlightEffects()
{
    DodgeFlightEffects.SetTemplate(DodgeFlightEffectsTemplate);
    DodgeFlightEffects.SetAbsolute(false, false, false);
    DodgeFlightEffects.SetLODLevel(WorldInfo.bDropDetail ? 1 : 0);
    DodgeFlightEffects.bUpdateComponentInTick = true;
    AttachComponent(DodgeFlightEffects);
    DodgeFlightEffects.SetHidden(false);
}

simulated function PostBeginPlay()
{
    PostBeginPlay();
    if (bDeleteMe)
    {
        return;
    }
    DodgeFlightEffects.SetHidden(true);
}

defaultproperties
{
    DodgeFlightEffects="Default__AliceDodgeParticleTrace.Particle"
    Physics="PHYS_Projectile"
}

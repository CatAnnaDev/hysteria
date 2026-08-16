class GameParticleEventManager extends ParticleEventManager
    abstract
    native
    notplaceable
    hidecategories(Navigation);

event HandleParticleModuleEventSendToGame(ParticleModuleEventSendToGame InEvent, out const Vector InCollideDirection, out const Vector InHitLocation, out const Vector InHitNormal, out const name InBoneName)
{
    InEvent.DoEvent(InCollideDirection, InHitLocation, InHitNormal, InBoneName);
}

defaultproperties
{
}

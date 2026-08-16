class ParticleEventManager extends Actor
    abstract
    native
    notplaceable
    config(Game)
    hidecategories(Navigation);

event HandleParticleModuleEventSendToGame(ParticleModuleEventSendToGame InEvent, out const Vector InCollideDirection, out const Vector InHitLocation, out const Vector InHitNormal, out const name InBoneName)
{
}

defaultproperties
{
    CollisionType="COLLIDE_CustomDefault"
}

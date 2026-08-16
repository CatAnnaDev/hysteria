class ActorFactoryAmbientSound extends ActorFactory
    native
    notplaceable
    editinlinenew
    collapsecategories
    config(Editor)
    hidecategories(Object,Object);

var() SoundCue AmbientSoundCue;

defaultproperties
{
    MenuName="Add AmbientSound"
    MenuPriority=11
    NewActorClass="AmbientSound"
}

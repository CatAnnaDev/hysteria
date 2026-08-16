class AmbientSoundSimple extends AmbientSound
    native
    placeable
    hidecategories(Navigation,Audio)
    autoexpandcategories(Audio,AmbientSoundSimple);

var() editconst editinline SoundNodeAmbient AmbientProperties;
var const export editinline SoundCue SoundCueInstance;
var const export editinline SoundNodeAmbient SoundNodeInstance;

defaultproperties
{
    SoundCueInstance="Default__AmbientSoundSimple.SoundCue0"
    SoundNodeInstance="Default__AmbientSoundSimple.SoundNodeAmbient0"
    AudioComponent="Default__AmbientSoundSimple.AudioComponent0"
    SpriteComp="Default__AmbientSoundSimple.Sprite"
    Components(0)="Default__AmbientSoundSimple.Sprite"
    Components(1)="Default__AmbientSoundSimple.DrawSoundRadius0"
    Components(2)="Default__AmbientSoundSimple.AudioComponent0"
}

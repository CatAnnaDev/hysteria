class AmbientSound extends Keypoint
    native
    placeable
    hidecategories(Navigation)
    autoexpandcategories(Audio);

var() bool bAutoPlay;
var bool bIsPlaying;
var(Audio) const export editconst editinline AudioComponent AudioComponent;

defaultproperties
{
    bAutoPlay=True
    AudioComponent="Default__AmbientSound.AudioComponent0"
    SpriteComp="Default__AmbientSound.Sprite"
    Components(0)="Default__AmbientSound.Sprite"
    Components(1)="Default__AmbientSound.DrawSoundRadius0"
    Components(2)="Default__AmbientSound.AudioComponent0"
}

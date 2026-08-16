class AmbientSoundMovable extends AmbientSound
    native
    placeable
    hidecategories(Navigation)
    autoexpandcategories(Audio);

defaultproperties
{
    AudioComponent="Default__AmbientSoundMovable.AudioComponent0"
    SpriteComp="Default__AmbientSoundMovable.Sprite"
    bStatic=False
    Components(0)="Default__AmbientSoundMovable.Sprite"
    Components(1)="Default__AmbientSoundMovable.DrawSoundRadius0"
    Components(2)="Default__AmbientSoundMovable.AudioComponent0"
    Physics="PHYS_Interpolating"
    TickGroup="TG_DuringAsyncWork"
}

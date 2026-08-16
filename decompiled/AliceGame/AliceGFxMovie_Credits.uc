class AliceGFxMovie_Credits extends AliceGFXMovie
    notplaceable;

var() SoundCue CreditsMusic;

function PlayMusic(string Index)
{
    switch (Index)
    {
        case "CreditsMusic":
            GetAlicePlayerController().playUniqueSound(CreditsMusic);
            break;
        default:
    }
}

defaultproperties
{
}

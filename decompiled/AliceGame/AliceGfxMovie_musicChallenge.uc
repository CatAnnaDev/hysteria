class AliceGfxMovie_musicChallenge extends AliceGFXMovie
    notplaceable;

var() SoundCue Ch2_A_Sound;
var() SoundCue Ch2_B_Sound;
var() SoundCue Ch2_X_Sound;
var() SoundCue Ch2_Y_Sound;
var() SoundCue Ch3_A_Sound;
var() SoundCue Ch3_B_Sound;
var() SoundCue Ch3_X_Sound;
var() SoundCue Ch3_Y_Sound;
var() SoundCue Ch5_A_Sound;
var() SoundCue Ch5_B_Sound;
var() SoundCue Ch5_X_Sound;
var() SoundCue Ch5_Y_Sound;

function PlaySound(string Id)
{
    LogInternal("PlaySound=" @ Id);
    switch (Id)
    {
        case "chapter_0_1":
            GetAlicePlayerController().PlaySound(Ch2_Y_Sound);
            break;
        case "chapter_0_2":
            GetAlicePlayerController().PlaySound(Ch2_X_Sound);
            break;
        case "chapter_0_3":
            GetAlicePlayerController().PlaySound(Ch2_B_Sound);
            break;
        case "chapter_0_4":
            GetAlicePlayerController().PlaySound(Ch2_A_Sound);
            break;
        case "chapter_1_1":
            GetAlicePlayerController().PlaySound(Ch3_Y_Sound);
            break;
        case "chapter_1_2":
            GetAlicePlayerController().PlaySound(Ch3_X_Sound);
            break;
        case "chapter_1_3":
            GetAlicePlayerController().PlaySound(Ch3_B_Sound);
            break;
        case "chapter_1_4":
            GetAlicePlayerController().PlaySound(Ch3_A_Sound);
            break;
        case "chapter_2_1":
            GetAlicePlayerController().PlaySound(Ch5_Y_Sound);
            break;
        case "chapter_2_2":
            GetAlicePlayerController().PlaySound(Ch5_X_Sound);
            break;
        case "chapter_2_3":
            GetAlicePlayerController().PlaySound(Ch5_B_Sound);
            break;
        case "chapter_2_4":
            GetAlicePlayerController().PlaySound(Ch5_A_Sound);
            break;
        default:
    }
}

defaultproperties
{
}

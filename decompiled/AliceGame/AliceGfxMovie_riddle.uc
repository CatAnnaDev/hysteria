class AliceGfxMovie_riddle extends AliceGFXMovie
    notplaceable;

var() SoundCue Wrong_1;
var() SoundCue Wrong_2;
var() SoundCue Wrong_3;
var() SoundCue Question_1;
var() SoundCue Question_2;
var() SoundCue Question_3;
var() SoundCue Question_4;
var() SoundCue Question_5;
var() SoundCue Question_6;
var() SoundCue Question_7;
var() SoundCue Question_8;
var() SoundCue Question_9;
var() SoundCue Question_10;
var() SoundCue Question_11;
var() SoundCue Question_12;
var() SoundCue Question_13;
var() SoundCue Question_14;
var() SoundCue Question_15;
var() SoundCue Question_16;

function stopSound()
{
    APC.playUniqueSound(none);
}

function PlayWrongSound(int Id)
{
    switch (Id)
    {
        case 1:
            APC.playUniqueSound(Wrong_1);
            break;
        case 2:
            APC.playUniqueSound(Wrong_2);
            break;
        case 3:
            APC.playUniqueSound(Wrong_3);
            break;
        default:
    }
}

function PlayQuestionSound(int Id)
{
    switch (Id)
    {
        case 1:
            APC.playUniqueSound(Question_1);
            break;
        case 2:
            APC.playUniqueSound(Question_2);
            break;
        case 3:
            APC.playUniqueSound(Question_3);
            break;
        case 4:
            APC.playUniqueSound(Question_4);
            break;
        case 7:
            APC.playUniqueSound(Question_7);
            break;
        case 8:
            APC.playUniqueSound(Question_8);
            break;
        case 9:
            APC.playUniqueSound(Question_9);
            break;
        case 10:
            APC.playUniqueSound(Question_10);
            break;
        case 11:
            APC.playUniqueSound(Question_11);
            break;
        case 12:
            APC.playUniqueSound(Question_12);
            break;
        case 13:
            APC.playUniqueSound(Question_13);
            break;
        case 14:
            APC.playUniqueSound(Question_14);
            break;
        case 15:
            APC.playUniqueSound(Question_15);
            break;
        case 16:
            APC.playUniqueSound(Question_16);
            break;
        default:
            APC.playUniqueSound(none);
            break;
    }
}

defaultproperties
{
}

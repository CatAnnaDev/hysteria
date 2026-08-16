class AliceGFxMovieGameMenu extends GFxMovie
    native
    notplaceable;

var SoundCue ConfirmSound;
var SoundCue GoBackSound;
var SoundCue SlideSound;
var SoundCue StartSound;

function PlaySound(int Index)
{
    if (Index == 1)
    {
        PlayMenuSound(ConfirmSound);
    }
    else if (Index == 2)
    {
        PlayMenuSound(GoBackSound);
    }
    else if (Index == 3)
    {
        PlayMenuSound(SlideSound);
    }
    else if (Index == 4)
    {
        PlayMenuSound(StartSound);
    }
}

native function PlayMenuSound(SoundCue sound_cue)
{
    sound_cue;
}

function setres(string Mode)
{
    GetGameViewportClient().ConsoleCommand("Setres " $ Mode);
}

function QuitGame()
{
    Close();
    GetGameViewportClient().ConsoleCommand("quit");
}

function RestartGame()
{
    Close();
    GetGameViewportClient().ConsoleCommand("restart");
}

function continueGame()
{
    Close();
}

function SetupResolution(string Mode)
{
    ActionScriptVoid("_root.changeSelfToResolution");
}

event OnClose()
{
}

function bool Start(optional bool StartPaused = false)
{
    local Vector2D ViewSize;
    
    Start(StartPaused);
    Advance(0.0);
    GetGameViewportClient().GetViewportSize(ViewSize);
    return true;
}

defaultproperties
{
    ConfirmSound="UI_SFX.Menu_Confirm_Cue"
    GoBackSound="UI_SFX.Menu_GoBack_Cue"
    SlideSound="UI_SFX.Menu_Slider_Cue"
    StartSound="UI_SFX.OK_Cue"
}

class GFxMovieHudMenu extends GFxMovie
    notplaceable;

function Quit()
{
    GetGameViewportClient().ConsoleCommand("quit");
}

function MenuClose()
{
    local PlayerController Player;
    
    SetFocus(false, false);
    if (GetGameViewportClient().Outer.GamePlayers.Length > 0)
    {
        Player = GetGameViewportClient().Outer.GamePlayers[0].Actor;
        if (Player != none)
        {
            Player.SetPause(false);
        }
    }
}

function MenuOpen()
{
    local PlayerController Player;
    
    SetFocus(true);
    if (GetGameViewportClient().Outer.GamePlayers.Length > 0)
    {
        Player = GetGameViewportClient().Outer.GamePlayers[0].Actor;
        if (Player != none)
        {
            Player.SetPause(true);
        }
    }
}

function SetupResolution(int X, int Y)
{
    ActionScriptVoid("_root.SetupResolution");
}

function bool Start(optional bool StartPaused = false)
{
    local Vector2D ViewSize;
    
    Start(StartPaused);
    Advance(0.0);
    GetGameViewportClient().GetViewportSize(ViewSize);
    SetupResolution(int(ViewSize.X), int(ViewSize.Y));
    return true;
}

defaultproperties
{
}

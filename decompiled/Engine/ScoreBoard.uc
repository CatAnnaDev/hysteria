class ScoreBoard extends HUD
    notplaceable
    transient
    config(Game)
    hidecategories(Navigation);

var bool bDisplayMessages;

function ChangeState(bool bIsVisible)
{
}

function UpdateScoreBoard()
{
}

function bool UpdateGRI()
{
    if (WorldInfo.GRI == none)
    {
        return false;
    }
    WorldInfo.GRI.SortPRIArray();
    return true;
}

function DrawHUD()
{
    UpdateGRI();
    UpdateScoreBoard();
}

defaultproperties
{
}

class AliceGameMenu extends Actor
    native
    notplaceable
    hidecategories(Navigation);

var() AliceGFxMovieGameMenu Movie;
var() bool bTakeFocus;
var() bool bCaptureInput;
var() bool bStartPaused;

native function OpenGameMenu()
{
}

defaultproperties
{
    bTakeFocus=True
    bCaptureInput=True
    CollisionType="COLLIDE_CustomDefault"
}

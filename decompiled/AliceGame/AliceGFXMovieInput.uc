class AliceGFXMovieInput extends Actor
    notplaceable
    hidecategories(Navigation);

var bool bActive;
var AlicePlayerController APC;
var AliceGfxMovie_inGameMenu inGameMenu;

event Tick(float DeltaTime)
{
    local float X, Y;
    
    if (!bActive)
    {
        return;
    }
    if (APC != none)
    {
        X = APC.GetOriStrafe();
        Y = APC.GetOriForward();
        if (Abs(X) > float(0) || Abs(Y) > float(0))
        {
            if (inGameMenu != none)
            {
                inGameMenu.SetInput(X, Y);
            }
        }
    }
}

defaultproperties
{
    bAlwaysTick=True
    CollisionType="COLLIDE_CustomDefault"
}

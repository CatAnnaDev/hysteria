class SpriteComponent extends PrimitiveComponent
    native
    notplaceable
    editinlinenew
    collapsecategories
    hidecategories(Object);

var() Texture2D Sprite;
var() bool bIsScreenSizeScaled;
var() float ScreenSize;
var() float U;
var() float UL;
var() float V;
var() float VL;

native simulated function SetSpriteAndUV(Texture2D NewSprite, int NewU, int NewUL, int NewV, int NewVL)
{
    NewSprite;
    NewU;
    NewUL;
    NewV;
    NewVL;
}

native simulated function SetUV(int NewU, int NewUL, int NewV, int NewVL)
{
    NewU;
    NewUL;
    NewV;
    NewVL;
}

native simulated function SetSprite(Texture2D NewSprite)
{
    NewSprite;
}

defaultproperties
{
    Sprite="EditorResources.S_Actor"
    ScreenSize=0.1
    ReplacementPrimitive="None"
}

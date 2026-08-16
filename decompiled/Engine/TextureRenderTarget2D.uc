class TextureRenderTarget2D extends TextureRenderTarget
    native
    notplaceable
    hidecategories(Object,Texture);

var() const int SizeX;
var() const int SizeY;
var const EPixelFormat Format;
var() TextureAddress AddressX;
var() TextureAddress AddressY;
var const LinearColor ClearColor;
var() const transient bool bForceLinearGamma;

native static final function TextureRenderTarget2D Create(int InSizeX, int InSizeY, optional EPixelFormat InFormat = 2, optional LinearColor InClearColor, optional bool bOnlyRenderOnce)
{
    InSizeX;
    InSizeY;
    InFormat;
    InClearColor;
    bOnlyRenderOnce;
}

defaultproperties
{
    Format="PF_A8R8G8B8"
    ClearColor=(R=0.0,G=1.0,B=0.0,A=1.0)
}

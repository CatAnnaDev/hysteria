class TextureRenderTargetCube extends TextureRenderTarget
    native
    notplaceable
    hidecategories(Object,Texture);

var() int SizeX;
var const EPixelFormat Format;

defaultproperties
{
    Format="PF_A8R8G8B8"
}

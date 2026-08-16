class TextureCube extends Texture
    native
    notplaceable
    hidecategories(Object);

var const transient int SizeX;
var const transient int SizeY;
var const transient EPixelFormat Format;
var const transient int NumMips;
var const transient bool bIsCubemapValid;
var() const Texture2D FacePosX;
var() const Texture2D FaceNegX;
var() const Texture2D FacePosY;
var() const Texture2D FaceNegY;
var() const Texture2D FacePosZ;
var() const Texture2D FaceNegZ;

defaultproperties
{
}

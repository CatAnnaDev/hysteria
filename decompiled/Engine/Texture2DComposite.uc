class Texture2DComposite extends Texture
    native
    notplaceable
    hidecategories(Object);

struct native SourceTexture2DRegion
{
    var int OffsetX;
    var int OffsetY;
    var int SizeX;
    var int SizeY;
    var Texture2D Texture2D;
};

var array<SourceTexture2DRegion> SourceRegions;
var int MaxTextureSize;

native final function ResetSourceRegions()
{
}

native final function UpdateCompositeTexture(int NumMipsToGenerate)
{
    NumMipsToGenerate;
}

native final function bool SourceTexturesFullyStreamedIn()
{
}

defaultproperties
{
    NeverStream=True
}

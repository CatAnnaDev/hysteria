class Texture2DDynamic extends Texture
    native
    notplaceable
    hidecategories(Object);

var native transient int SizeX;
var native transient int SizeY;
var native transient EPixelFormat Format;
var native transient int NumMips;
var native transient bool bIsResolveTarget;

native static final function Texture2DDynamic Create(int InSizeX, int InSizeY, optional EPixelFormat InFormat = 2, optional bool InIsResolveTarget = false)
{
    InSizeX;
    InSizeY;
    InFormat;
    InIsResolveTarget;
}

native final function Init(int InSizeX, int InSizeY, optional EPixelFormat InFormat = 2, optional bool InIsResolveTarget = false)
{
    InSizeX;
    InSizeY;
    InFormat;
    InIsResolveTarget;
}

defaultproperties
{
    NeverStream=True
}

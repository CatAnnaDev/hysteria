class Font extends Object
    native
    notplaceable
    hidecategories(Object);

const NULLCHARACTER = 127;

struct native immutable FontCharacter
{
    var() int StartU;
    var() int StartV;
    var() int USize;
    var() int VSize;
    var() byte TextureIndex;
    var() int VerticalOffset;
};

var() editinline array<FontCharacter> Characters;
var array<Texture2D> Textures;
var const native map<int, int> CharRemap;
var int IsRemapped;
var() int Kerning;
var() FontImportOptionsData ImportOptions;
var transient int NumCharacters;
var transient array<int> MaxCharHeight;

native function float GetMaxCharHeight()
{
}

native final function float GetAuthoredViewportHeight(float ViewportHeight)
{
    ViewportHeight;
}

native function float GetScalingFactor(float HeightTest)
{
    HeightTest;
}

native function int GetResolutionPageIndex(float HeightTest)
{
    HeightTest;
}

defaultproperties
{
    ImportOptions=(FontName="Arial",Height=16.0,bEnableAntialiasing=True,bEnableBold=False,bEnableItalic=False,bEnableUnderline=False,bAlphaOnly=False,CharacterSet="FontICS_Default",Chars="",UnicodeRange="",CharsFilePath="",CharsFileWildcard="",bCreatePrintableOnly=False,bIncludeASCIIRange=True,ForegroundColor=(R=1.0,G=1.0,B=1.0,A=1.0),bEnableDropShadow=False,TexturePageWidth=256,TexturePageMaxHeight=256,XPadding=1,YPadding=1,ExtendBoxTop=0,ExtendBoxBottom=0,ExtendBoxRight=0,ExtendBoxLeft=0,bEnableLegacyMode=False,Kerning=0,bUseDistanceFieldAlpha=False,DistanceFieldScaleFactor=16,DistanceFieldScanRadiusScale=1.0)
}

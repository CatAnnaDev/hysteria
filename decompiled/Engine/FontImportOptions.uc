class FontImportOptions extends Object
    native
    notplaceable
    transient
    hidecategories(Object);

enum EFontImportCharacterSet
{
    FontICS_Default,
    FontICS_Ansi,
    FontICS_Symbol,
};

struct native FontImportOptionsData
{
    var() string FontName;
    var() float Height;
    var() bool bEnableAntialiasing;
    var() bool bEnableBold;
    var() bool bEnableItalic;
    var() bool bEnableUnderline;
    var() bool bAlphaOnly;
    var() EFontImportCharacterSet CharacterSet;
    var() string Chars;
    var() string UnicodeRange;
    var() string CharsFilePath;
    var() string CharsFileWildcard;
    var() bool bCreatePrintableOnly;
    var() bool bIncludeASCIIRange;
    var() LinearColor ForegroundColor;
    var() bool bEnableDropShadow;
    var() int TexturePageWidth;
    var() int TexturePageMaxHeight;
    var() int XPadding;
    var() int YPadding;
    var() int ExtendBoxTop;
    var() int ExtendBoxBottom;
    var() int ExtendBoxRight;
    var() int ExtendBoxLeft;
    var() bool bEnableLegacyMode;
    var() int Kerning;
    var() bool bUseDistanceFieldAlpha;
    var() int DistanceFieldScaleFactor;
    var() float DistanceFieldScanRadiusScale;
};

var() FontImportOptionsData Data;

defaultproperties
{
    Data=(FontName="Arial",Height=16.0,bEnableAntialiasing=True,bEnableBold=False,bEnableItalic=False,bEnableUnderline=False,bAlphaOnly=False,CharacterSet="FontICS_Default",Chars="",UnicodeRange="",CharsFilePath="",CharsFileWildcard="",bCreatePrintableOnly=False,bIncludeASCIIRange=True,ForegroundColor=(R=1.0,G=1.0,B=1.0,A=1.0),bEnableDropShadow=False,TexturePageWidth=256,TexturePageMaxHeight=256,XPadding=1,YPadding=1,ExtendBoxTop=0,ExtendBoxBottom=0,ExtendBoxRight=0,ExtendBoxLeft=0,bEnableLegacyMode=False,Kerning=0,bUseDistanceFieldAlpha=False,DistanceFieldScaleFactor=16,DistanceFieldScanRadiusScale=1.0)
}

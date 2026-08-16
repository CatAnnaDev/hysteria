class GFxMovieInfo extends Object
    native
    notplaceable
    editinlinenew
    hidecategories(Object)
    autoexpandcategories(Import);

var const array<byte> RawData;
var() array<Object> References;
var() array<Object> UserReferences;
var() editconst bool bUsesFontlib;
var(Import) editoronly bool bUseGFxExport;
var(Import) editoronly bool bGFxExportSRGBTextures;
var() int RTTextures;
var() int RTVideoTextures;
var(Import) editoronly string SourceFile;
var(Import) editoronly string GFxExportCmdLine;

defaultproperties
{
    RTTextures=24
    RTVideoTextures=2
}

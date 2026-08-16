class ScriptedTexture extends TextureRenderTarget2D
    native
    notplaceable
    hidecategories(Object,Texture);

var transient bool bNeedsUpdate;
var transient bool bSkipNextClear;
var delegate<Render> __Render__Delegate;

delegate Render(Canvas C)
{
}

defaultproperties
{
    bNeedsUpdate=True
    bNeedsTwoCopies=False
}

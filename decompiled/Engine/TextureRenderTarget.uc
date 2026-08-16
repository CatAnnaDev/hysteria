class TextureRenderTarget extends Texture
    abstract
    native
    notplaceable;

var transient bool bUpdateImmediate;
var() bool bNeedsTwoCopies;
var() bool bRenderOnce;

defaultproperties
{
    bNeedsTwoCopies=True
    CompressionNone=True
    NeverStream=True
    LODGroup="TEXTUREGROUP_RenderTarget"
}

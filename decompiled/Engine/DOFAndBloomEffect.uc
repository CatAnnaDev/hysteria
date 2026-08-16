class DOFAndBloomEffect extends DOFEffect
    native
    notplaceable
    hidecategories(Object);

var() float BloomScale;
var() float SceneMultiplier;
var() float BlurBloomKernelSize;
var() bool bEnableSeparateBloom;
var() bool bEnableReferenceDOF;

defaultproperties
{
    BloomScale=1.0
    SceneMultiplier=1.0
    BlurBloomKernelSize=16.0
    BlurKernelSize=16.0
}

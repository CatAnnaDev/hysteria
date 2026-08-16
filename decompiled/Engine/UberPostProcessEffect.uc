class UberPostProcessEffect extends DOFBloomMotionBlurEffect
    native
    notplaceable
    hidecategories(Object);

var() Vector SceneShadows;
var() Vector SceneHighLights;
var() Vector SceneMidTones;
var() float SceneDesaturation;
var() bool bDisableDOFAndBloom;

defaultproperties
{
    SceneShadows=(X=0.0,Y=0.0,Z=-0.003)
    SceneHighLights=(X=0.8,Y=0.8,Z=0.8)
    SceneMidTones=(X=1.3,Y=1.3,Z=1.3)
    SceneDesaturation=0.4
}

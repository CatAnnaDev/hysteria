class PostProcessEffect extends Object
    native
    notplaceable
    hidecategories(Object);

var() bool bShowInEditor;
var() bool bShowInGame;
var() bool bUseWorldSettings;
var bool bAffectsLightingOnly;
var() name EffectName;
var int NodePosY;
var int NodePosX;
var int DrawWidth;
var int DrawHeight;
var int OutDrawY;
var int InDrawY;
var() ESceneDepthPriorityGroup SceneDPG;

defaultproperties
{
    bShowInEditor=True
    bShowInGame=True
    SceneDPG="SDPG_PostProcess"
}

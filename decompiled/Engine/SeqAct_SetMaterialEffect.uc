class SeqAct_SetMaterialEffect extends SequenceAction
    native
    notplaceable
    hidecategories(Object);

struct native MatParameter
{
    var() name ParamName;
    var() float ScalarValue;
    var() bool bActiveVaryingTime;
};

var() name EffectName;
var() bool bShowInEditor;
var() bool bShowInGame;
var() bool bSetNewMaterial;
var() bool bUseScreenAsTexture;
var() MaterialInterface NewMaterial;
var() array<MatParameter> MatParameters;

static event int GetObjClassVersion()
{
    return GetObjClassVersion() + 1;
}

defaultproperties
{
    bShowInEditor=True
    bShowInGame=True
    bSetNewMaterial=True
    ObjName="Set MaterialEffect"
    ObjCategory="PostProcess"
}

class AliceAnimNotify_SetMatParam extends AnimNotify
    native
    notplaceable
    editinlinenew
    collapsecategories
    hidecategories(Object);

enum EMatParamType
{
    EMPT_Float,
    EMPT_Bool,
};

struct native MatParamInfo
{
    var() EMatParamType ParamType;
    var() int MatID;
    var() name ParamName;
    var() float ScalarValue;
    var() bool SwitchValue;
    var() bool bActiveVaryingTime;
};

var() array<MatParamInfo> MatParamInfos;

defaultproperties
{
}

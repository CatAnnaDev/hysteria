class DistributionFloatParameterBase extends DistributionFloatConstant
    abstract
    native
    notplaceable
    editinlinenew
    collapsecategories
    hidecategories(Object,Object,Object);

enum DistributionParamMode
{
    DPM_Normal,
    DPM_Abs,
    DPM_Direct,
};

var() name ParameterName;
var() float MinInput;
var() float MaxInput;
var() float MinOutput;
var() float MaxOutput;
var() DistributionParamMode ParamMode;

defaultproperties
{
    MaxInput=1.0
    MaxOutput=1.0
}

class DistributionVectorParameterBase extends DistributionVectorConstant
    abstract
    native
    notplaceable
    editinlinenew
    collapsecategories
    hidecategories(Object,Object,Object);

var() name ParameterName;
var() Vector MinInput;
var() Vector MaxInput;
var() Vector MinOutput;
var() Vector MaxOutput;
var() export DistributionParamMode ParamModes[3];

defaultproperties
{
    MaxInput=(X=1.0,Y=1.0,Z=1.0)
    MaxOutput=(X=1.0,Y=1.0,Z=1.0)
}

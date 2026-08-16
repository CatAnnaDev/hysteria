class KynapseEntityInfoDefinition extends Object
    native
    notplaceable
    editinlinenew
    hidecategories(Object);

var() const string infoClass;
var() float validTime;
var() float unsafeTime;
var() float estimatedComputationTime;
var() bool immediateMode;

defaultproperties
{
    validTime=200.0
    unsafeTime=1000.0
    estimatedComputationTime=0.1
}

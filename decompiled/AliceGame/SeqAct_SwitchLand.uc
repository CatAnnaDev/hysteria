class SeqAct_SwitchLand extends SequenceAction
    native
    notplaceable
    hidecategories(Object);

var() bool bSwitchToWonderland;
var() bool bSwitchToLondon;
var() bool bSwitchToTransition;
var() bool bSwitchToShadowMode;
var() bool bSwitchToGiantMode;
var() bool bSwitchToRollingMode;
var() bool bSwitchToSwimMode;
var() bool bSwitchToWaterWalkMode;
var() bool bSwitchToAsylum;

defaultproperties
{
    bSwitchToWonderland=True
    ObjName="Switch Land"
    ObjCategory="Alice"
}

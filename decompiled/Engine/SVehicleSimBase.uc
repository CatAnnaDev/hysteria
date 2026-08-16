class SVehicleSimBase extends ActorComponent
    native
    notplaceable;

var() float WheelSuspensionStiffness;
var() float WheelSuspensionDamping;
var() float WheelSuspensionBias;
var() float WheelLongExtremumSlip;
var() float WheelLongExtremumValue;
var() float WheelLongAsymptoteSlip;
var() float WheelLongAsymptoteValue;
var() float WheelLatExtremumSlip;
var() float WheelLatExtremumValue;
var() float WheelLatAsymptoteSlip;
var() float WheelLatAsymptoteValue;
var() float WheelInertia;
var() bool bWheelSpeedOverride;
var() bool bClampedFrictionModel;
var() bool bAutoDrive;
var() float AutoDriveSteer;

defaultproperties
{
    WheelLongExtremumSlip=0.1
    WheelLongExtremumValue=1.0
    WheelLongAsymptoteSlip=2.0
    WheelLongAsymptoteValue=0.6
    WheelLatExtremumSlip=0.35
    WheelLatExtremumValue=0.85
    WheelLatAsymptoteSlip=1.4
    WheelLatAsymptoteValue=0.7
    WheelInertia=1.0
}

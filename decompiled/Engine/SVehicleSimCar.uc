class SVehicleSimCar extends SVehicleSimBase
    native
    notplaceable;

var() float ChassisTorqueScale;
var() InterpCurveFloat MaxSteerAngleCurve;
var() float SteerSpeed;
var() float ReverseThrottle;
var() float EngineBrakeFactor;
var() float MaxBrakeTorque;
var() float StopThreshold;
var bool bIsDriving;
var float ActualSteering;
var float TimeSinceThrottle;

defaultproperties
{
    ReverseThrottle=-1.0
}

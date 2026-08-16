class SVehicleSimTank extends SVehicleSimCar
    native
    notplaceable;

var float LeftTrackVel;
var float RightTrackVel;
var float LeftTrackTorque;
var float RightTrackTorque;
var() float MaxEngineTorque;
var() float EngineDamping;
var() float InsideTrackTorqueFactor;
var() float SteeringLatStiffnessFactor;
var() float TurnInPlaceThrottle;
var() float TurnMaxGripReduction;
var() float TurnGripScaleRate;
var() bool bTurnInPlaceOnSteer;

defaultproperties
{
    TurnMaxGripReduction=0.97
    TurnGripScaleRate=1.0
    bTurnInPlaceOnSteer=True
    bWheelSpeedOverride=True
}

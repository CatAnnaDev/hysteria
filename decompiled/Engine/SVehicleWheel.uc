class SVehicleWheel extends Component
    native
    notplaceable;

enum EWheelSide
{
    SIDE_None,
    SIDE_Left,
    SIDE_Right,
};

var() float Steer;
var() float MotorTorque;
var() float BrakeTorque;
var() float ChassisTorque;
var() bool bPoweredWheel;
var() bool bHoverWheel;
var() bool bCollidesVehicles;
var() bool bCollidesPawns;
var bool bIsSquealing;
var bool bWheelOnGround;
var() float SteerFactor;
var() name SkelControlName;
var SkelControlWheel WheelControl;
var() name BoneName;
var() Vector BoneOffset;
var() float WheelRadius;
var() float SuspensionTravel;
var() float SuspensionSpeed;
var() ParticleSystem WheelParticleSystem;
var() EWheelSide Side;
var() float LongSlipFactor;
var() float LatSlipFactor;
var() float HandbrakeLongSlipFactor;
var() float HandbrakeLatSlipFactor;
var() float ParkedSlipFactor;
var Vector WheelPosition;
var float SpinVel;
var float LongSlipRatio;
var float LatSlipAngle;
var Vector ContactNormal;
var Vector LongDirection;
var Vector LatDirection;
var float ContactForce;
var float LongImpulse;
var float LatImpulse;
var float DesiredSuspensionPosition;
var float SuspensionPosition;
var float CurrentRotation;
var const transient Pointer WheelShape;
var const transient int WheelMaterialIndex;
var class<ParticleSystemComponent> WheelPSCClass;
var export editinline ParticleSystemComponent WheelParticleComp;
var name SlipParticleParamName;

defaultproperties
{
    bCollidesVehicles=True
    WheelRadius=35.0
    SuspensionTravel=30.0
    SuspensionSpeed=50.0
    LongSlipFactor=4000.0
    LatSlipFactor=20000.0
    HandbrakeLongSlipFactor=4000.0
    HandbrakeLatSlipFactor=20000.0
    ParkedSlipFactor=20000.0
    WheelPSCClass="ParticleSystemComponent"
    SlipParticleParamName="WheelSlip"
}

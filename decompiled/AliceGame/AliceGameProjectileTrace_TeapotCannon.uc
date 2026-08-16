class AliceGameProjectileTrace_TeapotCannon extends AliceGameProjectileTrace_CurveToDestNoXY
    native
    notplaceable
    config(Weapon);

var config float FPSGravAcceleration;
var config float FPSGravAccelerationRate;
var transient float NoGravFlightTime;

defaultproperties
{
    FPSGravAcceleration=-3000.0
    FPSGravAccelerationRate=6000.0
}

class AliceGameProjectileTrace_MagicRandomCurve extends AliceGameProjectileTrace_DirectLine
    native
    notplaceable
    config(Weapon);

var transient int TraceIndex;
var transient float FlightTotalTime;
var float FlightTotalTime1;
var float CircleRadius1;
var float CircleDist1;
var float CircleAngle1;
var int Dist1Mode;
var int Radius1Mode;
var int Angle1Mode;
var transient float FlightTime1;
var transient Vector FlightFront1;
var transient Vector FlightRight1;
var transient Vector FlightUp1;
var transient Vector FlightOrient1;
var float FlightTotalTime2;
var float CircleRadius2;
var float CircleDist2;
var float CircleAngle2;
var int Dist2Mode;
var int Radius2Mode;
var int Angle2Mode;
var transient float FlightTime2;
var transient Vector FlightFront2;
var transient Vector FlightRight2;
var transient Vector FlightUp2;
var transient Vector FlightOrient2;
var float FlightTotalTime3;
var transient float FlightTime3;
var transient Vector TrackOrient;
var transient Vector TrackFront;
var transient Vector TrackUp;
var transient Vector TrackRight;
var transient int CurrentPhase;

defaultproperties
{
    FlightTotalTime1=0.1
    CircleRadius1=60.0
    CircleDist1=120.0
    Dist1Mode=2
    Radius1Mode=2
    Angle1Mode=2
    Radius2Mode=1
}

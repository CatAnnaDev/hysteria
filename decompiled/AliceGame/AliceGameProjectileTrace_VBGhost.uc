class AliceGameProjectileTrace_VBGhost extends AliceGameProjectileTrace
    native
    notplaceable
    config(Weapon);

var transient float FlightTime1;
var transient float StandTime1;
var transient Vector DestLocation1;
var transient float FlightTime2;
var transient float StandTime2;
var transient Vector DestLocation2;
var transient int CurrentPhase;

defaultproperties
{
}

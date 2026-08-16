class AliceAnimNotify_TriggerAliceGhost extends AnimNotify
    native
    notplaceable
    editinlinenew
    collapsecategories
    hidecategories(Object);

struct native GhostPositionOption
{
    var() Rotator AngleOffset;
    var() float DistOffset;
};

var() ParticleSystem AliceGhostEffectTemplate;
var() float FlightTime1;
var() float StandTime1;
var() array<GhostPositionOption> GhostPositions;
var() float FlightTime2;
var() float StandTime2;
var() float MaxFlightLength;
var() EDamageStrengthType DmgStrength;
var() float DamageValue;

defaultproperties
{
    FlightTime1=0.2
    StandTime1=0.2
    FlightTime2=0.2
    StandTime2=0.2
    MaxFlightLength=2000.0
}

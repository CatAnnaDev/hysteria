class AliceGameProjectileTrace extends Object
    abstract
    native
    notplaceable
    config(Weapon);

enum EProjectileInitType
{
    EProjectileInitType_ToDestination,
    EProjectileInitType_AlignSocket,
};

var EProjectileInitType ProjInitType;
var bool bNeedUpdateAccelarationWhenInit;
var bool bAlwaysMaxShotDistance;
var bool bNoXYAcceleration;
var transient bool bInRebounding;
var transient float RefSpeed;
var transient float FlightTime;
var transient Vector DestLocation;
var transient Actor TargetEnemyActor;
var transient float AngleToleranceXY;
var transient float AngleToleranceZ;

defaultproperties
{
}

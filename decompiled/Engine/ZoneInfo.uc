class ZoneInfo extends Info
    native
    notplaceable
    hidecategories(Navigation,Movement,Collision);

var() float KillZ;
var() float SoftKill;
var() class<KillZDamageType> KillZDamageType;
var() bool bSoftKillZ;

defaultproperties
{
    KillZ=-262143.0
    SoftKill=2500.0
    KillZDamageType="KillZDamageType"
    bStatic=True
    bNoDelete=True
    bGameRelevant=True
    Components(0)="Default__ZoneInfo.Sprite"
}

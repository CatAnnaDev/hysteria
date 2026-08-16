class SphinxInterstingPoint extends NavigationPoint
    native
    placeable
    hidecategories(Navigation,Lighting,LightColor,Force);

enum ESphinxIP
{
    InteractIP,
    LookAtIP,
};

struct native AccessNPC
{
    var() Pawn NPCPawn;
    var() int AttractChance;
    var() float BlockTime;
    var() name Animation;
    var float LastUsedTime;
    var bool bEnable;
    var bool bInAttractRadius;
};

var() ESphinxIP Type;
var transient float ToSeekerDistanceSQ;
var Pawn m_Pawn_MovingToHere;
var() bool bEnabled;
var() float AttractRadius;
var() float StopTurnTime;
var() Actor EnterPointActor;
var() export editinline AudioComponent IPAmbientSound;
var Vector EnterPointPosition;
var() array<AccessNPC> AccessNpcList;

function ShowRadius()
{
    DrawDebugCylinder(Location, Location, AttractRadius, 100, 255, 0, 0, true);
}

event PostBeginPlay()
{
    local int I;
    
    PostBeginPlay();
    if (EnterPointActor != none)
    {
        EnterPointPosition = EnterPointActor.Location;
    }
    else
    {
        EnterPointPosition = Location;
    }
    for (I = 0; I < AccessNpcList.Length; I++)
    {
        AccessNpcList[I].LastUsedTime = -AccessNpcList[I].BlockTime;
    }
}

defaultproperties
{
    bEnabled=True
    AttractRadius=1200.0
    StopTurnTime=30.0
    IPAmbientSound="Default__SphinxInterstingPoint.AmbientSound"
    bSpecialMove=True
    CylinderComponent="Default__SphinxInterstingPoint.CollisionCylinder"
    GoodSprite="Default__SphinxInterstingPoint.Sprite"
    BadSprite="Default__SphinxInterstingPoint.Sprite2"
    bCollideWhenPlacing=False
    Components(0)="Default__SphinxInterstingPoint.Sprite"
    Components(1)="Default__SphinxInterstingPoint.Sprite2"
    Components(2)="Default__SphinxInterstingPoint.Arrow"
    Components(3)="Default__SphinxInterstingPoint.CollisionCylinder"
    Components(4)="Default__SphinxInterstingPoint.PathRenderer"
    Components(5)="Default__SphinxInterstingPoint.AmbientSound"
    CollisionType="COLLIDE_CustomDefault"
    CollisionComponent="Default__SphinxInterstingPoint.CollisionCylinder"
}

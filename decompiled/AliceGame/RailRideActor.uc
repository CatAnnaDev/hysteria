class RailRideActor extends InterpActor
    native
    placeable
    hidecategories(Navigation);

var() bool bHorizontalMovement;
var() bool bVerticalMovement;
var bool bActived;
var bool bBouncing;
var() float HorizontalLimit;
var() float VerticalLimit;
var() float HorizontalSpeed;
var() float VerticalSpeed;
var() float SmoothFactor;
var() float BounceHitDamage;
var float HorizontalOffset;
var float VerticalOffset;
var float curVSpeed;
var float curHSpeed;
var() float BounceTime;
var() float BounceSpeed;
var Vector2D MoveDir;
var Vector BounceDir;
var AlicePlayerController MyPC;

function StopBounce()
{
    bBouncing = false;
}

function BounceOff(Vector HitNormal)
{
    if (!bBouncing)
    {
        bBouncing = true;
        BounceDir = HitNormal;
        SetTimer(BounceTime, false, 'StopBounce');
        curVSpeed = 0.0;
        curHSpeed = 0.0;
        TriggerEventClass(class'Engine.SeqEvent_TakeDamage', self, -1);
    }
}

event Tick(float DeltaTime)
{
    if (bBouncing)
    {
        curHSpeed = 0.0;
        curVSpeed = 0.0;
    }
}

event Bump(Actor Other, PrimitiveComponent OtherComp, Vector HitNormal)
{
    local Controller EventInstigator;
    
    foreach WorldInfo.AllControllers(class'Engine.Controller', EventInstigator)
    {
        Other.TakeDamage(int(VSize(Velocity)), EventInstigator, Other.Location, vector(Rotation), class'DmgType_RailRide');
        break;
    }
}

defaultproperties
{
    bHorizontalMovement=True
    bVerticalMovement=True
    HorizontalLimit=500.0
    VerticalLimit=500.0
    HorizontalSpeed=10.0
    VerticalSpeed=10.0
    SmoothFactor=1.0
    BounceHitDamage=20.0
    BounceTime=0.3
    BounceSpeed=40.0
    StaticMeshComponent="Default__RailRideActor.StaticMeshComponent0"
    LightEnvironment="Default__RailRideActor.MyLightEnvironment"
    bCollideActors=True
    bCollideWorld=True
    bBlockActors=True
    Components(0)="Default__RailRideActor.MyLightEnvironment"
    Components(1)="Default__RailRideActor.StaticMeshComponent0"
    CollisionType="COLLIDE_BlockAll"
    CollisionComponent="Default__RailRideActor.StaticMeshComponent0"
}

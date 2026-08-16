class AliceCameraMagnet extends Actor
    native
    placeable
    hidecategories(Navigation);

var() bool bEnableOnSight;
var() bool bDisableOnLookAway;
var() bool bEnabled;
var() bool bUseDeadZone;
var() bool bResetCameraAfterDisabled;
var() int InterpolateSpeed;
var() float CamDuration;
var() int Priority;
var() float AttractionRange;
var() float DisableRange;
var() int MaxTriggerCount;
var() float DeadZoneRadius;
var() float FOV;
var() float TurnHeadDuration;
var() float EaseIn;
var() float EaseOut;
var() float TargetRadius;
var() array<EPhysics> ActivationContext;
var() array<EPhysics> DeActivationContext;
var Vector Magnet2DPos;
var export editinline DrawSphereComponent DrawRange[2];

defaultproperties
{
    TargetRadius=100.0
    DrawRange="Default__AliceCameraMagnet.DrawAttractionRange"
    DrawRange[1]="Default__AliceCameraMagnet.DrawDisableRange"
    Components(0)="Default__AliceCameraMagnet.Sprite"
    Components(1)="Default__AliceCameraMagnet.DrawAttractionRange"
    Components(2)="Default__AliceCameraMagnet.DrawDisableRange"
    CollisionType="COLLIDE_CustomDefault"
}

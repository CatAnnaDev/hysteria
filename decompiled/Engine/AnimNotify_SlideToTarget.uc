class AnimNotify_SlideToTarget extends AnimNotify
    native
    notplaceable
    editinlinenew
    collapsecategories
    hidecategories(Object);

var() float StartTime;
var() float EndTime;
var() bool bDistanceLimit;
var() bool bSlideToMaxDistance;
var() float MaxDistance;
var() float MinDistance;
var float MaxAngle;

defaultproperties
{
    bDistanceLimit=True
}

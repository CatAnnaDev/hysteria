class SkelControlFootPlacement extends SkelControlLimb
    native
    notplaceable
    hidecategories(Object,Object,Effector);

var(FootPlacement) float FootOffset;
var(FootPlacement) EAxis FootUpAxis;
var(FootPlacement) Rotator FootRotOffset;
var(FootPlacement) bool bInvertFootUpAxis;
var(FootPlacement) bool bOrientFootToGround;
var(FootPlacement) bool bOnlyEnableForUpAdjustment;
var(FootPlacement) float MaxUpAdjustment;
var(FootPlacement) float MaxDownAdjustment;
var(FootPlacement) float MaxFootOrientAdjust;

defaultproperties
{
    FootUpAxis="AXIS_X"
    bOrientFootToGround=True
    MaxUpAdjustment=50.0
    MaxFootOrientAdjust=45.0
}

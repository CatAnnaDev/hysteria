class AliceAnimNotify_PlayWeaponSlotAnim extends AnimNotify
    native
    notplaceable
    editinlinenew
    collapsecategories
    hidecategories(Object);

var() name AnimName;
var() float PlayRate;
var() bool bLoop;
var() float BlendInTime;
var() float BlendOutTime;

defaultproperties
{
    PlayRate=1.0
}

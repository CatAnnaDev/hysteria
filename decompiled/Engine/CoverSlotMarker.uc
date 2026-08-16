class CoverSlotMarker extends NavigationPoint
    native
    notplaceable
    hidecategories(Navigation,Lighting,LightColor,Force);

var() editconst CoverInfo OwningSlot;
var bool bLastChoice;
var transient bool bIgnoreSizeLimits;

final simulated event string GetDebugString()
{
    return OwningSlot.Link.GetDebugString(OwningSlot.SlotIdx);
}

simulated event string GetDebugAbbrev()
{
    return "CSM";
}

native final function bool IsValidClaim(Pawn ChkClaim, optional bool bSkipTeamCheck, optional bool bSkipOverlapCheck)
{
    ChkClaim;
    bSkipTeamCheck;
    bSkipOverlapCheck;
}

native simulated function SetSlotEnabled(bool bEnable)
{
    bEnable;
}

native simulated function Rotator GetSlotRotation()
{
}

native simulated function Vector GetSlotLocation()
{
}

defaultproperties
{
    bSpecialMove=True
    CylinderComponent="Default__CoverSlotMarker.CollisionCylinder"
    GoodSprite="Default__CoverSlotMarker.Sprite"
    BadSprite="Default__CoverSlotMarker.Sprite2"
    bCollideWhenPlacing=False
    Components(0)="Default__CoverSlotMarker.Sprite"
    Components(1)="Default__CoverSlotMarker.Sprite2"
    Components(2)="Default__CoverSlotMarker.CollisionCylinder"
    Components(3)="Default__CoverSlotMarker.PathRenderer"
    CollisionType="COLLIDE_CustomDefault"
    CollisionComponent="Default__CoverSlotMarker.CollisionCylinder"
}

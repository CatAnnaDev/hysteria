class WeaponPickup_VB extends AliceWeaponPickupFactory
    placeable
    config(Weapon)
    hidecategories(Navigation,Lighting,LightColor,Force,PickupFactory);

defaultproperties
{
    WeaponPickupClass="VorpalBlade"
    BaseGlow="Default__WeaponPickup_VB.IdleEffect"
    PickedEffectTemplate="TarotCard.Upgrade.Upgrade_VB_Pickup"
    BaseMesh="Default__WeaponPickup_VB.BaseMeshComp"
    LightEnvironment="Default__WeaponPickup_VB.PickupLightEnvironment"
    PickUpWaveForm="Default__WeaponPickup_VB.ForceFeedbackWaveformPickUp"
    PickupMesh="Default__WeaponPickup_VB.WeaponPickupMeshComp"
    CylinderComponent="Default__WeaponPickup_VB.CollisionCylinder"
    Components(0)="Default__WeaponPickup_VB.CollisionCylinder"
    Components(1)="Default__WeaponPickup_VB.PathRenderer"
    Components(2)="Default__WeaponPickup_VB.PickupLightEnvironment"
    Components(3)="Default__WeaponPickup_VB.BaseMeshComp"
    Components(4)="Default__WeaponPickup_VB.WeaponPickupMeshComp"
    Components(5)="Default__WeaponPickup_VB.IdleEffect"
    CollisionComponent="Default__WeaponPickup_VB.CollisionCylinder"
}

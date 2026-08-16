class WeaponPickup_HF extends AliceWeaponPickupFactory
    placeable
    config(Weapon)
    hidecategories(Navigation,Lighting,LightColor,Force,PickupFactory);

defaultproperties
{
    WeaponPickupClass="TeapotCannon"
    BaseGlow="Default__WeaponPickup_HF.IdleEffect"
    PickedEffectTemplate="TarotCard.Upgrade.Upgrade_HF_Pickup"
    BaseMesh="Default__WeaponPickup_HF.BaseMeshComp"
    LightEnvironment="Default__WeaponPickup_HF.PickupLightEnvironment"
    PickUpWaveForm="Default__WeaponPickup_HF.ForceFeedbackWaveformPickUp"
    PickupMesh="Default__WeaponPickup_HF.WeaponPickupMeshComp"
    CylinderComponent="Default__WeaponPickup_HF.CollisionCylinder"
    Components(0)="Default__WeaponPickup_HF.CollisionCylinder"
    Components(1)="Default__WeaponPickup_HF.PathRenderer"
    Components(2)="Default__WeaponPickup_HF.PickupLightEnvironment"
    Components(3)="Default__WeaponPickup_HF.BaseMeshComp"
    Components(4)="Default__WeaponPickup_HF.WeaponPickupMeshComp"
    Components(5)="Default__WeaponPickup_HF.IdleEffect"
    CollisionComponent="Default__WeaponPickup_HF.CollisionCylinder"
}

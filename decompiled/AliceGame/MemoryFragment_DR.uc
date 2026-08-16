class MemoryFragment_DR extends MemoryFragmentNormal
    native
    placeable
    config(Pickup)
    hidecategories(Navigation,Lighting,LightColor,Force,PickupFactory);

defaultproperties
{
    IdleParticle="Default__MemoryFragment_DR.GlowEffect"
    PickupParticle="Default__MemoryFragment_DR.PickupEffect"
    MemoryFragmentType="MF_DR"
    StaticMesh="Default__MemoryFragment_DR.AmmoMeshComp"
    BaseMesh="Default__MemoryFragment_DR.BaseMeshComp"
    LightEnvironment="Default__MemoryFragment_DR.PickupLightEnvironment"
    PickUpWaveForm="Default__MemoryFragment_DR.ForceFeedbackWaveformPickUp"
    CylinderComponent="Default__MemoryFragment_DR.CollisionCylinder"
    Components(0)="Default__MemoryFragment_DR.CollisionCylinder"
    Components(1)="Default__MemoryFragment_DR.PathRenderer"
    Components(2)="Default__MemoryFragment_DR.PickupLightEnvironment"
    Components(3)="Default__MemoryFragment_DR.BaseMeshComp"
    Components(4)="Default__MemoryFragment_DR.AmmoMeshComp"
    Components(5)="Default__MemoryFragment_DR.GlowEffect"
    Components(6)="Default__MemoryFragment_DR.PickupEffect"
    CollisionComponent="Default__MemoryFragment_DR.CollisionCylinder"
}

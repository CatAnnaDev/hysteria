class MemoryFragment_Family extends MemoryFragmentNormal
    native
    placeable
    config(Pickup)
    hidecategories(Navigation,Lighting,LightColor,Force,PickupFactory);

defaultproperties
{
    IdleParticle="Default__MemoryFragment_Family.GlowEffect"
    PickupParticle="Default__MemoryFragment_Family.PickupEffect"
    MemoryFragmentType="MF_Family"
    StaticMesh="Default__MemoryFragment_Family.AmmoMeshComp"
    BaseMesh="Default__MemoryFragment_Family.BaseMeshComp"
    LightEnvironment="Default__MemoryFragment_Family.PickupLightEnvironment"
    PickUpWaveForm="Default__MemoryFragment_Family.ForceFeedbackWaveformPickUp"
    CylinderComponent="Default__MemoryFragment_Family.CollisionCylinder"
    Components(0)="Default__MemoryFragment_Family.CollisionCylinder"
    Components(1)="Default__MemoryFragment_Family.PathRenderer"
    Components(2)="Default__MemoryFragment_Family.PickupLightEnvironment"
    Components(3)="Default__MemoryFragment_Family.BaseMeshComp"
    Components(4)="Default__MemoryFragment_Family.AmmoMeshComp"
    Components(5)="Default__MemoryFragment_Family.GlowEffect"
    Components(6)="Default__MemoryFragment_Family.PickupEffect"
    CollisionComponent="Default__MemoryFragment_Family.CollisionCylinder"
}

class MemoryFragment_Lawyer extends MemoryFragmentNormal
    native
    placeable
    config(Pickup)
    hidecategories(Navigation,Lighting,LightColor,Force,PickupFactory);

defaultproperties
{
    IdleParticle="Default__MemoryFragment_Lawyer.GlowEffect"
    PickupParticle="Default__MemoryFragment_Lawyer.PickupEffect"
    MemoryFragmentType="MF_Lawyer"
    StaticMesh="Default__MemoryFragment_Lawyer.AmmoMeshComp"
    BaseMesh="Default__MemoryFragment_Lawyer.BaseMeshComp"
    LightEnvironment="Default__MemoryFragment_Lawyer.PickupLightEnvironment"
    PickUpWaveForm="Default__MemoryFragment_Lawyer.ForceFeedbackWaveformPickUp"
    CylinderComponent="Default__MemoryFragment_Lawyer.CollisionCylinder"
    Components(0)="Default__MemoryFragment_Lawyer.CollisionCylinder"
    Components(1)="Default__MemoryFragment_Lawyer.PathRenderer"
    Components(2)="Default__MemoryFragment_Lawyer.PickupLightEnvironment"
    Components(3)="Default__MemoryFragment_Lawyer.BaseMeshComp"
    Components(4)="Default__MemoryFragment_Lawyer.AmmoMeshComp"
    Components(5)="Default__MemoryFragment_Lawyer.GlowEffect"
    Components(6)="Default__MemoryFragment_Lawyer.PickupEffect"
    CollisionComponent="Default__MemoryFragment_Lawyer.CollisionCylinder"
}

class MemoryFragment_Nanny extends MemoryFragmentNormal
    native
    placeable
    config(Pickup)
    hidecategories(Navigation,Lighting,LightColor,Force,PickupFactory);

defaultproperties
{
    IdleParticle="Default__MemoryFragment_Nanny.GlowEffect"
    PickupParticle="Default__MemoryFragment_Nanny.PickupEffect"
    MemoryFragmentType="MF_Nanny"
    StaticMesh="Default__MemoryFragment_Nanny.AmmoMeshComp"
    BaseMesh="Default__MemoryFragment_Nanny.BaseMeshComp"
    LightEnvironment="Default__MemoryFragment_Nanny.PickupLightEnvironment"
    PickUpWaveForm="Default__MemoryFragment_Nanny.ForceFeedbackWaveformPickUp"
    CylinderComponent="Default__MemoryFragment_Nanny.CollisionCylinder"
    Components(0)="Default__MemoryFragment_Nanny.CollisionCylinder"
    Components(1)="Default__MemoryFragment_Nanny.PathRenderer"
    Components(2)="Default__MemoryFragment_Nanny.PickupLightEnvironment"
    Components(3)="Default__MemoryFragment_Nanny.BaseMeshComp"
    Components(4)="Default__MemoryFragment_Nanny.AmmoMeshComp"
    Components(5)="Default__MemoryFragment_Nanny.GlowEffect"
    Components(6)="Default__MemoryFragment_Nanny.PickupEffect"
    CollisionComponent="Default__MemoryFragment_Nanny.CollisionCylinder"
}

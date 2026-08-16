class MemoryFragment_Pris extends MemoryFragmentNormal
    native
    placeable
    config(Pickup)
    hidecategories(Navigation,Lighting,LightColor,Force,PickupFactory);

defaultproperties
{
    IdleParticle="Default__MemoryFragment_Pris.GlowEffect"
    PickupParticle="Default__MemoryFragment_Pris.PickupEffect"
    MemoryFragmentType="MF_Pris"
    StaticMesh="Default__MemoryFragment_Pris.AmmoMeshComp"
    BaseMesh="Default__MemoryFragment_Pris.BaseMeshComp"
    LightEnvironment="Default__MemoryFragment_Pris.PickupLightEnvironment"
    PickUpWaveForm="Default__MemoryFragment_Pris.ForceFeedbackWaveformPickUp"
    CylinderComponent="Default__MemoryFragment_Pris.CollisionCylinder"
    Components(0)="Default__MemoryFragment_Pris.CollisionCylinder"
    Components(1)="Default__MemoryFragment_Pris.PathRenderer"
    Components(2)="Default__MemoryFragment_Pris.PickupLightEnvironment"
    Components(3)="Default__MemoryFragment_Pris.BaseMeshComp"
    Components(4)="Default__MemoryFragment_Pris.AmmoMeshComp"
    Components(5)="Default__MemoryFragment_Pris.GlowEffect"
    Components(6)="Default__MemoryFragment_Pris.PickupEffect"
    CollisionComponent="Default__MemoryFragment_Pris.CollisionCylinder"
}

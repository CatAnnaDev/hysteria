class MemoryFragment_Queen extends MemoryFragmentNormal
    native
    placeable
    config(Pickup)
    hidecategories(Navigation,Lighting,LightColor,Force,PickupFactory);

defaultproperties
{
    IdleParticle="Default__MemoryFragment_Queen.GlowEffect"
    PickupParticle="Default__MemoryFragment_Queen.PickupEffect"
    MemoryFragmentType="MF_Queen"
    StaticMesh="Default__MemoryFragment_Queen.AmmoMeshComp"
    BaseMesh="Default__MemoryFragment_Queen.BaseMeshComp"
    LightEnvironment="Default__MemoryFragment_Queen.PickupLightEnvironment"
    PickUpWaveForm="Default__MemoryFragment_Queen.ForceFeedbackWaveformPickUp"
    CylinderComponent="Default__MemoryFragment_Queen.CollisionCylinder"
    Components(0)="Default__MemoryFragment_Queen.CollisionCylinder"
    Components(1)="Default__MemoryFragment_Queen.PathRenderer"
    Components(2)="Default__MemoryFragment_Queen.PickupLightEnvironment"
    Components(3)="Default__MemoryFragment_Queen.BaseMeshComp"
    Components(4)="Default__MemoryFragment_Queen.AmmoMeshComp"
    Components(5)="Default__MemoryFragment_Queen.GlowEffect"
    Components(6)="Default__MemoryFragment_Queen.PickupEffect"
    CollisionComponent="Default__MemoryFragment_Queen.CollisionCylinder"
}

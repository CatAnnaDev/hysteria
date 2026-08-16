class MemoryFragment_Bumby extends MemoryFragmentNormal
    native
    placeable
    config(Pickup)
    hidecategories(Navigation,Lighting,LightColor,Force,PickupFactory);

defaultproperties
{
    IdleParticle="Default__MemoryFragment_Bumby.GlowEffect"
    PickupParticle="Default__MemoryFragment_Bumby.PickupEffect"
    StaticMesh="Default__MemoryFragment_Bumby.AmmoMeshComp"
    BaseMesh="Default__MemoryFragment_Bumby.BaseMeshComp"
    LightEnvironment="Default__MemoryFragment_Bumby.PickupLightEnvironment"
    PickUpWaveForm="Default__MemoryFragment_Bumby.ForceFeedbackWaveformPickUp"
    CylinderComponent="Default__MemoryFragment_Bumby.CollisionCylinder"
    Components(0)="Default__MemoryFragment_Bumby.CollisionCylinder"
    Components(1)="Default__MemoryFragment_Bumby.PathRenderer"
    Components(2)="Default__MemoryFragment_Bumby.PickupLightEnvironment"
    Components(3)="Default__MemoryFragment_Bumby.BaseMeshComp"
    Components(4)="Default__MemoryFragment_Bumby.AmmoMeshComp"
    Components(5)="Default__MemoryFragment_Bumby.GlowEffect"
    Components(6)="Default__MemoryFragment_Bumby.PickupEffect"
    CollisionComponent="Default__MemoryFragment_Bumby.CollisionCylinder"
}

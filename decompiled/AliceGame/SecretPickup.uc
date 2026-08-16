class SecretPickup extends MemoryFragmentNormal
    native
    placeable
    config(Pickup)
    hidecategories(Navigation,Lighting,LightColor,Force,PickupFactory);

var() string secrettag;

function saveToPersistentData(Pawn P)
{
}

event ShowPressButtonUI(bool bShow)
{
    local SecretPickup pickitem;
    local AliceGameInfo agi;
    
    if (!bShow)
    {
        foreach AllActors(class'SecretPickup', pickitem)
        {
            if (pickitem.bMustInteract && VSize(WorldInfo.GetLocalPlayerPawn().Location - pickitem.Location) < pickitem.PickupRadius)
            {
                return;
            }
        }
        AlicePawn(WorldInfo.GetLocalPlayerPawn()).bInPickRadius = false;
    }
    else
    {
        AlicePawn(WorldInfo.GetLocalPlayerPawn()).bInPickRadius = true;
    }
    agi = AliceGameInfo(WorldInfo.Game);
    if (WorldInfo.GetMapName() != "AliceEntry")
    {
        if (bShow)
        {
            agi.GFxHUDMenu.ShowInteractPressX(0.0, agi.GetLocalizeString("Pickup_Secret"));
        }
        else
        {
            agi.GFxHUDMenu.ShowInteractPressX(-1.0, agi.GetLocalizeString("Pickup_Secret"));
        }
    }
}

defaultproperties
{
    IdleParticle="Default__SecretPickup.GlowEffect"
    PickupParticle="Default__SecretPickup.PickupEffect"
    StaticMesh="Default__SecretPickup.AmmoMeshComp"
    BaseMesh="Default__SecretPickup.BaseMeshComp"
    LightEnvironment="Default__SecretPickup.PickupLightEnvironment"
    PickUpWaveForm="Default__SecretPickup.ForceFeedbackWaveformPickUp"
    CylinderComponent="Default__SecretPickup.CollisionCylinder"
    Components(0)="Default__SecretPickup.CollisionCylinder"
    Components(1)="Default__SecretPickup.PathRenderer"
    Components(2)="Default__SecretPickup.PickupLightEnvironment"
    Components(3)="Default__SecretPickup.BaseMeshComp"
    Components(4)="Default__SecretPickup.AmmoMeshComp"
    Components(5)="Default__SecretPickup.GlowEffect"
    Components(6)="Default__SecretPickup.PickupEffect"
    CollisionComponent="Default__SecretPickup.CollisionCylinder"
}

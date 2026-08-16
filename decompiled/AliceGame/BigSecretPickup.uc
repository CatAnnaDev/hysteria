class BigSecretPickup extends MemoryFragmentNormal
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
    local BigSecretPickup pickitem;
    local AliceGameInfo agi;
    
    if (!bShow)
    {
        foreach AllActors(class'BigSecretPickup', pickitem)
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
            agi.GFxHUDMenu.ShowInteractPressX(0.0, agi.GetLocalizeString("Pickup_BigSecret"));
        }
        else
        {
            agi.GFxHUDMenu.ShowInteractPressX(-1.0, agi.GetLocalizeString("Pickup_BigSecret"));
        }
    }
}

defaultproperties
{
    IdleParticle="Default__BigSecretPickup.GlowEffect"
    PickupParticle="Default__BigSecretPickup.PickupEffect"
    StaticMesh="Default__BigSecretPickup.AmmoMeshComp"
    BaseMesh="Default__BigSecretPickup.BaseMeshComp"
    LightEnvironment="Default__BigSecretPickup.PickupLightEnvironment"
    PickUpWaveForm="Default__BigSecretPickup.ForceFeedbackWaveformPickUp"
    CylinderComponent="Default__BigSecretPickup.CollisionCylinder"
    Components(0)="Default__BigSecretPickup.CollisionCylinder"
    Components(1)="Default__BigSecretPickup.PathRenderer"
    Components(2)="Default__BigSecretPickup.PickupLightEnvironment"
    Components(3)="Default__BigSecretPickup.BaseMeshComp"
    Components(4)="Default__BigSecretPickup.AmmoMeshComp"
    Components(5)="Default__BigSecretPickup.GlowEffect"
    Components(6)="Default__BigSecretPickup.PickupEffect"
    CollisionComponent="Default__BigSecretPickup.CollisionCylinder"
}

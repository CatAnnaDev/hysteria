class KActorSpawnable extends KActor
    native
    notplaceable;

var bool bRecycleScaleToZero;
var bool bScalingToZero;

native final function ResetComponents()
{
}

simulated event RecycleInternal()
{
    SetHidden(true);
    StaticMeshComponent.SetHidden(true);
    SetPhysics(0);
    SetCollision(false, false);
    ClearTimer('Recycle');
    SetTickIsDisabled(true);
}

simulated function Recycle()
{
    if (bRecycleScaleToZero == true)
    {
        bScalingToZero = true;
    }
    else
    {
        RecycleInternal();
    }
}

simulated function Initialize()
{
    bScalingToZero = false;
    SetDrawScale(default.DrawScale);
    ClearTimer('Recycle');
    SetHidden(false);
    StaticMeshComponent.SetHidden(false);
    SetTickIsDisabled(false);
    SetPhysics(10);
    SetCollision(true, false);
}

defaultproperties
{
    StaticMeshComponent="Default__KActorSpawnable.StaticMeshComponent0"
    LightEnvironment="Default__KActorSpawnable.MyLightEnvironment"
    bNoDelete=False
    Components(0)="Default__KActorSpawnable.MyLightEnvironment"
    Components(1)="Default__KActorSpawnable.StaticMeshComponent0"
    CollisionComponent="Default__KActorSpawnable.StaticMeshComponent0"
}

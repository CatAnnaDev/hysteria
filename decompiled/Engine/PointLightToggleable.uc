class PointLightToggleable extends PointLight
    native
    placeable
    hidecategories(Navigation);

struct CheckpointRecord
{
    var bool bEnabled;
};

function ApplyCheckpointRecord(out const CheckpointRecord Record)
{
    bEnabled = Record.bEnabled;
    LightComponent.SetEnabled(bEnabled);
    ForceNetRelevant();
}

function CreateCheckpointRecord(out CheckpointRecord Record)
{
    Record.bEnabled = bEnabled;
}

function bool ShouldSaveForCheckpoint()
{
    return RemoteRole != 0;
}

defaultproperties
{
    LightComponent="Default__PointLightToggleable.PointLightComponent0"
    bStatic=False
    bHardAttach=True
    Components(0)="Default__PointLightToggleable.Sprite"
    Components(1)="Default__PointLightToggleable.DrawLightRadius0"
    Components(2)="Default__PointLightToggleable.DrawLightSourceRadius0"
    Components(3)="Default__PointLightToggleable.PointLightComponent0"
    TickGroup="TG_DuringAsyncWork"
}

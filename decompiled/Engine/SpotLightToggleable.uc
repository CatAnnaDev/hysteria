class SpotLightToggleable extends SpotLight
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
    LightComponent="Default__SpotLightToggleable.SpotLightComponent0"
    bStatic=False
    bHardAttach=True
    Components(0)="Default__SpotLightToggleable.Sprite"
    Components(1)="Default__SpotLightToggleable.DrawLightRadius0"
    Components(2)="Default__SpotLightToggleable.DrawInnerCone0"
    Components(3)="Default__SpotLightToggleable.DrawOuterCone0"
    Components(4)="Default__SpotLightToggleable.DrawLightSourceRadius0"
    Components(5)="Default__SpotLightToggleable.SpotLightComponent0"
    Components(6)="Default__SpotLightToggleable.ArrowComponent0"
    TickGroup="TG_DuringAsyncWork"
}

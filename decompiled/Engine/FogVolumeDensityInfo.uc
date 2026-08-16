class FogVolumeDensityInfo extends Info
    abstract
    native
    notplaceable
    hidecategories(Navigation,Collision)
    autoexpandcategories(FogVolumeDensityInfo);

struct CheckpointRecord
{
    var bool bEnabled;
};

var() export editinline FogVolumeDensityComponent DensityComponent;
var() export editinline StaticMeshComponent AutomaticMeshComponent;
var repnotify bool bEnabled;

replication
{
    if (Role == 3)
        bEnabled;
}

function ApplyCheckpointRecord(out const CheckpointRecord Record)
{
    bEnabled = Record.bEnabled;
    DensityComponent.SetEnabled(bEnabled);
    ForceNetRelevant();
    SetForcedInitialReplicatedProperty(BoolProperty'FogVolumeDensityInfo.bEnabled', bEnabled == default.bEnabled);
}

function CreateCheckpointRecord(out CheckpointRecord Record)
{
    Record.bEnabled = bEnabled;
}

function bool ShouldSaveForCheckpoint()
{
    return RemoteRole != 0;
}

simulated function OnToggle(SeqAct_Toggle Action)
{
    if (Action.InputLinks[0].bHasImpulse)
    {
        DensityComponent.SetEnabled(true);
    }
    else if (Action.InputLinks[1].bHasImpulse)
    {
        DensityComponent.SetEnabled(false);
    }
    else if (Action.InputLinks[2].bHasImpulse)
    {
        DensityComponent.SetEnabled(!DensityComponent.bEnabled);
    }
    bEnabled = DensityComponent.bEnabled;
    ForceNetRelevant();
    SetForcedInitialReplicatedProperty(BoolProperty'FogVolumeDensityInfo.bEnabled', bEnabled == default.bEnabled);
}

simulated event ReplicatedEvent(name VarName)
{
    if (VarName == 'bEnabled')
    {
        DensityComponent.SetEnabled(bEnabled);
    }
    else
    {
        ReplicatedEvent(VarName);
    }
}

event PostBeginPlay()
{
    PostBeginPlay();
    if (DensityComponent != none)
    {
        bEnabled = DensityComponent.bEnabled;
    }
}

defaultproperties
{
    AutomaticMeshComponent="Default__FogVolumeDensityInfo.AutomaticMeshComponent0"
    bNoDelete=True
    Components(0)="Default__FogVolumeDensityInfo.Sprite"
    Components(1)="Default__FogVolumeDensityInfo.AutomaticMeshComponent0"
}

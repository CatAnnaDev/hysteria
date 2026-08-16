class LevelStreamingVolume extends Volume
    native
    placeable
    hidecategories(Navigation,Object,Movement,Display,Advanced,Attachment,Collision,Volume);

enum EStreamingVolumeUsage
{
    SVB_Loading,
    SVB_LoadingAndVisibility,
    SVB_VisibilityBlockingOnLoad,
    SVB_BlockingOnLoad,
    SVB_LoadingNotVisible,
};

struct CheckpointRecord
{
    var bool bDisabled;
};

var() const editconst array<LevelStreaming> StreamingLevels;
var() bool bEditorPreVisOnly;
var() bool bDisabled;
var() bool bTestDistanceToVolume;
var() EStreamingVolumeUsage StreamingUsage;
var deprecated EStreamingVolumeUsage Usage;
var() float TestVolumeDistance;

function ApplyCheckpointRecord(out const CheckpointRecord Record)
{
    bDisabled = Record.bDisabled;
}

function CreateCheckpointRecord(out CheckpointRecord Record)
{
    Record.bDisabled = bDisabled;
}

simulated function OnToggle(SeqAct_Toggle Action)
{
    if (Action.InputLinks[0].bHasImpulse)
    {
        bDisabled = false;
    }
    else if (Action.InputLinks[1].bHasImpulse)
    {
        bDisabled = true;
    }
    else if (Action.InputLinks[2].bHasImpulse)
    {
        bDisabled = !bDisabled;
    }
}

defaultproperties
{
    StreamingUsage="SVB_LoadingAndVisibility"
    BrushColor=(B=0,G=165,R=255,A=255)
    bColored=True
    BrushComponent="Default__LevelStreamingVolume.BrushComponent0"
    bCollideActors=False
    bForceAllowKismetModification=True
    Components(0)="Default__LevelStreamingVolume.BrushComponent0"
    CollisionComponent="Default__LevelStreamingVolume.BrushComponent0"
    SupportedEvents(0)="SeqEvent_Touch"
}

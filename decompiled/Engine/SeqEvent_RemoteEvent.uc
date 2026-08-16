class SeqEvent_RemoteEvent extends SequenceEvent
    native
    notplaceable
    hidecategories(Object);

var() name EventName;
var transient bool bStatusIsOk;

static event int GetObjClassVersion()
{
    return GetObjClassVersion() + 1;
}

defaultproperties
{
    EventName="DefaultEvent"
    MaxTriggerCount=0
    bPlayerOnly=False
    ObjName="Remote Event"
}

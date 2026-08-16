class SeqEvent_InputCommand extends SequenceEvent
    native
    notplaceable
    hidecategories(Object);

var() string CommandName;
var() string EventDesc;

defaultproperties
{
    EventDesc="No description"
    MaxTriggerCount=0
    ObjName="InputCommand Event"
    ObjCategory="Misc"
}

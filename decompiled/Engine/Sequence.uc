class Sequence extends SequenceOp
    native
    notplaceable
    hidecategories(Object);

struct native QueuedActivationInfo
{
    var SequenceEvent ActivatedEvent;
    var Actor InOriginator;
    var Actor InInstigator;
    var array<int> ActivateIndices;
    var bool bPushTop;
};

struct native ActivateOp
{
    var SequenceOp ActivatorOp;
    var SequenceOp Op;
    var int InputIdx;
    var float RemainingDelay;
};

var const Pointer LogFile;
var const export array<SequenceObject> SequenceObjects;
var const array<SequenceOp> ActiveSequenceOps;
var const transient array<Sequence> NestedSequences;
var const array<SequenceEvent> UnregisteredEvents;
var const array<ActivateOp> DelayedActivatedOps;
var() bool bEnabled;
var array<QueuedActivationInfo> QueuedActivations;
var int DefaultViewX;
var int DefaultViewY;
var float DefaultViewZoom;

native final function SetEnabled(bool bInEnabled)
{
    bInEnabled;
}

function Reset()
{
    local int I;
    local SequenceOp Op;
    
    for (I = 0; I < SequenceObjects.Length; I++)
    {
        Op = SequenceOp(SequenceObjects[I]);
        if (Op != none)
        {
            Op.Reset();
        }
    }
}

native final function FindSeqObjectsByName(string SeqObjName, bool bCheckComment, out array<SequenceObject> OutputObjects, optional bool bRecursive = true)
{
    SeqObjName;
    bCheckComment;
    OutputObjects;
    bRecursive;
}

native final function FindSeqObjectsByClass(class<SequenceObject> DesiredClass, bool bRecursive, out array<SequenceObject> OutputObjects)
{
    DesiredClass;
    bRecursive;
    OutputObjects;
}

defaultproperties
{
    bEnabled=True
    DefaultViewZoom=1.0
    ObjName="Sequence"
}

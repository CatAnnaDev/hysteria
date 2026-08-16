class UIEventContainer extends Interface
    abstract
    native
    notplaceable;

native final function RemoveSequenceObjects(array<SequenceObject> ObjectsToRemove)
{
    ObjectsToRemove;
}

native final function RemoveSequenceObject(SequenceObject ObjectToRemove)
{
    ObjectToRemove;
}

native final function bool AddSequenceObject(SequenceObject NewObj, optional bool bRecurse)
{
    NewObj;
    bRecurse;
}

native final function GetUIEvents(out array<UIEvent> out_Events, optional class<UIEvent> LimitClass)
{
    out_Events;
    LimitClass;
}

defaultproperties
{
}

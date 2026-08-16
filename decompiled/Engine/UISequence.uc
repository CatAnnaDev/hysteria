class UISequence extends Sequence
    native
    notplaceable
    hidecategories(Object)
    implements(UIEventContainer);

var const native noexport Pointer VfTable_IUIEventContainer;
var const transient array<UIEvent> UIEvents;

native final function RemoveSequenceObjects(out const array<SequenceObject> ObjectsToRemove)
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

native final function UIScreenObject GetOwner()
{
}

defaultproperties
{
    ObjPosX=904
    ObjPosY=64
    ObjName="Widget Events"
}

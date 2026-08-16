class UIState extends UIRoot
    abstract
    native
    notplaceable
    editinlinenew
    hidecategories(Object,UIRoot)
    implements(UIEventContainer);

var const native noexport Pointer VfTable_IUIEventContainer;
var export editinline UIStateSequence StateSequence;
var array<InputKeyAction> StateInputActions;
var array<InputKeyAction> DisabledInputActions;
var() name MouseCursorName;
var transient byte PlayerIndexMask;
var const transient byte StackPriority;

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

event bool IsStateAllowed(UIScreenObject Target, UIState NewState, int PlayerIndex)
{
    return true;
}

event OnDeactivate(UIScreenObject Target, int PlayerIndex, bool bPoppedState)
{
}

event OnActivate(UIScreenObject Target, int PlayerIndex, bool bPushedState)
{
}

event bool DeactivateState(UIScreenObject Target, int PlayerIndex)
{
    return true;
}

event bool ActivateState(UIScreenObject Target, int PlayerIndex)
{
    return true;
}

native final function bool IsActiveForPlayer(int PlayerIndex)
{
    PlayerIndex;
}

event bool IsWidgetClassSupported(class<UIScreenObject> WidgetClass)
{
    return WidgetClass != none;
}

defaultproperties
{
    MouseCursorName="Arrow"
}

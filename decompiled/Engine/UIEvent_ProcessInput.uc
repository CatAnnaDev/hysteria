class UIEvent_ProcessInput extends UIEvent
    native
    placeable
    transient
    hidecategories(Object);

var native transient MultiMap_Mirror ActionMap;

event bool IsValidUISequenceObject(optional UIScreenObject TargetObject)
{
    return false;
}

defaultproperties
{
    Description="Executes actions in response to an input event, such as a keypress or mouse movement"
    bShouldRegisterEvent=False
    bPropagateEvent=False
    ObjName="Handle Input"
}

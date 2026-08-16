class UIComp_Event extends UIComponent
    native
    notplaceable
    within UIScreenObject;

var array<DefaultEventSpecification> DefaultEvents;
var UISequence EventContainer;
var transient UIEvent_ProcessInput InputProcessor;
var array<name> DisabledEventAliases;

native final function UnregisterInputEvents(UIState InputEventOwner, int PlayerIndex)
{
    InputEventOwner;
    PlayerIndex;
}

native final function RegisterInputEvents(UIState InputEventOwner, int PlayerIndex)
{
    InputEventOwner;
    PlayerIndex;
}

defaultproperties
{
}

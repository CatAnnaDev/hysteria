class ActorComponent extends Component
    abstract
    native
    noexport
    notplaceable;

var const native transient Pointer Scene;
var const transient Actor Owner;
var const native transient bool bAttached;
var const bool bTickInEditor;
var const transient bool bNeedsReattach;
var const transient bool bNeedsUpdateTransform;
var const ETickingGroup TickGroup;

native final function DetachFromAny()
{
}

native final function ForceUpdate(bool bTransformOnly)
{
    bTransformOnly;
}

native final function SetComponentRBFixed(bool bFixed)
{
    bFixed;
}

native final function SetTickGroup(ETickingGroup NewTickGroup)
{
    NewTickGroup;
}

defaultproperties
{
    TickGroup="TG_DuringAsyncWork"
}

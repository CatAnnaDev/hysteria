class UIEvent_MetaObject extends UIEvent
    native
    placeable
    transient
    hidecategories(Object);

var const native noexport Pointer VfTable_FCallbackEventDevice;

event bool IsPastingIntoUISequenceAllowed()
{
    return true;
}

event bool IsValidUISequenceObject(optional UIScreenObject TargetObject)
{
    return false;
}

defaultproperties
{
    ObjName="State Input Events"
    bDeletable=False
}

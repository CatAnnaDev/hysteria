class UIEvent_CalloutButtonInputProxy extends UIEvent
    native
    placeable
    hidecategories(Object);

var const UICalloutButtonPanel ButtonPanel;

static event int GetObjClassVersion()
{
    return GetObjClassVersion() + 1;
}

event bool IsPastingIntoUISequenceAllowed()
{
    return true;
}

event bool IsValidUISequenceObject(optional UIScreenObject TargetObject)
{
    return false;
}

native final function int FindButtonAliasIndex(name ButtonAliasName)
{
    ButtonAliasName;
}

native final function bool ChangeButtonAlias(name CurrentAliasName, name NewAliasName)
{
    CurrentAliasName;
    NewAliasName;
}

native final function bool UnregisterButtonAlias(name ButtonAliasName)
{
    ButtonAliasName;
}

native final function bool RegisterButtonAlias(name ButtonAliasName)
{
    ButtonAliasName;
}

defaultproperties
{
    ObjPosX=56
    ObjPosY=96
    ObjName="Callout Button Input Proxy"
    ObjColor=(B=255,G=135,R=70,A=255)
    bDeletable=False
}

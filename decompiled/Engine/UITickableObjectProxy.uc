class UITickableObjectProxy extends UIRoot
    native
    notplaceable
    transient
    hidecategories(Object,UIRoot)
    implements(UITickableObject);

var const native noexport Pointer VfTable_IUITickableObject;
var delegate<OnScriptTick> __OnScriptTick__Delegate;

event ScriptTick(float DeltaTime)
{
}

delegate OnScriptTick(UITickableObjectProxy Sender, float DeltaTime)
{
}

defaultproperties
{
}

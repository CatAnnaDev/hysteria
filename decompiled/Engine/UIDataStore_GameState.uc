class UIDataStore_GameState extends UIDataStore
    abstract
    native
    notplaceable
    transient
    hidecategories(Object,UIRoot);

var delegate<OnRefreshDataFieldValue> __OnRefreshDataFieldValue__Delegate;

function bool NotifyGameSessionEnded()
{
    return true;
}

delegate OnRefreshDataFieldValue()
{
}

defaultproperties
{
}

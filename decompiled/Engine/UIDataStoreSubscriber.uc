class UIDataStoreSubscriber extends Interface
    abstract
    native
    notplaceable;

native function ClearBoundDataStores()
{
}

native function GetBoundDataStores(out array<UIDataStore> out_BoundDataStores)
{
    out_BoundDataStores;
}

native function NotifyDataStoreValueUpdated(UIDataStore SourceDataStore, bool bValuesInvalidated, name PropertyTag, UIDataProvider SourceProvider, int ArrayIndex)
{
    SourceDataStore;
    bValuesInvalidated;
    PropertyTag;
    SourceProvider;
    ArrayIndex;
}

native function bool RefreshSubscriberValue(optional int BindingIndex = -1)
{
    BindingIndex;
}

native function string GetDataStoreBinding(optional int BindingIndex = -1)
{
    BindingIndex;
}

native function SetDataStoreBinding(string MarkupText, optional int BindingIndex = -1)
{
    MarkupText;
    BindingIndex;
}

defaultproperties
{
}

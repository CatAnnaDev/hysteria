class UIDataStorePublisher extends UIDataStoreSubscriber
    abstract
    native
    notplaceable;

native function bool SaveSubscriberValue(out array<UIDataStore> out_BoundDataStores, optional int BindingIndex = -1)
{
    out_BoundDataStores;
    BindingIndex;
}

defaultproperties
{
}

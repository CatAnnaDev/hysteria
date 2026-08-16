class UIDataStore extends UIDataProvider
    abstract
    native
    notplaceable
    transient
    hidecategories(Object,UIRoot);

var name Tag;
var array<delegate<OnDataStoreValueUpdated>> RefreshSubscriberNotifies;
var delegate<OnDataStoreValueUpdated> __OnDataStoreValueUpdated__Delegate;

final function DataStoreClient GetDataStoreClient()
{
    return class'UIInteraction'.static.GetDataStoreClient();
}

native function OnCommit()
{
}

final event RefreshSubscribers(optional name PropertyTag, optional bool bInvalidateValues = true, optional UIDataProvider SourceProvider, optional int ArrayIndex = -1)
{
    local int Idx;
    local delegate<OnDataStoreValueUpdated> Subscriber;
    local array<delegate<OnDataStoreValueUpdated>> SubscriberArrayCopy;
    
    SubscriberArrayCopy.Length = RefreshSubscriberNotifies.Length;
    for (Idx = 0; Idx < SubscriberArrayCopy.Length; Idx++)
    {
        SubscriberArrayCopy[Idx] = RefreshSubscriberNotifies[Idx];
    }
    for (Idx = 0; Idx < SubscriberArrayCopy.Length; Idx++)
    {
        Subscriber = SubscriberArrayCopy[Idx];
        OnDataStoreValueUpdated(self, bInvalidateValues, PropertyTag, SourceProvider, ArrayIndex);
    }
}

function bool NotifyGameSessionEnded()
{
}

event SubscriberDetached(UIDataStoreSubscriber Subscriber)
{
    local int SubscriberNotifyIndex;
    
    if (NotEqual_InterfaceInterface(Subscriber, UIDataStoreSubscriber(none)))
    {
        SubscriberNotifyIndex = RefreshSubscriberNotifies.Find(Subscriber.NotifyDataStoreValueUpdated);
        if (SubscriberNotifyIndex != -1)
        {
            RefreshSubscriberNotifies.Remove(SubscriberNotifyIndex, 1);
        }
    }
}

event SubscriberAttached(UIDataStoreSubscriber Subscriber)
{
    local int SubscriberNotifyIndex;
    
    if (NotEqual_InterfaceInterface(Subscriber, UIDataStoreSubscriber(none)))
    {
        SubscriberNotifyIndex = RefreshSubscriberNotifies.Find(Subscriber.NotifyDataStoreValueUpdated);
        if (SubscriberNotifyIndex == -1)
        {
            SubscriberNotifyIndex = RefreshSubscriberNotifies.Length;
            RefreshSubscriberNotifies[SubscriberNotifyIndex] = Subscriber.NotifyDataStoreValueUpdated;
        }
    }
}

event Unregistered(LocalPlayer PlayerOwner)
{
}

event Registered(LocalPlayer PlayerOwner)
{
}

delegate OnDataStoreValueUpdated(UIDataStore SourceDataStore, bool bValuesInvalidated, name PropertyTag, UIDataProvider SourceProvider, int ArrayIndex)
{
}

defaultproperties
{
}

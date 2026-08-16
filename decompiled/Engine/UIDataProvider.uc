class UIDataProvider extends UIRoot
    abstract
    native
    notplaceable
    transient
    hidecategories(Object,UIRoot);

enum EProviderAccessType
{
    ACCESS_ReadOnly,
    ACCESS_PerField,
    ACCESS_WriteAll,
};

struct native transient UIDataProviderField
{
    var name FieldTag;
    var EUIDataProviderFieldType FieldType;
    var array<UIDataProvider> FieldProviders;
};

var EProviderAccessType WriteAccessType;
var transient array<delegate<OnDataProviderPropertyChange>> ProviderChangedNotifies;
var transient delegate<OnDataProviderPropertyChange> __OnDataProviderPropertyChange__Delegate;

final function int ParseTagArrayDelimiter(out name FieldName)
{
    local string FieldNameString;
    local int Result;
    
    FieldNameString = string(FieldName);
    Result = ParseArrayDelimiter(FieldNameString);
    FieldName = name(FieldNameString);
    return Result;
}

final function bool RemovePropertyNotificationChangeRequest(delegate<OnDataProviderPropertyChange> InDelegate)
{
    local int Index;
    local bool bResult;
    
    Index = ProviderChangedNotifies.Find(InDelegate);
    while (Index != -1)
    {
        ProviderChangedNotifies.Remove(Index, 1);
        bResult = true;
        Index = ProviderChangedNotifies.Find(InDelegate);
    }
    return bResult;
}

final function bool AddPropertyNotificationChangeRequest(delegate<OnDataProviderPropertyChange> InDelegate, optional bool bAllowDuplicates)
{
    local int NewIndex;
    local bool bResult;
    
    NewIndex = ProviderChangedNotifies.Find(InDelegate);
    if (bAllowDuplicates || NewIndex == -1)
    {
        NewIndex = ProviderChangedNotifies.Length;
        ProviderChangedNotifies[NewIndex] = InDelegate;
        bResult = true;
    }
    return bResult;
}

event NotifyPropertyChanged(optional name PropTag)
{
    local int Index;
    local delegate<OnDataProviderPropertyChange> Subscriber;
    local array<delegate<OnDataProviderPropertyChange>> SubscriberArrayCopy;
    
    SubscriberArrayCopy.Length = ProviderChangedNotifies.Length;
    for (Index = 0; Index < SubscriberArrayCopy.Length; Index++)
    {
        SubscriberArrayCopy[Index] = ProviderChangedNotifies[Index];
    }
    for (Index = 0; Index < SubscriberArrayCopy.Length; Index++)
    {
        Subscriber = SubscriberArrayCopy[Index];
        OnDataProviderPropertyChange(self, PropTag);
    }
}

event bool IsCollectionDataType(EUIDataProviderFieldType FieldType)
{
    return FieldType == 4 || FieldType == 5;
}

event bool IsProviderDisabled()
{
}

event string GenerateFillerData(string DataTag)
{
}

event string GenerateScriptMarkupString(name DataTag)
{
}

event bool SetFieldValue(string FieldName, out const UIProviderScriptFieldValue FieldValue, optional int ArrayIndex = -1)
{
}

event bool GetFieldValue(string FieldName, out UIProviderScriptFieldValue FieldValue, optional int ArrayIndex = -1)
{
}

event bool AllowPublishingToField(string FieldName, optional int ArrayIndex = -1)
{
}

event GetSupportedScriptFields(out array<UIDataProviderField> out_Fields)
{
}

native function int ParseArrayDelimiter(out string DataTag)
{
    DataTag;
}

native final function bool GetProviderFieldType(coerce string DataTag, out EUIDataProviderFieldType out_ProviderFieldType)
{
    DataTag;
    out_ProviderFieldType;
}

delegate OnDataProviderPropertyChange(UIDataProvider SourceProvider, optional name PropTag)
{
}

defaultproperties
{
}

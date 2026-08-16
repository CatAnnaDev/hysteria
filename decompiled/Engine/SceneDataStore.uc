class SceneDataStore extends UIDataStore
    native
    notplaceable
    hidecategories(Object,UIRoot)
    implements(UIListElementProvider,UIListElementCellProvider);

var const native noexport Pointer VfTable_IUIListElementProvider;
var const native noexport Pointer VfTable_IUIListElementCellProvider;
var const transient UIScene OwnerScene;
var UIDynamicFieldProvider SceneDataProvider;

event Registered(LocalPlayer PlayerOwner)
{
    Registered(PlayerOwner);
    SceneDataProvider.__OnDataProviderPropertyChange__Delegate = SceneDataFieldChanged;
}

function SceneDataFieldChanged(UIDataProvider SourceProvider, optional name PropTag)
{
    RefreshSubscribers(PropTag, true, SourceProvider);
}

final function int FindCollectionValueIndex(name FieldName, out const string ValueToFind, optional bool bPersistent, optional name CellTag)
{
    if (SceneDataProvider != none)
    {
        return SceneDataProvider.FindCollectionValueIndex(FieldName, ValueToFind, bPersistent, CellTag);
    }
    return -1;
}

final function bool GetCollectionValue(name FieldName, int ValueIndex, out string out_Value, optional bool bPersistent, optional name CellTag)
{
    if (SceneDataProvider != none)
    {
        return SceneDataProvider.GetCollectionValue(FieldName, ValueIndex, out_Value, bPersistent, CellTag);
    }
    return false;
}

final function bool ClearCollectionValueArray(name FieldName, optional bool bPersistent, optional name CellTag)
{
    if (SceneDataProvider != none)
    {
        return SceneDataProvider.ClearCollectionValueArray(FieldName, bPersistent, CellTag);
    }
    return false;
}

final function bool ReplaceCollectionValueByIndex(name FieldName, int ValueIndex, out const string NewValue, optional bool bPersistent, optional name CellTag)
{
    if (SceneDataProvider != none)
    {
        return SceneDataProvider.ReplaceCollectionValueByIndex(FieldName, ValueIndex, NewValue, bPersistent, CellTag);
    }
    return false;
}

final function bool ReplaceCollectionValue(name FieldName, out const string CurrentValue, out const string NewValue, optional bool bPersistent, optional name CellTag)
{
    if (SceneDataProvider != none)
    {
        return SceneDataProvider.ReplaceCollectionValue(FieldName, CurrentValue, NewValue, bPersistent, CellTag);
    }
    return false;
}

final function bool RemoveCollectionValueByIndex(name FieldName, int ValueIndex, optional bool bPersistent, optional name CellTag)
{
    if (SceneDataProvider != none)
    {
        return SceneDataProvider.RemoveCollectionValueByIndex(FieldName, ValueIndex, bPersistent, CellTag);
    }
    return false;
}

final function bool RemoveCollectionValue(name FieldName, out const string ValueToRemove, optional bool bPersistent, optional name CellTag)
{
    if (SceneDataProvider != none)
    {
        return SceneDataProvider.RemoveCollectionValue(FieldName, ValueToRemove, bPersistent, CellTag);
    }
    return false;
}

final function bool InsertCollectionValue(name FieldName, out const string NewValue, optional int InsertIndex = -1, optional bool bPersistent, optional bool bAllowDuplicateValues, optional name CellTag)
{
    if (SceneDataProvider != none)
    {
        return SceneDataProvider.InsertCollectionValue(FieldName, NewValue, InsertIndex, bPersistent, bAllowDuplicateValues, CellTag);
    }
    return false;
}

final function bool SetCollectionValueArray(name FieldName, out const array<string> CollectionValues, optional bool bClearExisting = true, optional int InsertIndex = -1, optional bool bPersistent, optional name CellTag)
{
    if (SceneDataProvider != none)
    {
        return SceneDataProvider.SetCollectionValueArray(FieldName, CollectionValues, bClearExisting, InsertIndex, bPersistent, CellTag);
    }
    return false;
}

final function bool GetCollectionValueArray(name FieldName, out array<string> out_DataValueArray, optional bool bPersistent, optional name CellTag)
{
    if (SceneDataProvider != none)
    {
        return SceneDataProvider.GetCollectionValueArray(FieldName, out_DataValueArray, bPersistent, CellTag);
    }
    return false;
}

final function bool ClearFields(optional bool bReinitializeRuntimeFields = true)
{
    if (SceneDataProvider != none)
    {
        return SceneDataProvider.ClearFields(bReinitializeRuntimeFields);
    }
    return false;
}

final function int FindFieldIndex(name FieldName, optional bool bSearchPersistentFields)
{
    if (SceneDataProvider != none)
    {
        return SceneDataProvider.FindFieldIndex(FieldName, bSearchPersistentFields);
    }
    return -1;
}

final function bool RemoveField(name FieldName)
{
    if (SceneDataProvider != none)
    {
        return SceneDataProvider.RemoveField(FieldName);
    }
    return false;
}

final function bool AddField(name FieldName, optional EUIDataProviderFieldType FieldType = 0, optional bool bPersistent, optional out int out_InsertPosition)
{
    if (SceneDataProvider != none)
    {
        return SceneDataProvider.AddField(FieldName, FieldType, bPersistent, out_InsertPosition);
    }
    return false;
}

defaultproperties
{
    Tag="SCENE_DATASTORE_TAG"
}

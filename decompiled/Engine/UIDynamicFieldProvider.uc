class UIDynamicFieldProvider extends UIDataProvider
    native
    notplaceable
    perobjectconfig
    config(UI)
    hidecategories(Object,UIRoot);

var() config array<UIProviderScriptFieldValue> PersistentDataFields;
var() transient array<UIProviderScriptFieldValue> RuntimeDataFields;
var const native Map_Mirror PersistentCollectionData;
var const native transient Map_Mirror RuntimeCollectionData;

native final function int FindCollectionValueIndex(name FieldName, out const string ValueToFind, optional bool bPersistent, optional name CellTag)
{
    FieldName;
    ValueToFind;
    bPersistent;
    CellTag;
}

native final function bool GetCollectionValue(name FieldName, int ValueIndex, out string out_Value, optional bool bPersistent, optional name CellTag)
{
    FieldName;
    ValueIndex;
    out_Value;
    bPersistent;
    CellTag;
}

native final function bool ClearCollectionValueArray(name FieldName, optional bool bPersistent, optional name CellTag)
{
    FieldName;
    bPersistent;
    CellTag;
}

native final function bool ReplaceCollectionValueByIndex(name FieldName, int ValueIndex, out const string NewValue, optional bool bPersistent, optional name CellTag)
{
    FieldName;
    ValueIndex;
    NewValue;
    bPersistent;
    CellTag;
}

native final function bool ReplaceCollectionValue(name FieldName, out const string CurrentValue, out const string NewValue, optional bool bPersistent, optional name CellTag)
{
    FieldName;
    CurrentValue;
    NewValue;
    bPersistent;
    CellTag;
}

native final function bool RemoveCollectionValueByIndex(name FieldName, int ValueIndex, optional bool bPersistent, optional name CellTag)
{
    FieldName;
    ValueIndex;
    bPersistent;
    CellTag;
}

native final function bool RemoveCollectionValue(name FieldName, out const string ValueToRemove, optional bool bPersistent, optional name CellTag)
{
    FieldName;
    ValueToRemove;
    bPersistent;
    CellTag;
}

native final function bool InsertCollectionValue(name FieldName, out const string NewValue, optional int InsertIndex = -1, optional bool bPersistent, optional bool bAllowDuplicateValues, optional name CellTag)
{
    FieldName;
    NewValue;
    InsertIndex;
    bPersistent;
    bAllowDuplicateValues;
    CellTag;
}

native final function bool SetCollectionValueArray(name FieldName, out const array<string> CollectionValues, optional bool bClearExisting = true, optional int InsertIndex = -1, optional bool bPersistent, optional name CellTag)
{
    FieldName;
    CollectionValues;
    bClearExisting;
    InsertIndex;
    bPersistent;
    CellTag;
}

native final function bool GetCollectionValueArray(name FieldName, out array<string> out_DataValueArray, optional bool bPersistent, optional name CellTag)
{
    FieldName;
    out_DataValueArray;
    bPersistent;
    CellTag;
}

native final function bool GetCollectionValueSchema(name FieldName, out array<name> out_CellTagArray, optional bool bPersistent)
{
    FieldName;
    out_CellTagArray;
    bPersistent;
}

native final function SavePersistentProviderData()
{
}

native final function bool SetField(name FieldName, out const UIProviderScriptFieldValue FieldValue, optional bool bChangeExistingOnly = true)
{
    FieldName;
    FieldValue;
    bChangeExistingOnly;
}

native final function bool GetField(name FieldName, out UIProviderScriptFieldValue out_Field)
{
    FieldName;
    out_Field;
}

native final function bool ClearFields(optional bool bReinitializeRuntimeFields = true)
{
    bReinitializeRuntimeFields;
}

native final function int FindFieldIndex(name FieldName, optional bool bSearchPersistentFields)
{
    FieldName;
    bSearchPersistentFields;
}

native final function bool RemoveField(name FieldName)
{
    FieldName;
}

native final function bool AddField(name FieldName, optional EUIDataProviderFieldType FieldType = 0, optional bool bPersistent, optional out int out_InsertPosition)
{
    FieldName;
    FieldType;
    bPersistent;
    out_InsertPosition;
}

native function InitializeRuntimeFields()
{
}

defaultproperties
{
    WriteAccessType="ACCESS_WriteAll"
}

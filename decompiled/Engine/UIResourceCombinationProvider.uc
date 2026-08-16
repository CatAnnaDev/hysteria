class UIResourceCombinationProvider extends UIDataProvider
    abstract
    native
    notplaceable
    transient
    perobjectconfig
    config(Game)
    hidecategories(Object,UIRoot)
    implements(UIListElementProvider,UIListElementCellProvider);

var const native noexport Pointer VfTable_IUIListElementProvider;
var const native noexport Pointer VfTable_IUIListElementCellProvider;
var transient UIResourceDataProvider StaticDataProvider;
var transient UIDataProvider_OnlineProfileSettings ProfileProvider;

function bool ReplaceProviderCollection(out array<UIDataProviderField> out_Fields, name TargetFieldTag, out const array<UIDataProvider> ReplacementProviders)
{
    local int FieldIndex;
    local bool bResult;
    
    for (FieldIndex = 0; FieldIndex < out_Fields.Length; FieldIndex++)
    {
        if (out_Fields[FieldIndex].FieldTag == TargetFieldTag)
        {
            if (out_Fields[FieldIndex].FieldType == 5)
            {
                out_Fields[FieldIndex].FieldProviders = ReplacementProviders;
                bResult = true;
            }
            break;
        }
    }
    return bResult;
}

function bool ReplaceProviderValue(out array<UIDataProviderField> out_Fields, name TargetFieldTag, UIDataProvider ReplacementProvider)
{
    local int FieldIndex;
    local bool bResult;
    
    for (FieldIndex = 0; FieldIndex < out_Fields.Length; FieldIndex++)
    {
        if (out_Fields[FieldIndex].FieldTag == TargetFieldTag)
        {
            if (out_Fields[FieldIndex].FieldType == 1)
            {
                out_Fields[FieldIndex].FieldProviders[0] = ReplacementProvider;
                bResult = true;
            }
            break;
        }
    }
    return bResult;
}

function ClearProviderReferences()
{
    StaticDataProvider = none;
    ProfileProvider = none;
}

event bool GetCellFieldValue(name FieldName, name CellTag, int ListIndex, out UIProviderFieldValue out_FieldValue, optional int ArrayIndex = -1)
{
    local bool bResult;
    
    bResult = false;
    if (1 == 0)
    {
        LogInternal("(" $ string(Name) $ ") UIResourceCombinationProvider::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) @ "FieldName:'" $ string(FieldName) $ "'");
    }
    return bResult;
}

event bool GetCellFieldType(name FieldName, name CellTag, out EUIDataProviderFieldType FieldType)
{
    local bool bResult;
    
    bResult = false;
    if (1 == 0)
    {
        LogInternal("(" $ string(Name) $ ") UIResourceCombinationProvider::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) @ "FieldName:'" $ string(FieldName) $ "'");
    }
    return bResult;
}

event GetElementCellTags(name FieldName, out array<name> CellFieldTags, optional out array<string> ColumnHeaderDisplayText)
{
    if (1 == 0)
    {
        LogInternal("(" $ string(Name) $ ") UIResourceCombinationProvider::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) @ "FieldName:'" $ string(FieldName) $ "'");
    }
}

event bool GetElementCellValueProvider(name FieldName, int ListIndex, out UIListElementCellProvider out_ValueProvider)
{
    local bool bResult;
    
    bResult = false;
    if (1 == 0)
    {
        LogInternal("(" $ string(Name) $ ") UIResourceCombinationProvider::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) @ "FieldName:'" $ string(FieldName) $ "'");
    }
    return bResult;
}

event bool GetElementCellSchemaProvider(name FieldName, out UIListElementCellProvider out_SchemaProvider)
{
    local bool bResult;
    
    bResult = false;
    if (1 == 0)
    {
        LogInternal("(" $ string(Name) $ ") UIResourceCombinationProvider::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) @ "FieldName:'" $ string(FieldName) $ "'");
    }
    return bResult;
}

event bool IsElementEnabled(name FieldName, int CollectionIndex)
{
    local bool bResult;
    
    bResult = false;
    if (1 == 0)
    {
        LogInternal("(" $ string(Name) $ ") UIResourceCombinationProvider::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) @ "FieldName:'" $ string(FieldName) $ "'");
    }
    return bResult;
}

event bool GetListElements(name FieldName, out array<int> out_Elements)
{
    local bool bResult;
    
    bResult = false;
    if (1 == 0)
    {
        LogInternal("(" $ string(Name) $ ") UIResourceCombinationProvider::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) @ "FieldName:'" $ string(FieldName) $ "'");
    }
    return bResult;
}

event int GetElementCount(name FieldName)
{
    local int Result;
    
    if (1 == 0)
    {
        LogInternal("(" $ string(Name) $ ") UIResourceCombinationProvider::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) @ "FieldName:'" $ string(FieldName) $ "'");
    }
    Result = 0;
    return Result;
}

event array<name> GetElementProviderTags()
{
    local array<name> Tags;
    
    if (1 == 0)
    {
        LogInternal("(" $ string(Name) $ ") UIResourceCombinationProvider::" $ string(GetStateName()) $ ":" $ string(GetFuncName()));
    }
    Tags.Length = 0;
    return Tags;
}

event InitializeProvider(bool bIsEditor, UIResourceDataProvider InStaticResourceProvider, UIDataProvider_OnlineProfileSettings InProfileProvider)
{
    StaticDataProvider = InStaticResourceProvider;
    ProfileProvider = InProfileProvider;
}

defaultproperties
{
}

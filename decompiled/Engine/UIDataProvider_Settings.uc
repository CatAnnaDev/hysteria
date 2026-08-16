class UIDataProvider_Settings extends UIDynamicDataProvider
    native
    notplaceable
    transient
    hidecategories(Object,UIRoot);

struct native SettingsArrayProvider
{
    var int SettingsId;
    var name SettingsName;
    var UIDataProvider_SettingsArray Provider;
};

var Settings Settings;
var array<SettingsArrayProvider> SettingsArrayProviders;
var bool bIsAListRow;

function OnSettingValueUpdated(name SettingName)
{
    local int ProviderIdx;
    local UIDataProvider_SettingsArray ArrayProvider;
    
    if (!bIsAListRow)
    {
        for (ProviderIdx = 0; ProviderIdx < SettingsArrayProviders.Length; ProviderIdx++)
        {
            if (SettingName == SettingsArrayProviders[ProviderIdx].SettingsName)
            {
                ArrayProvider = SettingsArrayProviders[ProviderIdx].Provider;
                ArrayProviderPropertyChanged(ArrayProvider, SettingName);
                break;
            }
        }
    }
    else
    {
        NotifyPropertyChanged(SettingName);
    }
}

function ArrayProviderPropertyChanged(UIDataProvider SourceProvider, optional name PropTag)
{
    local int Index;
    local delegate<OnDataProviderPropertyChange> Subscriber;
    
    for (Index = 0; Index < ProviderChangedNotifies.Length; Index++)
    {
        Subscriber = ProviderChangedNotifies[Index];
        OnDataProviderPropertyChange(SourceProvider, PropTag);
    }
}

event ProviderInstanceUnbound(Object DataSourceInstance)
{
    local Settings SettingsObject;
    
    ProviderInstanceBound(DataSourceInstance);
    SettingsObject = Settings(DataSourceInstance);
    if (SettingsObject != none)
    {
        if (SettingsObject.__NotifySettingValueUpdated__Delegate == OnSettingValueUpdated)
        {
            SettingsObject.__NotifySettingValueUpdated__Delegate = None;
        }
        if (SettingsObject.__NotifyPropertyValueUpdated__Delegate == OnSettingValueUpdated)
        {
            SettingsObject.__NotifyPropertyValueUpdated__Delegate = None;
        }
    }
}

event ProviderInstanceBound(Object DataSourceInstance)
{
    local Settings SettingsObject;
    
    ProviderInstanceBound(DataSourceInstance);
    SettingsObject = Settings(DataSourceInstance);
    if (SettingsObject != none)
    {
        SettingsObject.__NotifySettingValueUpdated__Delegate = OnSettingValueUpdated;
        SettingsObject.__NotifyPropertyValueUpdated__Delegate = OnSettingValueUpdated;
    }
}

defaultproperties
{
    WriteAccessType="ACCESS_WriteAll"
}

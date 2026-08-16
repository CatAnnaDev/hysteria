class Settings extends Object
    abstract
    native
    notplaceable;

enum EPropertyValueMappingType
{
    PVMT_RawValue,
    PVMT_PredefinedValues,
    PVMT_Ranged,
    PVMT_IdMapped,
};

enum ESettingsDataType
{
    SDT_Empty,
    SDT_Int32,
    SDT_Int64,
    SDT_Double,
    SDT_String,
    SDT_Float,
    SDT_Blob,
    SDT_DateTime,
};

enum EOnlineDataAdvertisementType
{
    ODAT_DontAdvertise,
    ODAT_OnlineService,
    ODAT_QoS,
    ODAT_OnlineServiceAndQoS,
};

struct native SettingsPropertyPropertyMetaData
{
    var const int Id;
    var const name Name;
    var const localized string ColumnHeaderText;
    var const EPropertyValueMappingType MappingType;
    var const array<IdToStringMapping> ValueMappings;
    var const array<SettingsData> PredefinedValues;
    var const float MinVal;
    var const float MaxVal;
    var const float RangeIncrement;
};

struct native IdToStringMapping
{
    var const int Id;
    var const localized name Name;
};

struct native LocalizedStringSettingMetaData
{
    var const int Id;
    var const name Name;
    var const localized string ColumnHeaderText;
    var const array<StringIdToStringMapping> ValueMappings;
};

struct native StringIdToStringMapping
{
    var const int Id;
    var const localized name Name;
    var const bool bIsWildcard;
};

struct native SettingsProperty
{
    var int PropertyId;
    var SettingsData Data;
    var EOnlineDataAdvertisementType AdvertisementType;
};

struct native SettingsData
{
    var const ESettingsDataType Type;
    var const int Value1;
    var const native transient Pointer Value2;
};

struct native LocalizedStringSetting
{
    var int Id;
    var int ValueIndex;
    var EOnlineDataAdvertisementType AdvertisementType;
};

var array<LocalizedStringSetting> LocalizedSettings;
var array<SettingsProperty> Properties;
var array<LocalizedStringSettingMetaData> LocalizedSettingsMappings;
var array<SettingsPropertyPropertyMetaData> PropertyMappings;
var delegate<NotifySettingValueUpdated> __NotifySettingValueUpdated__Delegate;
var delegate<NotifyPropertyValueUpdated> __NotifyPropertyValueUpdated__Delegate;

native function UpdateFromURL(out const string URL, GameInfo Game)
{
    URL;
    Game;
}

native function BuildURL(out string URL)
{
    URL;
}

native function AppendContextsToURL(out string URL)
{
    URL;
}

native function AppendPropertiesToURL(out string URL)
{
    URL;
}

native function AppendDataBindingsToURL(out string URL)
{
    URL;
}

native function GetQoSAdvertisedStringSettings(out array<LocalizedStringSetting> QoSSettings)
{
    QoSSettings;
}

native function GetQoSAdvertisedProperties(out array<SettingsProperty> QoSProps)
{
    QoSProps;
}

native function bool GetRangedPropertyValue(int PropertyId, out float OutValue)
{
    PropertyId;
    OutValue;
}

native function bool SetRangedPropertyValue(int PropertyId, float NewValue)
{
    PropertyId;
    NewValue;
}

native function bool GetPropertyRange(int PropertyId, out float OutMinValue, out float OutMaxValue, out float RangeIncrement, out byte bFormatAsInt)
{
    PropertyId;
    OutMinValue;
    OutMaxValue;
    RangeIncrement;
    bFormatAsInt;
}

native function bool GetPropertyMappingType(int PropertyId, out EPropertyValueMappingType OutType)
{
    PropertyId;
    OutType;
}

native function bool HasStringSetting(int SettingId)
{
    SettingId;
}

native function bool HasProperty(int PropertyId)
{
    PropertyId;
}

native function UpdateProperties(out const array<SettingsProperty> Props, optional bool bShouldAddIfMissing = true)
{
    Props;
    bShouldAddIfMissing;
}

native function UpdateStringSettings(out const array<LocalizedStringSetting> Settings, optional bool bShouldAddIfMissing = true)
{
    Settings;
    bShouldAddIfMissing;
}

native function ESettingsDataType GetPropertyType(int PropertyId)
{
    PropertyId;
}

native function bool GetPropertyValueId(int PropertyId, out int ValueId)
{
    PropertyId;
    ValueId;
}

native function bool SetPropertyValueId(int PropertyId, int ValueId)
{
    PropertyId;
    ValueId;
}

native function bool GetStringProperty(int PropertyId, out string Value)
{
    PropertyId;
    Value;
}

native function SetStringProperty(int PropertyId, string Value)
{
    PropertyId;
    Value;
}

native function bool GetIntProperty(int PropertyId, out int Value)
{
    PropertyId;
    Value;
}

native function SetIntProperty(int PropertyId, int Value)
{
    PropertyId;
    Value;
}

native function bool GetFloatProperty(int PropertyId, out float Value)
{
    PropertyId;
    Value;
}

native function SetFloatProperty(int PropertyId, float Value)
{
    PropertyId;
    Value;
}

native function bool SetPropertyFromStringByName(name PropertyName, out const string NewValue)
{
    PropertyName;
    NewValue;
}

native function string GetPropertyAsStringByName(name PropertyName)
{
    PropertyName;
}

native function string GetPropertyAsString(int PropertyId)
{
    PropertyId;
}

native function string GetPropertyColumnHeader(int PropertyId)
{
    PropertyId;
}

native function name GetPropertyName(int PropertyId)
{
    PropertyId;
}

native function bool GetPropertyId(name PropertyName, out int PropertyId)
{
    PropertyName;
    PropertyId;
}

native function bool SetStringSettingValueFromStringByName(name StringSettingName, out const string NewValue)
{
    StringSettingName;
    NewValue;
}

native function name GetStringSettingValueNameByName(name StringSettingName)
{
    StringSettingName;
}

native function name GetStringSettingValueName(int StringSettingId, int ValueIndex)
{
    StringSettingId;
    ValueIndex;
}

native function bool IsWildcardStringSetting(int StringSettingId)
{
    StringSettingId;
}

native function string GetStringSettingColumnHeader(int StringSettingId)
{
    StringSettingId;
}

native function name GetStringSettingName(int StringSettingId)
{
    StringSettingId;
}

native function bool GetStringSettingId(name StringSettingName, out int StringSettingId)
{
    StringSettingName;
    StringSettingId;
}

native function bool GetStringSettingValueByName(name StringSettingName, out int ValueIndex)
{
    StringSettingName;
    ValueIndex;
}

native function SetStringSettingValueByName(name StringSettingName, int ValueIndex, bool bShouldAutoAdd)
{
    StringSettingName;
    ValueIndex;
    bShouldAutoAdd;
}

native function bool GetStringSettingValueNames(int StringSettingId, out array<IdToStringMapping> Values)
{
    StringSettingId;
    Values;
}

native function bool IncrementStringSettingValue(int StringSettingId, int Direction, bool bShouldWrap)
{
    StringSettingId;
    Direction;
    bShouldWrap;
}

native function bool GetStringSettingValue(int StringSettingId, out int ValueIndex)
{
    StringSettingId;
    ValueIndex;
}

native function SetStringSettingValue(int StringSettingId, int ValueIndex, optional bool bShouldAutoAdd)
{
    StringSettingId;
    ValueIndex;
    bShouldAutoAdd;
}

native static function GetSettingsDataDateTime(out SettingsData Data, out int OutInt1, out int OutInt2)
{
    Data;
    OutInt1;
    OutInt2;
}

native static function GetSettingsDataBlob(out SettingsData Data, out array<byte> OutBlob)
{
    Data;
    OutBlob;
}

native static function int GetSettingsDataInt(out SettingsData Data)
{
    Data;
}

native static function float GetSettingsDataFloat(out SettingsData Data)
{
    Data;
}

native static function string GetSettingsDataString(out SettingsData Data)
{
    Data;
}

native static function EmptySettingsData(out SettingsData Data)
{
    Data;
}

native static function SetSettingsData(out SettingsData Data, out SettingsData Data2Copy)
{
    Data;
    Data2Copy;
}

native static function SetSettingsDataBlob(out SettingsData Data, out array<byte> InBlob)
{
    Data;
    InBlob;
}

native static function SetSettingsDataDateTime(out SettingsData Data, int InInt1, int InInt2)
{
    Data;
    InInt1;
    InInt2;
}

native static function SetSettingsDataInt(out SettingsData Data, int InInt)
{
    Data;
    InInt;
}

native static function SetSettingsDataFloat(out SettingsData Data, float InFloat)
{
    Data;
    InFloat;
}

native static function SetSettingsDataString(out SettingsData Data, string InString)
{
    Data;
    InString;
}

delegate NotifyPropertyValueUpdated(name PropertyName)
{
}

delegate NotifySettingValueUpdated(name SettingName)
{
}

defaultproperties
{
}

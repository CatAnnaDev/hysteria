class OnlinePlayerStorage extends Object
    native
    notplaceable;

enum EOnlinePlayerStorageAsyncState
{
    OPAS_None,
    OPAS_Read,
    OPAS_Write,
};

enum EOnlineProfilePropertyOwner
{
    OPPO_None,
    OPPO_OnlineService,
    OPPO_Game,
};

struct native OnlineProfileSetting
{
    var EOnlineProfilePropertyOwner Owner;
    var SettingsProperty ProfileSetting;
};

var const int VersionNumber;
var array<OnlineProfileSetting> ProfileSettings;
var array<SettingsPropertyPropertyMetaData> ProfileMappings;
var const EOnlinePlayerStorageAsyncState AsyncState;
var delegate<NotifySettingValueUpdated> __NotifySettingValueUpdated__Delegate;

event SetToDefaults()
{
    ProfileSettings.Length = 0;
}

native function AddSettingFloat(int SettingId)
{
    SettingId;
}

native function AddSettingInt(int SettingId)
{
    SettingId;
}

native function bool GetRangedProfileSettingValue(int ProfileId, out float OutValue)
{
    ProfileId;
    OutValue;
}

native function bool SetRangedProfileSettingValue(int ProfileId, float NewValue)
{
    ProfileId;
    NewValue;
}

native function bool GetProfileSettingRange(int ProfileId, out float OutMinValue, out float OutMaxValue, out float RangeIncrement, out byte bFormatAsInt)
{
    ProfileId;
    OutMinValue;
    OutMaxValue;
    RangeIncrement;
    bFormatAsInt;
}

native static function bool GetProfileSettingMappingIds(int ProfileId, out array<int> IDs)
{
    ProfileId;
    IDs;
}

native function bool GetProfileSettingMappingType(int ProfileId, out EPropertyValueMappingType OutType)
{
    ProfileId;
    OutType;
}

native function bool SetProfileSettingValueFloat(int ProfileSettingId, float Value)
{
    ProfileSettingId;
    Value;
}

native function bool SetProfileSettingValueInt(int ProfileSettingId, int Value)
{
    ProfileSettingId;
    Value;
}

native function bool SetProfileSettingValueId(int ProfileSettingId, int Value)
{
    ProfileSettingId;
    Value;
}

native function bool GetProfileSettingValueFloat(int ProfileSettingId, out float Value)
{
    ProfileSettingId;
    Value;
}

native function bool GetProfileSettingValueInt(int ProfileSettingId, out int Value)
{
    ProfileSettingId;
    Value;
}

native function bool GetProfileSettingValueId(int ProfileSettingId, out int ValueId, optional out int ListIndex)
{
    ProfileSettingId;
    ValueId;
    ListIndex;
}

native function bool SetProfileSettingValue(int ProfileSettingId, out const string NewValue)
{
    ProfileSettingId;
    NewValue;
}

native function bool SetProfileSettingValueByName(name ProfileSettingName, out const string NewValue)
{
    ProfileSettingName;
    NewValue;
}

native function bool GetProfileSettingValueByName(name ProfileSettingName, out string Value)
{
    ProfileSettingName;
    Value;
}

native function bool GetProfileSettingValues(int ProfileSettingId, out array<name> Values)
{
    ProfileSettingId;
    Values;
}

native function name GetProfileSettingValueName(int ProfileSettingId)
{
    ProfileSettingId;
}

native function bool GetProfileSettingValue(int ProfileSettingId, out string Value, optional int ValueMapID = -1)
{
    ProfileSettingId;
    Value;
    ValueMapID;
}

native function bool IsProfileSettingIdMapped(int ProfileSettingId)
{
    ProfileSettingId;
}

native static final function int FindDefaultProfileMappingIndexByName(name ProfileSettingName)
{
    ProfileSettingName;
}

native final function int FindProfileMappingIndexByName(name ProfileSettingName)
{
    ProfileSettingName;
}

native final function int FindProfileMappingIndex(int ProfileSettingId)
{
    ProfileSettingId;
}

native final function int FindProfileSettingIndex(int ProfileSettingId)
{
    ProfileSettingId;
}

native function string GetProfileSettingColumnHeader(int ProfileSettingId)
{
    ProfileSettingId;
}

native function name GetProfileSettingName(int ProfileSettingId)
{
    ProfileSettingId;
}

native function bool GetProfileSettingId(name ProfileSettingName, out int ProfileSettingId)
{
    ProfileSettingName;
    ProfileSettingId;
}

delegate NotifySettingValueUpdated(name SettingName)
{
}

defaultproperties
{
    VersionNumber=-1
}

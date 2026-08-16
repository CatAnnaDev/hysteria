class UIDataProvider_OnlineProfileSettings extends UIDataProvider_OnlinePlayerStorage
    native
    notplaceable
    transient
    config(Game)
    hidecategories(Object,UIRoot);

function ClearReadCompleteDelegate(OnlinePlayerInterface PlayerInterface, byte LocalUserNum)
{
    PlayerInterface.ClearReadProfileSettingsCompleteDelegate(LocalUserNum, OnReadStorageComplete);
}

function AddReadCompleteDelegate(OnlinePlayerInterface PlayerInterface, byte LocalUserNum)
{
    PlayerInterface.AddReadProfileSettingsCompleteDelegate(LocalUserNum, OnReadStorageComplete);
}

function bool WriteData(OnlinePlayerInterface PlayerInterface, byte LocalUserNum, OnlinePlayerStorage PlayerStorage)
{
    return PlayerInterface.WriteProfileSettings(LocalUserNum, OnlineProfileSettings(PlayerStorage));
}

function bool ReadData(OnlinePlayerInterface PlayerInterface, byte LocalUserNum, OnlinePlayerStorage PlayerStorage)
{
    return PlayerInterface.ReadProfileSettings(LocalUserNum, OnlineProfileSettings(PlayerStorage));
}

defaultproperties
{
    ProviderName="ProfileData"
}

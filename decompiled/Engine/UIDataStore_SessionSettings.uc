class UIDataStore_SessionSettings extends UIDataStore_Settings
    native
    notplaceable
    transient
    config(Game)
    hidecategories(Object,UIRoot);

var const config array<string> SessionSettingsProviderClassNames;
var const transient array<class<SessionSettingsProvider>> SessionSettingsProviderClasses;
var transient array<SessionSettingsProvider> SessionSettings;

function bool NotifyGameSessionEnded()
{
    ClearDataProviders();
    return NotifyGameSessionEnded();
}

final function ClearDataProviders()
{
    local int I;
    
    for (I = 0; I < SessionSettings.Length; I++)
    {
        SessionSettings[I].CleanupDataProvider();
    }
    SessionSettings.Length = 0;
}

defaultproperties
{
    Tag="GameSettings"
}

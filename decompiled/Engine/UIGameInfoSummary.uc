class UIGameInfoSummary extends UIResourceDataProvider
    notplaceable
    transient
    perobjectconfig
    config(Game)
    hidecategories(Object,UIRoot);

var config string ClassName;
var config string GameAcronym;
var config string MapPrefix;
var config bool bIsTeamGame;
var config bool bIsDisabled;
var config string GameSettingsClassName;
var const config localized string GameName;
var const config localized string Description;

event bool IsProviderDisabled()
{
    return bIsDisabled;
}

defaultproperties
{
}

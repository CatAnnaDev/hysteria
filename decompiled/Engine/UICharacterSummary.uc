class UICharacterSummary extends UIResourceDataProvider
    notplaceable
    transient
    perobjectconfig
    config(Game)
    hidecategories(Object,UIRoot);

var config string ClassPathName;
var const config localized string CharacterName;
var const config localized string CharacterBio;
var config bool bIsDisabled;

event bool IsProviderDisabled()
{
    return bIsDisabled;
}

defaultproperties
{
}

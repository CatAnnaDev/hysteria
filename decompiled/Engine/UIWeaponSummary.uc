class UIWeaponSummary extends UIResourceDataProvider
    notplaceable
    transient
    perobjectconfig
    config(Game)
    hidecategories(Object,UIRoot);

var config string ClassPathName;
var const config localized string FriendlyName;
var const config localized string WeaponDescription;
var config bool bIsDisabled;

event bool IsProviderDisabled()
{
    return bIsDisabled;
}

defaultproperties
{
}

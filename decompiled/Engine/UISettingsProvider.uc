class UISettingsProvider extends UIPropertyDataProvider
    abstract
    native
    notplaceable
    transient
    hidecategories(Object,UIRoot);

var const name ProviderTag;

function bool CleanupDataProvider()
{
    return true;
}

function bool OnModifiedProperty(name PropertyName, UIObject Widget)
{
}

function SavePropertyValue(name PropertyName, UIObject Widget)
{
}

function LoadPropertyValue(name PropertyName, UIObject Widget)
{
}

defaultproperties
{
    ProviderTag="SettingsProvider"
}

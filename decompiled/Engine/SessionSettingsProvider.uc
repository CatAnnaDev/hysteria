class SessionSettingsProvider extends UISettingsProvider
    abstract
    native
    notplaceable
    transient
    within UIDataStore_SessionSettings
    hidecategories(Object,UIRoot);

var const class<UISettingsClient> ProviderClientClass;
var const class<Object> ProviderClientMetaClass;
var const transient class<Object> ProviderClient;

function bool CleanupDataProvider()
{
    if (ProviderClient != none)
    {
        return UnbindProviderClient();
    }
    return false;
}

event bool IsValidDataSourceClass(class<Object> PotentialDataSourceClass)
{
    return true;
}

event ProviderClientUnbound(class<Object> DataSourceClass)
{
}

event ProviderClientBound(class<Object> DataSourceClass)
{
}

native final function bool UnbindProviderClient()
{
}

native final function bool BindProviderClient(class<Object> DataSourceClass)
{
    DataSourceClass;
}

defaultproperties
{
    ProviderClientClass="UISettingsClient"
    ProviderTag="SessionSettingsProvider"
}

class UIDataStore_Registry extends UIDataStore
    native
    notplaceable
    transient
    hidecategories(Object,UIRoot);

var UIDynamicFieldProvider RegistryDataProvider;

final function UIDynamicFieldProvider GetDataProvider()
{
    return RegistryDataProvider;
}

defaultproperties
{
    Tag="Registry"
    WriteAccessType="ACCESS_WriteAll"
}

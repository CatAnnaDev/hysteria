class UIDynamicDataProvider extends UIPropertyDataProvider
    abstract
    native
    notplaceable
    transient
    hidecategories(Object,UIRoot)
    implements(UIListElementCellProvider);

var const native noexport Pointer VfTable_IUIListElementCellProvider;
var const class<Object> DataClass;
var const transient Object DataSource;

function bool CleanupDataProvider()
{
    return UnbindProviderInstance();
}

final function Object GetDataSource()
{
    return DataSource;
}

event bool IsValidDataSourceClass(class<Object> PotentialDataSourceClass)
{
    return true;
}

event ProviderInstanceUnbound(Object DataSourceInstance)
{
}

event ProviderInstanceBound(Object DataSourceInstance)
{
}

native final function bool UnbindProviderInstance()
{
}

native final function bool BindProviderInstance(Object DataSourceInstance)
{
    DataSourceInstance;
}

defaultproperties
{
}

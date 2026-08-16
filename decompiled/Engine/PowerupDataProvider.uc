class PowerupDataProvider extends InventoryDataProvider
    native
    notplaceable
    transient
    hidecategories(Object,UIRoot);

event bool IsValidDataSourceClass(class<Object> PotentialDataSourceClass)
{
    local bool bResult;
    
    bResult = IsValidDataSourceClass(PotentialDataSourceClass);
    if (bResult)
    {
        bResult = !ClassIsChildOf(PotentialDataSourceClass, class'Weapon');
    }
    return bResult;
}

defaultproperties
{
    DataClass="Inventory"
}

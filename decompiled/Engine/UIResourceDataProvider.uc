class UIResourceDataProvider extends UIPropertyDataProvider
    abstract
    native
    notplaceable
    transient
    perobjectconfig
    config(Game)
    hidecategories(Object,UIRoot)
    implements(UIListElementProvider,UIListElementCellProvider);

var const native noexport Pointer VfTable_IUIListElementProvider;
var const native noexport Pointer VfTable_IUIListElementCellProvider;
var bool bDataBindingPropertiesOnly;
var config bool bSkipDuringEnumeration;

event InitializeProvider(bool bIsEditor)
{
}

defaultproperties
{
    ComplexPropertyTypes(0)="Core.StructProperty"
    ComplexPropertyTypes(1)="Core.MapProperty"
    ComplexPropertyTypes(2)="Core.DelegateProperty"
}

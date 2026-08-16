class UIPropertyDataProvider extends UIDataProvider
    abstract
    native
    notplaceable
    transient
    hidecategories(Object,UIRoot);

var const array<class<Property>> ComplexPropertyTypes;
var delegate<CanSupportComplexPropertyType> __CanSupportComplexPropertyType__Delegate;

event bool GetCustomPropertyValue(out UIProviderScriptFieldValue PropertyValue, optional int ArrayIndex = -1)
{
}

delegate bool CanSupportComplexPropertyType(Property UnsupportedProperty)
{
}

defaultproperties
{
    ComplexPropertyTypes(0)="Core.StructProperty"
    ComplexPropertyTypes(1)="Core.MapProperty"
    ComplexPropertyTypes(2)="Core.ArrayProperty"
    ComplexPropertyTypes(3)="Core.DelegateProperty"
}

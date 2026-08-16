class SeqAct_ModifyProperty extends SequenceAction
    native
    notplaceable
    hidecategories(Object);

struct native PropertyInfo
{
    var() name PropertyName;
    var() bool bModifyProperty;
    var() string PropertyValue;
};

var() editinline array<PropertyInfo> Properties;

defaultproperties
{
    ObjName="Modify Property"
    ObjCategory="Object Property"
}

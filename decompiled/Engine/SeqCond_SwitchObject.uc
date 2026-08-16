class SeqCond_SwitchObject extends SeqCond_SwitchBase
    native
    placeable
    hidecategories(Object);

struct native SwitchObjectCase
{
    var() Object ObjectValue;
    var() bool bFallThru;
    var() bool bDefaultValue;
};

var() array<SwitchObjectCase> SupportedValues;
var() class<Object> MetaClass;

event RemoveValueEntry(int RemoveIndex)
{
    if (RemoveIndex >= 0 && RemoveIndex < SupportedValues.Length)
    {
        SupportedValues.Remove(RemoveIndex, 1);
    }
}

event InsertValueEntry(int InsertIndex)
{
    InsertIndex = Clamp(InsertIndex, 0, SupportedValues.Length);
    SupportedValues.Insert(InsertIndex, 1);
}

event bool IsFallThruEnabled(int ValueIndex)
{
    return ValueIndex >= 0 && ValueIndex < SupportedValues.Length && SupportedValues[ValueIndex].bFallThru;
}

event VerifyDefaultCaseValue()
{
    local int I;
    
    VerifyDefaultCaseValue();
    SupportedValues.Length = OutputLinks.Length;
    for (I = 0; I < SupportedValues.Length - 1; I++)
    {
        SupportedValues[I].bDefaultValue = false;
    }
    SupportedValues[SupportedValues.Length - 1].ObjectValue = none;
    SupportedValues[SupportedValues.Length - 1].bFallThru = false;
    SupportedValues[SupportedValues.Length - 1].bDefaultValue = true;
}

defaultproperties
{
    SupportedValues(0)=(ObjectValue="None",bFallThru=False,bDefaultValue=True)
    MetaClass="Core.Object"
    VariableLinks(0)=(ExpectedType="SeqVar_Object",LinkedVariables=(),LinkDesc="Object",LinkVar="None",PropertyName="None",bWriteable=False,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    ObjName="Switch Object"
}

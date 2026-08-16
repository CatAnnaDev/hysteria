class SeqCond_SwitchClass extends SeqCond_SwitchBase
    native
    placeable
    hidecategories(Object);

struct native SwitchClassInfo
{
    var() name ClassName;
    var() byte bFallThru;
};

var() array<SwitchClassInfo> ClassArray;

event RemoveValueEntry(int RemoveIndex)
{
    if (RemoveIndex >= 0 && RemoveIndex < ClassArray.Length)
    {
        ClassArray.Remove(RemoveIndex, 1);
    }
}

event InsertValueEntry(int InsertIndex)
{
    InsertIndex = Clamp(InsertIndex, 0, ClassArray.Length);
    ClassArray.Insert(InsertIndex, 1);
}

event bool IsFallThruEnabled(int ValueIndex)
{
    return ValueIndex >= 0 && ValueIndex < ClassArray.Length && ClassArray[ValueIndex].bFallThru != 0;
}

event VerifyDefaultCaseValue()
{
    VerifyDefaultCaseValue();
    ClassArray.Length = OutputLinks.Length;
    ClassArray[ClassArray.Length - 1].ClassName = 'Default';
    ClassArray[ClassArray.Length - 1].bFallThru = 0;
}

defaultproperties
{
    ClassArray(0)=(ClassName="Default",bFallThru=0)
    VariableLinks(0)=(ExpectedType="SeqVar_Object",LinkedVariables=(),LinkDesc="Object",LinkVar="None",PropertyName="None",bWriteable=False,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    ObjName="Switch Class"
}

class SeqAct_RangeSwitch extends SequenceAction
    native
    notplaceable
    deprecated
    hidecategories(Object);

struct native SwitchRange
{
    var() int Min;
    var() int Max;
};

var() editinline array<SwitchRange> Ranges;

defaultproperties
{
    VariableLinks(0)=(ExpectedType="SeqVar_Int",LinkedVariables=(),LinkDesc="Index",LinkVar="None",PropertyName="None",bWriteable=False,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    ObjName="Ranged"
    ObjCategory="Switch"
}

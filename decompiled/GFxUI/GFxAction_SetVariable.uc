class GFxAction_SetVariable extends SequenceAction
    native
    notplaceable
    hidecategories(Object);

var() GFxMovie Movie;
var() string Variable;

event bool IsValidLevelSequenceObject()
{
    return true;
}

defaultproperties
{
    VariableLinks(0)=(ExpectedType="Engine.SequenceVariable",LinkedVariables=(),LinkDesc="Value",LinkVar="None",PropertyName="None",bWriteable=True,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    ObjName="GFx SetVariable"
    ObjCategory="GFx"
}

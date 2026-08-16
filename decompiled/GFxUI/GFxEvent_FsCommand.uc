class GFxEvent_FsCommand extends SequenceEvent
    native
    notplaceable
    hidecategories(Object);

var() GFxMovie Movie;
var() string FSCommand;

defaultproperties
{
    MaxTriggerCount=0
    bPlayerOnly=False
    VariableLinks(0)=(ExpectedType="Engine.SeqVar_String",LinkedVariables=(),LinkDesc="Argument",LinkVar="None",PropertyName="None",bWriteable=True,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    ObjName="FsCommand"
    ObjCategory="GFx"
}

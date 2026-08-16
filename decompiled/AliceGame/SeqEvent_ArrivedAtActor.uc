class SeqEvent_ArrivedAtActor extends SequenceEvent
    native
    notplaceable
    hidecategories(Object);

var() Actor ArrivedTarget;

defaultproperties
{
    VariableLinks(0)=(ExpectedType="Engine.SeqVar_Object",LinkedVariables=(),LinkDesc="Instigator",LinkVar="None",PropertyName="None",bWriteable=True,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(1)=(ExpectedType="Engine.SeqVar_Object",LinkedVariables=(),LinkDesc="Arrived Target",LinkVar="None",PropertyName="ArrivedTarget",bWriteable=True,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    ObjName="Arrived At Actor"
    ObjCategory="AI"
}

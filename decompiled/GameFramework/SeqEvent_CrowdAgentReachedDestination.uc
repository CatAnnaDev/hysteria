class SeqEvent_CrowdAgentReachedDestination extends SequenceEvent
    native
    notplaceable
    hidecategories(Object);

defaultproperties
{
    MaxTriggerCount=0
    bPlayerOnly=False
    OutputLinks(0)=(Links=(),LinkDesc="Agent Reached Destination",bHasImpulse=False,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",ActivateDelay=0.0,DrawY=0,bHidden=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(0)=(ExpectedType="Engine.SeqVar_Object",LinkedVariables=(),LinkDesc="Agent",LinkVar="None",PropertyName="None",bWriteable=True,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    ObjName="Agent Reached"
    ObjCategory="Crowd"
}

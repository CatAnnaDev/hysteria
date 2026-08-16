class SeqAct_AttachToEvent extends SequenceAction
    native
    notplaceable
    hidecategories(Object);

var() bool bPreferController;

defaultproperties
{
    VariableLinks(0)=(ExpectedType="SeqVar_Object",LinkedVariables=(),LinkDesc="Attachee",LinkVar="None",PropertyName="None",bWriteable=False,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    EventLinks(0)=(ExpectedType="SequenceEvent",LinkedEvents=(),LinkDesc="Event",DrawX=0,bHidden=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    ObjName="Attach To Event"
    ObjCategory="Event"
}

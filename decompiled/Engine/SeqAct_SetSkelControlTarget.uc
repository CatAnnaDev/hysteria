class SeqAct_SetSkelControlTarget extends SequenceAction
    notplaceable
    hidecategories(Object);

var() name SkelControlName;
var() array<Object> TargetActors;

defaultproperties
{
    VariableLinks(0)=(ExpectedType="SeqVar_Object",LinkedVariables=(),LinkDesc="SkelMesh",LinkVar="None",PropertyName="Targets",bWriteable=False,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(1)=(ExpectedType="SeqVar_Object",LinkedVariables=(),LinkDesc="TargetActor",LinkVar="None",PropertyName="TargetActors",bWriteable=False,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    ObjName="Set SkelControl Target"
    ObjCategory="Actor"
}

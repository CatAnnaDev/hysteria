class SequenceAction extends SequenceOp
    abstract
    native
    notplaceable
    hidecategories(Object);

var name HandlerName;
var bool bCallHandler;
var() array<Object> Targets;

defaultproperties
{
    bCallHandler=True
    VariableLinks(0)=(ExpectedType="SeqVar_Object",LinkedVariables=(),LinkDesc="Target",LinkVar="None",PropertyName="Targets",bWriteable=False,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    ObjName="Unknown Action"
    ObjColor=(B=255,G=0,R=255,A=255)
}

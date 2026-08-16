class SeqAct_SetLocation extends SeqAct_SetSequenceVariable
    native
    notplaceable
    hidecategories(Object);

var() bool bSetLocation;
var() bool bSetRotation;
var() Vector LocationValue;
var() Rotator RotationValue;
var Object Target;

static event int GetObjClassVersion()
{
    return GetObjClassVersion() + 1;
}

defaultproperties
{
    bSetLocation=True
    bSetRotation=True
    VariableLinks(0)=(ExpectedType="SeqVar_Vector",LinkedVariables=(),LinkDesc="Location",LinkVar="None",PropertyName="None",bWriteable=False,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(1)=(ExpectedType="SeqVar_Vector",LinkedVariables=(),LinkDesc="Rotation",LinkVar="None",PropertyName="None",bWriteable=False,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(2)=(ExpectedType="SeqVar_Object",LinkedVariables=(),LinkDesc="Target",LinkVar="None",PropertyName="Target",bWriteable=True,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    ObjName="Set Actor Location"
    ObjCategory="Actor"
}

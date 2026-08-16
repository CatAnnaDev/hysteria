class SeqAct_SetMatInstVectorParam extends SequenceAction
    notplaceable
    deprecated
    hidecategories(Object);

var() MaterialInstanceConstant MatInst;
var() name ParamName;
var() LinearColor VectorValue;

static event int GetObjClassVersion()
{
    return GetObjClassVersion() + 2;
}

defaultproperties
{
    VectorValue=(R=0.0,G=0.0,B=0.0,A=1.0)
    VariableLinks(0)=(ExpectedType="SeqVar_Vector",LinkedVariables=(),LinkDesc="VectorValue",LinkVar="None",PropertyName="None",bWriteable=False,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    ObjName="Set VectorParam"
    ObjCategory="Material Instance"
}

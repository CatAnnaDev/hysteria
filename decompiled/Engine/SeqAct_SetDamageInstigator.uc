class SeqAct_SetDamageInstigator extends SequenceAction
    notplaceable
    hidecategories(Object);

var Actor DamageInstigator;

defaultproperties
{
    VariableLinks(0)=(ExpectedType="SeqVar_Object",LinkedVariables=(),LinkDesc="Target",LinkVar="None",PropertyName="Targets",bWriteable=False,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(1)=(ExpectedType="SeqVar_Object",LinkedVariables=(),LinkDesc="Damage Instigator",LinkVar="None",PropertyName="DamageInstigator",bWriteable=False,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=1,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    ObjName="Set Damage Instigator"
    ObjCategory="Actor"
}

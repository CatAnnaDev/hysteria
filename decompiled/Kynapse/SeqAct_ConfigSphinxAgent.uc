class SeqAct_ConfigSphinxAgent extends SequenceAction
    native
    notplaceable
    hidecategories(Object);

var transient array<Object> ConfigObjects;
var() bool bIsSleeping;
var() bool bIsIdle;
var() bool bIsWandering;
var() bool bIsFollowingPath;
var() bool bIsFighting;
var() bool bNotifyTeammateToFight;
var() bool bOverWritteSightDistance;
var() int AlternateWarningPackageIndex;
var() float OverWritteSightDistanceValue;

defaultproperties
{
    bIsWandering=True
    bNotifyTeammateToFight=True
    VariableLinks(0)=(ExpectedType="Engine.SeqVar_Object",LinkedVariables=(),LinkDesc="Target",LinkVar="None",PropertyName="Targets",bWriteable=False,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(1)=(ExpectedType="Engine.SeqVar_Object",LinkedVariables=(),LinkDesc="ConfigObject Target",LinkVar="None",PropertyName="None",bWriteable=False,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    ObjName="Config Sphinx Agent"
    ObjCategory="AI"
}

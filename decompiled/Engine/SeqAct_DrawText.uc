class SeqAct_DrawText extends SequenceAction
    native
    notplaceable
    hidecategories(Object);

var() float DisplayTimeSeconds;
var() bool bDisplayOnObject;
var() KismetDrawTextInfo DrawTextInfo;

static event int GetObjClassVersion()
{
    return GetObjClassVersion() + 1;
}

defaultproperties
{
    DisplayTimeSeconds=-1.0
    DrawTextInfo=(MessageText="",MessageFont="EngineFonts.SmallFont",MessageFontScale=(X=1.0,Y=1.0),MessageOffset=(X=0.0,Y=0.0),MessageColor=(B=255,G=255,R=255,A=255),MessageEndTime=-1.0)
    bLatentExecution=True
    bAutoActivateOutputLinks=False
    InputLinks(0)=(LinkDesc="Show",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    InputLinks(1)=(LinkDesc="Hide",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    VariableLinks(0)=(ExpectedType="SeqVar_Object",LinkedVariables=(),LinkDesc="Target",LinkVar="None",PropertyName="Targets",bWriteable=False,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(1)=(ExpectedType="SeqVar_String",LinkedVariables=(),LinkDesc="String",LinkVar="None",PropertyName="None",bWriteable=False,bModifiesLinkedObject=False,bHidden=True,MinVars=0,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    ObjName="Draw Text"
    ObjCategory="Misc"
}

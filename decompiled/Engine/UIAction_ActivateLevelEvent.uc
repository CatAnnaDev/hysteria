class UIAction_ActivateLevelEvent extends UIAction
    native
    placeable
    hidecategories(Object);

var() name EventName;

defaultproperties
{
    EventName="DefaultEvent"
    bAutoActivateOutputLinks=False
    OutputLinks(0)=(Links=(),LinkDesc="Failed",bHasImpulse=False,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",ActivateDelay=0.0,DrawY=0,bHidden=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    OutputLinks(1)=(Links=(),LinkDesc="Success",bHasImpulse=False,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",ActivateDelay=0.0,DrawY=0,bHidden=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(0)=(ExpectedType="SeqVar_Int",LinkedVariables=(),LinkDesc="Player Index",LinkVar="None",PropertyName="PlayerIndex",bWriteable=True,bModifiesLinkedObject=False,bHidden=True,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(1)=(ExpectedType="SeqVar_Int",LinkedVariables=(),LinkDesc="Gamepad Id",LinkVar="None",PropertyName="GamepadID",bWriteable=True,bModifiesLinkedObject=False,bHidden=True,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    ObjName="Activate Level Event"
    ObjCategory="Level"
}

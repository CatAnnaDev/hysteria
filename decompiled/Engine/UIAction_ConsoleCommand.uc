class UIAction_ConsoleCommand extends UIAction
    placeable
    hidecategories(Object);

var() string Command;

defaultproperties
{
    bAutoTargetOwner=True
    VariableLinks(0)=(ExpectedType="SeqVar_Object",LinkedVariables=(),LinkDesc="Target",LinkVar="None",PropertyName="Targets",bWriteable=False,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(1)=(ExpectedType="SeqVar_Int",LinkedVariables=(),LinkDesc="Player Index",LinkVar="None",PropertyName="PlayerIndex",bWriteable=True,bModifiesLinkedObject=False,bHidden=True,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(2)=(ExpectedType="SeqVar_Int",LinkedVariables=(),LinkDesc="Gamepad Id",LinkVar="None",PropertyName="GamepadID",bWriteable=True,bModifiesLinkedObject=False,bHidden=True,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(3)=(ExpectedType="SeqVar_String",LinkedVariables=(),LinkDesc="Command",LinkVar="None",PropertyName="Command",bWriteable=False,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    ObjName="Console Command"
    ObjCategory="Misc"
}

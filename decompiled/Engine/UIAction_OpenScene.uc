class UIAction_OpenScene extends UIAction_Scene
    native
    placeable
    hidecategories(Object);

var UIScene OpenedScene;
var() int DesiredPlayerIndex;

static event int GetObjClassVersion()
{
    return GetObjClassVersion() + 1;
}

defaultproperties
{
    DesiredPlayerIndex=-1
    VariableLinks(0)=(ExpectedType="SeqVar_Object",LinkedVariables=(),LinkDesc="Scene",LinkVar="None",PropertyName="Scene",bWriteable=False,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(1)=(ExpectedType="SeqVar_Int",LinkedVariables=(),LinkDesc="Player Index",LinkVar="None",PropertyName="PlayerIndex",bWriteable=True,bModifiesLinkedObject=False,bHidden=True,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(2)=(ExpectedType="SeqVar_Int",LinkedVariables=(),LinkDesc="Gamepad Id",LinkVar="None",PropertyName="GamepadID",bWriteable=True,bModifiesLinkedObject=False,bHidden=True,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(3)=(ExpectedType="SeqVar_Object",LinkedVariables=(),LinkDesc="Opened Scene",LinkVar="None",PropertyName="OpenedScene",bWriteable=True,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(4)=(ExpectedType="SeqVar_Int",LinkedVariables=(),LinkDesc="Player Index Override",LinkVar="None",PropertyName="DesiredPlayerIndex",bWriteable=False,bModifiesLinkedObject=False,bHidden=True,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    ObjName="Open Scene"
}

class UIEvent_SceneActivated extends UIEvent_Scene
    placeable
    hidecategories(Object);

var bool bInitialActivation;

static event int GetObjClassVersion()
{
    return GetObjClassVersion() + 1;
}

event Deactivated()
{
    local int I;
    local UIScene OwnerScene;
    
    Deactivated();
    OwnerScene = GetOwnerScene();
    if (OwnerScene == none || !OwnerScene.IsSceneActive())
    {
        for (I = 0; I < OutputLinks.Length; I++)
        {
            OutputLinks[I].bHasImpulse = false;
        }
        if (OwnerScene == none)
        {
            ScriptLog("Disabling" @ string(Class.Name) @ PathName(self) @ "because containing scene is None");
            LogInternal("Disabling" @ string(Class.Name) @ PathName(self) @ "because containing scene is None", 'DevUI');
        }
        else
        {
            ScriptLog("Disabling" @ string(Class.Name) @ PathName(self) @ "because containing scene" @ string(OwnerScene.SceneTag) @ "is no longer active");
            LogInternal("Disabling" @ string(Class.Name) @ PathName(self) @ "because containing scene" @ string(OwnerScene.SceneTag) @ "is no longer active", 'DevUI');
        }
    }
}

defaultproperties
{
    VariableLinks(0)=(ExpectedType="SeqVar_Object",LinkedVariables=(),LinkDesc="Activator",LinkVar="None",PropertyName="None",bWriteable=True,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(1)=(ExpectedType="SeqVar_Int",LinkedVariables=(),LinkDesc="Player Index",LinkVar="None",PropertyName="PlayerIndex",bWriteable=True,bModifiesLinkedObject=False,bHidden=True,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(2)=(ExpectedType="SeqVar_Int",LinkedVariables=(),LinkDesc="Gamepad Id",LinkVar="None",PropertyName="GamepadID",bWriteable=True,bModifiesLinkedObject=False,bHidden=True,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(3)=(ExpectedType="SeqVar_Bool",LinkedVariables=(),LinkDesc="Initial Activation",LinkVar="None",PropertyName="bInitialActivation",bWriteable=True,bModifiesLinkedObject=False,bHidden=True,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    ObjPosX=48
    ObjPosY=216
    ObjName="Scene Opened"
}

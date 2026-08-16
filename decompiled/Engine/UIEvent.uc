class UIEvent extends SequenceEvent
    abstract
    native
    placeable
    hidecategories(Object);

var const int SubobjectVersionModifier;
var UIScreenObject EventOwner;
var Object EventActivator;
var const localized string Description;
var bool bShouldRegisterEvent;
var bool bPropagateEvent;
var delegate<AllowEventActivation> __AllowEventActivation__Delegate;

static event int GetObjClassVersion()
{
    return GetObjClassVersion() + default.SubobjectVersionModifier + 2;
}

event bool ShouldAlwaysInstance()
{
    return false;
}

event bool IsValidUISequenceObject(optional UIScreenObject TargetObject)
{
    return true;
}

event bool IsValidLevelSequenceObject()
{
    return false;
}

native final function bool ActivateUIEvent(int ControllerIndex, UIScreenObject InEventOwner, optional Object InEventActivator, optional bool bActivateImmediately, optional out const array<int> IndicesToActivate)
{
    ControllerIndex;
    InEventOwner;
    InEventActivator;
    bActivateImmediately;
    IndicesToActivate;
}

native final function bool ConditionalActivateUIEvent(int ControllerIndex, UIScreenObject InEventOwner, optional Object InEventActivator, optional bool bActivateImmediately, optional out const array<int> IndicesToActivate)
{
    ControllerIndex;
    InEventOwner;
    InEventActivator;
    bActivateImmediately;
    IndicesToActivate;
}

native final function bool CanBeActivated(int ControllerIndex, UIScreenObject InEventOwner, optional Object InEventActivator, optional bool bActivateImmediately, optional out const array<int> IndicesToActivate)
{
    ControllerIndex;
    InEventOwner;
    InEventActivator;
    bActivateImmediately;
    IndicesToActivate;
}

native final function UIScene GetOwnerScene()
{
}

native final function UIScreenObject GetOwner()
{
}

delegate bool AllowEventActivation(int ControllerIndex, UIScreenObject InEventOwner, Object InEventActivator, bool bActivateImmediately, out const array<int> IndicesToActivate)
{
}

defaultproperties
{
    bShouldRegisterEvent=True
    bPropagateEvent=True
    MaxTriggerCount=0
    bClientSideOnly=True
    VariableLinks(0)=(ExpectedType="SeqVar_Object",LinkedVariables=(),LinkDesc="Activator",LinkVar="None",PropertyName="None",bWriteable=True,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(1)=(ExpectedType="SeqVar_Int",LinkedVariables=(),LinkDesc="Player Index",LinkVar="None",PropertyName="PlayerIndex",bWriteable=True,bModifiesLinkedObject=False,bHidden=True,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(2)=(ExpectedType="SeqVar_Int",LinkedVariables=(),LinkDesc="Gamepad Id",LinkVar="None",PropertyName="GamepadID",bWriteable=True,bModifiesLinkedObject=False,bHidden=True,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    ObjCategory="UI"
}

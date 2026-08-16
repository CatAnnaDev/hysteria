class SequenceEvent extends SequenceOp
    abstract
    native
    notplaceable
    hidecategories(Object);

var transient array<SequenceEvent> DuplicateEvts;
var Actor Originator;
var Actor Instigator;
var float ActivationTime;
var int TriggerCount;
var() int MaxTriggerCount;
var() float ReTriggerDelay;
var() bool bEnabled;
var() bool bPlayerOnly;
var transient bool bRegistered;
var() const bool bClientSideOnly;
var() byte Priority;
var int MaxWidth;

event Toggled()
{
}

function Reset()
{
    ActivationTime = 0.0;
    TriggerCount = 0;
    Instigator = none;
}

native final function bool CheckActivate(Actor InOriginator, Actor InInstigator, optional bool bTest, optional out const array<int> ActivateIndices, optional bool bPushTop)
{
    InOriginator;
    InInstigator;
    bTest;
    ActivateIndices;
    bPushTop;
}

event RegisterEvent()
{
}

defaultproperties
{
    MaxTriggerCount=1
    bEnabled=True
    bPlayerOnly=True
    bAutoActivateOutputLinks=False
    VariableLinks(0)=(ExpectedType="SeqVar_Object",LinkedVariables=(),LinkDesc="Instigator",LinkVar="None",PropertyName="None",bWriteable=True,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    ObjColor=(B=0,G=0,R=255,A=255)
}

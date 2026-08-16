class SequenceOp extends SequenceObject
    abstract
    native
    notplaceable
    hidecategories(Object);

struct native SeqEventLink
{
    var class<SequenceEvent> ExpectedType;
    var array<SequenceEvent> LinkedEvents;
    var string LinkDesc;
    var int DrawX;
    var bool bHidden;
    var transient editoronly bool bMoving;
    var editoronly bool bClampedMax;
    var editoronly bool bClampedMin;
    var editoronly int OverrideDelta;
};

struct native SeqVarLink
{
    var class<SequenceVariable> ExpectedType;
    var array<SequenceVariable> LinkedVariables;
    var string LinkDesc;
    var name LinkVar;
    var name PropertyName;
    var bool bWriteable;
    var bool bModifiesLinkedObject;
    var bool bHidden;
    var int MinVars;
    var int MaxVars;
    var int DrawX;
    var const transient Property CachedProperty;
    var bool bAllowAnyType;
    var transient editoronly bool bMoving;
    var editoronly bool bClampedMax;
    var editoronly bool bClampedMin;
    var editoronly int OverrideDelta;
};

struct native SeqOpOutputLink
{
    var array<SeqOpOutputInputLink> Links;
    var string LinkDesc;
    var bool bHasImpulse;
    var bool bDisabled;
    var bool bDisabledPIE;
    var bool bDisabledPIG;
    var SequenceOp LinkedOp;
    var float ActivateDelay;
    var int DrawY;
    var bool bHidden;
    var transient editoronly bool bMoving;
    var editoronly bool bClampedMax;
    var editoronly bool bClampedMin;
    var editoronly int OverrideDelta;
};

struct native SeqOpOutputInputLink
{
    var SequenceOp LinkedOp;
    var int InputLinkIdx;
};

struct native SeqOpInputLink
{
    var string LinkDesc;
    var bool bHasImpulse;
    var int QueuedActivations;
    var bool bDisabled;
    var bool bDisabledPIE;
    var bool bDisabledPIG;
    var SequenceOp LinkedOp;
    var int DrawY;
    var bool bHidden;
    var float ActivateDelay;
};

var bool bActive;
var const bool bLatentExecution;
var bool bAutoActivateOutputLinks;
var transient editoronly bool bHaveMovingVarConnector;
var transient editoronly bool bHaveMovingOutputConnector;
var transient editoronly bool bPendingVarConnectorRecalc;
var transient editoronly bool bPendingOutputConnectorRecalc;
var array<SeqOpInputLink> InputLinks;
var array<SeqOpOutputLink> OutputLinks;
var array<SeqVarLink> VariableLinks;
var array<SeqEventLink> EventLinks;
var transient int PlayerIndex;
var transient byte GamepadID;
var transient int ActivateCount;
var const transient duplicatetransient int SearchTag;

native final function ForceActivateInput(int InputIdx)
{
    InputIdx;
}

function Controller GetController(Actor TheActor)
{
    local Pawn P;
    local Controller C;
    
    C = Controller(TheActor);
    if (C != none)
    {
        return C;
    }
    else
    {
        P = Pawn(TheActor);
        return P != none ? P.Controller : none;
    }
}

function Pawn GetPawn(Actor TheActor)
{
    local Pawn P;
    local Controller C;
    
    P = Pawn(TheActor);
    if (P != none)
    {
        return P;
    }
    else
    {
        C = Controller(TheActor);
        return C != none ? C.Pawn : none;
    }
}

function Reset()
{
}

native final function PublishLinkedVariableValues()
{
}

native final function PopulateLinkedVariableValues()
{
}

event VersionUpdated(int OldVersion, int NewVersion)
{
}

event Deactivated()
{
}

event Activated()
{
}

native final function bool ActivateNamedOutputLink(string LinkDesc)
{
    LinkDesc;
}

native final function bool ActivateOutputLink(int OutputIdx)
{
    OutputIdx;
}

native final iterator function LinkedVariables(class<SequenceVariable> VarClass, out SequenceVariable OutVariable, optional string inDesc)
{
    VarClass;
    OutVariable;
    inDesc;
}

native final function GetBoolVars(out array<byte> boolVars, optional string inDesc)
{
    boolVars;
    inDesc;
}

native final function GetInterpDataVars(out array<InterpData> outIData, optional string inDesc)
{
    outIData;
    inDesc;
}

native final function GetObjectVars(out array<Object> objVars, optional string inDesc)
{
    objVars;
    inDesc;
}

native final function GetLinkedObjects(out array<SequenceObject> out_Objects, optional class<SequenceObject> ObjectType, optional bool bRecurse)
{
    out_Objects;
    ObjectType;
    bRecurse;
}

native final function bool HasLinkedOps(optional bool bConsiderInputLinks)
{
    bConsiderInputLinks;
}

defaultproperties
{
    bAutoActivateOutputLinks=True
    bPendingVarConnectorRecalc=True
    bPendingOutputConnectorRecalc=True
    InputLinks(0)=(LinkDesc="In",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    OutputLinks(0)=(Links=(),LinkDesc="Out",bHasImpulse=False,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",ActivateDelay=0.0,DrawY=0,bHidden=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    PlayerIndex=-1
    GamepadID=255
}

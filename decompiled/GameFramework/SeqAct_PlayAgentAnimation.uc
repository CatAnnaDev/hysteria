class SeqAct_PlayAgentAnimation extends SeqAct_Latent
    native
    notplaceable
    hidecategories(Object);

var() array<name> AnimationList;
var() float BlendInTime;
var() float BlendOutTime;
var() bool bUseRootMotion;
var() bool bFaceActionTargetFirst;
var() bool bLooping;
var() bool bBlendBetweenAnims;
var() int LoopIndex;
var() float LoopTime;
var Actor ActionTarget;

function SetCurrentAnimationActionFor(GameCrowdAgentSkeletal Agent)
{
    local GameCrowdBehavior_PlayAnimation AnimBehavior;
    local int I;
    
    AnimBehavior = new(Agent) class'GameCrowdBehavior_PlayAnimation';
    AnimBehavior.AnimSequence = self;
    AnimBehavior.BlendInTime = BlendInTime;
    AnimBehavior.BlendOutTime = BlendOutTime;
    AnimBehavior.bUseRootMotion = bUseRootMotion;
    AnimBehavior.bFaceActionTargetFirst = bFaceActionTargetFirst;
    AnimBehavior.bLooping = bLooping;
    AnimBehavior.LoopIndex = LoopIndex;
    AnimBehavior.LoopTime = LoopTime;
    AnimBehavior.bBlendBetweenAnims = bBlendBetweenAnims;
    AnimBehavior.CustomActionTarget = ActionTarget;
    for (I = 0; I < AnimationList.Length; I++)
    {
        AnimBehavior.AnimationList[I] = AnimationList[I];
    }
    Agent.ActivateInstancedBehavior(AnimBehavior);
}

static event int GetObjClassVersion()
{
    return GetObjClassVersion() + 1;
}

defaultproperties
{
    BlendInTime=0.2
    BlendOutTime=0.2
    LoopTime=-1.0
    bAutoActivateOutputLinks=False
    InputLinks(0)=(LinkDesc="Play",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    InputLinks(1)=(LinkDesc="Stop",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    OutputLinks(0)=(Links=(),LinkDesc="Finished",bHasImpulse=False,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",ActivateDelay=0.0,DrawY=0,bHidden=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    OutputLinks(1)=(Links=(),LinkDesc="Stopped",bHasImpulse=False,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",ActivateDelay=0.0,DrawY=0,bHidden=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    OutputLinks(2)=(Links=(),LinkDesc="Started",bHasImpulse=False,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",ActivateDelay=0.0,DrawY=0,bHidden=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(0)=(ExpectedType="Engine.SeqVar_Object",LinkedVariables=(),LinkDesc="Target",LinkVar="None",PropertyName="Targets",bWriteable=False,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(1)=(ExpectedType="Engine.SeqVar_Object",LinkedVariables=(),LinkDesc="Action Focus",LinkVar="None",PropertyName="ActionTarget",bWriteable=False,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(2)=(ExpectedType="Engine.SeqVar_Object",LinkedVariables=(),LinkDesc="Out Agent",LinkVar="None",PropertyName="None",bWriteable=True,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    ObjName="Play Agent Animation"
    ObjCategory="Crowd"
}

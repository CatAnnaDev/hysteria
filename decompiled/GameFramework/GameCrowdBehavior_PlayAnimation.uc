class GameCrowdBehavior_PlayAnimation extends GameCrowdAgentBehavior
    native
    placeable;

var() array<name> AnimationList;
var() float BlendInTime;
var() float BlendOutTime;
var() bool bUseRootMotion;
var() bool bLookAtPlayer;
var() bool bLooping;
var() bool bBlendBetweenAnims;
var Actor CustomActionTarget;
var() int LoopIndex;
var() float LoopTime;
var SeqAct_PlayAgentAnimation AnimSequence;
var int AnimationIndex;

function string GetBehaviorString()
{
    local string BehaviorString;
    
    BehaviorString = "Behavior: " $ string(self);
    if (bFaceActionTargetFirst)
    {
        BehaviorString = BehaviorString @ "Turning toward " $ string(ActionTarget);
    }
    else if (AnimationList.Length <= AnimationIndex || AnimationList[AnimationIndex] == 'None')
    {
        BehaviorString = BehaviorString @ "MISSING ANIMATION";
    }
    else
    {
        BehaviorString = BehaviorString @ "Playing " $ string(AnimationList[AnimationIndex]);
    }
    return BehaviorString;
}

function StopBehavior()
{
    GameCrowdAgentSkeletal(MyAgent).FullBodySlot.StopCustomAnim(BlendOutTime);
    GameCrowdAgentSkeletal(MyAgent).SetRootMotion(false);
    StopBehavior();
}

function PlayAgentAnimationNow()
{
    local float CurrentBlendInTime, CurrentBlendOutTime;
    local GameCrowdAgentSkeletal MySkAgent;
    
    MySkAgent = GameCrowdAgentSkeletal(MyAgent);
    bFaceActionTargetFirst = false;
    MySkAgent.SetRootMotion(bUseRootMotion);
    CurrentBlendInTime = 0.0;
    CurrentBlendOutTime = 0.0;
    if (bLooping && AnimationIndex == LoopIndex)
    {
        if (bBlendBetweenAnims || AnimationIndex == 0)
        {
            CurrentBlendInTime = BlendInTime;
        }
        MySkAgent.FullBodySlot.PlayCustomAnim(AnimationList[AnimationIndex], 1.0, CurrentBlendInTime, CurrentBlendOutTime, bLooping, true);
        if (LoopTime > 0.0)
        {
            MySkAgent.SetTimer(LoopTime, false, 'OnAnimEnd');
        }
    }
    else
    {
        if (bBlendBetweenAnims)
        {
            CurrentBlendInTime = BlendInTime;
            CurrentBlendOutTime = BlendOutTime;
        }
        else if (AnimationIndex == 0)
        {
            CurrentBlendInTime = BlendInTime;
        }
        MySkAgent.FullBodySlot.PlayCustomAnim(AnimationList[AnimationIndex], 1.0, CurrentBlendInTime, CurrentBlendOutTime, false, true);
        MySkAgent.FullBodySlot.SetActorAnimEndNotification(true);
    }
    if (AnimSequence != none)
    {
        AnimSequence.ActivateOutputLink(2);
    }
}

event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
    AnimationIndex++;
    if (AnimationList.Length > AnimationIndex)
    {
        PlayAgentAnimationNow();
    }
    else
    {
        if (AnimSequence != none && AnimSequence.OutputLinks[0].Links.Length > 0)
        {
            SetSequenceOutput();
            MyAgent.ClearLatentAction(class'SeqAct_PlayAgentAnimation', false);
            AnimSequence.ActivateOutputLink(0);
        }
        MyAgent.StopBehavior();
    }
}

native function SetSequenceOutput()
{
}

event FinishedTargetRotation()
{
    PlayAgentAnimationNow();
}

function InitBehavior(GameCrowdAgent Agent)
{
    local PlayerController PC, ClosestPC;
    local float ClosestDist, newdist;
    local GameCrowdAgentSkeletal SkAgent;
    
    InitBehavior(Agent);
    if (CustomActionTarget != none)
    {
        ActionTarget = CustomActionTarget;
    }
    else if (bLookAtPlayer)
    {
        ClosestDist = 1000000.0;
        foreach Agent.LocalPlayerControllers(class'Engine.PlayerController', PC)
        {
            if (PC.Pawn != none)
            {
                newdist = VSize(PC.Pawn.Location - Agent.Location);
                if (newdist < ClosestDist)
                {
                    ClosestDist = newdist;
                    ClosestPC = PC;
                }
            }
        }
        if (ClosestPC != none)
        {
            ActionTarget = ClosestPC.Pawn;
        }
    }
    SkAgent = GameCrowdAgentSkeletal(Agent);
    if (SkAgent == none)
    {
        WarnInternal("PlayAnimation behavior " $ string(self) $ " called on non-skeletal agent " $ string(Agent));
        return;
    }
    AnimationIndex = 0;
    if (!bFaceActionTargetFirst)
    {
        PlayAgentAnimationNow();
    }
}

defaultproperties
{
    BlendInTime=0.2
    BlendOutTime=0.2
    LoopTime=-1.0
    bIdleBehavior=True
}

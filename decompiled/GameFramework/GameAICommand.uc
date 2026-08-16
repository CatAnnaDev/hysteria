class GameAICommand extends Object
    abstract
    native
    notplaceable
    within GameAIController;

var const transient GameAICommand ChildCommand;
var const transient name ChildStatus;
var transient GameAIController GameAIOwner;
var transient name Status;
var bool bAllowNewSameClassInstance;
var bool bReplaceActiveSameClassInstance;
var transient bool bAborted;
var bool bIgnoreNotifies;
var transient bool bPendingPop;

function GetDebugOverheadText(PlayerController PC, out array<string> OutText)
{
}

event DrawDebug(HUD H, name Category)
{
}

event string GetDumpString()
{
    return string(self);
}

function Resumed(name OldCommandName)
{
    Outer.AILog_Internal("COMMAND RESUMED:" @ string(self) @ "from" @ string(OldCommandName) @ "with" @ string(ChildStatus));
}

function Paused(GameAICommand NewCommand)
{
    Outer.AILog_Internal("COMMAND PAUSED:" @ string(self) @ "by" @ string(NewCommand));
}

function Popped()
{
    Outer.AILog_Internal("COMMAND POPPED:" @ string(self) @ "with" @ string(Status));
}

function Pushed()
{
    Outer.AILog_Internal("COMMAND PUSHED:" @ string(self));
}

function PostPopped()
{
}

function PrePushed(GameAIController AI)
{
}

function bool AllowStateTransitionTo(name StateName)
{
    return ChildCommand == none || ChildCommand.AllowStateTransitionTo(StateName);
}

function bool AllowTransitionTo(class<GameAICommand> AttemptCommand)
{
    return ChildCommand == none || ChildCommand.AllowTransitionTo(AttemptCommand);
}

function Tick(float DeltaTime)
{
}

native final function bool ShouldIgnoreNotifies()
{
}

final event InternalTick(float DeltaTime)
{
    Tick(DeltaTime);
}

final event InternalResumed(name OldCommandName)
{
    Resumed(OldCommandName);
}

final event InternalPaused(GameAICommand NewCommand)
{
    Paused(NewCommand);
}

event InternalPopped()
{
    Popped();
    GameAIOwner = none;
    PostPopped();
}

final event InternalPushed()
{
    GotoState('Auto');
    Pushed();
}

final event InternalPrePushed(GameAIController AI)
{
    GameAIOwner = AI;
    PrePushed(AI);
}

static function bool InitCommand(GameAIController AI)
{
    local GameAICommand Cmd;
    
    if (AI != none)
    {
        Cmd = new(AI) default.Class;
        if (Cmd != none)
        {
            AI.PushCommand(Cmd);
            return true;
        }
    }
    return false;
}

static function bool InitCommandUserActor(GameAIController AI, Actor UserActor)
{
    return InitCommand(AI);
}

state DelaySuccess extends DebugState
{
    Begin:
    Outer.Sleep(0.1);
    Status = 'Success';
    Outer.PopCommand(self);
    Stop;
}

state DelayFailure extends DebugState
{
    Begin:
    Outer.Sleep(0.5);
    Status = 'Failure';
    Outer.PopCommand(self);
    Stop;
}

state DebugState
{
    function PausedState()
    {
        Outer.AILog_Internal("PAUSED", 'State');
    }
    
    function ContinuedState()
    {
        Outer.AILog_Internal("CONTINUED", 'State');
    }
    
    function PoppedState()
    {
        Outer.AILog_Internal("POPPED", 'State');
    }
    
    function PushedState()
    {
        Outer.AILog_Internal("PUSHED", 'State');
    }
    
    function EndState(name NextStateName)
    {
        Outer.AILog_Internal("ENDSTATE" @ string(NextStateName), 'State');
    }
    
    function BeginState(name PreviousStateName)
    {
        Outer.AILog_Internal("BEGINSTATE" @ string(PreviousStateName), 'State');
    }
    
    Stop;
}

defaultproperties
{
}

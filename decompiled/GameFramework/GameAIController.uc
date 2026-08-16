class GameAIController extends AIController
    abstract
    native
    notplaceable
    config(Game)
    hidecategories(Navigation);

var const transient GameAICommand CommandList;
var transient bool bHasRunawayCommandList;
var(Debug) config bool bAILogging;
var(Debug) config bool bAILogToWindow;
var(Debug) config bool bFlushAILogEachLine;
var(Debug) config bool bMapBasedLogName;
var(Debug) config bool bAIDrawDebug;
var transient bool bAIBroken;
var transient FileLog AILogFile;
var(Debug) config array<name> AILogFilter;
var repretry string DemoActionString;

replication
{
    if (bDemoRecording)
        DemoActionString;
}

final simulated event string GetActionString()
{
    local string ActionStr;
    local GameAICommand ActiveCmd;
    
    if (WorldInfo.IsPlayingDemo())
    {
        return DemoActionString;
    }
    else
    {
        ActiveCmd = GetActiveCommand();
        if (ActiveCmd != none)
        {
            ActionStr = string(ActiveCmd.Class) $ ":" $ string(ActiveCmd.GetStateName());
        }
        else
        {
            ActionStr = string(default.Class) $ ":" $ string(GetStateName());
        }
        return ActionStr;
    }
}

event bool GeneratePathToLocation(Vector Goal, optional float WithinDistance, optional bool bAllowPartialPath)
{
}

event bool GeneratePathToActor(Actor Goal, optional float WithinDistance, optional bool bAllowPartialPath)
{
}

function SetDesiredRotation(Rotator TargetDesiredRotation, optional bool InLockDesiredRotation = false, optional bool InUnlockWhenReached = false, optional float InterpolationTime = -1.0)
{
    if (Pawn != none)
    {
        Pawn.SetDesiredRotation(TargetDesiredRotation, InLockDesiredRotation, InUnlockWhenReached, InterpolationTime);
    }
}

event AILog_Internal(coerce string LogText, optional name LogCategory, optional bool bForce)
{
    local int Idx;
    local string ActionStr, FinalStr, Filename;
    local GameAICommand ActiveCommand;
    
    if (!bForce && !bAILogging)
    {
        return;
    }
    if (WorldInfo.IsConsoleBuild(2))
    {
        return;
    }
    if (!bForce)
    {
        for (Idx = 0; Idx < AILogFilter.Length; Idx++)
        {
            if (AILogFilter[Idx] == LogCategory)
            {
                return;
            }
        }
    }
    if (AILogFile == none)
    {
        AILogFile = Spawn(class'Engine.FileLog');
        if (bMapBasedLogName)
        {
            Filename = WorldInfo.GetMapName() $ "_" $ string(self);
            Filename = Repl(Filename, "ai_", "", false);
        }
        else
        {
            Filename = string(self);
        }
        if (Len(Filename) > 42)
        {
            Filename = Right(Filename, 42);
        }
        AILogFile.bKillDuringLevelTransition = true;
        AILogFile.bFlushEachWrite = bFlushAILogEachLine;
        AILogFile.bWantsAsyncWrites = !bFlushAILogEachLine;
        AILogFile.OpenLog(Filename, ".ailog");
    }
    ActionStr = string(GetStateName());
    ActiveCommand = GetActiveCommand();
    if (ActiveCommand != none)
    {
        ActionStr = string(ActiveCommand.Class) $ ":" $ string(ActiveCommand.GetStateName());
    }
    FinalStr = "[" $ string(WorldInfo.TimeSeconds) $ "]" @ ActionStr $ ":" @ LogText;
    AILogFile.Logf(FinalStr);
    if (WorldInfo.IsRecordingDemo())
    {
        RecordDemoAILog(FinalStr);
    }
    if (bAILogToWindow)
    {
        LogInternal(string(Pawn) @ "[" $ string(WorldInfo.TimeSeconds) $ "]" @ ActionStr $ ":" @ LogText);
    }
}

protected function RecordDemoAILog(coerce string LogText)
{
}

event Destroyed()
{
    Destroyed();
    if (AILogFile != none)
    {
        AILogFile.Destroy();
    }
    if (CommandList != none)
    {
        AbortCommand(CommandList);
    }
}

native function GameAICommand GetAICommandInStack(const class<GameAICommand> InClass)
{
    InClass;
}

native final function GameAICommand FindCommandOfClass(class<GameAICommand> SearchClass)
{
    SearchClass;
}

native final function DumpCommandStack()
{
}

native final function CheckCommandCount()
{
}

native final function GameAICommand GetActiveCommand()
{
}

native final function bool AbortCommand(GameAICommand AbortCmd, optional class<GameAICommand> AbortClass)
{
    AbortCmd;
    AbortClass;
}

native final function PopCommand(GameAICommand ToBePoppedCommand)
{
    ToBePoppedCommand;
}

native final function PushCommand(GameAICommand NewCommand)
{
    NewCommand;
}

state DebugState
{
    function PausedState()
    {
        AILog_Internal("PAUSED", 'State');
    }
    
    function ContinuedState()
    {
        AILog_Internal("CONTINUED", 'State');
    }
    
    function PoppedState()
    {
        AILog_Internal("POPPED", 'State');
    }
    
    function PushedState()
    {
        AILog_Internal("PUSHED", 'State');
    }
    
    function EndState(name NextStateName)
    {
        AILog_Internal("ENDSTATE" @ string(NextStateName), 'State');
    }
    
    function BeginState(name PreviousStateName)
    {
        AILog_Internal("BEGINSTATE" @ string(PreviousStateName), 'State');
    }
    
    Stop;
}

defaultproperties
{
}

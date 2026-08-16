class AutoTestManager extends Info
    native
    notplaceable
    config(Game)
    hidecategories(Navigation,Movement,Collision);

var bool bAutomatedPerfTesting;
var bool bAutoContinueToNextRound;
var bool bUsingAutomatedTestingMapList;
var bool bAutomatedTestingWithOpen;
var bool bCheckingForFragmentation;
var bool bCheckingForMemLeaks;
var bool bDoingASentinelRun;
var transient bool bSentinelStreamingLevelStillLoading;
var int AutomatedPerfRemainingTime;
var int AutomatedTestingMapIndex;
var globalconfig array<string> AutomatedMapTestingList;
var globalconfig int NumAutomatedMapTestingCycles;
var int NumberOfMatchesPlayed;
var int NumMapListCyclesDone;
var string AutomatedTestingExecCommandToRunAtStartMatch;
var string AutomatedMapTestingTransitionMap;
var string SentinelTaskDescription;
var string SentinelTaskParameter;
var string SentinelTagDesc;
var transient PlayerController SentinelPC;
var transient array<Vector> SentinelTravelArray;
var transient int SentinelNavigationIdx;
var transient int SentinelIdx;
var transient int NumRotationsIncrement;
var transient int TravelPointsIncrement;
var config int NumMinutesPerMap;
var config array<string> CommandsToRunAtEachTravelTheWorldNode;
var transient string CommandStringToExec;

function bool CheckForSentinelRun()
{
    if (bDoingASentinelRun)
    {
        LogInternal("DoingASentinelRun! task " $ SentinelTaskDescription);
        if (SentinelTaskDescription ~= "TravelTheWorld")
        {
            WorldInfo.Game.DoTravelTheWorld();
            return true;
        }
        else
        {
            BeginSentinelRun(SentinelTaskDescription, SentinelTaskParameter, SentinelTagDesc);
            SetTimer(3.0, true, 'DoTimeBasedSentinelStatGathering');
        }
    }
    return false;
}

function StartMatch()
{
    local PlayerController PC;
    
    if (bAutomatedTestingWithOpen)
    {
        IncrementNumberOfMatchesPlayed();
    }
    else
    {
        foreach WorldInfo.AllControllers(class'PlayerController', PC)
        {
            PC.IncrementNumberOfMatchesPlayed();
            break;
        }
    }
    IncrementAutomatedTestingMapIndex();
    if (bCheckingForFragmentation)
    {
        ConsoleCommand("MemFragCheck");
    }
    if (AutomatedTestingExecCommandToRunAtStartMatch != "")
    {
        LogInternal("AutomatedTestingExecCommandToRunAtStartMatch: " $ AutomatedTestingExecCommandToRunAtStartMatch);
        ConsoleCommand(AutomatedTestingExecCommandToRunAtStartMatch);
    }
}

function string GetNextAutomatedTestingMap()
{
    local string MapName;
    local PlayerController PC;
    local bool bResetMapIndex;
    
    if (bUsingAutomatedTestingMapList)
    {
        if (AutomatedTestingMapIndex >= 0 && Len(AutomatedMapTestingTransitionMap) > 0)
        {
            AutomatedTestingMapIndex++;
            AutomatedTestingMapIndex *= float(-1);
            MapName = AutomatedMapTestingTransitionMap;
        }
        else
        {
            if (Len(AutomatedMapTestingTransitionMap) > 0)
            {
                AutomatedTestingMapIndex *= float(-1);
            }
            if (++AutomatedTestingMapIndex >= AutomatedMapTestingList.Length)
            {
                AutomatedTestingMapIndex = 0;
                NumMapListCyclesDone++;
                bResetMapIndex = true;
            }
            MapName = AutomatedMapTestingList[AutomatedTestingMapIndex];
        }
        if (bAutomatedTestingWithOpen == true)
        {
            if (NumMapListCyclesDone >= NumAutomatedMapTestingCycles && NumAutomatedMapTestingCycles != 0)
            {
                if (bCheckingForMemLeaks)
                {
                    ConsoleCommand("DEFERRED_STOPMEMTRACKING_AND_DUMP");
                }
            }
        }
        else
        {
            foreach WorldInfo.AllControllers(class'PlayerController', PC)
            {
                if (bResetMapIndex)
                {
                    PC.PlayerReplicationInfo.AutomatedTestingData.NumMapListCyclesDone++;
                }
                if (PC.PlayerReplicationInfo.AutomatedTestingData.NumMapListCyclesDone >= NumAutomatedMapTestingCycles && NumAutomatedMapTestingCycles != 0)
                {
                    if (bCheckingForMemLeaks)
                    {
                        ConsoleCommand("DEFERRED_STOPMEMTRACKING_AND_DUMP");
                    }
                }
            }
        }
        LogInternal("NextAutomatedTestingMap: " $ MapName);
        return MapName;
    }
    return "";
}

function IncrementNumberOfMatchesPlayed()
{
    LogInternal("  Num Matches Played: " $ string(NumberOfMatchesPlayed));
    NumberOfMatchesPlayed++;
}

function IncrementAutomatedTestingMapIndex()
{
    if (bUsingAutomatedTestingMapList == true)
    {
        if (bAutomatedTestingWithOpen == true)
        {
            LogInternal("  NumMapListCyclesDone: " $ string(NumMapListCyclesDone) $ " / " $ string(NumAutomatedMapTestingCycles));
        }
        else if (AutomatedTestingMapIndex >= 0)
        {
            AutomatedTestingMapIndex++;
        }
        LogInternal("  NextIncrementAutomatedTestingMapIndex: " $ string(AutomatedTestingMapIndex) $ " / " $ string(AutomatedMapTestingList.Length));
    }
}

function CloseAutomatedMapTestTimer()
{
    if (Len(AutomatedMapTestingTransitionMap) > 0)
    {
        if (AutomatedTestingMapIndex < 0)
        {
            WorldInfo.Game.RestartGame();
        }
    }
    else
    {
        WorldInfo.Game.RestartGame();
    }
}

function StartAutomatedMapTestTimerWorker()
{
    local int LevelIdx;
    
    if (WorldInfo != none)
    {
        for (LevelIdx = 0; LevelIdx < WorldInfo.StreamingLevels.Length; ++LevelIdx)
        {
            if (WorldInfo.StreamingLevels[LevelIdx].bHasLoadRequestPending == true)
            {
                LogInternal("levels not streamed in yet sleeping 5s");
                return;
            }
        }
        if (bCheckingForMemLeaks)
        {
            if (Len(AutomatedMapTestingTransitionMap) > 0)
            {
                if (AutomatedTestingMapIndex < 0)
                {
                    WorldInfo.DoMemoryTracking();
                }
            }
            else
            {
                WorldInfo.DoMemoryTracking();
            }
        }
    }
    ClearTimer('StartAutomatedMapTestTimerWorker');
    SetTimer(15.0, false, 'CloseAutomatedMapTestTimer');
}

event StartAutomatedMapTestTimer()
{
    SetTimer(5.0, true, 'StartAutomatedMapTestTimerWorker');
}

function DoTimeBasedSentinelStatGathering()
{
    local PlayerController PC;
    local Vector ViewLocation;
    local Rotator ViewRotation;
    
    foreach LocalPlayerControllers(class'PlayerController', PC)
    {
        break;
    }
    PC.GetPlayerViewPoint(ViewLocation, ViewRotation);
    if (SentinelTaskDescription != "FlyThrough" && SentinelTaskDescription != "FlyThroughSplitScreen")
    {
        if (PC.Pawn != none)
        {
            ViewLocation = PC.Pawn.Location;
        }
    }
    AddSentinelPerTimePeriodStats(ViewLocation, ViewRotation);
}

native function DoSentinel_ViewDependentMemoryAtSpecificLocation(out const Vector InLocation, out const Rotator InRotation)
{
    InLocation;
    InRotation;
}

native function DoSentinel_PerfAtSpecificLocation(out const Vector InLocation, out const Rotator InRotation)
{
    InLocation;
    InRotation;
}

native function DoSentinel_MemoryAtSpecificLocation(const Vector InLocation, const Rotator InRotation)
{
    InLocation;
    InRotation;
}

native function GetTravelLocations(name LevelName, PlayerController PC, out array<Vector> TravelPoints)
{
    LevelName;
    PC;
    TravelPoints;
}

native function HandlePerLoadedMapAudioStats()
{
}

native function DoSentinelActionPerLoadedMap()
{
}

function DoTravelTheWorld()
{
    GotoState('TravelTheWorld');
}

native function EndSentinelRun(EAutomatedRunResult RunResult)
{
    RunResult;
}

native function AddSentinelPerTimePeriodStats(const Vector InLocation, const Rotator InRotation)
{
    InLocation;
    InRotation;
}

native function BeginSentinelRun(const string TaskDescription, const string TaskParameter, const string TagDesc)
{
    TaskDescription;
    TaskParameter;
    TagDesc;
}

function InitializeOptions(string Options)
{
    local string InOpt;
    
    AutomatedPerfRemainingTime = 60 * WorldInfo.Game.TimeLimit;
    bAutomatedPerfTesting = WorldInfo.Game.ParseOption(Options, "AutomatedPerfTesting") ~= "1" || WorldInfo.Game.ParseOption(Options, "gAPT") ~= "1";
    bCheckingForFragmentation = WorldInfo.Game.ParseOption(Options, "CheckingForFragmentation") ~= "1" || WorldInfo.Game.ParseOption(Options, "gCFF") ~= "1";
    bCheckingForMemLeaks = WorldInfo.Game.ParseOption(Options, "CheckingForMemLeaks") ~= "1" || WorldInfo.Game.ParseOption(Options, "gCFML") ~= "1";
    bDoingASentinelRun = WorldInfo.Game.ParseOption(Options, "DoingASentinelRun") ~= "1" || WorldInfo.Game.ParseOption(Options, "gDASR") ~= "1";
    SentinelTaskDescription = WorldInfo.Game.ParseOption(Options, "SentinelTaskDescription");
    if (SentinelTaskDescription == "")
    {
        SentinelTaskDescription = WorldInfo.Game.ParseOption(Options, "gSTD");
    }
    SentinelTaskParameter = WorldInfo.Game.ParseOption(Options, "SentinelTaskParameter");
    if (SentinelTaskParameter == "")
    {
        SentinelTaskParameter = WorldInfo.Game.ParseOption(Options, "gSTP");
    }
    SentinelTagDesc = WorldInfo.Game.ParseOption(Options, "SentinelTagDesc");
    if (SentinelTagDesc == "")
    {
        SentinelTagDesc = WorldInfo.Game.ParseOption(Options, "gSTDD");
    }
    InOpt = WorldInfo.Game.ParseOption(Options, "AutoContinueToNextRound");
    if (InOpt != "")
    {
        LogInternal("AutoContinueToNextRound: " $ string(bool(InOpt)));
        bAutoContinueToNextRound = bool(InOpt);
    }
    InOpt = WorldInfo.Game.ParseOption(Options, "bUsingAutomatedTestingMapList");
    if (InOpt != "")
    {
        LogInternal("bUsingAutomatedTestingMapList: " $ string(bool(InOpt)));
        bUsingAutomatedTestingMapList = bool(InOpt);
    }
    if (bUsingAutomatedTestingMapList)
    {
        if (AutomatedMapTestingList.Length == 0)
        {
            LogInternal("*** No maps in automated test map list... Disabling bUsingAutomatedTestingMapList");
            bUsingAutomatedTestingMapList = false;
        }
    }
    InOpt = WorldInfo.Game.ParseOption(Options, "bAutomatedTestingWithOpen");
    if (InOpt != "")
    {
        LogInternal("bAutomatedTestingWithOpen: " $ string(bool(InOpt)));
        bAutomatedTestingWithOpen = bool(InOpt);
    }
    AutomatedTestingExecCommandToRunAtStartMatch = WorldInfo.Game.ParseOption(Options, "AutomatedTestingExecCommandToRunAtStartMatch");
    LogInternal("AutomatedTestingExecCommandToRunAtStartMatch: " $ AutomatedTestingExecCommandToRunAtStartMatch);
    AutomatedMapTestingTransitionMap = WorldInfo.Game.ParseOption(Options, "AutomatedMapTestingTransitionMap");
    LogInternal("AutomatedMapTestingTransitionMap: " $ AutomatedMapTestingTransitionMap);
    InOpt = WorldInfo.Game.ParseOption(Options, "AutomatedTestingMapIndex");
    if (InOpt != "")
    {
        LogInternal("AutomatedTestingMapIndex: " $ string(int(InOpt)));
        AutomatedTestingMapIndex = int(InOpt);
    }
    if (bAutomatedTestingWithOpen)
    {
        InOpt = WorldInfo.Game.ParseOption(Options, "NumberOfMatchesPlayed");
        if (InOpt != "")
        {
            LogInternal("NumberOfMatchesPlayed: " $ string(int(InOpt)));
            NumberOfMatchesPlayed = int(InOpt);
        }
        InOpt = WorldInfo.Game.ParseOption(Options, "NumMapListCyclesDone");
        if (InOpt != "")
        {
            LogInternal("NumMapListCyclesDone: " $ string(int(InOpt)));
            NumMapListCyclesDone = int(InOpt);
        }
    }
    else
    {
        LogInternal("*** Disabling automated transition map for ServerTravel");
        AutomatedMapTestingTransitionMap = "";
    }
}

event Timer()
{
    if (bAutomatedPerfTesting && AutomatedPerfRemainingTime > 0 && !bAutoContinueToNextRound)
    {
        AutomatedPerfRemainingTime--;
        if (AutomatedPerfRemainingTime <= 0)
        {
            ConsoleCommand("EXIT");
        }
    }
}

event PostBeginPlay()
{
    PostBeginPlay();
    SetTimer(1.0, true);
}

state SentinelHandleCauseEventCommand
{
    Begin:
    bSentinelStreamingLevelStillLoading = false;
    for (SentinelIdx = 0; SentinelIdx < WorldInfo.StreamingLevels.Length; ++SentinelIdx)
    {
        if (WorldInfo.StreamingLevels[SentinelIdx].bHasLoadRequestPending == true)
        {
            LogInternal("levels not streamed in yet sleeping 1s");
            bSentinelStreamingLevelStillLoading = true;
            Sleep(1.0);
            break;
        }
    }
    if (bSentinelStreamingLevelStillLoading != false)
    {
        goto Begin;
    }
    if (WorldInfo.Game.CauseEventCommand != "")
    {
        foreach WorldInfo.AllControllers(class'PlayerController', SentinelPC)
        {
            SentinelPC.ConsoleCommand("ce " $ WorldInfo.Game.CauseEventCommand);
            break;
        }
    }
    if (SentinelTaskDescription == "FlyThrough" || SentinelTaskDescription == "FlyThroughSplitScreen")
    {
        SetTimer(0.5, true, 'DoTimeBasedSentinelStatGathering');
    }
    Stop;
}

state TravelTheWorld
{
    function SetIncrementsForLoops(const float NumTravelLocations)
    {
        local float TimeWeGetInSeconds;
        
        TimeWeGetInSeconds = float(NumMinutesPerMap * 60);
        if (CalcTravelTheWorldTime(int(NumTravelLocations), 8) < TimeWeGetInSeconds)
        {
            TravelPointsIncrement = 1;
            NumRotationsIncrement = 1;
            LogInternal(WorldInfo.GetMapName() $ " SetIncrementsForLoops: TravelPointsIncrement: " $ string(TravelPointsIncrement) $ " NumRotationsIncrement: " $ string(NumRotationsIncrement) $ " for NumTravelLocations: " $ string(NumTravelLocations));
            PrintOutTravelWorldTimes(int(CalcTravelTheWorldTime(int(NumTravelLocations), 8)));
        }
        else if (CalcTravelTheWorldTime(int(NumTravelLocations), 4) < TimeWeGetInSeconds)
        {
            TravelPointsIncrement = 1;
            NumRotationsIncrement = 2;
            LogInternal(WorldInfo.GetMapName() $ " SetIncrementsForLoops: TravelPointsIncrement: " $ string(TravelPointsIncrement) $ " NumRotationsIncrement: " $ string(NumRotationsIncrement) $ " for NumTravelLocations: " $ string(NumTravelLocations));
            PrintOutTravelWorldTimes(int(CalcTravelTheWorldTime(int(NumTravelLocations), 4)));
        }
        else
        {
            TravelPointsIncrement = int(CalcTravelTheWorldTime(int(NumTravelLocations), 4) / TimeWeGetInSeconds);
            NumRotationsIncrement = 2;
            LogInternal(WorldInfo.GetMapName() $ " SetIncrementsForLoops: TravelPointsIncrement: " $ string(TravelPointsIncrement) $ " NumRotationsIncrement: " $ string(NumRotationsIncrement) $ " for NumTravelLocations: " $ string(NumTravelLocations));
            PrintOutTravelWorldTimes(int(CalcTravelTheWorldTime(int(NumTravelLocations / float(TravelPointsIncrement)), 4)));
        }
    }
    
    function PrintOutTravelWorldTimes(const int TotalTimeInSeconds)
    {
        local int Hours, Minutes, Seconds;
        
        Hours = TotalTimeInSeconds / (60 * 60);
        Minutes = (TotalTimeInSeconds - Hours * 60 * 60) / 60;
        Seconds = TotalTimeInSeconds - Minutes * 60 - Hours * 60 * 60;
        LogInternal(WorldInfo.GetMapName() $ ": Traveling this map will take approx TotalSeconds: " $ string(TotalTimeInSeconds) $ "   Hours: " $ string(Hours) $ "  Minutes: " $ string(Minutes) $ "  Seconds: " $ string(Seconds));
    }
    
    function float CalcTravelTheWorldTime(const int NumTravelLocations, const int NumRotations)
    {
        local float TotalTimeInSeconds, PerTravelLocTime;
        
        TotalTimeInSeconds += float(WorldInfo.StreamingLevels.Length) * 2.0;
        TotalTimeInSeconds += 10.0;
        TotalTimeInSeconds += float(WorldInfo.StreamingLevels.Length) * 10.0;
        TotalTimeInSeconds += 10.0;
        TotalTimeInSeconds += 10.0;
        PerTravelLocTime = 0.5 + 4.0 + 1.0 + 0.5 + 1.0 + float(NumRotations) * 1.5 + float(NumRotations) * 1.5;
        TotalTimeInSeconds += PerTravelLocTime * float(NumTravelLocations);
        return TotalTimeInSeconds;
    }
    
    function BeginState(name PreviousStateName)
    {
        local PlayerController PC;
        
        LogInternal("BeginState TravelTheWorld");
        BeginState(PreviousStateName);
        foreach LocalPlayerControllers(class'PlayerController', PC)
        {
            SentinelPC = PC;
            SentinelPC.Sentinel_SetupForGamebasedTravelTheWorld();
            break;
        }
        SentinelPC.bIsUsingStreamingVolumes = false;
        BeginSentinelRun(SentinelTaskDescription, SentinelTaskParameter, SentinelTagDesc);
    }
    
    Begin:
    SentinelPC.Sentinel_PreAcquireTravelTheWorldPoints();
    for (SentinelIdx = 0; SentinelIdx < WorldInfo.StreamingLevels.Length; ++SentinelIdx)
    {
        LogInternal("StreamLevelOut: " $ string(WorldInfo.StreamingLevels[SentinelIdx].PackageName));
        SentinelPC.ClientUpdateLevelStreamingStatus(WorldInfo.StreamingLevels[SentinelIdx].PackageName, false, false, true);
    }
    Sleep(10.0);
    WorldInfo.ForceGarbageCollection(true);
    for (SentinelIdx = 0; SentinelIdx < WorldInfo.StreamingLevels.Length; ++SentinelIdx)
    {
        LogInternal("Gathering locations for: " $ string(WorldInfo.StreamingLevels[SentinelIdx].PackageName));
        SentinelPC.ClientUpdateLevelStreamingStatus(WorldInfo.StreamingLevels[SentinelIdx].PackageName, true, true, true);
        Sleep(7.0);
        GetTravelLocations(WorldInfo.StreamingLevels[SentinelIdx].PackageName, SentinelPC, SentinelTravelArray);
        DoSentinelActionPerLoadedMap();
        SentinelPC.ConsoleCommand("FractureAllMeshesToMaximizeMemoryUsage");
        SentinelPC.ConsoleCommand("stat memory");
        Sleep(0.5);
        DoSentinel_MemoryAtSpecificLocation(vect(0.0, 0.0, 0.0), rot(0, 0, 0));
        SentinelPC.ConsoleCommand("stat memory");
        SentinelPC.ClientUpdateLevelStreamingStatus(WorldInfo.StreamingLevels[SentinelIdx].PackageName, false, false, true);
        Sleep(3.0);
        WorldInfo.ForceGarbageCollection(true);
    }
    if (WorldInfo.StreamingLevels.Length == 0)
    {
        GetTravelLocations(WorldInfo.StreamingLevels[SentinelIdx].PackageName, SentinelPC, SentinelTravelArray);
        DoSentinelActionPerLoadedMap();
        SentinelPC.ConsoleCommand("FractureAllMeshesToMaximizeMemoryUsage");
        SentinelPC.ConsoleCommand("stat memory");
        Sleep(0.5);
        DoSentinel_MemoryAtSpecificLocation(vect(0.0, 0.0, 0.0), rot(0, 0, 0));
        SentinelPC.ConsoleCommand("stat memory");
        Sleep(3.0);
        WorldInfo.ForceGarbageCollection(true);
    }
    LogInternal(WorldInfo.GetMapName() $ " COMPLETED LEVEL INTEROGATION!! Total TravelPoints: " $ string(SentinelTravelArray.Length));
    SetIncrementsForLoops(float(SentinelTravelArray.Length));
    for (SentinelIdx = 0; SentinelIdx < WorldInfo.StreamingLevels.Length; ++SentinelIdx)
    {
        if (LevelStreamingAlwaysLoaded(WorldInfo.StreamingLevels[SentinelIdx]) != none)
        {
            LogInternal("   Found a LevelStreamingAlwaysLoaded" @ string(WorldInfo.StreamingLevels[SentinelIdx].PackageName));
            SentinelPC.ClientUpdateLevelStreamingStatus(WorldInfo.StreamingLevels[SentinelIdx].PackageName, true, true, true);
        }
    }
    SentinelPC.bIsUsingStreamingVolumes = true;
    Sleep(10.0);
    SentinelPC.Sentinel_PostAcquireTravelTheWorldPoints();
    Sleep(10.0);
    SentinelTravelArray.AddItem(SentinelTravelArray[0]);
    LogInternal("Starting Traversal");
    LogInternal("   SentinelTravelArray.length " $ string(SentinelTravelArray.Length));
    SentinelNavigationIdx = 0;
    while (SentinelNavigationIdx < SentinelTravelArray.Length)
    {
        LogInternal("Going to:" @ string(SentinelTravelArray[SentinelNavigationIdx]) @ string(SentinelNavigationIdx) $ " of " $ string(SentinelTravelArray.Length));
        SentinelPC.SetLocation(SentinelTravelArray[SentinelNavigationIdx]);
        SentinelPC.SetRotation(rot(0, 0, 0));
        Sleep(0.5);
        do
        {
            bSentinelStreamingLevelStillLoading = false;
            for (SentinelIdx = 0; SentinelIdx < WorldInfo.StreamingLevels.Length; ++SentinelIdx)
            {
                if (WorldInfo.StreamingLevels[SentinelIdx].bHasLoadRequestPending == true)
                {
                    LogInternal("levels not streamed in yet sleeping 1s");
                    bSentinelStreamingLevelStillLoading = true;
                    Sleep(1.0);
                    break;
                }
            }
        } until (bSentinelStreamingLevelStillLoading == false);
        WorldInfo.ForceGarbageCollection(true);
        Sleep(1.0);
        if (SentinelNavigationIdx == 0)
        {
            ConsoleCommand("MemLeakCheck");
        }
        SentinelPC.ConsoleCommand("stat memory");
        Sleep(0.5);
        DoSentinel_MemoryAtSpecificLocation(SentinelPC.Location, SentinelPC.Rotation);
        SentinelPC.ConsoleCommand("stat memory");
        SentinelPC.ConsoleCommand("stat scenerendering");
        SentinelPC.ConsoleCommand("stat streaming");
        Sleep(1.0);
        SentinelIdx = 0;
        while (SentinelIdx < 8)
        {
            SentinelPC.SetRotation(rot(0, 1, 0) * float(8192 * SentinelIdx));
            Sleep(1.5);
            DoSentinel_ViewDependentMemoryAtSpecificLocation(SentinelPC.Location, SentinelPC.Rotation);
            SentinelIdx += NumRotationsIncrement;
        }
        SentinelPC.ConsoleCommand("stat scenerendering");
        SentinelPC.ConsoleCommand("stat streaming");
        SentinelIdx = 0;
        while (SentinelIdx < 8)
        {
            SentinelPC.SetRotation(rot(0, 1, 0) * float(8192 * SentinelIdx));
            Sleep(1.5);
            DoSentinel_PerfAtSpecificLocation(SentinelPC.Location, SentinelPC.Rotation);
            SentinelIdx += NumRotationsIncrement;
        }
        foreach CommandsToRunAtEachTravelTheWorldNode(CommandStringToExec)
        {
            ConsoleCommand(CommandStringToExec);
        }
        SentinelNavigationIdx += TravelPointsIncrement;
    }
    ConsoleCommand("MemLeakCheck");
    LogInternal("COMPLETED!!!!!!!");
    ConsoleCommand("exit");
    Stop;
}

defaultproperties
{
    NumMinutesPerMap=50
    Components(0)="Default__AutoTestManager.Sprite"
}

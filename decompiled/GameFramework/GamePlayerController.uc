class GamePlayerController extends PlayerController
    abstract
    native
    notplaceable
    config(Game)
    hidecategories(Navigation);

var bool bWarnCrowdMembers;
var(Debug) bool bDebugCrowdAwareness;
var transient bool bIsWarmupPaused;
var float AgentAwareRadius;
var transient name CurrentSoundMode;

reliable client simulated function ClientColorFade(Color FadeColor, byte FromAlpha, byte ToAlpha, float FadeTime)
{
}

event WarmupPause(bool bDesiredPauseState)
{
    local Color FadeColor;
    local PlayerController PC;
    
    bIsWarmupPaused = bDesiredPauseState;
    SetPause(bDesiredPauseState, CanUnpauseWarmup);
    if (!bDesiredPauseState)
    {
        foreach LocalPlayerControllers(class'Engine.PlayerController', PC)
        {
            GamePlayerController(PC).ClientColorFade(FadeColor, 255, 0, 2.0);
        }
    }
}

function bool CanUnpauseWarmup()
{
    return !bIsWarmupPaused;
}

native final function GetCurrentMovie(out string MovieName)
{
    MovieName;
}

native reliable client final simulated event ClientStopMovie(float DelayInSeconds, bool bAllowMovieToFinish, bool bForceStopNonSkippable, bool bForceStopLoadingMovie)
{
    DelayInSeconds;
    bAllowMovieToFinish;
    bForceStopNonSkippable;
    bForceStopLoadingMovie;
}

native reliable client final simulated event ClientPlayMovie(string MovieName, optional int InStartOfRenderingMovieFrame = -1, optional int InEndOfRenderingMovieFrame = -1)
{
    MovieName;
    InStartOfRenderingMovieFrame;
    InEndOfRenderingMovieFrame;
}

native static final function KeepPlayingLoadingMovie()
{
}

native static final function ShowLoadingMovie(bool bShowMovie, optional bool bPauseAfterHide, optional float PauseDuration, optional float KeepPlayingDuration, optional bool bOverridePreviousDelays)
{
    bShowMovie;
    bPauseAfterHide;
    PauseDuration;
    KeepPlayingDuration;
    bOverridePreviousDelays;
}

final simulated function name GetCurrentSoundMode()
{
    return CurrentSoundMode;
}

simulated function bool SetSoundMode(name InSoundModeName)
{
    local AudioDevice Audio;
    local bool bSet;
    
    Audio = class'Engine.Engine'.static.GetAudioDevice();
    if (Audio != none)
    {
        bSet = Audio.SetSoundMode(InSoundModeName);
    }
    return bSet;
}

protected simulated function DoForceFeedbackForScreenShake(CameraShake ShakeData, float Scale)
{
    local int ShakeLevel;
    local float RotMag, LocMag, FOVMag;
    
    if (ShakeData != none)
    {
        RotMag = ShakeData.GetRotOscillationMagnitude() * Scale;
        if (RotMag > 40.0)
        {
            ShakeLevel = 2;
        }
        else if (RotMag > 20.0)
        {
            ShakeLevel = 1;
        }
        if (ShakeLevel < 2)
        {
            LocMag = ShakeData.GetLocOscillationMagnitude() * Scale;
            if (LocMag > 10.0)
            {
                ShakeLevel = 2;
            }
            else if (LocMag > 5.0)
            {
                ShakeLevel = 1;
            }
            FOVMag = ShakeData.FOVOscillation.Amplitude * Scale;
            if (ShakeLevel < 2)
            {
                if (FOVMag > 5.0)
                {
                    ShakeLevel = 2;
                }
                else if (FOVMag > 2.0)
                {
                    ShakeLevel = 1;
                }
            }
        }
        if (ShakeLevel == 2)
        {
            if (ShakeData.OscillationDuration <= float(1))
            {
                ClientPlayForceFeedbackWaveform(class'GameWaveForms'.default.default.CameraShakeBigShort);
            }
            else
            {
                ClientPlayForceFeedbackWaveform(class'GameWaveForms'.default.default.CameraShakeBigLong);
            }
        }
        else if (ShakeLevel == 1)
        {
            if (ShakeData.OscillationDuration <= float(1))
            {
                ClientPlayForceFeedbackWaveform(class'GameWaveForms'.default.default.CameraShakeMediumShort);
            }
            else
            {
                ClientPlayForceFeedbackWaveform(class'GameWaveForms'.default.default.CameraShakeMediumLong);
            }
        }
    }
}

event NotifyCrowdAgentInRadius(GameCrowdAgent Agent)
{
}

event NotifyCrowdAgentRefresh()
{
}

exec function CrowdDebug(bool bEnabled)
{
    local GameCrowdAgent GCA;
    local int I, AgentCount;
    local float DebugRadius;
    
    LogInternal("CROWDDEBUG" @ string(myHUD) @ string(bEnabled));
    myHUD.bShowOverlays = bEnabled;
    for (I = 0; I < myHUD.PostRenderedActors.Length; I++)
    {
        GCA = GameCrowdAgent(myHUD.PostRenderedActors[I]);
        if (GCA != none)
        {
            myHUD.RemovePostRenderedActor(GCA);
        }
    }
    if (bEnabled)
    {
        DebugRadius = 2000.0;
        foreach VisibleActors(class'GameCrowdAgent', GCA, DebugRadius, Pawn != none ? Pawn.Location : Location)
        {
            AgentCount++;
        }
        if (AgentCount > 100)
        {
            DebugRadius *= Sqrt(100.0 / float(AgentCount));
        }
        foreach VisibleActors(class'GameCrowdAgent', GCA, DebugRadius, Pawn != none ? Pawn.Location : Location)
        {
            myHUD.AddPostRenderedActor(GCA);
        }
    }
}

exec function CrowdToggle()
{
    local GameCrowdPopulationManager PopMgr;
    local GameCrowdAgent Agent;
    
    foreach DynamicActors(class'GameCrowdPopulationManager', PopMgr)
    {
        PopMgr.bSpawningActive = !PopMgr.bSpawningActive;
        if (!PopMgr.bSpawningActive)
        {
            foreach DynamicActors(class'GameCrowdAgent', Agent)
            {
                if (EqualEqual_InterfaceInterface(Agent.MySpawner, GameCrowdSpawnerInterface(self)))
                {
                    Agent.Destroy();
                }
            }
        }
    }
}

exec function CrowdFocus()
{
    local GameCrowdAgent GCA;
    local GameCrowdPopulationManager PopMgr;
    
    myHUD.bShowOverlays = true;
    foreach DynamicActors(class'GameCrowdAgent', GCA)
    {
        if (WorldInfo.TimeSeconds - GCA.LastRenderTime < 0.2 && VSizeSq(ViewTarget.Location - GCA.Location) < 100000000.0)
        {
            myHUD.AddPostRenderedActor(GCA);
            continue;
        }
        GCA.Destroy();
    }
    foreach DynamicActors(class'GameCrowdPopulationManager', PopMgr)
    {
        PopMgr.bSpawningActive = false;
    }
}

native function int GetUIPlayerIndex()
{
}

defaultproperties
{
    AgentAwareRadius=200.0
    CylinderComponent="Default__GamePlayerController.CollisionCylinder"
    Components(0)="Default__GamePlayerController.CollisionCylinder"
    CollisionComponent="Default__GamePlayerController.CollisionCylinder"
}

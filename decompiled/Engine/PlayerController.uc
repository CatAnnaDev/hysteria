class PlayerController extends Controller
    native
    nativereplication
    notplaceable
    config(Game)
    hidecategories(Navigation);

const MAXCLIENTUPDATEINTERVAL = 0.25;
const CLIENTADJUSTUPDATECOST = 180.0;
const MAXVEHICLEPOSITIONERRORSQUARED = 900.0;
const MAXNEARZEROVELOCITYSQUARED = 9.0;
const MAXPOSITIONERRORSQUARED = 3.0;

enum EProgressMessageType
{
    PMT_Clear,
    PMT_Information,
    PMT_AdminMessage,
    PMT_DownloadProgress,
    PMT_ConnectionFailure,
    PMT_SocketFailure,
};

enum EInputMatchAction
{
    IMA_GreaterThan,
    IMA_LessThan,
};

enum EInputTypes
{
    IT_XAxis,
    IT_YAxis,
};

struct native DebugTextInfo
{
    var Actor SrcActor;
    var Vector SrcActorOffset;
    var Vector SrcActorDesiredOffset;
    var string DebugText;
    var transient float TimeRemaining;
    var float Duration;
    var Color TextColor;
    var bool bAbsoluteLocation;
};

struct native InputMatchRequest
{
    var array<InputEntry> Inputs;
    var Actor MatchActor;
    var name MatchFuncName;
    var delegate<InputMatchDelegate> MatchDelegate;
    var name FailedFuncName;
    var name RequestName;
    var transient int MatchIdx;
    var transient float LastMatchTime;
};

struct native InputEntry
{
    var EInputTypes Type;
    var float Value;
    var float TimeDelta;
    var EInputMatchAction Action;
};

struct native ClientAdjustment
{
    var float TimeStamp;
    var EPhysics newPhysics;
    var Vector NewLoc;
    var Vector NewVel;
    var Actor NewBase;
    var Vector NewFloor;
    var byte bAckGoodMove;
};

var const Player Player;
var(Camera) editinline Camera PlayerCamera;
var const class<Camera> CameraClass;
var const class<PlayerOwnerDataStore> PlayerOwnerDataStoreClass;
var PlayerOwnerDataStore CurrentPlayerData;
var bool bFrozen;
var bool bPressedJump;
var bool bDoubleJump;
var bool bUpdatePosition;
var bool bUpdating;
var globalconfig bool bNeverSwitchOnPickup;
var bool bCheatFlying;
var bool bCameraPositionLocked;
var bool bShortConnectTimeOut;
var const bool bPendingDestroy;
var bool bWasSpeedHack;
var const bool bWasSaturated;
var globalconfig bool bAimingHelp;
var bool bClientSimulatingViewTarget;
var bool bSetViewTargetImmediately;
var bool bSetViewTargetRotImmediately;
var bool bSetViewTargetLocImmediately;
var bool bSetViewTargetFOVImmediately;
var bool bHasVoiceHandshakeCompleted;
var bool bCinematicMode;
var bool bCinemaDisableInputMove;
var bool bCinemaDisableInputLook;
var bool bIgnoreNetworkMessages;
var bool bReplicateAllPawns;
var bool bIsUsingStreamingVolumes;
var bool bIsExternalUIOpen;
var bool bIsControllerConnected;
var bool bCanUnPause;
var bool bNoCurrentUser;
var bool bCheckSoundOcclusion;
var globalconfig bool bLogHearSoundOverflow;
var globalconfig bool bCheckRelevancyThroughPortals;
var(Debug) bool bDebugClientAdjustPosition;
var float MaxResponseTime;
var float WaitDelay;
var Pawn AcknowledgedPawn;
var EDoubleClickDir DoubleClickDir;
var byte bIgnoreMoveInput;
var byte bIgnoreLookInput;
var input byte bRun;
var input byte bDuck;
var const duplicatetransient byte NetPlayerIndex;
var const Actor ViewTarget;
var PlayerReplicationInfo RealViewTarget;
var transient InterpTrackInstDirector ControllingDirTrackInst;
var float FOVAngle;
var float DesiredFOV;
var float DefaultFOV;
var const float LODDistanceFactor;
var repretry Rotator TargetViewRotation;
var repretry float TargetEyeHeight;
var Rotator BlendedTargetViewRotation;
var HUD myHUD;
var class<SavedMove> SavedMoveClass;
var SavedMove SavedMoves;
var SavedMove FreeMoves;
var SavedMove PendingMove;
var Vector LastAckedAccel;
var float CurrentTimeStamp;
var float LastUpdateTime;
var float ServerTimeStamp;
var float TimeMargin;
var float ClientUpdateTime;
var float MaxTimeMargin;
var float LastActiveTime;
var int ClientCap;
var deprecated float DynamicPingThreshold;
var float LastPingUpdate;
var float LastSpeedHackLog;
var ClientAdjustment PendingAdjustment;
var const localized string QuickSaveString;
var int GroundPitch;
var Vector OldFloor;
var transient CheatManager CheatManager;
var class<CheatManager> CheatClass;
var() transient editinline PlayerInput PlayerInput;
var class<PlayerInput> InputClass;
var const Vector FailedPathStart;
var export editinline CylinderComponent CylinderComponent;
var config string ForceFeedbackManagerClassName;
var transient ForceFeedbackManager ForceFeedbackManager;
var transient array<Interaction> Interactions;
var array<UniqueNetId> VoiceMuteList;
var array<UniqueNetId> GameplayVoiceMuteList;
var array<UniqueNetId> VoicePacketFilter;
var OnlineSubsystem OnlineSub;
var OnlineVoiceInterface VoiceInterface;
var UIDataStore_OnlinePlayerData OnlinePlayerData;
var config float InteractDistance;
var name DelayedJoinSessionName;
var array<InputMatchRequest> InputRequests;
var float LastBroadcastTime;
var string LastBroadcastString[4];
var array<name> PendingMapChangeLevelNames;
var CoverReplicator MyCoverReplicator;
var array<DebugTextInfo> DebugTextList;
var float SpectatorCameraSpeed;
var const duplicatetransient NetConnection PendingSwapConnection;
var float MinRespawnDelay;
var globalconfig int MaxConcurrentHearSounds;
var export editinline array<AudioComponent> HearSoundActiveComponents;
var export editinline array<AudioComponent> HearSoundPoolComponents;
var array<Actor> HiddenActors;
var float LastSpectatorStateSynchTime;
var string PhysMatLogInfo;
var transient Actor TargetingActor;
var transient Actor PreTargetingActor;
var delegate<CanUnpause> __CanUnpause__Delegate;
var delegate<InputMatchDelegate> __InputMatchDelegate__Delegate;

replication
{
    if (bNetOwner && Role == 3 && ViewTarget != Pawn && Pawn(ViewTarget) != none)
        TargetViewRotation, TargetEyeHeight;
}

event LoadingMapIsStart()
{
}

event LoadingBinkIsFinished()
{
}

event OnBinkPlay(string MovieName)
{
}

native private final function LogOutBugItAIGoToLogFile(const string InScreenShotDesc, const string InGoString, const string InLocString)
{
    InScreenShotDesc;
    InGoString;
    InLocString;
}

native private final function LogOutBugItGoToLogFile(const string InScreenShotDesc, const string InGoString, const string InLocString)
{
    InScreenShotDesc;
    InGoString;
    InLocString;
}

function DisableDebugAI()
{
    ConsoleCommand("debugai");
}

exec function DumpOnlineSessionState()
{
    if (CheatManager != none)
    {
        CheatManager.DumpOnlineSessionState();
    }
    else
    {
        DebugLogPRIs();
        if (OnlineSub != none)
        {
            OnlineSub.DumpSessionState();
        }
    }
}

function DebugLogPRIs()
{
    local int PlayerIndex;
    local UniqueNetId NetId;
    
    if (WorldInfo != none && WorldInfo.GRI != none)
    {
        LogInternal("  Number of PRI players: " $ string(WorldInfo.GRI.PRIArray.Length));
        for (PlayerIndex = 0; PlayerIndex < WorldInfo.GRI.PRIArray.Length; PlayerIndex++)
        {
            NetId = WorldInfo.GRI.PRIArray[PlayerIndex].UniqueId;
            LogInternal("    Player: " $ WorldInfo.GRI.PRIArray[PlayerIndex].PlayerName $ " UID (" $ class'OnlineSubsystem'.static.UniqueNetIdToString(NetId) $ ") PC (" $ string(WorldInfo.GRI.PRIArray[PlayerIndex].Owner) $ ")");
        }
        LogInternal("");
    }
}

exec event BugItStringCreator(out const Vector ViewLocation, out const Rotator ViewRotation, out string GoString, out string LocString)
{
    GoString = "BugItGo " $ string(ViewLocation.X) $ " " $ string(ViewLocation.Y) $ " " $ string(ViewLocation.Z) $ " " $ string(ViewRotation.Pitch) $ " " $ string(ViewRotation.Yaw) $ " " $ string(ViewRotation.Roll);
    LogInternal(GoString);
    LocString = "?BugLoc=" $ string(ViewLocation) $ "?BugRot=" $ string(ViewRotation);
    LogInternal(LocString);
}

exec event BugItAI(optional string ScreenShotDescription)
{
    local Vector ViewLocation;
    local Rotator ViewRotation;
    local string GoString, LocString;
    
    GetPlayerViewPoint(ViewLocation, ViewRotation);
    if (Pawn != none)
    {
        ViewLocation = Pawn.Location;
    }
    BugItStringCreator(ViewLocation, ViewRotation, GoString, LocString);
    ConsoleCommand("debugai");
    SetTimer(0.1, false, 'DisableDebugAI');
    LogOutBugItAIGoToLogFile(ScreenShotDescription, GoString, LocString);
}

exec function LogLoc()
{
    local Vector ViewLocation;
    local Rotator ViewRotation;
    local string GoString, LocString;
    
    GetPlayerViewPoint(ViewLocation, ViewRotation);
    if (Pawn != none)
    {
        ViewLocation = Pawn.Location;
    }
    BugItStringCreator(ViewLocation, ViewRotation, GoString, LocString);
}

exec event BugIt(optional string ScreenShotDescription)
{
    local Vector ViewLocation;
    local Rotator ViewRotation;
    local string GoString, LocString;
    
    ConsoleCommand("bugscreenshot " $ ScreenShotDescription);
    GetPlayerViewPoint(ViewLocation, ViewRotation);
    if (Pawn != none)
    {
        ViewLocation = Pawn.Location;
    }
    BugItStringCreator(ViewLocation, ViewRotation, GoString, LocString);
    LogOutBugItGoToLogFile(ScreenShotDescription, GoString, LocString);
}

function BugItWorker(Vector TheLocation, Rotator TheRotation)
{
    LogInternal("BugItGo to:" @ string(TheLocation) @ string(TheRotation));
    if (CheatManager != none)
    {
        CheatManager.Ghost();
    }
    ViewTarget.SetLocation(TheLocation);
    Pawn.FaceRotation(TheRotation, 0.0);
    SetRotation(TheRotation);
}

function BugItGoString(string TheLocation, string TheRotation)
{
    BugItWorker(vector(TheLocation), rotator(TheRotation));
}

exec function BugItGo(coerce float X, coerce float Y, coerce float Z, coerce int Pitch, coerce int Yaw, coerce int Roll)
{
    local Vector TheLocation;
    local Rotator TheRotation;
    
    TheLocation.X = X;
    TheLocation.Y = Y;
    TheLocation.Z = Z;
    TheRotation.Pitch = Pitch;
    TheRotation.Yaw = Yaw;
    TheRotation.Roll = Roll;
    BugItWorker(TheLocation, TheRotation);
}

function OnSetSoundMode(SeqAct_SetSoundMode Action)
{
    local AudioDevice Audio;
    
    Audio = class'Engine'.static.GetAudioDevice();
    if (Audio != none)
    {
        if (Action.InputLinks[0].bHasImpulse && Action.SoundMode != none)
        {
            Audio.SetSoundMode(Action.SoundMode.Name);
        }
        else
        {
            Audio.SetSoundMode('Default');
        }
    }
}

unreliable client simulated event ClientSpawnCameraLensEffect(class<EmitterCameraLensEffectBase> LensEffectEmitterClass)
{
    if (PlayerCamera != none)
    {
        PlayerCamera.AddCameraLensEffect(LensEffectEmitterClass);
    }
}

reliable client simulated event ClientStopCameraAnim(CameraAnim AnimToStop)
{
    if (PlayerCamera != none)
    {
        PlayerCamera.StopAllCameraAnimsByType(AnimToStop);
    }
}

unreliable client simulated event ClientPlayCameraAnim(CameraAnim AnimToPlay, optional bool bGamePlayCamera = false, optional float Scale = 1.0, optional float Rate = 1.0, optional float BlendInTime, optional float BlendOutTime, optional bool bLoop, optional bool bRandomStartTime, optional ECameraAnimPlaySpace Space = 0, optional Rotator CustomPlaySpace)
{
    local CameraAnimInst AnimInst;
    
    if (PlayerCamera != none)
    {
        AnimInst = PlayerCamera.PlayCameraAnim(AnimToPlay, bGamePlayCamera, Rate, Scale, BlendInTime, BlendOutTime, bLoop, bRandomStartTime);
        if (AnimInst != none && Space != 0)
        {
            AnimInst.SetPlaySpace(Space, CustomPlaySpace);
        }
    }
}

event ClearOnRequestUnloadLevel(LevelStreaming StreamingLevel)
{
}

function OnCameraShake(SeqAct_CameraShake inAction)
{
    if (inAction.InputLinks[0].bHasImpulse)
    {
        if (inAction.bRadialShake)
        {
            if (inAction.LocationActor != none)
            {
                class'Camera'.static.PlayWorldCameraShake(inAction.Shake, inAction.LocationActor, inAction.LocationActor.Location, inAction.RadialShake_InnerRadius, inAction.RadialShake_OuterRadius, inAction.RadialShake_Falloff, inAction.bDoControllerVibration, inAction.bOrientTowardRadialEpicenter);
            }
            else
            {
                WarnInternal(string(self) @ "Location actor needed for bRadialFalloff camera shake.");
                return;
            }
        }
        else
        {
            ClientPlayCameraShake(inAction.Shake, inAction.ShakeScale, inAction.bDoControllerVibration, inAction.PlaySpace, inAction.LocationActor == none ? rot(0, 0, 0) : inAction.LocationActor.Rotation);
        }
    }
    else
    {
        ClientStopCameraShake(inAction.Shake);
    }
}

unreliable client simulated function ClientStopCameraShake(CameraShake Shake)
{
    if (PlayerCamera != none)
    {
        PlayerCamera.StopCameraShake(Shake);
    }
}

unreliable client simulated function ClientPlayCameraShake(CameraShake Shake, optional float Scale = 1.0, optional bool bTryForceFeedback, optional ECameraAnimPlaySpace PlaySpace = 0, optional Rotator UserPlaySpaceRot)
{
    if (PlayerCamera != none)
    {
        PlayerCamera.PlayCameraShake(Shake, Scale, PlaySpace, UserPlaySpaceRot);
        if (bTryForceFeedback)
        {
            DoForceFeedbackForScreenShake(Shake, Scale);
        }
    }
}

protected simulated function DoForceFeedbackForScreenShake(CameraShake ShakeData, float ShakeScale)
{
}

delegate InputMatchDelegate()
{
}

function Sentinel_PostAcquireTravelTheWorldPoints()
{
}

function Sentinel_PreAcquireTravelTheWorldPoints()
{
}

function Sentinel_SetupForGamebasedTravelTheWorld()
{
}

simulated function OnFlyThroughHasEnded(SeqAct_FlyThroughHasEnded inAction)
{
    local PlayerController PC;
    
    if (WorldInfo.Game.IsDoingASentinelRun())
    {
        foreach WorldInfo.AllControllers(class'PlayerController', PC)
        {
            PC.ConsoleCommand("quit");
        }
    }
}

event bool GetAchievementProgression(int AchievementId, out float CurrentValue, out float MaxValue)
{
}

static function string GetPartyGameTypeName()
{
}

static function string GetPartyMapName()
{
}

simulated function bool IsPartyLeader()
{
    local OnlineGameSettings PartySettings;
    
    if (OnlineSub != none && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)))
    {
        PartySettings = OnlineSub.GameInterface.GetGameSettings('Party');
        if (PartySettings != none)
        {
            if (PlayerReplicationInfo != none)
            {
                return OnlineSub.AreUniqueNetIdsEqual(PartySettings.OwningPlayerId, PlayerReplicationInfo.UniqueId);
            }
        }
    }
    return WorldInfo.NetMode != 3 && IsPrimaryPlayer();
}

reliable client simulated event ClientPrestreamTextures(Actor ForcedActor, float ForceDuration, bool bEnableStreaming, optional int CinematicTextureGroups = 0)
{
    if (ForcedActor != none && IsPrimaryPlayer())
    {
        ForcedActor.PrestreamTextures(ForceDuration, bEnableStreaming, CinematicTextureGroups);
    }
}

reliable client simulated event ClientSetForceMipLevelsToBeResident(MaterialInterface Material, float ForceDuration, optional int CinematicTextureGroups)
{
    if (Material != none && IsPrimaryPlayer())
    {
        Material.SetForceMipLevelsToBeResident(false, false, ForceDuration, CinematicTextureGroups);
    }
}

reliable client simulated function ClientControlMovieTexture(TextureMovie MovieTexture, EMovieControlType Mode)
{
    if (MovieTexture != none)
    {
        switch (Mode)
        {
            case 0:
                MovieTexture.Play();
                break;
            case 1:
                MovieTexture.Stop();
                break;
            case 2:
                MovieTexture.Pause();
                break;
            default:
                break;
        }
    }
}

simulated function int GetSplitscreenPlayerCount()
{
    local LocalPlayer LP;
    local NetConnection RemoteConnection;
    local int Result;
    
    if (IsSplitscreenPlayer())
    {
        if (Player != none)
        {
            LP = LocalPlayer(Player);
            RemoteConnection = NetConnection(Player);
            if (LP != none)
            {
                Result = LP.ViewportClient.Outer.GamePlayers.Length;
            }
            else if (RemoteConnection != none)
            {
                if (ChildConnection(RemoteConnection) != none)
                {
                    RemoteConnection = ChildConnection(RemoteConnection).Parent;
                }
                Result = RemoteConnection.Children.Length + 1;
            }
            else
            {
                LogInternal("(" $ string(Name) $ ") PlayerController::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) @ "NOT A LOCALPLAYER AND NOT A REMOTECONNECTION!");
            }
        }
        else
        {
            LogInternal("(" $ string(Name) $ ") PlayerController::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) @ "called without a valid Player value!");
        }
    }
    return Result;
}

simulated function PlayerReplicationInfo GetSplitscreenPlayerByIndex(optional int PlayerIndex = 1)
{
    local PlayerReplicationInfo Result;
    local LocalPlayer LP, SplitPlayer;
    local NetConnection MasterConnection, RemoteConnection;
    local ChildConnection ChildRemoteConnection;
    
    if (Player != none)
    {
        if (IsSplitscreenPlayer())
        {
            LP = LocalPlayer(Player);
            RemoteConnection = NetConnection(Player);
            if (LP != none)
            {
                if (PlayerIndex >= 0 && PlayerIndex < LP.ViewportClient.Outer.GamePlayers.Length)
                {
                    SplitPlayer = LP.ViewportClient.Outer.GamePlayers[PlayerIndex];
                    Result = SplitPlayer.Actor.PlayerReplicationInfo;
                }
                else
                {
                    WarnInternal("(" $ string(Name) $ ") PlayerController::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) $ ":" @ "requested player at invalid index!" @ "PlayerIndex:'" $ string(PlayerIndex) $ "'" @ "NumLocalPlayers:'" $ string(LP.ViewportClient.Outer.GamePlayers.Length) $ "'");
                }
            }
            else if (RemoteConnection != none)
            {
                if (WorldInfo.NetMode == 3)
                {
                    WarnInternal("(" $ string(Name) $ ") PlayerController::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) $ ":" @ "CALLED ON CLIENT WITH VALID REMOTE NETCONNECTION!");
                }
                else
                {
                    ChildRemoteConnection = ChildConnection(RemoteConnection);
                    if (ChildRemoteConnection != none)
                    {
                        MasterConnection = ChildRemoteConnection.Parent;
                        if (PlayerIndex == 0)
                        {
                            Result = MasterConnection.Actor.PlayerReplicationInfo;
                        }
                        else
                        {
                            PlayerIndex--;
                            if (PlayerIndex >= 0 && PlayerIndex < MasterConnection.Children.Length)
                            {
                                ChildRemoteConnection = MasterConnection.Children[PlayerIndex];
                                Result = ChildRemoteConnection.Actor.PlayerReplicationInfo;
                            }
                        }
                    }
                    else if (RemoteConnection.Children.Length > 0)
                    {
                        if (PlayerIndex == 0)
                        {
                            Result = PlayerReplicationInfo;
                        }
                        else
                        {
                            PlayerIndex--;
                            if (PlayerIndex >= 0 && PlayerIndex < RemoteConnection.Children.Length)
                            {
                                ChildRemoteConnection = RemoteConnection.Children[PlayerIndex];
                                Result = ChildRemoteConnection.Actor.PlayerReplicationInfo;
                            }
                        }
                    }
                    else
                    {
                        LogInternal("(" $ string(Name) $ ") PlayerController::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) $ ":" @ string(Player) @ "IS NOT THE PRIMARY CONNECTION AND HAS NO CHILD CONNECTIONS!");
                    }
                }
            }
            else
            {
                LogInternal("(" $ string(Name) $ ") PlayerController::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) $ ":" @ string(Player) @ "IS NOT A LOCALPLAYER AND NOT A REMOTECONNECTION! (No valid Player reference)");
            }
        }
    }
    else
    {
        LogInternal("(" $ string(Name) $ ") PlayerController::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) $ ":" @ "NULL value for Player!");
    }
    return Result;
}

simulated function bool HasSplitscreenPlayer(PlayerReplicationInfo PRI)
{
    local bool bResult;
    local PlayerController OwnerPC;
    
    if (PRI != none)
    {
        if (PRI.IsLocalPlayerPRI())
        {
            bResult = IsSplitscreenPlayer();
        }
        else if (Role == 3)
        {
            OwnerPC = PlayerController(PRI.Owner);
            bResult = OwnerPC.IsSplitscreenPlayer();
        }
        else
        {
            bResult = PRI.SplitscreenIndex != -1;
        }
    }
    else
    {
        WarnInternal("(" $ string(Name) $ ") PlayerController::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) @ "called with a NULL PRI!");
    }
    return bResult;
}

simulated function bool IsSplitscreenPlayer(optional out int out_SplitscreenPlayerIndex)
{
    local bool bResult;
    local LocalPlayer LP;
    local NetConnection RemoteConnection;
    local ChildConnection ChildRemoteConnection;
    
    out_SplitscreenPlayerIndex = int(NetPlayerIndex);
    if (Player != none)
    {
        LP = LocalPlayer(Player);
        RemoteConnection = NetConnection(Player);
        if (LP != none)
        {
            if (LP.Outer.GamePlayers.Length > 1)
            {
                out_SplitscreenPlayerIndex = LP.Outer.GamePlayers.Find(LP);
                bResult = true;
            }
        }
        else if (RemoteConnection != none)
        {
            if (RemoteConnection.Children.Length > 0)
            {
                out_SplitscreenPlayerIndex = 0;
                bResult = true;
            }
            else
            {
                ChildRemoteConnection = ChildConnection(RemoteConnection);
                if (ChildRemoteConnection != none)
                {
                    if (ChildRemoteConnection.Parent != none)
                    {
                        out_SplitscreenPlayerIndex = ChildRemoteConnection.Parent.Children.Find(ChildRemoteConnection) + 1;
                    }
                    bResult = true;
                }
            }
        }
        else
        {
            LogInternal("(" $ string(Name) $ ") PlayerController::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) @ "NOT A LOCALPLAYER AND NOT A REMOTECONNECTION!", 'RON_DEBUG');
        }
    }
    return bResult;
}

simulated function bool IsPrimaryPlayer()
{
    local int SSIndex;
    
    return !IsSplitscreenPlayer(SSIndex) || SSIndex == 0;
}

reliable client simulated function ClientReturnToParty(UniqueNetId RequestingPlayerId)
{
    local string URL;
    
    if (IsPrimaryPlayer())
    {
        if (OnlineSub != none && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
        {
            if (OnlineSub.GameInterface.GetGameSettings('Party') != none)
            {
                if (IsPartyLeader())
                {
                    URL = GetPartyMapName() $ "?game=" $ GetPartyGameTypeName() $ "?listen";
                    WorldInfo.ServerTravel(URL, true, true);
                }
                else if (OnlineSub.GameInterface.GetResolvedConnectString('Party', URL))
                {
                    ClientTravel(URL, 0);
                }
            }
            else
            {
                ConsoleCommand("disconnect");
            }
        }
        else
        {
            ConsoleCommand("disconnect");
        }
    }
}

function OnJoinTravelToSessionComplete(name SessionName, bool bWasSuccessful)
{
    local string URL;
    
    if (bWasSuccessful)
    {
        if (OnlineSub.GameInterface.GetResolvedConnectString(SessionName, URL))
        {
            LogInternal("Resulting url for 'Game' is (" $ URL $ ")");
            ClientTravel(URL, 0);
        }
    }
}

reliable client simulated function ClientTravelToSession(name SessionName, class<OnlineGameSearch> SearchClass, byte PlatformSpecificInfo[80])
{
    local OnlineGameSearch Search;
    local LocalPlayer LP;
    local OnlineGameSearchResult SessionToJoin;
    
    LP = LocalPlayer(Player);
    if (LP != none)
    {
        Search = new SearchClass;
        if (OnlineSub.GameInterface.BindPlatformSpecificSessionToSearch(byte(LP.ControllerId), Search, PlatformSpecificInfo))
        {
            SessionToJoin = Search.Results[0];
            LogInternal("(PlayerController.ClientTravelToSession): " $ " SessionName=" $ string(SessionName) $ " SearchClass=" $ string(SearchClass) $ " UniqueId=" $ OnlineSub.UniqueNetIdToString(PlayerReplicationInfo.UniqueId) $ " Session.OwnerId=" $ OnlineSub.UniqueNetIdToString(SessionToJoin.GameSettings.OwningPlayerId));
            OnlineSub.GameInterface.AddJoinOnlineGameCompleteDelegate(OnJoinTravelToSessionComplete);
            OnlineSub.GameInterface.JoinOnlineGame(byte(LP.ControllerId), SessionName, SessionToJoin);
        }
    }
}

exec function PathClear()
{
    Pawn.ClearPathStep();
}

exec function PathChild(optional int Cnt)
{
    Pawn.IncrementPathChild(Max(1, Cnt), myHUD.Canvas);
}

exec function PathStep(optional int Cnt)
{
    Pawn.IncrementPathStep(Max(1, Cnt), myHUD.Canvas);
}

event SoakPause(Pawn P)
{
    LogInternal("Soak pause by " $ string(P));
    SetViewTarget(P);
    SetPause(true);
    myHUD.bShowDebugInfo = true;
}

function IncrementNumberOfMatchesPlayed()
{
    LogInternal("  Num Matches Played: " $ string(PlayerReplicationInfo.AutomatedTestingData.NumberOfMatchesPlayed));
    PlayerReplicationInfo.AutomatedTestingData.NumberOfMatchesPlayed++;
}

function bool CanViewUserCreatedContent()
{
    local LocalPlayer LocPlayer;
    
    LocPlayer = LocalPlayer(Player);
    if (LocPlayer != none && OnlineSub != none && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
    {
        return OnlineSub.PlayerInterface.CanDownloadUserContent(byte(LocPlayer.ControllerId)) == 2;
    }
    return true;
}

reliable client simulated function ClientEndOnlineGame()
{
    local OnlineGameSettings GameSettings;
    
    if (OnlineSub != none && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)) && IsPrimaryPlayer())
    {
        GameSettings = OnlineSub.GameInterface.GetGameSettings(PlayerReplicationInfo.SessionName);
        if (GameSettings != none && GameSettings.GameState == 3)
        {
            OnlineSub.GameInterface.EndOnlineGame(PlayerReplicationInfo.SessionName);
        }
    }
}

reliable client simulated function ClientStartOnlineGame()
{
    local OnlineGameSettings GameSettings;
    
    if (OnlineSub != none && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)) && IsPrimaryPlayer())
    {
        GameSettings = OnlineSub.GameInterface.GetGameSettings(PlayerReplicationInfo.SessionName);
        if (GameSettings != none && GameSettings.GameState == 1 || GameSettings.GameState == 5)
        {
            OnlineSub.GameInterface.StartOnlineGame(PlayerReplicationInfo.SessionName);
        }
    }
}

reliable server function ServerRegisterClientStatGuid(string StatGuid)
{
    if (OnlineSub != none && NotEqual_InterfaceInterface(OnlineSub.StatsInterface, OnlineStatsInterface(none)))
    {
        OnlineSub.StatsInterface.RegisterStatGuid(PlayerReplicationInfo.UniqueId, StatGuid);
    }
}

function OnRegisterHostStatGuidComplete(bool bWasSuccessful)
{
    local string StatGuid;
    
    OnlineSub.StatsInterface.ClearRegisterHostStatGuidCompleteDelegateDelegate(OnRegisterHostStatGuidComplete);
    if (bWasSuccessful)
    {
        StatGuid = OnlineSub.StatsInterface.GetClientStatGuid();
        ServerRegisterClientStatGuid(StatGuid);
    }
}

reliable client simulated function ClientRegisterHostStatGuid(string StatGuid)
{
    if (OnlineSub != none && NotEqual_InterfaceInterface(OnlineSub.StatsInterface, OnlineStatsInterface(none)))
    {
        OnlineSub.StatsInterface.AddRegisterHostStatGuidCompleteDelegate(OnRegisterHostStatGuidComplete);
        if (OnlineSub.StatsInterface.RegisterHostStatGuid(StatGuid) == false)
        {
            OnRegisterHostStatGuidComplete(false);
        }
    }
}

reliable client final simulated event RemoveAllDebugStrings()
{
    DebugTextList.Length = 0;
}

reliable client final simulated event RemoveDebugText(Actor SrcActor)
{
    local int Idx;
    
    Idx = DebugTextList.Find('SrcActor', SrcActor);
    if (Idx != -1)
    {
        DebugTextList.Remove(Idx, 1);
    }
}

reliable client final simulated event AddDebugText(string DebugText, optional Actor SrcActor, optional float Duration = -1.0, optional Vector Offset, optional Vector DesiredOffset, optional Color TextColor, optional bool bSkipOverwriteCheck, optional bool bAbsoluteLocation)
{
    local int Idx;
    
    if (TextColor.R == 0 && TextColor.G == 0 && TextColor.B == 0 && TextColor.A == 0)
    {
        TextColor.R = 255;
        TextColor.G = 255;
        TextColor.B = 255;
        TextColor.A = 255;
    }
    if (SrcActor != none)
    {
        if (Len(DebugText) == 0)
        {
            RemoveDebugText(SrcActor);
        }
        else
        {
            if (!bSkipOverwriteCheck)
            {
                Idx = DebugTextList.Find('SrcActor', SrcActor);
                if (Idx == -1)
                {
                    Idx = DebugTextList.Length;
                    DebugTextList.Length = Idx + 1;
                }
            }
            else
            {
                Idx = DebugTextList.Length;
                DebugTextList.Length = Idx + 1;
            }
            DebugTextList[Idx].SrcActor = SrcActor;
            DebugTextList[Idx].SrcActorOffset = Offset;
            DebugTextList[Idx].SrcActorDesiredOffset = DesiredOffset;
            DebugTextList[Idx].DebugText = DebugText;
            DebugTextList[Idx].TimeRemaining = Duration;
            DebugTextList[Idx].Duration = Duration;
            DebugTextList[Idx].TextColor = TextColor;
            DebugTextList[Idx].bAbsoluteLocation = bAbsoluteLocation;
        }
    }
}

final simulated function DrawDebugTextList(Canvas Canvas, float RenderDelta)
{
    local Vector cameraLoc, ScreenLoc, Offset, WorldTextLoc;
    local Rotator cameraRot;
    local int Idx;
    
    if (DebugTextList.Length > 0)
    {
        GetPlayerViewPoint(cameraLoc, cameraRot);
        Canvas.SetDrawColor(255, 255, 255);
        Canvas.Font = class'Engine'.static.GetSmallFont();
        for (Idx = 0; Idx < DebugTextList.Length; Idx++)
        {
            if (DebugTextList[Idx].SrcActor == none)
            {
                DebugTextList.Remove(Idx--, 1);
                continue;
            }
            if (DebugTextList[Idx].TimeRemaining != -1.0)
            {
                DebugTextList[Idx].TimeRemaining -= RenderDelta;
                if (DebugTextList[Idx].TimeRemaining <= 0.0)
                {
                    DebugTextList.Remove(Idx--, 1);
                    continue;
                }
            }
            if (DebugTextList[Idx].bAbsoluteLocation)
            {
                WorldTextLoc = VLerp(DebugTextList[Idx].SrcActorOffset, DebugTextList[Idx].SrcActorDesiredOffset, 1.0 - DebugTextList[Idx].TimeRemaining / DebugTextList[Idx].Duration);
            }
            else
            {
                Offset = VLerp(DebugTextList[Idx].SrcActorOffset, DebugTextList[Idx].SrcActorDesiredOffset, 1.0 - DebugTextList[Idx].TimeRemaining / DebugTextList[Idx].Duration);
                WorldTextLoc = DebugTextList[Idx].SrcActor.Location + (Offset >> cameraRot);
            }
            if ((WorldTextLoc - cameraLoc) Dot vector(cameraRot) > 0.0)
            {
                ScreenLoc = Canvas.Project(WorldTextLoc);
                Canvas.SetPos(ScreenLoc.X, ScreenLoc.Y);
                Canvas.DrawColor = DebugTextList[Idx].TextColor;
                Canvas.DrawText(DebugTextList[Idx].DebugText);
            }
        }
    }
}

exec function SendToConsole(string Command)
{
    if (LocalPlayer(Player) != none)
    {
        LocalPlayer(Player).ViewportClient.ViewportConsole.ConsoleCommand(Command);
    }
}

exec function ConsoleKey(name Key)
{
    if (LocalPlayer(Player) != none)
    {
        LocalPlayer(Player).ViewportClient.ViewportConsole.InputKey(0, Key, 0);
    }
}

simulated function OnDestroy(SeqAct_Destroy Action)
{
    Action.ScriptLog("Cannot use Destroy action on players");
}

reliable client simulated function ClientStartNetworkedVoice()
{
    local LocalPlayer LocPlayer;
    
    LocPlayer = LocalPlayer(Player);
    if (LocPlayer != none && OnlineSub != none && NotEqual_InterfaceInterface(OnlineSub.VoiceInterface, OnlineVoiceInterface(none)))
    {
        OnlineSub.VoiceInterface.StartNetworkedVoice(byte(LocPlayer.ControllerId));
    }
}

reliable client simulated function ClientStopNetworkedVoice()
{
    local LocalPlayer LocPlayer;
    
    LocPlayer = LocalPlayer(Player);
    if (LocPlayer != none && OnlineSub != none && NotEqual_InterfaceInterface(OnlineSub.VoiceInterface, OnlineVoiceInterface(none)))
    {
        OnlineSub.VoiceInterface.StopNetworkedVoice(byte(LocPlayer.ControllerId));
    }
}

reliable client simulated function ClientSetHostUniqueId(UniqueNetId InHostId)
{
}

reliable client simulated function ClientWriteLeaderboardStats(class<OnlineStatsWrite> OnlineStatsWriteClass)
{
}

reliable client simulated function ClientWriteOnlinePlayerScores(int LeaderboardId)
{
    local GameReplicationInfo GRI;
    local int Index;
    local array<OnlinePlayerScore> PlayerScores;
    local UniqueNetId ZeroUniqueId;
    local bool bIsTeamGame;
    local int ScoreIndex;
    
    GRI = WorldInfo.GRI;
    if (GRI != none && OnlineSub != none && NotEqual_InterfaceInterface(OnlineSub.StatsInterface, OnlineStatsInterface(none)))
    {
        bIsTeamGame = (GRI.GameClass != none ? GRI.GameClass.default.default.bTeamGame : false);
        for (Index = 0; Index < GRI.PRIArray.Length; Index++)
        {
            if (GRI.PRIArray[Index].UniqueId != ZeroUniqueId)
            {
                ScoreIndex = PlayerScores.Length;
                PlayerScores.Length = ScoreIndex + 1;
                PlayerScores[ScoreIndex].PlayerID = GRI.PRIArray[Index].UniqueId;
                if (bIsTeamGame)
                {
                    PlayerScores[ScoreIndex].TeamID = GRI.PRIArray[Index].Team.TeamIndex;
                    PlayerScores[ScoreIndex].Score = int(GRI.PRIArray[Index].Team.Score);
                    continue;
                }
                PlayerScores[ScoreIndex].TeamID = Index;
                PlayerScores[ScoreIndex].Score = int(GRI.PRIArray[Index].Score);
            }
        }
        OnlineSub.StatsInterface.WriteOnlinePlayerScores(PlayerReplicationInfo.SessionName, LeaderboardId, PlayerScores);
    }
}

reliable client simulated function ClientArbitratedMatchEnded()
{
    ConsoleCommand("Disconnect");
}

function NotifyNotEnoughSpaceInInvite()
{
    LogInternal("Not enough space for all local players in the game invite");
}

function NotifyNotAllPlayersCanJoinInvite()
{
    LogInternal("Not all local players have permission to join the game invite");
}

function NotifyInviteFailed()
{
    LogInternal("Invite handling failed");
    ClearInviteDelegates();
}

function OnInviteJoinComplete(name SessionName, bool bWasSuccessful)
{
    local string URL, ConnectPassword;
    
    if (bWasSuccessful)
    {
        if (OnlineSub != none && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)))
        {
            if (OnlineSub.GameInterface.GetResolvedConnectString(SessionName, URL))
            {
                if (class'UIRoot'.static.GetDataStoreStringValue("<Registry:ConnectPassword>", ConnectPassword) && ConnectPassword != "")
                {
                    URL $= "?Password=" $ ConnectPassword;
                }
                URL $= "?bIsFromInvite";
                LogInternal("Resulting url is (" $ URL $ ")");
                ClientTravel(URL, 0);
            }
        }
    }
    else
    {
        NotifyInviteFailed();
    }
    ClearInviteDelegates();
    class'UIRoot'.static.SetDataStoreStringValue("<Registry:ConnectPassword>", "");
}

function OnDestroyForInviteComplete(name SessionName, bool bWasSuccessful)
{
    if (bWasSuccessful)
    {
        OnlineSub.GameInterface.AddJoinOnlineGameCompleteDelegate(OnInviteJoinComplete);
        if (!OnlineSub.GameInterface.AcceptGameInvite(byte(LocalPlayer(Player).ControllerId), SessionName))
        {
            OnlineSub.GameInterface.ClearJoinOnlineGameCompleteDelegate(OnInviteJoinComplete);
            NotifyInviteFailed();
        }
    }
    else
    {
        NotifyInviteFailed();
    }
}

function OnEndForInviteComplete(name SessionName, bool bWasSuccessful)
{
    OnlineSub.GameInterface.AddDestroyOnlineGameCompleteDelegate(OnDestroyForInviteComplete);
    OnlineSub.GameInterface.DestroyOnlineGame(SessionName);
}

function ClearInviteDelegates()
{
    OnlineSub.GameInterface.ClearEndOnlineGameCompleteDelegate(OnEndForInviteComplete);
    OnlineSub.GameInterface.ClearDestroyOnlineGameCompleteDelegate(OnDestroyForInviteComplete);
    OnlineSub.GameInterface.ClearJoinOnlineGameCompleteDelegate(OnInviteJoinComplete);
}

function bool CanAllPlayersPlayOnline()
{
    local PlayerController PC;
    local LocalPlayer LocPlayer;
    
    foreach LocalPlayerControllers(class'PlayerController', PC)
    {
        LocPlayer = LocalPlayer(PC.Player);
        if (LocPlayer != none)
        {
            if (OnlineSub.PlayerInterface.GetLoginStatus(byte(LocPlayer.ControllerId)) != 2 || OnlineSub.PlayerInterface.CanPlayOnline(byte(LocPlayer.ControllerId)) == 0)
            {
                return false;
            }
            continue;
        }
        return false;
    }
    return true;
}

function bool InviteHasEnoughSpace(OnlineGameSettings InviteSettings)
{
    local int NumLocalPlayers;
    local PlayerController PC;
    
    foreach LocalPlayerControllers(class'PlayerController', PC)
    {
        NumLocalPlayers++;
    }
    return InviteSettings.NumOpenPrivateConnections + InviteSettings.NumOpenPublicConnections >= NumLocalPlayers;
}

function OnGameInviteAccepted(out const OnlineGameSearchResult InviteResult)
{
    local OnlineGameSettings GameInviteSettings;
    
    if (OnlineSub != none && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)))
    {
        GameInviteSettings = InviteResult.GameSettings;
        if (GameInviteSettings != none)
        {
            if (InviteHasEnoughSpace(GameInviteSettings))
            {
                if (CanAllPlayersPlayOnline())
                {
                    if (WorldInfo.NetMode != 0)
                    {
                        if (OnlineSub.GameInterface.GetGameSettings('Game').bUsesArbitration)
                        {
                            ClientWriteOnlinePlayerScores(WorldInfo.GRI.GameClass != none ? WorldInfo.GRI.GameClass.default.default.ArbitratedLeaderboardId : 0);
                        }
                        OnlineSub.GameInterface.AddEndOnlineGameCompleteDelegate(OnEndForInviteComplete);
                        OnlineSub.GameInterface.EndOnlineGame('Game');
                    }
                    else
                    {
                        OnlineSub.GameInterface.AddJoinOnlineGameCompleteDelegate(OnInviteJoinComplete);
                        if (!OnlineSub.GameInterface.AcceptGameInvite(byte(LocalPlayer(Player).ControllerId), 'Game'))
                        {
                            OnlineSub.GameInterface.ClearJoinOnlineGameCompleteDelegate(OnInviteJoinComplete);
                            NotifyInviteFailed();
                        }
                    }
                }
                else
                {
                    NotifyNotAllPlayersCanJoinInvite();
                }
            }
            else
            {
                NotifyNotEnoughSpaceInInvite();
            }
        }
        else
        {
            NotifyInviteFailed();
        }
    }
}

reliable server function ServerRegisteredForArbitration(bool bWasSuccessful)
{
    WorldInfo.Game.ProcessClientRegistrationCompletion(self, bWasSuccessful);
}

function OnArbitrationRegisterComplete(name SessionName, bool bWasSuccessful)
{
    OnlineSub.GameInterface.ClearArbitrationRegistrationCompleteDelegate(OnArbitrationRegisterComplete);
    ServerRegisteredForArbitration(bWasSuccessful);
}

reliable client simulated function ClientRegisterForArbitration()
{
    if (OnlineSub != none && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)))
    {
        OnlineSub.GameInterface.AddArbitrationRegistrationCompleteDelegate(OnArbitrationRegisterComplete);
        OnlineSub.GameInterface.RegisterForArbitration('Game');
    }
    else
    {
        ServerRegisteredForArbitration(true);
    }
}

reliable client simulated event ClientWasKicked()
{
}

native simulated function bool IsShowingSubtitles()
{
}

native simulated exec function SetRenderSubtitles(bool bValue)
{
    bValue;
}

native simulated exec function SetShowSubtitles(bool bValue)
{
    bValue;
}

event NotifyDirectorControl(bool bNowControlling)
{
    if (!bNowControlling && WorldInfo.NetMode == 3 && bClientSimulatingViewTarget)
    {
        ServerVerifyViewTarget();
    }
}

reliable server event ServerUnmutePlayer(UniqueNetId PlayerNetId)
{
    local PlayerController Other;
    local int RemoveIndex;
    
    RemoveIndex = VoiceMuteList.Find('Uid', PlayerNetId.Uid);
    if (RemoveIndex != -1)
    {
        VoiceMuteList.Remove(RemoveIndex, 1);
    }
    Other = GetPlayerControllerFromNetId(PlayerNetId);
    if (Other != none)
    {
        if (GameplayVoiceMuteList.Find('Uid', PlayerNetId.Uid) == -1 && Other.VoiceMuteList.Find('Uid', PlayerReplicationInfo.UniqueId.Uid) == -1)
        {
            ClientUnmutePlayer(PlayerNetId);
        }
        if (Other.VoiceMuteList.Find('Uid', PlayerReplicationInfo.UniqueId.Uid) == -1 && Other.GameplayVoiceMuteList.Find('Uid', PlayerReplicationInfo.UniqueId.Uid) == -1)
        {
            RemoveIndex = VoicePacketFilter.Find('Uid', PlayerNetId.Uid);
            if (RemoveIndex != -1)
            {
                VoicePacketFilter.Remove(RemoveIndex, 1);
            }
            RemoveIndex = Other.VoicePacketFilter.Find('Uid', PlayerReplicationInfo.UniqueId.Uid);
            if (RemoveIndex != -1)
            {
                Other.VoicePacketFilter.Remove(RemoveIndex, 1);
            }
            Other.ClientUnmutePlayer(PlayerReplicationInfo.UniqueId);
        }
    }
}

reliable server event ServerMutePlayer(UniqueNetId PlayerNetId)
{
    local PlayerController Other;
    
    if (VoiceMuteList.Find('Uid', PlayerNetId.Uid) == -1)
    {
        VoiceMuteList.AddItem(PlayerNetId);
    }
    if (VoicePacketFilter.Find('Uid', PlayerNetId.Uid) == -1)
    {
        VoicePacketFilter.AddItem(PlayerNetId);
    }
    ClientMutePlayer(PlayerNetId);
    Other = GetPlayerControllerFromNetId(PlayerNetId);
    if (Other != none)
    {
        if (Other.VoicePacketFilter.Find('Uid', PlayerReplicationInfo.UniqueId.Uid) == -1)
        {
            Other.VoicePacketFilter.AddItem(PlayerReplicationInfo.UniqueId);
        }
        Other.ClientMutePlayer(PlayerReplicationInfo.UniqueId);
    }
}

function GameplayUnmutePlayer(UniqueNetId PlayerNetId)
{
    local int RemoveIndex;
    local PlayerController Other;
    
    RemoveIndex = GameplayVoiceMuteList.Find('Uid', PlayerNetId.Uid);
    if (RemoveIndex != -1)
    {
        GameplayVoiceMuteList.Remove(RemoveIndex, 1);
    }
    Other = GetPlayerControllerFromNetId(PlayerNetId);
    if (Other != none)
    {
        if (VoiceMuteList.Find('Uid', PlayerNetId.Uid) == -1 && Other.VoiceMuteList.Find('Uid', PlayerReplicationInfo.UniqueId.Uid) == -1)
        {
            RemoveIndex = VoicePacketFilter.Find('Uid', PlayerNetId.Uid);
            if (RemoveIndex != -1)
            {
                VoicePacketFilter.Remove(RemoveIndex, 1);
            }
            ClientUnmutePlayer(PlayerNetId);
        }
    }
}

function GameplayMutePlayer(UniqueNetId PlayerNetId)
{
    if (GameplayVoiceMuteList.Find('Uid', PlayerNetId.Uid) == -1)
    {
        GameplayVoiceMuteList.AddItem(PlayerNetId);
    }
    if (VoicePacketFilter.Find('Uid', PlayerNetId.Uid) == -1)
    {
        VoicePacketFilter.AddItem(PlayerNetId);
    }
    ClientMutePlayer(PlayerNetId);
}

reliable client simulated event ClientUnmutePlayer(UniqueNetId PlayerNetId)
{
    local LocalPlayer LocPlayer;
    
    if (NotEqual_InterfaceInterface(VoiceInterface, OnlineVoiceInterface(none)))
    {
        LocPlayer = LocalPlayer(Player);
        if (LocPlayer != none)
        {
            VoiceInterface.UnmuteRemoteTalker(byte(LocPlayer.ControllerId), PlayerNetId);
        }
    }
}

reliable client simulated event ClientMutePlayer(UniqueNetId PlayerNetId)
{
    local LocalPlayer LocPlayer;
    
    if (NotEqual_InterfaceInterface(VoiceInterface, OnlineVoiceInterface(none)))
    {
        LocPlayer = LocalPlayer(Player);
        if (LocPlayer != none)
        {
            VoiceInterface.MuteRemoteTalker(byte(LocPlayer.ControllerId), PlayerNetId);
        }
    }
}

reliable client simulated function ClientVoiceHandshakeComplete()
{
    bHasVoiceHandshakeCompleted = true;
}

native static function PlayerController GetPlayerControllerFromNetId(UniqueNetId PlayerNetId)
{
    PlayerNetId;
}

reliable client simulated function ClientSetOnlineStatus()
{
}

function SeamlessTravelFrom(PlayerController OldPC)
{
    OldPC.PlayerReplicationInfo.Reset();
    OldPC.PlayerReplicationInfo.SeamlessTravelTo(PlayerReplicationInfo);
    OldPC.bIsPlayer = false;
    OldPC.PlayerReplicationInfo.Destroy();
    OldPC.PlayerReplicationInfo = none;
}

function SeamlessTravelTo(PlayerController NewPC)
{
}

event GetSeamlessTravelActorList(bool bToEntry, out array<Actor> ActorList)
{
    HearSoundActiveComponents.Length = 0;
    HearSoundPoolComponents.Length = 0;
    if (myHUD != none)
    {
        ActorList[ActorList.Length] = myHUD;
        if (myHUD.ScoreBoard != none)
        {
            ActorList[ActorList.Length] = myHUD.ScoreBoard;
        }
    }
}

native final function bool IsPlayerMuted(out const UniqueNetId Sender)
{
    Sender;
}

final function UIInteraction GetUIController()
{
    local LocalPlayer LP;
    local UIInteraction Result;
    
    LP = LocalPlayer(Player);
    if (LP != none && LP.ViewportClient != none)
    {
        Result = LP.ViewportClient.UIController;
    }
    return Result;
}

exec function SaveActorConfig(coerce name actorName)
{
    local Actor ChkActor;
    
    LogInternal("SaveActorConfig:" @ string(actorName));
    foreach AllActors(class'Actor', ChkActor)
    {
        if (ChkActor != none && ChkActor.Name == actorName)
        {
            LogInternal("- Saving config on:" @ string(ChkActor));
            ChkActor.SaveConfig();
        }
    }
}

exec function SaveClassConfig(coerce string ClassName)
{
    local class<Object> saveClass;
    
    LogInternal("SaveClassConfig:" @ ClassName);
    saveClass = class<Object>(DynamicLoadObject(ClassName, class'Core.Class'));
    if (saveClass != none)
    {
        LogInternal("- Saving config on:" @ string(saveClass));
        saveClass.static.StaticSaveConfig();
    }
    else
    {
        LogInternal("- Failed to find class:" @ ClassName);
    }
}

reliable client simulated event ClientSetBlockOnAsyncLoading()
{
    WorldInfo.bRequestedBlockOnAsyncLoading = true;
}

native reliable client final simulated event ClientFlushLevelStreaming()
{
}

reliable client simulated event ClientCancelPendingMapChange()
{
    WorldInfo.CancelPendingMapChange();
}

reliable client simulated event ClientCommitMapChange()
{
    if (IsTimerActive('DelayedPrepareMapChange'))
    {
        SetTimer(0.01, false, 'ClientCommitMapChange');
    }
    else
    {
        if (Pawn != none)
        {
            SetViewTarget(Pawn);
        }
        else
        {
            SetViewTarget(self);
        }
        WorldInfo.CommitMapChange();
    }
}

function DelayedPrepareMapChange()
{
    if (WorldInfo.IsPreparingMapChange())
    {
        SetTimer(0.01, false, 'DelayedPrepareMapChange');
    }
    else
    {
        WorldInfo.PrepareMapChange(PendingMapChangeLevelNames);
    }
}

reliable client simulated event ClientPrepareMapChange(name LevelName, bool bFirst, bool bLast)
{
    local PlayerController PC;
    
    foreach LocalPlayerControllers(class'PlayerController', PC)
    {
        if (PC != self)
        {
            return;
            continue;
        }
        break;
    }
    if (bFirst)
    {
        PendingMapChangeLevelNames.Length = 0;
        ClearTimer('DelayedPrepareMapChange');
    }
    PendingMapChangeLevelNames[PendingMapChangeLevelNames.Length] = LevelName;
    if (bLast)
    {
        DelayedPrepareMapChange();
    }
}

native reliable server final event ServerUpdateLevelVisibility(name PackageName, bool bIsVisible)
{
    PackageName;
    bIsVisible;
}

native reliable client simulated function ClientUpdateLevelStreamingStatus(name PackageName, bool bNewShouldBeLoaded, bool bNewShouldBeVisible, bool bNewShouldBlockOnLoad)
{
    PackageName;
    bNewShouldBeLoaded;
    bNewShouldBeVisible;
    bNewShouldBlockOnLoad;
}

final event LevelStreamingStatusChanged(LevelStreaming LevelObject, bool bNewShouldBeLoaded, bool bNewShouldBeVisible, bool bNewShouldBlockOnLoad)
{
    ClientUpdateLevelStreamingStatus(LevelObject.PackageName, bNewShouldBeLoaded, bNewShouldBeVisible, bNewShouldBlockOnLoad);
}

reliable client simulated event ClientForceGarbageCollection()
{
    WorldInfo.ForceGarbageCollection();
}

function OnConsoleCommand(SeqAct_ConsoleCommand inAction)
{
    local string Command;
    
    foreach inAction.Commands(Command)
    {
        if (!(Left(Command, 4) ~= "set ") && !(Left(Command, 9) ~= "setnopec "))
        {
            ConsoleCommand(Command);
        }
    }
}

function ResetPlayerMovementInput()
{
    bIgnoreMoveInput = default.bIgnoreMoveInput;
    bIgnoreLookInput = default.bIgnoreLookInput;
}

event bool IsLookInputIgnored()
{
    return bIgnoreLookInput > 0;
}

function IgnoreLookInput(bool bNewLookInput)
{
    bIgnoreLookInput = byte(Max(int(bIgnoreLookInput) + (bNewLookInput ? 1 : -1), 0));
}

event bool IsMoveInputIgnored()
{
    return bIgnoreMoveInput > 0;
}

function FroceResetIgnoreMoveInput()
{
    bIgnoreMoveInput = 0;
}

function IgnoreMoveInput(bool bNewMoveInput)
{
    bIgnoreMoveInput = byte(Max(int(bIgnoreMoveInput) + (bNewMoveInput ? 1 : -1), 0));
}

reliable client simulated function ClientSetCinematicMode(bool bInCinematicMode, bool bAffectsMovement, bool bAffectsTurning, bool bAffectsHUD, bool bHideCurrenWeapon)
{
    bCinematicMode = bInCinematicMode;
    if (myHUD != none && bAffectsHUD)
    {
        myHUD.bShowHUD = !bCinematicMode;
    }
    if (bAffectsMovement)
    {
        IgnoreMoveInput(bCinematicMode);
    }
    if (bAffectsTurning)
    {
        IgnoreLookInput(bCinematicMode);
    }
}

function SetCinematicMode(bool bInCinematicMode, bool bHidePlayer, bool bAffectsHUD, bool bAffectsMovement, bool bAffectsTurning, bool bAffectsButtons, bool bHideCurrenWeapon, bool bPauseClockBomb)
{
    local bool bAdjustMoveInput, bAdjustLookInput;
    
    bCinematicMode = bInCinematicMode;
    if (bCinematicMode)
    {
        if (Pawn != none && bHidePlayer)
        {
            Pawn.SetHidden(true);
        }
    }
    else if (Pawn != none)
    {
        Pawn.SetHidden(false);
    }
    bAdjustMoveInput = bAffectsMovement && bCinematicMode != bCinemaDisableInputMove;
    bAdjustLookInput = bAffectsTurning && bCinematicMode != bCinemaDisableInputLook;
    if (bAdjustMoveInput)
    {
        IgnoreMoveInput(bCinematicMode);
        bCinemaDisableInputMove = bCinematicMode;
    }
    if (bAdjustLookInput)
    {
        IgnoreLookInput(bCinematicMode);
        bCinemaDisableInputLook = bCinematicMode;
    }
    ClientSetCinematicMode(bCinematicMode, bAdjustMoveInput, bAdjustLookInput, bAffectsHUD, bHideCurrenWeapon);
}

function OnToggleCinematicMode(SeqAct_ToggleCinematicMode Action)
{
    local bool bNewCinematicMode;
    
    if (Role < 3)
    {
        WarnInternal("Not supported on client");
        return;
    }
    if (Action.InputLinks[0].bHasImpulse)
    {
        bNewCinematicMode = true;
    }
    else if (Action.InputLinks[1].bHasImpulse)
    {
        bNewCinematicMode = false;
    }
    else if (Action.InputLinks[2].bHasImpulse)
    {
        bNewCinematicMode = !bCinematicMode;
    }
    SetCinematicMode(bNewCinematicMode, Action.bHidePlayer, Action.bHideHUD, Action.bDisableMovement, Action.bDisableTurning, Action.bDisableInput, Action.bHideCurrentWeapon, Action.bPauseClockBomb);
}

simulated function bool IsForceFeedbackAllowed()
{
    return ForceFeedbackManager != none && ForceFeedbackManager.bAllowsForceFeedback;
}

reliable client final simulated event ClientStopForceFeedbackWaveform(optional ForceFeedbackWaveform FFWaveform)
{
    if (ForceFeedbackManager != none)
    {
        ForceFeedbackManager.StopForceFeedbackWaveform(FFWaveform);
    }
}

reliable client simulated event ClientPlayForceFeedbackWaveform(ForceFeedbackWaveform FFWaveform)
{
    if (PlayerInput != none && !PlayerInput.bUsingGamepad && !WorldInfo.IsConsoleBuild(1))
    {
        return;
    }
    if (ForceFeedbackManager != none && PlayerReplicationInfo != none && IsForceFeedbackAllowed())
    {
        ForceFeedbackManager.PlayForceFeedbackWaveform(FFWaveform);
    }
}

event PlayRumble(const AnimNotify_Rumble TheAnimNotify)
{
    if (TheAnimNotify.PredefinedWaveForm != none)
    {
        ClientPlayForceFeedbackWaveform(TheAnimNotify.PredefinedWaveForm.default.default.TheWaveForm);
    }
    else
    {
        ClientPlayForceFeedbackWaveform(TheAnimNotify.WaveForm);
    }
}

function OnForceFeedback(SeqAct_ForceFeedback Action)
{
    if (Action.InputLinks[0].bHasImpulse)
    {
        ClientPlayForceFeedbackWaveform(Action.FFWaveform);
    }
    else if (Action.InputLinks[1].bHasImpulse)
    {
        ClientStopForceFeedbackWaveform(Action.FFWaveform);
    }
}

function NotifyTakeHit(Controller InstigatedBy, Vector HitLocation, int Damage, class<DamageType> DamageType, Vector Momentum)
{
    NotifyTakeHit(InstigatedBy, HitLocation, Damage, DamageType, Momentum);
    ClientPlayForceFeedbackWaveform(DamageType.default.default.DamagedFFWaveform);
}

exec function ShowGameState()
{
    if (WorldInfo.Game != none)
    {
        LogInternal("(" $ string(Name) $ ") PlayerController::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) $ ": Dumping state stack for" @ string(WorldInfo.Game));
        WorldInfo.Game.DumpStateStack();
    }
    else
    {
        LogInternal("(" $ string(Name) $ ") PlayerController::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) $ ": No GameInfo found!");
    }
}

exec function ShowPlayerState()
{
    LogInternal("Dumping state stack for" @ string(self));
    DumpStateStack();
}

unreliable server function ServerRemoteEvent(name EventName)
{
    local array<SequenceObject> AllRemoteEvents;
    local SeqEvent_RemoteEvent RemoteEvt;
    local Sequence GameSeq;
    local int Idx;
    local bool bFoundEvt;
    
    GameSeq = WorldInfo.GetGameSequence();
    if (GameSeq != none)
    {
        GameSeq.FindSeqObjectsByClass(class'SeqEvent_RemoteEvent', true, AllRemoteEvents);
        if (EventName != 'None')
        {
            for (Idx = 0; Idx < AllRemoteEvents.Length; Idx++)
            {
                RemoteEvt = SeqEvent_RemoteEvent(AllRemoteEvents[Idx]);
                if (RemoteEvt != none && EventName == RemoteEvt.EventName)
                {
                    bFoundEvt = true;
                    RemoteEvt.CheckActivate(self, Pawn);
                }
            }
        }
    }
    if (!bFoundEvt)
    {
        LogInternal("Remote events:");
        ClientMessage("Remote events:", , 15.0);
        for (Idx = 0; Idx < AllRemoteEvents.Length; Idx++)
        {
            RemoteEvt = SeqEvent_RemoteEvent(AllRemoteEvents[Idx]);
            if (RemoteEvt != none && RemoteEvt.bEnabled)
            {
                LogInternal("-" @ string(RemoteEvt.EventName));
                ClientMessage("-" @ string(RemoteEvt.EventName), , 15.0);
            }
        }
    }
}

exec function RE(optional name EventName)
{
    ServerRemoteEvent(EventName);
}

exec function RemoteEvent(optional name EventName)
{
    ServerRemoteEvent(EventName);
}

exec function ListCE()
{
    ListConsoleEvents();
}

exec function ListConsoleEvents()
{
    local array<SequenceObject> ConsoleEvents;
    local SeqEvent_Console ConsoleEvt;
    local Sequence GameSeq;
    local int Idx;
    
    GameSeq = WorldInfo.GetGameSequence();
    if (GameSeq != none)
    {
        LogInternal("Console events:");
        ClientMessage("Console events:", , 15.0);
        GameSeq.FindSeqObjectsByClass(class'SeqEvent_Console', true, ConsoleEvents);
        for (Idx = 0; Idx < ConsoleEvents.Length; Idx++)
        {
            ConsoleEvt = SeqEvent_Console(ConsoleEvents[Idx]);
            if (ConsoleEvt != none && ConsoleEvt.bEnabled)
            {
                LogInternal("-" @ string(ConsoleEvt.ConsoleEventName) @ ConsoleEvt.EventDesc);
                ClientMessage("-" @ string(ConsoleEvt.ConsoleEventName) @ ConsoleEvt.EventDesc, , 15.0);
            }
        }
    }
}

exec function CE(optional name EventName)
{
    ServerCauseEvent(EventName);
}

exec function CauseEvent(optional name EventName)
{
    ServerCauseEvent(EventName);
}

unreliable server function ServerCauseEvent(name EventName)
{
    local array<SequenceObject> AllConsoleEvents;
    local SeqEvent_Console ConsoleEvt;
    local Sequence GameSeq;
    local int Idx;
    local bool bFoundEvt;
    
    GameSeq = WorldInfo.GetGameSequence();
    if (GameSeq != none && EventName != 'None')
    {
        GameSeq.FindSeqObjectsByClass(class'SeqEvent_Console', true, AllConsoleEvents);
        for (Idx = 0; Idx < AllConsoleEvents.Length; Idx++)
        {
            ConsoleEvt = SeqEvent_Console(AllConsoleEvents[Idx]);
            if (ConsoleEvt != none && EventName == ConsoleEvt.ConsoleEventName)
            {
                bFoundEvt = true;
                ConsoleEvt.CheckActivate(self, Pawn);
            }
        }
    }
    if (!bFoundEvt)
    {
        ListConsoleEvents();
    }
}

simulated function OnToggleHUD(SeqAct_ToggleHUD inAction)
{
    if (myHUD != none)
    {
        if (inAction.InputLinks[0].bHasImpulse)
        {
            myHUD.bShowHUD = true;
        }
        else if (inAction.InputLinks[1].bHasImpulse)
        {
            myHUD.bShowHUD = false;
        }
        else if (inAction.InputLinks[2].bHasImpulse)
        {
            myHUD.bShowHUD = !myHUD.bShowHUD;
        }
    }
}

simulated function OnSetCameraTargetAdvanced(SeqAct_SetCameraTargetAdvanced inAction)
{
    local Actor RealCameraTarget;
    local ViewTargetTransitionParams TransitionParams;
    
    if (inAction.bIsPlaying)
    {
        TransitionParams = inAction.StartTransitionParams;
    }
    else
    {
        TransitionParams = inAction.EndTransitionParams;
    }
    RealCameraTarget = inAction.CameraTarget;
    if (RealCameraTarget == none)
    {
        RealCameraTarget = (Pawn != none ? Pawn : self);
    }
    else if (RealCameraTarget.IsA('Controller'))
    {
        RealCameraTarget = Controller(RealCameraTarget).Pawn;
    }
    SetViewTarget(RealCameraTarget, TransitionParams);
}

simulated function OnSetCameraTarget(SeqAct_SetCameraTarget inAction)
{
    local Actor RealCameraTarget;
    
    RealCameraTarget = inAction.CameraTarget;
    if (RealCameraTarget == none)
    {
        RealCameraTarget = (Pawn != none ? Pawn : self);
    }
    else if (RealCameraTarget.IsA('Controller'))
    {
        RealCameraTarget = Controller(RealCameraTarget).Pawn;
    }
    SetViewTarget(RealCameraTarget, inAction.TransitionParams);
}

reliable client final simulated function ClientClearKismetText(Vector2D MessageOffset)
{
    local int RemoveIdx;
    
    RemoveIdx = myHUD.KismetTextInfo.Find('MessageOffset', MessageOffset);
    myHUD.KismetTextInfo.Remove(RemoveIdx, 1);
}

reliable client final simulated function ClientDrawKismetText(KismetDrawTextInfo DrawTextInfo, float DisplayTime)
{
    if (DisplayTime > float(0))
    {
        DrawTextInfo.MessageEndTime = WorldInfo.TimeSeconds + DisplayTime;
    }
    else
    {
        DrawTextInfo.MessageEndTime = -1.0;
    }
    myHUD.KismetTextInfo.AddItem(DrawTextInfo);
}

function OnDrawText(SeqAct_DrawText inAction)
{
    if (inAction.InputLinks[0].bHasImpulse)
    {
        ClientDrawKismetText(inAction.DrawTextInfo, inAction.DisplayTimeSeconds);
    }
    else
    {
        ClientClearKismetText(inAction.DrawTextInfo.MessageOffset);
    }
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
    DisplayDebug(HUD, out_YL, out_YPos);
    if (HUD.ShouldDisplayDebug('Camera'))
    {
        if (PlayerCamera != none)
        {
            PlayerCamera.DisplayDebug(HUD, out_YL, out_YPos);
        }
        else
        {
            HUD.Canvas.SetDrawColor(255, 0, 0);
            HUD.Canvas.DrawText("NO CAMERA");
            out_YPos += out_YL;
            HUD.Canvas.SetPos(4.0, out_YPos);
        }
    }
    if (HUD.ShouldDisplayDebug('Input'))
    {
        HUD.Canvas.SetDrawColor(255, 0, 0);
        HUD.Canvas.DrawText("Input ignoremove " $ string(bIgnoreMoveInput) $ " ignore look " $ string(bIgnoreLookInput) $ " aForward " $ string(PlayerInput.aForward));
        out_YPos += out_YL;
        HUD.Canvas.SetPos(4.0, out_YPos);
    }
}

reliable client simulated function ClientIgnoreLookInput(bool bIgnore)
{
    IgnoreLookInput(bIgnore);
}

reliable client simulated function ClientIgnoreMoveInput(bool bIgnore)
{
    IgnoreMoveInput(bIgnore);
}

function OnToggleInput(SeqAct_ToggleInput inAction)
{
    local bool bNewValue;
    
    if (Role < 3)
    {
        WarnInternal("Not supported on client");
        return;
    }
    if (inAction.InputLinks[0].bHasImpulse)
    {
        if (inAction.bToggleMovement)
        {
            IgnoreMoveInput(false);
            ClientIgnoreMoveInput(false);
        }
        if (inAction.bToggleTurning)
        {
            IgnoreLookInput(false);
            ClientIgnoreLookInput(false);
        }
    }
    else if (inAction.InputLinks[1].bHasImpulse)
    {
        if (inAction.bToggleMovement)
        {
            IgnoreMoveInput(true);
            ClientIgnoreMoveInput(true);
        }
        if (inAction.bToggleTurning)
        {
            IgnoreLookInput(true);
            ClientIgnoreLookInput(true);
        }
    }
    else if (inAction.InputLinks[2].bHasImpulse)
    {
        if (inAction.bToggleMovement)
        {
            bNewValue = !IsMoveInputIgnored();
            IgnoreMoveInput(bNewValue);
            ClientIgnoreMoveInput(bNewValue);
        }
        if (inAction.bToggleTurning)
        {
            bNewValue = !IsLookInputIgnored();
            IgnoreLookInput(bNewValue);
            ClientIgnoreLookInput(bNewValue);
        }
    }
}

function DrawHUD(HUD H)
{
    if (Pawn != none)
    {
        Pawn.DrawHUD(H);
    }
    if (PlayerInput != none)
    {
        PlayerInput.DrawHUD(H);
    }
}

function bool CanRestartPlayer()
{
    return PlayerReplicationInfo != none && !PlayerReplicationInfo.bOnlySpectator && HasClientLoadedCurrentWorld();
}

unreliable server function ServerViewSelf(optional ViewTargetTransitionParams TransitionParams)
{
    if (IsSpectating())
    {
        ResetCameraMode();
        SetViewTarget(self, TransitionParams);
        ClientSetViewTarget(self, TransitionParams);
    }
}

function ViewAPlayer(int Dir)
{
    local int I, CurrentIndex, NewIndex;
    local PlayerReplicationInfo PRI;
    local bool bSuccess;
    
    CurrentIndex = -1;
    if (RealViewTarget != none)
    {
        for (I = 0; I < WorldInfo.GRI.PRIArray.Length; I++)
        {
            if (RealViewTarget == WorldInfo.GRI.PRIArray[I])
            {
                CurrentIndex = I;
                break;
            }
        }
    }
    for (NewIndex = CurrentIndex + Dir; NewIndex >= 0 && NewIndex < WorldInfo.GRI.PRIArray.Length; NewIndex = NewIndex + Dir)
    {
        PRI = WorldInfo.GRI.PRIArray[NewIndex];
        if (PRI != none && Controller(PRI.Owner) != none && Controller(PRI.Owner).Pawn != none && WorldInfo.Game.CanSpectate(self, PRI))
        {
            bSuccess = true;
            break;
        }
    }
    if (!bSuccess)
    {
        CurrentIndex = (NewIndex < 0 ? WorldInfo.GRI.PRIArray.Length : -1);
        for (NewIndex = CurrentIndex + Dir; NewIndex >= 0 && NewIndex < WorldInfo.GRI.PRIArray.Length; NewIndex = NewIndex + Dir)
        {
            PRI = WorldInfo.GRI.PRIArray[NewIndex];
            if (PRI != none && Controller(PRI.Owner) != none && Controller(PRI.Owner).Pawn != none && WorldInfo.Game.CanSpectate(self, PRI))
            {
                bSuccess = true;
                break;
            }
        }
    }
    if (bSuccess)
    {
        SetViewTarget(PRI);
    }
}

unreliable server function ServerViewPrevPlayer()
{
    if (IsSpectating())
    {
        ViewAPlayer(-1);
    }
}

unreliable server function ServerViewNextPlayer()
{
    if (IsSpectating())
    {
        ViewAPlayer(1);
    }
}

unreliable server function ServerSetSpectatorLocation(Vector NewLoc)
{
    if (WorldInfo.TimeSeconds != LastSpectatorStateSynchTime)
    {
        ClientGotoState(GetStateName());
        LastSpectatorStateSynchTime = WorldInfo.TimeSeconds;
    }
}

function bool IsSpectating()
{
    return false;
}

function CheckJumpOrDuck()
{
    if (bPressedJump && Pawn != none)
    {
        Pawn.DoJump(bUpdating);
    }
}

function ClearDoubleClick()
{
    if (PlayerInput != none)
    {
        PlayerInput.DoubleClickTimer = 0.0;
    }
}

event Rotator LimitViewRotation(Rotator ViewRotation, float ViewPitchMin, float ViewPitchMax)
{
    ViewRotation.Pitch = ViewRotation.Pitch & 65535;
    if (float(ViewRotation.Pitch) > ViewPitchMax && float(ViewRotation.Pitch) < float(65535) + ViewPitchMin)
    {
        if (ViewRotation.Pitch < 32768)
        {
            ViewRotation.Pitch = int(ViewPitchMax);
        }
        else
        {
            ViewRotation.Pitch = int(float(65535) + ViewPitchMin);
        }
    }
    return ViewRotation;
}

function ProcessViewRotation(float DeltaTime, out Rotator out_ViewRotation, Rotator DeltaRot)
{
    if (PlayerCamera != none)
    {
        PlayerCamera.ProcessViewRotation(DeltaTime, out_ViewRotation, DeltaRot);
    }
    if (Pawn != none)
    {
        Pawn.ProcessViewRotation(DeltaTime, out_ViewRotation, DeltaRot);
    }
    else
    {
        out_ViewRotation += DeltaRot;
        out_ViewRotation = LimitViewRotation(out_ViewRotation, -16384.0, 16383.0);
    }
}

function UpdateRotation(float DeltaTime)
{
    local Rotator DeltaRot, NewRotation, ViewRotation;
    
    ViewRotation = Rotation;
    if (Pawn != none)
    {
        Pawn.SetDesiredRotation(ViewRotation);
    }
    DeltaRot.Yaw = int(PlayerInput.aTurn);
    DeltaRot.Pitch = int(PlayerInput.aLookUp);
    ProcessViewRotation(DeltaTime, ViewRotation, DeltaRot);
    SetRotation(ViewRotation);
    ViewShake(DeltaTime);
    NewRotation = ViewRotation;
    NewRotation.Roll = Rotation.Roll;
    if (Pawn != none)
    {
        Pawn.FaceRotation(NewRotation, DeltaTime);
    }
}

function ViewShake(float DeltaTime)
{
}

simulated event GetPlayerViewPoint(out Vector out_Location, out Rotator out_Rotation)
{
    local Actor TheViewTarget;
    
    if (PlayerCamera == none)
    {
        if (CameraClass != none)
        {
            PlayerCamera = Spawn(CameraClass, self);
            if (PlayerCamera != none)
            {
                PlayerCamera.InitializeFor(self);
            }
            else
            {
                LogInternal("Couldn't Spawn Camera Actor for Player!!");
            }
        }
    }
    if (PlayerCamera != none)
    {
        PlayerCamera.GetCameraViewPoint(out_Location, out_Rotation);
    }
    else
    {
        TheViewTarget = GetViewTarget();
        if (TheViewTarget != none)
        {
            out_Location = TheViewTarget.Location;
            out_Rotation = TheViewTarget.Rotation;
        }
        else
        {
            GetPlayerViewPoint(out_Location, out_Rotation);
        }
    }
}

event SpawnPlayerCamera()
{
    if (CameraClass != none && IsLocalPlayerController())
    {
        PlayerCamera = Spawn(CameraClass, self);
        if (PlayerCamera != none)
        {
            PlayerCamera.InitializeFor(self);
        }
        else
        {
            LogInternal("Couldn't Spawn Camera Actor for Player!!");
        }
    }
}

reliable server function ServerVerifyViewTarget()
{
    local Actor TheViewTarget;
    
    TheViewTarget = GetViewTarget();
    if (TheViewTarget == self)
    {
        return;
    }
    ClientSetViewTarget(TheViewTarget);
}

native function Actor GetViewTarget()
{
}

reliable client simulated event ClientSetViewTarget(Actor A, optional ViewTargetTransitionParams TransitionParams)
{
    if (!bClientSimulatingViewTarget)
    {
        if (A == none)
        {
            ServerVerifyViewTarget();
        }
        SetViewTarget(A, TransitionParams);
    }
}

final function SetViewTargetWithBlend(Actor NewViewTarget, optional float BlendTime = 0.35, optional EViewTargetBlendFunction BlendFunc = 1, optional float BlendExp = 2.0, optional bool bLockOutgoing = false)
{
    local ViewTargetTransitionParams TransitionParams;
    
    TransitionParams.BlendTime = BlendTime;
    TransitionParams.BlendFunction = BlendFunc;
    TransitionParams.BlendExp = BlendExp;
    TransitionParams.bLockOutgoing = bLockOutgoing;
    SetViewTarget(NewViewTarget, TransitionParams);
}

native function CheckViewTargetsBlendingConditions(ViewTargetTransitionParams TransitionParams)
{
    TransitionParams;
}

native function SetViewTarget(Actor NewViewTarget, optional ViewTargetTransitionParams TransitionParams)
{
    NewViewTarget;
    TransitionParams;
}

native function bool IsLocalPlayerController()
{
}

event float GetFOVAngle()
{
    return PlayerCamera != none ? PlayerCamera.GetFOVAngle() : FOVAngle;
}

function AdjustFOV(float DeltaTime)
{
    if (FOVAngle != DesiredFOV)
    {
        if (FOVAngle > DesiredFOV)
        {
            FOVAngle = FOVAngle - FMax(7.0, 0.9 * DeltaTime * (FOVAngle - DesiredFOV));
        }
        else
        {
            FOVAngle = FOVAngle - FMin(-7.0, 0.9 * DeltaTime * (FOVAngle - DesiredFOV));
        }
        if (Abs(FOVAngle - DesiredFOV) <= float(10))
        {
            FOVAngle = DesiredFOV;
        }
    }
}

event bool NotifyLanded(Vector HitNormal, Actor FloorActor)
{
    return bUpdating;
}

function float AimHelpDot(bool bInstantHit)
{
    if (FOVAngle < DefaultFOV - float(8))
    {
        return 0.99;
    }
    if (bInstantHit)
    {
        return 0.97;
    }
    return 0.93;
}

function Rotator GetAdjustedAimFor(Weapon W, Vector StartFireLoc)
{
    local Vector FireDir, AimSpot, HitLocation, HitNormal, OldAim, AimOffset;
    local Actor BestTarget, HitActor;
    local float bestAim, bestDist;
    local bool bNoZAdjust, bInstantHit;
    local Rotator BaseAimRot, AimRot;
    
    bInstantHit = W == none || W.bInstantHit;
    BaseAimRot = (Pawn != none ? Pawn.GetBaseAimRotation() : Rotation);
    FireDir = vector(BaseAimRot);
    HitActor = Trace(HitLocation, HitNormal, StartFireLoc + W.GetTraceRange() * FireDir, StartFireLoc, true);
    if (HitActor != none && HitActor.bProjTarget)
    {
        BestTarget = HitActor;
        bNoZAdjust = true;
        OldAim = HitLocation;
        bestDist = VSize(BestTarget.Location - Pawn.Location);
    }
    else
    {
        bestAim = 0.9;
        if (AimingHelp(bInstantHit))
        {
            bestAim = AimHelpDot(bInstantHit);
        }
        else if (bInstantHit)
        {
            bestAim = 1.0;
        }
        BestTarget = PickTarget(class'Pawn', bestAim, bestDist, FireDir, StartFireLoc, W.WeaponRange);
        if (BestTarget == none)
        {
            return BaseAimRot;
        }
        OldAim = StartFireLoc + FireDir * bestDist;
    }
    ShotTarget = Pawn(BestTarget);
    if (!AimingHelp(bInstantHit))
    {
        return BaseAimRot;
    }
    FireDir = BestTarget.Location - StartFireLoc;
    AimSpot = StartFireLoc + bestDist * Normal(FireDir);
    AimOffset = AimSpot - OldAim;
    if (ShotTarget != none)
    {
        if (bNoZAdjust)
        {
            AimSpot.Z = OldAim.Z;
        }
        else if (AimOffset.Z < float(0))
        {
            AimSpot.Z = ShotTarget.Location.Z + 0.4 * ShotTarget.CylinderComponent.CollisionHeight;
        }
        else
        {
            AimSpot.Z = ShotTarget.Location.Z - 0.7 * ShotTarget.CylinderComponent.CollisionHeight;
        }
    }
    else
    {
        AimSpot.Z = OldAim.Z;
    }
    if (!bNoZAdjust)
    {
        AimRot = rotator(AimSpot - StartFireLoc);
        if (FOVAngle < DefaultFOV - float(8))
        {
            AimRot.Yaw = AimRot.Yaw + 200 - Rand(400);
        }
        else
        {
            AimRot.Yaw = AimRot.Yaw + 375 - Rand(750);
        }
        return AimRot;
    }
    return rotator(AimSpot - StartFireLoc);
}

event CameraLookAtFinished(SeqAct_CameraLookAt Action)
{
}

function bool AimingHelp(bool bInstantHit)
{
    return WorldInfo.NetMode == 0 && bAimingHelp;
}

function PlayerMove(float DeltaTime)
{
}

event PlayerTick(float DeltaTime)
{
    if (!bShortConnectTimeOut)
    {
        bShortConnectTimeOut = true;
        ServerShortTimeout();
    }
    if (Pawn != AcknowledgedPawn)
    {
        if (Role < 3)
        {
            if (AcknowledgedPawn != none && AcknowledgedPawn.Controller == self)
            {
                AcknowledgedPawn.Controller = none;
            }
        }
        AcknowledgePossession(Pawn);
    }
    PlayerInput.PlayerInput(DeltaTime);
    if (bUpdatePosition)
    {
        ClientUpdatePosition();
    }
    PlayerMove(DeltaTime);
    AdjustFOV(DeltaTime);
}

function NotifyChangedWeapon(Weapon PreviousWeapon, Weapon NewWeapon)
{
}

reliable client simulated function ClientGameEnded(Actor EndGameFocus, bool bIsWinner)
{
    SetViewTarget(EndGameFocus);
    GotoState('RoundEnded');
}

function GameHasEnded(optional Actor EndGameFocus, optional bool bIsWinner)
{
    SetViewTarget(EndGameFocus);
    GotoState('RoundEnded');
    ClientGameEnded(EndGameFocus, bIsWinner);
}

reliable client simulated function ClientRestart(Pawn NewPawn)
{
    ResetPlayerMovementInput();
    CleanOutSavedMoves();
    Pawn = NewPawn;
    if (Pawn != none && Pawn.bTearOff)
    {
        UnPossess();
        Pawn = none;
    }
    AcknowledgePossession(Pawn);
    if (Pawn == none)
    {
        GotoState('WaitingForPawn');
        return;
    }
    Pawn.ClientRestart();
    if (Role < 3)
    {
        SetViewTarget(Pawn);
        ResetCameraMode();
        EnterStartState();
    }
    CleanOutSavedMoves();
}

function EnterStartState()
{
    local name NewState;
    
    if (Pawn.PhysicsVolume.bWaterVolume)
    {
        if (Pawn.HeadVolume.bWaterVolume)
        {
            Pawn.BreathTime = Pawn.UnderWaterTime;
        }
        NewState = Pawn.WaterMovementState;
    }
    else
    {
        NewState = Pawn.LandMovementState;
    }
    if (GetStateName() == NewState)
    {
        BeginState(NewState);
    }
    else
    {
        GotoState(NewState);
    }
}

native final function ForceSingleNetUpdateFor(Actor Target)
{
    Target;
}

native final function bool HasClientLoadedCurrentWorld()
{
}

event NotifyLoadedWorld(name WorldPackageName, bool bFinalDest)
{
    local PlayerStart P;
    local Rotator SpawnRotation;
    
    SetViewTarget(self);
    foreach WorldInfo.AllNavigationPoints(class'PlayerStart', P)
    {
        SetLocation(P.Location);
        SpawnRotation.Yaw = P.Rotation.Yaw;
        SetRotation(SpawnRotation);
        break;
    }
}

native reliable server final event ServerNotifyLoadedWorld(name WorldPackageName)
{
    WorldPackageName;
}

function Restart(bool bVehicleTransition)
{
    Restart(bVehicleTransition);
    ServerTimeStamp = 0.0;
    ResetTimeMargin();
    EnterStartState();
    ClientRestart(Pawn);
    SetViewTarget(Pawn);
    ResetCameraMode();
}

reliable client simulated event ClientSetProgressMessage(EProgressMessageType MessageType, string Message, optional string Title, optional bool bIgnoreFutureNetworkMessages)
{
    if (LocalPlayer(Player) != none)
    {
        LocalPlayer(Player).ViewportClient.SetProgressMessage(MessageType, Message, Title, bIgnoreFutureNetworkMessages);
    }
    else
    {
        WarnInternal("Discarded progress message due to no viewport:" @ string(MessageType) @ Message @ Title);
    }
}

exec function SwitchLevel(string URL)
{
    if (WorldInfo.NetMode == 0 || WorldInfo.NetMode == 2)
    {
        WorldInfo.ServerTravel(URL);
    }
}

reliable server function ServerChangeTeam(int N)
{
    local TeamInfo OldTeam;
    
    OldTeam = PlayerReplicationInfo.Team;
    WorldInfo.Game.ChangeTeam(self, N, true);
    if (WorldInfo.Game.bTeamGame && PlayerReplicationInfo.Team != OldTeam)
    {
        if (Pawn != none)
        {
            Pawn.PlayerChangedTeam();
        }
    }
}

exec function ChangeTeam(optional string TeamName)
{
    local int N;
    
    if (TeamName ~= "blue")
    {
        N = 1;
    }
    else if (TeamName ~= "red" || PlayerReplicationInfo == none || PlayerReplicationInfo.Team == none || PlayerReplicationInfo.Team.TeamIndex > 1)
    {
        N = 0;
    }
    else
    {
        N = 1 - PlayerReplicationInfo.Team.TeamIndex;
    }
    ServerChangeTeam(N);
}

exec function SwitchTeam()
{
    if (PlayerReplicationInfo.Team == none || PlayerReplicationInfo.Team.TeamIndex == 1)
    {
        ServerChangeTeam(0);
    }
    else
    {
        ServerChangeTeam(1);
    }
}

reliable server function ServerChangeName(coerce string S)
{
    if (S != "")
    {
        WorldInfo.Game.ChangeName(self, S, true);
    }
}

exec function SetName(coerce string S)
{
    local string NewName;
    local LocalPlayer LocPlayer;
    
    if (S != "")
    {
        LocPlayer = LocalPlayer(Player);
        if (LocPlayer != none && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
        {
            if (OnlineSub.PlayerInterface.GetLoginStatus(byte(LocPlayer.ControllerId)) == 2 && OnlineSub.GameInterface.GetGameSettings('Game') != none)
            {
                S = OnlineSub.PlayerInterface.GetPlayerNickname(byte(LocPlayer.ControllerId));
            }
        }
        NewName = S;
        ServerChangeName(NewName);
        UpdateURL("Name", NewName, true);
        SaveConfig();
    }
}

reliable server function ServerSuicide()
{
    if (Pawn != none && WorldInfo.TimeSeconds - Pawn.LastStartTime > float(10) || WorldInfo.NetMode == 0)
    {
        Pawn.Suicide();
    }
}

exec function Suicide()
{
    ServerSuicide();
}

function bool TriggerInteracted()
{
    local Actor A;
    local int Idx;
    local float Weight;
    local bool bInserted;
    local Vector cameraLoc;
    local Rotator cameraRot;
    local array<Trigger> useList;
    local array<Actor> sortedList;
    local array<float> weightList;
    
    if (Pawn != none)
    {
        GetTriggerUseList(InteractDistance, 60.0, 0.0, true, useList);
        if (useList.Length > 0)
        {
            GetPlayerViewPoint(cameraLoc, cameraRot);
            while (useList.Length > 0)
            {
                A = useList[useList.Length - 1];
                useList.Length = useList.Length - 1;
                Weight = Normal(A.Location - cameraLoc) Dot vector(cameraRot);
                Weight += 1.0 - VSize(A.Location - Pawn.Location) / InteractDistance;
                bInserted = false;
                for (Idx = 0; Idx < sortedList.Length && !bInserted; Idx++)
                {
                    if (weightList[Idx] < Weight)
                    {
                        sortedList.Insert(Idx, 1);
                        weightList.Insert(Idx, 1);
                        sortedList[Idx] = A;
                        weightList[Idx] = Weight;
                        bInserted = true;
                    }
                }
                if (!bInserted)
                {
                    Idx = sortedList.Length;
                    sortedList[Idx] = A;
                    weightList[Idx] = Weight;
                }
            }
            for (Idx = 0; Idx < sortedList.Length; Idx++)
            {
                if (sortedList[Idx].UsedBy(Pawn))
                {
                    return true;
                }
            }
        }
    }
    return false;
}

function bool FindVehicleToDrive()
{
    local Vehicle V, Best;
    local Vector ViewDir, PawnLoc2D, VLoc2D;
    local float NewDot, BestDot;
    
    if (Vehicle(Pawn.Base) != none && Vehicle(Pawn.Base).TryToDrive(Pawn))
    {
        return true;
    }
    PawnLoc2D = Pawn.Location;
    PawnLoc2D.Z = 0.0;
    ViewDir = vector(Pawn.Rotation);
    foreach Pawn.OverlappingActors(class'Vehicle', V, Pawn.VehicleCheckRadius)
    {
        VLoc2D = V.Location;
        VLoc2D.Z = 0.0;
        NewDot = Normal(VLoc2D - PawnLoc2D) Dot ViewDir;
        if (Best == none || NewDot > BestDot)
        {
            if (FastTrace(V.Location, Pawn.Location))
            {
                Best = V;
                BestDot = NewDot;
            }
        }
    }
    return Best != none && Best.TryToDrive(Pawn);
}

function bool PerformedUseAction()
{
    if (WorldInfo.Pauser == PlayerReplicationInfo)
    {
        return true;
    }
    if (Pawn == none)
    {
        return true;
    }
    if (Role < 3)
    {
        return false;
    }
    if (Vehicle(Pawn) != none)
    {
        return Vehicle(Pawn).DriverLeave(false);
    }
    if (FindVehicleToDrive())
    {
        return true;
    }
    return TriggerInteracted();
}

unreliable server function ServerUse()
{
    PerformedUseAction();
}

exec function Use()
{
    if (Role < 3)
    {
        PerformedUseAction();
    }
    ServerUse();
}

function GetTriggerUseList(float interactDistanceToCheck, float crosshairDist, float minDot, bool bUsuableOnly, out array<Trigger> out_useList)
{
    local int Idx;
    local Vector cameraLoc;
    local Rotator cameraRot;
    local Trigger checkTrigger;
    local SeqEvent_Used UseSeq;
    
    if (Pawn != none)
    {
        GetPlayerViewPoint(cameraLoc, cameraRot);
        foreach Pawn.CollidingActors(class'Trigger', checkTrigger, interactDistanceToCheck)
        {
            for (Idx = 0; Idx < checkTrigger.GeneratedEvents.Length; Idx++)
            {
                UseSeq = SeqEvent_Used(checkTrigger.GeneratedEvents[Idx]);
                if (UseSeq != none && !bUsuableOnly || checkTrigger.GeneratedEvents[Idx].CheckActivate(checkTrigger, Pawn, true) && Normal(checkTrigger.Location - cameraLoc) Dot vector(cameraRot) >= minDot && UseSeq.bAimToInteract && IsAimingAt(checkTrigger, 0.98) && VSize(Pawn.Location - checkTrigger.Location) <= UseSeq.InteractDistance || !UseSeq.bAimToInteract && VSize(Pawn.Location - checkTrigger.Location) <= UseSeq.InteractDistance)
                {
                    out_useList[out_useList.Length] = checkTrigger;
                    Idx = checkTrigger.GeneratedEvents.Length;
                }
            }
        }
    }
}

exec function StopAltFire(optional byte FireModeNum)
{
    StopFire(1);
}

exec function StartAltFire(optional byte FireModeNum)
{
    StartFire(1);
}

exec function StopFire(optional byte FireModeNum)
{
    if (WorldInfo.Pauser == PlayerReplicationInfo)
    {
        return;
    }
    if (Pawn != none)
    {
        Pawn.StopFire(FireModeNum);
    }
}

exec function StartFire(optional byte FireModeNum)
{
    if (WorldInfo.Pauser == PlayerReplicationInfo)
    {
        return;
    }
    if (Pawn != none && !bCinematicMode)
    {
        Pawn.StartFire(FireModeNum);
    }
}

exec function NextWeapon()
{
    if (WorldInfo.Pauser != none)
    {
        return;
    }
    if (Pawn.Weapon == none)
    {
        SwitchToBestWeapon();
        return;
    }
    if (Pawn.InvManager != none)
    {
        Pawn.InvManager.NextWeapon();
    }
}

exec function PrevWeapon()
{
    if (WorldInfo.Pauser != none)
    {
        return;
    }
    if (Pawn.Weapon == none)
    {
        SwitchToBestWeapon();
        return;
    }
    if (Pawn.InvManager != none)
    {
        Pawn.InvManager.PrevWeapon();
    }
}

reliable server function ServerThrowWeapon()
{
    if (Pawn.CanThrowWeapon())
    {
        Pawn.ThrowActiveWeapon();
    }
}

exec function ThrowWeapon()
{
    if (Pawn == none || Pawn.Weapon == none)
    {
        return;
    }
    ServerThrowWeapon();
}

exec function UTrace()
{
    ConsoleCommand("hidelog");
    if (Role != 3)
    {
        ServerUTrace();
    }
    SetUTracing(!IsUTracing());
    LogInternal("UTracing changed to " $ string(IsUTracing()) $ " at " $ string(WorldInfo.TimeSeconds), 'UTrace');
}

reliable server function ServerUTrace()
{
    if (WorldInfo.NetMode != 0 && PlayerReplicationInfo == none || !PlayerReplicationInfo.bAdmin)
    {
        return;
    }
    UTrace();
}

event ConditionalPause(bool bDesiredPauseState)
{
    if (bDesiredPauseState != IsPaused())
    {
        SetPause(bDesiredPauseState);
    }
}

exec function ShowMenu()
{
}

reliable server function ServerPause()
{
    if (!IsPaused())
    {
        SetPause(true);
    }
    else
    {
        SetPause(false);
    }
}

exec function Pause()
{
    ServerPause();
}

final simulated function bool IsPaused()
{
    return WorldInfo.Pauser != none;
}

function bool SetPause(bool bPause, optional delegate<CanUnpause> CanUnpauseDelegate = CanUnpause)
{
    local bool bResult;
    
    if (WorldInfo.NetMode != 3)
    {
        if (bPause)
        {
            bFire = 0;
            bResult = WorldInfo.Game.SetPause(self, CanUnpauseDelegate);
            if (bResult)
            {
                PauseRumbleForAllPlayers();
            }
        }
        else
        {
            WorldInfo.Game.ClearPause();
            if (WorldInfo.Pauser == none)
            {
                PauseRumbleForAllPlayers(false);
            }
        }
    }
    return bResult;
}

delegate bool CanUnpause()
{
    return WorldInfo.Pauser == PlayerReplicationInfo;
}

function PauseRumbleForAllPlayers(optional bool bShouldPauseRumble = true)
{
    local PlayerController PC;
    
    foreach LocalPlayerControllers(class'PlayerController', PC)
    {
        if (PC.ForceFeedbackManager != none)
        {
            PC.ForceFeedbackManager.PauseWaveform(bShouldPauseRumble);
        }
    }
}

exec function QuickLoad()
{
    if (WorldInfo.NetMode == 0)
    {
        ConsoleCommand("DEFER LOADGAME QUICKSAVE.SAV");
    }
}

exec function QuickSave()
{
    if (Pawn != none && Pawn.Health > 0 && WorldInfo.NetMode == 0)
    {
        ClientMessage(QuickSaveString);
        ConsoleCommand("DEFER SAVEGAME QUICKSAVE.SAV");
    }
}

exec function LocalTravel(string URL)
{
    if (WorldInfo.NetMode == 0)
    {
        ClientTravel(URL, 2);
    }
}

exec function RestartLevel()
{
    if (WorldInfo.NetMode == 0)
    {
        ClientTravel("?restart", 2);
    }
}

reliable server function ServerSpeech(name Type, int Index, string Callsign)
{
}

exec function Speech(name Type, int Index, string Callsign)
{
    ServerSpeech(Type, Index, Callsign);
}

reliable server function ServerRestartGame()
{
}

function HandleWalking()
{
    if (Pawn != none)
    {
        Pawn.SetWalking(bRun != 0);
    }
}

function CallServerMove(SavedMove NewMove, Vector ClientLoc, byte ClientRoll, int View, SavedMove OldMove)
{
    local Vector BuildAccel;
    local byte OldAccelX, OldAccelY, OldAccelZ;
    
    if (OldMove != none)
    {
        BuildAccel = 0.05 * OldMove.Acceleration + vect(0.5, 0.5, 0.5);
        OldAccelX = byte(CompressAccel(int(BuildAccel.X)));
        OldAccelY = byte(CompressAccel(int(BuildAccel.Y)));
        OldAccelZ = byte(CompressAccel(int(BuildAccel.Z)));
        OldServerMove(OldMove.TimeStamp, OldAccelX, OldAccelY, OldAccelZ, OldMove.CompressedFlags());
    }
    if (PendingMove != none)
    {
        DualServerMove(PendingMove.TimeStamp, PendingMove.Acceleration * float(10), PendingMove.CompressedFlags(), ((PendingMove.Rotation.Yaw & 65535) << 16) + (PendingMove.Rotation.Pitch & 65535), NewMove.TimeStamp, NewMove.Acceleration * float(10), ClientLoc, NewMove.CompressedFlags(), ClientRoll, View);
    }
    else
    {
        ServerMove(NewMove.TimeStamp, NewMove.Acceleration * float(10), ClientLoc, NewMove.CompressedFlags(), ClientRoll, View);
    }
}

function ReplicateMove(float DeltaTime, Vector newAccel, EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
{
    local SavedMove NewMove, OldMove, AlmostLastMove, LastMove;
    local byte ClientRoll;
    local float NetMoveDelta;
    
    if (Player == none)
    {
        return;
    }
    MaxResponseTime = default.MaxResponseTime * WorldInfo.TimeDilation;
    DeltaTime = (Pawn != none ? Pawn.CustomTimeDilation : CustomTimeDilation) * FMin(DeltaTime, MaxResponseTime);
    if (SavedMoves != none)
    {
        LastMove = SavedMoves;
        AlmostLastMove = LastMove;
        OldMove = none;
        while (LastMove.NextMove != none)
        {
            if (OldMove == none && Pawn != none && LastMove.IsImportantMove(LastAckedAccel))
            {
                OldMove = LastMove;
            }
            AlmostLastMove = LastMove;
            LastMove = LastMove.NextMove;
        }
    }
    NewMove = GetFreeMove();
    if (NewMove == none)
    {
        return;
    }
    NewMove.SetMoveFor(self, DeltaTime, newAccel, DoubleClickMove);
    bDoubleJump = false;
    ProcessMove(NewMove.Delta, NewMove.Acceleration, NewMove.DoubleClickMove, DeltaRot);
    if (PendingMove != none && PendingMove.CanCombineWith(NewMove, Pawn, MaxResponseTime))
    {
        Pawn.SetLocation(PendingMove.GetStartLocation());
        Pawn.Velocity = PendingMove.StartVelocity;
        if (PendingMove.StartBase != Pawn.Base)
        {
            Pawn.SetBase(PendingMove.StartBase);
        }
        Pawn.Floor = PendingMove.StartFloor;
        NewMove.Delta += PendingMove.Delta;
        NewMove.SetInitialPosition(Pawn);
        if (LastMove == PendingMove)
        {
            if (SavedMoves == PendingMove)
            {
                SavedMoves.NextMove = FreeMoves;
                FreeMoves = SavedMoves;
                SavedMoves = none;
            }
            else
            {
                PendingMove.NextMove = FreeMoves;
                FreeMoves = PendingMove;
                if (AlmostLastMove != none)
                {
                    AlmostLastMove.NextMove = none;
                    LastMove = AlmostLastMove;
                }
            }
            FreeMoves.Clear();
        }
        PendingMove = none;
    }
    if (Pawn != none)
    {
        Pawn.AutonomousPhysics(NewMove.Delta);
    }
    else
    {
        AutonomousPhysics(DeltaTime);
    }
    NewMove.PostUpdate(self);
    if (SavedMoves == none)
    {
        SavedMoves = NewMove;
    }
    else
    {
        LastMove.NextMove = NewMove;
    }
    if (PendingMove == none)
    {
        if (Player.CurrentNetSpeed > 10000 && WorldInfo.GRI != none && WorldInfo.GRI.PRIArray.Length <= 10)
        {
            NetMoveDelta = 0.011;
        }
        else
        {
            NetMoveDelta = FMax(0.0222, 2.0 * WorldInfo.MoveRepSize / float(Player.CurrentNetSpeed));
        }
        if ((WorldInfo.TimeSeconds - ClientUpdateTime) * WorldInfo.TimeDilation < NetMoveDelta)
        {
            PendingMove = NewMove;
            return;
        }
    }
    ClientUpdateTime = WorldInfo.TimeSeconds;
    ClientRoll = byte(Rotation.Roll >> 8 & 255);
    CallServerMove(NewMove, Pawn == none ? Location : Pawn.Location, ClientRoll, ((Rotation.Yaw & 65535) << 16) + (Rotation.Pitch & 65535), OldMove);
    PendingMove = none;
}

function MoveLog(name FunctionName, string Message, float TimeStamp, optional Vector NewLoc, optional Vector NewVel)
{
    LogInternal(string(Pawn) @ string(FunctionName) @ string(GetStateName()) @ string(TimeStamp) @ Message @ string(Pawn.Location) @ string(Pawn.Velocity) @ string(NewLoc) @ string(NewVel), 'PlayerMove');
}

function int CompressAccel(int C)
{
    if (C >= 0)
    {
        C = Min(C, 127);
    }
    else
    {
        C = Min(int(Abs(float(C))), 127) + 128;
    }
    return C;
}

final function SavedMove GetFreeMove()
{
    local SavedMove S, first;
    local int I;
    
    if (FreeMoves == none)
    {
        S = SavedMoves;
        while (S != none)
        {
            I++;
            if (I > 100)
            {
                first = SavedMoves;
                SavedMoves = SavedMoves.NextMove;
                first.Clear();
                first.NextMove = none;
                while (SavedMoves != none)
                {
                    S = SavedMoves;
                    SavedMoves = SavedMoves.NextMove;
                    S.Clear();
                    S.NextMove = FreeMoves;
                    FreeMoves = S;
                }
                PendingMove = none;
                return first;
            }
            S = S.NextMove;
        }
        return new(self) SavedMoveClass;
    }
    else
    {
        S = FreeMoves;
        FreeMoves = FreeMoves.NextMove;
        S.NextMove = none;
        return S;
    }
}

function ClientUpdatePosition()
{
    local SavedMove CurrentMove;
    local int realbRun, realbDuck;
    local bool bRealJump, bRealPreciseDestination, bRealForceMaxAccel, bRealRootMotionFromInterpCurve;
    local ERootMotionMode RealRootMotionMode;
    local Vector OldLoc;
    
    bUpdatePosition = false;
    if (Pawn != none && Pawn.Physics == 10)
    {
        return;
    }
    if (bDebugClientAdjustPosition)
    {
        LogInternal("(" $ string(Name) $ ") PlayerController::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) @ "!!!!!!!!!!!!!!" @ string(SavedMoves) @ "Pawn.Rotation:'" $ string(Pawn.Rotation) $ "'" @ "WorldInfo.TimeSeconds:'" $ string(WorldInfo.TimeSeconds) $ "'");
    }
    realbRun = int(bRun);
    realbDuck = int(bDuck);
    bRealJump = bPressedJump;
    bUpdating = true;
    bRealPreciseDestination = bPreciseDestination;
    if (Pawn != none)
    {
        bRealForceMaxAccel = Pawn.bForceMaxAccel;
        bRealRootMotionFromInterpCurve = Pawn.bRootMotionFromInterpCurve;
        RealRootMotionMode = Pawn.Mesh.RootMotionMode;
    }
    ClearAckedMoves();
    CurrentMove = SavedMoves;
    while (CurrentMove != none)
    {
        if (PendingMove == CurrentMove && Pawn != none)
        {
            PendingMove.SetInitialPosition(Pawn);
        }
        if (bDebugClientAdjustPosition)
        {
            LogInternal(CurrentMove.GetDebugString());
            LogInternal("Old" @ string(Pawn.Location) @ string(Pawn.bRootMotionFromInterpCurve) @ string(Pawn.RootMotionInterpCurrentTime));
            OldLoc = Pawn.Location;
        }
        CurrentMove.PrepMoveFor(Pawn);
        MoveAutonomous(CurrentMove.Delta, CurrentMove.CompressedFlags(), CurrentMove.Acceleration, rot(0, 0, 0));
        CurrentMove.ResetMoveFor(Pawn);
        if (bDebugClientAdjustPosition)
        {
            LogInternal("New" @ string(Pawn.Location) @ string(Pawn.bRootMotionFromInterpCurve) @ string(Pawn.RootMotionInterpCurrentTime));
            DrawDebugBox(OldLoc, vect(4.0, 4.0, 4.0), 120, 0, 0, true);
            DrawDebugBox(Pawn.Location, vect(5.0, 5.0, 5.0), 0, 0, 120, true);
            DrawDebugLine(OldLoc + vect(0.0, 0.0, 2.0), Pawn.Location + vect(0.0, 0.0, 2.0), 0, 120, 0, true);
        }
        CurrentMove = CurrentMove.NextMove;
    }
    bUpdating = false;
    bDuck = byte(realbDuck);
    bRun = byte(realbRun);
    bPressedJump = bRealJump;
    bPreciseDestination = bRealPreciseDestination;
    if (Pawn != none)
    {
        Pawn.bForceMaxAccel = bRealForceMaxAccel;
        Pawn.bRootMotionFromInterpCurve = bRealRootMotionFromInterpCurve;
        Pawn.Mesh.RootMotionMode = RealRootMotionMode;
    }
}

function ClearAckedMoves()
{
    local SavedMove CurrentMove;
    
    CurrentMove = SavedMoves;
    while (CurrentMove != none)
    {
        if (CurrentMove.TimeStamp <= CurrentTimeStamp)
        {
            if (CurrentMove.TimeStamp == CurrentTimeStamp)
            {
                LastAckedAccel = CurrentMove.Acceleration;
            }
            SavedMoves = CurrentMove.NextMove;
            CurrentMove.NextMove = FreeMoves;
            FreeMoves = CurrentMove;
            FreeMoves.Clear();
            CurrentMove = SavedMoves;
            continue;
        }
        break;
    }
}

unreliable server function ServerUpdatePing(int NewPing)
{
    PlayerReplicationInfo.Ping = byte(Min(int(0.25 * float(NewPing)), 250));
}

function UpdateStateFromAdjustment(name NewState)
{
    if (GetStateName() != NewState)
    {
        GotoState(NewState);
    }
}

unreliable client simulated function LongClientAdjustPosition(float TimeStamp, name NewState, EPhysics newPhysics, float NewLocX, float NewLocY, float NewLocZ, float NewVelX, float NewVelY, float NewVelZ, Actor NewBase, float NewFloorX, float NewFloorY, float NewFloorZ)
{
    local Vector NewLocation, NewVelocity, NewFloor;
    local Actor MoveActor;
    local SavedMove CurrentMove;
    local Actor TheViewTarget;
    local Vector OldLoc;
    
    OldLoc = (Pawn != none ? Pawn.Location : Location);
    UpdatePing(TimeStamp);
    if (Pawn != none)
    {
        if (Pawn.bTearOff)
        {
            Pawn = none;
            if (!GamePlayEndedState() && !IsInState('Dead'))
            {
                GotoState('Dead');
            }
            return;
        }
        MoveActor = Pawn;
        TheViewTarget = GetViewTarget();
        if (TheViewTarget != Pawn && TheViewTarget == self || Pawn(TheViewTarget) != none && Pawn(TheViewTarget).Health <= 0)
        {
            ResetCameraMode();
            SetViewTarget(Pawn);
        }
    }
    else
    {
        MoveActor = self;
        if (GetStateName() != NewState)
        {
            LogInternal("- state change:" @ string(GetStateName()) @ "->" @ string(NewState), 'PlayerMove');
            if (NewState == 'RoundEnded')
            {
                GotoState(NewState);
            }
            else if (IsInState('Dead'))
            {
                if (NewState != 'PlayerWalking' && NewState != 'PlayerSwimming')
                {
                    GotoState(NewState);
                }
                return;
            }
            else if (NewState == 'Dead')
            {
                GotoState(NewState);
            }
        }
    }
    if (CurrentTimeStamp >= TimeStamp)
    {
        return;
    }
    CurrentTimeStamp = TimeStamp;
    NewLocation.X = NewLocX;
    NewLocation.Y = NewLocY;
    NewLocation.Z = NewLocZ;
    NewVelocity.X = NewVelX;
    NewVelocity.Y = NewVelY;
    NewVelocity.Z = NewVelZ;
    CurrentMove = SavedMoves;
    while (CurrentMove != none)
    {
        if (CurrentMove.TimeStamp <= CurrentTimeStamp)
        {
            SavedMoves = CurrentMove.NextMove;
            CurrentMove.NextMove = FreeMoves;
            FreeMoves = CurrentMove;
            if (CurrentMove.TimeStamp == CurrentTimeStamp)
            {
                LastAckedAccel = CurrentMove.Acceleration;
                FreeMoves.Clear();
                if ((InterpActor(NewBase) != none || Vehicle(NewBase) != none) && NewBase == CurrentMove.EndBase)
                {
                    if (GetStateName() == NewState && IsInState('PlayerWalking') && MoveActor.Physics == 1 || MoveActor.Physics == 2)
                    {
                        if (VSizeSq(CurrentMove.SavedRelativeLocation - NewLocation) < 3.0)
                        {
                            CurrentMove = none;
                            return;
                        }
                        else if (Vehicle(NewBase) != none && VSizeSq(Velocity) < 9.0 && VSizeSq(NewVelocity) < 9.0 && VSizeSq(CurrentMove.SavedRelativeLocation - NewLocation) < 900.0)
                        {
                            CurrentMove = none;
                            return;
                        }
                    }
                }
                else if (VSizeSq(CurrentMove.SavedLocation - NewLocation) < 3.0 && VSizeSq(CurrentMove.SavedVelocity - NewVelocity) < 9.0 && GetStateName() == NewState && IsInState('PlayerWalking') && MoveActor.Physics == 1 || MoveActor.Physics == 2)
                {
                    CurrentMove = none;
                    return;
                }
                CurrentMove = none;
            }
            else
            {
                FreeMoves.Clear();
                CurrentMove = SavedMoves;
            }
            continue;
        }
        CurrentMove = none;
    }
    if (MoveActor.bHardAttach)
    {
        if (MoveActor.Base == none)
        {
            if (NewBase != none)
            {
                MoveActor.SetBase(NewBase);
            }
            if (MoveActor.Base == none)
            {
                MoveActor.SetHardAttach(false);
            }
            else
            {
                return;
            }
        }
        else
        {
            return;
        }
    }
    NewFloor.X = NewFloorX;
    NewFloor.Y = NewFloorY;
    NewFloor.Z = NewFloorZ;
    if (MoveActor.Base != NewBase)
    {
        LogInternal("- base mismatch:" @ string(MoveActor.Base) @ string(NewBase), 'PlayerMove');
    }
    if (MoveActor.Location != NewLocation)
    {
        LogInternal("- location mismatch, delta:" @ string(VSize(MoveActor.Location - NewLocation)), 'PlayerMove');
    }
    if (MoveActor.Velocity != NewVelocity)
    {
        LogInternal("- velocity mismatch, delta:" @ string(VSize(NewVelocity - MoveActor.Velocity)) @ "client:" @ string(VSize(MoveActor.Velocity)) @ "server:" @ string(VSize(NewVelocity)), 'PlayerMove');
    }
    if (Pawn != none && Pawn.default.Mesh.RootMotionMode == 2)
    {
        if (Pawn.Physics != 2 && Pawn.Mesh != none && Pawn.Mesh.RootMotionMode != 2 && !Pawn.bRootMotionFromInterpCurve)
        {
            LogInternal("- skipping position update for root motion", 'PlayerMove');
            return;
        }
        CurrentMove = SavedMoves;
        while (CurrentMove != none)
        {
            if (CurrentMove.bForceRMVelocity)
            {
                LogInternal("- skipping position update for upcoming root motion", 'PlayerMove');
                return;
            }
            CurrentMove = CurrentMove.NextMove;
        }
    }
    if (InterpActor(NewBase) != none || Vehicle(NewBase) != none)
    {
        NewLocation += NewBase.Location;
    }
    MoveActor.bCanTeleport = false;
    if (!MoveActor.SetLocation(NewLocation) && Pawn(MoveActor) != none && Pawn(MoveActor).CylinderComponent.CollisionHeight > Pawn(MoveActor).CrouchHeight && !Pawn(MoveActor).bIsCrouched && newPhysics == 1 && MoveActor.Physics != 10)
    {
        MoveActor.SetPhysics(newPhysics);
        if (!MoveActor.SetLocation(NewLocation + vect(0.0, 0.0, 1.0) * Pawn(MoveActor).MaxStepHeight))
        {
            Pawn(MoveActor).ForceCrouch();
            MoveActor.SetLocation(NewLocation);
        }
        else
        {
            MoveActor.MoveSmooth(vect(0.0, 0.0, -1.0) * Pawn(MoveActor).MaxStepHeight);
        }
    }
    MoveActor.bCanTeleport = true;
    if (MoveActor.Physics != 10 && newPhysics != 10)
    {
        MoveActor.SetPhysics(newPhysics);
    }
    if (MoveActor != self)
    {
        MoveActor.SetBase(NewBase, NewFloor);
    }
    MoveActor.Velocity = NewVelocity;
    UpdateStateFromAdjustment(NewState);
    bUpdatePosition = true;
    if (bDebugClientAdjustPosition)
    {
        DrawDebugBox(OldLoc, vect(2.0, 2.0, 2.0), 0, 120, 0, true);
        DrawDebugBox(Pawn.Location, vect(3.0, 3.0, 3.0), 255, 255, 255, true);
        DrawDebugLine(Pawn.Location, OldLoc, 255, 255, 255, true);
        LogInternal("(" $ string(Name) $ ") PlayerController::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) @ "!!!!!!!!!!!!!!" @ string(SavedMoves) @ "Pawn.Rotation:'" $ string(Pawn.Rotation) $ "'" @ "WorldInfo.TimeSeconds:'" $ string(WorldInfo.TimeSeconds) $ "'");
    }
}

final function UpdatePing(float TimeStamp)
{
    if (PlayerReplicationInfo != none)
    {
        PlayerReplicationInfo.UpdatePing(TimeStamp);
        if (WorldInfo.TimeSeconds - LastPingUpdate > float(4))
        {
            LastPingUpdate = WorldInfo.TimeSeconds;
            ServerUpdatePing(int(float(1000) * PlayerReplicationInfo.ExactPing));
        }
    }
}

reliable server function ServerSetNetSpeed(int NewSpeed)
{
    if (WorldInfo.Game != none && WorldInfo.NetMode == 2)
    {
        NewSpeed = Min(NewSpeed, WorldInfo.Game.AdjustedNetSpeed);
    }
    SetNetSpeed(NewSpeed);
}

unreliable client simulated function ClientAdjustPosition(float TimeStamp, name NewState, EPhysics newPhysics, float NewLocX, float NewLocY, float NewLocZ, float NewVelX, float NewVelY, float NewVelZ, Actor NewBase)
{
    local Vector Floor;
    
    if (Pawn != none)
    {
        Floor = Pawn.Floor;
    }
    LongClientAdjustPosition(TimeStamp, NewState, newPhysics, NewLocX, NewLocY, NewLocZ, NewVelX, NewVelY, NewVelZ, NewBase, Floor.X, Floor.Y, Floor.Z);
}

unreliable client simulated function ClientAckGoodMove(float TimeStamp)
{
    UpdatePing(TimeStamp);
    CurrentTimeStamp = TimeStamp;
    ClearAckedMoves();
}

reliable client simulated function ClientCapBandwidth(int Cap)
{
    ClientCap = Cap;
    if (Player != none && Player.CurrentNetSpeed > Cap)
    {
        SetNetSpeed(Cap);
    }
}

unreliable client simulated function ShortClientAdjustPosition(float TimeStamp, name NewState, EPhysics newPhysics, float NewLocX, float NewLocY, float NewLocZ, Actor NewBase)
{
    local Vector Floor;
    
    if (Pawn != none)
    {
        Floor = Pawn.Floor;
    }
    LongClientAdjustPosition(TimeStamp, NewState, newPhysics, NewLocX, NewLocY, NewLocZ, 0.0, 0.0, 0.0, NewBase, Floor.X, Floor.Y, Floor.Z);
}

unreliable client simulated function VeryShortClientAdjustPosition(float TimeStamp, float NewLocX, float NewLocY, float NewLocZ, Actor NewBase)
{
    local Vector Floor;
    
    if (Pawn != none)
    {
        Floor = Pawn.Floor;
    }
    LongClientAdjustPosition(TimeStamp, 'PlayerWalking', 1, NewLocX, NewLocY, NewLocZ, 0.0, 0.0, 0.0, NewBase, Floor.X, Floor.Y, Floor.Z);
}

function MoveAutonomous(float DeltaTime, byte CompressedFlags, Vector newAccel, Rotator DeltaRot)
{
    local EDoubleClickDir DoubleClickMove;
    
    if (Pawn != none && Pawn.bHardAttach)
    {
        return;
    }
    DoubleClickMove = SavedMoveClass.static.SetFlags(CompressedFlags, self);
    HandleWalking();
    ProcessMove(DeltaTime, newAccel, DoubleClickMove, DeltaRot);
    if (Pawn != none)
    {
        Pawn.AutonomousPhysics(DeltaTime);
    }
    else
    {
        AutonomousPhysics(DeltaTime);
    }
    bDoubleJump = false;
}

function ProcessMove(float DeltaTime, Vector newAccel, EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
{
    if (Pawn != none && Pawn.Acceleration != newAccel)
    {
        Pawn.Acceleration = newAccel;
    }
}

function ProcessDrive(float InForward, float InStrafe, float InUp, bool InJump)
{
    ClientGotoState(GetStateName(), 'Begin');
}

unreliable server function ServerDrive(float InForward, float InStrafe, float aUp, bool InJump, int View)
{
    local Rotator ViewRotation;
    
    ViewRotation.Pitch = View & 65535;
    ViewRotation.Yaw = View >> 16;
    ViewRotation.Roll = 0;
    SetRotation(ViewRotation);
    ProcessDrive(InForward, InStrafe, aUp, InJump);
}

event SendClientAdjustment()
{
    if (AcknowledgedPawn != Pawn)
    {
        PendingAdjustment.TimeStamp = 0.0;
        return;
    }
    if (PendingAdjustment.bAckGoodMove == 1)
    {
        ClientAckGoodMove(PendingAdjustment.TimeStamp);
    }
    else if (Pawn == none || Pawn.Physics != 8)
    {
        if (PendingAdjustment.NewVel == vect(0.0, 0.0, 0.0))
        {
            if (GetStateName() == 'PlayerWalking' && Pawn != none && Pawn.Physics == 1)
            {
                VeryShortClientAdjustPosition(PendingAdjustment.TimeStamp, PendingAdjustment.NewLoc.X, PendingAdjustment.NewLoc.Y, PendingAdjustment.NewLoc.Z, PendingAdjustment.NewBase);
            }
            else
            {
                ShortClientAdjustPosition(PendingAdjustment.TimeStamp, GetStateName(), PendingAdjustment.newPhysics, PendingAdjustment.NewLoc.X, PendingAdjustment.NewLoc.Y, PendingAdjustment.NewLoc.Z, PendingAdjustment.NewBase);
            }
        }
        else
        {
            ClientAdjustPosition(PendingAdjustment.TimeStamp, GetStateName(), PendingAdjustment.newPhysics, PendingAdjustment.NewLoc.X, PendingAdjustment.NewLoc.Y, PendingAdjustment.NewLoc.Z, PendingAdjustment.NewVel.X, PendingAdjustment.NewVel.Y, PendingAdjustment.NewVel.Z, PendingAdjustment.NewBase);
        }
    }
    else
    {
        LongClientAdjustPosition(PendingAdjustment.TimeStamp, GetStateName(), PendingAdjustment.newPhysics, PendingAdjustment.NewLoc.X, PendingAdjustment.NewLoc.Y, PendingAdjustment.NewLoc.Z, PendingAdjustment.NewVel.X, PendingAdjustment.NewVel.Y, PendingAdjustment.NewVel.Z, PendingAdjustment.NewBase, PendingAdjustment.NewFloor.X, PendingAdjustment.NewFloor.Y, PendingAdjustment.NewFloor.Z);
    }
    PendingAdjustment.TimeStamp = 0.0;
    PendingAdjustment.bAckGoodMove = 0;
}

unreliable server function ServerMove(float TimeStamp, Vector InAccel, Vector ClientLoc, byte MoveFlags, byte ClientRoll, int View)
{
    local float DeltaTime;
    local Rotator DeltaRot, Rot, ViewRot;
    local Vector Accel;
    local int maxPitch, ViewPitch, ViewYaw;
    
    if (CurrentTimeStamp >= TimeStamp)
    {
        return;
    }
    if (AcknowledgedPawn != Pawn)
    {
        InAccel = vect(0.0, 0.0, 0.0);
        GivePawn(Pawn);
    }
    ViewPitch = View & 65535;
    ViewYaw = View >> 16;
    Accel = InAccel * 0.1;
    DeltaTime = GetServerMoveDeltaTime(TimeStamp);
    CurrentTimeStamp = TimeStamp;
    ServerTimeStamp = WorldInfo.TimeSeconds;
    ViewRot.Pitch = ViewPitch;
    ViewRot.Yaw = ViewYaw;
    ViewRot.Roll = 0;
    if (InAccel != vect(0.0, 0.0, 0.0))
    {
        LastActiveTime = WorldInfo.TimeSeconds;
    }
    SetRotation(ViewRot);
    if (AcknowledgedPawn != Pawn)
    {
        return;
    }
    if (Pawn != none)
    {
        Rot.Roll = 256 * int(ClientRoll);
        Rot.Yaw = ViewYaw;
        if (Pawn.Physics == 3 || Pawn.Physics == 4)
        {
            maxPitch = 2;
        }
        else
        {
            maxPitch = 0;
        }
        if (ViewPitch > maxPitch * Pawn.MaxPitchLimit && ViewPitch < 65536 - maxPitch * Pawn.MaxPitchLimit)
        {
            if (ViewPitch < 32768)
            {
                Rot.Pitch = maxPitch * Pawn.MaxPitchLimit;
            }
            else
            {
                Rot.Pitch = 65536 - maxPitch * Pawn.MaxPitchLimit;
            }
        }
        else
        {
            Rot.Pitch = ViewPitch;
        }
        DeltaRot = Rotation - Rot;
        Pawn.FaceRotation(Rot, DeltaTime);
    }
    if (WorldInfo.Pauser == none && DeltaTime > float(0))
    {
        MoveAutonomous(DeltaTime, MoveFlags, Accel, DeltaRot);
    }
    ServerMoveHandleClientError(TimeStamp, InAccel, ClientLoc);
}

function ServerMoveHandleClientError(float TimeStamp, Vector InAccel, Vector ClientLoc)
{
    local float ClientErr;
    local Vector LocDiff;
    
    if (ClientLoc == vect(1.0, 2.0, 3.0))
    {
        return;
    }
    else if (WorldInfo.TimeSeconds - LastUpdateTime < 180.0 / float(Player.CurrentNetSpeed))
    {
        return;
    }
    if (Pawn == none)
    {
        LocDiff = Location - ClientLoc;
    }
    else if (Pawn.bForceRMVelocity && Pawn.default.Mesh.RootMotionMode == 2)
    {
        LocDiff = vect(0.0, 0.0, 0.0);
    }
    else if (Pawn.Physics != 0 && WorldInfo.TimeSeconds - LastUpdateTime > 1.0 && IsZero(InAccel))
    {
        LocDiff = vect(1000.0, 1000.0, 1000.0);
    }
    else
    {
        LocDiff = Pawn.Location - ClientLoc;
    }
    ClientErr = LocDiff Dot LocDiff;
    if (ClientErr > 3.0)
    {
        if (Pawn == none)
        {
            PendingAdjustment.newPhysics = Physics;
            PendingAdjustment.NewLoc = Location;
            PendingAdjustment.NewVel = Velocity;
        }
        else
        {
            PendingAdjustment.newPhysics = Pawn.Physics;
            PendingAdjustment.NewVel = Pawn.Velocity;
            PendingAdjustment.NewBase = Pawn.Base;
            if (InterpActor(Pawn.Base) != none || Vehicle(Pawn.Base) != none)
            {
                PendingAdjustment.NewLoc = Pawn.Location - Pawn.Base.Location;
            }
            else
            {
                PendingAdjustment.NewLoc = Pawn.Location;
            }
            PendingAdjustment.NewFloor = Pawn.Floor;
        }
        LastUpdateTime = WorldInfo.TimeSeconds;
        PendingAdjustment.TimeStamp = TimeStamp;
        PendingAdjustment.bAckGoodMove = 0;
    }
    else
    {
        PendingAdjustment.TimeStamp = TimeStamp;
        PendingAdjustment.bAckGoodMove = 1;
    }
}

function float GetServerMoveDeltaTime(float TimeStamp)
{
    local float DeltaTime;
    
    DeltaTime = FMin(MaxResponseTime, TimeStamp - CurrentTimeStamp);
    if (Pawn == none)
    {
        bWasSpeedHack = false;
        ResetTimeMargin();
    }
    else if (!CheckSpeedHack(DeltaTime))
    {
        if (!bWasSpeedHack)
        {
            if (WorldInfo.TimeSeconds - LastSpeedHackLog > float(20))
            {
                LogInternal("Possible speed hack by " $ PlayerReplicationInfo.PlayerName);
                LastSpeedHackLog = WorldInfo.TimeSeconds;
            }
            ClientMessage("Speed Hack Detected!", 'CriticalEvent');
        }
        else
        {
            bWasSpeedHack = true;
        }
        DeltaTime = 0.0;
        Pawn.Velocity = vect(0.0, 0.0, 0.0);
    }
    else
    {
        DeltaTime *= Pawn.CustomTimeDilation;
        bWasSpeedHack = false;
    }
    return DeltaTime;
}

unreliable server function OldServerMove(float OldTimeStamp, byte OldAccelX, byte OldAccelY, byte OldAccelZ, byte OldMoveFlags)
{
    local Vector Accel;
    
    if (AcknowledgedPawn != Pawn)
    {
        return;
    }
    if (CurrentTimeStamp < OldTimeStamp - 0.001)
    {
        Accel.X = float(OldAccelX);
        if (Accel.X > float(127))
        {
            Accel.X = -1.0 * (Accel.X - float(128));
        }
        Accel.Y = float(OldAccelY);
        if (Accel.Y > float(127))
        {
            Accel.Y = -1.0 * (Accel.Y - float(128));
        }
        Accel.Z = float(OldAccelZ);
        if (Accel.Z > float(127))
        {
            Accel.Z = -1.0 * (Accel.Z - float(128));
        }
        Accel *= float(20);
        OldTimeStamp = FMin(OldTimeStamp, CurrentTimeStamp + MaxResponseTime);
        MoveAutonomous(OldTimeStamp - CurrentTimeStamp, OldMoveFlags, Accel, rot(0, 0, 0));
        CurrentTimeStamp = OldTimeStamp;
    }
}

unreliable server function DualServerMove(float TimeStamp0, Vector InAccel0, byte PendingFlags, int View0, float TimeStamp, Vector InAccel, Vector ClientLoc, byte NewFlags, byte ClientRoll, int View)
{
    ServerMove(TimeStamp0, InAccel0, vect(1.0, 2.0, 3.0), PendingFlags, ClientRoll, View0);
    ServerMove(TimeStamp, InAccel, ClientLoc, NewFlags, ClientRoll, View);
}

function ForceDeathUpdate()
{
    LastUpdateTime = WorldInfo.TimeSeconds - float(10);
}

function ClientVoiceMessage(PlayerReplicationInfo Sender, PlayerReplicationInfo Recipient, name MessageType, byte messageID)
{
}

function bool UsingFirstPersonCamera()
{
    return (PlayerCamera == none || PlayerCamera.CameraStyle == 'FirstPerson') && LocalPlayer(Player) != none;
}

reliable client simulated event ClientSetCameraFade(bool bEnableFading, optional Color FadeColor, optional Vector2D FadeAlpha, optional float FadeTime)
{
    if (PlayerCamera != none)
    {
        PlayerCamera.bEnableFading = bEnableFading;
        if (PlayerCamera.bEnableFading)
        {
            PlayerCamera.FadeColor = FadeColor;
            PlayerCamera.FadeAlpha = FadeAlpha;
            PlayerCamera.FadeTime = FadeTime;
            PlayerCamera.FadeTimeRemaining = FadeTime;
        }
    }
}

event ResetCameraMode()
{
    if (Pawn != none)
    {
        SetCameraMode(Pawn.GetDefaultCameraMode(self));
    }
    else
    {
        SetCameraMode('FirstPerson');
    }
}

function SetCameraMode(name NewCamMode)
{
    if (PlayerCamera != none)
    {
        PlayerCamera.CameraStyle = NewCamMode;
        if (WorldInfo.NetMode == 1)
        {
            ClientSetCameraMode(NewCamMode);
        }
    }
}

reliable client simulated function ClientSetCameraMode(name NewCamMode)
{
    if (PlayerCamera != none)
    {
        PlayerCamera.CameraStyle = NewCamMode;
    }
}

reliable server function ServerCamera(name NewMode)
{
    if (NewMode == '1st')
    {
        NewMode = 'FirstPerson';
    }
    else if (NewMode == '3rd')
    {
        NewMode = 'ThirdPerson';
    }
    SetCameraMode(NewMode);
    if (PlayerCamera != none)
    {
        LogInternal("#### " $ string(PlayerCamera.CameraStyle));
    }
}

exec function Camera(name NewMode)
{
    ServerCamera(NewMode);
}

event PreClientTravel(string PendingURL, ETravelType TravelType, bool bIsSeamlessTravel)
{
    local UIInteraction UIController;
    local GameUISceneClient GameSceneClient;
    
    UIController = GetUIController();
    if (UIController != none && IsPrimaryPlayer())
    {
        GameSceneClient = UIController.SceneClient;
        if (GameSceneClient != none)
        {
            GameSceneClient.NotifyClientTravel(self, PendingURL, TravelType, bIsSeamlessTravel);
        }
    }
}

unreliable server function ServerTeamSay(string msg)
{
    LastActiveTime = WorldInfo.TimeSeconds;
    if (!WorldInfo.GRI.GameClass.default.default.bTeamGame)
    {
        Say(msg);
        return;
    }
    WorldInfo.Game.BroadcastTeam(self, msg, 'TeamSay');
}

exec function TeamSay(string msg)
{
    msg = Left(msg, 128);
    if (AllowTextMessage(msg))
    {
        ServerTeamSay(msg);
    }
}

reliable client simulated function ClientAdminMessage(string msg)
{
    local LocalPlayer LP;
    
    LP = LocalPlayer(Player);
    if (LP != none)
    {
        LP.ViewportClient.ClearProgressMessages();
        LP.ViewportClient.SetProgressTime(6.0);
        LP.ViewportClient.SetProgressMessage(2, msg);
    }
}

unreliable server function ServerSay(string msg)
{
    local PlayerController PC;
    
    if (PlayerReplicationInfo.bAdmin && Left(msg, 1) == "#")
    {
        msg = Right(msg, Len(msg) - 1);
        foreach WorldInfo.AllControllers(class'PlayerController', PC)
        {
            PC.ClientAdminMessage(msg);
        }
        return;
    }
    WorldInfo.Game.Broadcast(self, msg, 'Say');
}

exec function Say(string msg)
{
    msg = Left(msg, 128);
    if (AllowTextMessage(msg))
    {
        ServerSay(msg);
    }
}

function bool AllowTextMessage(string msg)
{
    local int I;
    
    if (WorldInfo.NetMode == 0 || PlayerReplicationInfo.bAdmin)
    {
        return true;
    }
    if (WorldInfo.Pauser == none && WorldInfo.TimeSeconds - LastBroadcastTime < float(2))
    {
        return false;
    }
    if (WorldInfo.TimeSeconds - LastBroadcastTime < float(5))
    {
        msg = Left(msg, Clamp(Len(msg) - 4, 8, 64));
        for (I = 0; I < 4; I++)
        {
            if (LastBroadcastString[I] ~= msg)
            {
                return false;
            }
        }
    }
    for (I = 3; I > 0; I--)
    {
        LastBroadcastString[I] = LastBroadcastString[I - 1];
    }
    LastBroadcastTime = WorldInfo.TimeSeconds;
    return true;
}

reliable server function ServerMutate(string MutateString)
{
    if (WorldInfo.NetMode == 3)
    {
        return;
    }
    WorldInfo.Game.Mutate(MutateString, self);
}

exec function Mutate(string MutateString)
{
    ServerMutate(MutateString);
}

exec function FOV(float F)
{
    if (PlayerCamera != none)
    {
        PlayerCamera.SetFOV(F);
        return;
    }
    if (F >= 80.0 || WorldInfo.NetMode == 0 || PlayerReplicationInfo.bOnlySpectator)
    {
        DefaultFOV = FClamp(F, 80.0, 100.0);
        DesiredFOV = DefaultFOV;
    }
}

function ResetFOV()
{
    DesiredFOV = DefaultFOV;
    FOVAngle = DefaultFOV;
}

function SetFOV(float NewFOV)
{
    DesiredFOV = NewFOV;
    FOVAngle = NewFOV;
}

function FixFOV()
{
    FOVAngle = default.DefaultFOV;
    DesiredFOV = default.DefaultFOV;
    DefaultFOV = default.DefaultFOV;
}

event Destroyed()
{
    ClientPlayForceFeedbackWaveform(none);
    if (Role < 3 || LocalPlayer(Player) != none)
    {
        ClearOnlineDelegates();
    }
    if (Pawn != none)
    {
        CleanupPawn();
    }
    if (myHUD != none)
    {
        myHUD.Destroy();
    }
    if (PlayerCamera != none)
    {
        PlayerCamera.Destroy();
        PlayerCamera = none;
    }
    ForceClearUnpauseDelegates();
    UnregisterPlayerDataStores();
    Destroyed();
}

function CleanupPawn()
{
    local Vehicle DrivenVehicle;
    local Pawn Driver;
    
    DrivenVehicle = Vehicle(Pawn);
    if (DrivenVehicle != none)
    {
        Driver = DrivenVehicle.Driver;
        DrivenVehicle.DriverLeave(true);
        if (Driver != none)
        {
            Driver.Health = 0;
            Driver.Died(self, class'DmgType_Suicided', Driver.Location);
        }
    }
    else if (Pawn != none)
    {
        Pawn.Health = 0;
        Pawn.Died(self, class'DmgType_Suicided', Pawn.Location);
    }
}

event ClearOnlineDelegates()
{
    local LocalPlayer LP;
    
    LogInternal("Clearing online delegates for" @ string(self) @ "(" $ "Player:" $ (Player != none ? string(Player.Name) : "None") $ ")", 'DevOnline');
    LP = LocalPlayer(Player);
    if (Role < 3 || LP != none)
    {
        if (OnlineSub != none)
        {
            if (NotEqual_InterfaceInterface(OnlineSub.SystemInterface, OnlineSystemInterface(none)))
            {
                OnlineSub.SystemInterface.ClearExternalUIChangeDelegate(OnExternalUIChanged);
                OnlineSub.SystemInterface.ClearControllerChangeDelegate(OnControllerChanged);
            }
            if (NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)) && LP != none)
            {
                OnlineSub.GameInterface.ClearGameInviteAcceptedDelegate(byte(LP.ControllerId), OnGameInviteAccepted);
            }
            if (NotEqual_InterfaceInterface(OnlineSub.PartyChatInterface, OnlinePartyChatInterface(none)))
            {
                OnlineSub.PartyChatInterface.ClearPartyMemberListChangedDelegate(byte(LP.ControllerId), OnPartyMemberListChanged);
                OnlineSub.PartyChatInterface.ClearPartyMembersInfoChangedDelegate(byte(LP.ControllerId), OnPartyMembersInfoChanged);
            }
        }
    }
}

function OnPartyMembersInfoChanged(string PlayerName, UniqueNetId PlayerID, int CustomData1, int CustomData2, int CustomData3, int CustomData4)
{
}

function OnPartyMemberListChanged(bool bJoinedOrLeft, string PlayerName, UniqueNetId PlayerID)
{
}

function RegisterOnlineDelegates()
{
    local LocalPlayer LP;
    
    LP = LocalPlayer(Player);
    if (OnlineSub != none && LP != none)
    {
        VoiceInterface = OnlineSub.VoiceInterface;
        if (NotEqual_InterfaceInterface(OnlineSub.SystemInterface, OnlineSystemInterface(none)))
        {
            OnlineSub.SystemInterface.AddExternalUIChangeDelegate(OnExternalUIChanged);
            OnlineSub.SystemInterface.AddControllerChangeDelegate(OnControllerChanged);
        }
        if (NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)))
        {
            OnlineSub.GameInterface.AddGameInviteAcceptedDelegate(byte(LP.ControllerId), OnGameInviteAccepted);
        }
        if (NotEqual_InterfaceInterface(OnlineSub.PartyChatInterface, OnlinePartyChatInterface(none)))
        {
            OnlineSub.PartyChatInterface.AddPartyMemberListChangedDelegate(byte(LP.ControllerId), OnPartyMemberListChanged);
            OnlineSub.PartyChatInterface.AddPartyMembersInfoChangedDelegate(byte(LP.ControllerId), OnPartyMembersInfoChanged);
        }
    }
}

function PlayBeepSound()
{
}

reliable client simulated event TeamMessage(PlayerReplicationInfo PRI, coerce string S, name Type, optional float MsgLifeTime)
{
    local bool bIsUserCreated;
    
    if (CanCommunicate())
    {
        if ((Type == 'Say' || Type == 'TeamSay') && PRI != none && AllowTTSMessageFrom(PRI))
        {
            if (!bIsUserCreated || bIsUserCreated && CanViewUserCreatedContent())
            {
                SpeakTTS(S, PRI);
            }
        }
        if (myHUD != none)
        {
            myHUD.Message(PRI, S, Type, MsgLifeTime);
        }
        if ((Type == 'Say' || Type == 'TeamSay') && PRI != none)
        {
            S = PRI.PlayerName $ ": " $ S;
            bIsUserCreated = true;
        }
        if (Player != none)
        {
            if (!bIsUserCreated || bIsUserCreated && CanViewUserCreatedContent())
            {
                LocalPlayer(Player).ViewportClient.ViewportConsole.OutputText(S);
            }
        }
    }
}

simulated function SpeakTTS(coerce string S, optional PlayerReplicationInfo PRI)
{
    local SoundCue Cue;
    local AudioComponent AC;
    
    Cue = CreateTTSSoundCue(S, PRI);
    if (Cue != none)
    {
        AC = CreateAudioComponent(Cue, false, true, , , true);
        AC.bAllowSpatialization = false;
        AC.bAutoDestroy = true;
        AC.Play();
    }
}

exec function TeamTalk()
{
    local Console PlayerConsole;
    local LocalPlayer LP;
    
    LP = LocalPlayer(Player);
    if (LP != none && CanCommunicate() && LP.ViewportClient.ViewportConsole != none)
    {
        PlayerConsole = LocalPlayer(Player).ViewportClient.ViewportConsole;
        PlayerConsole.StartTyping("TeamSay ");
    }
}

exec function Talk()
{
    local Console PlayerConsole;
    local LocalPlayer LP;
    
    LP = LocalPlayer(Player);
    if (LP != none && CanCommunicate() && LP.ViewportClient.ViewportConsole != none)
    {
        PlayerConsole = LocalPlayer(Player).ViewportClient.ViewportConsole;
        PlayerConsole.StartTyping("Say ");
    }
}

native private final simulated function SoundCue CreateTTSSoundCue(string StrToSpeak, PlayerReplicationInfo PRI)
{
    StrToSpeak;
    PRI;
}

private final simulated function bool AllowTTSMessageFrom(PlayerReplicationInfo PRI)
{
    return true;
}

private final simulated function bool CanCommunicate()
{
    return true;
}

reliable client simulated event ClientMessage(coerce string S, optional name Type, optional float MsgLifeTime)
{
    if (WorldInfo.NetMode == 1 || WorldInfo.GRI == none || IsPaused())
    {
        return;
    }
    if (Type == 'None')
    {
        Type = 'Event';
    }
    TeamMessage(PlayerReplicationInfo, S, Type, MsgLifeTime);
}

reliable client simulated function ClientPlayActorFaceFXAnim(Actor SourceActor, FaceFXAnimSet AnimSet, string GroupName, string SeqName, SoundCue SoundCueToPlay)
{
    if (SourceActor != none)
    {
        SourceActor.PlayActorFaceFXAnim(AnimSet, GroupName, SeqName, SoundCueToPlay);
    }
}

reliable client simulated event Kismet_ClientStopSound(SoundCue ASound, Actor SourceActor, float FadeOutTime)
{
    local AudioComponent AC, CheckAC;
    
    if (SourceActor == none)
    {
        SourceActor = WorldInfo;
    }
    foreach SourceActor.AllOwnedComponents(class'AudioComponent', CheckAC)
    {
        if (CheckAC.SoundCue == ASound)
        {
            AC = CheckAC;
            break;
        }
    }
    if (AC != none)
    {
        AC.FadeOut(FadeOutTime, 0.0);
    }
}

reliable client simulated event Kismet_ClientPlaySound(SoundCue ASound, Actor SourceActor, float VolumeMultiplier, float PitchMultiplier, float FadeInTime, bool bSuppressSubtitles, bool bSuppressSpatialization)
{
    local AudioComponent AC;
    
    if (SourceActor != none && IsClosestLocalPlayerToActor(SourceActor))
    {
        if (ASound.FaceFXAnimName != "" && SourceActor.PlayActorFaceFXAnim(ASound.FaceFXAnimSetRef, ASound.FaceFXGroupName, ASound.FaceFXAnimName, ASound))
        {
        }
        else
        {
            AC = SourceActor.CreateAudioComponent(ASound, false, true);
            if (AC != none)
            {
                AC.VolumeMultiplier = VolumeMultiplier;
                AC.PitchMultiplier = PitchMultiplier;
                AC.bAutoDestroy = true;
                AC.SubtitlePriority = 10000.0;
                AC.bSuppressSubtitles = bSuppressSubtitles;
                AC.FadeIn(FadeInTime, 1.0);
                if (bSuppressSpatialization)
                {
                    AC.bAllowSpatialization = false;
                }
            }
        }
    }
}

simulated function bool IsClosestLocalPlayerToActor(Actor TheActor)
{
    local PlayerController PC;
    local float MyDist;
    
    if (ViewTarget == none)
    {
        return false;
    }
    MyDist = VSize(ViewTarget.Location - TheActor.Location);
    foreach LocalPlayerControllers(class'PlayerController', PC)
    {
        if (PC != self && PC.ViewTarget != none && VSize(PC.ViewTarget.Location - TheActor.Location) < MyDist)
        {
            return false;
        }
    }
    return true;
}

unreliable client simulated event ClientHearSound(SoundCue ASound, Actor SourceActor, Vector SourceLocation, bool bStopWhenOwnerDestroyed, optional bool bIsOccluded)
{
    local AudioComponent AC;
    
    if (SourceActor == none)
    {
        AC = GetPooledAudioComponent(ASound, SourceActor, bStopWhenOwnerDestroyed, true, SourceLocation);
        if (AC == none)
        {
            return;
        }
        AC.bUseOwnerLocation = false;
        AC.Location = SourceLocation;
    }
    else if (SourceActor == GetViewTarget() || SourceActor == self)
    {
        AC = GetPooledAudioComponent(ASound, none, bStopWhenOwnerDestroyed);
        if (AC == none)
        {
            return;
        }
        AC.bAllowSpatialization = false;
    }
    else
    {
        AC = GetPooledAudioComponent(ASound, SourceActor, bStopWhenOwnerDestroyed);
        if (AC == none)
        {
            return;
        }
        if (!IsZero(SourceLocation) && SourceLocation != SourceActor.Location)
        {
            AC.bUseOwnerLocation = false;
            AC.Location = SourceLocation;
        }
    }
    if (bIsOccluded)
    {
        AC.VolumeMultiplier *= 0.5;
    }
    AC.Play();
}

native function AudioComponent GetPooledAudioComponent(SoundCue ASound, Actor SourceActor, bool bStopWhenOwnerDestroyed, optional bool bUseLocation, optional Vector SourceLocation)
{
    ASound;
    SourceActor;
    bStopWhenOwnerDestroyed;
    bUseLocation;
    SourceLocation;
}

simulated function HearSoundFinished(AudioComponent AC)
{
    HearSoundActiveComponents.RemoveItem(AC);
    if (!AC.IsPendingKill())
    {
        AC.ResetToDefaults();
        HearSoundPoolComponents[HearSoundPoolComponents.Length] = AC;
    }
}

unreliable client simulated event ClientPlaySound(SoundCue ASound)
{
    ClientHearSound(ASound, self, Location, false, false);
}

reliable client simulated event ReceiveLocalizedMessage(class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    if (WorldInfo.NetMode == 1 || WorldInfo.GRI == none)
    {
        return;
    }
    Message.static.ClientReceive(self, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
}

function CleanupPRI()
{
    WorldInfo.Game.AddInactivePRI(PlayerReplicationInfo, self);
    PlayerReplicationInfo = none;
}

function HandlePickup(Inventory Inv)
{
    ReceiveLocalizedMessage(Inv.MessageClass, , , , Inv.Class);
}

reliable client simulated function ClientSetHUD(class<HUD> newHUDType, class<ScoreBoard> newScoringType)
{
    if (myHUD != none)
    {
        myHUD.Destroy();
    }
    if (newHUDType == none)
    {
        myHUD = none;
    }
    else
    {
        myHUD = Spawn(newHUDType, self);
        if (myHUD != none)
        {
            myHUD.SpawnScoreBoard(newScoringType);
        }
    }
}

function PawnDied(Pawn P)
{
    if (P != Pawn)
    {
        return;
    }
    if (Pawn != none)
    {
        Pawn.RemoteRole = 1;
    }
    PawnDied(P);
}

event UnPossess()
{
    if (Pawn != none)
    {
        SetLocation(Pawn.Location);
        Pawn.RemoteRole = 1;
        Pawn.UnPossessed();
        CleanOutSavedMoves();
        if (GetViewTarget() == Pawn)
        {
            SetViewTarget(self);
        }
    }
    Pawn = none;
}

reliable server function ServerAcknowledgePossession(Pawn P)
{
    if (P != none && P == Pawn && P != AcknowledgedPawn)
    {
        ResetTimeMargin();
    }
    AcknowledgedPawn = P;
}

function AcknowledgePossession(Pawn P)
{
    if (LocalPlayer(Player) != none)
    {
        AcknowledgedPawn = P;
        if (P != none)
        {
            P.SetBaseEyeheight();
            P.EyeHeight = P.BaseEyeHeight;
        }
        ServerAcknowledgePossession(P);
    }
}

event Possess(Pawn aPawn, bool bVehicleTransition)
{
    local Actor A;
    local int I;
    local SeqEvent_Touch TouchEvent;
    
    if (!PlayerReplicationInfo.bOnlySpectator)
    {
        if (aPawn.Controller != none)
        {
            aPawn.Controller.UnPossess();
        }
        aPawn.PossessedBy(self, bVehicleTransition);
        Pawn = aPawn;
        Pawn.SetTickIsDisabled(false);
        ResetTimeMargin();
        UpdateSex();
        Restart(bVehicleTransition);
        foreach Pawn.TouchingActors(class'Actor', A)
        {
            for (I = 0; I < A.GeneratedEvents.Length; I++)
            {
                TouchEvent = SeqEvent_Touch(A.GeneratedEvents[I]);
                if (TouchEvent != none && TouchEvent.bPlayerOnly)
                {
                    TouchEvent.CheckTouchActivate(A, Pawn);
                }
            }
        }
    }
}

reliable client simulated function GivePawn(Pawn NewPawn)
{
    if (NewPawn == none)
    {
        return;
    }
    Pawn = NewPawn;
    NewPawn.Controller = self;
    ClientRestart(Pawn);
}

reliable server function AskForPawn()
{
    if (GamePlayEndedState())
    {
        ClientGotoState(GetStateName(), 'Begin');
    }
    else if (Pawn != none)
    {
        GivePawn(Pawn);
    }
    else
    {
        bFrozen = false;
        ServerRestartPlayer();
    }
}

reliable client simulated function ClientGotoState(name NewState, optional name NewLabel)
{
    if ((NewLabel == 'Begin' || NewLabel == 'None') && !IsInState(NewState))
    {
        GotoState(NewState);
    }
    else
    {
        GotoState(NewState, NewLabel);
    }
}

native simulated function bool IsMouseAvailable()
{
}

native simulated function bool IsKeyboardAvailable()
{
}

native simulated function SetUseTiltForwardAndBack(bool bActive)
{
    bActive;
}

native simulated function SetOnlyUseControllerTiltInput(bool bActive)
{
    bActive;
}

native simulated function SetControllerTiltActive(bool bActive)
{
    bActive;
}

native simulated function SetControllerTiltDesiredIfAvailable(bool bActive)
{
    bActive;
}

native simulated function bool IsControllerTiltActive()
{
}

final function float GetRumbleScale()
{
    local float retval;
    
    retval = 1.0;
    if (ForceFeedbackManager != none)
    {
        retval = ForceFeedbackManager.ScaleAllWaveformsBy;
    }
    return retval;
}

final function SetRumbleScale(float ScaleBy)
{
    if (ForceFeedbackManager != none)
    {
        ForceFeedbackManager.ScaleAllWaveformsBy = ScaleBy;
    }
}

simulated function ReloadProfileSettings()
{
    if (OnlinePlayerData != none && OnlinePlayerData.ProfileProvider != none)
    {
        OnlinePlayerData.ProfileProvider.RefreshStorageData();
    }
}

simulated function SetPlayerDataProvider(PlayerDataProvider DataProvider)
{
    local string PlayerName;
    
    PlayerName = (PlayerReplicationInfo != none ? PlayerReplicationInfo.PlayerName : "None");
    LogInternal(">>" @ "(" $ string(Name) $ ") PlayerController::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) @ "(" $ PlayerName $ "):" @ string(DataProvider), 'DevDataStore');
    if (CurrentPlayerData == none)
    {
        RegisterPlayerDataStores();
    }
    if (CurrentPlayerData != none)
    {
        if (DataProvider != none)
        {
            CurrentPlayerData.SetPlayerDataProvider(DataProvider);
        }
        else
        {
            LogInternal("NULL data provider specified!", 'DevDataStore');
        }
    }
    else
    {
        LogInternal("'PlayerOwner' data store not yet registered for player:" @ string(self) @ "(" $ PlayerName $ ")", 'DevDataStore');
    }
    LogInternal("<<" @ "(" $ string(Name) $ ") PlayerController::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) @ "(" $ PlayerName $ "):" @ string(DataProvider), 'DevDataStore');
}

simulated function UnregisterStandardPlayerDataStores()
{
    local LocalPlayer LP;
    local DataStoreClient DataStoreManager;
    local array<class<UIDataStore>> PlayerDataStoreClasses;
    local class<UIDataStore> PlayerDataStoreClass;
    local UIDataStore PlayerDataStore;
    local int ClassIndex;
    local string PlayerName;
    
    PlayerName = (PlayerReplicationInfo != none ? PlayerReplicationInfo.PlayerName : "None");
    LP = LocalPlayer(Player);
    if (LP != none)
    {
        LogInternal(">>" @ "(" $ string(Name) $ ") PlayerController::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) @ "(" $ PlayerName $ ")", 'DevDataStore');
        DataStoreManager = class'UIInteraction'.static.GetDataStoreClient();
        if (DataStoreManager != none)
        {
            DataStoreManager.GetPlayerDataStoreClasses(PlayerDataStoreClasses);
            for (ClassIndex = 0; ClassIndex < PlayerDataStoreClasses.Length; ClassIndex++)
            {
                PlayerDataStoreClass = PlayerDataStoreClasses[ClassIndex];
                if (PlayerDataStoreClass != none)
                {
                    PlayerDataStore = DataStoreManager.FindDataStore(PlayerDataStoreClass.default.default.Tag, LP);
                    if (PlayerDataStore != none)
                    {
                        if (!DataStoreManager.UnregisterDataStore(PlayerDataStore))
                        {
                            LogInternal("Failed to unregister '" $ string(PlayerDataStore.Tag) $ "' data store for player:" @ string(self) @ "(" $ PlayerName $ ")" @ "PlayerDataStore:" $ (PlayerDataStore != none ? string(PlayerDataStore.Name) : "None"), 'DevDataStore');
                        }
                    }
                }
            }
        }
        LogInternal("<<" @ "(" $ string(Name) $ ") PlayerController::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) @ "(" $ PlayerName $ ")", 'DevDataStore');
    }
}

simulated function UnregisterPlayerDataStores()
{
    local LocalPlayer LP;
    local DataStoreClient DataStoreManager;
    local UIDataStore_OnlinePlayerData OnlinePlayerDataStore;
    local string PlayerName;
    
    PlayerName = (PlayerReplicationInfo != none ? PlayerReplicationInfo.PlayerName : "None");
    LP = LocalPlayer(Player);
    if (LP != none)
    {
        LogInternal(">>" @ "(" $ string(Name) $ ") PlayerController::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) @ "(" $ PlayerName $ ")", 'DevDataStore');
        DataStoreManager = class'UIInteraction'.static.GetDataStoreClient();
        if (DataStoreManager != none)
        {
            if (CurrentPlayerData != none)
            {
                if (!DataStoreManager.UnregisterDataStore(CurrentPlayerData))
                {
                    LogInternal("Failed to unregister 'PlayerOwner' data store for player:" @ string(self) @ "(" $ PlayerName $ ")" @ "CurrentPlayerData:" $ (CurrentPlayerData != none ? string(CurrentPlayerData.Name) : "None"), 'DevDataStore');
                }
                CurrentPlayerData = none;
            }
            else
            {
                LogInternal("'PlayerOwner' data store not registered for player:" @ string(self) @ "(" $ PlayerName $ ")", 'DevDataStore');
            }
            OnlinePlayerData = none;
            OnlinePlayerDataStore = UIDataStore_OnlinePlayerData(DataStoreManager.FindDataStore('OnlinePlayerData', LP));
            if (OnlinePlayerDataStore != none)
            {
                if (!DataStoreManager.UnregisterDataStore(OnlinePlayerDataStore))
                {
                    LogInternal("Failed to unregister 'OnlinePlayerData' data store for player:" @ string(self) @ "(" $ PlayerName $ ")" @ "OnlinePlayerDataStore:" $ (OnlinePlayerDataStore != none ? string(OnlinePlayerDataStore.Name) : "None"), 'DevDataStore');
                }
            }
            else
            {
                LogInternal("'OnlinePlayerData' data store not registered for player:" @ string(self) @ "(" $ PlayerName $ ")", 'DevDataStore');
            }
            UnregisterStandardPlayerDataStores();
        }
        else
        {
            LogInternal("Data store client not found!", 'DevDataStore');
        }
        LogInternal("<<" @ "(" $ string(Name) $ ") PlayerController::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) @ "(" $ PlayerName $ ")", 'DevDataStore');
    }
}

protected simulated function RegisterStandardPlayerDataStores()
{
    local LocalPlayer LP;
    local DataStoreClient DataStoreManager;
    local array<class<UIDataStore>> PlayerDataStoreClasses;
    local class<UIDataStore> PlayerDataStoreClass;
    local UIDataStore PlayerDataStore;
    local int ClassIndex;
    local string PlayerName;
    
    PlayerName = (PlayerReplicationInfo != none ? PlayerReplicationInfo.PlayerName : "None");
    LP = LocalPlayer(Player);
    if (LP != none)
    {
        LogInternal(">>" @ "(" $ string(Name) $ ") PlayerController::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) @ "(" $ PlayerName $ ")", 'DevDataStore');
        DataStoreManager = class'UIInteraction'.static.GetDataStoreClient();
        if (DataStoreManager != none)
        {
            DataStoreManager.GetPlayerDataStoreClasses(PlayerDataStoreClasses);
            for (ClassIndex = 0; ClassIndex < PlayerDataStoreClasses.Length; ClassIndex++)
            {
                PlayerDataStoreClass = PlayerDataStoreClasses[ClassIndex];
                if (PlayerDataStoreClass != none)
                {
                    PlayerDataStore = DataStoreManager.FindDataStore(PlayerDataStoreClass.default.default.Tag, LP);
                    if (PlayerDataStore == none)
                    {
                        LogInternal("    Registering standard player data store '" $ string(PlayerDataStoreClass.Name) $ "' for player" @ string(self) @ "(" $ PlayerName $ ")" @ "LP:" $ (LP != none ? string(LP.Name) : "None"), 'DevDataStore');
                        PlayerDataStore = DataStoreManager.CreateDataStore(PlayerDataStoreClass);
                        if (PlayerDataStore != none)
                        {
                            if (!DataStoreManager.RegisterDataStore(PlayerDataStore, LP))
                            {
                                LogInternal("Failed to register '" $ string(PlayerDataStoreClass.default.default.Tag) $ "' data store for player:" @ string(self) @ "(" $ PlayerName $ ")" @ "PlayerDataStore:" $ (PlayerDataStore != none ? string(PlayerDataStore.Name) : "None"), 'DevDataStore');
                            }
                        }
                        else
                        {
                            LogInternal("Failed to create '" $ string(PlayerDataStoreClass.default.default.Tag) $ "' data store for player:" @ string(self) @ "(" $ PlayerName $ ") using class" @ string(PlayerOwnerDataStoreClass), 'DevDataStore');
                        }
                        continue;
                    }
                    LogInternal("'" $ string(PlayerDataStoreClass.default.default.Tag) $ "' data store already registered for player:" @ string(self) @ "(" $ PlayerName $ ")", 'DevDataStore');
                }
            }
        }
    }
}

protected simulated function RegisterCustomPlayerDataStores()
{
    local LocalPlayer LP;
    local DataStoreClient DataStoreManager;
    local class<UIDataStore_OnlinePlayerData> PlayerDataStoreClass;
    local string PlayerName;
    
    PlayerName = (PlayerReplicationInfo != none ? PlayerReplicationInfo.PlayerName : "None");
    LP = LocalPlayer(Player);
    LogInternal(">>" @ "(" $ string(Name) $ ") PlayerController::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) @ "(" $ PlayerName $ ")" @ "LP:" $ (LP != none ? string(LP.Name) : "None"), 'DevDataStore');
    if (LP != none)
    {
        DataStoreManager = class'UIInteraction'.static.GetDataStoreClient();
        if (DataStoreManager != none)
        {
            CurrentPlayerData = PlayerOwnerDataStore(DataStoreManager.FindDataStore('PlayerOwner', LP));
            if (CurrentPlayerData == none)
            {
                CurrentPlayerData = DataStoreManager.CreateDataStore(PlayerOwnerDataStoreClass);
                if (CurrentPlayerData != none)
                {
                    if (DataStoreManager.RegisterDataStore(CurrentPlayerData, LP))
                    {
                        if (PlayerReplicationInfo != none)
                        {
                            PlayerReplicationInfo.BindPlayerOwnerDataProvider();
                        }
                    }
                    else
                    {
                        LogInternal("Failed to register 'PlayerOwner' data store for player:" @ string(self) @ "(" $ PlayerName $ ")" @ "CurrentPlayerData:" $ (CurrentPlayerData != none ? string(CurrentPlayerData.Name) : "None"), 'DevDataStore');
                    }
                }
                else
                {
                    LogInternal("Failed to create 'PlayerOwner' data store for player:" @ string(self) @ "(" $ PlayerName $ ") using class" @ string(PlayerOwnerDataStoreClass), 'DevDataStore');
                }
            }
            else
            {
                LogInternal("'PlayerOwner' data store already registered for player:" @ string(self) @ "(" $ PlayerName $ ")", 'DevDataStore');
            }
            OnlinePlayerData = UIDataStore_OnlinePlayerData(DataStoreManager.FindDataStore('OnlinePlayerData', LP));
            if (OnlinePlayerData == none)
            {
                PlayerDataStoreClass = class<UIDataStore_OnlinePlayerData>(DataStoreManager.FindDataStoreClass(class'UIDataStore_OnlinePlayerData'));
                if (PlayerDataStoreClass != none)
                {
                    OnlinePlayerData = DataStoreManager.CreateDataStore(PlayerDataStoreClass);
                    if (OnlinePlayerData != none)
                    {
                        if (!DataStoreManager.RegisterDataStore(OnlinePlayerData, LP))
                        {
                            LogInternal("Failed to register 'OnlinePlayerData' data store for player:" @ string(self) @ "(" $ PlayerName $ ")" @ "OnlinePlayerData:" $ (OnlinePlayerData != none ? string(OnlinePlayerData.Name) : "None"), 'DevDataStore');
                        }
                    }
                    else
                    {
                        LogInternal("Failed to create 'OnlinePlayerData' data store for player:" @ string(self) @ "(" $ PlayerName $ ") using class" @ string(PlayerDataStoreClass), 'DevDataStore');
                    }
                }
                else
                {
                    LogInternal("Failed to find valid data store class while attempting to register the 'OnlinePlayerData' data store for player:" @ string(self) @ "(" $ PlayerName $ ")", 'DevDataStore');
                }
            }
            else
            {
                LogInternal("'OnlinePlayerData' data store already registered for player:" @ string(self) @ "(" $ PlayerName $ ")", 'DevDataStore');
            }
        }
    }
    LogInternal("<<" @ "(" $ string(Name) $ ") PlayerController::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) @ "(" $ PlayerName $ ")", 'DevDataStore');
}

final simulated function RegisterPlayerDataStores()
{
    RegisterCustomPlayerDataStores();
    RegisterStandardPlayerDataStores();
}

reliable client simulated function ClientInitializeDataStores()
{
    LogInternal(">> PlayerController::ClientInitializeDataStores for player" @ string(self), 'DevDataStore');
    RegisterPlayerDataStores();
    LogInternal("<< PlayerController::ClientInitializeDataStores for player" @ string(self), 'DevDataStore');
}

event InitInputSystem()
{
    local class<ForceFeedbackManager> FFManagerClass;
    local int I;
    local Sequence GameSeq;
    local array<SequenceObject> AllInterpActions;
    
    if (PlayerInput == none)
    {
        assert(InputClass != none);
        PlayerInput = new(self) InputClass;
    }
    if (Interactions.Find(PlayerInput) == -1)
    {
        Interactions[Interactions.Length] = PlayerInput;
    }
    if (ForceFeedbackManagerClassName != "")
    {
        FFManagerClass = class<ForceFeedbackManager>(DynamicLoadObject(ForceFeedbackManagerClassName, class'Core.Class'));
        if (FFManagerClass != none)
        {
            ForceFeedbackManager = new(self) FFManagerClass;
        }
    }
    RegisterOnlineDelegates();
    if (Role < 3)
    {
        GameSeq = WorldInfo.GetGameSequence();
        if (GameSeq != none)
        {
            GameSeq.FindSeqObjectsByClass(class'SeqAct_Interp', true, AllInterpActions);
            for (I = 0; I < AllInterpActions.Length; I++)
            {
                SeqAct_Interp(AllInterpActions[I]).AddPlayerToDirectorTracks(self);
            }
        }
    }
    SetOnlyUseControllerTiltInput(false);
    SetUseTiltForwardAndBack(true);
    SetControllerTiltActive(false);
}

final simulated function OnlineSubsystem GetOnlineSubsystem()
{
    if (OnlineSub == none)
    {
        OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
    }
    return OnlineSub;
}

function PostControllerIdChange()
{
    local LocalPlayer LP;
    local UniqueNetId PlayerID;
    
    LP = LocalPlayer(Player);
    if (LP != none)
    {
        if (WorldInfo.NetMode != 3 && OnlineSub != none && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
        {
            OnlineSub.PlayerInterface.GetUniquePlayerId(byte(LP.ControllerId), PlayerID);
            PlayerReplicationInfo.SetUniqueId(PlayerID);
        }
        RegisterPlayerDataStores();
        RegisterOnlineDelegates();
        ClientSetOnlineStatus();
        assert(WorldInfo.Game != none);
        if (!WorldInfo.Game.bRequiresPushToTalk)
        {
            ClientStartNetworkedVoice();
        }
    }
}

function PreControllerIdChange()
{
    local LocalPlayer LP;
    
    LP = LocalPlayer(Player);
    if (LP != none)
    {
        ClientStopNetworkedVoice();
        ClearOnlineDelegates();
        UnregisterPlayerDataStores();
    }
}

function CleanOutSavedMoves()
{
    SavedMoves = none;
    PendingMove = none;
}

reliable client simulated function ClientReset()
{
    ResetCameraMode();
    SetViewTarget(self);
    GotoState(PlayerReplicationInfo.bOnlySpectator ? 'Spectating' : 'PlayerWaiting');
}

function Reset()
{
    local Vehicle DrivenVehicle;
    
    DrivenVehicle = Vehicle(Pawn);
    if (DrivenVehicle != none)
    {
        DrivenVehicle.DriverLeave(true);
    }
    if (Pawn != none)
    {
        PawnDied(Pawn);
        UnPossess();
    }
    Reset();
    SetViewTarget(self);
    ResetCameraMode();
    WaitDelay = WorldInfo.TimeSeconds + float(2);
    FixFOV();
    if (PlayerReplicationInfo.bOnlySpectator)
    {
        GotoState('Spectating');
    }
    else
    {
        GotoState('PlayerWaiting');
    }
}

function SpawnDefaultHUD()
{
    if (LocalPlayer(Player) == none)
    {
        return;
    }
    LogInternal(string(GetFuncName()));
    myHUD = Spawn(class'HUD', self);
}

exec function EnableCheats()
{
    AddCheats();
}

function AddCheats()
{
    if (CheatManager == none && WorldInfo.Game != none && WorldInfo.Game.AllowCheats(self))
    {
        CheatManager = new(self) CheatClass;
        CheatManager.InitCheatManager();
    }
}

event KickWarning()
{
    ReceiveLocalizedMessage(class'GameMessage', 15);
}

function ServerGivePawn()
{
    GivePawn(Pawn);
}

reliable server function ServerShortTimeout()
{
    local Actor A;
    
    if (!bShortConnectTimeOut)
    {
        bShortConnectTimeOut = true;
        ResetTimeMargin();
        if (WorldInfo.Pauser != none)
        {
            foreach AllActors(class'Actor', A)
            {
                if (!A.bOnlyRelevantToOwner)
                {
                    A.bForceNetUpdate = true;
                }
            }
        }
        else if (WorldInfo.Game.NumPlayers < 8)
        {
            foreach AllActors(class'Actor', A)
            {
                if (A.NetUpdateFrequency < float(1) && !A.bOnlyRelevantToOwner)
                {
                    A.SetNetUpdateTime(FMin(A.NetUpdateTime, WorldInfo.TimeSeconds + 0.2 * FRand()));
                }
            }
        }
        else
        {
            foreach AllActors(class'Actor', A)
            {
                if (A.NetUpdateFrequency < float(1) && !A.bOnlyRelevantToOwner)
                {
                    A.SetNetUpdateTime(FMin(A.NetUpdateTime, WorldInfo.TimeSeconds + 0.5 * FRand()));
                }
            }
        }
    }
}

function ResetTimeMargin()
{
    TimeMargin = -0.1;
    MaxTimeMargin = class'GameInfo'.default.default.MaxTimeMargin;
}

event PreRender(Canvas Canvas)
{
}

simulated event ReceivedPlayer()
{
    local LocalPlayer LP;
    local PlayerController FirstPlayer;
    
    if (PlayerReplicationInfo != none && LocalPlayer(Player) != none && IsSplitscreenPlayer())
    {
        if (NetPlayerIndex != 0)
        {
            LP = LocalPlayer(Player);
            FirstPlayer = LP.ViewportClient.Outer.GamePlayers[0].Actor;
            assert(FirstPlayer != self);
            FirstPlayer.PlayerReplicationInfo.SetSplitscreenIndex(0);
        }
        PlayerReplicationInfo.SetSplitscreenIndex(NetPlayerIndex);
    }
    RegisterPlayerDataStores();
}

simulated event PostBeginPlay()
{
    PostBeginPlay();
    ResetCameraMode();
    MaxTimeMargin = class'GameInfo'.default.default.MaxTimeMargin;
    MaxResponseTime = default.MaxResponseTime * WorldInfo.TimeDilation;
    if (WorldInfo.NetMode == 3)
    
    {
        SpawnDefaultHUD();
    }
    else
    {
        AddCheats();
    }
    SetViewTarget(self);
    LastActiveTime = WorldInfo.TimeSeconds;
    OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
}

function CoverReplicator SpawnCoverReplicator()
{
    if (MyCoverReplicator == none && Role == 3 && LocalPlayer(Player) == none)
    {
        MyCoverReplicator = Spawn(class'CoverReplicator', self);
        MyCoverReplicator.ReplicateInitialCoverInfo();
    }
    return MyCoverReplicator;
}

function bool CanUnpauseControllerConnected()
{
    return bIsControllerConnected;
}

function OnControllerChanged(int ControllerId, bool bIsConnected)
{
    local LocalPlayer LP;
    
    LP = LocalPlayer(Player);
    if (LP != none && LP.ControllerId == ControllerId && WorldInfo.IsConsoleBuild() && WorldInfo.Game == none || !WorldInfo.Game.IsAutomatedPerfTesting())
    {
        bIsControllerConnected = bIsConnected;
        if (!bIsConnected)
        {
            bCanUnPause = !IsPaused();
        }
        LogInternal("Received gamepad connection change for player" @ string(class'UIInteraction'.static.GetPlayerIndex(ControllerId)) $ ": gamepad" @ string(ControllerId) @ "is now" @ (bIsConnected ? "connected" : "disconnected"));
        if (bCanUnPause && !bNoCurrentUser)
        {
            SetPause(!bIsConnected, CanUnpauseControllerConnected);
        }
    }
}

function bool CanUnpauseExternalUI()
{
    return !bIsExternalUIOpen || bPendingDelete || bPendingDestroy || bDeleteMe;
}

function OnExternalUIChanged(bool bIsOpening)
{
    bIsExternalUIOpen = bIsOpening;
    SetPause(bIsOpening, CanUnpauseExternalUI);
}

function ForceClearUnpauseDelegates()
{
    if (WorldInfo.Game != none)
    {
        WorldInfo.Game.ForceClearUnpauseDelegates(self);
    }
}

simulated event CallCameraUpdateViewTarget(Camera Camera, out TViewTarget OutVT)
{
    Camera.UpdateViewTarget(OutVT, 0.0);
}

simulated event FellOutOfWorld(class<DamageType> dmgType)
{
}

native function CleanUpAudioComponents()
{
}

native(524) final function int FindStairRotation(float DeltaTime)
{
    DeltaTime;
}

native final function bool CheckSpeedHack(float DeltaTime)
{
    DeltaTime;
}

native reliable server private final event ServerProcessConvolve(string C, int H)
{
    C;
    H;
}

native reliable client private final simulated event ClientConvolve(string C, int H)
{
    C;
    H;
}

native exec function SetAudioGroupVolume(name GroupName, float Volume)
{
    GroupName;
    Volume;
}

native function SetAllowMatureLanguage(bool bAllowMatureLanguge)
{
    bAllowMatureLanguge;
}

native function string PasteFromClipboard()
{
}

native function CopyToClipboard(string Text)
{
    Text;
}

native final function string GetDefaultURL(string Option)
{
    Option;
}

native(546) final function UpdateURL(string NewOption, string NewValue, bool bSave1Default)
{
    NewOption;
    NewValue;
    bSave1Default;
}

native reliable client simulated event ClientTravel(string URL, ETravelType TravelType, optional bool bSeamless = false, optional Guid MapPackageGuid)
{
    URL;
    TravelType;
    bSeamless;
    MapPackageGuid;
}

native function string ConsoleCommand(string Command, optional bool bWriteToLog = true)
{
    Command;
    bWriteToLog;
}

native final function string GetServerNetworkAddress()
{
}

native final function string GetPlayerNetworkAddress()
{
}

native final function SetNetSpeed(int NewSpeed)
{
    NewSpeed;
}

reliable client simulated function ClientDrawCoordinateSystem(Vector AxisLoc, Rotator AxisRot, float Scale, optional bool bPersistentLines)
{
    LogInternal("ClientDrawCoordinateSystem");
    DrawDebugCoordinateSystem(AxisLoc, AxisRot, Scale, bPersistentLines);
}

event setFacingSlideTarget(Actor Target)
{
}

event Actor getFacingSlideTarget()
{
}

event Actor getBKActorInInputCone(Vector inputDir)
{
}

event Pawn getNPCInInputCone(Vector inputDir)
{
}

event Vector getInputVectorSlideToTarget()
{
}

state Dead
{
    event EndState(name NextStateName)
    {
        CleanOutSavedMoves();
        Velocity = vect(0.0, 0.0, 0.0);
        Acceleration = vect(0.0, 0.0, 0.0);
        if (!PlayerReplicationInfo.bOutOfLives)
        {
            ResetCameraMode();
        }
        bPressedJump = false;
        if (myHUD != none)
        {
            myHUD.SetShowScores(false);
        }
    }
    
    event BeginState(name PreviousStateName)
    {
        if (Pawn != none && Pawn.Controller == self)
        {
            Pawn.Controller = none;
        }
        Pawn = none;
        FOVAngle = DesiredFOV;
        Enemy = none;
        bFrozen = true;
        bPressedJump = false;
        FindGoodView();
        SetTimer(MinRespawnDelay, false);
        CleanOutSavedMoves();
    }
    
    event Timer()
    {
        if (!bFrozen)
        {
            return;
        }
        bFrozen = false;
        bPressedJump = false;
    }
    
    function FindGoodView()
    {
        local Vector cameraLoc;
        local Rotator cameraRot, ViewRotation;
        local int tries, besttry;
        local float bestDist, newdist;
        local int startYaw;
        local Actor TheViewTarget;
        
        ViewRotation = Rotation;
        ViewRotation.Pitch = 56000;
        tries = 0;
        besttry = 0;
        bestDist = 0.0;
        startYaw = ViewRotation.Yaw;
        TheViewTarget = GetViewTarget();
        for (tries = 0; tries < 16; tries++)
        {
            cameraLoc = TheViewTarget.Location;
            SetRotation(ViewRotation);
            GetPlayerViewPoint(cameraLoc, cameraRot);
            newdist = VSize(cameraLoc - TheViewTarget.Location);
            if (newdist > bestDist)
            {
                bestDist = newdist;
                besttry = tries;
            }
            ViewRotation.Yaw += 4096;
        }
        ViewRotation.Yaw = startYaw + besttry * 4096;
        SetRotation(ViewRotation);
    }
    
    function PlayerMove(float DeltaTime)
    {
        local Vector X, Y, Z;
        local Rotator DeltaRot, ViewRotation;
        
        if (!bFrozen)
        {
            if (bPressedJump)
            {
                StartFire(0);
                bPressedJump = false;
            }
            GetAxes(Rotation, X, Y, Z);
            ViewRotation = Rotation;
            DeltaRot.Yaw = int(PlayerInput.aTurn);
            DeltaRot.Pitch = int(PlayerInput.aLookUp);
            ProcessViewRotation(DeltaTime, ViewRotation, DeltaRot);
            SetRotation(ViewRotation);
            if (Role < 3)
            {
                ReplicateMove(DeltaTime, vect(0.0, 0.0, 0.0), 0, rot(0, 0, 0));
            }
        }
        else if (!IsTimerActive() || GetTimerCount() > MinRespawnDelay)
        {
            bFrozen = false;
        }
        ViewShake(DeltaTime);
    }
    
    unreliable server function ServerMove(float TimeStamp, Vector Accel, Vector ClientLoc, byte NewFlags, byte ClientRoll, int View)
    {
        Global.ServerMove(TimeStamp, Accel, ClientLoc, 0, ClientRoll, View);
    }
    
    exec function Jump()
    {
        StartFire(0);
    }
    
    exec function Use()
    {
        StartFire(0);
    }
    
    exec function StartFire(optional byte FireModeNum)
    {
        if (bFrozen)
        {
            if (!IsTimerActive() || GetTimerCount() > MinRespawnDelay)
            {
                bFrozen = false;
            }
            return;
        }
        ServerRestartPlayer();
    }
    
    reliable server function ServerRestartPlayer()
    {
        if (!WorldInfo.Game.PlayerCanRestart(self))
        {
            return;
        }
        ServerRestartPlayer();
    }
    
    function bool IsDead()
    {
        return true;
    }
    
    exec function ThrowWeapon()
    {
    }
    
    exec function PrevWeapon()
    {
    }
    
    exec function NextWeapon()
    {
    }
    
    function KilledBy(Pawn EventInstigator)
    {
    }
    
    function HearNoise(float Loudness, Actor NoiseMaker, optional name NoiseType)
    {
    }
    
    function SeePlayer(Pawn Seen)
    {
    }
    
    Begin:
    if (LocalPlayer(Player) != none)
    {
        if (myHUD != none)
        {
            myHUD.PlayerOwnerDied();
        }
    }
    Stop;
}

state RoundEnded
{
    event EndState(name NextStateName)
    {
        if (myHUD != none)
        {
            myHUD.SetShowScores(false);
        }
    }
    
    event BeginState(name PreviousStateName)
    {
        local Pawn P;
        
        FOVAngle = DesiredFOV;
        bFire = 0;
        if (Pawn != none)
        {
            Pawn.TurnOff();
            StopFiring();
        }
        if (myHUD != none)
        {
            myHUD.SetShowScores(true);
        }
        bFrozen = true;
        FindGoodView();
        SetTimer(5.0, false);
        foreach DynamicActors(class'Pawn', P)
        {
            P.TurnOff();
        }
    }
    
    unreliable client simulated function LongClientAdjustPosition(float TimeStamp, name NewState, EPhysics newPhysics, float NewLocX, float NewLocY, float NewLocZ, float NewVelX, float NewVelY, float NewVelZ, Actor NewBase, float NewFloorX, float NewFloorY, float NewFloorZ)
    {
    }
    
    event Timer()
    {
        bFrozen = false;
    }
    
    function FindGoodView()
    {
        local Rotator GoodRotation;
        
        GoodRotation = Rotation;
        GetViewTarget().FindGoodEndView(self, GoodRotation);
        SetRotation(GoodRotation);
    }
    
    unreliable server function ServerMove(float TimeStamp, Vector InAccel, Vector ClientLoc, byte NewFlags, byte ClientRoll, int View)
    {
        Global.ServerMove(TimeStamp, InAccel, ClientLoc, NewFlags, ClientRoll, ((Rotation.Yaw & 65535) << 16) + (Rotation.Pitch & 65535));
    }
    
    function PlayerMove(float DeltaTime)
    {
        local Vector X, Y, Z;
        local Rotator DeltaRot, ViewRotation;
        
        GetAxes(Rotation, X, Y, Z);
        ViewRotation = Rotation;
        DeltaRot.Yaw = int(PlayerInput.aTurn);
        DeltaRot.Pitch = int(PlayerInput.aLookUp);
        ProcessViewRotation(DeltaTime, ViewRotation, DeltaRot);
        SetRotation(ViewRotation);
        ViewShake(DeltaTime);
        if (Role < 3)
        {
            ReplicateMove(DeltaTime, vect(0.0, 0.0, 0.0), 0, rot(0, 0, 0));
        }
        else
        {
            ProcessMove(DeltaTime, vect(0.0, 0.0, 0.0), 0, rot(0, 0, 0));
        }
        bPressedJump = false;
    }
    
    exec function StartFire(optional byte FireModeNum)
    {
        if (Role < 3)
        {
            return;
        }
        if (!bFrozen)
        {
            ServerRestartGame();
        }
        else if (!IsTimerActive())
        {
            SetTimer(1.5, false);
        }
    }
    
    reliable server function ServerRestartGame()
    {
        if (WorldInfo.Game.PlayerCanRestartGame(self))
        {
            WorldInfo.Game.ResetLevel();
        }
    }
    
    event Possess(Pawn aPawn, bool bVehicleTransition)
    {
        Global.Possess(aPawn, bVehicleTransition);
        if (Pawn != none)
        {
            Pawn.TurnOff();
        }
    }
    
    exec function Use()
    {
    }
    
    exec function ThrowWeapon()
    {
    }
    
    function bool IsSpectating()
    {
        return true;
    }
    
    reliable server function ServerRestartPlayer()
    {
    }
    
    exec function Suicide()
    {
    }
    
    function TakeDamage(int DamageAmount, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
    {
    }
    
    function Falling()
    {
    }
    
    function NotifyPhysicsVolumeChange(PhysicsVolume NewVolume)
    {
    }
    
    function bool NotifyHeadVolumeChange(PhysicsVolume NewVolume)
    {
    }
    
    function HitWall(Vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
    {
    }
    
    function bool NotifyBump(Actor Other, Vector HitNormal)
    {
    }
    
    function KilledBy(Pawn EventInstigator)
    {
    }
    
    function HearNoise(float Loudness, Actor NoiseMaker, optional name NoiseType)
    {
    }
    
    function SeePlayer(Pawn Seen)
    {
    }
    
    Begin:
    Stop;
}

state WaitingForPawn extends BaseSpectating
{
    event EndState(name NextStateName)
    {
        ResetCameraMode();
        SetTimer(0.0, false);
    }
    
    event BeginState(name PreviousStateName)
    {
        SetTimer(0.2, true);
        AskForPawn();
    }
    
    event Timer()
    {
        AskForPawn();
    }
    
    function ReplicateMove(float DeltaTime, Vector newAccel, EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
    {
        ProcessMove(DeltaTime, newAccel, DoubleClickMove, DeltaRot);
    }
    
    event PlayerTick(float DeltaTime)
    {
        Global.PlayerTick(DeltaTime);
        if (Pawn != none)
        {
            Pawn.Controller = self;
            Pawn.BecomeViewTarget(self);
            ClientRestart(Pawn);
        }
        else if (!IsTimerActive() || GetTimerCount() > 1.0)
        {
            SetTimer(0.2, true);
            AskForPawn();
        }
    }
    
    unreliable client simulated function LongClientAdjustPosition(float TimeStamp, name NewState, EPhysics newPhysics, float NewLocX, float NewLocY, float NewLocZ, float NewVelX, float NewVelY, float NewVelZ, Actor NewBase, float NewFloorX, float NewFloorY, float NewFloorZ)
    {
        if (NewState == 'RoundEnded')
        {
            GotoState(NewState);
        }
    }
    
    reliable client simulated function ClientGotoState(name NewState, optional name NewLabel)
    {
        if (NewState == 'RoundEnded')
        {
            Global.ClientGotoState(NewState, NewLabel);
        }
    }
    
    exec function StartFire(optional byte FireModeNum)
    {
        AskForPawn();
    }
    
    function KilledBy(Pawn EventInstigator)
    {
    }
    
    function HearNoise(float Loudness, Actor NoiseMaker, optional name NoiseType)
    {
    }
    
    function SeePlayer(Pawn Seen)
    {
    }
    
    Stop;
}

auto state PlayerWaiting extends BaseSpectating
{
    simulated event BeginState(name PreviousStateName)
    {
        if (PlayerReplicationInfo != none)
        {
            PlayerReplicationInfo.SetWaitingPlayer(true);
        }
        bCollideWorld = true;
    }
    
    event EndState(name NextStateName)
    {
        if (PlayerReplicationInfo != none)
        {
            PlayerReplicationInfo.SetWaitingPlayer(false);
        }
        bCollideWorld = false;
    }
    
    exec function StartFire(optional byte FireModeNum)
    {
        ServerRestartPlayer();
    }
    
    reliable server function ServerRestartPlayer()
    {
        if (WorldInfo.TimeSeconds < WaitDelay)
        {
            return;
        }
        if (WorldInfo.NetMode == 3)
        {
            return;
        }
        if (WorldInfo.Game.bWaitingToStartMatch)
        {
            PlayerReplicationInfo.bReadyToPlay = true;
        }
        else
        {
            WorldInfo.Game.RestartPlayer(self);
        }
    }
    
    reliable server function ServerChangeTeam(int N)
    {
        WorldInfo.Game.ChangeTeam(self, N, true);
    }
    
    reliable server function ServerSuicide()
    {
    }
    
    exec function Suicide()
    {
    }
    
    exec function Jump()
    {
    }
    
    exec function SwitchToBestWeapon(optional bool bForceNewWeapon)
    {
    }
    
    exec function PrevWeapon()
    {
    }
    
    exec function NextWeapon()
    {
    }
    
    function PhysicsVolumeChange(PhysicsVolume NewVolume)
    {
    }
    
    function TakeDamage(int DamageAmount, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
    {
    }
    
    function bool NotifyBump(Actor Other, Vector HitNormal)
    {
    }
    
    function HearNoise(float Loudness, Actor NoiseMaker, optional name NoiseType)
    {
    }
    
    function SeePlayer(Pawn Seen)
    {
    }
    
    Stop;
}

state Spectating extends BaseSpectating
{
    event EndState(name NextStateName)
    {
        if (PlayerReplicationInfo != none)
        {
            if (PlayerReplicationInfo.bOnlySpectator)
            {
                LogInternal("WARNING - Spectator only player leaving spectating state to go to " $ string(NextStateName));
            }
            PlayerReplicationInfo.bIsSpectator = false;
        }
        bCollideWorld = false;
    }
    
    event BeginState(name PreviousStateName)
    {
        if (Pawn != none)
        {
            SetLocation(Pawn.Location);
            UnPossess();
        }
        bCollideWorld = true;
    }
    
    exec function StartAltFire(optional byte FireModeNum)
    {
        ResetCameraMode();
        ServerViewSelf();
    }
    
    exec function StartFire(optional byte FireModeNum)
    {
        ServerViewNextPlayer();
    }
    
    function bool NotifyHeadVolumeChange(PhysicsVolume NewVolume)
    {
    }
    
    function NotifyPhysicsVolumeChange(PhysicsVolume NewVolume)
    {
    }
    
    exec function ThrowWeapon()
    {
    }
    
    exec function Suicide()
    {
    }
    
    reliable client function ClientRestart(Pawn NewPawn)
    {
    }
    
    exec function RestartLevel()
    {
    }
    
    Stop;
}

state BaseSpectating
{
    event EndState(name NextStateName)
    {
        bCollideWorld = false;
    }
    
    event BeginState(name PreviousStateName)
    {
        bCollideWorld = true;
    }
    
    function ReplicateMove(float DeltaTime, Vector newAccel, EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
    {
        ProcessMove(DeltaTime, newAccel, DoubleClickMove, DeltaRot);
        ServerSetSpectatorLocation(Location);
    }
    
    unreliable server function ServerSetSpectatorLocation(Vector NewLoc)
    {
        SetLocation(NewLoc);
        if (WorldInfo.TimeSeconds - LastSpectatorStateSynchTime > 2.0)
        {
            ClientGotoState(GetStateName());
            LastSpectatorStateSynchTime = WorldInfo.TimeSeconds;
        }
    }
    
    function PlayerMove(float DeltaTime)
    {
        local Vector X, Y, Z;
        
        GetAxes(Rotation, X, Y, Z);
        Acceleration = PlayerInput.aForward * X + PlayerInput.aStrafe * Y + PlayerInput.aUp * vect(0.0, 0.0, 1.0);
        UpdateRotation(DeltaTime);
        if (Role < 3)
        {
            ReplicateMove(DeltaTime, Acceleration, 0, rot(0, 0, 0));
        }
        else
        {
            ProcessMove(DeltaTime, Acceleration, 0, rot(0, 0, 0));
        }
    }
    
    function ProcessMove(float DeltaTime, Vector newAccel, EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
    {
        local float VelSize;
        
        Acceleration = Normal(newAccel) * SpectatorCameraSpeed;
        VelSize = VSize(Velocity);
        if (VelSize > float(0))
        {
            Velocity = Velocity - (Velocity - Normal(Acceleration) * VelSize) * FMin(DeltaTime * float(8), 1.0);
        }
        Velocity = Velocity + Acceleration * DeltaTime;
        if (VSize(Velocity) > SpectatorCameraSpeed)
        {
            Velocity = Normal(Velocity) * SpectatorCameraSpeed;
        }
        LimitSpectatorVelocity();
        if (VSize(Velocity) > float(0))
        {
            MoveSmooth(float(1 + int(bRun)) * Velocity * DeltaTime);
            if (LimitSpectatorVelocity())
            {
                MoveSmooth(Velocity.Z * vect(0.0, 0.0, 1.0) * DeltaTime);
            }
        }
    }
    
    function bool LimitSpectatorVelocity()
    {
        if (Location.Z > WorldInfo.StallZ)
        {
            Velocity.Z = FMin(SpectatorCameraSpeed, WorldInfo.StallZ - Location.Z - 2.0);
            return true;
        }
        else if (Location.Z < WorldInfo.KillZ)
        {
            Velocity.Z = FMin(SpectatorCameraSpeed, WorldInfo.KillZ - Location.Z + 2.0);
            return true;
        }
        return false;
    }
    
    function bool IsSpectating()
    {
        return true;
    }
    
    Stop;
}

state PlayerFlying
{
    event BeginState(name PreviousStateName)
    {
        Pawn.SetPhysics(4);
    }
    
    function PlayerMove(float DeltaTime)
    {
        local Vector X, Y, Z;
        
        GetAxes(Rotation, X, Y, Z);
        Pawn.Acceleration = PlayerInput.aForward * X + PlayerInput.aStrafe * Y + PlayerInput.aUp * vect(0.0, 0.0, 1.0);
        Pawn.Acceleration = Pawn.AccelRate * Normal(Pawn.Acceleration);
        if (bCheatFlying && Pawn.Acceleration == vect(0.0, 0.0, 0.0))
        {
            Pawn.Velocity = vect(0.0, 0.0, 0.0);
        }
        UpdateRotation(DeltaTime);
        if (Role < 3)
        {
            ReplicateMove(DeltaTime, Pawn.Acceleration, 0, rot(0, 0, 0));
        }
        else
        {
            ProcessMove(DeltaTime, Pawn.Acceleration, 0, rot(0, 0, 0));
        }
    }
    
    function Bump(Actor Other, PrimitiveComponent OtherComp, Vector HitNormal)
    {
    }
    
    function HearNoise(float Loudness, Actor NoiseMaker, optional name NoiseType)
    {
    }
    
    function SeePlayer(Pawn Seen)
    {
    }
    
    Stop;
}

state PlayerSwimming
{
    event BeginState(name PreviousStateName)
    {
        ClearTimer();
        if (Pawn.Physics != 10)
        {
            Pawn.SetPhysics(3);
        }
    }
    
    event Timer()
    {
        if (!Pawn.PhysicsVolume.bWaterVolume && Role == 3)
        {
            GotoState(Pawn.LandMovementState);
        }
        ClearTimer();
    }
    
    function PlayerMove(float DeltaTime)
    {
        local Rotator OldRotation;
        local Vector X, Y, Z, newAccel;
        
        if (Pawn == none)
        {
            GotoState('Dead');
        }
        else
        {
            GetAxes(Rotation, X, Y, Z);
            newAccel = PlayerInput.aForward * X + PlayerInput.aStrafe * Y + PlayerInput.aUp * vect(0.0, 0.0, 1.0);
            newAccel = Pawn.AccelRate * Normal(newAccel);
            OldRotation = Rotation;
            UpdateRotation(DeltaTime);
            if (Role < 3)
            {
                ReplicateMove(DeltaTime, newAccel, 0, OldRotation - Rotation);
            }
            else
            {
                ProcessMove(DeltaTime, newAccel, 0, OldRotation - Rotation);
            }
            bPressedJump = false;
        }
    }
    
    function ProcessMove(float DeltaTime, Vector newAccel, EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
    {
        Pawn.Acceleration = newAccel;
    }
    
    event NotifyPhysicsVolumeChange(PhysicsVolume NewVolume)
    {
        local Actor HitActor;
        local Vector HitLocation, HitNormal, Checkpoint, X, Y, Z;
        
        if (!Pawn.bCollideActors)
        {
            GotoState(Pawn.LandMovementState);
        }
        if (Pawn.Physics != 10)
        {
            if (!NewVolume.bWaterVolume)
            {
                Pawn.SetPhysics(2);
                if (Pawn.Velocity.Z > float(0))
                {
                    GetAxes(Rotation, X, Y, Z);
                    Pawn.bUpAndOut = X Dot Pawn.Acceleration > float(0) && Pawn.Acceleration.Z > float(0) || Rotation.Pitch > 2048;
                    if (Pawn.bUpAndOut && Pawn.CheckWaterJump(HitNormal))
                    {
                        Pawn.Velocity.Z = Pawn.OutofWaterZ;
                        GotoState(Pawn.LandMovementState);
                    }
                    else if (Pawn.Velocity.Z > float(160) || !Pawn.TouchingWaterVolume())
                    {
                        GotoState(Pawn.LandMovementState);
                    }
                    else
                    {
                        Checkpoint = Pawn.Location;
                        Checkpoint.Z -= Pawn.CylinderComponent.CollisionHeight + 6.0;
                        HitActor = Trace(HitLocation, HitNormal, Checkpoint, Pawn.Location, false);
                        if (HitActor != none)
                        {
                            GotoState(Pawn.LandMovementState);
                        }
                        else
                        {
                            SetTimer(0.7, false);
                        }
                    }
                }
            }
            else
            {
                ClearTimer();
                Pawn.SetPhysics(3);
            }
        }
        else if (!NewVolume.bWaterVolume)
        {
            GotoState(Pawn.LandMovementState);
        }
    }
    
    event bool NotifyLanded(Vector HitNormal, Actor FloorActor)
    {
        if (Pawn.PhysicsVolume.bWaterVolume)
        {
            Pawn.SetPhysics(3);
        }
        else
        {
            GotoState(Pawn.LandMovementState);
        }
        return bUpdating;
    }
    
    function Bump(Actor Other, PrimitiveComponent OtherComp, Vector HitNormal)
    {
    }
    
    function HearNoise(float Loudness, Actor NoiseMaker, optional name NoiseType)
    {
    }
    
    function SeePlayer(Pawn Seen)
    {
    }
    
    Begin:
    Stop;
}

state PlayerDriving
{
    event EndState(name NextStateName)
    {
        CleanOutSavedMoves();
    }
    
    event BeginState(name PreviousStateName)
    {
        CleanOutSavedMoves();
    }
    
    unreliable server function ServerUse()
    {
        local Vehicle CurrentVehicle;
        
        CurrentVehicle = Vehicle(Pawn);
        CurrentVehicle.DriverLeave(false);
    }
    
    function PlayerMove(float DeltaTime)
    {
        UpdateRotation(DeltaTime);
        ProcessDrive(PlayerInput.RawJoyUp, PlayerInput.RawJoyRight, PlayerInput.aUp, bPressedJump);
        if (Role < 3)
        {
            ServerDrive(PlayerInput.RawJoyUp, PlayerInput.RawJoyRight, PlayerInput.aUp, bPressedJump, ((Rotation.Yaw & 65535) << 16) + (Rotation.Pitch & 65535));
        }
        bPressedJump = false;
    }
    
    function ProcessDrive(float InForward, float InStrafe, float InUp, bool InJump)
    {
        local Vehicle CurrentVehicle;
        
        CurrentVehicle = Vehicle(Pawn);
        if (CurrentVehicle != none)
        {
            bPressedJump = InJump;
            CurrentVehicle.SetInputs(InForward, -InStrafe, InUp);
            CheckJumpOrDuck();
        }
    }
    
    function ProcessMove(float DeltaTime, Vector newAccel, EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
    {
    }
    
    function Bump(Actor Other, PrimitiveComponent OtherComp, Vector HitNormal)
    {
    }
    
    function HearNoise(float Loudness, Actor NoiseMaker, optional name NoiseType)
    {
    }
    
    function SeePlayer(Pawn Seen)
    {
    }
    
    Stop;
}

state PlayerClimbing
{
    event EndState(name NextStateName)
    {
        if (Pawn != none)
        {
            Pawn.SetRemoteViewPitch(0);
            Pawn.ShouldCrouch(false);
        }
    }
    
    event BeginState(name PreviousStateName)
    {
        Pawn.ShouldCrouch(false);
        bPressedJump = false;
    }
    
    function PlayerMove(float DeltaTime)
    {
        local Vector X, Y, Z, newAccel;
        local Rotator OldRotation, ViewRotation;
        
        GetAxes(Rotation, X, Y, Z);
        if (Pawn.OnLadder != none)
        {
            newAccel = PlayerInput.aForward * Pawn.OnLadder.ClimbDir;
            if (Pawn.OnLadder.bAllowLadderStrafing)
            {
                newAccel += PlayerInput.aStrafe * Y;
            }
        }
        else
        {
            newAccel = PlayerInput.aForward * X + PlayerInput.aStrafe * Y;
        }
        newAccel = Pawn.AccelRate * Normal(newAccel);
        ViewRotation = Rotation;
        SetRotation(ViewRotation);
        OldRotation = Rotation;
        UpdateRotation(DeltaTime);
        if (Role < 3)
        {
            ReplicateMove(DeltaTime, newAccel, 0, OldRotation - Rotation);
        }
        else
        {
            ProcessMove(DeltaTime, newAccel, 0, OldRotation - Rotation);
        }
        bPressedJump = false;
    }
    
    function ProcessMove(float DeltaTime, Vector newAccel, EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
    {
        if (Pawn == none)
        {
            return;
        }
        if (Role == 3)
        {
            Pawn.SetRemoteViewPitch(Rotation.Pitch);
        }
        Pawn.Acceleration = newAccel;
        if (bPressedJump)
        {
            Pawn.DoJump(bUpdating);
            if (Pawn.Physics == 2)
            {
                GotoState(Pawn.LandMovementState);
            }
        }
    }
    
    event NotifyPhysicsVolumeChange(PhysicsVolume NewVolume)
    {
        if (NewVolume.bWaterVolume)
        {
            GotoState(Pawn.WaterMovementState);
        }
        else
        {
            GotoState(Pawn.LandMovementState);
        }
    }
    
    function Bump(Actor Other, PrimitiveComponent OtherComp, Vector HitNormal)
    {
    }
    
    function HearNoise(float Loudness, Actor NoiseMaker, optional name NoiseType)
    {
    }
    
    function SeePlayer(Pawn Seen)
    {
    }
    
    Stop;
}

state PlayerWalking
{
    event EndState(name NextStateName)
    {
        GroundPitch = 0;
        if (Pawn != none)
        {
            Pawn.SetRemoteViewPitch(0);
            if (bDuck == 0)
            {
                Pawn.ShouldCrouch(false);
            }
        }
    }
    
    event BeginState(name PreviousStateName)
    {
        DoubleClickDir = 0;
        bPressedJump = false;
        GroundPitch = 0;
        if (Pawn != none)
        {
            Pawn.ShouldCrouch(false);
            if (Pawn.Physics != 2 && Pawn.Physics != 17 && Pawn.Physics != 10 && Pawn.Physics != 14)
            {
                LogInternal("previous physics is " @ string(Pawn.Physics) @ " when playerwalking starts");
                Pawn.SetPhysics(1);
            }
        }
    }
    
    function PlayerMove(float DeltaTime)
    {
        local Vector X, Y, Z, newAccel;
        local EDoubleClickDir DoubleClickMove;
        local Rotator OldRotation;
        local bool bSaveJump;
        
        if (Pawn == none)
        {
            GotoState('Dead');
        }
        else
        {
            GetAxes(Pawn.Rotation, X, Y, Z);
            newAccel = PlayerInput.aForward * X + PlayerInput.aStrafe * Y;
            newAccel.Z = 0.0;
            newAccel = Pawn.AccelRate * Normal(newAccel);
            DoubleClickMove = PlayerInput.CheckForDoubleClickMove(DeltaTime / WorldInfo.TimeDilation);
            OldRotation = Rotation;
            UpdateRotation(DeltaTime);
            bDoubleJump = false;
            if (bPressedJump && Pawn.CannotJumpNow())
            {
                bSaveJump = true;
                bPressedJump = false;
            }
            else
            {
                bSaveJump = false;
            }
            if (Role < 3)
            {
                ReplicateMove(DeltaTime, newAccel, DoubleClickMove, OldRotation - Rotation);
            }
            else
            {
                ProcessMove(DeltaTime, newAccel, DoubleClickMove, OldRotation - Rotation);
            }
            bPressedJump = bSaveJump;
        }
    }
    
    function ProcessMove(float DeltaTime, Vector newAccel, EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
    {
        if (Pawn == none)
        {
            return;
        }
        if (Role == 3)
        {
            Pawn.SetRemoteViewPitch(Rotation.Pitch);
        }
        Pawn.Acceleration = newAccel;
        CheckJumpOrDuck();
    }
    
    event NotifyPhysicsVolumeChange(PhysicsVolume NewVolume)
    {
        if (NewVolume.bWaterVolume && Pawn.bCollideWorld)
        {
            GotoState(Pawn.WaterMovementState);
        }
    }
    
    function Bump(Actor Other, PrimitiveComponent OtherComp, Vector HitNormal)
    {
    }
    
    function HearNoise(float Loudness, Actor NoiseMaker, optional name NoiseType)
    {
    }
    
    function SeePlayer(Pawn Seen)
    {
    }
    
    Begin:
    Stop;
}

defaultproperties
{
    CameraClass="Camera"
    PlayerOwnerDataStoreClass="PlayerOwnerDataStore"
    bIsUsingStreamingVolumes=True
    bNoCurrentUser=True
    bCheckRelevancyThroughPortals=True
    MaxResponseTime=0.125
    FOVAngle=85.0
    DesiredFOV=85.0
    DefaultFOV=85.0
    LODDistanceFactor=1.0
    SavedMoveClass="SavedMove"
    LastSpeedHackLog=-100.0
    QuickSaveString="Salvataggio veloce"
    CheatClass="CheatManager"
    InputClass="PlayerInput"
    CylinderComponent="Default__PlayerController.CollisionCylinder"
    InteractDistance=512.0
    SpectatorCameraSpeed=600.0
    MinRespawnDelay=1.0
    MaxConcurrentHearSounds=32
    PhysMatLogInfo="=== PhysMat Info ==="
    bIsPlayer=True
    bCanDoSpecial=True
    Components(0)="Default__PlayerController.CollisionCylinder"
    NetPriority=3.0
    CollisionComponent="Default__PlayerController.CollisionCylinder"
}

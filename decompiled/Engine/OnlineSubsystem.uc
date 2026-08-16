class OnlineSubsystem extends Object
    abstract
    native
    notplaceable
    config(Engine);

enum EOnlineNewsType
{
    ONT_Unknown,
    ONT_GameNews,
    ONT_ContentAnnouncements,
    ONT_Misc,
};

enum EOnlineAccountCreateStatus
{
    OACS_CreateSuccessful,
    OACS_UnknownError,
    OACS_InvalidUserName,
    OACS_InvalidPassword,
    OACS_InvalidUniqueUserName,
    OACS_UniqueUserNameInUse,
    OACS_ServiceUnavailable,
};

enum ELanBeaconState
{
    LANB_NotUsingLanBeacon,
    LANB_Hosting,
    LANB_Searching,
};

enum ENATType
{
    NAT_Unknown,
    NAT_Open,
    NAT_Moderate,
    NAT_Strict,
};

enum EOnlineServerConnectionStatus
{
    OSCS_NotConnected,
    OSCS_Connected,
    OSCS_ConnectionDropped,
    OSCS_NoNetworkConnection,
    OSCS_ServiceUnavailable,
    OSCS_UpdateRequired,
    OSCS_ServersTooBusy,
    OSCS_DuplicateLoginDetected,
    OSCS_InvalidUser,
};

enum EOnlineFriendState
{
    OFS_Offline,
    OFS_Online,
    OFS_Away,
    OFS_Busy,
};

enum EOnlineEnumerationReadState
{
    OERS_NotStarted,
    OERS_InProgress,
    OERS_Done,
    OERS_Failed,
};

enum EOnlineGameState
{
    OGS_NoSession,
    OGS_Pending,
    OGS_Starting,
    OGS_InProgress,
    OGS_Ending,
    OGS_Ended,
};

enum ENetworkNotificationPosition
{
    NNP_TopLeft,
    NNP_TopCenter,
    NNP_TopRight,
    NNP_CenterLeft,
    NNP_Center,
    NNP_CenterRight,
    NNP_BottomLeft,
    NNP_BottomCenter,
    NNP_BottomRight,
};

enum EFeaturePrivilegeLevel
{
    FPL_Disabled,
    FPL_EnabledFriendsOnly,
    FPL_Enabled,
};

enum ELoginStatus
{
    LS_NotLoggedIn,
    LS_UsingLocalProfile,
    LS_LoggedIn,
};

struct native OnlinePartyMember
{
    var const UniqueNetId UniqueId;
    var const string NickName;
    var const byte LocalUserNum;
    var const ENATType NatType;
    var const int TitleId;
    var const bool bIsLocal;
    var const bool bIsInPartyVoice;
    var const bool bIsTalking;
    var const bool bIsInGameSession;
    var const native transient Pointer SessionInfo;
    var const QWord Data1;
    var const QWord Data2;
};

struct native AchievementDetails
{
    var const int Id;
    var const string AchievementName;
    var const string Description;
    var const string HowTo;
    var Surface Image;
    var const int GamerPoints;
    var const bool bIsSecret;
    var const bool bWasAchievedOnline;
    var const bool bWasAchievedOffline;
};

struct native NamedSession
{
    var name SessionName;
    var const native transient Pointer SessionInfo;
    var OnlineGameSettings GameSettings;
    var array<OnlineRegistrant> Registrants;
    var array<OnlineArbitrationRegistrant> ArbitrationRegistrants;
};

struct native CommunityContentMetadata
{
    var int ContentType;
    var array<SettingsProperty> MetadataItems;
};

struct native CommunityContentFile
{
    var int ContentId;
    var int FileId;
    var int ContentType;
    var int FileSize;
    var UniqueNetId Owner;
    var int DownloadCount;
    var float AverageRating;
    var int RatingCount;
    var int LastRatingGiven;
    var string LocalFilePath;
};

struct native TitleFile
{
    var string Filename;
    var EOnlineEnumerationReadState AsyncState;
    var array<byte> Data;
};

struct native NamedInterfaceDef
{
    var name InterfaceName;
    var string InterfaceClassName;
};

struct native NamedInterface
{
    var name InterfaceName;
    var Object InterfaceObject;
};

struct native OnlineFriendMessage
{
    var UniqueNetId SendingPlayerId;
    var string SendingPlayerNick;
    var bool bIsFriendInvite;
    var bool bIsGameInvite;
    var bool bWasAccepted;
    var bool bWasDenied;
    var string Message;
};

struct native RemoteTalker
{
    var UniqueNetId TalkerId;
    var float LastNotificationTime;
    var bool bWasTalking;
    var bool bIsTalking;
    var bool bIsRegistered;
};

struct native LocalTalker
{
    var bool bHasVoice;
    var bool bHasNetworkedVoice;
    var bool bIsRecognizingSpeech;
    var bool bWasTalking;
    var bool bIsTalking;
    var bool bIsRegistered;
};

struct native OnlinePlayerScore
{
    var UniqueNetId PlayerID;
    var int TeamID;
    var int Score;
};

struct SpeechRecognizedWord
{
    var int WordId;
    var string WordText;
    var float Confidence;
};

struct native OnlineArbitrationRegistrant extends OnlineRegistrant
{
    var const QWord MachineId;
    var const int Trustworthiness;
};

struct native OnlineRegistrant
{
    var const UniqueNetId PlayerNetId;
};

struct native OnlineContent
{
    var int UserIndex;
    var string FriendlyName;
    var string ContentPath;
    var array<string> ContentPackages;
    var array<string> ContentFiles;
};

struct native OnlineFriend
{
    var const UniqueNetId UniqueId;
    var const QWord SessionId;
    var const string NickName;
    var const string PresenceInfo;
    var const EOnlineFriendState FriendState;
    var const bool bIsOnline;
    var const bool bIsPlaying;
    var const bool bIsPlayingThisGame;
    var const bool bIsJoinable;
    var const bool bHasVoiceSupport;
    var bool bHaveInvited;
    var const bool bHasInvitedYou;
};

struct native FriendsQuery
{
    var UniqueNetId UniqueId;
    var bool bIsFriend;
};

struct native UniqueNetId
{
    var QWord Uid;
};

var const native noexport Pointer VfTable_FTickableObject;
var OnlineAccountInterface AccountInterface;
var OnlinePlayerInterface PlayerInterface;
var OnlinePlayerInterfaceEx PlayerInterfaceEx;
var OnlineSystemInterface SystemInterface;
var OnlineGameInterface GameInterface;
var OnlineContentInterface ContentInterface;
var OnlineVoiceInterface VoiceInterface;
var OnlineStatsInterface StatsInterface;
var OnlineNewsInterface NewsInterface;
var OnlinePartyChatInterface PartyChatInterface;
var array<NamedInterface> NamedInterfaces;
var config array<NamedInterfaceDef> NamedInterfaceDefs;
var const array<NamedSession> Sessions;
var config bool bUseBuildIdOverride;
var config int BuildIdOverride;
var config string IniLocPatcherClassName;
var transient IniLocPatcher Patcher;
var config float AsyncMinCompletionTime;

function SetDebugSpewLevel(int DebugSpewLevel)
{
}

function DumpVoiceRegistration()
{
}

static function DumpNetIds(out const array<UniqueNetId> Players, string DebugLabel)
{
    local int PlayerIdx;
    local UniqueNetId NetId;
    
    for (PlayerIdx = 0; PlayerIdx < Players.Length; PlayerIdx++)
    {
        NetId = Players[PlayerIdx];
        LogInternal(DebugLabel $ ": " $ " PlayerIdx=" $ string(PlayerIdx) $ " UniqueId=" $ UniqueNetIdToString(NetId));
    }
}

function DumpSessionState()
{
    local int Index, PlayerIndex;
    local UniqueNetId NetId, ZeroId;
    
    NetId = ZeroId;
    ZeroId = NetId;
    LogInternal("Unreal online session state");
    LogInternal("-------------------------------------------------------------");
    LogInternal("");
    LogInternal("Number of sessions: " $ string(Sessions.Length));
    for (Index = 0; Index < Sessions.Length; Index++)
    {
        LogInternal("  Session: " $ string(Sessions[Index].SessionName));
        DumpGameSettings(Sessions[Index].GameSettings);
        LogInternal("");
        LogInternal("    Number of players: " $ string(Sessions[Index].Registrants.Length));
        for (PlayerIndex = 0; PlayerIndex < Sessions[Index].Registrants.Length; PlayerIndex++)
        {
            NetId = Sessions[Index].Registrants[PlayerIndex].PlayerNetId;
            LogInternal("      Player: " $ UniqueNetIdToString(NetId));
        }
        LogInternal("    Number of arbitrated players: " $ string(Sessions[Index].ArbitrationRegistrants.Length));
        for (PlayerIndex = 0; PlayerIndex < Sessions[Index].ArbitrationRegistrants.Length; PlayerIndex++)
        {
            NetId = Sessions[Index].ArbitrationRegistrants[PlayerIndex].PlayerNetId;
            LogInternal("      Player: " $ UniqueNetIdToString(NetId));
        }
    }
}

static function DumpGameSettings(const OnlineGameSettings GameSettings)
{
    LogInternal("    OnlineGameSettings: " $ string(GameSettings));
    LogInternal("      OwningPlayerName: " $ GameSettings.OwningPlayerName);
    LogInternal("      OwningPlayerId: " $ UniqueNetIdToString(GameSettings.OwningPlayerId));
    LogInternal("      PingInMs: " $ string(GameSettings.PingInMs));
    LogInternal("      NumPublicConnections: " $ string(GameSettings.NumPublicConnections));
    LogInternal("      NumOpenPublicConnections: " $ string(GameSettings.NumOpenPublicConnections));
    LogInternal("      NumPrivateConnections: " $ string(GameSettings.NumPrivateConnections));
    LogInternal("      NumOpenPrivateConnections: " $ string(GameSettings.NumOpenPrivateConnections));
    LogInternal("      bIsLanMatch: " $ string(GameSettings.bIsLanMatch));
    LogInternal("      bIsDedicated: " $ string(GameSettings.bIsDedicated));
    LogInternal("      bUsesStats: " $ string(GameSettings.bUsesStats));
    LogInternal("      bUsesArbitration: " $ string(GameSettings.bUsesArbitration));
    LogInternal("      bAntiCheatProtected: " $ string(GameSettings.bAntiCheatProtected));
    LogInternal("      bShouldAdvertise: " $ string(GameSettings.bShouldAdvertise));
    LogInternal("      bAllowJoinInProgress: " $ string(GameSettings.bAllowJoinInProgress));
    LogInternal("      bAllowInvites: " $ string(GameSettings.bAllowInvites));
    LogInternal("      bUsesPresence: " $ string(GameSettings.bUsesPresence));
    LogInternal("      bWasFromInvite: " $ string(GameSettings.bWasFromInvite));
    LogInternal("      bAllowJoinViaPresence: " $ string(GameSettings.bAllowJoinViaPresence));
    LogInternal("      bAllowJoinViaPresenceFriendsOnly: " $ string(GameSettings.bAllowJoinViaPresenceFriendsOnly));
    LogInternal("      GameState: " $ string(GameSettings.GameState));
}

native static final function int GetNumSupportedLogins()
{
}

native function int GetBuildUniqueId()
{
}

native static final function bool AreUniqueNetIdsEqual(out const UniqueNetId NetIdA, out const UniqueNetId NetIdB)
{
    NetIdA;
    NetIdB;
}

native static final function bool StringToUniqueNetId(string UniqueNetIdString, out UniqueNetId out_UniqueId)
{
    UniqueNetIdString;
    out_UniqueId;
}

native static final function string UniqueNetIdToString(out const UniqueNetId IdToConvert)
{
    IdToConvert;
}

event Object GetNamedInterface(name InterfaceName)
{
    local int InterfaceIndex;
    
    InterfaceIndex = NamedInterfaces.Find('InterfaceName', InterfaceName);
    if (InterfaceIndex != -1)
    {
        return NamedInterfaces[InterfaceIndex].InterfaceObject;
    }
    return none;
}

event SetNamedInterface(name InterfaceName, Object NewInterface)
{
    local int InterfaceIndex;
    
    InterfaceIndex = NamedInterfaces.Find('InterfaceName', InterfaceName);
    if (InterfaceIndex == -1)
    {
        InterfaceIndex = NamedInterfaces.Length;
        NamedInterfaces.Length = NamedInterfaces.Length + 1;
        NamedInterfaces[InterfaceIndex].InterfaceName = InterfaceName;
    }
    NamedInterfaces[InterfaceIndex].InterfaceObject = NewInterface;
}

event bool SetPartyChatInterface(Object NewInterface)
{
    PartyChatInterface = OnlinePartyChatInterface(NewInterface);
    return NotEqual_InterfaceInterface(PartyChatInterface, OnlinePartyChatInterface(none));
}

event bool SetNewsInterface(Object NewInterface)
{
    NewsInterface = OnlineNewsInterface(NewInterface);
    return NotEqual_InterfaceInterface(NewsInterface, OnlineNewsInterface(none));
}

event bool SetStatsInterface(Object NewInterface)
{
    StatsInterface = OnlineStatsInterface(NewInterface);
    return NotEqual_InterfaceInterface(StatsInterface, OnlineStatsInterface(none));
}

event bool SetVoiceInterface(Object NewInterface)
{
    VoiceInterface = OnlineVoiceInterface(NewInterface);
    return NotEqual_InterfaceInterface(VoiceInterface, OnlineVoiceInterface(none));
}

event bool SetContentInterface(Object NewInterface)
{
    ContentInterface = OnlineContentInterface(NewInterface);
    return NotEqual_InterfaceInterface(ContentInterface, OnlineContentInterface(none));
}

event bool SetGameInterface(Object NewInterface)
{
    GameInterface = OnlineGameInterface(NewInterface);
    return NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none));
}

event bool SetSystemInterface(Object NewInterface)
{
    SystemInterface = OnlineSystemInterface(NewInterface);
    return NotEqual_InterfaceInterface(SystemInterface, OnlineSystemInterface(none));
}

event bool SetPlayerInterfaceEx(Object NewInterface)
{
    PlayerInterfaceEx = OnlinePlayerInterfaceEx(NewInterface);
    return NotEqual_InterfaceInterface(PlayerInterfaceEx, OnlinePlayerInterfaceEx(none));
}

event bool SetPlayerInterface(Object NewInterface)
{
    PlayerInterface = OnlinePlayerInterface(NewInterface);
    return NotEqual_InterfaceInterface(PlayerInterface, OnlinePlayerInterface(none));
}

event bool SetAccountInterface(Object NewInterface)
{
    AccountInterface = OnlineAccountInterface(NewInterface);
    return NotEqual_InterfaceInterface(AccountInterface, OnlineAccountInterface(none));
}

event Exit()
{
}

event bool PostInit()
{
    local class<IniLocPatcher> IniLocPatcherClass;
    
    if (IniLocPatcherClassName != "")
    {
        LogInternal("Loading " $ IniLocPatcherClassName $ " for INI/Loc patching");
        IniLocPatcherClass = class<IniLocPatcher>(DynamicLoadObject(IniLocPatcherClassName, class'Core.Class'));
        Patcher = new IniLocPatcherClass;
        if (Patcher != none)
        {
            Patcher.Init();
        }
        else
        {
            return false;
        }
    }
    return true;
}

native event bool Init()
{
}

defaultproperties
{
}

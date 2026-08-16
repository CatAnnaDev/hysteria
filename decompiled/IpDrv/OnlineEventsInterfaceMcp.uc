class OnlineEventsInterfaceMcp extends MCPBase
    native
    notplaceable
    config(Engine)
    implements(OnlineEventsInterface);

enum EEventUploadType
{
    EUT_GenericStats,
    EUT_ProfileData,
    EUT_HardwareData,
    EUT_MatchmakingData,
};

struct native EventUploadConfig
{
    var const EEventUploadType UploadType;
    var const string UploadUrl;
    var const float TimeOut;
    var const bool bUseCompression;
};

var const config array<EventUploadConfig> EventUploadConfigs;
var const native array<Pointer> HttpPostObjects;
var config array<EEventUploadType> DisabledUploadTypes;
var const config bool bBinaryStats;

function bool UploadHardwareData(UniqueNetId UniqueId, string PlayerNick)
{
}

native function bool UploadGameplayEventsData(OnlineGameplayEvents Events)
{
    Events;
}

native function bool UploadProfileData(UniqueNetId UniqueId, string PlayerNick, OnlineProfileSettings ProfileSettings)
{
    UniqueId;
    PlayerNick;
    ProfileSettings;
}

defaultproperties
{
}

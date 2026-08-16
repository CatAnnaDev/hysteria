class MeshBeaconClient extends MeshBeacon
    native
    notplaceable
    config(Engine);

enum EMeshBeaconClientState
{
    MBCS_None,
    MBCS_Connecting,
    MBCS_Connected,
    MBCS_ConnectionFailed,
    MBCS_AwaitingResponse,
    MBCS_Closed,
};

struct native ClientBandwidthTestData
{
    var EMeshBeaconBandwidthTestType TestType;
    var EMeshBeaconBandwidthTestState CurrentState;
    var int NumBytesToSendTotal;
    var int NumBytesSentTotal;
    var int NumBytesSentLast;
    var float ElapsedTestTime;
};

struct native ClientConnectionRequest
{
    var UniqueNetId PlayerNetId;
    var ENATType NatType;
    var bool bCanHostVs;
    var float GoodHostRatio;
    var array<ConnectionBandwidthStats> BandwidthHistory;
    var int MinutesSinceLastTest;
};

var const OnlineGameSearchResult HostPendingRequest;
var const ClientConnectionRequest ClientPendingRequest;
var ClientBandwidthTestData CurrentBandwidthTest;
var EMeshBeaconClientState ClientBeaconState;
var EMeshBeaconPacketType ClientBeaconRequestType;
var config float ConnectionRequestTimeout;
var float ConnectionRequestElapsedTime;
var config string ResolverClassName;
var class<ClientBeaconAddressResolver> ResolverClass;
var ClientBeaconAddressResolver Resolver;
var transient bool bUsingRegisteredAddr;
var delegate<OnConnectionRequestResult> __OnConnectionRequestResult__Delegate;
var delegate<OnReceivedBandwidthTestRequest> __OnReceivedBandwidthTestRequest__Delegate;
var delegate<OnReceivedBandwidthTestResults> __OnReceivedBandwidthTestResults__Delegate;
var delegate<OnTravelRequestReceived> __OnTravelRequestReceived__Delegate;
var delegate<OnCreateNewSessionRequestReceived> __OnCreateNewSessionRequestReceived__Delegate;

function DebugRender(Canvas Canvas)
{
    local int HistoryIdx;
    local float XL, YL, Offset;
    
    Offset = 50.0;
    Canvas.Font = class'Engine.Engine'.static.GetTinyFont();
    Canvas.StrLen("============================================================", XL, YL);
    Canvas.SetPos(Offset, Offset);
    Canvas.SetDrawColor(0, 0, 255, 64);
    Canvas.DrawTile(Canvas.DefaultTexture, XL, float(Canvas.SizeY) - Offset * float(2), 0.0, 0.0, 1.0, 1.0);
    Canvas.SetPos(Offset, Offset);
    Canvas.SetDrawColor(255, 255, 255);
    Canvas.DrawText("Debug info for Beacon: " $ string(BeaconName));
    Canvas.DrawText("");
    Canvas.DrawText("Client entry: ");
    Canvas.StrLen("============================================================", XL, YL);
    Canvas.SetPos(Canvas.CurX + float(10), Canvas.CurY);
    Canvas.DrawText("PlayerNetId: " $ class'Engine.OnlineSubsystem'.static.UniqueNetIdToString(ClientPendingRequest.PlayerNetId));
    Canvas.DrawText("NatType: " $ string(ClientPendingRequest.NatType));
    Canvas.DrawText("GoodHostRatio: " $ string(ClientPendingRequest.GoodHostRatio));
    Canvas.DrawText("bCanHostVs: " $ string(ClientPendingRequest.bCanHostVs));
    Canvas.DrawText("MinutesSinceLastTest: " $ string(ClientPendingRequest.MinutesSinceLastTest));
    Canvas.DrawText("Current BandwidthTest: ");
    Canvas.SetPos(Canvas.CurX + float(10), Canvas.CurY);
    Canvas.DrawText("CurrentState: " $ string(CurrentBandwidthTest.CurrentState));
    Canvas.DrawText("TestType: " $ string(CurrentBandwidthTest.TestType));
    Canvas.DrawText("NumBytesToSendTotal: " $ string(CurrentBandwidthTest.NumBytesToSendTotal));
    Canvas.DrawText("NumBytesSentTotal: " $ string(CurrentBandwidthTest.NumBytesSentTotal));
    Canvas.SetPos(Canvas.CurX - float(10), Canvas.CurY);
    Canvas.DrawText("Bandwidth History: " $ string(ClientPendingRequest.BandwidthHistory.Length));
    Canvas.SetPos(Canvas.CurX + float(10), Canvas.CurY);
    for (HistoryIdx = 0; HistoryIdx < ClientPendingRequest.BandwidthHistory.Length; HistoryIdx++)
    {
        Canvas.DrawText(" Upstream bytes/sec: " $ string(ClientPendingRequest.BandwidthHistory[HistoryIdx].UpstreamRate) $ " Roundrtrip msec: " $ string(ClientPendingRequest.BandwidthHistory[HistoryIdx].RoundtripLatency));
    }
}

function DumpInfo()
{
    local int HistoryIdx;
    
    LogInternal("Debug info for Beacon: " $ string(BeaconName));
    LogInternal("");
    LogInternal("Client entry: ");
    LogInternal("\tPlayerNetId: " $ class'Engine.OnlineSubsystem'.static.UniqueNetIdToString(ClientPendingRequest.PlayerNetId));
    LogInternal("\tNatType: " $ string(ClientPendingRequest.NatType));
    LogInternal("\tGoodHostRatio: " $ string(ClientPendingRequest.GoodHostRatio));
    LogInternal("\tbCanHostVs: " $ string(ClientPendingRequest.bCanHostVs));
    LogInternal("\tMinutesSinceLastTest: " $ string(ClientPendingRequest.MinutesSinceLastTest));
    LogInternal("\tBandwidthTest.CurrentState: " $ string(CurrentBandwidthTest.CurrentState));
    LogInternal("\tBandwidthTest.TestType: " $ string(CurrentBandwidthTest.TestType));
    LogInternal("\tBandwidth History: " $ string(ClientPendingRequest.BandwidthHistory.Length));
    for (HistoryIdx = 0; HistoryIdx < ClientPendingRequest.BandwidthHistory.Length; HistoryIdx++)
    {
        LogInternal("\t\t" $ " Upstream bytes/sec: " $ string(ClientPendingRequest.BandwidthHistory[HistoryIdx].UpstreamRate) $ " Downstream bytes/sec: " $ string(ClientPendingRequest.BandwidthHistory[HistoryIdx].DownstreamRate) $ " Roundrtrip msec: " $ string(ClientPendingRequest.BandwidthHistory[HistoryIdx].RoundtripLatency));
    }
}

native function bool SendHostNewGameSessionResponse(bool bSuccess, name SessionName, class<OnlineGameSearch> SearchClass, out const byte PlatformSpecificInfo[80])
{
    bSuccess;
    SessionName;
    SearchClass;
    PlatformSpecificInfo;
}

delegate OnCreateNewSessionRequestReceived(name SessionName, class<OnlineGameSearch> SearchClass, out const array<PlayerMember> Players)
{
}

delegate OnTravelRequestReceived(name SessionName, class<OnlineGameSearch> SearchClass, out const byte PlatformSpecificInfo[80])
{
}

delegate OnReceivedBandwidthTestResults(EMeshBeaconBandwidthTestType TestType, EMeshBeaconBandwidthTestResult TestResult, out const ConnectionBandwidthStats BandwidthStats)
{
}

delegate OnReceivedBandwidthTestRequest(EMeshBeaconBandwidthTestType TestType)
{
}

delegate OnConnectionRequestResult(EMeshBeaconConnectionResult ConnectionResult)
{
}

native function bool BeginBandwidthTest(EMeshBeaconBandwidthTestType TestType, int TestBufferSize)
{
    TestType;
    TestBufferSize;
}

native function bool RequestConnection(out const OnlineGameSearchResult DesiredHost, out const ClientConnectionRequest ClientRequest, bool bRegisterSecureAddress)
{
    DesiredHost;
    ClientRequest;
    bRegisterSecureAddress;
}

native event DestroyBeacon()
{
}

defaultproperties
{
}

class MeshBeaconHost extends MeshBeacon
    native
    notplaceable
    config(Engine);

struct native ClientMeshBeaconConnection
{
    var UniqueNetId PlayerNetId;
    var float ElapsedHeartbeatTime;
    var native transient Pointer Socket;
    var bool bConnectionAccepted;
    var ClientConnectionBandwidthTestData BandwidthTest;
    var ENATType NatType;
    var bool bCanHostVs;
    var float GoodHostRatio;
    var array<ConnectionBandwidthStats> BandwidthHistory;
    var int MinutesSinceLastTest;
};

struct native ClientConnectionBandwidthTestData
{
    var EMeshBeaconBandwidthTestState CurrentState;
    var EMeshBeaconBandwidthTestType TestType;
    var int BytesTotalNeeded;
    var int BytesReceived;
    var Double RequestTestStartTime;
    var Double TestStartTime;
    var ConnectionBandwidthStats BandwidthStats;
};

var const array<ClientMeshBeaconConnection> ClientConnections;
var array<UniqueNetId> PendingPlayerConnections;
var const UniqueNetId OwningPlayerId;
var bool bAllowBandwidthTesting;
var config int ConnectionBacklog;
var delegate<OnReceivedClientConnectionRequest> __OnReceivedClientConnectionRequest__Delegate;
var delegate<OnStartedBandwidthTest> __OnStartedBandwidthTest__Delegate;
var delegate<OnFinishedBandwidthTest> __OnFinishedBandwidthTest__Delegate;
var delegate<OnAllPendingPlayersConnected> __OnAllPendingPlayersConnected__Delegate;
var delegate<OnReceivedClientCreateNewSessionResult> __OnReceivedClientCreateNewSessionResult__Delegate;

function DebugRender(Canvas Canvas, UniqueNetId CurOptimalHostId)
{
    local int ClientIdx, HistoryIdx;
    local UniqueNetId NetId;
    local float XL, YL, Offset;
    
    Offset = 50.0;
    Canvas.Font = class'Engine.Engine'.static.GetTinyFont();
    Canvas.StrLen("============================================================", XL, YL);
    YL = float(Canvas.SizeY) - Offset * float(2);
    Canvas.SetPos(Offset, Offset);
    Canvas.SetDrawColor(0, 0, 255, 64);
    Canvas.DrawTile(Canvas.DefaultTexture, XL, YL, 0.0, 0.0, 1.0, 1.0);
    Canvas.SetPos(Offset, Offset);
    Canvas.SetDrawColor(255, 255, 255);
    Canvas.DrawText("Debug info for Beacon:" $ string(BeaconName));
    if (CurOptimalHostId == OwningPlayerId)
    {
        Canvas.SetDrawColor(255, 255, 0);
    }
    Canvas.DrawText("Owning Host: " $ class'Engine.OnlineSubsystem'.static.UniqueNetIdToString(OwningPlayerId));
    for (ClientIdx = 0; ClientIdx < ClientConnections.Length; ClientIdx++)
    {
        Canvas.SetDrawColor(255, 255, 255);
        if (Canvas.CurY >= YL)
        {
            Canvas.SetPos(Canvas.CurX + XL, Offset);
        }
        NetId = ClientConnections[ClientIdx].PlayerNetId;
        Canvas.DrawText("============================================================");
        Canvas.DrawText("Client connection entry: " $ string(ClientIdx));
        Canvas.SetPos(Canvas.CurX + float(10), Canvas.CurY);
        if (CurOptimalHostId == NetId)
        {
            Canvas.SetDrawColor(255, 255, 0);
        }
        Canvas.DrawText("PlayerNetId: " $ class'Engine.OnlineSubsystem'.static.UniqueNetIdToString(NetId));
        Canvas.SetDrawColor(255, 255, 255);
        Canvas.DrawText("NatType: " $ string(ClientConnections[ClientIdx].NatType));
        Canvas.DrawText("GoodHostRatio: " $ string(ClientConnections[ClientIdx].GoodHostRatio));
        Canvas.DrawText("bCanHostVs: " $ string(ClientConnections[ClientIdx].bCanHostVs));
        Canvas.DrawText("MinutesSinceLastTest: " $ string(ClientConnections[ClientIdx].MinutesSinceLastTest));
        Canvas.DrawText("Current BandwidthTest: ");
        Canvas.SetPos(Canvas.CurX + float(10), Canvas.CurY);
        Canvas.DrawText("CurrentState: " $ string(ClientConnections[ClientIdx].BandwidthTest.CurrentState));
        Canvas.DrawText("TestType: " $ string(ClientConnections[ClientIdx].BandwidthTest.TestType));
        Canvas.DrawText("BytesTotalNeeded: " $ string(ClientConnections[ClientIdx].BandwidthTest.BytesTotalNeeded));
        Canvas.DrawText("BytesReceived: " $ string(ClientConnections[ClientIdx].BandwidthTest.BytesReceived));
        Canvas.DrawText("UpstreamRate bytes/sec: " $ string(ClientConnections[ClientIdx].BandwidthTest.BandwidthStats.UpstreamRate));
        Canvas.SetPos(Canvas.CurX - float(10), Canvas.CurY);
        Canvas.DrawText("Bandwidth History: " $ string(ClientConnections[ClientIdx].BandwidthHistory.Length));
        Canvas.SetPos(Canvas.CurX + float(10), Canvas.CurY);
        for (HistoryIdx = 0; HistoryIdx < ClientConnections[ClientIdx].BandwidthHistory.Length; HistoryIdx++)
        {
            Canvas.DrawText("Upstream bytes/sec: " $ string(ClientConnections[ClientIdx].BandwidthHistory[HistoryIdx].UpstreamRate));
        }
        Canvas.SetPos(Canvas.CurX - float(20), Canvas.CurY);
    }
}

function DumpConnections()
{
    local int ClientIdx, HistoryIdx;
    local UniqueNetId NetId;
    
    LogInternal("Debug info for Beacon: " $ string(BeaconName));
    for (ClientIdx = 0; ClientIdx < ClientConnections.Length; ClientIdx++)
    {
        NetId = ClientConnections[ClientIdx].PlayerNetId;
        LogInternal("");
        LogInternal("Client connection entry: " $ string(ClientIdx));
        LogInternal("\tPlayerNetId: " $ class'Engine.OnlineSubsystem'.static.UniqueNetIdToString(NetId));
        LogInternal("\tNatType: " $ string(ClientConnections[ClientIdx].NatType));
        LogInternal("\tGoodHostRatio: " $ string(ClientConnections[ClientIdx].GoodHostRatio));
        LogInternal("\tbCanHostVs: " $ string(ClientConnections[ClientIdx].bCanHostVs));
        LogInternal("\tMinutesSinceLastTest: " $ string(ClientConnections[ClientIdx].MinutesSinceLastTest));
        LogInternal("\tBandwidthTest.CurrentState: " $ string(ClientConnections[ClientIdx].BandwidthTest.CurrentState));
        LogInternal("\tBandwidthTest.TestType: " $ string(ClientConnections[ClientIdx].BandwidthTest.TestType));
        LogInternal("\tBandwidth History: " $ string(ClientConnections[ClientIdx].BandwidthHistory.Length));
        for (HistoryIdx = 0; HistoryIdx < ClientConnections[ClientIdx].BandwidthHistory.Length; HistoryIdx++)
        {
            LogInternal("\t\t" $ " Upstream bytes/sec: " $ string(ClientConnections[ClientIdx].BandwidthHistory[HistoryIdx].UpstreamRate) $ " Downstream bytes/sec: " $ string(ClientConnections[ClientIdx].BandwidthHistory[HistoryIdx].DownstreamRate) $ " Roundrtrip msec: " $ string(ClientConnections[ClientIdx].BandwidthHistory[HistoryIdx].RoundtripLatency));
        }
    }
    LogInternal("");
}

delegate OnReceivedClientCreateNewSessionResult(bool bSucceeded, name SessionName, class<OnlineGameSearch> SearchClass, out const byte PlatformSpecificInfo[80])
{
}

native function bool RequestClientCreateNewSession(UniqueNetId PlayerNetId, name SessionName, class<OnlineGameSearch> SearchClass, out const array<PlayerMember> Players)
{
    PlayerNetId;
    SessionName;
    SearchClass;
    Players;
}

native function TellClientsToTravel(name SessionName, class<OnlineGameSearch> SearchClass, out const byte PlatformSpecificInfo[80])
{
    SessionName;
    SearchClass;
    PlatformSpecificInfo;
}

delegate OnAllPendingPlayersConnected()
{
}

native function bool AllPlayersConnected(out const array<UniqueNetId> Players)
{
    Players;
}

native function int GetConnectionIndexForPlayer(UniqueNetId PlayerNetId)
{
    PlayerNetId;
}

function SetPendingPlayerConnections(out const array<UniqueNetId> Players)
{
    PendingPlayerConnections = Players;
}

delegate OnFinishedBandwidthTest(UniqueNetId PlayerNetId, EMeshBeaconBandwidthTestType TestType, EMeshBeaconBandwidthTestResult TestResult, out const ConnectionBandwidthStats BandwidthStats)
{
}

delegate OnStartedBandwidthTest(UniqueNetId PlayerNetId, EMeshBeaconBandwidthTestType TestType)
{
}

delegate OnReceivedClientConnectionRequest(out const ClientMeshBeaconConnection NewClientConnection)
{
}

function AllowBandwidthTesting(bool bEnabled)
{
    bAllowBandwidthTesting = bEnabled;
}

native function CancelPendingBandwidthTests()
{
}

native function bool HasPendingBandwidthTest()
{
}

native function CancelInProgressBandwidthTests()
{
}

native function bool HasInProgressBandwidthTest()
{
}

native function bool RequestClientBandwidthTest(UniqueNetId PlayerNetId, EMeshBeaconBandwidthTestType TestType, int TestBufferSize)
{
    PlayerNetId;
    TestType;
    TestBufferSize;
}

native event DestroyBeacon()
{
}

native function bool InitHostBeacon(UniqueNetId InOwningPlayerId)
{
    InOwningPlayerId;
}

defaultproperties
{
    bAllowBandwidthTesting=True
}

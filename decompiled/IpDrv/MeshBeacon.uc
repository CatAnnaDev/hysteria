class MeshBeacon extends Object
    native
    notplaceable
    config(Engine);

enum EMeshBeaconBandwidthTestType
{
    MB_BandwidthTestType_Upstream,
    MB_BandwidthTestType_Downstream,
    MB_BandwidthTestType_RoundtripLatency,
};

enum EMeshBeaconBandwidthTestResult
{
    MB_BandwidthTestResult_Succeeded,
    MB_BandwidthTestResult_Timeout,
    MB_BandwidthTestResult_Error,
};

enum EMeshBeaconBandwidthTestState
{
    MB_BandwidthTestState_NotStarted,
    MB_BandwidthTestState_RequestPending,
    MB_BandwidthTestState_StartPending,
    MB_BandwidthTestState_InProgress,
    MB_BandwidthTestState_Completed,
    MB_BandwidthTestState_Incomplete,
    MB_BandwidthTestState_Timeout,
    MB_BandwidthTestState_Error,
};

enum EMeshBeaconConnectionResult
{
    MB_ConnectionResult_Succeeded,
    MB_ConnectionResult_Duplicate,
    MB_ConnectionResult_Timeout,
    MB_ConnectionResult_Error,
};

enum EMeshBeaconPacketType
{
    MB_Packet_UnknownType,
    MB_Packet_ClientNewConnectionRequest,
    MB_Packet_ClientBeginBandwidthTest,
    MB_Packet_ClientCreateNewSessionResponse,
    MB_Packet_HostNewConnectionResponse,
    MB_Packet_HostBandwidthTestRequest,
    MB_Packet_HostCompletedBandwidthTest,
    MB_Packet_HostTravelRequest,
    MB_Packet_HostCreateNewSessionRequest,
    MB_Packet_DummyData,
    MB_Packet_Heartbeat,
};

struct native PlayerMember
{
    var int TeamNum;
    var int Skill;
    var UniqueNetId NetId;
};

struct native ConnectionBandwidthStats
{
    var int UpstreamRate;
    var int DownstreamRate;
    var int RoundtripLatency;
};

var const native noexport Pointer VfTable_FTickableObject;
var config int MeshBeaconPort;
var native transient Pointer Socket;
var transient bool bIsInTick;
var transient bool bWantsDeferredDestroy;
var bool bShouldTick;
var config float HeartbeatTimeout;
var float ElapsedHeartbeatTime;
var name BeaconName;
var config int SocketSendBufferSize;
var config int SocketReceiveBufferSize;
var config int MaxBandwidthTestBufferSize;
var config int MinBandwidthTestBufferSize;
var config float MaxBandwidthTestSendTime;
var config float MaxBandwidthTestReceiveTime;
var config int MaxBandwidthHistoryEntries;

native event DestroyBeacon()
{
}

defaultproperties
{
    bShouldTick=True
}

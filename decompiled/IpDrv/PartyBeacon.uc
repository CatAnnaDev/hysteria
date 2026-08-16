class PartyBeacon extends Object
    native
    notplaceable
    config(Engine);

enum EPartyReservationResult
{
    PRR_GeneralError,
    PRR_PartyLimitReached,
    PRR_IncorrectPlayerCount,
    PRR_RequestTimedOut,
    PRR_ReservationDuplicate,
    PRR_ReservationNotFound,
    PRR_ReservationAccepted,
};

enum EReservationPacketType
{
    RPT_UnknownPacketType,
    RPT_ClientReservationRequest,
    RPT_ClientReservationUpdateRequest,
    RPT_ClientCancellationRequest,
    RPT_HostReservationResponse,
    RPT_HostReservationCountUpdate,
    RPT_HostTravelRequest,
    RPT_HostIsReady,
    RPT_HostHasCancelled,
    RPT_Heartbeat,
};

struct native PartyReservation
{
    var int TeamNum;
    var UniqueNetId PartyLeader;
    var array<PlayerReservation> PartyMembers;
};

struct native PlayerReservation
{
    var UniqueNetId NetId;
    var int Skill;
    var int XpLevel;
    var Double Mu;
    var Double Sigma;
    var float ElapsedSessionTime;
};

var const native noexport Pointer VfTable_FTickableObject;
var config int PartyBeaconPort;
var native transient Pointer Socket;
var bool bIsInTick;
var bool bWantsDeferredDestroy;
var bool bShouldTick;
var config float HeartbeatTimeout;
var float ElapsedHeartbeatTime;
var name BeaconName;
var delegate<OnDestroyComplete> __OnDestroyComplete__Delegate;

delegate OnDestroyComplete()
{
}

native event DestroyBeacon()
{
}

defaultproperties
{
    bShouldTick=True
}

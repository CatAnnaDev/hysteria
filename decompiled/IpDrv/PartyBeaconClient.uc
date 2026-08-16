class PartyBeaconClient extends PartyBeacon
    native
    notplaceable
    config(Engine);

enum EPartyBeaconClientRequest
{
    PBClientRequest_NewReservation,
    PBClientRequest_UpdateReservation,
};

enum EPartyBeaconClientState
{
    PBCS_None,
    PBCS_Connecting,
    PBCS_Connected,
    PBCS_ConnectionFailed,
    PBCS_AwaitingResponse,
    PBCS_Closed,
};

var const OnlineGameSearchResult HostPendingRequest;
var PartyReservation PendingRequest;
var EPartyBeaconClientState ClientBeaconState;
var EPartyBeaconClientRequest ClientBeaconRequestType;
var config float ReservationRequestTimeout;
var float ReservationRequestElapsedTime;
var config string ResolverClassName;
var class<ClientBeaconAddressResolver> ResolverClass;
var ClientBeaconAddressResolver Resolver;
var delegate<OnReservationRequestComplete> __OnReservationRequestComplete__Delegate;
var delegate<OnReservationCountUpdated> __OnReservationCountUpdated__Delegate;
var delegate<OnTravelRequestReceived> __OnTravelRequestReceived__Delegate;
var delegate<OnHostIsReady> __OnHostIsReady__Delegate;
var delegate<OnHostHasCancelled> __OnHostHasCancelled__Delegate;

native event DestroyBeacon()
{
}

native function bool CancelReservation(UniqueNetId CancellingPartyLeader)
{
    CancellingPartyLeader;
}

native function bool RequestReservationUpdate(out const OnlineGameSearchResult DesiredHost, UniqueNetId RequestingPartyLeader, out const array<PlayerReservation> PlayersToAdd)
{
    DesiredHost;
    RequestingPartyLeader;
    PlayersToAdd;
}

native function bool RequestReservation(out const OnlineGameSearchResult DesiredHost, UniqueNetId RequestingPartyLeader, out const array<PlayerReservation> Players)
{
    DesiredHost;
    RequestingPartyLeader;
    Players;
}

delegate OnHostHasCancelled()
{
}

delegate OnHostIsReady()
{
}

delegate OnTravelRequestReceived(name SessionName, class<OnlineGameSearch> SearchClass, byte PlatformSpecificInfo[80])
{
}

delegate OnReservationCountUpdated(int ReservationRemaining)
{
}

delegate OnReservationRequestComplete(EPartyReservationResult ReservationResult)
{
}

defaultproperties
{
}

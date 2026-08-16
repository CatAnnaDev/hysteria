class OnlineGameSettings extends Settings
    native
    notplaceable;

var databinding int NumPublicConnections;
var databinding int NumPrivateConnections;
var databinding int NumOpenPublicConnections;
var databinding int NumOpenPrivateConnections;
var const QWord ServerNonce;
var databinding bool bShouldAdvertise;
var databinding bool bIsLanMatch;
var databinding bool bUsesStats;
var databinding bool bAllowJoinInProgress;
var databinding bool bAllowInvites;
var databinding bool bUsesPresence;
var databinding bool bAllowJoinViaPresence;
var databinding bool bAllowJoinViaPresenceFriendsOnly;
var databinding bool bUsesArbitration;
var databinding bool bAntiCheatProtected;
var const bool bWasFromInvite;
var databinding bool bIsDedicated;
var const bool bHasSkillUpdateInProgress;
var databinding string OwningPlayerName;
var UniqueNetId OwningPlayerId;
var databinding int PingInMs;
var databinding float MatchQuality;
var const databinding EOnlineGameState GameState;
var const int BuildUniqueId;

defaultproperties
{
    bShouldAdvertise=True
    bUsesStats=True
    bAllowJoinInProgress=True
    bAllowInvites=True
    bUsesPresence=True
    bAllowJoinViaPresence=True
}

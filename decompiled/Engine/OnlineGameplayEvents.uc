class OnlineGameplayEvents extends Object
    native
    notplaceable;

struct native PlayerEvent
{
    var float EventTime;
    var Vector EventLocation;
    var int PlayerIndexAndYaw;
    var int PlayerPitchAndRoll;
};

struct native GameplayEvent
{
    var int PlayerEventAndTarget;
    var int EventNameAndDesc;
};

struct native PlayerInformation
{
    var string ControllerName;
    var string PlayerName;
    var UniqueNetId UniqueId;
    var bool bIsBot;
    var int LastPlayerEventIdx;
};

var const array<PlayerInformation> PlayerList;
var const array<string> EventDescList;
var const array<name> EventNames;
var const array<GameplayEvent> GameplayEvents;
var const array<PlayerEvent> PlayerEvents;
var const string GameplaySessionStartTime;
var const bool bGameplaySessionInProgress;
var const Guid GameplaySessionID;

defaultproperties
{
}

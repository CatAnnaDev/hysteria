class OnlineSubsystemCommonImpl extends OnlineSubsystem
    native
    notplaceable
    config(Engine);

var const native transient Pointer VoiceEngine;
var config int MaxLocalTalkers;
var config int MaxRemoteTalkers;
var config bool bIsUsingSpeechRecognition;
var OnlineGameInterfaceImpl GameInterfaceImpl;

function GetRegisteredPlayers(name SessionName, out array<UniqueNetId> OutRegisteredPlayers)
{
    local int Idx, PlayerIdx;
    
    OutRegisteredPlayers.Length = 0;
    for (Idx = 0; Idx < Sessions.Length; Idx++)
    {
        if (Sessions[Idx].SessionName == SessionName)
        {
            OutRegisteredPlayers.Length = Sessions[Idx].Registrants.Length;
            for (PlayerIdx = 0; PlayerIdx < Sessions[Idx].Registrants.Length; PlayerIdx++)
            {
                OutRegisteredPlayers[PlayerIdx] = Sessions[Idx].Registrants[PlayerIdx].PlayerNetId;
            }
            break;
        }
    }
}

native function bool IsPlayerInSession(name SessionName, UniqueNetId PlayerID)
{
    SessionName;
    PlayerID;
}

event UniqueNetId GetPlayerUniqueNetIdFromIndex(int UserIndex)
{
}

event string GetPlayerNicknameFromIndex(int UserIndex)
{
}

defaultproperties
{
    MaxLocalTalkers=1
    MaxRemoteTalkers=16
}

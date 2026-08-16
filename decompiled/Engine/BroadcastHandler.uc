class BroadcastHandler extends Info
    notplaceable
    config(Game)
    hidecategories(Navigation,Movement,Collision);

var int SentText;
var config bool bMuteSpectators;

event AllowBroadcastLocalizedTeam(int TeamIndex, Actor Sender, class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local PlayerController P;
    
    foreach WorldInfo.AllControllers(class'PlayerController', P)
    {
        if (P.PlayerReplicationInfo != none && P.PlayerReplicationInfo.Team != none && P.PlayerReplicationInfo.Team.TeamIndex == TeamIndex)
        {
            BroadcastLocalized(Sender, P, Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
        }
    }
}

event AllowBroadcastLocalized(Actor Sender, class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local PlayerController P;
    
    foreach WorldInfo.AllControllers(class'PlayerController', P)
    {
        BroadcastLocalized(Sender, P, Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
    }
}

function BroadcastTeam(Controller Sender, coerce string msg, optional name Type)
{
    local PlayerController P;
    
    if (!AllowsBroadcast(Sender, Len(msg)))
    {
        return;
    }
    foreach WorldInfo.AllControllers(class'PlayerController', P)
    {
        if (P.PlayerReplicationInfo.Team == Sender.PlayerReplicationInfo.Team)
        {
            BroadcastText(Sender.PlayerReplicationInfo, P, msg, Type);
        }
    }
}

function Broadcast(Actor Sender, coerce string msg, optional name Type)
{
    local PlayerController P;
    local PlayerReplicationInfo PRI;
    
    if (!AllowsBroadcast(Sender, Len(msg)))
    {
        return;
    }
    if (Pawn(Sender) != none)
    {
        PRI = Pawn(Sender).PlayerReplicationInfo;
    }
    else if (Controller(Sender) != none)
    {
        PRI = Controller(Sender).PlayerReplicationInfo;
    }
    foreach WorldInfo.AllControllers(class'PlayerController', P)
    {
        BroadcastText(PRI, P, msg, Type);
    }
}

function BroadcastLocalized(Actor Sender, PlayerController Receiver, class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    Receiver.ReceiveLocalizedMessage(Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
}

function BroadcastText(PlayerReplicationInfo SenderPRI, PlayerController Receiver, coerce string msg, optional name Type)
{
    Receiver.TeamMessage(SenderPRI, msg, Type);
}

function bool AllowsBroadcast(Actor broadcaster, int InLen)
{
    if (bMuteSpectators && PlayerController(broadcaster) != none && PlayerController(broadcaster).PlayerReplicationInfo.bOnlySpectator)
    {
        return false;
    }
    SentText += InLen;
    return WorldInfo.Pauser != none || SentText < 260;
}

function UpdateSentText()
{
    SentText = 0;
}

defaultproperties
{
    Components(0)="Default__BroadcastHandler.Sprite"
    TickGroup="TG_DuringAsyncWork"
}

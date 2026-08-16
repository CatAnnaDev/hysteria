class GameMessage extends LocalMessage
    notplaceable;

var const localized string SwitchLevelMessage;
var const localized string LeftMessage;
var const localized string FailedTeamMessage;
var const localized string FailedPlaceMessage;
var const localized string FailedSpawnMessage;
var const localized string EnteredMessage;
var const localized string MaxedOutMessage;
var const localized string ArbitrationMessage;
var const localized string OvertimeMessage;
var const localized string GlobalNameChange;
var const localized string NewTeamMessage;
var const localized string NewTeamMessageTrailer;
var const localized string NoNameChange;
var const localized string VoteStarted;
var const localized string VotePassed;
var const localized string MustHaveStats;
var const localized string CantBeSpectator;
var const localized string CantBePlayer;
var const localized string BecameSpectator;
var const localized string NewPlayerMessage;
var const localized string KickWarning;
var const localized string NewSpecMessage;
var const localized string SpecEnteredMessage;

static function string GetString(optional int Switch, optional bool bPRI1HUD, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    switch (Switch)
    {
        case 0:
            return default.OvertimeMessage;
            break;
        case 1:
            if (RelatedPRI_1 == none)
            {
                return default.NewPlayerMessage;
            }
            return RelatedPRI_1.PlayerName $ default.EnteredMessage;
            break;
        case 2:
            if (RelatedPRI_1 == none)
            {
                return "";
            }
            return RelatedPRI_1.OldName @ default.GlobalNameChange @ RelatedPRI_1.PlayerName;
            break;
        case 3:
            if (RelatedPRI_1 == none)
            {
                return "";
            }
            if (OptionalObject == none)
            {
                return "";
            }
            return RelatedPRI_1.PlayerName @ default.NewTeamMessage @ TeamInfo(OptionalObject).GetHumanReadableName() $ default.NewTeamMessageTrailer;
            break;
        case 4:
            if (RelatedPRI_1 == none)
            {
                return "";
            }
            return RelatedPRI_1.PlayerName $ default.LeftMessage;
            break;
        case 5:
            return default.SwitchLevelMessage;
            break;
        case 6:
            return default.FailedTeamMessage;
            break;
        case 7:
            return default.MaxedOutMessage;
            break;
        case 8:
            return default.NoNameChange;
            break;
        case 9:
            return RelatedPRI_1.PlayerName @ default.VoteStarted;
            break;
        case 10:
            return default.VotePassed;
            break;
        case 11:
            return default.MustHaveStats;
            break;
        case 12:
            return default.CantBeSpectator;
            break;
        case 13:
            return default.CantBePlayer;
            break;
        case 14:
            return RelatedPRI_1.PlayerName @ default.BecameSpectator;
            break;
        case 15:
            return default.KickWarning;
            break;
        case 16:
            if (RelatedPRI_1 == none)
            {
                return default.NewSpecMessage;
            }
            return RelatedPRI_1.PlayerName $ default.SpecEnteredMessage;
            break;
        default:
    }
    return "";
}

defaultproperties
{
    SwitchLevelMessage="Cambio livelli"
    LeftMessage=" ha abbandonato la partita."
    FailedTeamMessage="Impossibile trovare una squadra per il giocatore"
    FailedPlaceMessage="Impossibile trovare un punto di partenza"
    FailedSpawnMessage="Impossibile far entrare nella partita il giocatore"
    EnteredMessage=" è entrato nella partita."
    MaxedOutMessage="Il server ha raggiunto la capacità massima."
    ArbitrationMessage="The session has already started."
    OvertimeMessage="Pareggio alla fine del regolamento. Tempo extra con eliminazione diretta!"
    GlobalNameChange="ha cambiato nome in"
    NewTeamMessage="è ora con:"
    NoNameChange="Il nome è già in uso."
    VoteStarted="ha iniziato una votazione."
    VotePassed="Votazione passata."
    MustHaveStats="Per accedere a questo server, devono essere attivate le statistiche mondiali."
    CantBeSpectator="Spiacente, ora non puoi diventare uno spettatore."
    CantBePlayer="Spiacente, ora non puoi diventare un giocatore attivo."
    BecameSpectator="diventa uno spettatore."
    NewPlayerMessage="Un nuovo giocatore è entrato nella partita."
    KickWarning="Fra poco verrai espulso per inattività!"
    NewSpecMessage="Uno spettatore è entrato nella partita "
    SpecEnteredMessage=" partecipa come spettatore."
}

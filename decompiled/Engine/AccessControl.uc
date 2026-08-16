class AccessControl extends Info
    notplaceable
    config(Game)
    hidecategories(Navigation,Movement,Collision);

var globalconfig array<string> IPPolicies;
var globalconfig array<UniqueNetId> BannedIDs;
var const localized string IPBanned;
var const localized string WrongPassword;
var const localized string NeedPassword;
var const localized string SessionBanned;
var const localized string KickedMsg;
var const localized string DefaultKickReason;
var const localized string IdleKickReason;
var class<Admin> AdminClass;
var globalconfig string AdminPassword;
var globalconfig string GamePassword;
var const localized string ACDisplayText[3];
var const localized string ACDescText[3];
var bool bDontAddDefaultAdmin;

function bool IsIDBanned(out const UniqueNetId NetId)
{
    local int I;
    
    for (I = 0; I < BannedIDs.Length; I++)
    {
        if (BannedIDs[I] == NetId)
        {
            return true;
        }
    }
    return false;
}

function bool CheckIPPolicy(string Address)
{
    local int I, J, LastMatchingPolicy;
    local string Policy, Mask;
    local bool bAcceptAddress, bAcceptPolicy;
    
    J = InStr(Address, ":");
    if (J != -1)
    {
        Address = Left(Address, J);
    }
    bAcceptAddress = true;
    for (I = 0; I < IPPolicies.Length; I++)
    {
        J = InStr(IPPolicies[I], ",");
        if (J == -1)
        {
            continue;
        }
        Policy = Left(IPPolicies[I], J);
        Mask = Mid(IPPolicies[I], J + 1);
        if (Policy ~= "ACCEPT")
        {
            bAcceptPolicy = true;
        }
        else if (Policy ~= "DENY")
        {
            bAcceptPolicy = false;
        }
        else
        {
            continue;
        }
        J = InStr(Mask, "*");
        if (J != -1)
        {
            if (Left(Mask, J) == Left(Address, J))
            {
                bAcceptAddress = bAcceptPolicy;
                LastMatchingPolicy = I;
            }
            continue;
        }
        if (Mask == Address)
        {
            bAcceptAddress = bAcceptPolicy;
            LastMatchingPolicy = I;
        }
    }
    if (!bAcceptAddress)
    {
        LogInternal("Denied connection for " $ Address $ " with IP policy " $ IPPolicies[LastMatchingPolicy]);
    }
    return bAcceptAddress;
}

event PreLogin(string Options, string Address, out string OutError, bool bSpectator)
{
    local string InPassword;
    
    OutError = "";
    InPassword = WorldInfo.Game.ParseOption(Options, "Password");
    if (WorldInfo.NetMode != 0 && WorldInfo.Game.AtCapacity(bSpectator))
    {
        OutError = PathName(WorldInfo.Game.GameMessageClass) $ ".MaxedOutMessage";
    }
    else if (GamePassword != "" && Caps(InPassword) != Caps(GamePassword) && AdminPassword == "" || Caps(InPassword) != Caps(AdminPassword))
    {
        OutError = (InPassword == "" ? "Engine.AccessControl.NeedPassword" : "Engine.AccessControl.WrongPassword");
    }
    if (!CheckIPPolicy(Address))
    {
        OutError = "Engine.AccessControl.IPBanned";
    }
}

function bool ValidLogin(string UserName, string Password)
{
    return AdminPassword != "" && Password == AdminPassword;
}

function bool ParseAdminOptions(string Options)
{
    local string InAdminName, InPassword;
    
    InPassword = class'GameInfo'.static.ParseOption(Options, "Password");
    InAdminName = class'GameInfo'.static.ParseOption(Options, "AdminName");
    return ValidLogin(InAdminName, InPassword);
}

function AdminExited(PlayerController P)
{
    local string LogoutString;
    
    LogoutString = P.PlayerReplicationInfo.PlayerName $ "is no longer logged in as a server administrator.";
    LogInternal(LogoutString);
    WorldInfo.Game.Broadcast(P, LogoutString);
}

function AdminEntered(PlayerController P)
{
    local string LoginString;
    
    LoginString = P.PlayerReplicationInfo.PlayerName @ "logged in as a server administrator.";
    LogInternal(LoginString);
    WorldInfo.Game.Broadcast(P, LoginString);
}

function bool AdminLogout(PlayerController P)
{
    if (P.PlayerReplicationInfo.bAdmin)
    {
        P.PlayerReplicationInfo.bAdmin = false;
        P.bGodMode = false;
        P.Suicide();
        return true;
    }
    return false;
}

function bool AdminLogin(PlayerController P, string Password)
{
    if (AdminPassword == "")
    {
        return false;
    }
    if (Password == AdminPassword)
    {
        P.PlayerReplicationInfo.bAdmin = true;
        return true;
    }
    return false;
}

function bool KickPlayer(PlayerController C, string KickReason)
{
    if (C != none && !IsAdmin(C) && NetConnection(C.Player) != none)
    {
        return ForceKickPlayer(C, KickReason);
    }
    return false;
}

function bool ForceKickPlayer(PlayerController C, string KickReason)
{
    if (C != none && NetConnection(C.Player) != none)
    {
        if (C.Pawn != none)
        {
            C.Pawn.Suicide();
        }
        C.ClientWasKicked();
        if (C != none)
        {
            C.Destroy();
        }
        return true;
    }
    return false;
}

function KickBan(string Target)
{
    local PlayerController P;
    local string IP;
    
    P = PlayerController(GetControllerFromString(Target));
    if (NetConnection(P.Player) != none)
    {
        if (!WorldInfo.IsConsoleBuild())
        {
            IP = P.GetPlayerNetworkAddress();
            if (CheckIPPolicy(IP))
            {
                IP = Left(IP, InStr(IP, ":"));
                LogInternal("Adding IP Ban for: " $ IP);
                IPPolicies[IPPolicies.Length] = "DENY," $ IP;
                SaveConfig();
            }
        }
        if (P.PlayerReplicationInfo.UniqueId != P.PlayerReplicationInfo.default.UniqueId && !IsIDBanned(P.PlayerReplicationInfo.UniqueId))
        {
            BannedIDs.AddItem(P.PlayerReplicationInfo.UniqueId);
            SaveConfig();
        }
        KickPlayer(P, DefaultKickReason);
        return;
    }
}

function Kick(string Target)
{
    local Controller C;
    
    C = GetControllerFromString(Target);
    if (C != none && C.PlayerReplicationInfo != none)
    {
        if (PlayerController(C) != none)
        {
            KickPlayer(PlayerController(C), DefaultKickReason);
        }
        else if (C.PlayerReplicationInfo.bBot)
        {
            if (C.Pawn != none)
            {
                C.Pawn.Destroy();
            }
            if (C != none)
            {
                C.Destroy();
            }
        }
    }
}

function Controller GetControllerFromString(string Target)
{
    local Controller C, FinalC;
    local int I;
    
    FinalC = none;
    foreach WorldInfo.AllControllers(class'Controller', C)
    {
        if (C.PlayerReplicationInfo != none && C.PlayerReplicationInfo.PlayerName ~= Target || C.PlayerReplicationInfo.PlayerName ~= Target)
        {
            FinalC = C;
            break;
        }
    }
    if (C == none && WorldInfo != none && WorldInfo.GRI != none)
    {
        for (I = 0; I < WorldInfo.GRI.PRIArray.Length; I++)
        {
            if (string(WorldInfo.GRI.PRIArray[I].PlayerID) == Target)
            {
                FinalC = Controller(WorldInfo.GRI.PRIArray[I].Owner);
                break;
            }
        }
    }
    return FinalC;
}

function bool RequiresPassword()
{
    return GamePassword != "";
}

function SetGamePassword(string P)
{
    GamePassword = P;
    WorldInfo.Game.UpdateGameSettings();
}

function bool SetAdminPassword(string P)
{
    AdminPassword = P;
    return true;
}

function bool IsAdmin(PlayerController P)
{
    if (P != none)
    {
        if (Admin(P) != none)
        {
            return true;
        }
        if (P.PlayerReplicationInfo != none && P.PlayerReplicationInfo.bAdmin)
        {
            return true;
        }
    }
    return false;
}

defaultproperties
{
    IPPolicies(0)="ACCEPT;*"
    IPBanned="Il tuo indirizzo IP è bandito su questo server."
    WrongPassword="La password che hai inserito è errata."
    NeedPassword="Ti serve una password per entrare in questa partita."
    SessionBanned="Il tuo indirizzo IP è stato bandito da questa sessione di gioco."
    KickedMsg="Sei stato escluso d'autorità dalla partita."
    DefaultKickReason="Nessuno specificato"
    IdleKickReason="Espulso per inerzia."
    AdminClass="Admin"
    ACDisplayText="Password partita"
    ACDisplayText[1]="Regole d'accesso"
    ACDisplayText[2]="Password amministratore"
    ACDescText="Se questa password è specificata, i giocatori devono inserirla per accedere a questo server."
    ACDescText[1]="Specifica gli indirizzi IP o le gamme di indirizzi banditi."
    ACDescText[2]="Password necessaria per accedere a questo server con privilegi di amministratore."
    Components(0)="Default__AccessControl.Sprite"
}

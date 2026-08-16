class Admin extends PlayerController
    notplaceable
    config(Game)
    hidecategories(Navigation);

reliable server function ServerSwitch(string URL)
{
    WorldInfo.ServerTravel(URL);
}

exec function Switch(string URL)
{
    ServerSwitch(URL);
}

reliable server function ServerRestartMap()
{
    ClientTravel("?restart", 2);
}

exec function RestartMap()
{
    ServerRestartMap();
}

exec function PlayerList()
{
    local PlayerReplicationInfo PRI;
    
    LogInternal("Player List:");
    foreach DynamicActors(class'PlayerReplicationInfo', PRI)
    {
        LogInternal(PRI.PlayerName @ "( ping" @ string(PRI.Ping) $ ")");
    }
}

reliable server function ServerKick(string S)
{
    WorldInfo.Game.Kick(S);
}

exec function Kick(string S)
{
    ServerKick(S);
}

reliable server function ServerKickBan(string S)
{
    WorldInfo.Game.KickBan(S);
}

exec function KickBan(string S)
{
    ServerKickBan(S);
}

reliable server function ServerAdmin(string CommandLine)
{
    local string Result;
    
    Result = ConsoleCommand(CommandLine);
    if (Result != "")
    {
        ClientMessage(Result);
    }
}

exec function Admin(string CommandLine)
{
    ServerAdmin(CommandLine);
}

simulated event PostBeginPlay()
{
    PostBeginPlay();
    AddCheats();
}

defaultproperties
{
    CylinderComponent="Default__Admin.CollisionCylinder"
    Components(0)="Default__Admin.CollisionCylinder"
    CollisionComponent="Default__Admin.CollisionCylinder"
}

class Info extends Actor
    abstract
    native
    notplaceable
    hidecategories(Navigation,Movement,Collision);

struct native export transient ServerResponseLine
{
    var() int ServerID;
    var() string IP;
    var() int Port;
    var() int QueryPort;
    var() string ServerName;
    var() string MapName;
    var() string GameType;
    var() int CurrentPlayers;
    var() int MaxPlayers;
    var() int Ping;
    var() array<KeyValuePair> ServerInfo;
    var() array<PlayerResponseLine> PlayerInfo;
};

struct native export transient PlayerResponseLine
{
    var() int PlayerNum;
    var() int PlayerID;
    var() string PlayerName;
    var() int Ping;
    var() int Score;
    var() int StatsID;
    var() array<KeyValuePair> PlayerInfo;
};

struct native export transient KeyValuePair
{
    var() string Key;
    var() string Value;
};

defaultproperties
{
    bHidden=True
    bSkipActorPropertyReplication=True
    bOnlyDirtyReplication=True
    Components(0)="Default__Info.Sprite"
    CollisionType="COLLIDE_CustomDefault"
    NetUpdateFrequency=10.0
}

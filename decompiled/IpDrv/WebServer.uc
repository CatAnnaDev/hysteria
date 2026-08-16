class WebServer extends TcpLink
    notplaceable
    transient
    config(Web)
    hidecategories(Navigation,Movement,Collision);

var config string ServerName;
var config string Applications[10];
var config string ApplicationPaths[10];
var config bool bEnabled;
var config int ListenPort;
var config int MaxConnections;
var config int DefaultApplication;
var config int ExpirationSeconds;
var string ServerURL;
var WebApplication ApplicationObjects[10];
var int ConnectionCount;
var int ConnId;

function WebApplication GetApplication(string URI, out string SubURI)
{
    local int I, L;
    
    SubURI = "";
    for (I = 0; I < 10; I++)
    {
        if (ApplicationPaths[I] != "")
        {
            L = Len(ApplicationPaths[I]);
            if (Left(URI, L) ~= ApplicationPaths[I] && Len(URI) == L || Mid(URI, L, 1) == "/")
            {
                SubURI = Mid(URI, L);
                return ApplicationObjects[I];
            }
        }
    }
    LogInternal("No application found to handle request" @ URI);
    return none;
}

event LostChild(Actor C)
{
    LostChild(C);
    ConnectionCount--;
    if (ConnectionCount <= MaxConnections && LinkState != 2)
    {
        LogInternal("WebServer: Listening again - connections have been closed.");
        Listen();
    }
}

event GainedChild(Actor C)
{
    GainedChild(C);
    ConnectionCount++;
    if (MaxConnections > 0 && ConnectionCount > MaxConnections && LinkState == 2)
    {
        LogInternal("WebServer: Too many connections - closing down Listen.");
        Close();
    }
}

event Destroyed()
{
    local int I;
    
    LogInternal("Destroying WebServer");
    for (I = 0; I < 10; I++)
    {
        if (ApplicationObjects[I] != none)
        {
            ApplicationObjects[I].CleanupApp();
        }
    }
    Destroyed();
}

function PostBeginPlay()
{
    local int I;
    local class<WebApplication> ApplicationClass;
    local IpAddr L;
    local string S;
    
    if (WorldInfo.NetMode == 0 || WorldInfo.NetMode == 3)
    {
        Destroy();
        return;
    }
    if (!bEnabled)
    {
        LogInternal("Webserver is not enabled.  Set bEnabled to True in Advanced Options.");
        Destroy();
        return;
    }
    PostBeginPlay();
    if (ServerName == "")
    {
        GetLocalIP(L);
        S = IpAddrToString(L);
        I = InStr(S, ":");
        if (I != -1)
        {
            S = Left(S, I);
        }
        ServerURL = "http://" $ S;
    }
    else
    {
        ServerURL = "http://" $ ServerName;
    }
    if (ListenPort != 80)
    {
        ServerURL = ServerURL $ ":" $ string(ListenPort);
    }
    if (BindPort(ListenPort) > 0)
    {
        if (Listen() == true)
        {
            LogInternal("Web Server Created" @ ServerURL @ "Port:" @ string(ListenPort) @ "MaxCon" @ string(MaxConnections) @ "ExpirationSecs" @ string(ExpirationSeconds) @ "Enabled" @ string(bEnabled));
            for (I = 0; I < 10; I++)
            {
                if (Applications[I] == "")
                {
                    break;
                }
                ApplicationClass = class<WebApplication>(DynamicLoadObject(Applications[I], class'Core.Class'));
                if (ApplicationClass != none)
                {
                    ApplicationObjects[I] = new(none) ApplicationClass;
                    ApplicationObjects[I].WorldInfo = WorldInfo;
                    ApplicationObjects[I].WebServer = self;
                    ApplicationObjects[I].Path = ApplicationPaths[I];
                    ApplicationObjects[I].Init();
                    continue;
                }
                LogInternal("Failed to load" @ Applications[I]);
            }
            return;
        }
        else
        {
            LogInternal("Unable to setup server for listen");
        }
    }
    else
    {
        LogInternal("Unable to bind webserver to a port");
    }
    Destroy();
}

defaultproperties
{
    AcceptClass="WebConnection"
    Components(0)="Default__WebServer.Sprite"
}

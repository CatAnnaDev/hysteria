class InternetLink extends Info
    native
    notplaceable
    transient
    hidecategories(Navigation,Movement,Collision);

enum EReceiveMode
{
    RMODE_Manual,
    RMODE_Event,
};

enum ELineMode
{
    LMODE_auto,
    LMODE_DOS,
    LMODE_UNIX,
    LMODE_MAC,
};

enum ELinkMode
{
    MODE_Text,
    MODE_Line,
    MODE_Binary,
};

struct IpAddr
{
    var int Addr;
    var int Port;
};

var ELinkMode LinkMode;
var ELineMode InLineMode;
var ELineMode OutLineMode;
var EReceiveMode ReceiveMode;
var const Pointer Socket;
var const int Port;
var const Pointer RemoteSocket;
var const native Pointer PrivateResolveInfo;
var const int DataPending;

event ResolveFailed()
{
}

event Resolved(IpAddr Addr)
{
}

native function GetLocalIP(out IpAddr Arg)
{
    Arg;
}

native function bool StringToIpAddr(string Str, out IpAddr Addr)
{
    Str;
    Addr;
}

native function string IpAddrToString(IpAddr Arg)
{
    Arg;
}

native function int GetLastError()
{
}

native function Resolve(coerce string Domain)
{
    Domain;
}

native function bool ParseURL(coerce string URL, out string Addr, out int PortNum, out string LevelName, out string EntryName)
{
    URL;
    Addr;
    PortNum;
    LevelName;
    EntryName;
}

native function bool IsDataPending()
{
}

defaultproperties
{
    ReceiveMode="RMODE_Event"
    Components(0)="Default__InternetLink.Sprite"
}

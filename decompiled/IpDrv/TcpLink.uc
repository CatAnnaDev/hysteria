class TcpLink extends InternetLink
    native
    notplaceable
    transient
    hidecategories(Navigation,Movement,Collision);

enum ELinkState
{
    STATE_Initialized,
    STATE_Ready,
    STATE_Listening,
    STATE_Connecting,
    STATE_Connected,
    STATE_ListenClosePending,
    STATE_ConnectClosePending,
    STATE_ListenClosing,
    STATE_ConnectClosing,
};

var ELinkState LinkState;
var IpAddr RemoteAddr;
var class<TcpLink> AcceptClass;
var const array<byte> SendFIFO;
var const string RecvBuf;

event ReceivedBinary(int Count, byte B[255])
{
}

event ReceivedLine(string Line)
{
}

event ReceivedText(string Text)
{
}

event Closed()
{
}

event Opened()
{
}

event Accepted()
{
}

native function int ReadBinary(int Count, out byte B[255])
{
    Count;
    B;
}

native function int ReadText(out string Str)
{
    Str;
}

native function int SendBinary(int Count, byte B[255])
{
    Count;
    B;
}

native function int SendText(coerce string Str)
{
    Str;
}

native function bool IsConnected()
{
}

native function bool Close()
{
}

native function bool Open(IpAddr Addr)
{
    Addr;
}

native function bool Listen()
{
}

native function int BindPort(optional int PortNum, optional bool bUseNextAvailable)
{
    PortNum;
    bUseNextAvailable;
}

defaultproperties
{
    bAlwaysTick=True
    Components(0)="Default__TcpLink.Sprite"
}

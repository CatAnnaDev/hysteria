class WebConnection extends TcpLink
    notplaceable
    transient
    config(Web)
    hidecategories(Navigation,Movement,Collision);

var WebServer WebServer;
var string ReceivedData;
var WebRequest Request;
var WebResponse Response;
var WebApplication Application;
var bool bDelayCleanup;
var int RawBytesExpecting;
var config int MaxValueLength;
var config int MaxLineLength;
var int ConnId;

final function bool IsHanging()
{
    return bDelayCleanup;
}

function Cleanup()
{
    if (bDelayCleanup)
    {
        return;
    }
    if (Request != none)
    {
        Request = none;
    }
    if (Response != none)
    {
        Response.Connection = none;
        Response = none;
    }
    if (Application != none)
    {
        Application = none;
    }
    Close();
}

function CheckRawBytes()
{
    if (RawBytesExpecting <= 0)
    {
        if (InStr(Locs(Request.ContentType), "application/x-www-form-urlencoded") != 0)
        {
            LogInternal("WebConnection: Unknown form data content-type: " $ Request.ContentType);
            Response.HTTPError(400);
        }
        else
        {
            Request.DecodeFormData(ReceivedData);
            if (Application.PreQuery(Request, Response))
            {
                Application.Query(Request, Response);
                Application.PostQuery(Request, Response);
            }
            ReceivedData = "";
        }
        Cleanup();
    }
}

function EndOfHeaders()
{
    if (Response == none)
    {
        CreateResponseObject();
        Response.HTTPError(400);
        Cleanup();
        return;
    }
    if (Application == none)
    {
        Response.HTTPError(404);
        Cleanup();
        return;
    }
    if (Request.ContentLength != 0 && Request.RequestType == 1)
    {
        RawBytesExpecting = Request.ContentLength;
        RawBytesExpecting -= Len(ReceivedData);
        CheckRawBytes();
    }
    else
    {
        if (Application.PreQuery(Request, Response))
        {
            Application.Query(Request, Response);
            Application.PostQuery(Request, Response);
        }
        Cleanup();
    }
}

function CreateResponseObject()
{
    local int I;
    
    Request = new(none) class'WebRequest';
    Request.RemoteAddr = IpAddrToString(RemoteAddr);
    I = InStr(Request.RemoteAddr, ":");
    if (I > -1)
    {
        Request.RemoteAddr = Left(Request.RemoteAddr, I);
    }
    Response = new(none) class'WebResponse';
    Response.Connection = self;
}

function ProcessPost(string S)
{
    local int I;
    
    if (Request == none)
    {
        CreateResponseObject();
    }
    Request.RequestType = 1;
    S = Mid(S, 5);
    while (Left(S, 1) == " ")
    {
        S = Mid(S, 1);
    }
    I = InStr(S, " ");
    if (I != -1)
    {
        S = Left(S, I);
    }
    I = InStr(S, "?");
    if (I != -1)
    {
        Request.DecodeFormData(Mid(S, I + 1));
        S = Left(S, I);
    }
    Application = WebServer.GetApplication(S, Request.URI);
    if (Application != none && Request.URI == "")
    {
        Response.Redirect(S $ "/");
        Cleanup();
    }
}

function ProcessGet(string S)
{
    local int I;
    
    if (Request == none)
    {
        CreateResponseObject();
    }
    Request.RequestType = 0;
    S = Mid(S, 4);
    while (Left(S, 1) == " ")
    {
        S = Mid(S, 1);
    }
    I = InStr(S, " ");
    if (I != -1)
    {
        S = Left(S, I);
    }
    I = InStr(S, "?");
    if (I != -1)
    {
        Request.DecodeFormData(Mid(S, I + 1));
        S = Left(S, I);
    }
    Application = WebServer.GetApplication(S, Request.URI);
    if (Application != none && Request.URI == "")
    {
        Response.Redirect(S $ "/");
        Cleanup();
    }
    else if (Application == none && WebServer.DefaultApplication != -1)
    {
        Response.Redirect(WebServer.ApplicationPaths[WebServer.DefaultApplication] $ "/");
        Cleanup();
    }
}

function ProcessHead(string S)
{
}

function ReceivedLine(string S)
{
    if (S == "")
    {
        EndOfHeaders();
    }
    else if (Left(S, 4) ~= "GET ")
    {
        ProcessGet(S);
    }
    else if (Left(S, 5) ~= "POST ")
    {
        ProcessPost(S);
    }
    else if (Left(S, 5) ~= "HEAD ")
    {
        ProcessHead(S);
    }
    else if (Request != none)
    {
        Request.ProcessHeaderString(S);
    }
}

event ReceivedText(string Text)
{
    local int I;
    local string S;
    
    ReceivedData $= Text;
    if (RawBytesExpecting > 0)
    {
        RawBytesExpecting -= Len(Text);
        CheckRawBytes();
        return;
    }
    if (Left(ReceivedData, 1) == Chr(10))
    {
        ReceivedData = Mid(ReceivedData, 1);
    }
    I = InStr(ReceivedData, Chr(13));
    while (I != -1)
    {
        S = Left(ReceivedData, I);
        I++;
        if (Mid(ReceivedData, I, 1) == Chr(10))
        {
            I++;
        }
        ReceivedData = Mid(ReceivedData, I);
        ReceivedLine(S);
        if (LinkState != 4)
        {
            return;
        }
        if (RawBytesExpecting > 0)
        {
            CheckRawBytes();
            return;
        }
        I = InStr(ReceivedData, Chr(13));
    }
}

event Timer()
{
    bDelayCleanup = false;
    Cleanup();
}

event Closed()
{
    Destroy();
}

event Accepted()
{
    WebServer = WebServer(Owner);
    SetTimer(30.0, false);
    ConnId = WebServer.ConnId++;
}

defaultproperties
{
    Components(0)="Default__WebConnection.Sprite"
}

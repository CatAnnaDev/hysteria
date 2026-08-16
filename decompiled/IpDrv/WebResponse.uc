class WebResponse extends Object
    native
    notplaceable
    config(Web);

var array<string> headers;
var const native Map_Mirror ReplacementMap;
var const config string IncludePath;
var const localized string CharSet;
var WebConnection Connection;
var bool bSentText;
var bool bSentResponse;

function bool SentResponse()
{
    return bSentResponse;
}

function bool SentText()
{
    return bSentText;
}

function Redirect(string URL)
{
    HTTPResponse("HTTP/1.1 302 Document Moved");
    AddHeader("Location: " $ URL);
    SendText("<html><head><title>Document Moved</title></head>");
    SendText("<body><h1>Object Moved</h1>This document may be found <a HREF=\"" $ URL $ "\">here</a>.</body></html>");
}

function SendStandardHeaders(optional string ContentType, optional bool bCache)
{
    if (ContentType == "")
    {
        ContentType = "text/html";
    }
    if (!bSentResponse)
    {
        HTTPResponse("HTTP/1.1 200 OK");
    }
    AddHeader("Server: UnrealEngine IpDrv Web Server Build " $ Connection.WorldInfo.EngineVersion, false);
    AddHeader("Content-Type: " $ ContentType, false);
    if (bCache)
    {
        AddHeader("Cache-Control: max-age=" $ string(Connection.WebServer.ExpirationSeconds), false);
        AddHeader("Expires: " $ GetHTTPExpiration(Connection.WebServer.ExpirationSeconds), false);
    }
    AddHeader("Connection: Close");
    SendHeaders();
    HTTPHeader("");
}

function HTTPError(int ErrorNum, optional string Data)
{
    switch (ErrorNum)
    {
        case 400:
            HTTPResponse("HTTP/1.1 400 Bad Request");
            SendText("<HTML><HEAD><TITLE>400 Bad Request</TITLE></HEAD><BODY><H1>400 Bad Request</H1>If you got this error from a standard web browser, please mail epicgames.com and submit a bug report.</BODY></HTML>");
            break;
        case 401:
            HTTPResponse("HTTP/1.1 401 Unauthorized");
            AddHeader("WWW-authenticate: basic realm=\"" $ Data $ "\"");
            SendText("<HTML><HEAD><TITLE>401 Unauthorized</TITLE></HEAD><BODY><H1>401 Unauthorized</H1></BODY></HTML>");
            break;
        case 404:
            HTTPResponse("HTTP/1.1 404 Not Found");
            SendText("<HTML><HEAD><TITLE>404 File Not Found</TITLE></HEAD><BODY><H1>404 File Not Found</H1>The URL you requested was not found.</BODY></HTML>");
            break;
        default:
            break;
    }
}

function SendHeaders()
{
    local string hdr;
    
    foreach headers(hdr)
    {
        HTTPHeader(hdr);
    }
}

function AddHeader(string Header, optional bool bReplace = true)
{
    local int I, Idx;
    local string Part, Entry;
    
    I = InStr(Header, ":");
    if (I > -1)
    {
        Part = Caps(Left(Header, I + 1));
    }
    else
    {
        return;
    }
    foreach headers(Entry, Idx)
    {
        if (InStr(Caps(Entry), Part) > -1)
        {
            if (bReplace)
            {
                if (I + 2 >= Len(Header))
                {
                    headers.Remove(Idx, 1);
                }
                else
                {
                    headers[Idx] = Header;
                }
            }
            return;
        }
    }
    if (Len(Header) > I + 2)
    {
        headers.AddItem(Header);
    }
}

function HTTPHeader(string Header)
{
    if (bSentText)
    {
        LogInternal("Can't send headers - already called SendText()");
    }
    else
    {
        if (!bSentResponse)
        {
            HTTPResponse("HTTP/1.1 200 Ok");
        }
        if (Len(Header) == 0)
        {
            bSentText = true;
        }
        Connection.SendText(Header $ Chr(13) $ Chr(10));
    }
}

function HTTPResponse(string Header)
{
    bSentResponse = true;
    HTTPHeader(Header);
}

function FailAuthentication(string Realm)
{
    HTTPError(401, Realm);
}

function bool SendCachedFile(string Filename, optional string ContentType)
{
    if (!bSentText)
    {
        SendStandardHeaders(ContentType, true);
        bSentText = true;
    }
    return IncludeUHTM(Filename);
}

event SendBinary(int Count, byte B[255])
{
    Connection.SendBinary(Count, B);
}

event SendText(string Text, optional bool bNoCRLF)
{
    if (!bSentText)
    {
        SendStandardHeaders();
        bSentText = true;
    }
    if (bNoCRLF)
    {
        Connection.SendText(Text);
    }
    else
    {
        Connection.SendText(Text $ Chr(13) $ Chr(10));
    }
}

native final function Dump()
{
}

native final function string GetHTTPExpiration(optional int OffsetSeconds)
{
    OffsetSeconds;
}

native final function string LoadParsedUHTM(string Filename)
{
    Filename;
}

native final function bool IncludeBinaryFile(string Filename)
{
    Filename;
}

native final function bool IncludeUHTM(string Filename)
{
    Filename;
}

native final function ClearSubst()
{
}

native final function Subst(string Variable, coerce string Value, optional bool bClear)
{
    Variable;
    Value;
    bClear;
}

native final function bool FileExists(string Filename)
{
    Filename;
}

defaultproperties
{
}

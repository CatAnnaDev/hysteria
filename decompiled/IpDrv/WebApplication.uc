class WebApplication extends Object
    notplaceable;

var WorldInfo WorldInfo;
var WebServer WebServer;
var string Path;

function PostQuery(WebRequest Request, WebResponse Response)
{
}

function Query(WebRequest Request, WebResponse Response)
{
}

function bool PreQuery(WebRequest Request, WebResponse Response)
{
    return true;
}

function CleanupApp()
{
    if (WorldInfo != none)
    {
        WorldInfo = none;
    }
    if (WebServer != none)
    {
        WebServer = none;
    }
}

final function Cleanup()
{
}

function Init()
{
}

defaultproperties
{
}

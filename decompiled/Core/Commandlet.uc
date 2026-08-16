class Commandlet extends Object
    abstract
    native
    notplaceable
    transient;

var const localized string HelpDescription;
var const localized string HelpUsage;
var const localized string HelpWebLink;
var const localized array<string> HelpParamNames;
var const localized array<string> HelpParamDescriptions;
var bool IsServer;
var bool IsClient;
var bool IsEditor;
var bool LogToConsole;
var bool ShowErrorCount;

native event int Main(string Params)
{
    Params;
}

defaultproperties
{
    IsServer=True
    IsClient=True
    IsEditor=True
    ShowErrorCount=True
}

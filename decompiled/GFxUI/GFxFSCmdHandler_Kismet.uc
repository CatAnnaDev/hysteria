class GFxFSCmdHandler_Kismet extends GFxFSCmdHandler
    native
    notplaceable;

var const native map<int, int> Events;

native event bool FSCommand(GFxMovie Movie, string Cmd, string Arg)
{
    Movie;
    Cmd;
    Arg;
}

defaultproperties
{
}

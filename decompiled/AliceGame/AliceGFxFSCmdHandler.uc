class AliceGFxFSCmdHandler extends GFxFSCmdHandler
    native
    notplaceable;

native event bool FSCommand(GFxMovie Movie, string Cmd, string Arg)
{
    Movie;
    Cmd;
    Arg;
}

defaultproperties
{
}

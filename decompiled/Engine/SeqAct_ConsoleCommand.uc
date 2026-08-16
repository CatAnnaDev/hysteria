class SeqAct_ConsoleCommand extends SequenceAction
    notplaceable
    hidecategories(Object);

var string Command;
var() array<string> Commands;

static event int GetObjClassVersion()
{
    return GetObjClassVersion() + 1;
}

function VersionUpdated(int OldVersion, int NewVersion)
{
    if (OldVersion < 2 && Commands.Length == 0 || Commands[0] == "")
    {
        Commands[0] = Command;
    }
}

defaultproperties
{
    Commands(0)=""
    ObjName="Console Command"
    ObjCategory="Misc"
}

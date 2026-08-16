class FileLog extends FileWriter
    native
    notplaceable
    hidecategories(Navigation,Movement,Collision);

function CloseLog()
{
    CloseFile();
}

function OpenLog(coerce string LogFilename, optional string extension, optional bool bUnique)
{
    OpenFile(LogFilename, 0, extension, bUnique);
}

defaultproperties
{
    Components(0)="Default__FileLog.Sprite"
}

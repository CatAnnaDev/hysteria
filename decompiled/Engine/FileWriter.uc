class FileWriter extends Info
    native
    notplaceable
    hidecategories(Navigation,Movement,Collision);

enum FWFileType
{
    FWFT_Log,
    FWFT_Stats,
    FWFT_HTML,
    FWFT_User,
    FWFT_Debug,
};

var const native Pointer ArchivePtr;
var const string Filename;
var const FWFileType FileType;
var bool bFlushEachWrite;
var bool bWantsAsyncWrites;

event Destroyed()
{
    CloseFile();
}

native final function Logf(coerce string logString)
{
    logString;
}

native final function CloseFile()
{
}

native final function bool OpenFile(coerce string InFilename, optional FWFileType InFileType, optional string InExtension, optional bool bUnique, optional bool bIncludeTimeStamp)
{
    InFilename;
    InFileType;
    InExtension;
    bUnique;
    bIncludeTimeStamp;
}

defaultproperties
{
    bFlushEachWrite=True
    bTickIsDisabled=True
    Components(0)="Default__FileWriter.Sprite"
}

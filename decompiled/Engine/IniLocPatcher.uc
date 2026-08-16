class IniLocPatcher extends Object
    native
    notplaceable
    config(Engine);

struct native IniLocFileEntry
{
    var string Filename;
    var EOnlineEnumerationReadState ReadState;
};

var config array<IniLocFileEntry> Files;
var transient OnlineSystemInterface SystemInterface;
var delegate<OnReadTitleFileComplete> __OnReadTitleFileComplete__Delegate;

function ClearCachedFiles()
{
    local int Index;
    
    for (Index = 0; Index < Files.Length; Index++)
    {
        Files[Index].ReadState = 0;
    }
}

function ClearReadFileDelegate(delegate<OnReadTitleFileComplete> ReadTitleFileCompleteDelegate)
{
    if (NotEqual_InterfaceInterface(SystemInterface, OnlineSystemInterface(none)))
    {
        SystemInterface.ClearReadTitleFileCompleteDelegate(ReadTitleFileCompleteDelegate);
    }
}

function AddReadFileDelegate(delegate<OnReadTitleFileComplete> ReadTitleFileCompleteDelegate)
{
    if (ReadTitleFileCompleteDelegate != none)
    {
        SystemInterface.AddReadTitleFileCompleteDelegate(ReadTitleFileCompleteDelegate);
    }
}

function AddFileToDownload(string Filename)
{
    local int FileIndex;
    
    FileIndex = Files.Find('Filename', Filename);
    if (FileIndex == -1)
    {
        FileIndex = Files.Length;
        Files.Length = FileIndex + 1;
        Files[FileIndex].Filename = Filename;
    }
    else
    {
        Files[FileIndex].ReadState = 0;
    }
    DownloadFiles();
}

native function ProcessIniLocFile(string Filename, out array<byte> FileData)
{
    Filename;
    FileData;
}

function OnReadFileComplete(bool bWasSuccessful, string Filename)
{
    local int Index;
    local array<byte> FileData;
    
    for (Index = 0; Index < Files.Length; Index++)
    {
        if (Files[Index].Filename == Filename)
        {
            if (bWasSuccessful)
            {
                Files[Index].ReadState = 2;
                if (SystemInterface.GetTitleFileContents(Filename, FileData) && FileData.Length > 0)
                {
                    ProcessIniLocFile(Filename, FileData);
                }
                else
                {
                    Files[Index].ReadState = 3;
                }
                continue;
            }
            LogInternal("Failed to download the file (" $ Files[Index].Filename $ ") from system interface");
            Files[Index].ReadState = 3;
        }
    }
}

function DownloadFiles()
{
    local int Index;
    
    if (NotEqual_InterfaceInterface(SystemInterface, OnlineSystemInterface(none)))
    {
        for (Index = 0; Index < Files.Length; Index++)
        {
            if (Files[Index].ReadState == 0)
            {
                if (SystemInterface.ReadTitleFile(Files[Index].Filename))
                {
                    Files[Index].ReadState = 1;
                    continue;
                }
                Files[Index].ReadState = 3;
            }
        }
    }
}

function Init()
{
    local OnlineSubsystem OnlineSub;
    local int Index;
    
    OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != none)
    {
        SystemInterface = OnlineSub.SystemInterface;
        if (NotEqual_InterfaceInterface(SystemInterface, OnlineSystemInterface(none)))
        {
            SystemInterface.AddReadTitleFileCompleteDelegate(OnReadFileComplete);
        }
        else
        {
            for (Index = 0; Index < Files.Length; Index++)
            {
                Files[Index].ReadState = 3;
            }
        }
    }
}

delegate OnReadTitleFileComplete(bool bWasSuccessful, string Filename)
{
}

defaultproperties
{
}

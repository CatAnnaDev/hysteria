class IniLocPatcherMcp extends IniLocPatcher
    notplaceable
    config(Engine);

var config name McpDownloaderName;
var transient OnlineTitleFileDownloadMcp Downloader;

function ClearCachedFiles()
{
    Downloader.ClearDownloadedFiles();
    ClearCachedFiles();
}

function ClearReadFileDelegate(delegate<OnReadTitleFileComplete> ReadTitleFileCompleteDelegate)
{
    if (Downloader != none)
    {
        Downloader.ClearReadTitleFileCompleteDelegate(ReadTitleFileCompleteDelegate);
    }
    else
    {
        ClearReadFileDelegate(ReadTitleFileCompleteDelegate);
    }
}

function AddReadFileDelegate(delegate<OnReadTitleFileComplete> ReadTitleFileCompleteDelegate)
{
    if (Downloader != none)
    {
        if (ReadTitleFileCompleteDelegate != none)
        {
            Downloader.AddReadTitleFileCompleteDelegate(ReadTitleFileCompleteDelegate);
        }
    }
    else
    {
        AddReadFileDelegate(ReadTitleFileCompleteDelegate);
    }
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
                if (Downloader.GetTitleFileContents(Filename, FileData))
                {
                    ProcessIniLocFile(Filename, FileData);
                }
                else
                {
                    Files[Index].ReadState = 3;
                }
                continue;
            }
            LogInternal("Failed to download the file (" $ Files[Index].Filename $ ") from MCP downloader");
            Files[Index].ReadState = 3;
        }
    }
}

function DownloadFiles()
{
    local int Index;
    
    if (Downloader != none)
    {
        for (Index = 0; Index < Files.Length; Index++)
        {
            if (Files[Index].ReadState == 0)
            {
                if (Downloader.ReadTitleFile(Files[Index].Filename))
                {
                    Files[Index].ReadState = 1;
                    continue;
                }
                Files[Index].ReadState = 3;
            }
        }
    }
    else
    {
        DownloadFiles();
    }
}

function Init()
{
    local OnlineSubsystem OnlineSub;
    
    OnlineSub = class'Engine.GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != none)
    {
        Downloader = OnlineTitleFileDownloadMcp(OnlineSub.GetNamedInterface(McpDownloaderName));
        if (Downloader != none)
        {
            Downloader.AddReadTitleFileCompleteDelegate(OnReadFileComplete);
        }
        else
        {
            Init();
        }
    }
}

defaultproperties
{
}

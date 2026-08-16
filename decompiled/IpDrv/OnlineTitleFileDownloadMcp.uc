class OnlineTitleFileDownloadMcp extends MCPBase
    native
    notplaceable
    config(Engine);

var array<delegate<OnReadTitleFileComplete>> ReadTitleFileCompleteDelegates;
var array<TitleFile> TitleFiles;
var const native Pointer HttpDownloader;
var transient int CurrentIndex;
var config string BaseUrl;
var config float TimeOut;
var delegate<OnReadTitleFileComplete> __OnReadTitleFileComplete__Delegate;

native function bool ClearDownloadedFiles()
{
}

function EOnlineEnumerationReadState GetTitleFileState(string Filename)
{
    local int FileIndex;
    
    FileIndex = TitleFiles.Find('Filename', Filename);
    if (FileIndex != -1)
    {
        return TitleFiles[FileIndex].AsyncState;
    }
    return 3;
}

native function bool GetTitleFileContents(string Filename, out array<byte> FileContents)
{
    Filename;
    FileContents;
}

function ClearReadTitleFileCompleteDelegate(delegate<OnReadTitleFileComplete> ReadTitleFileCompleteDelegate)
{
    local int RemoveIndex;
    
    RemoveIndex = ReadTitleFileCompleteDelegates.Find(ReadTitleFileCompleteDelegate);
    if (RemoveIndex != -1)
    {
        ReadTitleFileCompleteDelegates.Remove(RemoveIndex, 1);
    }
}

function AddReadTitleFileCompleteDelegate(delegate<OnReadTitleFileComplete> ReadTitleFileCompleteDelegate)
{
    if (ReadTitleFileCompleteDelegates.Find(ReadTitleFileCompleteDelegate) == -1)
    {
        ReadTitleFileCompleteDelegates[ReadTitleFileCompleteDelegates.Length] = ReadTitleFileCompleteDelegate;
    }
}

native function bool ReadTitleFile(string FileToRead)
{
    FileToRead;
}

delegate OnReadTitleFileComplete(bool bWasSuccessful, string Filename)
{
}

defaultproperties
{
}

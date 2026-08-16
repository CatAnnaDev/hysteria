class OnlineContentInterface extends Interface
    abstract
    notplaceable;

var delegate<OnContentChange> __OnContentChange__Delegate;
var delegate<OnReadContentComplete> __OnReadContentComplete__Delegate;
var delegate<OnQueryAvailableDownloadsComplete> __OnQueryAvailableDownloadsComplete__Delegate;

function GetAvailableDownloadCounts(byte LocalUserNum, out int NewDownloads, out int TotalDownloads)
{
}

function ClearQueryAvailableDownloadsComplete(byte LocalUserNum, delegate<OnQueryAvailableDownloadsComplete> QueryDownloadsDelegate)
{
}

function AddQueryAvailableDownloadsComplete(byte LocalUserNum, delegate<OnQueryAvailableDownloadsComplete> QueryDownloadsDelegate)
{
}

delegate OnQueryAvailableDownloadsComplete(bool bWasSuccessful)
{
}

function bool QueryAvailableDownloads(byte LocalUserNum, optional int CategoryMask = -1)
{
}

function EOnlineEnumerationReadState GetContentList(byte LocalUserNum, out array<OnlineContent> ContentList)
{
}

function bool ReadContentList(byte LocalUserNum)
{
}

function ClearReadContentComplete(byte LocalUserNum, delegate<OnReadContentComplete> ReadContentCompleteDelegate)
{
}

function AddReadContentComplete(byte LocalUserNum, delegate<OnReadContentComplete> ReadContentCompleteDelegate)
{
}

delegate OnReadContentComplete(bool bWasSuccessful)
{
}

function ClearContentChangeDelegate(delegate<OnContentChange> ContentDelegate, optional byte LocalUserNum = 255)
{
}

function AddContentChangeDelegate(delegate<OnContentChange> ContentDelegate, optional byte LocalUserNum = 255)
{
}

delegate OnContentChange()
{
}

defaultproperties
{
}

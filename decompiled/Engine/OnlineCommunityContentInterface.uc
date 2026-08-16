class OnlineCommunityContentInterface extends Interface
    abstract
    notplaceable;

var delegate<OnReadContentListComplete> __OnReadContentListComplete__Delegate;
var delegate<OnReadFriendsContentListComplete> __OnReadFriendsContentListComplete__Delegate;
var delegate<OnUploadContentComplete> __OnUploadContentComplete__Delegate;
var delegate<OnDownloadContentComplete> __OnDownloadContentComplete__Delegate;
var delegate<OnGetContentPayloadComplete> __OnGetContentPayloadComplete__Delegate;

function RateContent(byte PlayerNum, out const CommunityContentFile FileToRate, int NewRating)
{
}

function ClearGetContentPayloadCompleteDelegate(delegate<OnGetContentPayloadComplete> GetContentPayloadCompleteDelegate)
{
}

function AddGetContentPayloadCompleteDelegate(delegate<OnGetContentPayloadComplete> GetContentPayloadCompleteDelegate)
{
}

delegate OnGetContentPayloadComplete(bool bWasSuccessful, CommunityContentFile FileDownloaded, out const array<byte> Payload)
{
}

function bool GetContentPayload(byte PlayerNum, out const CommunityContentFile FileDownloaded)
{
}

function ClearDownloadContentCompleteDelegate(delegate<OnDownloadContentComplete> DownloadContentCompleteDelegate)
{
}

function AddDownloadContentCompleteDelegate(delegate<OnDownloadContentComplete> DownloadContentCompleteDelegate)
{
}

delegate OnDownloadContentComplete(bool bWasSuccessful, CommunityContentFile FileDownloaded)
{
}

function bool DownloadContent(byte PlayerNum, out const CommunityContentFile FileToDownload)
{
}

function ClearUploadContentCompleteDelegate(delegate<OnUploadContentComplete> UploadContentCompleteDelegate)
{
}

function AddUploadContentCompleteDelegate(delegate<OnUploadContentComplete> UploadContentCompleteDelegate)
{
}

delegate OnUploadContentComplete(bool bWasSuccessful, CommunityContentFile UploadedFile)
{
}

function bool UploadContent(byte PlayerNum, out const array<byte> Payload, out const CommunityContentMetadata MetaData)
{
}

function bool GetFriendsContentList(byte PlayerNum, out const OnlineFriend Friend, out array<CommunityContentFile> ContentFiles)
{
}

function ClearReadFriendsContentListCompleteDelegate(delegate<OnReadFriendsContentListComplete> ReadFriendsContentListCompleteDelegate)
{
}

function AddReadFriendsContentListCompleteDelegate(delegate<OnReadFriendsContentListComplete> ReadFriendsContentListCompleteDelegate)
{
}

delegate OnReadFriendsContentListComplete(bool bWasSuccessful)
{
}

function bool ReadFriendsContentList(byte PlayerNum, out const array<OnlineFriend> Friends, optional int StartAt = 0, optional int NumToRead = -1)
{
}

function bool GetContentList(byte PlayerNum, out array<CommunityContentFile> ContentFiles)
{
}

function ClearReadContentListCompleteDelegate(delegate<OnReadContentListComplete> ReadContentListCompleteDelegate)
{
}

function AddReadContentListCompleteDelegate(delegate<OnReadContentListComplete> ReadContentListCompleteDelegate)
{
}

delegate OnReadContentListComplete(bool bWasSuccessful)
{
}

function bool ReadContentList(byte PlayerNum, optional int StartAt = 0, optional int NumToRead = -1)
{
}

function Exit()
{
}

function bool Init()
{
}

defaultproperties
{
}

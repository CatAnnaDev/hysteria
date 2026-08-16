class OnlineEventsInterface extends Interface
    abstract
    notplaceable;

function bool UploadHardwareData(UniqueNetId UniqueId, string PlayerNick)
{
}

function bool UploadGameplayEventsData(OnlineGameplayEvents Events)
{
}

function bool UploadProfileData(UniqueNetId UniqueId, string PlayerNick, OnlineProfileSettings ProfileSettings)
{
}

defaultproperties
{
}

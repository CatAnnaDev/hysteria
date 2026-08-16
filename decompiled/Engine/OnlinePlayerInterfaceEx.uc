class OnlinePlayerInterfaceEx extends Interface
    abstract
    notplaceable;

var delegate<OnDeviceSelectionComplete> __OnDeviceSelectionComplete__Delegate;
var delegate<OnProfileDataChanged> __OnProfileDataChanged__Delegate;

function bool ShowCustomPlayersUI(byte LocalUserNum, out const array<UniqueNetId> Players, string Title, string Description)
{
}

function bool ShowPlayersUI(byte LocalUserNum)
{
}

function bool ShowFriendsInviteUI(byte LocalUserNum, UniqueNetId PlayerID)
{
}

function ClearProfileDataChangedDelegate(byte LocalUserNum, delegate<OnProfileDataChanged> ProfileDataChangedDelegate)
{
}

function AddProfileDataChangedDelegate(byte LocalUserNum, delegate<OnProfileDataChanged> ProfileDataChangedDelegate)
{
}

delegate OnProfileDataChanged()
{
}

function bool UnlockGamerPicture(byte LocalUserNum, int PictureId)
{
}

function bool IsDeviceValid(int DeviceID, optional int SizeNeeded)
{
}

function int GetDeviceSelectionResults(byte LocalUserNum, out string DeviceName)
{
}

function ClearDeviceSelectionDoneDelegate(byte LocalUserNum, delegate<OnDeviceSelectionComplete> DeviceDelegate)
{
}

function AddDeviceSelectionDoneDelegate(byte LocalUserNum, delegate<OnDeviceSelectionComplete> DeviceDelegate)
{
}

delegate OnDeviceSelectionComplete(bool bWasSuccessful)
{
}

function bool ShowDeviceSelectionUI(byte LocalUserNum, int SizeNeeded, optional bool bForceShowUI, optional bool bManageStorage)
{
}

function bool ShowMembershipMarketplaceUI(byte LocalUserNum)
{
}

function bool ShowContentMarketplaceUI(byte LocalUserNum, optional int CategoryMask = -1, optional int OfferId)
{
}

function bool ShowInviteUI(byte LocalUserNum, optional string InviteText)
{
}

function bool ShowAchievementsUI(byte LocalUserNum)
{
}

function bool ShowMessagesUI(byte LocalUserNum)
{
}

function bool ShowGamerCardUI(byte LocalUserNum, UniqueNetId PlayerID)
{
}

function bool ShowFeedbackUI(byte LocalUserNum, UniqueNetId PlayerID)
{
}

defaultproperties
{
}

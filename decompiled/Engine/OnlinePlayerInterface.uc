class OnlinePlayerInterface extends Interface
    abstract
    notplaceable;

var delegate<OnDLCContentInstalled> __OnDLCContentInstalled__Delegate;
var delegate<OnLoginChange> __OnLoginChange__Delegate;
var delegate<OnLoginCancelled> __OnLoginCancelled__Delegate;
var delegate<OnMutingChange> __OnMutingChange__Delegate;
var delegate<OnFriendsChange> __OnFriendsChange__Delegate;
var delegate<OnLoginFailed> __OnLoginFailed__Delegate;
var delegate<OnLogoutCompleted> __OnLogoutCompleted__Delegate;
var delegate<OnLoginStatusChange> __OnLoginStatusChange__Delegate;
var delegate<OnReadProfileSettingsComplete> __OnReadProfileSettingsComplete__Delegate;
var delegate<OnWriteProfileSettingsComplete> __OnWriteProfileSettingsComplete__Delegate;
var delegate<OnReadPlayerStorageComplete> __OnReadPlayerStorageComplete__Delegate;
var delegate<OnReadPlayerStorageForNetIdComplete> __OnReadPlayerStorageForNetIdComplete__Delegate;
var delegate<OnWritePlayerStorageComplete> __OnWritePlayerStorageComplete__Delegate;
var delegate<OnReadFriendsComplete> __OnReadFriendsComplete__Delegate;
var delegate<OnKeyboardInputComplete> __OnKeyboardInputComplete__Delegate;
var delegate<OnAddFriendByNameComplete> __OnAddFriendByNameComplete__Delegate;
var delegate<OnFriendInviteReceived> __OnFriendInviteReceived__Delegate;
var delegate<OnReceivedGameInvite> __OnReceivedGameInvite__Delegate;
var delegate<OnJoinFriendGameComplete> __OnJoinFriendGameComplete__Delegate;
var delegate<OnFriendMessageReceived> __OnFriendMessageReceived__Delegate;
var delegate<OnUnlockAchievementComplete> __OnUnlockAchievementComplete__Delegate;
var delegate<OnReadAchievementsComplete> __OnReadAchievementsComplete__Delegate;

function EOnlineEnumerationReadState GetAchievements(byte LocalUserNum, out array<AchievementDetails> Achievements, optional int TitleId = 0)
{
}

function ClearReadAchievementsCompleteDelegate(byte LocalUserNum, delegate<OnReadAchievementsComplete> ReadAchievementsCompleteDelegate)
{
}

function AddReadAchievementsCompleteDelegate(byte LocalUserNum, delegate<OnReadAchievementsComplete> ReadAchievementsCompleteDelegate)
{
}

delegate OnReadAchievementsComplete(int TitleId)
{
}

function bool ReadAchievements(byte LocalUserNum, optional int TitleId = 0, optional bool bShouldReadText = true, optional bool bShouldReadImages = false)
{
}

function ClearUnlockAchievementCompleteDelegate(byte LocalUserNum, delegate<OnUnlockAchievementComplete> UnlockAchievementCompleteDelegate)
{
}

function AddUnlockAchievementCompleteDelegate(byte LocalUserNum, delegate<OnUnlockAchievementComplete> UnlockAchievementCompleteDelegate)
{
}

delegate OnUnlockAchievementComplete(bool bWasSuccessful)
{
}

function bool UnlockAchievement(byte LocalUserNum, int AchievementId)
{
}

function bool DeleteMessage(byte LocalUserNum, int MessageIndex)
{
}

function ClearFriendMessageReceivedDelegate(byte LocalUserNum, delegate<OnFriendMessageReceived> MessageDelegate)
{
}

function AddFriendMessageReceivedDelegate(byte LocalUserNum, delegate<OnFriendMessageReceived> MessageDelegate)
{
}

delegate OnFriendMessageReceived(byte LocalUserNum, UniqueNetId SendingPlayer, string SendingNick, string Message)
{
}

function GetFriendMessages(byte LocalUserNum, out array<OnlineFriendMessage> FriendMessages)
{
}

function ClearJoinFriendGameCompleteDelegate(delegate<OnJoinFriendGameComplete> JoinFriendGameCompleteDelegate)
{
}

function AddJoinFriendGameCompleteDelegate(delegate<OnJoinFriendGameComplete> JoinFriendGameCompleteDelegate)
{
}

delegate OnJoinFriendGameComplete(bool bWasSuccessful)
{
}

function bool JoinFriendGame(byte LocalUserNum, UniqueNetId Friend)
{
}

function ClearReceivedGameInviteDelegate(byte LocalUserNum, delegate<OnReceivedGameInvite> ReceivedGameInviteDelegate)
{
}

function AddReceivedGameInviteDelegate(byte LocalUserNum, delegate<OnReceivedGameInvite> ReceivedGameInviteDelegate)
{
}

delegate OnReceivedGameInvite(byte LocalUserNum, string InviterName)
{
}

function bool SendGameInviteToFriends(byte LocalUserNum, array<UniqueNetId> Friends, optional string Text)
{
}

function bool SendGameInviteToFriend(byte LocalUserNum, UniqueNetId Friend, optional string Text)
{
}

function bool SendMessageToFriend(byte LocalUserNum, UniqueNetId Friend, string Message)
{
}

function ClearFriendInviteReceivedDelegate(byte LocalUserNum, delegate<OnFriendInviteReceived> InviteDelegate)
{
}

function AddFriendInviteReceivedDelegate(byte LocalUserNum, delegate<OnFriendInviteReceived> InviteDelegate)
{
}

delegate OnFriendInviteReceived(byte LocalUserNum, UniqueNetId RequestingPlayer, string RequestingNick, string Message)
{
}

function bool RemoveFriend(byte LocalUserNum, UniqueNetId FormerFriend)
{
}

function bool DenyFriendInvite(byte LocalUserNum, UniqueNetId RequestingPlayer)
{
}

function bool AcceptFriendInvite(byte LocalUserNum, UniqueNetId RequestingPlayer)
{
}

function ClearAddFriendByNameCompleteDelegate(byte LocalUserNum, delegate<OnAddFriendByNameComplete> FriendDelegate)
{
}

function AddAddFriendByNameCompleteDelegate(byte LocalUserNum, delegate<OnAddFriendByNameComplete> FriendDelegate)
{
}

delegate OnAddFriendByNameComplete(bool bWasSuccessful)
{
}

function bool AddFriendByName(byte LocalUserNum, string FriendName, optional string Message)
{
}

function bool AddFriend(byte LocalUserNum, UniqueNetId NewFriend, optional string Message)
{
}

function string GetKeyboardInputResults(out byte bWasCanceled)
{
}

function ClearKeyboardInputDoneDelegate(delegate<OnKeyboardInputComplete> InputDelegate)
{
}

function AddKeyboardInputDoneDelegate(delegate<OnKeyboardInputComplete> InputDelegate)
{
}

delegate OnKeyboardInputComplete(bool bWasSuccessful)
{
}

function bool ShowKeyboardUI(byte LocalUserNum, string TitleText, string DescriptionText, optional bool bIsPassword = false, optional bool bShouldValidate = true, optional string DefaultText, optional int MaxResultLength = 256)
{
}

function SetOnlineStatus(byte LocalUserNum, int StatusId, out const array<LocalizedStringSetting> LocalizedStringSettings, out const array<SettingsProperty> Properties)
{
}

function EOnlineEnumerationReadState GetFriendsList(byte LocalUserNum, out array<OnlineFriend> Friends, optional int Count, optional int StartingAt)
{
}

function ClearReadFriendsCompleteDelegate(byte LocalUserNum, delegate<OnReadFriendsComplete> ReadFriendsCompleteDelegate)
{
}

function AddReadFriendsCompleteDelegate(byte LocalUserNum, delegate<OnReadFriendsComplete> ReadFriendsCompleteDelegate)
{
}

delegate OnReadFriendsComplete(bool bWasSuccessful)
{
}

function bool ReadFriendsList(byte LocalUserNum, optional int Count, optional int StartingAt)
{
}

function ClearWritePlayerStorageCompleteDelegate(byte LocalUserNum, delegate<OnWritePlayerStorageComplete> WritePlayerStorageCompleteDelegate)
{
}

function AddWritePlayerStorageCompleteDelegate(byte LocalUserNum, delegate<OnWritePlayerStorageComplete> WritePlayerStorageCompleteDelegate)
{
}

delegate OnWritePlayerStorageComplete(byte LocalUserNum, bool bWasSuccessful)
{
}

function bool WritePlayerStorage(byte LocalUserNum, OnlinePlayerStorage PlayerStorage)
{
}

function OnlinePlayerStorage GetPlayerStorage(byte LocalUserNum)
{
}

function ClearReadPlayerStorageForNetIdCompleteDelegate(UniqueNetId NetId, delegate<OnReadPlayerStorageForNetIdComplete> ReadPlayerStorageForNetIdCompleteDelegate)
{
}

function AddReadPlayerStorageForNetIdCompleteDelegate(UniqueNetId NetId, delegate<OnReadPlayerStorageForNetIdComplete> ReadPlayerStorageForNetIdCompleteDelegate)
{
}

delegate OnReadPlayerStorageForNetIdComplete(UniqueNetId NetId, bool bWasSuccessful)
{
}

function bool ReadPlayerStorageForNetId(UniqueNetId NetId, OnlinePlayerStorage PlayerStorage)
{
}

function ClearReadPlayerStorageCompleteDelegate(byte LocalUserNum, delegate<OnReadPlayerStorageComplete> ReadPlayerStorageCompleteDelegate)
{
}

function AddReadPlayerStorageCompleteDelegate(byte LocalUserNum, delegate<OnReadPlayerStorageComplete> ReadPlayerStorageCompleteDelegate)
{
}

delegate OnReadPlayerStorageComplete(byte LocalUserNum, bool bWasSuccessful)
{
}

function bool ReadPlayerStorage(byte LocalUserNum, OnlinePlayerStorage PlayerStorage)
{
}

function ClearWriteProfileSettingsCompleteDelegate(byte LocalUserNum, delegate<OnWriteProfileSettingsComplete> WriteProfileSettingsCompleteDelegate)
{
}

function AddWriteProfileSettingsCompleteDelegate(byte LocalUserNum, delegate<OnWriteProfileSettingsComplete> WriteProfileSettingsCompleteDelegate)
{
}

delegate OnWriteProfileSettingsComplete(byte LocalUserNum, bool bWasSuccessful)
{
}

function bool WriteProfileSettings(byte LocalUserNum, OnlineProfileSettings ProfileSettings)
{
}

function OnlineProfileSettings GetProfileSettings(byte LocalUserNum)
{
}

function ClearReadProfileSettingsCompleteDelegate(byte LocalUserNum, delegate<OnReadProfileSettingsComplete> ReadProfileSettingsCompleteDelegate)
{
}

function AddReadProfileSettingsCompleteDelegate(byte LocalUserNum, delegate<OnReadProfileSettingsComplete> ReadProfileSettingsCompleteDelegate)
{
}

delegate OnReadProfileSettingsComplete(byte LocalUserNum, bool bWasSuccessful)
{
}

function bool ReadProfileSettings(byte LocalUserNum, OnlineProfileSettings ProfileSettings)
{
}

function ClearFriendsChangeDelegate(byte LocalUserNum, delegate<OnFriendsChange> FriendsDelegate)
{
}

function AddFriendsChangeDelegate(byte LocalUserNum, delegate<OnFriendsChange> FriendsDelegate)
{
}

function ClearMutingChangeDelegate(delegate<OnMutingChange> MutingDelegate)
{
}

function AddMutingChangeDelegate(delegate<OnMutingChange> MutingDelegate)
{
}

function ClearLoginCancelledDelegate(delegate<OnLoginCancelled> CancelledDelegate)
{
}

function AddLoginCancelledDelegate(delegate<OnLoginCancelled> CancelledDelegate)
{
}

function ClearLoginStatusChangeDelegate(delegate<OnLoginStatusChange> LoginStatusDelegate, byte LocalUserNum)
{
}

function AddLoginStatusChangeDelegate(delegate<OnLoginStatusChange> LoginStatusDelegate, byte LocalUserNum)
{
}

delegate OnLoginStatusChange(ELoginStatus NewStatus, ELoginStatus PrevStatus, UniqueNetId NewId)
{
}

function ClearLoginChangeDelegate(delegate<OnLoginChange> LoginDelegate)
{
}

function AddLoginChangeDelegate(delegate<OnLoginChange> LoginDelegate)
{
}

function bool ShowFriendsUI(byte LocalUserNum)
{
}

function bool IsMuted(byte LocalUserNum, UniqueNetId PlayerID)
{
}

function bool AreAnyFriends(byte LocalUserNum, out array<FriendsQuery> Query)
{
}

function bool IsFriend(byte LocalUserNum, UniqueNetId PlayerID)
{
}

function EFeaturePrivilegeLevel CanShowPresenceInformation(byte LocalUserNum)
{
}

function EFeaturePrivilegeLevel CanViewPlayerProfiles(byte LocalUserNum)
{
}

function EFeaturePrivilegeLevel CanPurchaseContent(byte LocalUserNum)
{
}

function EFeaturePrivilegeLevel CanDownloadUserContent(byte LocalUserNum)
{
}

function EFeaturePrivilegeLevel CanCommunicate(byte LocalUserNum)
{
}

function EFeaturePrivilegeLevel CanPlayOnline(byte LocalUserNum)
{
}

function bool IsLocalLogin(byte LocalUserNum)
{
}

function bool IsGuestLogin(byte LocalUserNum)
{
}

function string GetPlayerNickname(byte LocalUserNum)
{
}

function bool GetUniquePlayerId(byte LocalUserNum, out UniqueNetId PlayerID)
{
}

function ELoginStatus GetLoginStatus(byte LocalUserNum)
{
}

function ClearLogoutCompletedDelegate(byte LocalUserNum, delegate<OnLogoutCompleted> LogoutDelegate)
{
}

function AddLogoutCompletedDelegate(byte LocalUserNum, delegate<OnLogoutCompleted> LogoutDelegate)
{
}

delegate OnLogoutCompleted(bool bWasSuccessful)
{
}

function bool Logout(byte LocalUserNum)
{
}

function ClearLoginFailedDelegate(byte LocalUserNum, delegate<OnLoginFailed> LoginDelegate)
{
}

function AddLoginFailedDelegate(byte LocalUserNum, delegate<OnLoginFailed> LoginDelegate)
{
}

delegate OnLoginFailed(byte LocalUserNum, EOnlineServerConnectionStatus ErrorCode)
{
}

function bool AutoLogin()
{
}

function bool Login(byte LocalUserNum, string LoginName, string Password, optional bool bWantsLocalOnly)
{
}

function bool ShowLoginUI(optional bool bShowOnlineOnly = false)
{
}

delegate OnFriendsChange()
{
}

delegate OnMutingChange()
{
}

delegate OnLoginCancelled()
{
}

delegate OnLoginChange(byte LocalUserNum)
{
}

function ClearDLCContentInstalledDelegate(delegate<OnDLCContentInstalled> DLCContentInstalledDelegate)
{
}

function AddDLCContentInstalledDelegate(delegate<OnDLCContentInstalled> DLCContentInstalledDelegate)
{
}

delegate OnDLCContentInstalled()
{
}

defaultproperties
{
}

class OnlineSubsystemPC extends OnlineSubsystemCommonImpl
    native
    notplaceable
    config(Engine)
    implements(OnlinePlayerInterface,OnlineVoiceInterface,OnlineStatsInterface,OnlineSystemInterface);

var const string LoggedInPlayerName;
var const UniqueNetId LoggedInPlayerId;
var array<delegate<OnDLCContentInstalled>> DLCContentInstalledDelegates;
var const native array<Pointer> AsyncTasks;
var config string ProfileDataDirectory;
var config string ProfileDataExtension;
var array<delegate<OnReadProfileSettingsComplete>> ReadProfileSettingsDelegates;
var array<delegate<OnWriteProfileSettingsComplete>> WriteProfileSettingsDelegates;
var OnlineProfileSettings CachedProfile;
var array<delegate<OnRecognitionComplete>> SpeechRecognitionCompleteDelegates;
var array<delegate<OnReadFriendsComplete>> ReadFriendsDelegates;
var array<delegate<OnFriendsChange>> FriendsChangeDelegates;
var array<delegate<OnMutingChange>> MutingChangeDelegates;
var delegate<OnDLCContentInstalled> __OnDLCContentInstalled__Delegate;
var delegate<OnLoginChange> __OnLoginChange__Delegate;
var delegate<OnLoginCancelled> __OnLoginCancelled__Delegate;
var delegate<OnMutingChange> __OnMutingChange__Delegate;
var delegate<OnReadTitleFileComplete> __OnReadTitleFileComplete__Delegate;
var delegate<OnPlayerTalkingStateChange> __OnPlayerTalkingStateChange__Delegate;
var delegate<OnFriendsChange> __OnFriendsChange__Delegate;
var delegate<OnLoginFailed> __OnLoginFailed__Delegate;
var delegate<OnLogoutCompleted> __OnLogoutCompleted__Delegate;
var delegate<OnReadProfileSettingsComplete> __OnReadProfileSettingsComplete__Delegate;
var delegate<OnWriteProfileSettingsComplete> __OnWriteProfileSettingsComplete__Delegate;
var delegate<OnLoginStatusChange> __OnLoginStatusChange__Delegate;
var delegate<OnReadFriendsComplete> __OnReadFriendsComplete__Delegate;
var delegate<OnRecognitionComplete> __OnRecognitionComplete__Delegate;
var delegate<OnReadOnlineStatsComplete> __OnReadOnlineStatsComplete__Delegate;
var delegate<OnFlushOnlineStatsComplete> __OnFlushOnlineStatsComplete__Delegate;
var delegate<OnRegisterHostStatGuidComplete> __OnRegisterHostStatGuidComplete__Delegate;
var delegate<OnLinkStatusChange> __OnLinkStatusChange__Delegate;
var delegate<OnExternalUIChange> __OnExternalUIChange__Delegate;
var delegate<OnControllerChange> __OnControllerChange__Delegate;
var delegate<OnConnectionStatusChange> __OnConnectionStatusChange__Delegate;
var delegate<OnStorageDeviceChange> __OnStorageDeviceChange__Delegate;
var delegate<OnKeyboardInputComplete> __OnKeyboardInputComplete__Delegate;
var delegate<OnWritePlayerStorageComplete> __OnWritePlayerStorageComplete__Delegate;
var delegate<OnReadPlayerStorageForNetIdComplete> __OnReadPlayerStorageForNetIdComplete__Delegate;
var delegate<OnReadPlayerStorageComplete> __OnReadPlayerStorageComplete__Delegate;
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

function bool UnmuteAll(byte LocalUserNum)
{
}

function bool MuteAll(byte LocalUserNum, bool bAllowFriends)
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

function ClearWritePlayerStorageCompleteDelegate(byte LocalUserNum, delegate<OnWritePlayerStorageComplete> WritePlayerStorageCompleteDelegate)
{
}

function bool WritePlayerStorage(byte LocalUserNum, OnlinePlayerStorage PlayerStorage)
{
}

function OnlinePlayerStorage GetPlayerStorage(byte LocalUserNum)
{
    return none;
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

function ClearReadPlayerStorageForNetIdCompleteDelegate(UniqueNetId NetId, delegate<OnReadPlayerStorageForNetIdComplete> ReadPlayerStorageForNetIdCompleteDelegate)
{
}

function bool ReadPlayerStorageForNetId(UniqueNetId NetId, OnlinePlayerStorage PlayerStorage)
{
}

function AddReadPlayerStorageForNetIdCompleteDelegate(UniqueNetId NetId, delegate<OnReadPlayerStorageForNetIdComplete> ReadPlayerStorageForNetIdCompleteDelegate)
{
}

delegate OnReadPlayerStorageForNetIdComplete(UniqueNetId NetId, bool bWasSuccessful)
{
}

function AddWritePlayerStorageCompleteDelegate(byte LocalUserNum, delegate<OnWritePlayerStorageComplete> WritePlayerStorageCompleteDelegate)
{
}

delegate OnWritePlayerStorageComplete(byte LocalUserNum, bool bWasSuccessful)
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

function ClearStorageDeviceChangeDelegate(delegate<OnStorageDeviceChange> StorageDeviceChangeDelegate)
{
}

function AddStorageDeviceChangeDelegate(delegate<OnStorageDeviceChange> StorageDeviceChangeDelegate)
{
}

delegate OnStorageDeviceChange()
{
}

function ENATType GetNATType()
{
    return 1;
}

function ClearConnectionStatusChangeDelegate(delegate<OnConnectionStatusChange> ConnectionStatusDelegate)
{
}

function AddConnectionStatusChangeDelegate(delegate<OnConnectionStatusChange> ConnectionStatusDelegate)
{
}

delegate OnConnectionStatusChange(EOnlineServerConnectionStatus ConnectionStatus)
{
}

function bool IsControllerConnected(int ControllerId)
{
    if (ControllerId == 0)
    {
        return true;
    }
    return false;
}

function ClearControllerChangeDelegate(delegate<OnControllerChange> ControllerChangeDelegate)
{
}

function AddControllerChangeDelegate(delegate<OnControllerChange> ControllerChangeDelegate)
{
}

delegate OnControllerChange(int ControllerId, bool bIsConnected)
{
}

function SetNetworkNotificationPosition(ENetworkNotificationPosition NewPos)
{
}

function ENetworkNotificationPosition GetNetworkNotificationPosition()
{
}

function ClearExternalUIChangeDelegate(delegate<OnExternalUIChange> ExternalUIDelegate)
{
}

function AddExternalUIChangeDelegate(delegate<OnExternalUIChange> ExternalUIDelegate)
{
}

delegate OnExternalUIChange(bool bIsOpening)
{
}

function ClearLinkStatusChangeDelegate(delegate<OnLinkStatusChange> LinkStatusDelegate)
{
}

function AddLinkStatusChangeDelegate(delegate<OnLinkStatusChange> LinkStatusDelegate)
{
}

delegate OnLinkStatusChange(bool bIsConnected)
{
}

function bool HasLinkConnection()
{
    return true;
}

event UniqueNetId GetPlayerUniqueNetIdFromIndex(int UserIndex)
{
    local UniqueNetId Zero;
    
    if (UserIndex == 0)
    {
        return LoggedInPlayerId;
    }
    return Zero;
}

event string GetPlayerNicknameFromIndex(int UserIndex)
{
    if (UserIndex == 0)
    {
        return LoggedInPlayerName;
    }
    return "";
}

function bool RegisterStatGuid(UniqueNetId PlayerID, out const string ClientStatGuid)
{
}

function string GetClientStatGuid()
{
}

function ClearRegisterHostStatGuidCompleteDelegateDelegate(delegate<OnFlushOnlineStatsComplete> RegisterHostStatGuidCompleteDelegate)
{
}

function AddRegisterHostStatGuidCompleteDelegate(delegate<OnFlushOnlineStatsComplete> RegisterHostStatGuidCompleteDelegate)
{
}

delegate OnRegisterHostStatGuidComplete(bool bWasSuccessful)
{
}

function bool RegisterHostStatGuid(out const string HostStatGuid)
{
}

function string GetHostStatGuid()
{
}

function bool WriteOnlinePlayerScores(name SessionName, int LeaderboardId, out const array<OnlinePlayerScore> PlayerScores)
{
}

function ClearFlushOnlineStatsCompleteDelegate(delegate<OnFlushOnlineStatsComplete> FlushOnlineStatsCompleteDelegate)
{
}

function AddFlushOnlineStatsCompleteDelegate(delegate<OnFlushOnlineStatsComplete> FlushOnlineStatsCompleteDelegate)
{
}

delegate OnFlushOnlineStatsComplete(name SessionName, bool bWasSuccessful)
{
}

function bool FlushOnlineStats(name SessionName)
{
}

function bool WriteOnlineStats(name SessionName, UniqueNetId Player, OnlineStatsWrite StatsWrite)
{
}

function FreeStats(OnlineStatsRead StatsRead)
{
}

function ClearReadOnlineStatsCompleteDelegate(delegate<OnReadOnlineStatsComplete> ReadOnlineStatsCompleteDelegate)
{
}

function AddReadOnlineStatsCompleteDelegate(delegate<OnReadOnlineStatsComplete> ReadOnlineStatsCompleteDelegate)
{
}

function bool ReadOnlineStatsByRankAroundPlayer(byte LocalUserNum, OnlineStatsRead StatsRead, optional int NumRows = 10)
{
}

function bool ReadOnlineStatsByRank(OnlineStatsRead StatsRead, optional int StartIndex = 1, optional int NumToRead = 100)
{
}

function bool ReadOnlineStatsForFriends(byte LocalUserNum, OnlineStatsRead StatsRead)
{
}

function bool ReadOnlineStats(out const array<UniqueNetId> Players, OnlineStatsRead StatsRead)
{
}

delegate OnReadOnlineStatsComplete(bool bWasSuccessful)
{
}

function bool SetSpeechRecognitionObject(byte LocalUserNum, SpeechRecognition SpeechRecogObj)
{
}

function bool SelectVocabulary(byte LocalUserNum, int VocabularyId)
{
}

function ClearRecognitionCompleteDelegate(byte LocalUserNum, delegate<OnRecognitionComplete> RecognitionDelegate)
{
    local int RemoveIndex;
    
    RemoveIndex = SpeechRecognitionCompleteDelegates.Find(RecognitionDelegate);
    if (RemoveIndex != -1)
    {
        SpeechRecognitionCompleteDelegates.Remove(RemoveIndex, 1);
    }
}

function AddRecognitionCompleteDelegate(byte LocalUserNum, delegate<OnRecognitionComplete> RecognitionDelegate)
{
    if (SpeechRecognitionCompleteDelegates.Find(RecognitionDelegate) == -1)
    {
        SpeechRecognitionCompleteDelegates[SpeechRecognitionCompleteDelegates.Length] = RecognitionDelegate;
    }
}

delegate OnRecognitionComplete()
{
}

function bool GetRecognitionResults(byte LocalUserNum, out array<SpeechRecognizedWord> Words)
{
}

function bool StopSpeechRecognition(byte LocalUserNum)
{
}

function bool StartSpeechRecognition(byte LocalUserNum)
{
}

function StopNetworkedVoice(byte LocalUserNum)
{
}

function StartNetworkedVoice(byte LocalUserNum)
{
}

function bool UnmuteRemoteTalker(byte LocalUserNum, UniqueNetId PlayerID)
{
}

function bool MuteRemoteTalker(byte LocalUserNum, UniqueNetId PlayerID)
{
}

function bool SetRemoteTalkerPriority(byte LocalUserNum, UniqueNetId PlayerID, int Priority)
{
}

function bool IsHeadsetPresent(byte LocalUserNum)
{
}

function bool IsRemotePlayerTalking(UniqueNetId PlayerID)
{
}

function bool IsLocalPlayerTalking(byte LocalUserNum)
{
}

function bool UnregisterRemoteTalker(UniqueNetId PlayerID)
{
}

function bool RegisterRemoteTalker(UniqueNetId PlayerID)
{
}

function bool UnregisterLocalTalker(byte LocalUserNum)
{
}

function bool RegisterLocalTalker(byte LocalUserNum)
{
}

function EOnlineEnumerationReadState GetFriendsList(byte LocalUserNum, out array<OnlineFriend> Friends, optional int Count, optional int StartingAt)
{
}

function ClearReadFriendsCompleteDelegate(byte LocalUserNum, delegate<OnReadFriendsComplete> ReadFriendsCompleteDelegate)
{
    local int RemoveIndex;
    
    if (LocalUserNum == 0)
    {
        RemoveIndex = ReadFriendsDelegates.Find(ReadFriendsCompleteDelegate);
        if (RemoveIndex != -1)
        {
            ReadFriendsDelegates.Remove(RemoveIndex, 1);
        }
    }
    else
    {
        WarnInternal("Invalid user index (" $ string(LocalUserNum) $ ") specified for ClearReadFriendsCompleteDelegate()");
    }
}

function AddReadFriendsCompleteDelegate(byte LocalUserNum, delegate<OnReadFriendsComplete> ReadFriendsCompleteDelegate)
{
    if (LocalUserNum == 0)
    {
        if (ReadFriendsDelegates.Find(ReadFriendsCompleteDelegate) == -1)
        {
            ReadFriendsDelegates[ReadFriendsDelegates.Length] = ReadFriendsCompleteDelegate;
        }
    }
    else
    {
        WarnInternal("Invalid user index (" $ string(LocalUserNum) $ ") specified for AddReadFriendsCompleteDelegate()");
    }
}

delegate OnReadFriendsComplete(bool bWasSuccessful)
{
}

function bool ReadFriendsList(byte LocalUserNum, optional int Count, optional int StartingAt)
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

function ClearWriteProfileSettingsCompleteDelegate(byte LocalUserNum, delegate<OnWriteProfileSettingsComplete> WriteProfileSettingsCompleteDelegate)
{
    local int RemoveIndex;
    
    if (LocalUserNum == 0)
    {
        RemoveIndex = WriteProfileSettingsDelegates.Find(WriteProfileSettingsCompleteDelegate);
        if (RemoveIndex != -1)
        {
            WriteProfileSettingsDelegates.Remove(RemoveIndex, 1);
        }
    }
    else
    {
        WarnInternal("Invalid user index (" $ string(LocalUserNum) $ ") specified for ClearWriteProfileSettingsCompleteDelegate()");
    }
}

function AddWriteProfileSettingsCompleteDelegate(byte LocalUserNum, delegate<OnWriteProfileSettingsComplete> WriteProfileSettingsCompleteDelegate)
{
    if (LocalUserNum == 0)
    {
        if (WriteProfileSettingsDelegates.Find(WriteProfileSettingsCompleteDelegate) == -1)
        {
            WriteProfileSettingsDelegates[WriteProfileSettingsDelegates.Length] = WriteProfileSettingsCompleteDelegate;
        }
    }
    else
    {
        WarnInternal("Invalid user index (" $ string(LocalUserNum) $ ") specified for AddWriteProfileSettingsCompleteDelegate()");
    }
}

delegate OnWriteProfileSettingsComplete(byte LocalUserNum, bool bWasSuccessful)
{
}

native function bool WriteProfileSettings(byte LocalUserNum, OnlineProfileSettings ProfileSettings)
{
    LocalUserNum;
    ProfileSettings;
}

function OnlineProfileSettings GetProfileSettings(byte LocalUserNum)
{
    if (LocalUserNum == 0)
    {
        return CachedProfile;
    }
    return none;
}

function ClearReadProfileSettingsCompleteDelegate(byte LocalUserNum, delegate<OnReadProfileSettingsComplete> ReadProfileSettingsCompleteDelegate)
{
    local int RemoveIndex;
    
    if (LocalUserNum == 0)
    {
        RemoveIndex = ReadProfileSettingsDelegates.Find(ReadProfileSettingsCompleteDelegate);
        if (RemoveIndex != -1)
        {
            ReadProfileSettingsDelegates.Remove(RemoveIndex, 1);
        }
    }
    else
    {
        WarnInternal("Invalid user index (" $ string(LocalUserNum) $ ") specified for ClearReadProfileSettingsCompleteDelegate()");
    }
}

function AddReadProfileSettingsCompleteDelegate(byte LocalUserNum, delegate<OnReadProfileSettingsComplete> ReadProfileSettingsCompleteDelegate)
{
    if (LocalUserNum == 0)
    {
        if (ReadProfileSettingsDelegates.Find(ReadProfileSettingsCompleteDelegate) == -1)
        {
            ReadProfileSettingsDelegates[ReadProfileSettingsDelegates.Length] = ReadProfileSettingsCompleteDelegate;
        }
    }
    else
    {
        WarnInternal("Invalid user index (" $ string(LocalUserNum) $ ") specified for AddReadProfileSettingsCompleteDelegate()");
    }
}

delegate OnReadProfileSettingsComplete(byte LocalUserNum, bool bWasSuccessful)
{
}

native function bool ReadProfileSettings(byte LocalUserNum, OnlineProfileSettings ProfileSettings)
{
    LocalUserNum;
    ProfileSettings;
}

function ClearFriendsChangeDelegate(byte LocalUserNum, delegate<OnFriendsChange> FriendsDelegate)
{
    local int RemoveIndex;
    
    if (LocalUserNum == 0)
    {
        RemoveIndex = FriendsChangeDelegates.Find(FriendsDelegate);
        if (RemoveIndex != -1)
        {
            FriendsChangeDelegates.Remove(RemoveIndex, 1);
        }
    }
    else
    {
        WarnInternal("Invalid user index (" $ string(LocalUserNum) $ ") specified for ClearFriendsChangeDelegate()");
    }
}

function AddFriendsChangeDelegate(byte LocalUserNum, delegate<OnFriendsChange> FriendsDelegate)
{
    if (LocalUserNum == 0)
    {
        if (FriendsChangeDelegates.Find(FriendsDelegate) == -1)
        {
            FriendsChangeDelegates[FriendsChangeDelegates.Length] = FriendsDelegate;
        }
    }
    else
    {
        WarnInternal("Invalid user index (" $ string(LocalUserNum) $ ") specified for ClearFriendsChangeDelegate()");
    }
}

function ClearMutingChangeDelegate(delegate<OnFriendsChange> MutingDelegate)
{
    local int RemoveIndex;
    
    RemoveIndex = MutingChangeDelegates.Find(MutingDelegate);
    if (RemoveIndex != -1)
    {
        MutingChangeDelegates.Remove(RemoveIndex, 1);
    }
}

function AddMutingChangeDelegate(delegate<OnMutingChange> MutingDelegate)
{
    if (MutingChangeDelegates.Find(MutingDelegate) == -1)
    {
        MutingChangeDelegates[MutingChangeDelegates.Length] = MutingDelegate;
    }
}

function bool IsGuestLogin(byte LocalUserNum)
{
}

function bool IsLocalLogin(byte LocalUserNum)
{
}

function ClearLoginCancelledDelegate(delegate<OnLoginCancelled> CancelledDelegate)
{
}

function AddLoginCancelledDelegate(delegate<OnLoginCancelled> CancelledDelegate)
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

function string GetPlayerNickname(byte LocalUserNum)
{
    return LoggedInPlayerName;
}

function bool GetUniquePlayerId(byte LocalUserNum, out UniqueNetId PlayerID)
{
    PlayerID = LoggedInPlayerId;
    return true;
}

function ELoginStatus GetLoginStatus(byte LocalUserNum)
{
    return 0;
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

function ClearPlayerTalkingDelegate(delegate<OnPlayerTalkingStateChange> TalkerDelegate)
{
}

function AddPlayerTalkingDelegate(delegate<OnPlayerTalkingStateChange> TalkerDelegate)
{
}

delegate OnPlayerTalkingStateChange(UniqueNetId Player, bool bIsTalking)
{
}

function EOnlineEnumerationReadState GetTitleFileState(string Filename)
{
}

function bool GetTitleFileContents(string Filename, out array<byte> FileContents)
{
}

function ClearReadTitleFileCompleteDelegate(delegate<OnReadTitleFileComplete> ReadTitleFileCompleteDelegate)
{
}

function AddReadTitleFileCompleteDelegate(delegate<OnReadTitleFileComplete> ReadTitleFileCompleteDelegate)
{
}

function bool ReadTitleFile(string FileToRead)
{
}

delegate OnReadTitleFileComplete(bool bWasSuccessful, string Filename)
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
    local int RemoveIndex;
    
    RemoveIndex = DLCContentInstalledDelegates.Find(DLCContentInstalledDelegate);
    if (RemoveIndex != -1)
    {
        DLCContentInstalledDelegates.Remove(RemoveIndex, 1);
    }
}

function AddDLCContentInstalledDelegate(delegate<OnDLCContentInstalled> DLCContentInstalledDelegate)
{
    if (DLCContentInstalledDelegates.Find(DLCContentInstalledDelegate) == -1)
    {
        DLCContentInstalledDelegates.AddItem(DLCContentInstalledDelegate);
    }
}

delegate OnDLCContentInstalled()
{
}

native event bool Init()
{
}

defaultproperties
{
    LoggedInPlayerName="Player1"
}

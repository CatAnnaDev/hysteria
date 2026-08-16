class OnlinePlaylistManager extends Object
    native
    notplaceable
    config(Playlist);

struct native Playlist
{
    var array<ConfiguredGameSetting> ConfiguredGames;
    var int PlaylistId;
    var string LocalizationString;
    var array<int> ContentIds;
    var int TeamSize;
    var int TeamCount;
    var string Name;
    var bool bIsArbitrated;
    var bool bDisableDedicatedServerSearches;
};

struct native ConfiguredGameSetting
{
    var int GameSettingId;
    var string GameSettingsClassName;
    var string URL;
    var transient OnlineGameSettings GameSettings;
};

var config array<Playlist> Playlists;
var array<string> PlaylistFileNames;
var config array<name> DatastoresToRefresh;
var int DownloadCount;
var int SuccessfulCount;
var config int VersionNumber;
var delegate<OnReadPlaylistComplete> __OnReadPlaylistComplete__Delegate;

function Reset()
{
    local OnlineSubsystem OnlineSub;
    
    DownloadCount = 0;
    SuccessfulCount = 0;
    OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != none && OnlineSub.Patcher != none)
    {
        OnlineSub.Patcher.ClearCachedFiles();
    }
}

function GetContentIdsFromPlaylist(int PlaylistId, out array<int> ContentIds)
{
    local int PlaylistIndex, ContentIdx;
    
    for (PlaylistIndex = 0; PlaylistIndex < Playlists.Length; PlaylistIndex++)
    {
        if (Playlists[PlaylistIndex].PlaylistId == PlaylistId)
        {
            for (ContentIdx = 0; ContentIdx < Playlists[PlaylistIndex].ContentIds.Length; ContentIdx++)
            {
                ContentIds.AddItem(Playlists[PlaylistIndex].ContentIds[ContentIdx]);
            }
            return;
        }
    }
}

function GetTeamInfoFromPlaylist(int PlaylistId, out int TeamSize, out int TeamCount)
{
    local int PlaylistIndex;
    
    for (PlaylistIndex = 0; PlaylistIndex < Playlists.Length; PlaylistIndex++)
    {
        if (Playlists[PlaylistIndex].PlaylistId == PlaylistId)
        {
            TeamSize = Playlists[PlaylistIndex].TeamSize;
            TeamCount = Playlists[PlaylistIndex].TeamCount;
            return;
        }
    }
    TeamSize = 0;
    TeamCount = 0;
}

function bool PlaylistSupportsDedicatedServers(int PlaylistId)
{
    local int PlaylistIndex;
    
    for (PlaylistIndex = 0; PlaylistIndex < Playlists.Length; PlaylistIndex++)
    {
        if (Playlists[PlaylistIndex].PlaylistId == PlaylistId)
        {
            return !Playlists[PlaylistIndex].bDisableDedicatedServerSearches;
        }
    }
    return false;
}

function bool HasAnyGameSettings(int PlaylistId)
{
    local int PlaylistIndex, GameIndex;
    
    for (PlaylistIndex = 0; PlaylistIndex < Playlists.Length; PlaylistIndex++)
    {
        if (Playlists[PlaylistIndex].PlaylistId == PlaylistId)
        {
            for (GameIndex = 0; GameIndex < Playlists[PlaylistIndex].ConfiguredGames.Length; GameIndex++)
            {
                if (Playlists[PlaylistIndex].ConfiguredGames[GameIndex].GameSettings != none)
                {
                    return true;
                }
            }
        }
    }
    return false;
}

function OnlineGameSettings GetGameSettings(int PlaylistId, int GameSettingsId)
{
    local int PlaylistIndex, GameIndex;
    
    for (PlaylistIndex = 0; PlaylistIndex < Playlists.Length; PlaylistIndex++)
    {
        if (Playlists[PlaylistIndex].PlaylistId == PlaylistId)
        {
            for (GameIndex = 0; GameIndex < Playlists[PlaylistIndex].ConfiguredGames.Length; GameIndex++)
            {
                if (Playlists[PlaylistIndex].ConfiguredGames[GameIndex].GameSettingId == GameSettingsId)
                {
                    return Playlists[PlaylistIndex].ConfiguredGames[GameIndex].GameSettings;
                }
            }
        }
    }
    WarnInternal("GetGameSettings() failed to find playlist" @ string(PlaylistId) @ "with game settings" @ string(GameSettingsId) @ "check DefaultPlaylist.ini");
    return none;
}

native function FinalizePlaylistObjects()
{
}

function OnReadTitleFileComplete(bool bWasSuccessful, string Filename)
{
    local OnlineSubsystem OnlineSub;
    local int FileIndex;
    
    for (FileIndex = 0; FileIndex < PlaylistFileNames.Length; FileIndex++)
    {
        if (PlaylistFileNames[FileIndex] == Filename)
        {
            DownloadCount++;
            SuccessfulCount += int(bWasSuccessful);
            if (DownloadCount == PlaylistFileNames.Length)
            {
                if (SuccessfulCount != DownloadCount)
                {
                    LogInternal("PlaylistManager: not all files downloaded correctly, using defaults where applicable");
                }
                FinalizePlaylistObjects();
                OnReadPlaylistComplete();
                OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
                if (OnlineSub != none && OnlineSub.Patcher != none)
                {
                    OnlineSub.Patcher.ClearReadFileDelegate(OnReadTitleFileComplete);
                }
            }
        }
    }
}

native function DetermineFilesToDownload()
{
}

function DownloadPlaylist()
{
    local OnlineSubsystem OnlineSub;
    local int FileIndex;
    
    if (SuccessfulCount == 0)
    {
        OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
        if (OnlineSub != none && OnlineSub.Patcher != none)
        {
            OnlineSub.Patcher.AddReadFileDelegate(OnReadTitleFileComplete);
            DownloadCount = 0;
            SuccessfulCount = 0;
            if (PlaylistFileNames.Length == 0)
            {
                DetermineFilesToDownload();
            }
            for (FileIndex = 0; FileIndex < PlaylistFileNames.Length; FileIndex++)
            {
                OnlineSub.Patcher.AddFileToDownload(PlaylistFileNames[FileIndex]);
            }
        }
        else
        {
            LogInternal("No online layer present, using defaults for playlist");
            FinalizePlaylistObjects();
            OnReadPlaylistComplete();
        }
    }
    else
    {
        OnReadPlaylistComplete();
    }
}

delegate OnReadPlaylistComplete()
{
}

defaultproperties
{
}

class UIDataProvider_PlayerAchievements extends UIDataProvider_OnlinePlayerDataBase
    native
    notplaceable
    transient
    hidecategories(Object,UIRoot)
    implements(UIListElementCellProvider);

var const native noexport Pointer VfTable_IUIListElementCellProvider;
var transient array<AchievementDetails> Achievements;

function UpdateAchievements()
{
    local OnlineSubsystem OnlineSub;
    
    if (Player != none)
    {
        Achievements.Length = 0;
        OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
        if (OnlineSub != none && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)) && OnlineSub.PlayerInterface.GetLoginStatus(byte(Player.ControllerId)) > 0)
        {
            OnlineSub.PlayerInterface.ReadAchievements(byte(Player.ControllerId));
        }
        NotifyPropertyChanged('Achievements');
    }
}

function OnLoginChange(byte LocalUserNum)
{
    if (int(LocalUserNum) == Player.ControllerId)
    {
        UpdateAchievements();
    }
}

event OnUnregister()
{
    local OnlineSubsystem OnlineSub;
    
    OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != none)
    {
        if (NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
        {
            OnlineSub.PlayerInterface.ClearLoginChangeDelegate(OnLoginChange);
        }
        if (NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
        {
            OnlineSub.PlayerInterface.ClearUnlockAchievementCompleteDelegate(byte(Player.ControllerId), OnPlayerAchievementUnlocked);
            OnlineSub.PlayerInterface.ClearReadAchievementsCompleteDelegate(byte(Player.ControllerId), OnPlayerAchievementsChanged);
        }
    }
    Achievements.Length = 0;
    OnUnregister();
}

event OnRegister(LocalPlayer InPlayer)
{
    local OnlineSubsystem OnlineSub;
    
    OnRegister(InPlayer);
    if (Player != none)
    {
        OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
        if (OnlineSub != none)
        {
            if (NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
            {
                OnlineSub.PlayerInterface.AddLoginChangeDelegate(OnLoginChange);
                OnlineSub.PlayerInterface.AddReadAchievementsCompleteDelegate(byte(Player.ControllerId), OnPlayerAchievementsChanged);
                OnlineSub.PlayerInterface.AddUnlockAchievementCompleteDelegate(byte(Player.ControllerId), OnPlayerAchievementUnlocked);
                OnlineSub.PlayerInterface.ReadAchievements(byte(Player.ControllerId));
            }
        }
    }
}

function OnPlayerAchievementUnlocked(bool bWasSuccessful)
{
    if (bWasSuccessful)
    {
        UpdateAchievements();
    }
}

function OnPlayerAchievementsChanged(int TitleId)
{
    local OnlineSubsystem OnlineSub;
    local EOnlineEnumerationReadState Result;
    
    if (Player != none)
    {
        OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
        if (OnlineSub != none && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)) && TitleId == 0)
        {
            Result = OnlineSub.PlayerInterface.GetAchievements(byte(Player.ControllerId), Achievements, TitleId);
            if (Result == 2)
            {
                PopulateAchievementIcons();
                NotifyPropertyChanged('Achievements');
                NotifyPropertyChanged('TotalGamerPoints');
            }
        }
    }
}

function GetAchievementDetails(const int AchievementId, out AchievementDetails OutAchievementDetails)
{
    local int Idx;
    
    Idx = Achievements.Find('Id', AchievementId);
    if (Idx != -1)
    {
        OutAchievementDetails = Achievements[Idx];
    }
}

function string GetAchievementIconPathName(int AchievementId, optional bool bReturnLockedIcon)
{
}

function PopulateAchievementIcons()
{
}

native final function int GetMaxTotalGamerScore()
{
}

native final function int GetTotalGamerScore()
{
}

defaultproperties
{
}

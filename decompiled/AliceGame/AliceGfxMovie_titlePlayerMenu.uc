class AliceGfxMovie_titlePlayerMenu extends AliceGFXMovie
    notplaceable;

const MaxChapterCount = 70;

var() SoundCue MainMenuMusicStart;
var() SoundCue CreditsMusic;
var() SoundCue DrawerCloseSound;
var() SoundCue DrawerOpenSound;
var() SoundCue SliderSound;
var() SoundCue StartPageSound;
var() SoundCue MoveSound;
var int SaveControllerIndex;
var bool bShowingAutoSaveWarning;
var bool bIsShowingPressStart;
var bool bShowingLoginUI;

function UT_UnlockTrophyDressUps()
{
    APC.UT_UnlockTrophyDressUps();
}

function SetNotShowingAutoSaveWarning()
{
    bShowingAutoSaveWarning = false;
}

function SetShowingAutoSaveWarning()
{
    bShowingAutoSaveWarning = true;
}

function bool shouldDefaultInvertControls()
{
    return APC.getAliceGameEngine().shouldDefaultInvertControls();
}

function bool getIsJPNSKU()
{
    return APC.GetJPNSKU();
}

function bool getIsSpecialPCEdition()
{
    return APC.getAliceGameEngine().GIsSpecialPCEdition;
}

function ExecAlice1()
{
    AliceCheatManager(APC.CheatManager).ExecAlice1();
}

function TitleOnStartShown()
{
    bIsShowingPressStart = true;
}

function TitleOnStartPressed()
{
    bIsShowingPressStart = false;
}

function bool shouldShowAutoSaveWarning()
{
    return GetAlicePlayerController().getAliceGameEngine().shouldShowAutoSaveWarning();
}

function ShowAutoSaveWarning()
{
    GetAlicePlayerController().getAliceGameEngine().ShowAutoSaveWarning();
}

function donotShowAutoSaveWarning()
{
    GetAlicePlayerController().getAliceGameEngine().donotShowAutoSaveWarning();
}

function bool InputKey(int ControllerId, name Key, EInputEvent Event, float AmountDepressed, bool bGamepad)
{
    local OnlinePlayerInterface PlayerInterface;
    local OnlineSubsystem OnlineSub;
    local bool isGuestAccount, IsLoggedIn;
    
    isGuestAccount = false;
    if (Event != 1)
    {
        return false;
    }
    if (bShowingAutoSaveWarning)
    {
        return false;
    }
    if (bShowingLoginUI)
    {
        return true;
    }
    IsLoggedIn = IsControllerLoggedIn(ControllerId);
    if (IsLoggedIn)
    {
        OnlineSub = class'Engine.GameEngine'.static.GetOnlineSubsystem();
        if (OnlineSub != none)
        {
            isGuestAccount = OnlineSub.PlayerInterface.IsGuestLogin(byte(ControllerId));
        }
    }
    if ((isGuestAccount || AliceGameInfo(APC.WorldInfo.Game).getAliceGameEngine().CurrentUserID == -1) && bIsShowingPressStart)
    {
        LogInternal("      InputKey Setting ControllerId and initting persistent data for: " @ string(ControllerId));
        if (APC.WorldInfo.IsConsoleBuild(1) && Key == 'XboxTypeS_Start' || Key == 'XboxTypeS_A' || Key == 'XboxTypeS_Back')
        {
            if (!IsLoggedIn || isGuestAccount)
            {
                bShowingLoginUI = true;
                if (isGuestAccount)
                {
                    APC.AliceLocErrorMsgBox("GenericError", "LoginErrorGuest");
                }
                SaveControllerIndex = ControllerId;
                ShowLoginUIWithCancelWarning();
                return true;
            }
            if (OnlineSub != none)
            {
                OnlineSub.PlayerInterface.ClearLoginCancelledDelegate(OnLoginCancelled);
            }
            SetCurrentPlayDataIndex(ControllerId);
            AliceGameInfo(APC.WorldInfo.Game).getAliceGameEngine().SetCurrentDeviceID(-1);
            AliceGameInfo(APC.WorldInfo.Game).InitLoadPersistentSaveData();
            if (OnlineSub != none)
            {
                PlayerInterface = OnlineSub.PlayerInterface;
                PlayerInterface.AddLoginChangeDelegate(APC.OnLoginChange);
                PlayerInterface.AddDLCContentInstalledDelegate(APC.OnDLCContentInstalled);
            }
            bIsShowingPressStart = false;
        }
        else if (!APC.WorldInfo.IsConsoleBuild(1))
        {
            AliceGameInfo(APC.WorldInfo.Game).getAliceGameEngine().SetCurrentDeviceID(-1);
            SetCurrentPlayDataIndex(ControllerId);
            bIsShowingPressStart = false;
        }
    }
    return false;
}

protected function OnLoginChange(byte LocalUserNum)
{
    local OnlineSubsystem OnlineSub;
    
    OnlineSub = class'Engine.GameEngine'.static.GetOnlineSubsystem();
    if (none != OnlineSub && NotEqual_InterfaceInterface(OnlinePlayerInterface(none), OnlineSub.PlayerInterface))
    {
        OnlineSub.PlayerInterface.ClearLoginChangeDelegate(OnLoginChange);
        OnlineSub.PlayerInterface.ClearLoginCancelledDelegate(OnLoginCancelled);
    }
    bShowingLoginUI = false;
}

protected function OnLoginCancelled()
{
    local OnlineSubsystem OnlineSub;
    
    OnlineSub = class'Engine.GameEngine'.static.GetOnlineSubsystem();
    if (none != OnlineSub && NotEqual_InterfaceInterface(OnlinePlayerInterface(none), OnlineSub.PlayerInterface))
    {
        OnlineSub.PlayerInterface.ClearLoginChangeDelegate(OnLoginChange);
        OnlineSub.PlayerInterface.ClearLoginCancelledDelegate(OnLoginCancelled);
    }
    if (!IsControllerLoggedIn(SaveControllerIndex))
    {
        APC.AliceLocErrorMsgBox("GenericError", "LoginError");
    }
    bShowingLoginUI = false;
}

function ShowLoginUIWithCancelWarning()
{
    local OnlineSubsystem OnlineSub;
    
    OnlineSub = class'Engine.GameEngine'.static.GetOnlineSubsystem();
    if (none != OnlineSub && NotEqual_InterfaceInterface(OnlinePlayerInterface(none), OnlineSub.PlayerInterface))
    {
        OnlineSub.PlayerInterface.AddLoginChangeDelegate(OnLoginChange);
        OnlineSub.PlayerInterface.AddLoginCancelledDelegate(OnLoginCancelled);
        OnlineSub.PlayerInterface.ShowLoginUI();
    }
}

function bool IsControllerLoggedIn(int ControllerId)
{
    local OnlineSubsystem OnlineSub;
    local ELoginStatus LoginStatus;
    local bool retval;
    
    OnlineSub = class'Engine.GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != none)
    {
        if (NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
        {
            LoginStatus = OnlineSub.PlayerInterface.GetLoginStatus(byte(ControllerId));
            retval = LoginStatus != 0;
        }
    }
    return retval;
}

function PlaySound(string Index)
{
    switch (Index)
    {
        case "DrawerCloseSound":
            APC.PlaySound(DrawerCloseSound);
            break;
        case "DrawerOpenSound":
            APC.PlaySound(DrawerOpenSound);
            break;
        case "SelectSound":
            APC.PlaySound(SelectSound);
            break;
        case "SelectBackSound":
            APC.PlaySound(SelectBackSound);
            break;
        case "SliderSound":
            APC.PlaySound(SliderSound);
            break;
        case "StartPageSound":
            APC.PlaySound(StartPageSound);
            break;
        case "OptionHighLightSound":
            APC.PlaySound(OptionHighLightSound);
            break;
        case "MoveSound":
            APC.PlaySound(MoveSound);
            break;
        default:
    }
}

function PlayMusic(string Index)
{
    switch (Index)
    {
        case "MainMenuMusicStart":
            APC.playUniqueSound(MainMenuMusicStart);
            break;
        case "CreditsMusic":
            APC.playUniqueSound(CreditsMusic);
            break;
        default:
    }
}

function getUserProfileList()
{
    local array<AliceGamePlayerProfileData> outputProfileData;
    
    Engine(APC.Player.Outer).GetPlayerProfileList(outputProfileData);
    sendUserProfileList(outputProfileData);
}

function backtoTitle()
{
    local OnlinePlayerInterface PlayerInterface;
    local OnlineSubsystem OnlineSub;
    
    ShowStartScreen();
    if (APC.WorldInfo.IsConsoleBuild(1) && AliceGameInfo(APC.WorldInfo.Game).getAliceGameEngine().CurrentUserID != -1)
    {
        OnlineSub = class'Engine.GameEngine'.static.GetOnlineSubsystem();
        if (OnlineSub != none)
        {
            PlayerInterface = OnlineSub.PlayerInterface;
            PlayerInterface.ClearLoginChangeDelegate(APC.OnLoginChange);
        }
    }
    SetCurrentPlayDataIndex(-1);
    AliceGameInfo(APC.WorldInfo.Game).getAliceGameEngine().SetCurrentDeviceID(-2);
    GetGameViewportClient().ConsoleCommand("open AliceEntry");
}

function bool shouldPromptVideoConfig()
{
    if (APC.WorldInfo.IsConsoleBuild())
    {
        return false;
    }
    else if (AliceGameInfo(APC.WorldInfo.Game).getAliceGameEngine().GetCompatCompositeIndex() > 3)
    {
        return true;
    }
    else
    {
        return false;
    }
}

function SetCurrentPlayDataIndex(int Index)
{
    Engine(APC.Player.Outer).SetCurrentPlayDataIndex(Index);
    APC.bNoCurrentUser = false;
    AliceGameInfo(APC.WorldInfo.Game).getAliceGameEngine().CurrentUserID = Index;
}

function sendUserProfileList(array<AliceGamePlayerProfileData> outputProfileData)
{
    ActionScriptVoid("profile.content.sendUserProfileList");
}

function delUserProfile(int Index)
{
    Engine(APC.Player.Outer).DeleteFromPlayerProfileList(Index);
    APC.configDataManager.setAllConfigDefault();
    Engine(APC.Player.Outer).SavePlayerList();
}

function createUserProfile(string UserName)
{
    Engine(APC.Player.Outer).AddNewPlayerToPlayerProfileList(UserName);
    APC.configDataManager.setKeysDefault();
    Engine(APC.Player.Outer).SavePlayerList();
}

function leaveControl()
{
    APC.UI_bUpdateKeySettings = false;
    APC.PlayerInput.EnableInputCommands(true);
}

function SetGFXMovie()
{
    APC.UI_bUpdateKeySettings = true;
    APC.PlayerInput.EnableInputCommands(false);
}

function bool isFinishGameOnHard()
{
    return APC.getAliceGameEngine().isFinishGameOnHard();
}

function bool IsChapterUnLocked(int I)
{
    return APC.WorldInfo.Game.MyCheckPointManager.IsChapterUnLocked(I);
}

function int getChapterUnlocked()
{
    return APC.WorldInfo.Game.MyCheckPointManager.getChapterUnlocked();
}

function GotoCust(float D)
{
    AliceCheatManager(APC.CheatManager).ScaleFOV(D);
}

function MoveCameraSpeed(float OffsetX, float OffsetY, float OffsetZ)
{
    APC.UI_MoveCameraSpeed(OffsetX, OffsetY, OffsetZ);
}

function SetAliceRotation(float fYaw)
{
    APC.UI_SetAliceRotation(fYaw);
}

function CameraOffsetRange(float MinOffsetX, float MinOffsetY, float MinOffsetZ, float MaxOffsetX, float MaxOffsetY, float MaxOffsetZ)
{
    APC.UI_CameraOffsetRange(MinOffsetX, MinOffsetY, MinOffsetZ, MaxOffsetX, MaxOffsetY, MaxOffsetZ);
}

function CameraMove(float OffsetX, float OffsetY, float OffsetZ)
{
    APC.UI_MoveCamera(OffsetX, OffsetY, OffsetZ);
}

function AliceMove(float OffsetX, float OffsetY, float OffsetZ)
{
    APC.UI_MoveAlice(OffsetX, OffsetY, OffsetZ);
}

function AliceRotate(float R)
{
    APC.UI_RotateAlice(R);
}

event GameCallback(optional int CallbackType = 0)
{
    APC.SetCurAliceDressAsUserDress();
    ActionScriptVoid("_root.finishChangeDress");
    GameCallback(CallbackType);
}

function continueGame()
{
    AliceGameInfo(APC.WorldInfo.Game).LoadLastCheckpointFromTitleMenu();
}

function LoadCheckpoint(int cid)
{
    APC.WorldInfo.Game.MyCheckPointManager.LoadChapter(byte(cid));
}

function UT_SetStoryMode(bool bInStoryMode)
{
    APC.UT_SetStoryMode(bInStoryMode);
}

function int ChangeAliceWonderlandDress(int Id)
{
    return APC.ChangeAliceWonderlandDress(Id, false, self);
}

function string getMenuName()
{
    local string menuNames;
    local int I;
    
    for (I = 0; I < 70; I++)
    {
        menuNames $= APC.WorldInfo.Game.MyCheckPointManager.AliceChapterName[I] $ ",";
    }
    return menuNames;
}

function ViewAsset(int Index)
{
    if (APC != none)
    {
        APC.ViewAsset(Index);
    }
}

defaultproperties
{
    __HandleInputKey__Delegate="None"
}

class UIInteraction extends Interaction
    native
    notplaceable
    transient
    config(UI)
    within GameViewportClient
    hidecategories(Object,UIRoot);

const DEFAULT_UISKIN = "DefaultUISkin.DefaultSkin";

struct native transient UIAxisEmulationData extends UIKeyRepeatData
{
    var bool bEnabled;
};

struct native transient UIKeyRepeatData
{
    var name CurrentRepeatKey;
    var Double NextRepeatTime;
};

var const native noexport Pointer VfTable_FExec;
var const native noexport Pointer VfTable_FGlobalDataStoreClientManager;
var const native noexport Pointer VfTable_FCallbackEventDevice;
var class<GameUISceneClient> SceneClientClass;
var const transient GameUISceneClient SceneClient;
var config string UISkinName;
var config array<name> UISoundCueNames;
var transient array<name> SupportedDoubleClickKeys;
var const transient DataStoreClient DataStoreManager;
var const transient UIInputConfiguration UIInputConfig;
var const native transient map<int, int> WidgetInputAliasLookupTable;
var const transient bool bProcessInput;
var const config bool bDisableToolTips;
var const config bool bFocusOnActive;
var const config bool bFocusedStateRules;
var const transient bool bIsUIPrimitiveSceneInitialized;
var const config float UIJoystickDeadZone;
var const config float UIAxisMultiplier;
var const config float AxisRepeatDelay;
var const config float MouseButtonRepeatDelay;
var const config float DoubleClickTriggerSeconds;
var const config int DoubleClickPixelTolerance;
var const config float ToolTipInitialDelaySeconds;
var const config float ToolTipExpirationSeconds;
var const transient UIKeyRepeatData MouseButtonRepeatInfo;
var const native transient map<int, int> AxisEmulationDefinitions;
var transient UIAxisEmulationData AxisInputEmulation[4];
var const native transient Pointer CanvasScene;

function NotifyGameSessionEnded()
{
    if (SceneClient != none)
    {
        SceneClient.NotifyGameSessionEnded();
    }
    if (DataStoreManager != none)
    {
        DataStoreManager.NotifyGameSessionEnded();
    }
    if (UIInputConfig != none)
    {
        UIInputConfig.NotifyGameSessionEnded();
    }
}

static final event ENATType GetNATType()
{
    local OnlineSubsystem OnlineSub;
    local OnlineSystemInterface SystemInterface;
    local ENATType Result;
    
    OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != none)
    {
        SystemInterface = OnlineSub.SystemInterface;
        if (NotEqual_InterfaceInterface(SystemInterface, OnlineSystemInterface(none)))
        {
            Result = SystemInterface.GetNATType();
        }
    }
    return Result;
}

final function bool CanAllPlayOnline()
{
    local int PlayerIndex;
    
    for (PlayerIndex = 0; PlayerIndex < Outer.Outer.GamePlayers.Length; PlayerIndex++)
    {
        if (!CanPlayOnline(Outer.Outer.GamePlayers[PlayerIndex].ControllerId))
        {
            return false;
        }
    }
    return true;
}

static final event bool CanPlayOnline(int ControllerId)
{
    local EFeaturePrivilegeLevel Result;
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterface PlayerInterface;
    
    Result = 0;
    OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != none)
    {
        PlayerInterface = OnlineSub.PlayerInterface;
        if (NotEqual_InterfaceInterface(PlayerInterface, OnlinePlayerInterface(none)))
        {
            Result = PlayerInterface.CanPlayOnline(byte(ControllerId));
        }
    }
    return Result != 0;
}

static final function int GetConnectedGamepadCount(optional array<bool> ControllerConnectionStatusOverrides)
{
    local int I, Result;
    
    for (I = 0; I < 4; I++)
    {
        if (I < ControllerConnectionStatusOverrides.Length)
        {
            if (ControllerConnectionStatusOverrides[I])
            {
                Result++;
            }
            continue;
        }
        if (IsGamepadConnected(I))
        {
            Result++;
        }
    }
    return Result;
}

static final function bool IsGamepadConnected(int ControllerId)
{
    local bool bResult;
    local OnlineSubsystem OnlineSub;
    local OnlineSystemInterface SystemInterface;
    
    OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != none)
    {
        SystemInterface = OnlineSub.SystemInterface;
        if (NotEqual_InterfaceInterface(SystemInterface, OnlineSystemInterface(none)))
        {
            bResult = SystemInterface.IsControllerConnected(ControllerId);
        }
    }
    return bResult;
}

static final function int GetNumGuestsLoggedIn()
{
    local OnlineSubsystem OnlineSub;
    local int ControllerId, GuestCount;
    
    OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != none && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
    {
        for (ControllerId = 0; ControllerId < 4; ControllerId++)
        {
            if (OnlineSub.PlayerInterface.IsGuestLogin(byte(ControllerId)))
            {
                GuestCount++;
            }
        }
    }
    return GuestCount;
}

static final function int GetLoggedInPlayerCount(optional bool bRequireOnlineLogin)
{
    local int ControllerId, Result;
    
    for (ControllerId = 0; ControllerId < 4; ControllerId++)
    {
        if (IsLoggedIn(ControllerId, bRequireOnlineLogin))
        {
            Result++;
        }
    }
    return Result;
}

static final event bool IsLoggedIn(int ControllerId, optional bool bRequireOnlineLogin)
{
    local bool bResult;
    local ELoginStatus LoginStatus;
    
    LoginStatus = GetLoginStatus(ControllerId);
    bResult = LoginStatus == 2 || LoginStatus == 1 && !bRequireOnlineLogin;
    return bResult;
}

static final event bool HasLinkConnection()
{
    local bool bResult;
    local OnlineSubsystem OnlineSub;
    local OnlineSystemInterface SystemInterface;
    
    OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != none)
    {
        SystemInterface = OnlineSub.SystemInterface;
        if (NotEqual_InterfaceInterface(SystemInterface, OnlineSystemInterface(none)))
        {
            bResult = SystemInterface.HasLinkConnection();
        }
    }
    return bResult;
}

final function ELoginStatus GetLowestLoginStatusOfControllers()
{
    local ELoginStatus Result, LoginStatus;
    local int PlayerIndex;
    
    Result = 2;
    for (PlayerIndex = 0; PlayerIndex < Outer.Outer.GamePlayers.Length; PlayerIndex++)
    {
        LoginStatus = GetLoginStatus(Outer.Outer.GamePlayers[PlayerIndex].ControllerId);
        if (LoginStatus < Result)
        {
            Result = LoginStatus;
        }
    }
    return Result;
}

static final event ELoginStatus GetLoginStatus(int ControllerId)
{
    local ELoginStatus Result;
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterface PlayerInterface;
    
    Result = 0;
    if (ControllerId != -1)
    {
        OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
        if (OnlineSub != none)
        {
            PlayerInterface = OnlineSub.PlayerInterface;
            if (NotEqual_InterfaceInterface(PlayerInterface, OnlinePlayerInterface(none)))
            {
                Result = PlayerInterface.GetLoginStatus(byte(ControllerId));
            }
        }
    }
    return Result;
}

final function SetMousePosition(int NewMouseX, int NewMouseY)
{
    SceneClient.SetMousePosition(NewMouseX, NewMouseY);
}

function NotifyPlayerRemoved(int PlayerIndex, LocalPlayer RemovedPlayer)
{
    local int PlayerCount, NextPlayerIndex, I;
    local UIAxisEmulationData Empty;
    
    if (PlayerIndex >= 0 && PlayerIndex < 4)
    {
        PlayerCount = GetPlayerCount();
        assert(PlayerCount < 4);
        for (I = PlayerIndex; I < PlayerCount; I++)
        {
            NextPlayerIndex = I + 1;
            AxisInputEmulation[I].NextRepeatTime = AxisInputEmulation[NextPlayerIndex].NextRepeatTime;
            AxisInputEmulation[I].CurrentRepeatKey = AxisInputEmulation[NextPlayerIndex].CurrentRepeatKey;
            AxisInputEmulation[I].bEnabled = AxisInputEmulation[NextPlayerIndex].bEnabled;
        }
        Empty.CurrentRepeatKey = 'None';
        AxisInputEmulation[PlayerCount] = Empty;
    }
    if (SceneClient != none)
    {
        SceneClient.NotifyPlayerRemoved(PlayerIndex, RemovedPlayer);
    }
}

function NotifyPlayerAdded(int PlayerIndex, LocalPlayer AddedPlayer)
{
    local UIAxisEmulationData Empty;
    
    if (PlayerIndex >= 0 && PlayerIndex < 4)
    {
        Empty.CurrentRepeatKey = 'None';
        AxisInputEmulation[PlayerIndex] = Empty;
    }
    if (SceneClient != none)
    {
        SceneClient.NotifyPlayerAdded(PlayerIndex, AddedPlayer);
    }
}

static final function LocalPlayer GetLocalPlayer(int PlayerIndex)
{
    local UIInteraction UIController;
    local LocalPlayer Result;
    
    UIController = class'UIRoot'.static.GetCurrentUIController();
    if (UIController != none && PlayerIndex >= 0 && PlayerIndex < UIController.Outer.Outer.GamePlayers.Length)
    {
        Result = UIController.Outer.Outer.GamePlayers[PlayerIndex];
    }
    return Result;
}

native final function UIScene CreateScene(class<UIScene> SceneClass, optional name SceneTag, optional UIScene SceneTemplate)
{
    SceneClass;
    SceneTag;
    SceneTemplate;
}

native final function UIObject CreateTransientWidget(class<UIObject> WidgetClass, name WidgetTag, optional UIObject Owner)
{
    WidgetClass;
    WidgetTag;
    Owner;
}

native final function bool PlayUISound(name SoundCueName, optional int PlayerIndex = 0)
{
    SoundCueName;
    PlayerIndex;
}

native static final function DataStoreClient GetDataStoreClient()
{
}

native static final function int GetPlayerControllerId(int PlayerIndex)
{
    PlayerIndex;
}

native static final function int GetPlayerIndex(int ControllerId)
{
    ControllerId;
}

native static final function int GetPlayerCount()
{
}

defaultproperties
{
    SceneClientClass="GameUISceneClient"
    UISkinName="DefaultUISkin.DefaultSkin"
    UISoundCueNames(0)="GenericError"
    UISoundCueNames(1)="MouseEnter"
    UISoundCueNames(2)="MouseExit"
    UISoundCueNames(3)="Clicked"
    UISoundCueNames(4)="Focused"
    UISoundCueNames(5)="SceneOpened"
    UISoundCueNames(6)="SceneClosed"
    UISoundCueNames(7)="ListSubmit"
    UISoundCueNames(8)="ListUp"
    UISoundCueNames(9)="ListDown"
    UISoundCueNames(10)="SliderIncrement"
    UISoundCueNames(11)="SliderDecrement"
    UISoundCueNames(12)="NavigateUp"
    UISoundCueNames(13)="NavigateDown"
    UISoundCueNames(14)="NavigateLeft"
    UISoundCueNames(15)="NavigateRight"
    UISoundCueNames(16)="CheckboxChecked"
    UISoundCueNames(17)="CheckboxUnchecked"
    UIJoystickDeadZone=0.9
    UIAxisMultiplier=1.0
    AxisRepeatDelay=0.2
    MouseButtonRepeatDelay=0.15
    DoubleClickTriggerSeconds=0.5
    DoubleClickPixelTolerance=1
    ToolTipInitialDelaySeconds=0.25
    ToolTipExpirationSeconds=5.0
    AxisInputEmulation=(bEnabled=True,CurrentRepeatKey="None",NextRepeatTime=())
    AxisInputEmulation[1]=(bEnabled=True,CurrentRepeatKey="None",NextRepeatTime=())
    AxisInputEmulation[2]=(bEnabled=True,CurrentRepeatKey="None",NextRepeatTime=())
    AxisInputEmulation[3]=(bEnabled=True,CurrentRepeatKey="None",NextRepeatTime=())
}

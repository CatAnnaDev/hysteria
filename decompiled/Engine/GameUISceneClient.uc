class GameUISceneClient extends UISceneClient
    native
    notplaceable
    transient
    config(UI)
    within UIInteraction
    hidecategories(Object,UIRoot);

var const transient array<UIScene> ActiveScenes;
var const transient UITexture CurrentMouseCursor;
var const transient bool bRenderCursor;
var const transient bool bUpdateInputProcessingStatus;
var const transient bool bUpdateCursorRenderStatus;
var transient bool bUpdateSceneViewportSizes;
var config bool bEnableDebugInput;
var config bool bRenderDebugInfo;
var globalconfig bool bRenderDebugInfoAtTop;
var globalconfig bool bRenderActiveControlInfo;
var globalconfig bool bRenderFocusedControlInfo;
var globalconfig bool bRenderTargetControlInfo;
var globalconfig bool bSelectVisibleTargetsOnly;
var globalconfig bool bInteractiveMode;
var globalconfig bool bDisplayFullPaths;
var globalconfig bool bShowWidgetPath;
var globalconfig bool bShowRenderBounds;
var globalconfig bool bShowCurrentState;
var globalconfig bool bShowMousePos;
var config bool bRestrictActiveControlToFocusedScene;
var const config bool bCaptureUnprocessedInput;
var const config bool bSynchronizePlayers;
var transient bool bKillRestoreMenuProgression;
var(ZDebug) transient bool bDebugResolveScene;
var(ZDebug) transient bool bBlockSceneUpdates;
var(ZDebug) transient bool bBlockUpdatesAfterStackModification;
var const transient float LatestDeltaTime;
var const transient Double DoubleClickStartTime;
var const transient IntPoint DoubleClickStartPosition;
var const transient Texture DefaultUITexture[3];
var const native transient Map_Mirror InitialPressedKeys;
var transient class<UIMessageBoxBase> MessageBoxClass;
var config float OverlaySceneAlphaModulation;
var const transient UIScreenObject DebugTarget;
var transient array<UIAnimationSeq> AnimSequencePool;
var const transient array<name> NavAliases;
var const transient array<name> AxisInputKeys;

native final function UIAnimationSeq FindUIAnimation(name NameOfSequence)
{
    NameOfSequence;
}

exec function ShowMenuProgression()
{
    local DataStoreClient DSClient;
    local UIDataStore_Registry RegistryDS;
    local UIDynamicFieldProvider RegistryProvider;
    local array<string> Values;
    local array<name> SceneTags;
    local int SceneIndex, MenuIndex;
    
    LogInternal("Current stored menu progression:");
    DSClient = class'UIInteraction'.static.GetDataStoreClient();
    if (DSClient != none)
    {
        RegistryDS = UIDataStore_Registry(DSClient.FindDataStore('Registry'));
        if (RegistryDS != none)
        {
            RegistryProvider = RegistryDS.GetDataProvider();
            if (RegistryProvider != none)
            {
                if (RegistryProvider.GetCollectionValueSchema('MenuProgression', SceneTags))
                {
                    for (SceneIndex = 0; SceneIndex < SceneTags.Length; SceneIndex++)
                    {
                        if (RegistryProvider.GetCollectionValueArray('MenuProgression', Values, false, SceneTags[SceneIndex]))
                        {
                            for (MenuIndex = 0; MenuIndex < Values.Length; MenuIndex++)
                            {
                                LogInternal("    Scene:" @ string(SceneTags[SceneIndex]) @ "Menu" @ string(MenuIndex) $ ":" @ Values[MenuIndex]);
                            }
                            continue;
                        }
                        LogInternal("No menu progression data found for scene" @ string(SceneIndex) $ ":" @ string(SceneTags[SceneIndex]));
                    }
                }
                else
                {
                    LogInternal("No menu progression data found in the Registry data store");
                }
            }
        }
    }
}

exec function DebugShowMessage(string Message, optional string Aliases = "GenericCancel,GenericAccept", optional string Title, optional string Question)
{
    local array<string> ButtonAliasStrings;
    local array<name> ButtonAliases;
    local int I;
    
    if (Message != "")
    {
        ParseStringIntoArray(Aliases, ButtonAliasStrings, ",", true);
        ButtonAliases.Length = ButtonAliasStrings.Length;
        for (I = 0; I < ButtonAliasStrings.Length; I++)
        {
            ButtonAliases[I] = name(ButtonAliasStrings[I]);
        }
        ShowUIMessage('DebugTestMessage', Title, Message, Question, ButtonAliases, DebugMessageOptionSelected);
    }
}

function bool DebugMessageOptionSelected(UIMessageBoxBase Sender, name SelectedInputAlias, int PlayerIndex)
{
    LogInternal("(" $ string(Name) $ ") GameUISceneClient::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) @ "Sender:" $ (Sender != none ? string(Sender.Name) : "None") @ "SelectedInputAlias:'" $ string(SelectedInputAlias) $ "'" @ "PlayerIndex:'" $ string(PlayerIndex) $ "'");
    return true;
}

exec function ShowDataStores(optional bool bVerbose)
{
    LogInternal("Dumping data store info to log - if you don't see any results, you probably need to unsuppress DevDataStore");
    if (DataStoreManager != none)
    {
        DataStoreManager.DebugDumpDataStoreInfo(bVerbose);
    }
    else
    {
        LogInternal(string(self) @ "has a NULL DataStoreManager!", 'DevDataStore');
    }
}

exec function RefreshFormatting()
{
    local UIScene ActiveScene;
    
    ActiveScene = GetActiveScene(none, true);
    if (ActiveScene != none)
    {
        LogInternal("Forcing a formatting update and scene refresh for" @ string(ActiveScene));
        ActiveScene.RequestFormattingUpdate();
    }
}

exec function ShowDataStoreField(string DataStoreMarkup)
{
    local string Value;
    
    if (class'UIRoot'.static.GetDataStoreStringValue(DataStoreMarkup, Value))
    {
        LogInternal("Successfully retrieved value for markup string (" $ DataStoreMarkup $ "): '" $ Value $ "'");
    }
    else
    {
        LogInternal("Failed to resolve value for data store markup (" $ DataStoreMarkup $ ")");
    }
}

exec function CloseMenu(optional name SceneName)
{
    local int I;
    local UIScene Scene;
    
    if (SceneName == 'None')
    {
        Scene = GetActiveScene();
        if (Scene != none)
        {
            LogInternal("Closing topmost scene '" $ Scene.GetWidgetPathName() $ "'");
            CloseScene(Scene);
        }
        else
        {
            LogInternal("No scenes currently open");
        }
    }
    else
    {
        for (I = 0; I < ActiveScenes.Length; I++)
        {
            if (ActiveScenes[I].SceneTag == SceneName)
            {
                LogInternal("Closing scene '" $ ActiveScenes[I].GetWidgetPathName() $ "'");
                CloseScene(ActiveScenes[I], false, true);
                return;
            }
        }
        LogInternal("No scenes found in ActiveScenes array with name matching '" $ string(SceneName) $ "'");
    }
}

exec function OpenMenu(string MenuPath, optional int PlayerIndex = -1)
{
    local UIScene Scene;
    local LocalPlayer SceneOwner;
    
    LogInternal("Attempting to load menu by name '" $ MenuPath $ "'");
    Scene = UIScene(DynamicLoadObject(MenuPath, class'UIScene'));
    if (Scene != none)
    {
        if (PlayerIndex != -1)
        {
            SceneOwner = Outer.Outer.Outer.GamePlayers[PlayerIndex];
        }
        OpenScene(Scene, SceneOwner);
    }
    else
    {
        LogInternal("Failed to load menu '" $ MenuPath $ "'");
    }
}

exec function CreateMenu(class<UIScene> SceneClass, optional int PlayerIndex = -1)
{
    local UIScene Scene;
    local LocalPlayer SceneOwner;
    
    LogInternal("Attempting to create script menu '" $ string(SceneClass) $ "'");
    Scene = CreateScene(SceneClass);
    if (Scene != none)
    {
        if (PlayerIndex != -1)
        {
            SceneOwner = Outer.Outer.Outer.GamePlayers[PlayerIndex];
        }
        OpenScene(Scene, SceneOwner);
    }
    else
    {
        LogInternal("Failed to create menu '" $ string(SceneClass) $ "'");
    }
}

exec function ToggleDebugInput(optional bool bEnable = !bEnableDebugInput)
{
    bEnableDebugInput = bEnable;
    LogInternal((bEnableDebugInput ? "Enabling" : "Disabling") @ "debug input processing");
}

exec function ShowMenuStates()
{
    local int I;
    
    for (I = 0; I < ActiveScenes.Length; I++)
    {
        ActiveScenes[I].LogCurrentState(0);
    }
}

exec function ShowRenderBounds()
{
    local int I;
    
    for (I = 0; I < ActiveScenes.Length; I++)
    {
        ActiveScenes[I].LogRenderBounds(0);
    }
}

exec function ShowDockingStacks()
{
    local int I;
    
    for (I = 0; I < ActiveScenes.Length; I++)
    {
        ActiveScenes[I].LogDockingStack();
    }
}

static final function bool ClearUIMessageScene(name SceneTag, optional LocalPlayer ScenePlayerOwner, optional bool bCloseChildScenes = false)
{
    local GameUISceneClient GameSceneClient;
    local UIScene ExistingScene;
    local bool bResult;
    
    GameSceneClient = class'UIRoot'.static.GetSceneClient();
    if (GameSceneClient != none)
    {
        ExistingScene = GameSceneClient.FindSceneByTag(SceneTag, ScenePlayerOwner);
        if (ExistingScene != none)
        {
            bResult = ExistingScene.CloseScene(ExistingScene, bCloseChildScenes, true);
        }
    }
    return bResult;
}

static function bool ShowUIMessage(name SceneTag, string Title, string Message, string Question, array<name> ButtonAliases, delegate<OnOptionSelected> SelectionCallback, optional LocalPlayer ScenePlayerOwner, optional out UIMessageBoxBase out_CreatedScene, optional byte ForcedPriority)
{
    local UIScene ExistingScene;
    local UIMessageBoxBase MessageBox;
    local GameUISceneClient GameSceneClient;
    local bool bResult;
    
    out_CreatedScene = none;
    GameSceneClient = class'UIRoot'.static.GetSceneClient();
    if (GameSceneClient != none)
    {
        ExistingScene = GameSceneClient.FindSceneByTag(SceneTag, ScenePlayerOwner);
        if (ExistingScene == none)
        {
            MessageBox = CreateUIMessageBox(SceneTag);
            if (MessageBox != none)
            {
                ExistingScene = MessageBox.OpenScene(MessageBox, ScenePlayerOwner, ForcedPriority);
                if (ExistingScene != none)
                {
                    MessageBox = UIMessageBoxBase(ExistingScene);
                    MessageBox.SetupMessageBox(Title, Message, Question, ButtonAliases, SelectionCallback);
                    out_CreatedScene = MessageBox;
                    bResult = true;
                }
            }
        }
    }
    return bResult;
}

static function UIMessageBoxBase CreateUIMessageBox(name SceneTag, optional class<UIMessageBoxBase> CustomMessageBoxClass = default.MessageBoxClass, optional UIMessageBoxBase SceneTemplate)
{
    local UIMessageBoxBase Result;
    local GameUISceneClient GameSceneClient;
    
    if (SceneTag != 'None')
    {
        GameSceneClient = class'UIRoot'.static.GetSceneClient();
        if (GameSceneClient != none)
        {
            Result = GameSceneClient.CreateScene(CustomMessageBoxClass, SceneTag, SceneTemplate);
        }
    }
    return Result;
}

function RestoreMenuProgression(optional UIScene BaseScene)
{
    local DataStoreClient DSClient;
    local UIDataStore_Registry RegistryDS;
    local UIDynamicFieldProvider RegistryProvider;
    local UIScene CurrentScene, NextSceneTemplate, SceneInstance;
    local string ScenePathName;
    local bool bHasValidNetworkConnection;
    local LocalPlayer PlayerOwner;
    
    bKillRestoreMenuProgression = false;
    if (class'WorldInfo'.static.IsMenuLevel())
    {
        if (BaseScene == none && IsUIActive())
        {
            BaseScene = ActiveScenes[ActiveScenes.Length - 1];
        }
        if (BaseScene != none)
        {
            DSClient = class'UIInteraction'.static.GetDataStoreClient();
            if (DSClient != none)
            {
                RegistryDS = UIDataStore_Registry(DSClient.FindDataStore('Registry'));
                if (RegistryDS != none)
                {
                    RegistryProvider = RegistryDS.GetDataProvider();
                    if (RegistryProvider != none)
                    {
                        LogInternal("Restoring menu progression from '" $ PathName(BaseScene) $ "'", 'DevUI');
                        bHasValidNetworkConnection = class'UIInteraction'.static.HasLinkConnection();
                        PlayerOwner = Outer.Outer.Outer.GamePlayers[0];
                        CurrentScene = BaseScene;
                        while (CurrentScene != none && !bKillRestoreMenuProgression)
                        {
                            ScenePathName = "";
                            if (RegistryProvider.GetCollectionValue('MenuProgression', 0, ScenePathName, false, CurrentScene.SceneTag))
                            {
                                if (ScenePathName != "")
                                {
                                    NextSceneTemplate = UIScene(DynamicLoadObject(ScenePathName, class'UIScene'));
                                    if (NextSceneTemplate != none)
                                    {
                                        if (NextSceneTemplate.bRequiresNetwork && !bHasValidNetworkConnection)
                                        {
                                            break;
                                        }
                                        SceneInstance = CurrentScene.OpenScene(NextSceneTemplate, PlayerOwner, , true);
                                        if (SceneInstance != none)
                                        {
                                            CurrentScene = SceneInstance;
                                        }
                                        else
                                        {
                                            WarnInternal("Failed to restore scene '" $ PathName(NextSceneTemplate) $ "': call to OpenScene failed.");
                                            break;
                                        }
                                    }
                                    else
                                    {
                                        WarnInternal("Failed to restore scene '" $ ScenePathName $ "' by name: call to DynamicLoadObject() failed.");
                                        break;
                                    }
                                }
                                else
                                {
                                    LogInternal("(" $ string(Name) $ ") GameUISceneClient::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) @ "'MenuProgression' value was empty for '" $ PathName(CurrentScene) $ "'", 'DevUI');
                                    break;
                                }
                                continue;
                            }
                            LogInternal("(" $ string(Name) $ ") GameUISceneClient::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) @ "No 'MenuProgression' found in the Registry data store for '" $ string(CurrentScene.SceneTag) $ "'", 'DevUI');
                            break;
                        }
                        RegistryProvider.ClearCollectionValueArray('MenuProgression');
                    }
                }
            }
        }
    }
}

function ClearMenuProgression()
{
    local DataStoreClient DSClient;
    local UIDataStore_Registry RegistryDS;
    local UIDynamicFieldProvider RegistryProvider;
    
    DSClient = class'UIInteraction'.static.GetDataStoreClient();
    if (DSClient != none)
    {
        RegistryDS = UIDataStore_Registry(DSClient.FindDataStore('Registry'));
        if (RegistryDS != none)
        {
            RegistryProvider = RegistryDS.GetDataProvider();
            if (RegistryProvider != none)
            {
                RegistryProvider.ClearCollectionValueArray('MenuProgression');
            }
        }
    }
}

function SaveMenuProgression()
{
    local DataStoreClient DSClient;
    local UIDataStore_Registry RegistryDS;
    local UIDynamicFieldProvider RegistryProvider;
    local int I;
    local UIScene SceneResource, CurrentScene, NextScene;
    local string ScenePathName;
    
    if (class'WorldInfo'.static.IsMenuLevel())
    {
        DSClient = class'UIInteraction'.static.GetDataStoreClient();
        if (DSClient != none)
        {
            RegistryDS = UIDataStore_Registry(DSClient.FindDataStore('Registry'));
            if (RegistryDS != none)
            {
                RegistryProvider = RegistryDS.GetDataProvider();
                if (RegistryProvider != none)
                {
                    RegistryProvider.ClearCollectionValueArray('MenuProgression');
                    LogInternal("Storing menu progression (" $ string(ActiveScenes.Length) @ "open scenes)", 'DevUI');
                    for (I = 0; I < ActiveScenes.Length - 1; I++)
                    {
                        CurrentScene = ActiveScenes[I];
                        NextScene = ActiveScenes[I + 1];
                        if (CurrentScene != none && NextScene != none && CurrentScene != NextScene)
                        {
                            if (NextScene.bMenuLevelRestoresScene)
                            {
                                SceneResource = UIScene(NextScene.ObjectArchetype);
                                if (SceneResource != none)
                                {
                                    ScenePathName = PathName(SceneResource);
                                    if (RegistryProvider.InsertCollectionValue('MenuProgression', ScenePathName, -1, false, false, CurrentScene.SceneTag))
                                    {
                                        LogInternal("Storing" @ ScenePathName @ "as next menu in progression for" @ string(CurrentScene.SceneTag), 'DevUI');
                                        continue;
                                    }
                                    WarnInternal("Failed to store scene '" $ ScenePathName $ "' menu progression in Registry");
                                    break;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

function NotifyStorageDeviceChanged()
{
    local UIScene Scene;
    
    Scene = GetActiveScene();
    if (Scene != none)
    {
        Scene.NotifyStorageDeviceChanged();
    }
}

function NotifyPlayerRemoved(int PlayerIndex, LocalPlayer RemovedPlayer)
{
    local int SceneIndex;
    local array<UIScene> CurrentScenes;
    
    CurrentScenes = ActiveScenes;
    for (SceneIndex = 0; SceneIndex < CurrentScenes.Length; SceneIndex++)
    {
        CurrentScenes[SceneIndex].NotifyPlayerRemoved(PlayerIndex, RemovedPlayer);
    }
    if (IsUIActive(2))
    {
        RequestInputProcessingUpdate();
    }
}

function NotifyPlayerAdded(int PlayerIndex, LocalPlayer AddedPlayer)
{
    local int SceneIndex;
    local array<UIScene> CurrentScenes;
    
    CurrentScenes = ActiveScenes;
    for (SceneIndex = 0; SceneIndex < CurrentScenes.Length; SceneIndex++)
    {
        CurrentScenes[SceneIndex].NotifyPlayerAdded(PlayerIndex, AddedPlayer);
    }
    if (IsUIActive(2))
    {
        RequestInputProcessingUpdate();
    }
}

function NotifyLinkStatusChanged(bool bConnected)
{
    local UIScene Scene;
    
    Scene = GetActiveScene();
    if (Scene != none)
    {
        Scene.NotifyLinkStatusChanged(bConnected);
    }
}

function NotifyOnlineServiceStatusChanged(EOnlineServerConnectionStatus NewConnectionStatus)
{
    local UIScene Scene;
    
    Scene = GetActiveScene();
    if (Scene != none)
    {
        Scene.NotifyOnlineServiceStatusChanged(NewConnectionStatus);
    }
}

function NotifyControllerChanged(int ControllerId, bool bConnected)
{
    local UIScene Scene;
    
    LogInternal("(" $ string(Name) $ ") GameUISceneClient::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) @ "ControllerId:'" $ string(ControllerId) $ "'" @ "bConnected:'" $ string(bConnected) $ "'", 'RON_DEBUG');
    Scene = GetActiveScene();
    if (Scene != none)
    {
        Scene.NotifyControllerStatusChanged(ControllerId, bConnected);
    }
}

function OnLoginChange(byte ControllerId)
{
    local UIScene Scene;
    local ELoginStatus Status;
    
    Status = Outer.GetLoginStatus(int(ControllerId));
    Scene = GetActiveScene();
    if (Scene != none)
    {
        Scene.NotifyLoginStatusChanged(int(ControllerId), Status);
    }
}

function NotifyGameSessionEnded()
{
    local int I;
    local array<UIScene> CurrentlyActiveScenes;
    
    SaveMenuProgression();
    CurrentlyActiveScenes = ActiveScenes;
    for (I = CurrentlyActiveScenes.Length - 1; I >= 0; I--)
    {
        if (CurrentlyActiveScenes[I] != none)
        {
            CurrentlyActiveScenes[I].NotifyGameSessionEnded();
            continue;
        }
        CurrentlyActiveScenes.Remove(I, 1);
    }
    for (I = CurrentlyActiveScenes.Length - 1; I >= 0; I--)
    {
        if (CurrentlyActiveScenes[I].bCloseOnLevelChange)
        {
            CurrentlyActiveScenes[I].CloseScene(CurrentlyActiveScenes[I], true, true);
        }
    }
}

function NotifyClientTravel(PlayerController TravellingPlayer, string TravelURL, ETravelType TravelType, bool bIsSeamlessTravel)
{
    local int SceneIndex;
    local array<UIScene> CurrentlyActiveScenes;
    local UIScene NextScene;
    local LocalPlayer TravellingLP;
    
    if (TravellingPlayer != none)
    {
        TravellingLP = LocalPlayer(TravellingPlayer.Player);
    }
    CurrentlyActiveScenes = ActiveScenes;
    for (SceneIndex = CurrentlyActiveScenes.Length - 1; SceneIndex >= 0; SceneIndex--)
    {
        NextScene = CurrentlyActiveScenes[SceneIndex];
        if (NextScene != none && NextScene.PlayerOwner == TravellingLP || NextScene.PlayerOwner == none)
        {
            NextScene.NotifyPreClientTravel(TravelURL, TravelType, bIsSeamlessTravel);
        }
    }
}

function bool IsAllowedToModifyPlayerCount()
{
    return bSynchronizePlayers;
}

event SynchronizePlayers(optional int MaxPlayersAllowed = 4, optional bool bAllowJoins = true, optional bool bAllowRemoval = true)
{
    local int PlayerIndex, ControllerId;
    local string ErrorString;
    local LocalPlayer PlayerRef;
    
    if (IsAllowedToModifyPlayerCount())
    {
        for (ControllerId = 0; ControllerId < 4; ControllerId++)
        {
            PlayerIndex = Outer.GetPlayerIndex(ControllerId);
            if (Outer.IsGamepadConnected(ControllerId))
            {
                if (PlayerIndex == -1 && bAllowJoins)
                {
                    if (Outer.Outer.Outer.GamePlayers.Length < MaxPlayersAllowed)
                    {
                        LogInternal("(" $ string(Name) $ ") GameUISceneClient::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) @ "attempting to create a new local player -" @ "ControllerId:'" $ string(ControllerId) $ "'");
                        PlayerRef = Outer.Outer.CreatePlayer(ControllerId, ErrorString, true);
                    }
                    else
                    {
                        LogInternal("(" $ string(Name) $ ") GameUISceneClient::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) @ "unable to create player for gamepad" @ string(ControllerId) @ "because the max player count has been reached (" $ string(MaxPlayersAllowed) $ ")");
                    }
                }
                continue;
            }
            if (PlayerIndex != -1 && bAllowRemoval && !Outer.IsLoggedIn(ControllerId))
            {
                PlayerRef = Outer.Outer.Outer.GamePlayers[PlayerIndex];
                if (Outer.Outer.Outer.GamePlayers.Length > 1)
                {
                    LogInternal("(" $ string(Name) $ ") GameUISceneClient::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) @ "attempting to remove local player that is no longer signed-in:" @ "ControllerId:'" $ string(ControllerId) $ "'" @ "(" $ "PlayerIndex:'" $ string(PlayerIndex) $ "'" $ ")");
                    if (!Outer.Outer.RemovePlayer(PlayerRef))
                    {
                        WarnInternal("(" $ string(Name) $ ") GameUISceneClient::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) @ "failed to remove player at index" @ string(PlayerIndex) $ "!");
                    }
                    continue;
                }
                LogInternal("(" $ string(Name) $ ") GameUISceneClient::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) @ "player" @ string(PlayerIndex) @ "is no longer signed-in but cannot be removed because it is the last player");
            }
        }
        while (Outer.Outer.Outer.GamePlayers.Length > Max(1, MaxPlayersAllowed))
        {
            LogInternal("(" $ string(Name) $ ") GameUISceneClient::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) @ "attempting to remove local player to match the maximum number of players allowed:" @ "ControllerId:'" $ string(ControllerId) $ "'" @ "(" $ "PlayerIndex:'" $ string(PlayerIndex) $ "'" $ ")");
            PlayerRef = Outer.Outer.Outer.GamePlayers[PlayerIndex];
            if (!Outer.Outer.RemovePlayer(PlayerRef))
            {
                WarnInternal("(" $ string(Name) $ ") GameUISceneClient::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) @ "failed to remove player at index" @ string(PlayerIndex) $ "!");
            }
        }
    }
}

event InitializeSceneClient()
{
    local OnlineSubsystem OnlineSub;
    
    InitializeSceneClient();
    OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != none)
    {
        if (NotEqual_InterfaceInterface(OnlineSub.SystemInterface, OnlineSystemInterface(none)))
        {
            OnlineSub.SystemInterface.AddConnectionStatusChangeDelegate(NotifyOnlineServiceStatusChanged);
            OnlineSub.SystemInterface.AddLinkStatusChangeDelegate(NotifyLinkStatusChanged);
            OnlineSub.SystemInterface.AddControllerChangeDelegate(NotifyControllerChanged);
            OnlineSub.SystemInterface.AddStorageDeviceChangeDelegate(NotifyStorageDeviceChanged);
        }
        else
        {
            LogInternal("(" $ string(Name) $ ") GameUISceneClient::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) @ "no Online System interface found!", 'DevOnline');
        }
        if (NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
        {
            OnlineSub.PlayerInterface.AddLoginChangeDelegate(OnLoginChange);
        }
        else
        {
            LogInternal("(" $ string(Name) $ ") GameUISceneClient::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) @ "no Online Player interface found!", 'DevOnline');
        }
    }
    else
    {
        LogInternal("(" $ string(Name) $ ") GameUISceneClient::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) @ "no OnlineSubsystem found!", 'DevOnline');
    }
}

event bool CanShowToolTips()
{
    if (Outer.bDisableToolTips)
    {
        return false;
    }
    return true;
}

event PauseGame(bool bDesiredPauseState, optional int PlayerIndex = 0)
{
    local PlayerController PlayerOwner;
    
    if (Outer.Outer.Outer.GamePlayers.Length > 0)
    {
        PlayerIndex = Clamp(PlayerIndex, 0, Outer.Outer.Outer.GamePlayers.Length - 1);
        PlayerOwner = Outer.Outer.Outer.GamePlayers[PlayerIndex].Actor;
        if (PlayerOwner != none)
        {
            PlayerOwner.SetPause(bDesiredPauseState, CanUnpauseInternalUI);
        }
    }
}

native function bool SetActiveControl(UIObject NewActiveControl)
{
    NewActiveControl;
}

native final function bool CanUnpauseInternalUI()
{
}

native final function RequestCursorRenderUpdate()
{
}

native final function RequestInputProcessingUpdate()
{
}

native final iterator function AllActiveScenes(class<UIScene> SceneClass, out UIScene OutScene, optional bool bIterateBackwards, optional int StartingIndex = -1, optional int SceneFilterMask = -1)
{
    SceneClass;
    OutScene;
    bIterateBackwards;
    StartingIndex;
    SceneFilterMask;
}

native final function UIScene GetNextSceneFromIndex(int StartingSceneIndex, optional LocalPlayer MatchingPlayerOwner, optional bool bIgnoreUnfocusedScenes)
{
    StartingSceneIndex;
    MatchingPlayerOwner;
    bIgnoreUnfocusedScenes;
}

native final function UIScene GetNextScene(const UIScene SourceScene, optional bool bRequireMatchingPlayerOwner = true, optional bool bIgnoreUnfocusedScenes)
{
    SourceScene;
    bRequireMatchingPlayerOwner;
    bIgnoreUnfocusedScenes;
}

native final function UIScene GetPreviousInputProcessingScene(const UIScene SourceScene, optional bool bIgnoreUnfocusedScenes = true)
{
    SourceScene;
    bIgnoreUnfocusedScenes;
}

native final function UIScene GetPreviousSceneFromIndex(int StartingSceneIndex, optional LocalPlayer MatchingPlayerOwner, optional bool bIgnoreUnfocusedScenes)
{
    StartingSceneIndex;
    MatchingPlayerOwner;
    bIgnoreUnfocusedScenes;
}

native final function UIScene GetPreviousScene(const UIScene SourceScene, optional bool bRequireMatchingPlayerOwner = true, optional bool bIgnoreUnfocusedScenes)
{
    SourceScene;
    bRequireMatchingPlayerOwner;
    bIgnoreUnfocusedScenes;
}

native final function UIScene GetActiveScene(optional LocalPlayer MatchingPlayerOwner, optional bool bIgnoreUnfocusedScenes)
{
    MatchingPlayerOwner;
    bIgnoreUnfocusedScenes;
}

native final function int GetActiveSceneCount(optional LocalPlayer MatchingPlayerOwner, optional bool bIgnoreUnfocusedScenes)
{
    MatchingPlayerOwner;
    bIgnoreUnfocusedScenes;
}

native final function int FindSceneIndexByTag(name SceneTag, optional LocalPlayer SceneOwner)
{
    SceneTag;
    SceneOwner;
}

native final function UIScene GetSceneAtIndex(int SceneIndex)
{
    SceneIndex;
}

native final function int FindSceneIndex(const UIScene SceneToFind)
{
    SceneToFind;
}

native final function UIScene FindSceneByTag(name SceneTag, optional LocalPlayer SceneOwner)
{
    SceneTag;
    SceneOwner;
}

native final function UIObject CreateTransientWidget(class<UIObject> WidgetClass, name WidgetTag, optional UIObject Owner)
{
    WidgetClass;
    WidgetTag;
    Owner;
}

native final function UIScene CreateScene(class<UIScene> SceneClass, optional name SceneTag, optional UIScene SceneTemplate)
{
    SceneClass;
    SceneTag;
    SceneTemplate;
}

native final function UIScene GetTransientScene()
{
}

native static final function ENetMode GetCurrentNetMode()
{
}

defaultproperties
{
    bEnableDebugInput=True
    bRenderDebugInfoAtTop=True
    bRenderActiveControlInfo=True
    bRenderFocusedControlInfo=True
    bRenderTargetControlInfo=True
    bSelectVisibleTargetsOnly=True
    bDisplayFullPaths=True
    bShowWidgetPath=True
    bShowRenderBounds=True
    bShowCurrentState=True
    bShowMousePos=True
    bRestrictActiveControlToFocusedScene=True
    bCaptureUnprocessedInput=True
    DefaultUITexture="EngineResources.WhiteSquareTexture"
    DefaultUITexture[1]="EngineResources.Black"
    DefaultUITexture[2]="EngineResources.Gray"
    MessageBoxClass="UIMessageBox"
    OverlaySceneAlphaModulation=0.45
    NavAliases(0)="UIKEY_NavFocusUp"
    NavAliases(1)="UIKEY_NavFocusDown"
    NavAliases(2)="UIKEY_NavFocusLeft"
    NavAliases(3)="UIKEY_NavFocusRight"
    AxisInputKeys(0)="KEY_Gamepad_LeftStick_Up"
    AxisInputKeys(1)="KEY_Gamepad_LeftStick_Down"
    AxisInputKeys(2)="KEY_Gamepad_LeftStick_Right"
    AxisInputKeys(3)="KEY_Gamepad_LeftStick_Left"
    AxisInputKeys(4)="KEY_Gamepad_RightStick_Up"
    AxisInputKeys(5)="KEY_Gamepad_RightStick_Down"
    AxisInputKeys(6)="KEY_Gamepad_RightStick_Right"
    AxisInputKeys(7)="KEY_Gamepad_RightStick_Left"
    AxisInputKeys(8)="KEY_SIXAXIS_AccelX"
    AxisInputKeys(9)="KEY_SIXAXIS_AccelY"
    AxisInputKeys(10)="KEY_SIXAXIS_AccelZ"
    AxisInputKeys(11)="KEY_SIXAXIS_Gyro"
    AxisInputKeys(12)="KEY_XboxTypeS_LeftX"
    AxisInputKeys(13)="KEY_XboxTypeS_LeftY"
    AxisInputKeys(14)="KEY_XboxTypeS_RightX"
    AxisInputKeys(15)="KEY_XboxTypeS_RightY"
}

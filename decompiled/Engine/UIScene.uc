class UIScene extends UIScreenObject
    native
    placeable
    config(UI)
    hidecategories(Object,UIRoot,Object);

var() editconst name SceneTag;
var const transient UISceneClient SceneClient;
var const export editinline SceneDataStore SceneData;
var const transient LocalPlayer PlayerOwner;
var const transient UIContextMenu ActiveContextMenu;
var const transient UIContextMenu StandardContextMenu;
var(Controls) const class<UIContextMenu> DefaultContextMenuClass;
var(Style) const editinline UISkin SceneSkin;
var const transient UISafeRegionPanel PrimarySafeRegionPanel;
var const native transient array<UIDockingNode> DockingStack;
var const transient array<UIObject> RenderStack;
var const transient array<UITickableObject> TickableObjects;
var transient array<UIScreenObject> AnimatingObjects;
var const native transient Map_Mirror InputSubscriptions[4];
var transient int LastPlayerIndex;
var const transient bool bUpdateDockingStack;
var const transient bool bUpdateScenePositions;
var const transient bool bUpdateNavigationLinks;
var const transient bool bUpdatePrimitiveUsage;
var const transient bool bRefreshWidgetStyles;
var const transient bool bRefreshStringFormatting;
var const transient bool bRecalculateInputMask;
var const transient bool bPerformedInitialUpdate;
var const transient bool bResolvingScenePositions;
var const transient bool bUsesPrimitives;
var const transient bool bSupportsNavigation;
var const transient bool bReevaluateRotationSupport;
var const transient bool bSupportsRotation;
var(Flags) bool bDisplayCursor;
var(Flags) bool bRenderParentScenes;
var(Flags) bool bAlwaysRenderScene;
var(Flags) bool bPauseGameWhileActive;
var(Flags) bool bExemptFromAutoClose;
var(Flags) bool bCloseOnLevelChange;
var(Flags) bool bSaveSceneValuesOnClose;
var(PostProcess) bool bEnableScenePostProcessing;
var(Flags) bool bEnableSceneDepthTesting;
var(Flags) bool bRequiresNetwork;
var(Flags) bool bRequiresOnlineService;
var(Flags) bool bMenuLevelRestoresScene;
var(Flags) bool bFlushPlayerInput;
var(Flags) bool bCaptureMatchedInput;
var(Flags) bool bDisableWorldRendering;
var transient bool bAnimationBlockingInput;
var transient int UpdateSceneFeedbackLoopCount;
var() int SceneStackPriority;
var editoronly Texture2D ScenePreview;
var transient byte PlayerInputMask;
var(Interaction) EScreenInputMode SceneInputMode;
var(Interaction) ESplitscreenRenderMode SceneRenderMode;
var(PostProcess) EUIPostProcessGroup ScenePostProcessGroup;
var(PostProcess) PostProcessChain UIPostProcessForeground;
var(PostProcess) PostProcessChain UIPostProcessBackground;
var const transient PostProcessSettings CurrentBackgroundSettings;
var const transient PostProcessSettings CurrentForegroundSettings;
var Vector2D CurrentViewportSize;
var(Animation) name SceneAnimation_Open;
var(Animation) name SceneAnimation_Close;
var(Animation) name SceneAnimation_LoseFocus;
var(Animation) name SceneAnimation_RegainingFocus;
var(Animation) name SceneAnimation_RegainedFocus;
var(Sound) name SceneOpenedCue;
var(Sound) name SceneClosedCue;
var const transient editoronly UILayerBase SceneLayerRoot;
var delegate<GetSceneInputModeOverride> __GetSceneInputModeOverride__Delegate;
var delegate<OnInterceptRawInputKey> __OnInterceptRawInputKey__Delegate;
var delegate<OnSceneActivated> __OnSceneActivated__Delegate;
var delegate<OnSceneDeactivated> __OnSceneDeactivated__Delegate;
var delegate<OnQueryCloseSceneAllowed> __OnQueryCloseSceneAllowed__Delegate;
var delegate<OnTopSceneChanged> __OnTopSceneChanged__Delegate;
var delegate<ShouldModulateBackgroundAlpha> __ShouldModulateBackgroundAlpha__Delegate;
var delegate<OnQueryBeginAnimation_DisableInput> __OnQueryBeginAnimation_DisableInput__Delegate;
var delegate<OnQueryEndAnimation_EnableInput> __OnQueryEndAnimation_EnableInput__Delegate;

function DebugShowAnimators()
{
    local int I, ChildIndex;
    local array<UIObject> SceneChildren, AnimatingChildren;
    
    SceneChildren = GetChildren(true);
    for (ChildIndex = 0; ChildIndex < SceneChildren.Length; ChildIndex++)
    {
        if (SceneChildren[ChildIndex].IsAnimating())
        {
            AnimatingChildren.AddItem(SceneChildren[ChildIndex]);
        }
    }
    LogInternal(string(Name) @ "has" @ string(AnimationCount) @ "active animations");
    if (IsAnimating())
    {
        LogInternal("  " $ string(I++) $ ")" @ string(Class.Name) @ string(Name));
        for (ChildIndex = 0; ChildIndex < AnimatingChildren.Length; ChildIndex++)
        {
            LogInternal("    " $ string(I++) $ ")" @ string(AnimatingChildren[ChildIndex].Class.Name) @ PathName(AnimatingChildren[ChildIndex]));
        }
    }
}

function LogCurrentState(int Indent)
{
    local int I;
    local UIState CurrentState;
    
    LogInternal("");
    CurrentState = GetCurrentState();
    LogInternal("Menu state for scene '" $ string(Name) $ "':" @ string(CurrentState.Name));
    for (I = 0; I < Children.Length; I++)
    {
        Children[I].LogCurrentState(3);
    }
}

function LogRenderBounds(int Indent)
{
    local int I;
    
    LogInternal("");
    LogInternal("Render bounds for '" $ string(SceneTag) $ "'" @ "(" $ string(Position.Value[0]) $ "," $ string(Position.Value[1]) $ "," $ string(Position.Value[2]) $ "," $ string(Position.Value[3]) $ ")");
    for (I = 0; I < Children.Length; I++)
    {
        Children[I].LogRenderBounds(3);
    }
}

function OnRegainedFocusAnimationComplete(UIScreenObject Sender, name AnimName, int TrackTypeMask)
{
    if (TrackTypeMask == 0)
    {
        LogInternal("(" $ string(Name) $ ") UIScene::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) @ "Sender:" $ (Sender != none ? string(Sender.Name) : "None") @ "AnimName:'" $ string(AnimName) $ "'", 'DevUIAnimation');
    }
    if (TrackTypeMask == 0 && AnimName == SceneAnimation_RegainedFocus)
    {
        Remove_UIAnimTrackCompletedHandler(OnRegainedFocusAnimationComplete);
    }
}

function OnRegainingFocusAnimationComplete(UIScreenObject Sender, name AnimName, int TrackTypeMask)
{
    if (TrackTypeMask == 0)
    {
        LogInternal("(" $ string(Name) $ ") UIScene::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) @ "Sender:" $ (Sender != none ? string(Sender.Name) : "None") @ "AnimName:'" $ string(AnimName) $ "'", 'DevUIAnimation');
    }
    if (TrackTypeMask == 0 && AnimName == SceneAnimation_RegainingFocus)
    {
        Remove_UIAnimTrackCompletedHandler(OnRegainingFocusAnimationComplete);
    }
}

function OnLostFocusAnimationComplete(UIScreenObject Sender, name AnimName, int TrackTypeMask)
{
    if (TrackTypeMask == 0)
    {
        LogInternal("(" $ string(Name) $ ") UIScene::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) @ "Sender:" $ (Sender != none ? string(Sender.Name) : "None") @ "AnimName:'" $ string(AnimName) $ "'", 'DevUIAnimation');
    }
    if (TrackTypeMask == 0 && AnimName == SceneAnimation_LoseFocus)
    {
        Remove_UIAnimTrackCompletedHandler(OnLostFocusAnimationComplete);
    }
}

function OnCloseAnimationComplete_IgnoreChildScenes(UIScreenObject Sender, name AnimName, int TrackTypeMask)
{
    local GameUISceneClient GameSceneClient;
    
    if (TrackTypeMask == 0)
    {
        LogInternal("(" $ string(Name) $ ") UIScene::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) @ "Sender:" $ (Sender != none ? string(Sender.Name) : "None") @ "AnimName:'" $ string(AnimName) $ "'", 'DevUIAnimation');
    }
    if (TrackTypeMask == 0 && AnimName == SceneAnimation_Close)
    {
        Remove_UIAnimTrackCompletedHandler(OnCloseAnimationComplete_IgnoreChildScenes);
        GameSceneClient = GetSceneClient();
        if (GameSceneClient != none)
        {
            GameSceneClient.CloseScene(self, false);
        }
    }
}

function OnCloseAnimationComplete(UIScreenObject Sender, name AnimName, int TrackTypeMask)
{
    local GameUISceneClient GameSceneClient;
    
    if (TrackTypeMask == 0)
    {
        LogInternal("(" $ string(Name) $ ") UIScene::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) @ "Sender:" $ (Sender != none ? string(Sender.Name) : "None") @ "AnimName:'" $ string(AnimName) $ "'", 'DevUIAnimation');
    }
    if (TrackTypeMask == 0 && AnimName == SceneAnimation_Close)
    {
        Remove_UIAnimTrackCompletedHandler(OnCloseAnimationComplete);
        GameSceneClient = GetSceneClient();
        if (GameSceneClient != none)
        {
            GameSceneClient.CloseScene(self);
        }
    }
}

function OnOpenAnimationComplete(UIScreenObject Sender, name AnimName, int TrackTypeMask)
{
    if (TrackTypeMask == 0)
    {
        LogInternal("(" $ string(Name) $ ") UIScene::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) @ "Sender:" $ (Sender != none ? string(Sender.Name) : "None") @ "AnimName:'" $ string(AnimName) $ "'", 'DevUIAnimation');
    }
    if (TrackTypeMask == 0 && AnimName == SceneAnimation_Open)
    {
        Remove_UIAnimTrackCompletedHandler(OnOpenAnimationComplete);
    }
}

function BeginSceneRegainedFocusAnimation()
{
    BeginSceneAnimation(SceneAnimation_RegainedFocus, OnRegainedFocusAnimationComplete);
}

function BeginSceneRegainingFocusAnimation()
{
    BeginSceneAnimation(SceneAnimation_RegainingFocus, OnRegainingFocusAnimationComplete);
}

function BeginSceneLostFocusAnimation()
{
    BeginSceneAnimation(SceneAnimation_LoseFocus, OnLostFocusAnimationComplete);
}

function bool BeginSceneCloseAnimation(bool bCloseChildScenes)
{
    local UIScene ParentScene;
    local bool bResult;
    
    if (BeginSceneAnimation(SceneAnimation_Close, bCloseChildScenes ? OnCloseAnimationComplete : OnCloseAnimationComplete_IgnoreChildScenes))
    {
        ParentScene = GetPreviousScene();
        if (ParentScene != none)
        {
            ParentScene.BeginSceneRegainingFocusAnimation();
        }
        bResult = true;
    }
    return bResult;
}

function BeginSceneOpenAnimation()
{
    local bool bIsPerformingLoseFocusAnimation, bIsPerformingCloseAnimation;
    
    bIsPerformingLoseFocusAnimation = SceneAnimation_LoseFocus != 'None' && IsAnimating(SceneAnimation_LoseFocus);
    bIsPerformingCloseAnimation = SceneAnimation_Close != 'None' && IsAnimating(SceneAnimation_Close);
    if (!bIsPerformingLoseFocusAnimation && !bIsPerformingCloseAnimation)
    {
        BeginSceneAnimation(SceneAnimation_Open, OnOpenAnimationComplete);
    }
}

function bool StopSceneAnimation(name AnimationSequenceName, optional bool bFinalize = true)
{
    local bool bResult;
    
    if (AnimationSequenceName != 'None' && !IsEditor() && IsAnimating(AnimationSequenceName))
    {
        StopUIAnimation(AnimationSequenceName, , bFinalize);
        bResult = true;
    }
    return bResult;
}

function bool BeginSceneAnimation(name AnimationSequenceName, optional delegate<OnUIAnim_TrackCompleted> TrackCompletedDelegate)
{
    local bool bResult;
    
    if (AnimationSequenceName != 'None' && !IsEditor())
    {
        if (TrackCompletedDelegate != none)
        {
            Add_UIAnimTrackCompletedHandler(TrackCompletedDelegate);
        }
        PlayUIAnimation(AnimationSequenceName);
        bResult = true;
    }
    return bResult;
}

function int FindAnimatorIndex(UIScreenObject SearchObj)
{
    local int Index, Result;
    
    Result = -1;
    if (SearchObj != none)
    {
        for (Index = 0; Index < AnimatingObjects.Length; Index++)
        {
            if (AnimatingObjects[Index] == SearchObj)
            {
                Result = Index;
                break;
            }
        }
    }
    return Result;
}

event bool CloseScene(optional UIScene SceneToClose = self, optional bool bCloseChildScenes = true, optional bool bForceCloseImmediately)
{
    local GameUISceneClient GameSceneClient;
    local int SceneIndex;
    local UIScene NextSceneInStack;
    local bool bResult;
    
    if (SceneClient != none && SceneToClose != none)
    {
        if (bForceCloseImmediately || !SceneToClose.BeginSceneCloseAnimation(bCloseChildScenes))
        {
            bResult = SceneClient.CloseScene(SceneToClose, bCloseChildScenes, bForceCloseImmediately);
        }
        else
        {
            GameSceneClient = GetSceneClient();
            if (GameSceneClient != none && bCloseChildScenes)
            {
                SceneIndex = GameSceneClient.FindSceneIndex(SceneToClose);
                if (SceneIndex != -1)
                {
                    NextSceneInStack = GameSceneClient.GetNextSceneFromIndex(SceneIndex, SceneToClose.PlayerOwner, true);
                    while (NextSceneInStack != none && NextSceneInStack.SceneStackPriority <= SceneToClose.SceneStackPriority)
                    {
                        if (!NextSceneInStack.bExemptFromAutoClose)
                        {
                            CloseScene(NextSceneInStack, false, true);
                        }
                        NextSceneInStack = GameSceneClient.GetNextSceneFromIndex(SceneIndex, SceneToClose.PlayerOwner, true);
                    }
                }
            }
            bResult = true;
        }
    }
    return bResult;
}

event UIScene OpenScene(UIScene SceneToOpen, optional LocalPlayer ScenePlayerOwner = GetPlayerOwner(), optional byte ForcedPriority, optional bool bSkipAnimation = false, optional delegate<OnSceneActivated> SceneDelegate = None)
{
    local UIScene ActiveScene, SceneInstance;
    local GameUISceneClient GameSceneClient;
    
    if (SceneToOpen != none)
    {
        GameSceneClient = GetSceneClient();
        if (GameSceneClient != none)
        {
            GameSceneClient.InitializeScene(SceneToOpen, ScenePlayerOwner, SceneInstance);
            if (SceneInstance != none)
            {
                if (SceneDelegate != none)
                {
                    SceneInstance.__OnSceneActivated__Delegate = SceneDelegate;
                }
                ActiveScene = GameSceneClient.GetActiveScene(ScenePlayerOwner, true);
                if (ActiveScene != none)
                {
                    ActiveScene.StopSceneAnimation(ActiveScene.SceneAnimation_Close);
                }
                if (GameSceneClient.OpenScene(SceneInstance, ScenePlayerOwner, SceneInstance, ForcedPriority))
                {
                    if (ScenePlayerOwner != SceneInstance.PlayerOwner)
                    {
                        ActiveScene = GameSceneClient.GetActiveScene(SceneInstance.PlayerOwner);
                        if (ActiveScene != none && ActiveScene == SceneInstance)
                        {
                            ActiveScene = ActiveScene.GetPreviousScene(true, true);
                        }
                        ScenePlayerOwner = SceneInstance.PlayerOwner;
                    }
                    if (bSkipAnimation)
                    {
                        if (ActiveScene != none)
                        {
                            ActiveScene.StopSceneAnimation(ActiveScene.SceneAnimation_LoseFocus);
                        }
                        if (SceneInstance != none)
                        {
                            SceneInstance.StopSceneAnimation(SceneInstance.SceneAnimation_Open);
                        }
                    }
                    else if (ActiveScene != none)
                    {
                        if (ActiveScene != GameSceneClient.GetActiveScene(ScenePlayerOwner, true))
                        {
                            ActiveScene.StopSceneAnimation(ActiveScene.SceneAnimation_Open, false);
                            ActiveScene.BeginSceneLostFocusAnimation();
                        }
                        else
                        {
                            SceneInstance.StopSceneAnimation(ActiveScene.SceneAnimation_Open);
                            SceneInstance.BeginSceneLostFocusAnimation();
                        }
                    }
                }
            }
        }
    }
    return SceneInstance;
}

function NotifyPlayerRemoved(int PlayerIndex, LocalPlayer RemovedPlayer)
{
    local bool bRemovingPlayerOwner;
    
    bRemovingPlayerOwner = PlayerOwner == RemovedPlayer;
    RemovePlayerData(PlayerIndex, RemovedPlayer);
    if (bRemovingPlayerOwner)
    {
    }
}

function NotifyPlayerAdded(int PlayerIndex, LocalPlayer AddedPlayer)
{
    CreatePlayerData(PlayerIndex, AddedPlayer);
}

function NotifyStorageDeviceChanged()
{
    local UIScene ParentScene;
    
    ParentScene = GetPreviousScene(false);
    if (ParentScene != none)
    {
        ParentScene.NotifyStorageDeviceChanged();
    }
}

function NotifyLinkStatusChanged(bool bConnected)
{
    local UIScene ParentScene;
    
    ParentScene = GetPreviousScene(false);
    if (!bConnected && bRequiresNetwork)
    {
        CloseScene(self, true, true);
    }
    if (ParentScene != none)
    {
        ParentScene.NotifyLinkStatusChanged(bConnected);
    }
}

function NotifyOnlineServiceStatusChanged(EOnlineServerConnectionStatus NewConnectionStatus)
{
    local UIScene ParentScene;
    
    ParentScene = GetPreviousScene(false);
    if (NewConnectionStatus != 1 && bRequiresOnlineService)
    {
        CloseScene(self, true, true);
    }
    if (ParentScene != none)
    {
        ParentScene.NotifyOnlineServiceStatusChanged(NewConnectionStatus);
    }
}

function NotifyControllerStatusChanged(int ControllerId, bool bConnected)
{
    local UIScene ParentScene;
    
    ParentScene = GetPreviousScene(false);
    if (ParentScene != none)
    {
        ParentScene.NotifyControllerStatusChanged(ControllerId, bConnected);
    }
}

function bool NotifyLoginStatusChanged(int ControllerId, ELoginStatus NewStatus)
{
    local UIScene ParentScene;
    local bool bResult;
    
    ParentScene = GetPreviousScene(false, true);
    if (ParentScene != none)
    {
        bResult = ParentScene.NotifyLoginStatusChanged(ControllerId, NewStatus);
    }
    return bResult;
}

function NotifyGameSessionEnded()
{
    if (bCloseOnLevelChange && SceneClient != none)
    {
        CloseScene(self, true, true);
    }
}

function NotifyPreClientTravel(string TravelURL, ETravelType TravelType, bool bIsSeamless)
{
}

function SceneCreated(UIScene CreatedScene)
{
}

event UIAnimationEnded(UIScreenObject Sender, name AnimName, int TrackTypeMask)
{
    if (Sender != none && !Sender.IsAnimating())
    {
        AnimatingObjects.RemoveItem(Sender);
    }
    UIAnimationEnded(Sender, AnimName, TrackTypeMask);
    if (!IsAnimating())
    {
        AnimatingObjects.RemoveItem(self);
    }
    if (OnQueryEndAnimation_EnableInput(AnimName, TrackTypeMask))
    {
        bAnimationBlockingInput = false;
    }
}

event UIAnimationStarted(UIScreenObject Sender, name AnimName, int TrackTypeMask, optional bool bSetAnimatingFlag = true)
{
    local int AnimatorIndex, SequenceIndex, TrackIndex, FrameIndex, PPTrackMask;
    local EUIAnimType TrackType;
    local PostProcessSettings CurrentSettings;
    
    AnimatorIndex = FindAnimatorIndex(Sender);
    if (AnimatorIndex == -1 && Sender != none)
    {
        AnimatingObjects[AnimatingObjects.Length] = Sender;
    }
    UIAnimationStarted(Sender, AnimName, TrackTypeMask, bSetAnimatingFlag);
    PPTrackMask = 14 | 15 | 16;
    if ((TrackTypeMask & PPTrackMask) != 0 && AnimGetCurrentPPSettings(CurrentSettings))
    {
        SequenceIndex = FindAnimationSequenceIndex(AnimName);
        for (TrackIndex = 0; TrackIndex < AnimStack[SequenceIndex].AnimationTracks.Length; TrackIndex++)
        {
            TrackType = AnimStack[SequenceIndex].AnimationTracks[TrackIndex].TrackType;
            if (TrackType == 14 || TrackType == 15 || TrackType == 16)
            {
                for (FrameIndex = 0; FrameIndex < AnimStack[SequenceIndex].AnimationTracks[TrackIndex].KeyFrames.Length; FrameIndex++)
                {
                    if (AnimStack[SequenceIndex].AnimationTracks[TrackIndex].KeyFrames[FrameIndex].RemainingTime == -1.0)
                    {
                        if (TrackType == 14)
                        {
                            AnimStack[SequenceIndex].AnimationTracks[TrackIndex].KeyFrames[FrameIndex].RemainingTime = CurrentSettings.Bloom_InterpolationDuration;
                        }
                        else
                        {
                            assert(TrackType == 15 || TrackType == 16);
                            AnimStack[SequenceIndex].AnimationTracks[TrackIndex].KeyFrames[FrameIndex].RemainingTime = CurrentSettings.DOF_InterpolationDuration;
                        }
                        break;
                    }
                }
            }
        }
    }
    if (OnQueryBeginAnimation_DisableInput(AnimName, TrackTypeMask))
    {
        bAnimationBlockingInput = true;
    }
}

event SetVisibility(bool bIsVisible)
{
    local GameUISceneClient GameSceneClient;
    
    SetVisibility(bIsVisible);
    GameSceneClient = GameUISceneClient(SceneClient);
    if (GameSceneClient != none)
    {
        GameSceneClient.RequestCursorRenderUpdate();
    }
}

event RemovedChild(UIScreenObject WidgetOwner, UIObject OldChild, optional array<UIObject> ExclusionSet)
{
    local UITickableObject TickableObject;
    
    RemovedChild(WidgetOwner, OldChild, ExclusionSet);
    if (GetSceneInputMode() == 2 && OldChild.GetInputMask(false, true) != 0)
    {
        RequestSceneInputMaskUpdate();
    }
    TickableObject = UITickableObject(OldChild);
    if (NotEqual_InterfaceInterface(TickableObject, UITickableObject(none)))
    {
        UnregisterTickableObject(TickableObject);
    }
}

event AddedChild(UIScreenObject WidgetOwner, UIObject NewChild)
{
    AddedChild(WidgetOwner, NewChild);
    NewChild.SetInputMask(PlayerInputMask, true);
    if (GetSceneInputMode() == 2 && NewChild.GetInputMask(false, true) != 0)
    {
        RequestSceneInputMaskUpdate();
    }
}

final event CalculateInputMask()
{
    local int ActivePlayers, ChildIndex;
    local GameUISceneClient GameSceneClient;
    local byte PlayerIndex, NewMask, TestMask, SceneMask;
    local EScreenInputMode InputMode;
    local array<UIObject> SceneChildren;
    
    NewMask = GetInputMask();
    GameSceneClient = GameUISceneClient(SceneClient);
    if (GameSceneClient != none)
    {
        InputMode = GetSceneInputMode();
        switch (InputMode)
        {
            case 1:
            case 3:
            case 2:
                if (PlayerOwner == none)
                {
                    NewMask = 0;
                    ActivePlayers = GetActivePlayerCount();
                    for (PlayerIndex = 0; int(PlayerIndex) < ActivePlayers; PlayerIndex++)
                    {
                        NewMask = byte(int(NewMask) | 1 << int(PlayerIndex));
                    }
                }
                else
                {
                    PlayerIndex = byte(GameSceneClient.Outer.Outer.Outer.GamePlayers.Find(PlayerOwner));
                    if (int(PlayerIndex) == -1)
                    {
                        NewMask = 15;
                    }
                    else
                    {
                        NewMask = byte(int(1) << int(PlayerIndex));
                        if (InputMode == 2)
                        {
                            SceneMask = NewMask;
                            SceneChildren = GetChildren(true);
                            for (ChildIndex = 0; ChildIndex < SceneChildren.Length; ChildIndex++)
                            {
                                TestMask = SceneChildren[ChildIndex].GetInputMask(false, true);
                                SceneMask = byte(int(SceneMask) | int(TestMask));
                            }
                        }
                    }
                }
                break;
            case 5:
            case 4:
                NewMask = 15;
                break;
            case 6:
                NewMask = 0;
                ActivePlayers = GetActivePlayerCount();
                for (PlayerIndex = 0; int(PlayerIndex) < ActivePlayers; PlayerIndex++)
                {
                    NewMask = byte(int(NewMask) | 1 << int(PlayerIndex));
                }
                break;
            case 0:
                NewMask = 0;
                break;
            default:
                WarnInternal("(" $ string(Name) $ ") UIScene::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) @ "(" $ string(SceneTag) $ ") unhandled ScreenInputMode '" $ string(GetEnum(Enum'UIRoot.EScreenInputMode', int(InputMode))) $ "'.  PlayerInputMask will be set to 0");
                break;
        }
    }
    SetInputMask(NewMask, true);
    SetInputMask(byte(int(NewMask) | int(SceneMask)), false, true);
}

event SceneDeactivated()
{
    ActivateEventByClass(LastPlayerIndex, class'UIEvent_SceneDeactivated', self, true);
}

event SceneActivated(bool bInitialActivation)
{
    local int EventIndex;
    local array<UIEvent> EventList;
    local UIEvent_SceneActivated SceneActivatedEvent;
    
    FindEventsOfClass(class'UIEvent_SceneActivated', EventList);
    for (EventIndex = 0; EventIndex < EventList.Length; EventIndex++)
    {
        SceneActivatedEvent = UIEvent_SceneActivated(EventList[EventIndex]);
        if (SceneActivatedEvent != none)
        {
            SceneActivatedEvent.bInitialActivation = bInitialActivation;
            SceneActivatedEvent.ConditionalActivateUIEvent(LastPlayerIndex, self, self, bInitialActivation);
        }
    }
    if (bInitialActivation)
    {
        BeginSceneOpenAnimation();
    }
    else
    {
        if (SceneAnimation_RegainingFocus != 'None' && IsAnimating(SceneAnimation_RegainingFocus))
        {
            StopUIAnimation(SceneAnimation_RegainingFocus, , false);
        }
        BeginSceneRegainedFocusAnimation();
    }
}

event UIObject GetFocusHint(optional bool bQueryOnly)
{
}

native final function LogDockingStack()
{
}

native final function bool SetActiveContextMenu(UIContextMenu NewContextMenu, int PlayerIndex)
{
    NewContextMenu;
    PlayerIndex;
}

native final function UIContextMenu GetActiveContextMenu()
{
}

native final function UIContextMenu GetDefaultContextMenu()
{
}

native final function bool IsSceneActive(optional bool bTopmostScene)
{
    bTopmostScene;
}

native static function WorldInfo GetWorldInfo()
{
}

native final function SetSceneRenderMode(ESplitscreenRenderMode NewRenderMode)
{
    NewRenderMode;
}

native final function ESplitscreenRenderMode GetSceneRenderMode()
{
}

native final function EScreenInputMode GetSceneInputMode(optional bool bMemberValueOnly)
{
    bMemberValueOnly;
}

native final function SetSceneInputMode(EScreenInputMode NewInputMode)
{
    NewInputMode;
}

native final function EUIPostProcessGroup GetScenePostProcessGroup()
{
}

native final function bool ShouldRenderParentScenes()
{
}

native final function UIScene GetPreviousScene(optional bool bRequireMatchingPlayerOwner = true, optional bool bIgnoreUnfocusedScenes)
{
    bRequireMatchingPlayerOwner;
    bIgnoreUnfocusedScenes;
}

native final function UIScene GetNextScene(optional bool bRequireMatchingPlayerOwner = true, optional bool bIgnoreUnfocusedScenes)
{
    bRequireMatchingPlayerOwner;
    bIgnoreUnfocusedScenes;
}

native final function UIDataStore ResolveDataStore(name DataStoreTag, optional LocalPlayer InPlayerOwner)
{
    DataStoreTag;
    InPlayerOwner;
}

native final function UnbindSubscribers()
{
}

native final function SaveSceneDataValues(optional bool bUnbindSubscribers)
{
    bUnbindSubscribers;
}

native final function LoadSceneDataValues()
{
}

native final function SceneDataStore GetSceneDataStore()
{
}

native final function int FindTickableObjectIndex(UITickableObject ObjectToFind)
{
    ObjectToFind;
}

native final function bool UnregisterTickableObject(UITickableObject ObjectToRemove)
{
    ObjectToRemove;
}

native final function bool RegisterTickableObject(UITickableObject ObjectToRegister, optional int InsertIndex = -1)
{
    ObjectToRegister;
    InsertIndex;
}

native final function ResolveScenePositions()
{
}

native final function RebuildDockingStack()
{
}

native final function ForceImmediateSceneUpdate()
{
}

delegate bool OnQueryEndAnimation_EnableInput(name AnimationSequenceName, int TrackTypeMask)
{
    local bool bResult;
    
    if (TrackTypeMask == 0)
    {
        bResult = !bAnimating && AnimationSequenceName != 'None';
    }
    return bResult;
}

delegate bool OnQueryBeginAnimation_DisableInput(name AnimationSequenceName, int TrackTypeMask)
{
    local bool bResult;
    
    if (TrackTypeMask == 0)
    {
        bResult = bAnimating && AnimationSequenceName != 'None';
    }
    return bResult;
}

delegate bool ShouldModulateBackgroundAlpha(out float AlphaModulationPercent)
{
}

delegate OnTopSceneChanged(UIScene NewTopScene)
{
}

delegate bool OnQueryCloseSceneAllowed(UIScene SceneToDeactivate, bool bCloseChildScenes, bool bForcedClose)
{
}

delegate OnSceneDeactivated(UIScene DeactivatedScene)
{
}

delegate OnSceneActivated(UIScene ActivatedScene, bool bInitialActivation)
{
}

delegate bool OnInterceptRawInputKey(out const InputEventParameters EventParms)
{
}

delegate EScreenInputMode GetSceneInputModeOverride()
{
}

defaultproperties
{
    DefaultContextMenuClass="UIContextMenu"
    LastPlayerIndex=-1
    bUpdateDockingStack=True
    bUpdateScenePositions=True
    bUpdateNavigationLinks=True
    bUpdatePrimitiveUsage=True
    bReevaluateRotationSupport=True
    bDisplayCursor=True
    bPauseGameWhileActive=True
    bCloseOnLevelChange=True
    bSaveSceneValuesOnClose=True
    bFlushPlayerInput=True
    bCaptureMatchedInput=True
    SceneStackPriority=10
    PlayerInputMask=15
    SceneInputMode="INPUTMODE_Locked"
    SceneRenderMode="SPLITRENDER_PlayerOwner"
    CurrentBackgroundSettings=(bOverride_EnableBloom=True,bOverride_EnableDOF=True,bOverride_EnableMotionBlur=True,bOverride_EnableDynamicTonemapping=True,bOverride_EnableSceneEffect=True,bOverride_AllowAmbientOcclusion=True,bOverride_OverrideRimShaderColor=True,bOverride_Bloom_Scale=True,bOverride_Bloom_InterpolationDuration=True,bOverride_DOF_FalloffExponent=True,bOverride_DOF_BlurKernelSize=True,bOverride_DOF_BlurBloomKernelSize=True,bOverride_DOF_MaxNearBlurAmount=True,bOverride_DOF_MaxFarBlurAmount=True,bOverride_DOF_ModulateBlurColor=True,bOverride_DOF_FocusType=True,bOverride_DOF_FocusNearInnerRadius=True,bOverride_DOF_FocusFarInnerRadius=True,bOverride_DOF_FocusDistance=True,bOverride_DOF_FarFocusDistance=True,bOverride_DOF_FocusPosition=True,bOverride_DOF_InterpolationDuration=True,bOverride_DOF_EnableDynamicDoF=True,bOverride_DOF_AdaptationRate=True,bOverride_DOF_WaitingTime=True,bOverride_DOF_AimingPoint=True,bOverride_DOF_MinFarInnerRadius=True,bOverride_DOF_DDofRange=True,bOverride_DOF_ResetAdaptationRate=True,bOverride_DOF_ResetDistDifference=True,bOverride_MotionBlur_MaxVelocity=True,bOverride_MotionBlur_Amount=True,bOverride_MotionBlur_FullMotionBlur=True,bOverride_MotionBlur_CameraRotationThreshold=True,bOverride_MotionBlur_CameraTranslationThreshold=True,bOverride_MotionBlur_InterpolationDuration=True,bOverride_DynamicTonemapping_MiddleGray=True,bOverride_DynamicTonemapping_AdaptationRate=True,bOverride_DynamicTonemapping_LuminanceScale=True,bOverride_DynamicTonemapping_MinGray=True,bOverride_DynamicTonemapping_MinColorScale=True,bOverride_DynamicTonemapping_MaxColorScale=True,bOverride_Scene_Desaturation=True,bOverride_Scene_HighLights=True,bOverride_Scene_MidTones=True,bOverride_Scene_Shadows=True,bOverride_Scene_InterpolationDuration=True,bOverride_RimShader_Color=True,bOverride_RimShader_InterpolationDuration=True,bEnableBloom=True,bEnableDOF=False,bEnableMotionBlur=True,bEnableSceneEffect=True,bAllowAmbientOcclusion=True,bOverrideRimShaderColor=False,bEnableDynamicTonemapping=True,Bloom_Scale=1.0,Bloom_InterpolationDuration=1.0,DOF_FalloffExponent=4.0,DOF_BlurKernelSize=16.0,DOF_BlurBloomKernelSize=16.0,DOF_MaxNearBlurAmount=1.0,DOF_MaxFarBlurAmount=1.0,DOF_ModulateBlurColor=(B=255,G=255,R=255,A=255),DOF_FocusType="FOCUS_Distance",DOF_FocusNearInnerRadius=2000.0,DOF_FocusFarInnerRadius=2000.0,DOF_FocusDistance=0.0,DOF_FarFocusDistance=1.0,DOF_FocusPosition=(X=0.0,Y=0.0,Z=0.0),DOF_InterpolationDuration=1.0,DOF_EnableDynamicDoF=False,DOF_AdaptationRate=10.0,DOF_WaitingTime=5.0,DOF_AimingPoint=(X=0.5,Y=0.45,Z=0.1),DOF_MinFarInnerRadius=100.0,DOF_DDofRange=100.0,DOF_ResetAdaptationRate=120.0,DOF_ResetDistDifference=100.0,MotionBlur_MaxVelocity=1.0,MotionBlur_Amount=0.5,MotionBlur_FullMotionBlur=True,MotionBlur_CameraRotationThreshold=45.0,MotionBlur_CameraTranslationThreshold=10000.0,MotionBlur_InterpolationDuration=1.0,DynamicTonemapping_MiddleGray=0.2,DynamicTonemapping_AdaptationRate=90.0,DynamicTonemapping_LuminanceScale=4.0,DynamicTonemapping_MinGray=0.0005,DynamicTonemapping_MinColorScale=0.7,DynamicTonemapping_MaxColorScale=1.2,Scene_Desaturation=0.0,Scene_HighLights=(X=1.0,Y=1.0,Z=1.0),Scene_MidTones=(X=1.0,Y=1.0,Z=1.0),Scene_Shadows=(X=0.0,Y=0.0,Z=0.0),Scene_InterpolationDuration=1.0,RimShader_Color=(R=0.47044,G=0.585973,B=0.827726,A=1.0),RimShader_InterpolationDuration=1.0,ColorGrading_LookupTable="None")
    CurrentForegroundSettings=(bOverride_EnableBloom=True,bOverride_EnableDOF=True,bOverride_EnableMotionBlur=True,bOverride_EnableDynamicTonemapping=True,bOverride_EnableSceneEffect=True,bOverride_AllowAmbientOcclusion=True,bOverride_OverrideRimShaderColor=True,bOverride_Bloom_Scale=True,bOverride_Bloom_InterpolationDuration=True,bOverride_DOF_FalloffExponent=True,bOverride_DOF_BlurKernelSize=True,bOverride_DOF_BlurBloomKernelSize=True,bOverride_DOF_MaxNearBlurAmount=True,bOverride_DOF_MaxFarBlurAmount=True,bOverride_DOF_ModulateBlurColor=True,bOverride_DOF_FocusType=True,bOverride_DOF_FocusNearInnerRadius=True,bOverride_DOF_FocusFarInnerRadius=True,bOverride_DOF_FocusDistance=True,bOverride_DOF_FarFocusDistance=True,bOverride_DOF_FocusPosition=True,bOverride_DOF_InterpolationDuration=True,bOverride_DOF_EnableDynamicDoF=True,bOverride_DOF_AdaptationRate=True,bOverride_DOF_WaitingTime=True,bOverride_DOF_AimingPoint=True,bOverride_DOF_MinFarInnerRadius=True,bOverride_DOF_DDofRange=True,bOverride_DOF_ResetAdaptationRate=True,bOverride_DOF_ResetDistDifference=True,bOverride_MotionBlur_MaxVelocity=True,bOverride_MotionBlur_Amount=True,bOverride_MotionBlur_FullMotionBlur=True,bOverride_MotionBlur_CameraRotationThreshold=True,bOverride_MotionBlur_CameraTranslationThreshold=True,bOverride_MotionBlur_InterpolationDuration=True,bOverride_DynamicTonemapping_MiddleGray=True,bOverride_DynamicTonemapping_AdaptationRate=True,bOverride_DynamicTonemapping_LuminanceScale=True,bOverride_DynamicTonemapping_MinGray=True,bOverride_DynamicTonemapping_MinColorScale=True,bOverride_DynamicTonemapping_MaxColorScale=True,bOverride_Scene_Desaturation=True,bOverride_Scene_HighLights=True,bOverride_Scene_MidTones=True,bOverride_Scene_Shadows=True,bOverride_Scene_InterpolationDuration=True,bOverride_RimShader_Color=True,bOverride_RimShader_InterpolationDuration=True,bEnableBloom=True,bEnableDOF=False,bEnableMotionBlur=True,bEnableSceneEffect=True,bAllowAmbientOcclusion=True,bOverrideRimShaderColor=False,bEnableDynamicTonemapping=True,Bloom_Scale=1.0,Bloom_InterpolationDuration=1.0,DOF_FalloffExponent=4.0,DOF_BlurKernelSize=16.0,DOF_BlurBloomKernelSize=16.0,DOF_MaxNearBlurAmount=1.0,DOF_MaxFarBlurAmount=1.0,DOF_ModulateBlurColor=(B=255,G=255,R=255,A=255),DOF_FocusType="FOCUS_Distance",DOF_FocusNearInnerRadius=2000.0,DOF_FocusFarInnerRadius=2000.0,DOF_FocusDistance=0.0,DOF_FarFocusDistance=1.0,DOF_FocusPosition=(X=0.0,Y=0.0,Z=0.0),DOF_InterpolationDuration=1.0,DOF_EnableDynamicDoF=False,DOF_AdaptationRate=10.0,DOF_WaitingTime=5.0,DOF_AimingPoint=(X=0.5,Y=0.45,Z=0.1),DOF_MinFarInnerRadius=100.0,DOF_DDofRange=100.0,DOF_ResetAdaptationRate=120.0,DOF_ResetDistDifference=100.0,MotionBlur_MaxVelocity=1.0,MotionBlur_Amount=0.5,MotionBlur_FullMotionBlur=True,MotionBlur_CameraRotationThreshold=45.0,MotionBlur_CameraTranslationThreshold=10000.0,MotionBlur_InterpolationDuration=1.0,DynamicTonemapping_MiddleGray=0.2,DynamicTonemapping_AdaptationRate=90.0,DynamicTonemapping_LuminanceScale=4.0,DynamicTonemapping_MinGray=0.0005,DynamicTonemapping_MinColorScale=0.7,DynamicTonemapping_MaxColorScale=1.2,Scene_Desaturation=0.0,Scene_HighLights=(X=1.0,Y=1.0,Z=1.0),Scene_MidTones=(X=1.0,Y=1.0,Z=1.0),Scene_Shadows=(X=0.0,Y=0.0,Z=0.0),Scene_InterpolationDuration=1.0,RimShader_Color=(R=0.47044,G=0.585973,B=0.827726,A=1.0),RimShader_InterpolationDuration=1.0,ColorGrading_LookupTable="None")
    CurrentViewportSize=(X=1024.0,Y=768.0)
    SceneOpenedCue="SceneOpened"
    SceneClosedCue="SceneClosed"
    DefaultStates(0)="UIState_Enabled"
    DefaultStates(1)="UIState_Disabled"
    DefaultStates(2)="UIState_Focused"
    DefaultStates(3)="UIState_Active"
    EventProvider="Default__UIScene.SceneEventComponent"
}

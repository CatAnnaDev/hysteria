class UIScreenObject extends UIRoot
    abstract
    native
    placeable
    config(UI)
    hidecategories(Object,UIRoot,Object);

var(Appearance) UIScreenValue_Bounds Position;
var(Appearance) float ZDepth;
var(Appearance) bool bHidden;
var transient bool bInitialized;
var(Interaction) const bool bNeverFocus;
var(Interaction) bool bSupportsFocusHint;
var const bool bOverrideInputOrder;
var transient bool bAnimating;
var transient bool bAnimationPaused;
var const bool bSupports3DPrimitives;
var array<UIObject> Children;
var const array<class<UIState>> DefaultStates;
var class<UIState> InitialState;
var(Appearance) const export editconst editinline array<UIState> InactiveStates;
var const transient array<UIState> StateStack;
var const transient array<PlayerInteractionData> FocusControls;
var(Interaction) transient array<UIFocusPropagationData> FocusPropagation;
var transient array<UIAnimSequence> AnimStack;
var transient int AnimationCount;
var(ZDebug) globalconfig float AnimationDebugMultiplier;
var(Appearance) float Opacity;
var export editinline UIComp_Event EventProvider;
var(Sound) name FocusedCue;
var(Sound) name MouseEnterCue;
var(Sound) name NavigateUpCue;
var(Sound) name NavigateDownCue;
var(Sound) name NavigateLeftCue;
var(Sound) name NavigateRightCue;
var(Animation) transient editconst array<delegate<OnUIAnim_KeyFrameCompleted>> KeyFrameCompletedDelegates;
var(Animation) transient editconst array<delegate<OnUIAnim_TrackCompleted>> TrackCompletedDelegates;
var delegate<NotifyActiveSkinChanged> __NotifyActiveSkinChanged__Delegate;
var delegate<OnRawInputKey> __OnRawInputKey__Delegate;
var delegate<OnRawInputAxis> __OnRawInputAxis__Delegate;
var delegate<OnProcessInputKey> __OnProcessInputKey__Delegate;
var delegate<OnProcessInputAxis> __OnProcessInputAxis__Delegate;
var delegate<NotifyPositionChanged> __NotifyPositionChanged__Delegate;
var delegate<NotifyResolutionChanged> __NotifyResolutionChanged__Delegate;
var transient delegate<NotifyActiveStateChanged> __NotifyActiveStateChanged__Delegate;
var delegate<NotifyVisibilityChanged> __NotifyVisibilityChanged__Delegate;
var transient delegate<OnInitialSceneUpdate> __OnInitialSceneUpdate__Delegate;
var delegate<OnUIAnim_KeyFrameCompleted> __OnUIAnim_KeyFrameCompleted__Delegate;
var delegate<OnUIAnim_TrackCompleted> __OnUIAnim_TrackCompleted__Delegate;

function LogCurrentState(int Indent)
{
    local int I;
    local string IndentString;
    local UIState CurrentState;
    
    for (I = 0; I < Indent; I++)
    {
        IndentString $= " ";
    }
    CurrentState = GetCurrentState();
    LogInternal(IndentString $ "'" $ string(Name) $ "':" @ string(CurrentState.Name));
    for (I = 0; I < Children.Length; I++)
    {
        Children[I].LogCurrentState(Indent + 3);
    }
}

final function int Find_UIAnimTrackCompletedHandler(delegate<OnUIAnim_TrackCompleted> TrackCompletedDelegate)
{
    return TrackCompletedDelegates.Find(TrackCompletedDelegate);
}

final function int Find_UIAnimKeyFrameCompletedHandler(delegate<OnUIAnim_KeyFrameCompleted> KeyFrameCompletedDelegate)
{
    return KeyFrameCompletedDelegates.Find(KeyFrameCompletedDelegate);
}

final function Remove_UIAnimTrackCompletedHandler(delegate<OnUIAnim_TrackCompleted> TrackCompletedDelegate)
{
    local int RemoveIndex;
    
    if (TrackCompletedDelegate != none)
    {
        RemoveIndex = TrackCompletedDelegates.Find(TrackCompletedDelegate);
        if (RemoveIndex != -1)
        {
            TrackCompletedDelegates.Remove(RemoveIndex, 1);
        }
        else
        {
            WarnInternal(string(TrackCompletedDelegate) @ "was not found in the list of delegates.");
        }
    }
    else
    {
        WarnInternal("NULL value specified for delegate to remove.");
    }
}

final function Remove_UIAnimKeyFrameCompletedHandler(delegate<OnUIAnim_KeyFrameCompleted> KeyFrameCompletedDelegate)
{
    local int RemoveIndex;
    
    if (KeyFrameCompletedDelegate != none)
    {
        RemoveIndex = KeyFrameCompletedDelegates.Find(KeyFrameCompletedDelegate);
        if (RemoveIndex != -1)
        {
            KeyFrameCompletedDelegates.Remove(RemoveIndex, 1);
        }
        else
        {
            WarnInternal(string(KeyFrameCompletedDelegate) @ "was not found in the list of delegates.");
        }
    }
    else
    {
        WarnInternal("NULL value specified for delegate to remove.");
    }
}

final function Add_UIAnimTrackCompletedHandler(delegate<OnUIAnim_TrackCompleted> TrackCompletedDelegate)
{
    if (TrackCompletedDelegate != none)
    {
        if (TrackCompletedDelegates.Find(TrackCompletedDelegate) == -1)
        {
            TrackCompletedDelegates.AddItem(TrackCompletedDelegate);
        }
    }
    else
    {
        WarnInternal("NULL value specified for delegate to add.");
    }
}

final function Add_UIAnimKeyFrameCompletedHandler(delegate<OnUIAnim_KeyFrameCompleted> KeyFrameCompletedDelegate)
{
    if (KeyFrameCompletedDelegate != none)
    {
        if (KeyFrameCompletedDelegates.Find(KeyFrameCompletedDelegate) == -1)
        {
            KeyFrameCompletedDelegates.AddItem(KeyFrameCompletedDelegate);
        }
    }
    else
    {
        WarnInternal("NULL value specified for delegate to add.");
    }
}

event ActivateTrackCompletedDelegates(UIScreenObject Sender, name AnimName, int TrackTypeMask)
{
    local int FuncIndex;
    local array<delegate<OnUIAnim_TrackCompleted>> TempDelegates;
    local delegate<OnUIAnim_TrackCompleted> HandlerFunction;
    
    TempDelegates = TrackCompletedDelegates;
    for (FuncIndex = 0; FuncIndex < TempDelegates.Length; FuncIndex++)
    {
        HandlerFunction = TempDelegates[FuncIndex];
        OnUIAnim_TrackCompleted(Sender, AnimName, TrackTypeMask);
    }
}

event ActivateKeyFrameCompletedDelegates(UIScreenObject Sender, name AnimName, EUIAnimType TrackType)
{
    local int FuncIndex;
    local array<delegate<OnUIAnim_KeyFrameCompleted>> TempDelegates;
    local delegate<OnUIAnim_KeyFrameCompleted> HandlerFunction;
    
    TempDelegates = KeyFrameCompletedDelegates;
    for (FuncIndex = 0; FuncIndex < TempDelegates.Length; FuncIndex++)
    {
        HandlerFunction = TempDelegates[FuncIndex];
        OnUIAnim_KeyFrameCompleted(Sender, AnimName, TrackType);
    }
}

event UIAnimationEnded(UIScreenObject Sender, name AnimName, int TrackTypeMask)
{
    local UIScreenObject Parent;
    
    if (Sender != none)
    {
        AnimationCount--;
        if (AnimationCount <= 0)
        {
            AnimationCount = 0;
            bAnimating = false;
        }
        if (Sender == self)
        {
            ActivateTrackCompletedDelegates(Sender, AnimName, TrackTypeMask);
        }
        Parent = GetParent();
        if (Parent != none)
        {
            Parent.UIAnimationEnded(Sender, AnimName, TrackTypeMask);
        }
    }
}

event UIAnimationStarted(UIScreenObject Sender, name AnimName, int TrackTypeMask, optional bool bSetAnimatingFlag = true)
{
    local UIScreenObject Parent;
    
    if (Sender != none)
    {
        AnimationCount++;
        if (!bAnimating && bSetAnimatingFlag)
        {
            bAnimating = true;
        }
        Parent = GetParent();
        if (Parent != none)
        {
            Parent.UIAnimationStarted(Sender, AnimName, TrackTypeMask, bSetAnimatingFlag);
        }
    }
}

native final function bool IsAnimationPaused()
{
}

native final function PauseAnimations(bool bPauseAnimation)
{
    bPauseAnimation;
}

native event bool IsAnimating(optional name AnimationSequenceName)
{
    AnimationSequenceName;
}

native event ClearUIAnimationLoop(int SequenceIndex, optional int TrackTypeMask)
{
    SequenceIndex;
    TrackTypeMask;
}

native event StopUIAnimation(name AnimName, optional UIAnimationSeq AnimSeq, optional bool bFinalize = true, optional int TrackTypeMask)
{
    AnimName;
    AnimSeq;
    bFinalize;
    TrackTypeMask;
}

native event PlayUIAnimation(name AnimName, optional UIAnimationSeq AnimSeqTemplate, optional EUIAnimationLoopMode OverrideLoopMode = 3, optional float PlaybackRate = 1.0, optional float InitialPosition = 0.0, optional bool bSetAnimatingFlag = true)
{
    AnimName;
    AnimSeqTemplate;
    OverrideLoopMode;
    PlaybackRate;
    InitialPosition;
    bSetAnimatingFlag;
}

native final function int FindAnimationSequenceIndex(name SequenceName)
{
    SequenceName;
}

native function TickAnimations(float DeltaTime)
{
    DeltaTime;
}

native final function bool AnimGetCurrentPPSettings(out PostProcessSettings CurrentSettings)
{
    CurrentSettings;
}

native final function bool Anim_SetValue(EUIAnimType AnimationType, out const UIAnimationRawData NewValue)
{
    AnimationType;
    NewValue;
}

native final function bool Anim_GetValue(EUIAnimType AnimationType, out UIAnimationRawData out_CurrentValue)
{
    AnimationType;
    out_CurrentValue;
}

delegate OnUIAnim_TrackCompleted(UIScreenObject Sender, name AnimName, int TrackTypeMask)
{
}

delegate OnUIAnim_KeyFrameCompleted(UIScreenObject Sender, name AnimName, EUIAnimType TrackType)
{
}

function BecomePrimaryPlayer(int PlayerIndex)
{
    local array<LocalPlayer> OtherPlayers;
    local LocalPlayer PlayerOwner, NextPlayer, OriginalPrimaryPlayer;
    local UIInteraction UIController;
    local UIScene OwnerScene;
    local UIObject Widget;
    
    UIController = GetCurrentUIController();
    if (UIController != none && PlayerIndex > 0 && PlayerIndex < UIController.GetPlayerCount())
    {
        OriginalPrimaryPlayer = GetPlayerOwner(0);
        PlayerOwner = GetPlayerOwner(PlayerIndex);
        if (PlayerOwner == none)
        {
            PlayerOwner = GetPlayerOwner();
        }
        if (PlayerOwner != none)
        {
            NextPlayer = OriginalPrimaryPlayer;
            while (NextPlayer != none && NextPlayer != PlayerOwner)
            {
                UIController.NotifyPlayerRemoved(0, NextPlayer);
                UIController.Outer.Outer.GamePlayers.Remove(0, 1);
                OtherPlayers.AddItem(NextPlayer);
                NextPlayer = GetPlayerOwner(0);
            }
            while (OtherPlayers.Length > 0)
            {
                NextPlayer = OtherPlayers[0];
                UIController.Outer.Outer.GamePlayers.InsertItem(1, NextPlayer);
                UIController.NotifyPlayerAdded(1, NextPlayer);
                OtherPlayers.Remove(0, 1);
            }
            Widget = UIObject(self);
            if (Widget == none)
            {
                OwnerScene = UIScene(self);
            }
            else
            {
                OwnerScene = Widget.GetScene();
            }
            if (OwnerScene != none)
            {
                OwnerScene.LastPlayerIndex = 0;
            }
            PlayerIndex = 0;
        }
        NextPlayer = GetPlayerOwner(0);
        if (OriginalPrimaryPlayer != NextPlayer)
        {
            NextPlayer.Actor.ReloadProfileSettings();
        }
    }
}

function ENATType GetNATType()
{
    return class'UIInteraction'.static.GetNATType();
}

static final function GetLoggedInControllerIds(out array<int> ControllerIds, optional bool bRequireOnlineLogin, optional int MaxPlayersToCheck = 4)
{
    local int ControllerId;
    
    MaxPlayersToCheck = Min(class'OnlineSubsystem'.static.GetNumSupportedLogins(), MaxPlayersToCheck);
    ControllerIds.Length = 0;
    for (ControllerId = 0; ControllerId < MaxPlayersToCheck; ControllerId++)
    {
        if (class'UIInteraction'.static.IsLoggedIn(ControllerId, bRequireOnlineLogin))
        {
            ControllerIds.AddItem(ControllerId);
        }
    }
}

static final function int GetLoggedInPlayerCount(optional bool bRequireOnlineLogin, optional int MaxPlayersToCheck = 4)
{
    local array<int> IDs;
    
    GetLoggedInControllerIds(IDs, bRequireOnlineLogin, MaxPlayersToCheck);
    return IDs.Length;
}

final function bool CanPlayOnline(optional int ControllerId = GetBestControllerId())
{
    return class'UIInteraction'.static.CanPlayOnline(ControllerId);
}

static final function bool HasLinkConnection()
{
    return class'UIInteraction'.static.HasLinkConnection();
}

final function ELoginStatus GetLoginStatus(optional int ControllerId = GetBestControllerId())
{
    return class'UIInteraction'.static.GetLoginStatus(ControllerId);
}

function OnConsoleCommand(UIAction_ConsoleCommand Action)
{
    local LocalPlayer PlayerOwner;
    
    PlayerOwner = GetPlayerOwner();
    if (PlayerOwner != none && PlayerOwner.Actor != none)
    {
        PlayerOwner.Actor.ConsoleCommand(Action.Command);
    }
    else
    {
        LogInternal("(" $ string(Name) $ ") UIScreenObject::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) @ "Couldn't execute console command '" $ Action.Command $ "':" @ "PlayerOwner:" $ (PlayerOwner != none ? string(PlayerOwner.Name) : "None") @ (PlayerOwner != none ? "PlayerOwner.Actor:" $ (PlayerOwner.Actor != none ? string(PlayerOwner.Actor.Name) : "None") : ""));
    }
}

final function bool DisableWidget(int PlayerIndex)
{
    return SetEnabled(false, PlayerIndex);
}

final function bool EnableWidget(int PlayerIndex)
{
    return SetEnabled(true, PlayerIndex);
}

function UIScreenObject GetParent()
{
}

event bool ActivateFocusHint(UIObject FocusHintObject)
{
    return false;
}

event GetSupportedUIActionKeyNames(out array<name> out_KeyNames)
{
}

final event DisablePlayerInput(byte PlayerIndex, optional bool bRecurse = true)
{
    local byte NewPlayerInputMask;
    
    if (PlayerIndex >= 0 && int(PlayerIndex) < 4)
    {
        NewPlayerInputMask = byte(int(GetInputMask(false, true)) & ~(1 << int(PlayerIndex)));
        SetInputMask(NewPlayerInputMask, bRecurse, true);
    }
}

final event EnablePlayerInput(byte PlayerIndex, optional bool bRecurse = true)
{
    local byte CurrentPlayerInputMask, NewPlayerInputMask;
    
    if (PlayerIndex >= 0 && int(PlayerIndex) < 4)
    {
        CurrentPlayerInputMask = GetInputMask(false, true);
        NewPlayerInputMask = byte(int(CurrentPlayerInputMask) | 1 << int(PlayerIndex));
        SetInputMask(NewPlayerInputMask, bRecurse, true);
    }
}

event SetVisibility(bool bIsVisible)
{
    PrivateSetVisibility(bIsVisible);
}

private final function PrivateSetVisibility(bool bVisible)
{
    local bool bCouldAcceptFocus;
    
    if (bHidden == bVisible)
    {
        bCouldAcceptFocus = CanAcceptFocus(GetBestPlayerIndex());
        bHidden = !bVisible;
        NotifyVisibilityChanged(self, bVisible);
        if (IsFocused())
        {
            KillFocus(none);
        }
        if (bCouldAcceptFocus != CanAcceptFocus(GetBestPlayerIndex()))
        {
            RequestSceneUpdate(false, false, true);
        }
    }
}

final event bool IsGamepadConnected(optional int ControllerId = 255)
{
    if (ControllerId == 255)
    {
        ControllerId = GetBestControllerId();
    }
    return class'UIInteraction'.static.IsGamepadConnected(ControllerId);
}

event bool IsLoggedIn(optional int ControllerId = 255, optional bool bRequireOnlineLogin)
{
    if (ControllerId == 255)
    {
        ControllerId = GetBestControllerId();
    }
    return class'UIInteraction'.static.IsLoggedIn(ControllerId, bRequireOnlineLogin);
}

event RemovedFromParent(UIScreenObject WidgetOwner)
{
    local int AnimationIndex;
    
    for (AnimationIndex = AnimStack.Length - 1; AnimationIndex >= 0; AnimationIndex--)
    {
        StopUIAnimation(AnimStack[AnimationIndex].SequenceRef.SeqName, AnimStack[AnimationIndex].SequenceRef, false);
    }
}

event RemovedChild(UIScreenObject WidgetOwner, UIObject OldChild, optional array<UIObject> ExclusionSet)
{
}

event AddedChild(UIScreenObject WidgetOwner, UIObject NewChild)
{
}

event PostInitialize()
{
}

event Initialized()
{
}

native final function string GetWidgetPathName()
{
}

native final function float GetAspectRatioAutoScaleFactor(optional Font BaseFont)
{
    BaseFont;
}

native final function Matrix GetInverseCanvasToScreen()
{
}

native final function Matrix GetCanvasToScreen()
{
}

native final function Vector PixelToCanvas(out const Vector2D PixelPosition)
{
    PixelPosition;
}

native final function Vector ScreenToCanvas(out const Vector4 ScreenPosition)
{
    ScreenPosition;
}

native final function Vector4 PixelToScreen(out const Vector2D PixelPosition)
{
    PixelPosition;
}

native final function Vector2D ScreenToPixel(out const Vector4 ScreenPosition)
{
    ScreenPosition;
}

native final function Vector4 CanvasToScreen(out const Vector CanvasPosition)
{
    CanvasPosition;
}

native final function Vector DeProject(out const Vector PixelPosition)
{
    PixelPosition;
}

native final function Vector Project(out const Vector CanvasPosition)
{
    CanvasPosition;
}

native final function GetDockedWidgets(out array<UIObject> out_DockedWidgets, optional EUIWidgetFace SourceFace = 4, optional EUIWidgetFace TargetFace = 4)
{
    out_DockedWidgets;
    SourceFace;
    TargetFace;
}

native static final function float ResolveUIExtent(out const UIScreenValue_Extent ExtentToResolve, UIScreenObject OwnerWidget, optional EUIExtentEvalType OutputType = 0)
{
    ExtentToResolve;
    OwnerWidget;
    OutputType;
}

native final function Vector GetPositionVector(optional bool bIncludeParentPosition = true)
{
    bIncludeParentPosition;
}

native final function float GetBounds(EUIOrientation Dimension, optional EPositionEvalType OutputType = 0, optional bool bIgnoreDockPadding)
{
    Dimension;
    OutputType;
    bIgnoreDockPadding;
}

native final function float GetPosition(EUIWidgetFace Face, optional EPositionEvalType OutputType = 0, optional bool bIncludeOrigin, optional bool bIgnoreDockPadding)
{
    Face;
    OutputType;
    bIncludeOrigin;
    bIgnoreDockPadding;
}

native final function SetPosition(float NewValue, EUIWidgetFace Face, optional EPositionEvalType InputType = 3, optional bool bIncludesViewportOrigin, optional bool bResolveChange = true)
{
    NewValue;
    Face;
    InputType;
    bIncludesViewportOrigin;
    bResolveChange;
}

native final function InvalidateAllPositions(optional bool bIgnoreDockedFaces = true)
{
    bIgnoreDockedFaces;
}

native final function InvalidatePosition(EUIWidgetFace Face)
{
    Face;
}

native final function int GetPlayerOwnerIndex(optional bool bRequireValidIndex = true)
{
    bRequireValidIndex;
}

native final function int GetBestControllerId()
{
}

native final function int GetBestPlayerIndex()
{
}

native final function int GetSupportedPlayerCount()
{
}

native static final function int GetActivePlayerCount()
{
}

native final function SetInputMask(byte NewInputMask, optional bool bRecurse = true, optional bool bForcedOverride)
{
    NewInputMask;
    bRecurse;
    bForcedOverride;
}

native final function byte GetInputMask(optional bool bInheritedMaskOnly, optional bool bOverrideMaskOnly)
{
    bInheritedMaskOnly;
    bOverrideMaskOnly;
}

native final function bool AcceptsPlayerInput(int PlayerIndex)
{
    PlayerIndex;
}

native final function bool IsRuntimeInstance()
{
}

native final function bool IsPressed(optional int PlayerIndex = GetBestPlayerIndex())
{
    PlayerIndex;
}

native final function bool IsActive(optional int PlayerIndex = GetBestPlayerIndex())
{
    PlayerIndex;
}

native final function bool IsFocused(optional int PlayerIndex = GetBestPlayerIndex())
{
    PlayerIndex;
}

native final function bool IsDisabled(optional int PlayerIndex = GetBestPlayerIndex(), optional bool bCheckOwnerChain = true)
{
    PlayerIndex;
    bCheckOwnerChain;
}

native final function bool IsEnabled(optional int PlayerIndex = GetBestPlayerIndex(), optional bool bCheckOwnerChain = true)
{
    PlayerIndex;
    bCheckOwnerChain;
}

native final function OverrideLastFocusedControl(int PlayerIndex, UIObject ChildToFocus)
{
    PlayerIndex;
    ChildToFocus;
}

native final function UIObject GetLastFocusedControl(optional bool bRecurse, optional int PlayerIndex = GetBestPlayerIndex())
{
    bRecurse;
    PlayerIndex;
}

native final function UIObject GetFocusedControl(optional bool bRecurse, optional int PlayerIndex = GetBestPlayerIndex())
{
    bRecurse;
    PlayerIndex;
}

native function bool KillFocus(UIScreenObject Sender, optional int PlayerIndex = GetBestPlayerIndex())
{
    Sender;
    PlayerIndex;
}

native function bool SetFocusToChild(optional UIObject ChildToFocus, optional int PlayerIndex = GetBestPlayerIndex())
{
    ChildToFocus;
    PlayerIndex;
}

native function bool SetFocus(UIScreenObject Sender, optional int PlayerIndex = GetBestPlayerIndex())
{
    Sender;
    PlayerIndex;
}

native final function bool CanPropagateFocusFor(UIObject TestChild)
{
    TestChild;
}

native function bool CanAcceptFocus(optional int PlayerIndex = GetBestPlayerIndex(), optional bool bIncludeParentVisibility = true)
{
    PlayerIndex;
    bIncludeParentVisibility;
}

native final function bool IsNeverFocused()
{
}

native function bool NavigateFocus(UIScreenObject Sender, EUIWidgetFace Direction, optional int PlayerIndex = GetBestPlayerIndex(), optional out byte bFocusChanged)
{
    Sender;
    Direction;
    PlayerIndex;
    bFocusChanged;
}

native function bool PrevControl(UIScreenObject Sender, optional int PlayerIndex = GetBestPlayerIndex())
{
    Sender;
    PlayerIndex;
}

native function bool NextControl(UIScreenObject Sender, optional int PlayerIndex = GetBestPlayerIndex())
{
    Sender;
    PlayerIndex;
}

native function bool FocusLastControl(UIScreenObject Sender, optional int PlayerIndex = GetBestPlayerIndex())
{
    Sender;
    PlayerIndex;
}

native function bool FocusFirstControl(UIScreenObject Sender, optional int PlayerIndex = GetBestPlayerIndex())
{
    Sender;
    PlayerIndex;
}

native final function bool IsHoldingShift(int ControllerId)
{
    ControllerId;
}

native final function bool IsHoldingAlt(int ControllerId)
{
    ControllerId;
}

native final function bool IsHoldingCtrl(int ControllerId)
{
    ControllerId;
}

native final function bool ConditionalPropagateEnabledState(int PlayerIndex, optional bool bForce)
{
    PlayerIndex;
    bForce;
}

native final function bool DeactivateStateByClass(class<UIState> StateToRemove, int PlayerIndex, optional out UIState StateThatWasRemoved)
{
    StateToRemove;
    PlayerIndex;
    StateThatWasRemoved;
}

native final function bool DeactivateState(UIState StateToRemove, int PlayerIndex)
{
    StateToRemove;
    PlayerIndex;
}

native final function bool ActivateStateByClass(class<UIState> StateToActivate, int PlayerIndex, optional out UIState StateThatWasAdded)
{
    StateToActivate;
    PlayerIndex;
    StateThatWasAdded;
}

native final function bool ActivateState(UIState StateToActivate, int PlayerIndex)
{
    StateToActivate;
    PlayerIndex;
}

native final function bool HasActiveStateOfClass(class<UIState> StateClass, int PlayerIndex, optional out int StateIndex)
{
    StateClass;
    PlayerIndex;
    StateIndex;
}

native final function UIState GetCurrentState(optional int PlayerIndex = -1)
{
    PlayerIndex;
}

native function bool SetEnabled(bool bEnabled, optional int PlayerIndex = GetBestPlayerIndex())
{
    bEnabled;
    PlayerIndex;
}

native final function FindEventsOfClass(class<UIEvent> EventClassToFind, out array<UIEvent> out_EventInstances, optional UIState LimitScope, optional bool bExactClass)
{
    EventClassToFind;
    out_EventInstances;
    LimitScope;
    bExactClass;
}

native final function ActivateEventByClass(int PlayerIndex, class<UIEvent> EventClassToActivate, optional Object InEventActivator, optional bool bActivateImmediately, optional array<int> IndicesToActivate, optional out array<UIEvent> out_ActivatedEvents)
{
    PlayerIndex;
    EventClassToActivate;
    InEventActivator;
    bActivateImmediately;
    IndicesToActivate;
    out_ActivatedEvents;
}

native final function float GetAspectRatio()
{
}

native final function float GetViewportHeight()
{
}

native final function float GetViewportWidth()
{
}

native final function bool GetViewportSize(out Vector2D out_ViewportSize)
{
    out_ViewportSize;
}

native final function bool GetViewportOrigin(out Vector2D out_ViewportOrigin)
{
    out_ViewportOrigin;
}

native final function float GetViewportScale()
{
}

native final function bool GetViewportOffset(out Vector2D out_ViewportOffset)
{
    out_ViewportOffset;
}

native final function bool RebuildNavigationLinks()
{
}

native final function RequestPrimitiveReview(bool bReinitializePrimitives, bool bReviewPrimitiveUsage)
{
    bReinitializePrimitives;
    bReviewPrimitiveUsage;
}

native final function RequestSceneInputMaskUpdate()
{
}

native final function RequestFormattingUpdate()
{
}

native final function RequestSceneUpdate(bool bDockingStackChanged, bool bPositionsChanged, optional bool bNavLinksOutdated = false, optional bool bWidgetStylesChanged = false)
{
    bDockingStackChanged;
    bPositionsChanged;
    bNavLinksOutdated;
    bWidgetStylesChanged;
}

native final function int GetDockClients(optional out array<UIObject> DockClients, optional bool bDirectDockClientsOnly = true, optional EUIWidgetFace TargetFace = 4, optional EUIWidgetFace SourceFace = 4)
{
    DockClients;
    bDirectDockClientsOnly;
    TargetFace;
    SourceFace;
}

native final function int GetObjectCount()
{
}

native final function array<UIObject> GetChildren(optional bool bRecurse, optional array<UIObject> ExclusionSet)
{
    bRecurse;
    ExclusionSet;
}

native final function bool ContainsChildOfClass(class<UIObject> SearchClass, optional bool bRecurse = true)
{
    SearchClass;
    bRecurse;
}

native final function bool ContainsChild(UIObject Child, optional bool bRecurse = true)
{
    Child;
    bRecurse;
}

native final function int FindChildIndex(name WidgetName)
{
    WidgetName;
}

native final function UIObject FindChildUsingID(WIDGET_ID WidgetID, optional bool bRecurse)
{
    WidgetID;
    bRecurse;
}

native final function UIObject FindChild(name WidgetName, optional bool bRecurse)
{
    WidgetName;
    bRecurse;
}

native final function bool ReplaceChild(UIObject ExistingChild, UIObject NewChild)
{
    ExistingChild;
    NewChild;
}

native final function bool ReparentChildren(array<UIObject> ChildrenToReparent, UIScreenObject NewParent, optional int InsertIndex = -1)
{
    ChildrenToReparent;
    NewParent;
    InsertIndex;
}

native final function bool ReparentChild(UIObject CurrentChild, UIScreenObject NewParent, optional int InsertIndex = -1)
{
    CurrentChild;
    NewParent;
    InsertIndex;
}

native final function array<UIObject> RemoveChildren(array<UIObject> ChildrenToRemove)
{
    ChildrenToRemove;
}

native final function bool RemoveChild(UIObject ExistingChild, optional array<UIObject> ExclusionSet)
{
    ExistingChild;
    ExclusionSet;
}

native function int InsertChild(UIObject NewChild, optional int InsertIndex = -1, optional bool bRenameExisting = true)
{
    NewChild;
    InsertIndex;
    bRenameExisting;
}

native final function Initialize(UIScene inOwnerScene, optional UIObject InOwner)
{
    inOwnerScene;
    InOwner;
}

native final function UIPrefabInstance InstanceUIPrefab(UIPrefab SourcePrefab, optional name PrefabInstanceName, optional out const Vector2D PlacementLocation, optional int InsertIndex = -1, optional bool bRenameExisting = true)
{
    SourcePrefab;
    PrefabInstanceName;
    PlacementLocation;
    InsertIndex;
    bRenameExisting;
}

native final function UIObject CreateWidget(UIScreenObject Owner, class<UIObject> WidgetClass, optional Object WidgetArchetype, optional name WidgetName)
{
    Owner;
    WidgetClass;
    WidgetArchetype;
    WidgetName;
}

native static final function bool PlayUISound(name SoundCueName, optional int PlayerIndex = 0)
{
    SoundCueName;
    PlayerIndex;
}

native final function LocalPlayer GetPlayerOwner(optional int PlayerIndex = -1)
{
    PlayerIndex;
}

native final function InitializePlayerTracking()
{
}

native final function RemovePlayerData(int PlayerIndex, LocalPlayer RemovedPlayer)
{
    PlayerIndex;
    RemovedPlayer;
}

native final function CreatePlayerData(int PlayerIndex, LocalPlayer AddedPlayer)
{
    PlayerIndex;
    AddedPlayer;
}

native final function SetZDepth(float NewZDepth, optional bool bPropagateToChildren)
{
    NewZDepth;
    bPropagateToChildren;
}

native final function float GetZDepth()
{
}

native final function bool IsHidden(optional bool bIncludeParents)
{
    bIncludeParents;
}

native final function bool IsVisible(optional bool bIncludeParents)
{
    bIncludeParents;
}

native final function bool IsInitialized()
{
}

delegate OnInitialSceneUpdate()
{
}

delegate NotifyVisibilityChanged(UIScreenObject SourceWidget, bool bIsVisible)
{
}

delegate NotifyActiveStateChanged(UIScreenObject Sender, int PlayerIndex, UIState NewlyActiveState, optional UIState PreviouslyActiveState)
{
}

delegate NotifyResolutionChanged(out const Vector2D OldViewportsize, out const Vector2D NewViewportSize)
{
}

delegate NotifyPositionChanged(UIScreenObject Sender)
{
}

delegate bool OnProcessInputAxis(out const SubscribedInputEventParameters EventParms)
{
}

delegate bool OnProcessInputKey(out const SubscribedInputEventParameters EventParms)
{
}

delegate bool OnRawInputAxis(out const InputEventParameters EventParms)
{
}

delegate bool OnRawInputKey(out const InputEventParameters EventParms)
{
}

delegate NotifyActiveSkinChanged()
{
}

defaultproperties
{
    Position=(Value=0.0,Value[1]=0.0,Value[2]=1.0,Value[3]=1.0,ScaleType="EVALPOS_PercentageOwner",ScaleType[1]="EVALPOS_PercentageOwner",ScaleType[2]="EVALPOS_PercentageOwner",ScaleType[3]="EVALPOS_PercentageOwner",bInvalidated=1,bInvalidated[1]=1,bInvalidated[2]=1,bInvalidated[3]=1,AspectRatioMode="UIASPECTRATIO_AdjustNone")
    DefaultStates(0)="UIState_Enabled"
    DefaultStates(1)="UIState_Disabled"
    InitialState="UIState_Enabled"
    AnimationDebugMultiplier=1.0
    Opacity=1.0
    FocusedCue="Focused"
    NavigateUpCue="NavigateUp"
    NavigateDownCue="NavigateDown"
    NavigateLeftCue="NavigateLeft"
    NavigateRightCue="NavigateRight"
}

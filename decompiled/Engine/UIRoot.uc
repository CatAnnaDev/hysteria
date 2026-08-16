class UIRoot extends Object
    abstract
    native
    notplaceable
    hidecategories(Object,UIRoot);

const MAX_SUPPORTED_GAMEPADS = 4;
const SCENE_DATASTORE_TAG = 'SceneData';
const DEFAULT_SIZE_Y = 768;
const DEFAULT_SIZE_X = 1024;
const PRIVATE_Protected = 0x380;
const PRIVATE_KeepFocusedState = 0x800;
const PRIVATE_PropagateState = 0x400;
const PRIVATE_EditorNoReparent = 0x200;
const PRIVATE_EditorNoRename = 0x100;
const PRIVATE_EditorNoDelete = 0x080;
const PRIVATE_TreeHiddenRecursive = 0x042;
const PRIVATE_ManagedStyle = 0x020;
const PRIVATE_NotRotatable = 0x010;
const PRIVATE_NotDockable = 0x008;
const PRIVATE_NotFocusable = 0x004;
const PRIVATE_TreeHidden = 0x002;
const PRIVATE_NotEditorSelectable = 0x001;
const DEFAULT_SCENE_PRIORITY = 10;
const TEMP_SPLITSCREEN_INDEX = 0;

enum EUIPostProcessGroup
{
    UIPostProcess_None,
    UIPostProcess_Background,
    UIPostProcess_Foreground,
    UIPostProcess_BackgroundAndForeground,
    UIPostProcess_Dynamic,
};

enum EInputPlatformType
{
    IPT_PC,
    IPT_360,
    IPT_PS3,
};

enum ERotationAnchor
{
    RA_Absolute,
    RA_Center,
    RA_PivotLeft,
    RA_PivotRight,
    RA_PivotTop,
    RA_PivotBottom,
    RA_UpperLeft,
    RA_UpperRight,
    RA_LowerLeft,
    RA_LowerRight,
};

enum EEditBoxCharacterSet
{
    CHARSET_All,
    CHARSET_NoSpecial,
    CHARSET_AlphaOnly,
    CHARSET_NumericOnly,
    CHARSET_AlphaNumeric,
};

enum EUIDataProviderFieldType
{
    DATATYPE_Property,
    DATATYPE_Provider,
    DATATYPE_RangeProperty,
    DATATYPE_NetIdProperty,
    DATATYPE_Collection,
    DATATYPE_ProviderCollection,
};

enum ESplitscreenRenderMode
{
    SPLITRENDER_Fullscreen,
    SPLITRENDER_PlayerOwner,
};

enum EScreenInputMode
{
    INPUTMODE_None,
    INPUTMODE_Locked,
    INPUTMODE_Selective,
    INPUTMODE_MatchingOnly,
    INPUTMODE_ActiveOnly,
    INPUTMODE_Free,
    INPUTMODE_Simultaneous,
};

enum ENavigationLinkType
{
    NAVLINK_Automatic,
    NAVLINK_Manual,
};

enum EUIDefaultPenColor
{
    UIPEN_White,
    UIPEN_Black,
    UIPEN_Grey,
};

enum EUIAspectRatioConstraint
{
    UIASPECTRATIO_AdjustNone,
    UIASPECTRATIO_AdjustWidth,
    UIASPECTRATIO_AdjustHeight,
};

enum EUIWidgetFace
{
    UIFACE_Left,
    UIFACE_Top,
    UIFACE_Right,
    UIFACE_Bottom,
};

enum EUIOrientation
{
    UIORIENT_Horizontal,
    UIORIENT_Vertical,
};

enum EColumnHeaderState
{
    COLUMNHEADER_Normal,
    COLUMNHEADER_PrimarySort,
    COLUMNHEADER_SecondarySort,
};

enum EUIListElementState
{
    ELEMENT_Normal,
    ELEMENT_Active,
    ELEMENT_Selected,
    ELEMENT_UnderCursor,
};

enum EUIAlignment
{
    UIALIGN_Left,
    UIALIGN_Center,
    UIALIGN_Right,
    UIALIGN_Default,
};

enum ETextAutoScaleMode
{
    UIAUTOSCALE_None,
    UIAUTOSCALE_Normal,
    UIAUTOSCALE_Justified,
    UIAUTOSCALE_ResolutionBased,
};

enum ETextClipMode
{
    CLIP_None,
    CLIP_Normal,
    CLIP_Ellipsis,
    CLIP_Wrap,
};

enum EUIAutoSizeConstraintType
{
    UIAUTOSIZEREGION_Minimum,
    UIAUTOSIZEREGION_Maximum,
};

enum EUIDockPaddingEvalType
{
    UIPADDINGEVAL_Pixels,
    UIPADDINGEVAL_PercentTarget,
    UIPADDINGEVAL_PercentOwner,
    UIPADDINGEVAL_PercentScene,
    UIPADDINGEVAL_PercentViewport,
};

enum EUIExtentEvalType
{
    UIEXTENTEVAL_Pixels,
    UIEXTENTEVAL_PercentSelf,
    UIEXTENTEVAL_PercentOwner,
    UIEXTENTEVAL_PercentScene,
    UIEXTENTEVAL_PercentViewport,
};

enum EPositionEvalType
{
    EVALPOS_None,
    EVALPOS_PixelViewport,
    EVALPOS_PixelScene,
    EVALPOS_PixelOwner,
    EVALPOS_PercentageViewport,
    EVALPOS_PercentageOwner,
    EVALPOS_PercentageScene,
};

enum EMaterialAdjustmentType
{
    ADJUST_None,
    ADJUST_Normal,
    ADJUST_Justified,
    ADJUST_Bound,
    ADJUST_Stretch,
};

struct native UIInputAliasClassMap
{
    var string WidgetClassName;
    var class<UIScreenObject> WidgetClass;
    var array<UIInputAliasStateMap> WidgetStates;
    var const native transient map<int, int> StateLookupTable;
    var const native transient map<int, int> StateReverseLookupTable;
};

struct native export UIInputAliasStateMap
{
    var string StateClassName;
    var class<UIState> State;
    var array<UIInputActionAlias> StateInputAliases;
};

struct native export UIInputAliasMap
{
    var const native transient MultiMap_Mirror InputAliasLookupTable;
};

struct native export transient UIInputAliasValue
{
    var byte ModifierFlagMask;
    var name InputAliasName;
};

struct native export UIInputActionAlias
{
    var name InputAliasName;
    var array<RawInputKeyEventData> LinkedInputKeys;
};

struct native export RawInputKeyEventData
{
    var name InputKeyName;
    var byte ModifierKeyFlags;
};

struct native UIAxisEmulationDefinition
{
    var name AxisInputKey;
    var name AdjacentAxisInputKey;
    var bool bEmulateButtonPress;
    var name InputKeyToEmulate[2];
};

struct native transient SubscribedInputEventParameters extends InputEventParameters
{
    var const transient name InputAliasName;
};

struct native transient InputEventParameters
{
    var const transient int PlayerIndex;
    var const transient int ControllerId;
    var const transient name InputKeyName;
    var const transient EInputEvent EventType;
    var const transient float InputDelta;
    var const transient float DeltaTime;
    var const transient bool bAltPressed;
    var const transient bool bCtrlPressed;
    var const transient bool bShiftPressed;
};

struct native export UIMouseCursor
{
    var() name CursorStyle;
    var() UITexture Cursor;
};

struct native transient WrappedStringElement
{
    var string Value;
    var Vector2D LineExtent;
};

struct native transient UIStringNode_FormattedNodeParent extends UIStringNode_Text
{
};

struct native transient UIStringNode_NestedMarkupParent extends UIStringNode
{
};

struct native transient UIStringNode_Image extends UIStringNode
{
    var() Vector2D ForcedExtent;
    var() TextureCoordinates TexCoords;
    var() UITexture RenderedImage;
};

struct native transient UIStringNode_Text extends UIStringNode
{
    var() string RenderedText;
    var UICombinedStyleData NodeStyleParameters;
};

struct native transient UIStringNode
{
    var const native transient noexport Pointer VfTable;
    var const transient UIDataStore NodeDataStore;
    var const native transient Pointer ParentNode;
    var() string SourceText;
    var() Vector2D Extent;
    var() Vector2D Scaling;
    var bool bForceWrap;
};

struct native transient UIStringNodeModifier
{
    struct native transient ModifierData
    {
        var const transient UIStyle_Data Style;
        var const transient array<Font> InlineFontStack;
    };
    var const transient UICombinedStyleData CustomStyleData;
    var const transient UICombinedStyleData BaseStyleData;
    var const transient array<ModifierData> ModifierStack;
    var const transient UIState CurrentMenuState;
};

struct native transient UICombinedStyleData
{
    var LinearColor TextColor;
    var LinearColor ImageColor;
    var float TextPadding[2];
    var float ImagePadding[2];
    var Font DrawFont;
    var Surface FallbackImage;
    var TextureCoordinates AtlasCoords;
    var UITextAttributes TextAttributes;
    var EUIAlignment TextAlignment[2];
    var ETextClipMode TextClipMode;
    var EUIAlignment TextClipAlignment;
    var UIImageAdjustmentData AdjustmentType[2];
    var TextAutoScaleValue TextAutoScaling;
    var Vector2D TextScale;
    var Vector2D TextSpacingAdjust;
    var const bool bInitialized;
};

struct native UIImageStyleOverride extends UIStyleOverride
{
    var() TextureCoordinates Coordinates;
    var() UIImageAdjustmentData Formatting[2];
    var bool bOverrideCoordinates;
    var bool bOverrideFormatting;
};

struct native UITextStyleOverride extends UIStyleOverride
{
    var() Font DrawFont;
    var() UITextAttributes TextAttributes;
    var() EUIAlignment TextAlignment[2];
    var() ETextClipMode ClipMode;
    var() EUIAlignment ClipAlignment;
    var() TextAutoScaleValue AutoScaling;
    var() float DrawScale[2];
    var() float SpacingAdjust[2];
    var bool bOverrideDrawFont;
    var bool bOverrideAttributes;
    var bool bOverrideAlignment;
    var bool bOverrideClipMode;
    var bool bOverrideClipAlignment;
    var bool bOverrideAutoScale;
    var bool bOverrideScale;
    var bool bOverrideSpacingAdjust;
};

struct native UIStyleOverride
{
    var() LinearColor DrawColor;
    var() float Opacity;
    var() float Padding[2];
    var bool bOverrideDrawColor;
    var bool bOverrideOpacity;
    var bool bOverridePadding;
};

struct native TextAutoScaleValue
{
    var() float MinScale;
    var() ETextAutoScaleMode AutoScaleMode;
};

struct native transient RenderParameters
{
    var float DrawX;
    var float DrawY;
    var float DrawZ;
    var float DrawXL;
    var float DrawYL;
    var Vector2D Scaling;
    var Font DrawFont;
    var EUIAlignment TextAlignment[2];
    var Vector2D ImageExtent;
    var TextureCoordinates DrawCoords;
    var Vector2D SpacingAdjust;
    var float ViewportHeight;
    var bool bUseOverrideColor;
    var LinearColor OverideDrawColor;
};

struct native UIStringCaretParameters
{
    var() bool bDisplayCaret;
    var() EUIDefaultPenColor CaretType;
    var() float CaretWidth;
    var() name CaretStyle;
    var transient int CaretPosition;
    var transient MaterialInterface CaretMaterial;
};

struct native UIImageAdjustmentData
{
    var() UIScreenValue_Extent ProtectedRegion[2];
    var() EMaterialAdjustmentType AdjustmentType;
    var() EUIAlignment Alignment;
};

struct native UITextAttributes
{
    var() bool Bold;
    var() bool Italic;
    var() bool Underline;
    var() bool Shadow;
    var() bool Strikethrough;
};

struct native transient StyleReferenceId
{
    var name StyleReferenceTag;
    var Property StyleProperty;
};

struct native transient UIStyleSubscriberReference
{
    var name SubscriberId;
    var UIStyleResolver Subscriber;
};

struct native UIDataStoreBinding
{
    var const transient UIDataStoreSubscriber Subscriber;
    var() const editconst EUIDataProviderFieldType RequiredFieldType;
    var() const string MarkupString;
    var const transient int BindingIndex;
    var const transient name DataStoreName;
    var const transient name DataStoreField;
    var const transient UIDataStore ResolvedDataStore;
};

struct native UIRotation
{
    var() const Rotator Rotation;
    var const transient Matrix TransformMatrix;
    var() const UIAnchorPosition AnchorPosition;
    var() ERotationAnchor AnchorType;
};

struct native UIDockingNode
{
    var() UIObject Widget;
    var() EUIWidgetFace Face;
};

struct native UIDockingSet
{
    var const UIObject OwnerWidget;
    var() editconst UIObject TargetWidget[4];
    var() editconst UIScreenValue_DockPadding DockPadding;
    var() bool bLockWidthWhenDocked;
    var() bool bLockHeightWhenDocked;
    var() editconst EUIWidgetFace TargetFace[4];
    var transient byte bResolved[4];
    var transient byte bLinking[4];
};

struct native UINavigationData
{
    var() transient editconst UIObject NavigationTarget[4];
    var() editconst UIObject ForcedNavigationTarget[4];
    var() byte bNullOverride[4];
};

struct native UIFocusPropagationData
{
    var() const transient editconst UIObject FirstFocusTarget;
    var() const transient editconst UIObject LastFocusTarget;
    var() const transient editconst UIObject NextFocusTarget;
    var() const transient editconst UIObject PrevFocusTarget;
    var transient bool bPendingReceiveFocus;
};

struct native transient PlayerInteractionData
{
    var transient UIObject FocusedControl;
    var transient UIObject LastFocusedControl;
};

struct native StateInputKeyAction extends InputKeyAction
{
    var() class<UIState> Scope;
};

struct native InputKeyAction
{
    var() name InputKeyName;
    var() EInputEvent InputKeyState;
    var array<SeqOpOutputInputLink> TriggeredOps;
    var deprecated array<SequenceOp> ActionsToExecute;
};

struct native DefaultEventSpecification
{
    var UIEvent EventTemplate;
    var class<UIState> EventState;
};

struct native transient InputEventSubscription
{
    var name KeyName;
    var array<UIScreenObject> Subscribers;
};

struct native UIRenderingSubregion
{
    var() UIScreenValue_Extent ClampRegionSize;
    var() UIScreenValue_Extent ClampRegionOffset;
    var() EUIAlignment ClampRegionAlignment;
    var() bool bSubregionEnabled;
};

struct native AutoSizeData
{
    var() UIScreenValue_AutoSizeRegion Extent;
    var() AutoSizePadding Padding;
    var() bool bAutoSizeEnabled;
};

struct native AutoSizePadding extends UIScreenValue_AutoSizeRegion
{
};

struct native UIScreenValue_AutoSizeRegion
{
    var() float Value[2];
    var() EUIExtentEvalType EvalType[2];
};

struct native UIScreenValue_DockPadding
{
    var() editconst float PaddingValue[4];
    var() editconst EUIDockPaddingEvalType PaddingScaleType[4];
};

struct native ScreenPositionRange extends UIScreenValue_Position
{
};

struct native UIAnchorPosition extends UIScreenValue_Position
{
    var() float ZDepth;
};

struct native UIScreenValue_Bounds
{
    var() editconst float Value[4];
    var() editconst EPositionEvalType ScaleType[4];
    var transient byte bInvalidated[4];
    var() EUIAspectRatioConstraint AspectRatioMode;
};

struct native UIScreenValue_Position
{
    var() float Value[2];
    var() EPositionEvalType ScaleType[2];
};

struct native UIScreenValue_Extent
{
    var() float Value;
    var() EUIExtentEvalType ScaleType;
    var() EUIOrientation Orientation;
};

struct native UIScreenValue
{
    var() float Value;
    var() EPositionEvalType ScaleType;
    var() EUIOrientation Orientation;
};

struct native UIStyleReference
{
    var name DefaultStyleTag;
    var const class<UIStyle_Data> RequiredStyleClass;
    var const STYLE_ID AssignedStyleID;
    var const transient UIStyle ResolvedStyle;
};

struct native UIProviderFieldValue extends UIProviderScriptFieldValue
{
    var const native transient Pointer CustomStringNode;
};

struct native UIProviderScriptFieldValue
{
    var name PropertyTag;
    var EUIDataProviderFieldType PropertyType;
    var string StringValue;
    var Surface ImageValue;
    var array<int> ArrayValue;
    var UIRangeData RangeValue;
    var UniqueNetId NetIdValue;
    var TextureCoordinates AtlasCoordinates;
};

struct native TextureCoordinates
{
    var() float U;
    var() float V;
    var() float UL;
    var() float VL;
};

struct native UIRangeData
{
    var(Range) float CurrentValue;
    var(Range) float MinValue;
    var(Range) float MaxValue;
    var(Range) float NudgeValue;
    var(Range) bool bIntRange;
};

struct native atomic STYLE_ID extends Guid
{
};

struct native atomic WIDGET_ID extends Guid
{
};

static final function OnlinePlayerInterfaceEx GetOnlinePlayerInterfaceEx()
{
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterfaceEx PlayerIntEx;
    
    OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != none)
    {
        PlayerIntEx = OnlineSub.PlayerInterfaceEx;
    }
    else
    {
        LogInternal("GetOnlinePlayerInterfaceEx: Unable to find OnlineSubSystem!");
    }
    return PlayerIntEx;
}

static final function OnlinePlayerInterface GetOnlinePlayerInterface()
{
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterface Result;
    
    OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != none)
    {
        Result = OnlineSub.PlayerInterface;
    }
    else
    {
        LogInternal("GetOnlinePlayerInterfaceEx: Unable to find OnlineSubSystem!");
    }
    return Result;
}

static final function OnlineGameInterface GetOnlineGameInterface()
{
    local OnlineSubsystem OnlineSub;
    local OnlineGameInterface Result;
    
    OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != none)
    {
        Result = OnlineSub.GameInterface;
    }
    else
    {
        LogInternal("GetOnlinePlayerInterfaceEx: Unable to find OnlineSubSystem!");
    }
    return Result;
}

static final function string ConvertWidgetIDToString(UIObject SourceWidget)
{
    local string Result;
    
    if (SourceWidget != none)
    {
        Result = ToHex(SourceWidget.WidgetID.A) $ ToHex(SourceWidget.WidgetID.B) $ ToHex(SourceWidget.WidgetID.C) $ ToHex(SourceWidget.WidgetID.D);
    }
    return Result;
}

static function bool GetDataStoreStringValue(string InDataStoreMarkup, out string OutStringValue, optional UIScene OwnerScene = none, optional LocalPlayer OwnerPlayer = none)
{
    local UIProviderFieldValue FieldValue;
    local bool Result;
    
    if (GetDataStoreFieldValue(InDataStoreMarkup, FieldValue, OwnerScene, OwnerPlayer))
    {
        OutStringValue = FieldValue.StringValue;
        Result = true;
    }
    return Result;
}

native static final function bool GetDataStoreFieldValue(string InDataStoreMarkup, out UIProviderFieldValue OutFieldValue, optional UIScene OwnerScene, optional LocalPlayer OwnerPlayer)
{
    InDataStoreMarkup;
    OutFieldValue;
    OwnerScene;
    OwnerPlayer;
}

static function bool SetDataStoreStringValue(string InDataStoreMarkup, string InStringValue, optional UIScene OwnerScene, optional LocalPlayer OwnerPlayer)
{
    local UIProviderFieldValue FieldValue;
    
    FieldValue.StringValue = InStringValue;
    FieldValue.PropertyType = 0;
    return SetDataStoreFieldValue(InDataStoreMarkup, FieldValue, OwnerScene, OwnerPlayer);
}

native static final function bool SetDataStoreFieldValue(string InDataStoreMarkup, out const UIProviderFieldValue InFieldValue, optional UIScene OwnerScene, optional LocalPlayer OwnerPlayer)
{
    InDataStoreMarkup;
    InFieldValue;
    OwnerScene;
    OwnerPlayer;
}

static final function UIDataStore StaticResolveDataStore(name DataStoreTag, optional UIScene OwnerScene, optional LocalPlayer InPlayerOwner)
{
    local UIDataStore Result;
    local DataStoreClient DSClient;
    
    if (OwnerScene != none)
    {
        Result = OwnerScene.ResolveDataStore(DataStoreTag, InPlayerOwner);
    }
    else
    {
        DSClient = class'UIInteraction'.static.GetDataStoreClient();
        if (DSClient != none)
        {
            Result = DSClient.FindDataStore(DataStoreTag, InPlayerOwner);
        }
    }
    return Result;
}

native static final function Matrix GetPrimitiveTransform(UIObject Widget, optional bool bIncludeAnchorPosition, optional bool bIncudeRotation = true, optional bool bIncludeScale = true)
{
    Widget;
    bIncludeAnchorPosition;
    bIncudeRotation;
    bIncludeScale;
}

native static final function SetMouseCaptureOverride(bool bCaptureMouse)
{
    bCaptureMouse;
}

native static final function bool GetCursorSize(out float CursorXL, out float CursorYL)
{
    CursorXL;
    CursorYL;
}

native static final function bool GetCursorPosition(out int CursorX, out int CursorY, optional const UIScene Scene)
{
    CursorX;
    CursorY;
    Scene;
}

native static final function EUIOrientation GetFaceOrientation(EUIWidgetFace Face)
{
    Face;
}

native static final function GameUISceneClient GetSceneClient()
{
}

native static final function UIInteraction GetCurrentUIController()
{
}

static final function bool IsEditor()
{
    return GetCurrentUIController() == none;
}

static final function bool IsConsole(optional EConsoleType ConsoleType = 0)
{
    return class'WorldInfo'.static.IsConsoleBuild(ConsoleType);
}

native static final function EInputPlatformType GetInputPlatformType(optional LocalPlayer OwningPlayer)
{
    OwningPlayer;
}

defaultproperties
{
}

class UIObject extends UIScreenObject
    abstract
    native
    placeable
    config(UI)
    hidecategories(Object,UIRoot,Object);

const CONTEXTMENU_BINDING_INDEX = 101;
const TOOLTIP_BINDING_INDEX = 100;
const FIRST_DEFAULT_DATABINDING_INDEX = 100;

var WIDGET_ID WidgetID;
var(Appearance) editconst name WidgetTag;
var const duplicatetransient UIObject Owner;
var const duplicatetransient UIScene OwnerScene;
var UIStyleReference PrimaryStyle;
var(Interaction) byte PlayerInputMask;
var(PostProcess) EUIPostProcessGroup MaskPostProcess;
var(Interaction) UINavigationData NavigationTargets;
var(Interaction) int TabIndex;
var(Appearance) editconst UIDockingSet DockTargets;
var(Appearance) const transient editconst float RenderBounds[4];
var(Appearance) const transient editconst Vector2D RenderBoundsVertices[4];
var(Appearance) UIRotation Rotation;
var(Appearance) Vector RenderOffset;
var int PrivateFlags;
var(Data) UIDataStoreBinding ToolTip;
var(Data) editconst UIDataStoreBinding ContextMenuData;
var UIObject AnimationParent;
var transient array<UIStyleResolver> StyleSubscribers;
var bool bEnableActiveCursorUpdates;
var const bool bSupportsPrimaryStyle;
var bool bEnableSceneUpdateNotifications;
var(ZDebug) bool bDebugShowBounds;
var(ZDebug) Color DebugBoundsColor;
var delegate<OnCreate> __OnCreate__Delegate;
var delegate<OnPreSceneUpdate> __OnPreSceneUpdate__Delegate;
var delegate<OnPostSceneUpdate> __OnPostSceneUpdate__Delegate;
var delegate<OnValueChanged> __OnValueChanged__Delegate;
var delegate<OnRefreshSubscriberValue> __OnRefreshSubscriberValue__Delegate;
var delegate<OnPressed> __OnPressed__Delegate;
var delegate<OnPressRepeat> __OnPressRepeat__Delegate;
var delegate<OnPressRelease> __OnPressRelease__Delegate;
var delegate<OnClicked> __OnClicked__Delegate;
var delegate<OnDoubleClick> __OnDoubleClick__Delegate;
var delegate<OnOpenContextMenu> __OnOpenContextMenu__Delegate;
var delegate<OnCloseContextMenu> __OnCloseContextMenu__Delegate;
var delegate<OnContextMenuItemSelected> __OnContextMenuItemSelected__Delegate;

function LogRenderBounds(int Indent)
{
    local int I;
    local string IndentString;
    
    for (I = 0; I < Indent; I++)
    {
        IndentString $= " ";
    }
    LogInternal(IndentString $ "'" $ string(WidgetTag) $ "': (" $ string(RenderBounds[0]) $ "," $ string(RenderBounds[1]) $ "," $ string(RenderBounds[2]) $ "," $ string(RenderBounds[3]) $ ") Pos:(" $ string(Position.Value[0]) $ "," $ string(Position.Value[1]) $ "," $ string(Position.Value[2]) $ "," $ string(Position.Value[3]) $ ")");
    for (I = 0; I < Children.Length; I++)
    {
        Children[I].LogRenderBounds(Indent + 3);
    }
}

function ClearDockTargets()
{
    local byte FaceIndex;
    
    for (FaceIndex = 0; int(FaceIndex) < 4; FaceIndex++)
    {
        SetDockParameters(FaceIndex, none, 4, 0.0);
    }
}

function UIScreenObject GetParent()
{
    local UIScreenObject Result;
    
    Result = GetOwner();
    if (Result == none)
    {
        Result = GetScene();
    }
    return Result;
}

final function UIObject GetOwner()
{
    return Owner;
}

final function UIScene GetScene()
{
    return OwnerScene;
}

native final function bool SetWidgetStyleByName(name StyleResolverTagToSet, name StyleFriendlyName)
{
    StyleResolverTagToSet;
    StyleFriendlyName;
}

native final function int FindStyleSubscriberIndexById(name StyleSubscriberId)
{
    StyleSubscriberId;
}

native final function int FindStyleSubscriberIndex(out const UIStyleResolver Subscriber)
{
    Subscriber;
}

native final function RemoveStyleSubscriber(UIStyleResolver Subscriber)
{
    Subscriber;
}

native final function AddStyleSubscriber(UIStyleResolver Subscriber)
{
    Subscriber;
}

native final function float GetPositionExtent(EUIWidgetFace Face, optional bool bIncludeRotation, optional bool bIncludeOrigin)
{
    Face;
    bIncludeRotation;
    bIncludeOrigin;
}

native final function GetPositionExtents(out float MinX, out float MaxX, out float MinY, out float MaxY, optional bool bIncludeRotation, optional bool bIncludeOrigin)
{
    MinX;
    MaxX;
    MinY;
    MaxY;
    bIncludeRotation;
    bIncludeOrigin;
}

native final function bool NeedsActiveCursorUpdates()
{
}

native function SetActiveCursorUpdate(bool bShouldReceiveCursorUpdates)
{
    bShouldReceiveCursorUpdates;
}

native final function SetPrivateBehavior(int Behavior, bool Value, optional bool bRecurse)
{
    Behavior;
    Value;
    bRecurse;
}

native final function bool IsPrivateBehaviorSet(int Behavior)
{
    Behavior;
}

native function bool CanAcceptFocus(optional int PlayerIndex = 0, optional bool bIncludeParentVisibility = true)
{
    PlayerIndex;
    bIncludeParentVisibility;
}

native final function bool SetForcedNavigationTarget(EUIWidgetFace Face, UIObject NavTarget, optional bool bIsNullOverride = false)
{
    Face;
    NavTarget;
    bIsNullOverride;
}

native final function bool SetNavigationTarget(EUIWidgetFace Face, UIObject NewNavTarget)
{
    Face;
    NewNavTarget;
}

native final function bool IsDockedTo(const UIScreenObject TargetWidget, optional EUIWidgetFace SourceFace = 4, optional EUIWidgetFace TargetFace = 4)
{
    TargetWidget;
    SourceFace;
    TargetFace;
}

native final function bool GetDockParameters(EUIWidgetFace SourceFace, out UIScreenObject TargetWidget, out EUIWidgetFace TargetFace, out float TargetPadding)
{
    SourceFace;
    TargetWidget;
    TargetFace;
    TargetPadding;
}

native final function bool SetDockParameters(EUIWidgetFace SourceFace, UIScreenObject Target, EUIWidgetFace TargetFace, float PaddingValue, optional EUIDockPaddingEvalType PaddingInputType = 0, optional bool bModifyPaddingScaleType)
{
    SourceFace;
    Target;
    TargetFace;
    PaddingValue;
    PaddingInputType;
    bModifyPaddingScaleType;
}

native function bool SetDockPadding(EUIWidgetFace SourceFace, float PaddingValue, optional EUIDockPaddingEvalType PaddingInputType = 0, optional bool bModifyPaddingScaleType)
{
    SourceFace;
    PaddingValue;
    PaddingInputType;
    bModifyPaddingScaleType;
}

native function bool SetDockTarget(EUIWidgetFace SourceFace, UIScreenObject Target, EUIWidgetFace TargetFace)
{
    SourceFace;
    Target;
    TargetFace;
}

native final function bool IsContainedBy(UIObject TestWidget)
{
    TestWidget;
}

native function NotifyValueChanged(optional int PlayerIndex = -1, optional int NotifyFlags = 0)
{
    PlayerIndex;
    NotifyFlags;
}

native final function Matrix GetRotationMatrix(optional bool bIncludeParentRotations = true)
{
    bIncludeParentRotations;
}

native final function Matrix GenerateTransformMatrix(optional bool bIncludeParentTransforms = true)
{
    bIncludeParentTransforms;
}

native final function Vector GetAnchorPosition(optional bool bRelativeToWidget = true, optional bool bPixelSpace)
{
    bRelativeToWidget;
    bPixelSpace;
}

native final function UpdateRotationMatrix()
{
}

native final function RotateWidget(Rotator NewRotationAmount, optional bool bAccumulateRotation)
{
    NewRotationAmount;
    bAccumulateRotation;
}

native final function SetAnchorPosition(Vector NewAnchorPosition, optional EPositionEvalType InputType = 1)
{
    NewAnchorPosition;
    InputType;
}

native final function bool HasTransform(optional bool bIncludeParentTransforms = true)
{
    bIncludeParentTransforms;
}

native final function string GetToolTipValue()
{
}

native function string GenerateSceneDataStoreMarkup(optional string Group = "ContextMenuItems")
{
    Group;
}

native final function ClearDefaultDataBinding(int BindingIndex)
{
    BindingIndex;
}

native final function GetDefaultDataStores(out array<UIDataStore> out_BoundDataStores)
{
    out_BoundDataStores;
}

native final function bool ResolveDefaultDataBinding(int BindingIndex)
{
    BindingIndex;
}

native final function string GetDefaultDataBinding(int BindingIndex)
{
    BindingIndex;
}

native final function SetDefaultDataBinding(string MarkupText, int BindingIndex)
{
    MarkupText;
    BindingIndex;
}

delegate OnContextMenuItemSelected(UIContextMenu ContextMenu, int PlayerIndex, int ItemIndex)
{
}

delegate bool OnCloseContextMenu(UIContextMenu ContextMenu, int PlayerIndex)
{
}

delegate bool OnOpenContextMenu(UIObject Sender, int PlayerIndex, out UIContextMenu CustomContextMenu)
{
}

delegate OnDoubleClick(UIScreenObject EventObject, int PlayerIndex)
{
}

delegate bool OnClicked(UIScreenObject EventObject, int PlayerIndex)
{
}

delegate OnPressRelease(UIScreenObject EventObject, int PlayerIndex)
{
}

delegate OnPressRepeat(UIScreenObject EventObject, int PlayerIndex)
{
}

delegate OnPressed(UIScreenObject EventObject, int PlayerIndex)
{
}

delegate bool OnRefreshSubscriberValue(UIObject Sender, int BindingIndex)
{
}

delegate OnValueChanged(UIObject Sender, int PlayerIndex)
{
}

delegate OnPostSceneUpdate(UIObject Sender)
{
}

delegate OnPreSceneUpdate(UIObject Sender)
{
}

delegate OnCreate(UIObject CreatedWidget, UIScreenObject CreatorContainer)
{
}

defaultproperties
{
    PrimaryStyle=(DefaultStyleTag="DefaultComboStyle",RequiredStyleClass="None",AssignedStyleID=(A=0,B=0,C=0,D=0),ResolvedStyle="None")
    PlayerInputMask=15
    TabIndex=-1
    DockTargets=(OwnerWidget="None",TargetWidget="None",TargetWidget[1]="None",TargetWidget[2]="None",TargetWidget[3]="None",DockPadding=(PaddingValue=0.0,PaddingValue[1]=0.0,PaddingValue[2]=0.0,PaddingValue[3]=0.0,PaddingScaleType="UIPADDINGEVAL_Pixels",PaddingScaleType[1]="UIPADDINGEVAL_Pixels",PaddingScaleType[2]="UIPADDINGEVAL_Pixels",PaddingScaleType[3]="UIPADDINGEVAL_Pixels"),bLockWidthWhenDocked=False,bLockHeightWhenDocked=False,TargetFace="None",TargetFace[1]="None",TargetFace[2]="None",TargetFace[3]="None",bResolved=0,bResolved[1]=0,bResolved[2]=0,bResolved[3]=0,bLinking=0,bLinking[1]=0,bLinking[2]=0,bLinking[3]=0)
    Rotation=(Rotation=(Pitch=0,Yaw=0,Roll=0),TransformMatrix=(XPlane=(X=0.0,Y=1.0,Z=0.0,W=0.0),YPlane=(X=0.0,Y=0.0,Z=1.0,W=0.0),ZPlane=(X=0.0,Y=0.0,Z=0.0,W=1.0),WPlane=(X=1.0,Y=0.0,Z=0.0,W=0.0)),AnchorPosition=(ZDepth=0.0,Value=0.0,Value[1]=0.0,ScaleType="EVALPOS_PixelOwner",ScaleType[1]="EVALPOS_PixelOwner"),AnchorType="RA_Center")
    ToolTip=(Subscriber="None",RequiredFieldType="DATATYPE_Property",MarkupString="",BindingIndex=100,DataStoreName="None",DataStoreField="None",ResolvedDataStore="None")
    ContextMenuData=(Subscriber="None",RequiredFieldType="DATATYPE_Collection",MarkupString="",BindingIndex=101,DataStoreName="None",DataStoreField="None",ResolvedDataStore="None")
    bSupportsPrimaryStyle=True
    DebugBoundsColor=(B=255,G=128,R=255,A=255)
    EventProvider="Default__UIObject.WidgetEventComponent"
}

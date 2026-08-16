class UIComp_DrawString extends UIComp_DrawComponents
    native
    notplaceable
    editinlinenew
    within UIObject
    hidecategories(Object)
    implements(UIStyleResolver);

var const native noexport Pointer VfTable_IUIStyleResolver;
var transient UIDataStoreSubscriber SubscriberOwner;
var name StyleResolverTag;
var transient UIString ValueString;
var const transient class<UIString> StringClass;
var(Appearance) bool bDropShadow;
var(Data) bool bIgnoreMarkup;
var(Appearance) bool bAllowBoundsAdjustment;
var(ZDebug) transient bool bRefreshString;
var transient bool bReapplyFormatting;
var(Appearance) Vector2D DropShadowOffset;
var(Appearance) LinearColor DropShadowColor;
var(Appearance) AutoSizeData AutoSizeParameters[2];
var(Appearance) UIRenderingSubregion ClampRegion[2];
var(StyleOverride) UITextStyleOverride TextStyleCustomization;
var UIStyleReference StringStyle;

final event SetAutoSizePadding(EUIOrientation Orientation, float NearValue, float FarValue, EUIExtentEvalType NearScaleType, EUIExtentEvalType FarScaleType)
{
    local bool bNeedsReformatting;
    
    bNeedsReformatting = AutoSizeParameters[int(Orientation)].Padding.Value[0] != NearValue || AutoSizeParameters[int(Orientation)].Padding.Value[1] != FarValue || AutoSizeParameters[int(Orientation)].Padding.EvalType[0] != NearScaleType || AutoSizeParameters[int(Orientation)].Padding.EvalType[1] != FarScaleType;
    AutoSizeParameters[int(Orientation)].Padding.Value[0] = NearValue;
    AutoSizeParameters[int(Orientation)].Padding.Value[1] = FarValue;
    AutoSizeParameters[int(Orientation)].Padding.EvalType[0] = NearScaleType;
    AutoSizeParameters[int(Orientation)].Padding.EvalType[1] = FarScaleType;
    bReapplyFormatting = bReapplyFormatting || bNeedsReformatting;
    if (bReapplyFormatting)
    {
        Outer.RequestSceneUpdate(false, true);
    }
}

final event EnableAutoSizing(EUIOrientation Orientation, optional bool bShouldEnable = true)
{
    local bool bNeedsReformatting;
    
    bNeedsReformatting = IsAutoSizeEnabled(Orientation) != bShouldEnable;
    AutoSizeParameters[int(Orientation)].bAutoSizeEnabled = bShouldEnable;
    bReapplyFormatting = bReapplyFormatting || bNeedsReformatting;
    if (bReapplyFormatting)
    {
        Outer.RequestSceneUpdate(true, true);
    }
}

final function bool IsAutoSizeEnabled(EUIOrientation Orientation)
{
    return AutoSizeParameters[int(Orientation)].bAutoSizeEnabled;
}

native final function SetAutoSizeExtent(EUIOrientation Orientation, float MinValue, float MaxValue, EUIExtentEvalType MinScaleType, EUIExtentEvalType MaxScaleType)
{
    Orientation;
    MinValue;
    MaxValue;
    MinScaleType;
    MaxScaleType;
}

native final function bool NotifyResolveStyle(UISkin ActiveSkin, bool bClearExistingValue, optional UIState CurrentMenuState, optional const name StylePropertyName)
{
    ActiveSkin;
    bClearExistingValue;
    CurrentMenuState;
    StylePropertyName;
}

native final function bool SetStyleResolverTag(name NewResolverTag)
{
    NewResolverTag;
}

native final function name GetStyleResolverTag()
{
}

native final function bool GetFinalStringStyle(out UICombinedStyleData FinalStyleData)
{
    FinalStyleData;
}

native final function UIStyle_Combo GetAppliedStringStyle(optional UIState DesiredMenuState)
{
    DesiredMenuState;
}

native final function ETextClipMode GetWrapMode()
{
}

native final function DisableCustomSpacingAdjust()
{
}

native final function DisableCustomScale()
{
}

native final function DisableCustomAutoScaling()
{
}

native final function DisableCustomClipAlignment()
{
}

native final function DisableCustomClipMode()
{
}

native final function DisableCustomAlignment()
{
}

native final function DisableCustomAttributes()
{
}

native final function DisableCustomFont()
{
}

native final function DisableCustomPadding()
{
}

native final function DisableCustomOpacity()
{
}

native final function DisableCustomColor()
{
}

native final function SetSpacingAdjust(EUIOrientation Orientation, float NewSpacingAdjust)
{
    Orientation;
    NewSpacingAdjust;
}

native final function SetScale(EUIOrientation Orientation, float NewScale)
{
    Orientation;
    NewScale;
}

native final function SetAutoScaling(ETextAutoScaleMode NewAutoScaleMode, optional float NewMinScaleValue = -1.0)
{
    NewAutoScaleMode;
    NewMinScaleValue;
}

native final function SetClipAlignment(EUIAlignment NewClipAlignment)
{
    NewClipAlignment;
}

native final function SetWrapMode(ETextClipMode NewClipMode)
{
    NewClipMode;
}

native final function SetAlignment(EUIOrientation Orientation, EUIAlignment NewAlignment)
{
    Orientation;
    NewAlignment;
}

native final function SetAttributes(UITextAttributes NewAttributes)
{
    NewAttributes;
}

native final function SetFont(Font NewFont)
{
    NewFont;
}

native final function SetPadding(float HorizontalPadding, float VerticalPadding)
{
    HorizontalPadding;
    VerticalPadding;
}

native final function SetOpacity(float NewOpacity)
{
    NewOpacity;
}

native final function SetColor(LinearColor NewColor)
{
    NewColor;
}

native final function SetSubregionAlignment(EUIOrientation Orientation, EUIAlignment NewValue)
{
    Orientation;
    NewValue;
}

native final function SetSubregionOffset(EUIOrientation Orientation, float NewValue, EUIExtentEvalType EvalType)
{
    Orientation;
    NewValue;
    EvalType;
}

native final function SetSubregionSize(EUIOrientation Orientation, float NewValue, EUIExtentEvalType EvalType)
{
    Orientation;
    NewValue;
    EvalType;
}

native final function EnableSubregion(EUIOrientation Orientation, optional bool bShouldEnable = true)
{
    Orientation;
    bShouldEnable;
}

native final function EUIAlignment GetSubregionAlignment(EUIOrientation Orientation)
{
    Orientation;
}

native final function float GetSubregionOffset(EUIOrientation Orientation, optional EUIExtentEvalType OutputType = 0)
{
    Orientation;
    OutputType;
}

native final function float GetSubregionSize(EUIOrientation Orientation, optional EUIExtentEvalType OutputType = 0)
{
    Orientation;
    OutputType;
}

native final function bool IsSubregionEnabled(EUIOrientation Orientation)
{
    Orientation;
}

native final function RefreshValue()
{
}

native final function string GetValue(optional bool bReturnProcessedText = true)
{
    bReturnProcessedText;
}

native final function SetValue(string NewText)
{
    NewText;
}

defaultproperties
{
    StyleResolverTag="String Style"
    StringClass="UIString"
    bAllowBoundsAdjustment=True
    DropShadowOffset=(X=2.0,Y=2.0)
    DropShadowColor=(R=0.0,G=0.0,B=0.0,A=1.0)
    ClampRegion=(ClampRegionSize=(Value=1.0,ScaleType="UIEXTENTEVAL_PercentSelf",Orientation="UIORIENT_Horizontal"),ClampRegionOffset=(Value=0.0,ScaleType="UIEXTENTEVAL_PercentSelf",Orientation="UIORIENT_Horizontal"),ClampRegionAlignment="UIALIGN_Default",bSubregionEnabled=False)
    ClampRegion[1]=(ClampRegionSize=(Value=1.0,ScaleType="UIEXTENTEVAL_PercentSelf",Orientation="UIORIENT_Vertical"),ClampRegionOffset=(Value=0.0,ScaleType="UIEXTENTEVAL_PercentSelf",Orientation="UIORIENT_Vertical"),ClampRegionAlignment="UIALIGN_Default",bSubregionEnabled=False)
    TextStyleCustomization=(DrawFont="None",TextAttributes=(Bold=False,Italic=False,Underline=False,Shadow=False,Strikethrough=False),TextAlignment="UIALIGN_Left",TextAlignment[1]="UIALIGN_Left",ClipMode="CLIP_None",ClipAlignment="UIALIGN_Left",AutoScaling=(MinScale=0.6,AutoScaleMode="UIAUTOSCALE_None"),DrawScale=1.0,DrawScale[1]=1.0,SpacingAdjust=0.0,SpacingAdjust[1]=0.0,bOverrideDrawFont=False,bOverrideAttributes=False,bOverrideAlignment=False,bOverrideClipMode=False,bOverrideClipAlignment=False,bOverrideAutoScale=False,bOverrideScale=False,bOverrideSpacingAdjust=False,DrawColor=(R=1.0,G=1.0,B=1.0,A=1.0),Opacity=1.0,Padding=0.0,Padding[1]=0.0,bOverrideDrawColor=False,bOverrideOpacity=False,bOverridePadding=False)
    StringStyle=(DefaultStyleTag="DefaultComboStyle",RequiredStyleClass="UIStyle_Combo",AssignedStyleID=(A=0,B=0,C=0,D=0),ResolvedStyle="None")
}

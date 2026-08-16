class UIComp_DrawImage extends UIComp_DrawComponents
    native
    notplaceable
    editinlinenew
    within UIObject
    hidecategories(Object)
    implements(UIStyleResolver,CustomPropertyItemHandler);

var const native noexport Pointer VfTable_IUIStyleResolver;
var const native noexport Pointer VfTable_ICustomPropertyItemHandler;
var name StyleResolverTag;
var(StyleOverride) export editinline UITexture ImageRef;
var(StyleOverride) UIImageStyleOverride StyleCustomization;
var UIStyleReference ImageStyle;

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

native final function Surface GetImage()
{
}

native final function DisableCustomFormatting()
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

native final function DisableCustomCoordinates()
{
}

native final function SetFormatting(EUIOrientation Orientation, UIImageAdjustmentData NewFormattingData)
{
    Orientation;
    NewFormattingData;
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

native final function SetCoordinates(TextureCoordinates NewCoordinates)
{
    NewCoordinates;
}

native final function SetImage(Surface NewImage)
{
    NewImage;
}

native final function UIStyle_Image GetAppliedImageStyle(optional UIState DesiredMenuState)
{
    DesiredMenuState;
}

defaultproperties
{
    StyleResolverTag="Image Style"
    StyleCustomization=(Coordinates=(U=0.0,V=0.0,UL=0.0,VL=0.0),Formatting=(ProtectedRegion=(Value=0.0,ScaleType="UIEXTENTEVAL_Pixels",Orientation="UIORIENT_Horizontal"),ProtectedRegion[1]=(Value=0.0,ScaleType="UIEXTENTEVAL_Pixels",Orientation="UIORIENT_Horizontal"),AdjustmentType="ADJUST_Normal",Alignment="UIALIGN_Left"),Formatting[1]=(ProtectedRegion=(Value=0.0,ScaleType="UIEXTENTEVAL_Pixels",Orientation="UIORIENT_Vertical"),ProtectedRegion[1]=(Value=0.0,ScaleType="UIEXTENTEVAL_Pixels",Orientation="UIORIENT_Vertical"),AdjustmentType="ADJUST_Normal",Alignment="UIALIGN_Left"),bOverrideCoordinates=False,bOverrideFormatting=False,DrawColor=(R=1.0,G=1.0,B=1.0,A=1.0),Opacity=1.0,Padding=0.0,Padding[1]=0.0,bOverrideDrawColor=False,bOverrideOpacity=False,bOverridePadding=False)
    ImageStyle=(DefaultStyleTag="DefaultImageStyle",RequiredStyleClass="UIStyle_Image",AssignedStyleID=(A=0,B=0,C=0,D=0),ResolvedStyle="None")
}

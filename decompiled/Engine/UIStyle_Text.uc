class UIStyle_Text extends UIStyle_Data
    native
    notplaceable
    hidecategories(Object,UIRoot);

var Font StyleFont;
var UITextAttributes Attributes;
var EUIAlignment Alignment[2];
var ETextClipMode ClipMode;
var EUIAlignment ClipAlignment;
var TextAutoScaleValue AutoScaling;
var Vector2D Scale;
var Vector2D SpacingAdjust;

defaultproperties
{
    StyleFont="EngineFonts.SmallFont"
    Alignment[1]="UIALIGN_Center"
    AutoScaling=(MinScale=0.6,AutoScaleMode="UIAUTOSCALE_None")
    Scale=(X=1.0,Y=1.0)
    UIEditorControlClass="WxStyleTextPropertiesGroup"
}

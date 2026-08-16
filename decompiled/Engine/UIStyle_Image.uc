class UIStyle_Image extends UIStyle_Data
    native
    notplaceable
    hidecategories(Object,UIRoot);

var() Surface DefaultImage;
var() TextureCoordinates Coordinates;
var() UIImageAdjustmentData AdjustmentType[2];

defaultproperties
{
    DefaultImage="EngineResources.DefaultTexture"
    AdjustmentType=(ProtectedRegion=(Value=0.0,ScaleType="UIEXTENTEVAL_Pixels",Orientation="UIORIENT_Horizontal"),ProtectedRegion[1]=(Value=0.0,ScaleType="UIEXTENTEVAL_Pixels",Orientation="UIORIENT_Horizontal"),AdjustmentType="ADJUST_Normal",Alignment="UIALIGN_Left")
    AdjustmentType[1]=(ProtectedRegion=(Value=0.0,ScaleType="UIEXTENTEVAL_Pixels",Orientation="UIORIENT_Horizontal"),ProtectedRegion[1]=(Value=0.0,ScaleType="UIEXTENTEVAL_Pixels",Orientation="UIORIENT_Horizontal"),AdjustmentType="ADJUST_Normal",Alignment="UIALIGN_Left")
    UIEditorControlClass="WxStyleImagePropertiesGroup"
}

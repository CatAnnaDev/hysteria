class UIString extends UIRoot
    native
    notplaceable
    transient
    within UIScreenObject
    hidecategories(Object,UIRoot);

var native transient array<Pointer> Nodes;
var transient UICombinedStyleData StringStyleData;
var transient Vector2D StringExtent;

native final function bool ContainsMarkup()
{
}

native final function GetAutoScaleValue(Vector2D BoundingRegionSize, Vector2D StringSize, out Vector2D out_AutoScalePercent)
{
    BoundingRegionSize;
    StringSize;
    out_AutoScalePercent;
}

native final function string GetValue(optional bool bReturnProcessedText = true)
{
    bReturnProcessedText;
}

native final function bool SetValue(string InputString, bool bIgnoreMarkup)
{
    InputString;
    bIgnoreMarkup;
}

defaultproperties
{
    StringStyleData=(TextColor=(R=0.0,G=0.0,B=0.0,A=1.0),ImageColor=(R=0.0,G=0.0,B=0.0,A=1.0),TextPadding=0.0,TextPadding[1]=0.0,ImagePadding=0.0,ImagePadding[1]=0.0,DrawFont="None",FallbackImage="None",AtlasCoords=(U=0.0,V=0.0,UL=0.0,VL=0.0),TextAttributes=(Bold=False,Italic=False,Underline=False,Shadow=False,Strikethrough=False),TextAlignment="UIALIGN_Left",TextAlignment[1]="UIALIGN_Left",TextClipMode="CLIP_Normal",TextClipAlignment="UIALIGN_Left",AdjustmentType=(ProtectedRegion=(Value=0.0,ScaleType="UIEXTENTEVAL_Pixels",Orientation="UIORIENT_Horizontal"),ProtectedRegion[1]=(Value=0.0,ScaleType="UIEXTENTEVAL_Pixels",Orientation="UIORIENT_Horizontal"),AdjustmentType="ADJUST_Normal",Alignment="UIALIGN_Left"),AdjustmentType[1]=(ProtectedRegion=(Value=0.0,ScaleType="UIEXTENTEVAL_Pixels",Orientation="UIORIENT_Horizontal"),ProtectedRegion[1]=(Value=0.0,ScaleType="UIEXTENTEVAL_Pixels",Orientation="UIORIENT_Horizontal"),AdjustmentType="ADJUST_Normal",Alignment="UIALIGN_Left"),TextAutoScaling=(MinScale=0.6,AutoScaleMode="UIAUTOSCALE_None"),TextScale=(X=1.0,Y=1.0),TextSpacingAdjust=(X=0.0,Y=0.0),bInitialized=False)
}

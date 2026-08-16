class UIFrameBox extends UIContainer
    native
    placeable
    config(UI)
    hidecategories(Object,UIRoot,Object);

enum EFrameBoxImage
{
    FBI_TopLeft,
    FBI_Top,
    FBI_TopRight,
    FBI_CenterLeft,
    FBI_Center,
    FBI_CenterRight,
    FBI_BottomLeft,
    FBI_Bottom,
    FBI_BottomRight,
};

struct native CornerSizes
{
    var() float TopLeft[2];
    var() float TopRight[2];
    var() float BottomLeft[2];
    var() float BottomRight[2];
    var() float TopHeight;
    var() float BottomHeight;
    var() float CenterLeftWidth;
    var() float CenterRightWidth;
};

var(Components) const export editinline noclear UIComp_DrawImage BackgroundImageComponent[9];
var(Appearance) editinline CornerSizes BackgroundCornerSizes;

final function SetBackgroundImage(EFrameBoxImage ImageToSet, Surface NewImage)
{
    if (BackgroundImageComponent[int(ImageToSet)] != none)
    {
        BackgroundImageComponent[int(ImageToSet)].SetImage(NewImage);
    }
}

defaultproperties
{
    BackgroundImageComponent="Default__UIFrameBox.TemplateTopLeft"
    BackgroundImageComponent[1]="Default__UIFrameBox.TemplateTop"
    BackgroundImageComponent[2]="Default__UIFrameBox.TemplateTopRight"
    BackgroundImageComponent[3]="Default__UIFrameBox.TemplateCenterLeft"
    BackgroundImageComponent[4]="Default__UIFrameBox.TemplateCenter"
    BackgroundImageComponent[5]="Default__UIFrameBox.TemplateCenterRight"
    BackgroundImageComponent[6]="Default__UIFrameBox.TemplateBottomLeft"
    BackgroundImageComponent[7]="Default__UIFrameBox.TemplateBottom"
    BackgroundImageComponent[8]="Default__UIFrameBox.TemplateBottomRight"
    BackgroundCornerSizes=(TopLeft=16.0,TopLeft[1]=16.0,TopRight=16.0,TopRight[1]=16.0,BottomLeft=16.0,BottomLeft[1]=16.0,BottomRight=16.0,BottomRight[1]=16.0,TopHeight=16.0,BottomHeight=16.0,CenterLeftWidth=16.0,CenterRightWidth=16.0)
    PrimaryStyle=(DefaultStyleTag="PanelBackground",RequiredStyleClass="UIStyle_Image")
    bSupportsPrimaryStyle=False
    EventProvider="Default__UIFrameBox.WidgetEventComponent"
}

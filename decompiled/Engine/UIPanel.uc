class UIPanel extends UIContainer
    native
    placeable
    config(UI)
    hidecategories(Object,UIRoot,Object);

var(Components) const export editinline UIComp_DrawImage BackgroundImageComponent;
var(Appearance) bool bEnforceClipping;

final function SetBackgroundImage(Surface NewImage)
{
    if (BackgroundImageComponent != none)
    {
        BackgroundImageComponent.SetImage(NewImage);
    }
}

defaultproperties
{
    BackgroundImageComponent="Default__UIPanel.PanelBackgroundTemplate"
    PrimaryStyle=(DefaultStyleTag="PanelBackground",RequiredStyleClass="UIStyle_Image")
    bSupportsPrimaryStyle=False
    EventProvider="Default__UIPanel.WidgetEventComponent"
}

class UIButton extends UIObject
    native
    placeable
    config(UI)
    hidecategories(Object,UIRoot,Object);

var(Components) const export editinline noclear UIComp_DrawImage BackgroundImageComponent;
var(Sound) name ClickedCue;

final function SetImage(Surface NewImage)
{
    if (BackgroundImageComponent != none)
    {
        BackgroundImageComponent.SetImage(NewImage);
    }
}

defaultproperties
{
    BackgroundImageComponent="Default__UIButton.BackgroundImageTemplate"
    ClickedCue="Clicked"
    PrimaryStyle=(DefaultStyleTag="ButtonBackground",RequiredStyleClass="UIStyle_Image")
    bSupportsPrimaryStyle=False
    DefaultStates(0)="UIState_Enabled"
    DefaultStates(1)="UIState_Disabled"
    DefaultStates(2)="UIState_Focused"
    DefaultStates(3)="UIState_Active"
    DefaultStates(4)="UIState_Pressed"
    EventProvider="Default__UIButton.WidgetEventComponent"
}

class UIOptionListButton extends UIButton
    native
    notplaceable
    config(UI)
    within UIOptionListBase
    hidecategories(Object,UIRoot,Object);

native final function UpdateButtonState(optional int PlayerIndex = -1)
{
    PlayerIndex;
}

defaultproperties
{
    BackgroundImageComponent="Default__UIOptionListButton.BackgroundImageTemplate"
    PrivateFlags=111
    EventProvider="Default__UIOptionListButton.WidgetEventComponent"
}

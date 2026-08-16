class UIToggleButton extends UILabelButton
    native
    placeable
    config(UI)
    hidecategories(Object,UIRoot,Object);

var(Data) UIDataStoreBinding ValueDataSource;
var(Data) bool bIsChecked;
var(Components) const export editinline noclear UIComp_DrawString CheckedStringRenderComponent;
var(Components) const export editinline noclear UIComp_DrawImage CheckedBackgroundImageComponent;

function bool ButtonClicked(UIScreenObject Sender, int PlayerIndex)
{
    SetValue(!IsChecked());
    return false;
}

native final function SetValue(bool bShouldBeChecked, optional int PlayerIndex = -1)
{
    bShouldBeChecked;
    PlayerIndex;
}

final function bool IsChecked()
{
    return bIsChecked;
}

native function SetCaption(string NewText)
{
    NewText;
}

defaultproperties
{
    ValueDataSource=(Subscriber="None",RequiredFieldType="DATATYPE_Property",MarkupString="",BindingIndex=-1,DataStoreName="None",DataStoreField="None",ResolvedDataStore="None")
    CheckedStringRenderComponent="Default__UIToggleButton.CheckedLabelStringRenderer"
    CheckedBackgroundImageComponent="Default__UIToggleButton.CheckedBackgroundImageTemplate"
    StringRenderComponent="Default__UIToggleButton.LabelStringRenderer"
    BackgroundImageComponent="Default__UIToggleButton.BackgroundImageTemplate"
    __OnClicked__Delegate="None"
    EventProvider="Default__UIToggleButton.WidgetEventComponent"
}

class UIOptionList extends UIOptionListBase
    native
    placeable
    config(UI)
    hidecategories(Object,UIRoot,Object);

var transient int CurrentIndex;
var const transient UIListElementProvider DataProvider;
var delegate<OnIsCurrValueValid> __OnIsCurrValueValid__Delegate;

native function SetCurrentIndex(int NewIndex)
{
    NewIndex;
}

native function int GetCurrentIndex()
{
}

delegate bool OnIsCurrValueValid()
{
}

native function bool IsCurrValueValid()
{
}

native function SetNextValue()
{
}

native function SetPrevValue()
{
}

native final function bool GetListValue(int ListIndex, out string OutValue)
{
    ListIndex;
    OutValue;
}

defaultproperties
{
    DecrementButton="Default__UIOptionList.DecrementButtonTemplate"
    IncrementButton="Default__UIOptionList.IncrementButtonTemplate"
    BackgroundImageComponent="Default__UIOptionList.BackgroundImageTemplate"
    StringRenderComponent="Default__UIOptionList.LabelStringRenderer"
    Children(0)="Default__UIOptionList.DecrementButtonTemplate"
    Children(1)="Default__UIOptionList.IncrementButtonTemplate"
    EventProvider="Default__UIOptionList.WidgetEventComponent"
}

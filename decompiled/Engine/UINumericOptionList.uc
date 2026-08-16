class UINumericOptionList extends UIOptionListBase
    native
    placeable
    config(UI)
    hidecategories(Object,UIRoot,Object);

var(Data) UIRangeData RangeValue;

native final function float GetValue(optional bool bPercentageValue)
{
    bPercentageValue;
}

native final function bool SetValue(coerce float NewValue, optional bool bPercentageValue)
{
    NewValue;
    bPercentageValue;
}

defaultproperties
{
    RangeValue=(CurrentValue=0.0,MinValue=0.0,MaxValue=0.0,NudgeValue=1.0,bIntRange=False)
    DecrementButton="Default__UINumericOptionList.DecrementButtonTemplate"
    IncrementButton="Default__UINumericOptionList.IncrementButtonTemplate"
    BackgroundImageComponent="Default__UINumericOptionList.BackgroundImageTemplate"
    StringRenderComponent="Default__UINumericOptionList.LabelStringRenderer"
    DataSource=(RequiredFieldType="DATATYPE_RangeProperty")
    Children(0)="Default__UINumericOptionList.DecrementButtonTemplate"
    Children(1)="Default__UINumericOptionList.IncrementButtonTemplate"
    EventProvider="Default__UINumericOptionList.WidgetEventComponent"
}

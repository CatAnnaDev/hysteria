class UIObjectList extends UIList
    native
    placeable
    config(UI)
    hidecategories(Object,UIRoot,Object);

native final function UIObject GetElementObjectValue(int ElementIndex, optional int CellIndex = -1)
{
    ElementIndex;
    CellIndex;
}

defaultproperties
{
    VerticalScrollbar="Default__UIObjectList.VertScrollbarTemplate"
    CellDataComponent="Default__UIObjectList.ObjectListPresenter"
    Children(0)="Default__UIObjectList.VertScrollbarTemplate"
    EventProvider="Default__UIObjectList.WidgetEventComponent"
}

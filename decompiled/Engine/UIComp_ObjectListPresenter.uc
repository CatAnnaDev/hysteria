class UIComp_ObjectListPresenter extends UIComp_ListPresenter
    native
    notplaceable
    editinlinenew
    within UIObjectList
    hidecategories(Object);

defaultproperties
{
    ListItemOverlay="Default__UIComp_ObjectListPresenter.NormalOverlayTemplate"
    ListItemOverlay[1]="Default__UIComp_ObjectListPresenter.ActiveOverlayTemplate"
    ListItemOverlay[2]="Default__UIComp_ObjectListPresenter.SelectionOverlayTemplate"
    ListItemOverlay[3]="Default__UIComp_ObjectListPresenter.HoverOverlayTemplate"
    bDisplayColumnHeaders=False
}

class UIComp_ContextMenuListPresenter extends UIComp_ListPresenterCascade
    native
    notplaceable
    editinlinenew
    within UIContextMenu
    hidecategories(Object);

defaultproperties
{
    ListItemOverlay="Default__UIComp_ContextMenuListPresenter.NormalOverlayTemplate"
    ListItemOverlay[1]="Default__UIComp_ContextMenuListPresenter.ActiveOverlayTemplate"
    ListItemOverlay[2]="Default__UIComp_ContextMenuListPresenter.SelectionOverlayTemplate"
    ListItemOverlay[3]="Default__UIComp_ContextMenuListPresenter.HoverOverlayTemplate"
    bDisplayColumnHeaders=False
}

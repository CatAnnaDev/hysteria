class UIComp_ListPresenterCascade extends UIComp_ListPresenter
    native
    notplaceable
    editinlinenew
    within UIList
    hidecategories(Object);

defaultproperties
{
    ListItemOverlay="Default__UIComp_ListPresenterCascade.NormalOverlayTemplate"
    ListItemOverlay[1]="Default__UIComp_ListPresenterCascade.ActiveOverlayTemplate"
    ListItemOverlay[2]="Default__UIComp_ListPresenterCascade.SelectionOverlayTemplate"
    ListItemOverlay[3]="Default__UIComp_ListPresenterCascade.HoverOverlayTemplate"
}

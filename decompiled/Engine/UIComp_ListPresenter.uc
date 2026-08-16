class UIComp_ListPresenter extends UIComp_ListPresenterBase
    native
    notplaceable
    editinlinenew
    within UIList
    hidecategories(Object)
    implements(CustomPropertyItemHandler);

struct native UIElementCellSchema
{
    var() editinline array<UIListElementCellTemplate> Cells;
};

struct native UIListItem
{
    var const UIListItemDataBinding DataSource;
    var() editconst editfixedsize editinline array<UIListElementCell> Cells;
    var() transient editconst EUIListElementState ElementState;
    var() editconst editinline UIObject ElementWidget;
};

struct native UIListElementCellTemplate extends UIListElementCell
{
    var() editinline name CellDataField;
    var() string ColumnHeaderText;
    var() UIScreenValue_Extent CellSize;
    var float CellPosition;
};

struct native UIListElementCell
{
    var const native transient int ContainerElementIndex;
    var const transient UIList OwnerList;
    var UIStyleReference CellStyle[4];
    var transient noexport Object ValueObject;
};

var const native noexport Pointer VfTable_ICustomPropertyItemHandler;
var(Data) const UIElementCellSchema ElementSchema;
var(Appearance) UIScreenValue_Extent SelectionHintPadding;
var(Data) transient editconst editinline array<UIListItem> ListItems;
var(Style) export editinline UITexture ColumnHeaderBackground[3];
var(Style) export editinline UITexture ListItemOverlay[4];
var(Style) TextureCoordinates ColumnHeaderBackgroundCoordinates[3];
var(Style) TextureCoordinates ListItemOverlayCoordinates[4];
var(Appearance) int MaxElementsPerPage;
var(Appearance) bool bDisplayColumnHeaders;

native final function int FindElementIndex(int DataSourceIndex)
{
    DataSourceIndex;
}

defaultproperties
{
    ListItemOverlay="Default__UIComp_ListPresenter.NormalOverlayTemplate"
    ListItemOverlay[1]="Default__UIComp_ListPresenter.ActiveOverlayTemplate"
    ListItemOverlay[2]="Default__UIComp_ListPresenter.SelectionOverlayTemplate"
    ListItemOverlay[3]="Default__UIComp_ListPresenter.HoverOverlayTemplate"
    bDisplayColumnHeaders=True
}

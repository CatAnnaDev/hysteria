class UIComp_ListPresenterBase extends UIComp_ListComponentBase
    abstract
    native
    notplaceable
    editinlinenew
    within UIList
    hidecategories(Object);

struct native UIListItemDataBinding
{
    var UIListElementCellProvider DataSourceProvider;
    var name DataSourceTag;
    var int DataSourceIndex;
};

var transient bool bReapplyFormatting;

native final function int GetMaxElementsPerPage()
{
}

native final function SetMaxElementsPerPage(int NewMaxVisibleElements)
{
    NewMaxVisibleElements;
}

native final function string GetElementValue(int ElementIndex, optional int CellIndex = -1)
{
    ElementIndex;
    CellIndex;
}

native final function EnableColumnHeaderRendering(optional bool bShouldRenderColHeaders = true)
{
    bShouldRenderColHeaders;
}

native final function bool ShouldRenderColumnHeaders()
{
}

native final function bool ShouldAdjustListBounds(EUIOrientation Orientation)
{
    Orientation;
}

native final function CalculateAutoSizeColumnWidth(int ColIndex, out float out_ColWidth, out float out_StylePadding, optional bool bReturnUnformattedValue)
{
    ColIndex;
    out_ColWidth;
    out_StylePadding;
    bReturnUnformattedValue;
}

native final function CalculateAutoSizeRowHeight(int RowIndex, out float out_RowHeight, out float out_StylePadding, optional bool bReturnUnformattedValue)
{
    RowIndex;
    out_RowHeight;
    out_StylePadding;
    bReturnUnformattedValue;
}

native final function float GetSchemaCellPosition(int SchemaCellIndex)
{
    SchemaCellIndex;
}

native final function bool SetSchemaCellSize(int SchemaCellIndex, float NewCellSize, optional EUIExtentEvalType EvalType = 0)
{
    SchemaCellIndex;
    NewCellSize;
    EvalType;
}

native final function float GetSchemaCellSize(int SchemaCellIndex, optional EUIExtentEvalType EvalType = 0)
{
    SchemaCellIndex;
    EvalType;
}

native final function int GetSchemaCellCount()
{
}

native final function UIListElementCellProvider GetCellSchemaProvider()
{
}

defaultproperties
{
    bReapplyFormatting=True
}

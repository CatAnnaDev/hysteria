class UIDataProvider_OnlinePlayerStorageArray extends UIDataProvider
    native
    notplaceable
    transient
    hidecategories(Object,UIRoot)
    implements(UIListElementProvider,UIListElementCellProvider);

var const native noexport Pointer VfTable_IUIListElementProvider;
var const native noexport Pointer VfTable_IUIListElementCellProvider;
var OnlinePlayerStorage PlayerStorage;
var int PlayerStorageId;
var name PlayerStorageName;
var const string ColumnHeaderText;
var array<name> Values;

defaultproperties
{
    WriteAccessType="ACCESS_WriteAll"
}

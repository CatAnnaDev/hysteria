class UIDataProvider_SettingsArray extends UIDataProvider
    native
    notplaceable
    transient
    hidecategories(Object,UIRoot)
    implements(UIListElementProvider,UIListElementCellProvider);

var const native noexport Pointer VfTable_IUIListElementProvider;
var const native noexport Pointer VfTable_IUIListElementCellProvider;
var Settings Settings;
var int SettingsId;
var name SettingsName;
var const string ColumnHeaderText;
var array<IdToStringMapping> Values;

defaultproperties
{
    WriteAccessType="ACCESS_WriteAll"
}

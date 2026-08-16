class UIDataProvider_MenuItem extends UIResourceDataProvider
    native
    notplaceable
    transient
    perobjectconfig
    config(UI)
    hidecategories(Object,UIRoot);

enum EMenuOptionType
{
    MENUOT_ComboReadOnly,
    MENUOT_ComboNumeric,
    MENUOT_CheckBox,
    MENUOT_Slider,
    MENUOT_Spinner,
    MENUOT_EditBox,
    MENUOT_CollectionCheckBox,
    MENUOT_CollapsingList,
};

var config EMenuOptionType OptionType;
var config EEditBoxCharacterSet EditboxAllowedChars;
var config array<name> OptionSet;
var config string DataStoreMarkup;
var config string DescriptionMarkup;
var config name RequiredGameMode;
var const config localized string FriendlyName;
var string CustomFriendlyName;
var const config localized string Description;
var config bool bEditableCombo;
var config bool bNumericCombo;
var config bool bKeyboardOrMouseOption;
var config bool bOnlineOnly;
var config bool bOfflineOnly;
var() bool bSearchAllInis;
var config bool bRemoveOn360;
var config bool bRemoveOnPC;
var config bool bRemoveOnPS3;
var config int EditBoxMaxLength;
var config UIRangeData RangeData;
var config array<name> SchemaCellFields;
var const string IniName;

native final function bool IsFiltered()
{
}

defaultproperties
{
}

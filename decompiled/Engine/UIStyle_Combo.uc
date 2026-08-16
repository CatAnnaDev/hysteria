class UIStyle_Combo extends UIStyle_Data
    native
    notplaceable
    hidecategories(Object,UIRoot);

struct native StyleDataReference
{
    var UIStyle OwnerStyle;
    var STYLE_ID SourceStyleID;
    var transient UIStyle SourceStyle;
    var UIState SourceState;
    var UIStyle_Data CustomStyleData;
};

var StyleDataReference ImageStyle;
var StyleDataReference TextStyle;

native final function UIStyle_Image GetComboImageStyle()
{
}

native final function UIStyle_Text GetComboTextStyle()
{
}

defaultproperties
{
    UIEditorControlClass="WxStyleComboPropertiesGroup"
}

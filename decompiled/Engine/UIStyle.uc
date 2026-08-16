class UIStyle extends UIRoot
    native
    notplaceable
    perobjectconfig
    within UISkin
    hidecategories(Object,UIRoot);

var STYLE_ID StyleID;
var name StyleTag;
var() const localized string StyleName;
var const string StyleGroupName;
var const class<UIStyle_Data> StyleDataClass;
var const native transient map<int, int> StateDataMap;

final event UIStyle_Data GetDefaultStyle()
{
    return GetStyleForStateByClass(class'UIState_Enabled');
}

native final function UIStyle_Data GetStyleForStateByClass(class<UIState> StateClass)
{
    StateClass;
}

native final function UIStyle_Data GetStyleForState(UIState StateObject)
{
    StateObject;
}

defaultproperties
{
    StyleName="Default Style"
}

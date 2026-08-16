class UIStyle_Data extends UIRoot
    abstract
    native
    notplaceable
    hidecategories(Object,UIRoot);

var const editoronly string UIEditorControlClass;
var LinearColor StyleColor;
var float StylePadding[2];
var bool bEnabled;
var transient bool bDirty;
var delegate<MatchesStyleData> __MatchesStyleData__Delegate;

delegate bool MatchesStyleData(const UIStyle_Data OtherStyle)
{
}

defaultproperties
{
    StyleColor=(R=1.0,G=1.0,B=1.0,A=1.0)
}

class UISkin extends UIDataStore
    native
    notplaceable
    hidecategories(Object,UIRoot);

struct native UISoundCue
{
    var name SoundName;
    var SoundCue SoundToPlay;
};

var const export editinline array<UIStyle> Styles;
var const array<string> StyleGroups;
var const array<UISoundCue> SoundCues;
var const native transient map<int, int> StyleLookupTable;
var const native transient map<int, int> StyleNameMap;
var const transient array<string> StyleGroupMap;
var const native duplicatetransient map<int, int> CursorMap;
var const native transient map<int, int> SoundCueMap;

event SubscriberDetached(UIDataStoreSubscriber Subscriber)
{
}

event SubscriberAttached(UIDataStoreSubscriber Subscriber)
{
}

native final function GetStyleGroups(out array<string> StyleGroupArray, optional bool bIncludeInheritedGroups = true)
{
    StyleGroupArray;
    bIncludeInheritedGroups;
}

native final function int FindStyleGroupIndex(string StyleGroupName)
{
    StyleGroupName;
}

native final function bool RenameStyleGroup(string OldStyleGroupName, string NewStyleGroupName)
{
    OldStyleGroupName;
    NewStyleGroupName;
}

native final function bool RemoveStyleGroupName(string StyleGroupName)
{
    StyleGroupName;
}

native final function bool AddStyleGroupName(string StyleGroupName)
{
    StyleGroupName;
}

native final function bool IsInheritedGroupName(string StyleGroupName)
{
    StyleGroupName;
}

native final function GetSkinSoundCues(out array<UISoundCue> out_SoundCues)
{
    out_SoundCues;
}

native final function bool GetUISoundCue(name SoundCueName, out SoundCue out_UISoundCue)
{
    SoundCueName;
    out_UISoundCue;
}

native final function bool RemoveUISoundCue(name SoundCueName)
{
    SoundCueName;
}

native final function bool AddUISoundCue(name SoundCueName, SoundCue SoundToPlay)
{
    SoundCueName;
    SoundToPlay;
}

native final function UITexture GetCursorResource(name CursorName)
{
    CursorName;
}

native final function GetAvailableStyles(out array<UIStyle> out_Styles, optional bool bIncludeInheritedStyles = true)
{
    out_Styles;
    bIncludeInheritedStyles;
}

defaultproperties
{
    Tag="Styles"
}

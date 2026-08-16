class UIPrefab extends UIObject
    native
    notplaceable
    hidedropdown
    config(UI)
    hidecategories(Object,UIRoot,Object);

struct native transient ArchetypeInstancePair
{
    var transient UIObject WidgetArchetype;
    var transient UIObject WidgetInstance;
    var transient float ArchetypeBounds[4];
    var transient float InstanceBounds[4];
};

var const int PrefabVersion;
var const int InternalPrefabVersion;
var const editoronly Texture2D PrefabPreview;
var const transient int ModificationCounter;
var(Appearance) const UIScreenValue_Extent OriginalWidth;
var(Appearance) const UIScreenValue_Extent OriginalHeight;

defaultproperties
{
    OriginalWidth=(Value=0.0,ScaleType="UIEXTENTEVAL_PercentScene",Orientation="UIORIENT_Horizontal")
    OriginalHeight=(Value=0.0,ScaleType="UIEXTENTEVAL_PercentScene",Orientation="UIORIENT_Vertical")
    EventProvider="Default__UIPrefab.WidgetEventComponent"
}

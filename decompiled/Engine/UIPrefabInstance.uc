class UIPrefabInstance extends UIObject
    native
    notplaceable
    hidedropdown
    config(UI)
    hidecategories(Object,UIRoot,Object);

var const UIPrefab SourcePrefab;
var const int PrefabInstanceVersion;
var const native map<int, int> ArchetypeToInstanceMap;
var const editoronly int PI_PackageVersion;
var const editoronly int PI_LicenseePackageVersion;
var const editoronly int PI_DataOffset;
var const editoronly array<byte> PI_Bytes;
var const editoronly array<Object> PI_CompleteObjects;
var const editoronly array<Object> PI_ReferencedObjects;
var const editoronly array<string> PI_SavedNames;
var const native map<int, int> PI_ObjectMap;

native final function DetachFromSourcePrefab()
{
}

defaultproperties
{
    PI_PackageVersion=-1
    PI_LicenseePackageVersion=-1
    EventProvider="Default__UIPrefabInstance.WidgetEventComponent"
}

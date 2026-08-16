class PrefabInstance extends Actor
    native
    notplaceable
    hidecategories(Navigation);

var const Prefab TemplatePrefab;
var const int TemplateVersion;
var const native map<int, int> ArchetypeToInstanceMap;
var const PrefabSequence SequenceInstance;
var const int PI_PackageVersion;
var const int PI_LicenseePackageVersion;
var const array<byte> PI_Bytes;
var const array<Object> PI_CompleteObjects;
var const array<Object> PI_ReferencedObjects;
var const array<string> PI_SavedNames;
var const native map<int, int> PI_ObjectMap;

defaultproperties
{
    PI_PackageVersion=-1
    PI_LicenseePackageVersion=-1
    Components(0)="Default__PrefabInstance.Sprite"
    CollisionType="COLLIDE_CustomDefault"
}

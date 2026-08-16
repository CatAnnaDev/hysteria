class InterpData extends SequenceVariable
    native
    notplaceable
    hidecategories(Object);

var float InterpLength;
var float PathBuildTime;
var export array<InterpGroup> InterpGroups;
var export InterpCurveEdSetup CurveEdSetup;
var editoronly array<InterpFilter> InterpFilters;
var editoronly InterpFilter SelectedFilter;
var transient editoronly array<InterpFilter> DefaultFilters;
var float EdSectionStart;
var float EdSectionEnd;
var() bool bShouldBakeAndPrune;

defaultproperties
{
    InterpLength=5.0
    DefaultFilters(0)="Default__InterpData.FilterAll"
    DefaultFilters(1)="Default__InterpData.FilterCameras"
    DefaultFilters(2)="Default__InterpData.FilterSkeletalMeshes"
    DefaultFilters(3)="Default__InterpData.FilterEmitters"
    DefaultFilters(4)="Default__InterpData.FilterSounds"
    DefaultFilters(5)="Default__InterpData.FilterEvents"
    EdSectionStart=1.0
    EdSectionEnd=2.0
    ObjName="Matinee Data"
    ObjColor=(B=0,G=128,R=255,A=255)
}

class LevelStreaming extends Object
    abstract
    native
    notplaceable
    editinlinenew;

var() const editconst name PackageName;
var const transient Level LoadedLevel;
var() const Vector Offset;
var const Vector OldOffset;
var const transient bool bIsVisible;
var const transient bool bHasLoadRequestPending;
var const transient bool bHasUnloadRequestPending;
var() const bool bShouldBeVisibleInEditor;
var const bool bBoundingBoxVisible;
var() const bool bLocked;
var() const bool bIsFullyStatic;
var const transient bool bShouldBeLoaded;
var const transient bool bShouldBeVisible;
var transient bool bShouldBlockOnLoad;
var() bool bDrawOnLevelStatusMap;
var const transient bool bIsRequestingUnloadAndRemoval;
var() const Color DrawColor;
var() const editconst array<LevelStreamingVolume> EditorStreamingVolumes;
var() float MinTimeBetweenVolumeUnloadRequests;
var const transient float LastVolumeUnloadRequestTime;
var array<string> Keywords;
var() const editconst LevelGridVolume EditorGridVolume;
var() const editconst int GridPosition[3];

defaultproperties
{
    bShouldBeVisibleInEditor=True
    bDrawOnLevelStatusMap=True
    DrawColor=(B=255,G=255,R=255,A=255)
    MinTimeBetweenVolumeUnloadRequests=2.0
}

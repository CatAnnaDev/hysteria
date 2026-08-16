class SceneCaptureComponent extends ActorComponent
    abstract
    native
    notplaceable
    hidecategories(Object);

enum ESceneCaptureViewMode
{
    SceneCapView_Lit,
    SceneCapView_Unlit,
    SceneCapView_LitNoShadows,
    SceneCapView_Wire,
};

var(Capture) bool bEnabled;
var(Capture) bool bEnablePostProcess;
var(Capture) bool bEnableFog;
var(Capture) bool bUseMainScenePostProcessSettings;
var(Capture) bool bSkipUpdateIfOwnerOccluded;
var const native transient bool bNeedsSceneUpdate;
var(Capture) Color ClearColor;
var(Capture) ESceneCaptureViewMode ViewMode;
var(Capture) int SceneLOD;
var(Capture) const float FrameRate;
var(Capture) PostProcessChain PostProcess;
var(Capture) float MaxUpdateDist;
var(Capture) float MaxStreamingUpdateDist;
var const native transient Pointer CaptureInfo;
var const native transient Pointer ViewState;
var const native transient duplicatetransient array<Pointer> PostProcessProxies;

native final simulated function SetEnabled(bool bEnable)
{
    bEnable;
}

final simulated function bool NeedsUpdate()
{
    return bNeedsSceneUpdate;
}

native final function SetFrameRate(float NewFrameRate)
{
    NewFrameRate;
}

defaultproperties
{
    bEnabled=True
    ClearColor=(B=0,G=0,R=0,A=255)
    ViewMode="SceneCapView_LitNoShadows"
    FrameRate=30.0
}

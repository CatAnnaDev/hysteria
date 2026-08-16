class UISceneClient extends UIRoot
    abstract
    native
    notplaceable
    transient
    hidecategories(Object,UIRoot);

const SCENEFILTER_Any = 0xFFFFFFFF;
const SCENEFILTER_ReceivesFocus = 0x00000020;
const SCENEFILTER_UsesPostProcessing = 0x00000010;
const SCENEFILTER_PrimitiveUsersOnly = 0x00000008;
const SCENEFILTER_PausersOnly = 0x00000004;
const SCENEFILTER_InputProcessorOnly = 0x00000002;
const SCENEFILTER_IncludeTransient = 0x00000001;
const SCENEFILTER_None = 0x00000000;

var const native noexport Pointer VfTable_FExec;
var const native transient Pointer RenderViewport;
var transient UISkin ActiveSkin;
var const transient IntPoint MousePosition;
var const transient UIObject ActiveControl;
var const transient DataStoreClient DataStoreManager;
var transient MaterialInstanceConstant OpacityParameter;
var const transient name OpacityParameterName;
var const transient Matrix CanvasToScreen;
var const transient Matrix InvCanvasToScreen;
var transient PostProcessChain UIScenePostProcess;
var transient bool bEnablePostProcess;

event InitializeSceneClient()
{
}

native final function Matrix GetInverseCanvasToScreen(optional const UIObject Widget)
{
    Widget;
}

native final function Matrix GetCanvasToScreen(optional const UIObject Widget)
{
    Widget;
}

native final function UpdateCanvasToScreen()
{
}

native final function bool ChangeMouseCursor(name CursorName)
{
    CursorName;
}

native final function SetMousePosition(int NewMouseX, int NewMouseY)
{
    NewMouseX;
    NewMouseY;
}

native final function bool CloseSceneAtIndex(int SceneStackIndex, optional bool bCloseChildScenes = true, optional bool bForceCloseImmediately)
{
    SceneStackIndex;
    bCloseChildScenes;
    bForceCloseImmediately;
}

native final function bool CloseScene(UIScene Scene, optional bool bCloseChildScenes = true, optional bool bForceCloseImmediately)
{
    Scene;
    bCloseChildScenes;
    bForceCloseImmediately;
}

native final function bool ReplaceSceneAtIndex(int IndexOfSceneToReplace, UIScene SceneToOpen, optional LocalPlayer SceneOwner, optional out UIScene OpenedScene, optional byte ForcedPriority)
{
    IndexOfSceneToReplace;
    SceneToOpen;
    SceneOwner;
    OpenedScene;
    ForcedPriority;
}

native final function bool ReplaceScene(UIScene SceneInstanceToReplace, UIScene SceneToOpen, optional LocalPlayer SceneOwner, optional out UIScene OpenedScene, optional byte ForcedPriority)
{
    SceneInstanceToReplace;
    SceneToOpen;
    SceneOwner;
    OpenedScene;
    ForcedPriority;
}

native final function bool InsertScene(int DesiredInsertIndex, UIScene Scene, optional LocalPlayer SceneOwner, optional out UIScene OpenedScene, optional out int ActualInsertIndex, optional byte ForcedPriority)
{
    DesiredInsertIndex;
    Scene;
    SceneOwner;
    OpenedScene;
    ActualInsertIndex;
    ForcedPriority;
}

native final function bool OpenScene(UIScene Scene, optional LocalPlayer SceneOwner, optional out UIScene OpenedScene, optional byte ForcedPriority)
{
    Scene;
    SceneOwner;
    OpenedScene;
    ForcedPriority;
}

native final function bool InitializeScene(UIScene Scene, optional LocalPlayer SceneOwner, optional out UIScene InitializedScene)
{
    Scene;
    SceneOwner;
    InitializedScene;
}

native final function bool IsSceneInitialized(UIScene Scene)
{
    Scene;
}

native final function bool IsUIActive(optional int Flags = -1)
{
    Flags;
}

native final function bool ChangeActiveSkin(UISkin NewActiveSkin)
{
    NewActiveSkin;
}

defaultproperties
{
    OpacityParameterName="UI_Opacity"
    bEnablePostProcess=True
}

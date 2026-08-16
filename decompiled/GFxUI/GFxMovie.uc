class GFxMovie extends Object
    native
    notplaceable;

enum GFxAlign
{
    Align_Center,
    Align_TopCenter,
    Align_BottomCenter,
    Align_CenterLeft,
    Align_CenterRight,
    Align_TopLeft,
    Align_TopRight,
    Align_BottomLeft,
    Align_BottomRight,
};

enum GFxScaleMode
{
    GSM_NoScale,
    GSM_ShowAll,
    GSM_ExactFit,
    GSM_NoBorder,
};

enum ASType
{
    AS_Undefined,
    AS_Null,
    AS_Number,
    AS_String,
    AS_Boolean,
};

enum GFxRenderTextureMode
{
    RTM_Opaque,
    RTM_Alpha,
    RTM_AlphaComposite,
};

enum GFxTimingMode
{
    TM_Game,
    TM_Real,
};

struct native ASValue
{
    var() ASType Type;
    var() bool B;
    var() float N;
    var() string S;
};

struct native GFxDataStoreBinding
{
    var() UIDataStoreBinding DataSource;
    var() string VarPath;
    var() string ModelId;
    var() string ControlId;
    var() bool bEditable;
    var() array<name> CellTags;
    var const transient array<byte> ModelIdUtf8;
    var const transient array<byte> ControlIdUtf8;
    var const transient UIListElementProvider ListDataProvider;
    var const transient array<name> FullCellTags;
    var const native transient Pointer ModelRef;
    var const native transient Pointer ControlRef;
};

struct native ExternalTexture
{
    var() string Resource;
    var() Texture Texture;
};

var() GFxMovieInfo MovieInfo;
var() TextureRenderTarget2D RenderTexture;
var transient PlayerController PlayerOwner;
var const native transient Pointer pMovie;
var const native transient Pointer pCaptureKeys;
var const native transient Pointer pFocusIgnoreKeys;
var() GFxFSCmdHandler FSCmdHandler;
var() Object ExternalInterface;
var() array<name> CaptureKeys;
var() array<name> FocusIgnoreKeys;
var() ESceneDepthPriorityGroup SceneDPG;
var() GFxTimingMode TimingMode;
var() GFxRenderTextureMode RenderTextureMode;
var() bool bDisplayWithHudOff;
var() bool bGammaCorrection;
var const native transient map<int, int> ASUClasses;
var const native transient map<int, int> ASUObjects;
var const transient int NextASUObject;
var() array<ExternalTexture> ExternalTextures;
var() array<GFxDataStoreBinding> DataStoreBindings;
var transient GFxDataStoreSubscriber DataStoreSubscriber;
var delegate<HandleInputKey> __HandleInputKey__Delegate;

native protected final function ActionScriptSetFunction(GFxValue Obj, string member)
{
    Obj;
    member;
}

native protected final function GFxValue ActionScriptObject(string Path)
{
    Path;
}

native protected final function string ActionScriptString(string Path)
{
    Path;
}

native protected final function float ActionScriptFloat(string Path)
{
    Path;
}

native protected final function int ActionScriptInt(string Path)
{
    Path;
}

native protected final function ActionScriptVoid(string Path)
{
    Path;
}

event UserTick()
{
}

function SetExternalInterface(Object H)
{
    ExternalInterface = H;
}

function SetFsCmdHandler(GFxFSCmdHandler H)
{
    FSCmdHandler = H;
}

native function SetVariableObject(string Path, GFxValue Value)
{
    Path;
    Value;
}

native function GFxValue GetVariableObject(string Path, optional class<GFxValue> Type)
{
    Path;
    Type;
}

native function GFxValue CreateArray()
{
}

native function GFxValue CreateObject(string ASClass, optional class<GFxValue> Type)
{
    ASClass;
    Type;
}

native function bool SetVariableStringArray(string Path, int Index, array<string> Arg)
{
    Path;
    Index;
    Arg;
}

native function bool SetVariableFloatArray(string Path, int Index, array<float> Arg)
{
    Path;
    Index;
    Arg;
}

native function bool SetVariableIntArray(string Path, int Index, array<int> Arg)
{
    Path;
    Index;
    Arg;
}

native function bool SetVariableArray(string Path, int Index, array<ASValue> Arg)
{
    Path;
    Index;
    Arg;
}

native function bool GetVariableStringArray(string Path, int Index, out array<string> Arg)
{
    Path;
    Index;
    Arg;
}

native function bool GetVariableFloatArray(string Path, int Index, out array<float> Arg)
{
    Path;
    Index;
    Arg;
}

native function bool GetVariableIntArray(string Path, int Index, out array<int> Arg)
{
    Path;
    Index;
    Arg;
}

native function bool GetVariableArray(string Path, int Index, out array<ASValue> Arg)
{
    Path;
    Index;
    Arg;
}

native function SetVariableString(string Path, string S)
{
    Path;
    S;
}

native function SetVariableNumber(string Path, float F)
{
    Path;
    F;
}

native function SetVariableBool(string Path, bool B)
{
    Path;
    B;
}

native function SetVariable(string Path, ASValue Arg)
{
    Path;
    Arg;
}

native function string GetVariableString(string Path)
{
    Path;
}

native function float GetVariableNumber(string Path)
{
    Path;
}

native function bool GetVariableBool(string Path)
{
    Path;
}

native function ASValue GetVariable(string Path)
{
    Path;
}

native function PublishDataStoreValues()
{
}

native function RefreshDataStoreBindings()
{
}

native function ASValue Invoke(string method, array<ASValue> args)
{
    method;
    args;
}

native function SetTimingMode(GFxTimingMode Mode)
{
    Mode;
}

native function Pause(optional bool pauseplay = true)
{
    pauseplay;
}

native final function Advance(float Time)
{
    Time;
}

native function bool SetExternalTexture(string Resource, Texture Texture)
{
    Resource;
    Texture;
}

native final function FlushPlayerInput(bool capturekeysonly)
{
    capturekeysonly;
}

native final function ClearFocusIgnoreKeys()
{
}

native final function AddFocusIgnoreKey(name Key)
{
    Key;
}

native final function ClearCaptureKeys()
{
}

native final function AddCaptureKey(name Key)
{
    Key;
}

native final function SetFocus(bool captureInput, optional bool Focus = true)
{
    captureInput;
    Focus;
}

native final function SetSceneDPG(ESceneDepthPriorityGroup NewDPG)
{
    NewDPG;
}

native final function SetPerspective3D(out const Matrix matPersp)
{
    matPersp;
}

native final function SetView3D(out const Matrix matView)
{
    matView;
}

native final function GetVisibleFrameRect(out float x0, out float y0, out float X1, out float Y1)
{
    x0;
    y0;
    X1;
    Y1;
}

native final function SetAlignment(GFxAlign A)
{
    A;
}

native final function SetViewScaleMode(GFxScaleMode sm)
{
    sm;
}

native final function SetViewport(int X, int Y, int Width, int Height)
{
    X;
    Y;
    Width;
    Height;
}

native final function GameViewportClient GetGameViewportClient()
{
}

function SetMovieInfo(GFxMovieInfo Data)
{
    MovieInfo = Data;
}

event OnClose()
{
}

native final function Close(optional bool Unload = true)
{
    Unload;
}

native event bool Start(optional bool StartPaused = false)
{
    StartPaused;
}

delegate bool HandleInputKey(int ControllerId, name Key, EInputEvent EventType, float AmountDepressed, optional bool bGamepad)
{
}

defaultproperties
{
    SceneDPG="SDPG_PostProcess"
    bGammaCorrection=True
}

class DebugCameraController extends PlayerController
    native
    notplaceable
    config(Input)
    hidecategories(Navigation);

var globalconfig name PrimaryKey;
var globalconfig name SecondaryKey;
var globalconfig name UnselectKey;
var globalconfig bool bShowSelectedInfo;
var bool bIsFrozenRendering;
var PlayerController OryginalControllerRef;
var Player OryginalPlayer;
var export editinline DrawFrustumComponent DrawFrustum;
var Actor SelectedActor;
var export editinline PrimitiveComponent SelectedComponent;

native function string ConsoleCommand(string Command, optional bool bWriteToLog = true)
{
    Command;
    bWriteToLog;
}

exec function ShowDebugSelectedInfo()
{
    bShowSelectedInfo = !bShowSelectedInfo;
}

function bool NativeInputKey(int ControllerId, name Key, EInputEvent Event, optional float AmountDepressed = 1.0, optional bool bGamepad = false)
{
    local Vector CamLoc, ZeroVec;
    local Rotator CamRot;
    local TraceHitInfo HitInfo;
    local Actor HitActor;
    local Vector HitLoc, HitNormal;
    
    CamLoc = PlayerCamera.CameraCache.POV.Location;
    CamRot = PlayerCamera.CameraCache.POV.Rotation;
    if (Event == 0)
    {
        if (Key == UnselectKey)
        {
            Unselect();
            SelectedActor = none;
            SelectedComponent = none;
            return true;
        }
        if (Key == PrimaryKey)
        {
            HitActor = Trace(HitLoc, HitNormal, vector(CamRot) * float(5000) * float(20) + CamLoc, CamLoc, true, ZeroVec, HitInfo);
            if (HitActor != none)
            {
                SelectedActor = HitActor;
                SelectedComponent = HitInfo.HitComponent;
                PrimarySelect(HitLoc, HitNormal, HitInfo);
            }
            return true;
        }
        if (Key == SecondaryKey)
        {
            HitActor = Trace(HitLoc, HitNormal, vector(CamRot) * float(5000) * float(20) + CamLoc, CamLoc, true, ZeroVec, HitInfo);
            if (HitActor != none)
            {
                SelectedActor = HitActor;
                SelectedComponent = HitInfo.HitComponent;
                SecondarySelect(HitLoc, HitNormal, HitInfo);
            }
            return true;
        }
    }
    return false;
}

function DisableDebugCamera()
{
    if (OryginalControllerRef != none)
    {
        if (bIsFrozenRendering == true)
        {
            ConsoleCommand("FreezeRendering");
            bIsFrozenRendering = false;
        }
        if (OryginalPlayer != none)
        {
            OnDeactivate(OryginalControllerRef);
            OryginalPlayer.SwitchController(OryginalControllerRef);
            OryginalControllerRef = none;
        }
    }
}

exec function NormalSpeed()
{
    bRun = 0;
}

exec function MoreSpeed()
{
    bRun = 2;
}

exec function SetFreezeRendering()
{
    ConsoleCommand("FreezeRendering");
    bIsFrozenRendering = !bIsFrozenRendering;
}

function OnDeactivate(PlayerController PC)
{
    DrawFrustum.SetHidden(true);
    ConsoleCommand("show camfrustums");
    PC.PlayerCamera.DetachComponent(DrawFrustum);
    PC.SetHidden(true);
    PC.PlayerCamera.SetHidden(true);
}

function OnActivate(PlayerController PC)
{
    if (DrawFrustum == none)
    {
        DrawFrustum = new(PC.PlayerCamera) class'DrawFrustumComponent';
    }
    DrawFrustum.SetHidden(false);
    PC.SetHidden(false);
    PC.PlayerCamera.SetHidden(false);
    DrawFrustum.FrustumAngle = PC.PlayerCamera.CameraCache.POV.FOV;
    DrawFrustum.SetAbsolute(true, true, false);
    DrawFrustum.SetTranslation(PC.PlayerCamera.CameraCache.POV.Location);
    DrawFrustum.SetRotation(PC.PlayerCamera.CameraCache.POV.Rotation);
    PC.PlayerCamera.AttachComponent(DrawFrustum);
    ConsoleCommand("show camfrustums");
}

simulated event PostBeginPlay()
{
    PostBeginPlay();
    if (myHUD != none)
    {
        myHUD.Destroy();
    }
    myHUD = Spawn(class'DebugCameraHUD', self);
}

native function Unselect()
{
}

native function SecondarySelect(Vector HitLoc, Vector HitNormal, TraceHitInfo HitInfo)
{
    HitLoc;
    HitNormal;
    HitInfo;
}

native function PrimarySelect(Vector HitLoc, Vector HitNormal, TraceHitInfo HitInfo)
{
    HitLoc;
    HitNormal;
    HitInfo;
}

auto state PlayerWaiting
{
    function PlayerMove(float DeltaTime)
    {
        local float UndilatedDeltaTime;
        
        UndilatedDeltaTime = DeltaTime / WorldInfo.TimeDilation;
        PlayerMove(UndilatedDeltaTime);
        if (WorldInfo.Pauser != none)
        {
            PlayerCamera.UpdateCamera(DeltaTime);
        }
    }
    
    Stop;
}

defaultproperties
{
    PrimaryKey="LeftMouseButton"
    SecondaryKey="RightMouseButton"
    UnselectKey="Escape"
    bShowSelectedInfo=True
    InputClass="DebugCameraInput"
    CylinderComponent="Default__DebugCameraController.CollisionCylinder"
    bHidden=False
    bAlwaysTick=True
    bHiddenEd=False
    Components(0)="Default__DebugCameraController.CollisionCylinder"
    CollisionComponent="Default__DebugCameraController.CollisionCylinder"
}

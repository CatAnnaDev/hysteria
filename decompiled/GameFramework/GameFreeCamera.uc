class GameFreeCamera extends GameCameraBase
    notplaceable
    config(Camera);

var() const float DefaultFOV;
var float MoveSpeed;
var float RotSpeed;
var float ForwardSpeedFactor;
var float RightwardSpeedFactor;
var Vector Forward;
var Vector Rightward;
var Vector Upward;
var float ForwardSign;
var float RightwardSign;
var float UpwardSign;
var Rotator RotSign;
var float PitchFactor;
var float YawFactor;
var float RollFactor;
var Rotator InputRotator;
var int ControllerIndex;
var bool bSpeedUp;
var bool bSpeedDown;

simulated function Rotator LimitViewRotation(Rotator ViewRotation, float ViewPitchMin, float ViewPitchMax)
{
    ViewRotation.Pitch = ViewRotation.Pitch & 65535;
    if (float(ViewRotation.Pitch) > ViewPitchMax && float(ViewRotation.Pitch) < float(65535) + ViewPitchMin)
    {
        if (ViewRotation.Pitch < 32768)
        {
            ViewRotation.Pitch = int(ViewPitchMax);
        }
        else
        {
            ViewRotation.Pitch = int(float(65535) + ViewPitchMin);
        }
    }
    return ViewRotation;
}

simulated function ClearMoveFlags()
{
    ForwardSign = 0.0;
    RightwardSign = 0.0;
    UpwardSign = 0.0;
    RotSign = rot(0, 0, 0);
    YawFactor = 0.0;
    PitchFactor = 0.0;
    RollFactor = 0.0;
}

simulated function ProcessInputInfo(float DeltaTime, out TViewTarget OutVT)
{
    local Vector DeltaLoc, CamForward, CamRightward, CamUpward;
    
    DeltaLoc = vect(0.0, 0.0, 0.0);
    InputRotator.Yaw += int(YawFactor * RotSpeed * DeltaTime);
    InputRotator.Pitch += int(PitchFactor * RotSpeed * DeltaTime);
    InputRotator.Roll += int(RollFactor * RotSpeed * DeltaTime);
    InputRotator = LimitViewRotation(InputRotator, -16161.0, 16383.0);
    CamForward = TransformVectorByRotation(InputRotator, Forward);
    CamRightward = TransformVectorByRotation(InputRotator, Rightward);
    CamUpward = TransformVectorByRotation(InputRotator, Upward);
    DeltaLoc += ForwardSign * CamForward * MoveSpeed * ForwardSpeedFactor * DeltaTime;
    DeltaLoc += RightwardSign * CamRightward * MoveSpeed * RightwardSpeedFactor * DeltaTime;
    DeltaLoc += UpwardSign * CamUpward * MoveSpeed * DeltaTime;
    OutVT.POV.Location += DeltaLoc;
    OutVT.POV.Rotation = InputRotator;
    ClearMoveFlags();
}

simulated function GetInputInfo()
{
    local PlayerInput InputInfo;
    local float RawJoyUp, RawJoyRight, RawJoyLookRight, RawJoyLookUp;
    
    InputInfo = PlayerInput(PlayerCamera.PCOwner.Interactions[ControllerIndex]);
    if (InputInfo != none)
    {
        RawJoyUp = InputInfo.RawJoyUp;
        RawJoyRight = InputInfo.RawJoyRight;
        RawJoyLookRight = InputInfo.RawJoyLookRight;
        RawJoyLookUp = InputInfo.RawJoyLookUp;
        ForwardSign = GetSign(RawJoyUp);
        RightwardSign = GetSign(RawJoyRight);
        ForwardSpeedFactor = Abs(GetDeflection(RawJoyUp, 0.05)) ** float(2);
        RightwardSpeedFactor = Abs(GetDeflection(RawJoyRight, 0.05)) ** float(2);
        if (ControllerIndex != 0)
        {
            UpwardSign = (IsKeyPressed(InputInfo, 'XboxTypeS_Y') ? 1.0 : IsKeyPressed(InputInfo, 'XboxTypeS_A') ? -1.0 : 0.0);
        }
        YawFactor = GetDeflection(RawJoyLookRight, 0.05);
        PitchFactor = -GetDeflection(RawJoyLookUp, 0.05);
        if (IsKeyPressed(InputInfo, 'XboxTypeS_LeftTrigger'))
        {
            RollFactor = -1.0;
        }
        else if (IsKeyPressed(InputInfo, 'XboxTypeS_RightTrigger'))
        {
            RollFactor = 1.0;
        }
        else
        {
            RollFactor = 0.0;
        }
        if (IsKeyPressed(InputInfo, 'XboxTypeS_LeftShoulder'))
        {
            if (!bSpeedDown)
            {
                MoveSpeed *= 0.5;
                RotSpeed *= 0.5;
            }
            bSpeedDown = true;
        }
        else
        {
            bSpeedDown = false;
        }
        if (IsKeyPressed(InputInfo, 'XboxTypeS_RightShoulder'))
        {
            if (!bSpeedUp)
            {
                MoveSpeed *= 2.0;
                RotSpeed *= 2.0;
            }
            bSpeedUp = true;
        }
        else
        {
            bSpeedUp = false;
        }
    }
}

function bool IsKeyPressed(PlayerInput InputInfo, name KeyName)
{
    local int I;
    
    for (I = 0; I < InputInfo.PressedKeys.Length; I++)
    {
        if (InputInfo.PressedKeys[I] == KeyName)
        {
            return true;
        }
    }
    return false;
}

simulated function float GetDeflection(float F, optional float Epsilon = 0.0)
{
    local float R, abs_f;
    
    abs_f = Abs(F);
    if (abs_f <= Epsilon)
    {
        R = 0.0;
    }
    else if (abs_f >= 1.0 - Epsilon)
    {
        R = abs_f / F;
    }
    else
    {
        R = abs_f / F * (abs_f - Epsilon) / (1.0 - 2.0 * Epsilon);
    }
    return R;
}

simulated function float GetSign(float F, optional float Epsilon = 0.0)
{
    local float R;
    
    R = (Abs(F) <= Epsilon ? 0.0 : F > 0.0 ? 1.0 : -1.0);
    return R;
}

function ProcessViewRotation(float DeltaTime, Actor ViewTarget, out Rotator out_ViewRotation, out Rotator out_DeltaRot)
{
}

function OnBecomeActive(GameCameraBase OldCamera)
{
    bResetCameraInterpolation = true;
    ClearMoveFlags();
    InputRotator = OldCamera.PlayerCamera.CameraCache.POV.Rotation;
    OnBecomeActive(OldCamera);
}

function UpdateCamera(Pawn P, GamePlayerCamera CameraActor, float DeltaTime, out TViewTarget OutVT)
{
    OutVT.POV.FOV = DefaultFOV;
    GetInputInfo();
    ProcessInputInfo(DeltaTime, OutVT);
    if (P != none)
    {
        P.CalcCamera(DeltaTime, OutVT.POV.Location, OutVT.POV.Rotation, OutVT.POV.FOV);
    }
    bResetCameraInterpolation = false;
}

defaultproperties
{
    DefaultFOV=80.0
    MoveSpeed=300.0
    RotSpeed=5461.0
    Forward=(X=1.0,Y=0.0,Z=0.0)
    Rightward=(X=0.0,Y=1.0,Z=0.0)
    Upward=(X=0.0,Y=0.0,Z=1.0)
}

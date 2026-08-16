class AliceCamMod_Targeting extends CameraModifier
    notplaceable;

var const float MinAngleDiffToRot;
var const float MaxAngleDiffToRot;
var float OldLockOnRotSpeed;

function float GetAliceViewDeltaRoll(AlicePawn MyAlicePawn, Rotator ViewRotation)
{
    return float(NormalizeRotAxis(MyAlicePawn.Rotation.Roll + MyAlicePawn.AliceCameraOrientation.Roll - ViewRotation.Roll));
}

function float GetAliceViewDeltaPitch(AlicePawn MyAlicePawn, Rotator ViewRotation)
{
    return float(NormalizeRotAxis(MyAlicePawn.Rotation.Pitch + MyAlicePawn.AliceCameraOrientation.Pitch - ViewRotation.Pitch));
}

function BlendCameraRotation(int DeltaAngle, float ElapsedTime, float BlendTime, out int out_DeltaRot)
{
    out_DeltaRot = int(Lerp(0.0, float(DeltaAngle), ElapsedTime / BlendTime));
}

simulated function ImplementAliceStickToCamera(AlicePlayerController APC, AlicePawn MyAlicePawn, float DeltaTime, out Rotator ViewRotation, out Rotator out_DeltaRot, optional bool bPitch = true)
{
    local int DeltaAngle;
    local Rotator RevolSpeed;
    
    out_DeltaRot = rot(0, 0, 0);
    DeltaAngle = int(GetAliceViewDeltaYaw(MyAlicePawn, ViewRotation));
    if (MyAlicePawn.bCamRevolBlending)
    {
        if (MyAlicePawn.CameraBlendTime > 0.0)
        {
            MyAlicePawn.CameraElapsedBlendTime += DeltaTime;
            if (MyAlicePawn.CameraElapsedBlendTime >= MyAlicePawn.CameraBlendTime)
            {
                MyAlicePawn.CameraElapsedBlendTime = MyAlicePawn.CameraBlendTime;
                MyAlicePawn.bCamRevolBlending = false;
            }
            BlendCameraRotation(DeltaAngle, MyAlicePawn.CameraElapsedBlendTime, MyAlicePawn.CameraBlendTime, out_DeltaRot.Yaw);
            if (bPitch)
            {
                DeltaAngle = int(GetAliceViewDeltaPitch(MyAlicePawn, ViewRotation));
                BlendCameraRotation(DeltaAngle, MyAlicePawn.CameraElapsedBlendTime, MyAlicePawn.CameraBlendTime, out_DeltaRot.Pitch);
            }
            DeltaAngle = int(GetAliceViewDeltaRoll(MyAlicePawn, ViewRotation));
            BlendCameraRotation(DeltaAngle, MyAlicePawn.CameraElapsedBlendTime, MyAlicePawn.CameraBlendTime, out_DeltaRot.Roll);
            MyAlicePawn.BlendToTargetCameraDistance(MyAlicePawn.CameraElapsedBlendTime / MyAlicePawn.CameraBlendTime);
            APC.bSetViewTargetLocImmediately = true;
        }
        else
        {
            RevolSpeed = MyAlicePawn.CamInitRevolutionSpeed;
            InterpolateCameraRotation(DeltaAngle, DeltaTime, RevolSpeed.Yaw, out_DeltaRot.Yaw);
            if (bPitch)
            {
                DeltaAngle = int(GetAliceViewDeltaPitch(MyAlicePawn, ViewRotation));
                InterpolateCameraRotation(DeltaAngle, DeltaTime, RevolSpeed.Pitch, out_DeltaRot.Pitch);
            }
            DeltaAngle = int(GetAliceViewDeltaRoll(MyAlicePawn, ViewRotation));
            InterpolateCameraRotation(DeltaAngle, DeltaTime, RevolSpeed.Roll, out_DeltaRot.Roll);
        }
    }
    else
    {
        MyAlicePawn.bCamRevolBlending = false;
        ViewRotation = MyAlicePawn.Rotation + MyAlicePawn.AliceCameraOrientation;
    }
    MyAlicePawn.CamRevolutionDelay = 0.0;
    APC.bSetViewTargetRotImmediately = true;
}

function float GetDeltaYaw(Rotator TargetRotation, Rotator ViewRotation)
{
    local int DeltaAngle;
    local Vector TarDir, CamDir;
    local Rotator TarRot, CamRot;
    
    TarRot = TargetRotation;
    TarRot.Pitch = 0;
    TarRot.Roll = 0;
    CamRot = ViewRotation;
    CamRot.Pitch = 0;
    CamRot.Roll = 0;
    TarDir = vector(TarRot);
    CamDir = vector(CamRot);
    DeltaAngle = int(AlicePlayerController(CameraOwner.PCOwner).CalcAngleBetweenVectors(CamDir, TarDir) / 3.1415927 * float(32767));
    return float(DeltaAngle);
}

function InterpolateCameraRotation(int DeltaAngle, float DeltaTime, int Speed, out int out_DeltaRot)
{
    AlicePlayerCamera(CameraOwner).InterpolateRotation(DeltaAngle, DeltaTime, Speed, out_DeltaRot);
}

function float GetAliceViewDeltaYaw(AlicePawn MyAlicePawn, Rotator ViewRotation)
{
    return GetDeltaYaw(MyAlicePawn.Rotation + MyAlicePawn.AliceCameraOrientation, ViewRotation);
}

simulated function ImplementAliceLockOnCamera(AlicePlayerController APC, AlicePawn MyAlicePawn, float DeltaTime, out Rotator out_ViewRotation, out Rotator out_DeltaRot)
{
    local int DeltaAngle, DeltaOffset, AngleOffset, YawOffset;
    local float RotSpeed, MaxYawDeclination, DistAliceToNPC, FOVScale;
    local Vector TargetDir, TargetLoc;
    local Rotator TargetRot;
    local bool bInterpolate, bEnableYawOffset;
    local AlicePlayerCamera AliceCamera;
    
    out_DeltaRot = rot(0, 0, 0);
    DeltaAngle = int(GetAliceViewDeltaYaw(MyAlicePawn, out_ViewRotation));
    MaxYawDeclination = 0.5 * APC.PlayerCamera.CameraCache.POV.FOV * MyAlicePawn.MaxLockOnYawDeclination;
    MaxYawDeclination *= 0.017453292 * 10430.378;
    if (APC.IsLockOnNPC() || APC.IsLockOnBActor() || MyAlicePawn.bCombatToStrafeCamWait)
    {
        MyAlicePawn.CheckSwitchTargetDelay(DeltaTime);
        if (!MyAlicePawn.bCombatToStrafeCamWait && !MyAlicePawn.bSwitchTargetDelay && !APC.IsLockOnDeadNPC())
        {
            TargetLoc = (APC.IsLockOnNPC() ? APC.TargetNPCSocket.Pawn.GetCameraTargetSocketLoc(APC.TargetNPCSocket.SocketIndex) : APC.TargetBActorInfo.vLocation);
        }
        else
        {
            TargetLoc = MyAlicePawn.OldLockOnTargetLoc;
        }
        TargetDir = TargetLoc - APC.PlayerCamera.CameraCache.POV.Location;
        TargetRot = rotator(TargetDir);
        DeltaAngle = NormalizeRotAxis(TargetRot.Yaw - out_ViewRotation.Yaw);
        FOVScale = Tan(0.5 * MyAlicePawn.BorderFOV * 0.017453292) / Tan(0.5 * APC.PlayerCamera.CameraCache.POV.FOV * 0.017453292);
        AliceCamera = AlicePlayerCamera(APC.PlayerCamera);
        bEnableYawOffset = WeaponForAliceRange(MyAlicePawn.Weapon) == none;
        bInterpolate = false;
        if ((!AliceCamera.CanSeeEx(MyAlicePawn.Location + MyAlicePawn.LockOnSocketOffset, FOVScale, false) || !AliceCamera.CanSeeEx(TargetLoc, FOVScale, false)) && !MyAlicePawn.bCamRevolBlending)
        {
            RotSpeed = MyAlicePawn.OutOfFrameRotSpeed * 0.017453292 * 10430.378;
            bInterpolate = true;
        }
        else if (Abs(float(DeltaAngle)) < MaxYawDeclination)
        {
            RotSpeed = float(MyAlicePawn.CamRevolutionSpeed.Yaw);
            bInterpolate = true;
        }
        if (bInterpolate)
        {
            if (!MyAlicePawn.bAliceStartCombatCam)
            {
                RotSpeed = AliceCamera.CameraFloatInertiaFunction(OldLockOnRotSpeed, RotSpeed, MyAlicePawn.ReadjustBlendSpeed, DeltaTime);
            }
            InterpolateCameraRotation(DeltaAngle, DeltaTime, int(RotSpeed), out_DeltaRot.Yaw);
            OldLockOnRotSpeed = RotSpeed;
        }
        else
        {
            out_DeltaRot.Yaw = int(DeltaAngle > 0 ? float(DeltaAngle) - MaxYawDeclination : float(DeltaAngle) + MaxYawDeclination);
        }
        if (MyAlicePawn.bYawOffsetRuntime && bEnableYawOffset)
        {
            YawOffset = int(MyAlicePawn.LockOnYawOffset * 0.017453292 * 10430.378);
            DeltaOffset = NormalizeRotAxis(MyAlicePawn.Rotation.Yaw - out_ViewRotation.Yaw);
            if (Abs(float(DeltaOffset)) < float(YawOffset))
            {
                AngleOffset = (DeltaOffset >= 0 ? -YawOffset : YawOffset);
                DeltaOffset = NormalizeRotAxis(MyAlicePawn.Rotation.Yaw + AngleOffset - out_ViewRotation.Yaw);
                if (MyAlicePawn.LockOnElapsedTime > MyAlicePawn.CameraBlendTime)
                {
                    MyAlicePawn.LockOnElapsedTime = MyAlicePawn.CameraBlendTime;
                }
                BlendCameraRotation(DeltaOffset, MyAlicePawn.LockOnElapsedTime, MyAlicePawn.CameraBlendTime, out_DeltaRot.Yaw);
                MyAlicePawn.LockOnElapsedTime += DeltaTime;
            }
            else
            {
                MyAlicePawn.LockOnElapsedTime = 0.0;
            }
        }
        if (!MyAlicePawn.bCombatToStrafeCamWait && !APC.IsLockOnDeadNPC())
        {
            if (APC.IsLockOnNPC())
            {
                DistAliceToNPC = VSize2D(APC.TargetNPCSocket.Pawn.Location - MyAlicePawn.Location);
                MyAlicePawn.AdjustCameraDistInLockOn(APC.TargetNPCSocket.Pawn, DistAliceToNPC);
            }
            else
            {
                DistAliceToNPC = VSize2D(APC.TargetBActorInfo.vLocation - MyAlicePawn.Location);
                MyAlicePawn.AdjustCameraDistInLockOnBActor(APC.TargetBActorInfo.BActor, DistAliceToNPC);
            }
            if (MyAlicePawn.bCamRevolBlending)
            {
                if (MyAlicePawn.CameraBlendTime > 0.0)
                {
                    MyAlicePawn.CameraElapsedBlendTime += DeltaTime;
                    if (MyAlicePawn.CameraElapsedBlendTime >= MyAlicePawn.CameraBlendTime)
                    {
                        MyAlicePawn.CameraElapsedBlendTime = MyAlicePawn.CameraBlendTime;
                        MyAlicePawn.bCamRevolBlending = false;
                    }
                    MyAlicePawn.AliceCameraFOV = MyAlicePawn.CombatCamera.FOV;
                    MyAlicePawn.SaveTargetCameraDistFOVInfo();
                    MyAlicePawn.LoadCurCameraDistFOVInfo();
                    MyAlicePawn.BlendToTargetCameraDistance(MyAlicePawn.CameraElapsedBlendTime / MyAlicePawn.CameraBlendTime);
                    if (!MyAlicePawn.bYawOffsetRuntime && bEnableYawOffset)
                    {
                        YawOffset = int(MyAlicePawn.LockOnYawOffset * 0.017453292 * 10430.378);
                        DeltaOffset = NormalizeRotAxis(MyAlicePawn.Rotation.Yaw - out_ViewRotation.Yaw);
                        if (Abs(float(DeltaOffset)) < float(YawOffset))
                        {
                            AngleOffset = (DeltaOffset >= 0 ? -YawOffset : YawOffset);
                            DeltaOffset = NormalizeRotAxis(MyAlicePawn.Rotation.Yaw + AngleOffset - out_ViewRotation.Yaw);
                            BlendCameraRotation(DeltaOffset, MyAlicePawn.CameraElapsedBlendTime, MyAlicePawn.CameraBlendTime, out_DeltaRot.Yaw);
                        }
                    }
                }
            }
        }
    }
    else
    {
        RotSpeed = float(MyAlicePawn.CamRevolutionSpeed.Yaw);
        InterpolateCameraRotation(DeltaAngle, DeltaTime, int(RotSpeed), out_DeltaRot.Yaw);
    }
    if (MyAlicePawn.bCamRevolBlending)
    {
        if (MyAlicePawn.CameraBlendTime > 0.0)
        {
            MyAlicePawn.CameraElapsedBlendTime += DeltaTime;
            if (MyAlicePawn.CameraElapsedBlendTime >= MyAlicePawn.CameraBlendTime)
            {
                MyAlicePawn.CameraElapsedBlendTime = MyAlicePawn.CameraBlendTime;
                MyAlicePawn.bCamRevolBlending = false;
            }
            DeltaAngle = int(GetAliceViewDeltaPitch(MyAlicePawn, out_ViewRotation));
            BlendCameraRotation(DeltaAngle, MyAlicePawn.CameraElapsedBlendTime, MyAlicePawn.CameraBlendTime, out_DeltaRot.Pitch);
            DeltaAngle = int(GetAliceViewDeltaRoll(MyAlicePawn, out_ViewRotation));
            BlendCameraRotation(DeltaAngle, MyAlicePawn.CameraElapsedBlendTime, MyAlicePawn.CameraBlendTime, out_DeltaRot.Roll);
        }
        else
        {
            out_ViewRotation.Pitch = MyAlicePawn.AliceCameraOrientation.Pitch;
            out_ViewRotation.Roll = MyAlicePawn.AliceCameraOrientation.Roll;
        }
    }
    if (APC.IsLockOnBActor() || APC.IsLockOnNPC())
    {
    }
}

simulated function bool ProcessViewRotation(Actor ViewTarget, float DeltaTime, out Rotator out_ViewRotation, out Rotator out_DeltaRot)
{
    local AlicePlayerInput PlayerInput;
    local AlicePlayerController APC;
    
    PlayerInput = AlicePlayerInput(CameraOwner.PCOwner.PlayerInput);
    APC = AlicePlayerController(CameraOwner.PCOwner);
    APC.MyAlicePawn.CamDistScale = APC.MyAlicePawn.default.CamDistScale;
    if (ViewTarget != none && PlayerInput != none && APC.bTargetingModeActive)
    {
        if (APC.IsLockOnNPC() || APC.IsLockOnBActor() || APC.MyAlicePawn.bCombatToStrafeCamWait)
        {
            ImplementAliceLockOnCamera(APC, APC.MyAlicePawn, DeltaTime, out_ViewRotation, out_DeltaRot);
        }
        else
        {
            ImplementAliceStickToCamera(APC, APC.MyAlicePawn, DeltaTime, out_ViewRotation, out_DeltaRot);
        }
    }
    return false;
}

function DEBUG_ShowLockOnTarget(AlicePlayerController APC)
{
    local Vector TargetLoc;
    
    if (!APC.MyAlicePawn.bCombatToStrafeCamWait && !APC.MyAlicePawn.bSwitchTargetDelay && !APC.IsLockOnDeadNPC())
    {
        TargetLoc = (APC.IsLockOnNPC() ? APC.TargetNPCSocket.Pawn.GetCameraTargetSocketLoc(APC.TargetNPCSocket.SocketIndex) : APC.TargetBActorInfo.vLocation);
    }
    else
    {
        TargetLoc = APC.MyAlicePawn.OldLockOnTargetLoc;
    }
    APC.DrawDebugLine(APC.MyAlicePawn.Location + APC.MyAlicePawn.LockOnSocketOffset, TargetLoc, 255, 255, 0);
    LogInternal("SocketIndex = " @ string(APC.TargetNPCSocket.SocketIndex) @ "Pawn = " @ string(APC.TargetNPCSocket.Pawn));
}

function DEBUG_ShowDirections(Actor ViewTarget, Rotator ViewRotation)
{
    local Vector TarDir, CamDir;
    
    TarDir = vector(ViewTarget.Rotation);
    ViewRotation.Pitch = 0;
    CamDir = vector(ViewRotation);
    CameraOwner.PCOwner.DrawDebugLine(CameraOwner.PCOwner.Pawn.Location, CameraOwner.PCOwner.Pawn.Location + CamDir * float(1000), 255, 0, 0);
    CameraOwner.PCOwner.DrawDebugLine(CameraOwner.PCOwner.Pawn.Location, CameraOwner.PCOwner.Pawn.Location + TarDir * float(1000), 0, 255, 0);
    if (ViewTarget != CameraOwner.PCOwner.Pawn)
    {
        TarDir = vector(CameraOwner.PCOwner.Pawn.Rotation);
        CameraOwner.PCOwner.DrawDebugLine(CameraOwner.PCOwner.Pawn.Location, CameraOwner.PCOwner.Pawn.Location + TarDir * float(1000), 255, 255, 0);
    }
}

defaultproperties
{
    MaxAngleDiffToRot=32767.0
}

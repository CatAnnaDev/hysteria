class AliceCamMod_BackOfPlayer extends CameraModifier
    native
    notplaceable;

var bool EnableInterpolation;
var bool bRightStickFree;
var bool bLeftStickFree;
var float FacingTime;
var const float FacingWaitTime;
var float ResetDelayTime;
var const float ResetDelay;
var Rotator OldDeltaRotToPawn;
var Rotator OldViewTargetRotation;
var float AllowedMinDeltaAngle;
var Rotator RotationTarget;
var int OldCamBehavior;
var Rotator OldViewRotation;
var float CamYawSpeed;
var float CamPitchSpeed;

simulated function ImplementAliceSoftResetCamera(AlicePawn MyAlicePawn, float DeltaTime, out Rotator out_ViewRotation, out Rotator out_DeltaRot, float TargetSpeed, bool bRotated)
{
    local int DeltaAngle, DeltaRot, RotSpeed;
    local bool bReseted;
    
    if (!bRightStickFree || MyAlicePawn.bCamRevolBlending)
    {
        MyAlicePawn.bSoftResetCamera = false;
        return;
    }
    bReseted = false;
    if (TargetSpeed < 0.1 && !bRotated)
    {
        RotSpeed = MyAlicePawn.CamRevolutionSpeed.Yaw;
        DeltaAngle = int(GetAliceViewDeltaYaw(MyAlicePawn, out_ViewRotation));
        InterpolateCameraRotation(DeltaAngle, DeltaTime, RotSpeed, DeltaRot);
        out_DeltaRot.Yaw = DeltaRot;
        if (Abs(float(DeltaAngle)) <= float(10))
        {
            bReseted = true;
        }
    }
    else
    {
        bReseted = true;
    }
    if (MyAlicePawn.CamRevolutionSpeed.Pitch == 0)
    {
        RotSpeed = MyAlicePawn.CamRevolutionSpeed.Yaw;
        DeltaAngle = int(GetAliceViewDeltaPitch(MyAlicePawn, out_ViewRotation));
        InterpolateCameraRotation(DeltaAngle, DeltaTime, RotSpeed, DeltaRot);
        out_DeltaRot.Pitch = DeltaRot;
        if (Abs(float(DeltaAngle)) > float(10))
        {
            bReseted = false;
        }
    }
    MyAlicePawn.bSoftResetCamera = !bReseted;
    MyAlicePawn.CamRevolutionDelay = 0.0;
}

simulated function ImplementAliceForceResetCamera(AlicePlayerController APC, AlicePawn MyAlicePawn, float DeltaTime, out Rotator out_ViewRotation, out Rotator out_DeltaRot)
{
    local int DeltaAngle;
    local float Weight;
    
    out_DeltaRot = rot(0, 0, 0);
    DeltaAngle = int(GetAliceViewDeltaYaw(MyAlicePawn, out_ViewRotation));
    if (MyAlicePawn.bForceResetCamera && Abs(float(DeltaAngle)) > float(10))
    {
        if (MyAlicePawn.ForceResetCameraWaitTime > 0.0)
        {
            MyAlicePawn.OldForceResetCameraElapsedTime = MyAlicePawn.ForceResetCameraElapsedTime;
            MyAlicePawn.ForceResetCameraElapsedTime += DeltaTime;
            if (MyAlicePawn.ForceResetCameraElapsedTime > MyAlicePawn.ForceResetCameraWaitTime)
            {
                if (MyAlicePawn.OldForceResetCameraElapsedTime >= MyAlicePawn.ForceResetCameraWaitTime)
                {
                    MyAlicePawn.bForceResetCamera = false;
                }
            }
            if (MyAlicePawn.bForceResetCamera)
            {
                Weight = MyAlicePawn.ForceResetCameraElapsedTime / MyAlicePawn.ForceResetCameraWaitTime;
                if (Weight >= 1.0)
                {
                    Weight = 1.0;
                }
                BlendCameraRotation(DeltaAngle, Weight, out_DeltaRot.Yaw);
                DeltaAngle = int(GetAliceViewDeltaPitch(MyAlicePawn, out_ViewRotation));
                BlendCameraRotation(DeltaAngle, Weight, out_DeltaRot.Pitch);
                MyAlicePawn.CamLocDelay = 0.0;
                MyAlicePawn.CamDistDelay = 0.0;
            }
            else
            {
                MyAlicePawn.CamLocDelay = MyAlicePawn.default.CamLocDelay;
                MyAlicePawn.CamDistDelay = MyAlicePawn.default.CamDistDelay;
                out_ViewRotation = CameraOwner.CameraCache.POV.Rotation;
            }
        }
        else
        {
            out_ViewRotation = MyAlicePawn.Rotation;
            MyAlicePawn.bForceResetCamera = false;
            MyAlicePawn.CamLocDelay = MyAlicePawn.default.CamLocDelay;
            MyAlicePawn.CamDistDelay = MyAlicePawn.default.CamDistDelay;
        }
    }
    else
    {
        MyAlicePawn.bForceResetCamera = false;
        MyAlicePawn.CamLocDelay = MyAlicePawn.default.CamLocDelay;
        MyAlicePawn.CamDistDelay = MyAlicePawn.default.CamDistDelay;
    }
    MyAlicePawn.CamRevolutionDelay = 0.0;
}

simulated function ImplementCameraMagnet(AlicePawn MyAlicePawn, float DeltaTime, out Rotator out_ViewRotation, out Rotator out_DeltaRot, float TargetSpeed)
{
    local int DeltaAngle, DeltaRot;
    local Rotator AliceEyeRot;
    local Vector MagnetDir, AliceEyeLoc;
    local AliceCameraMagnet ACM;
    local float SpeedFactor, YawSpeed, PitchSpeed;
    
    ACM = MyAlicePawn.CurCameraMagnet;
    if (!bRightStickFree)
    {
        if (ACM.bDisableOnLookAway)
        {
            ACM.MaxTriggerCount = -1;
            MyAlicePawn.SetCameraMagnet(none);
        }
        MyAlicePawn.CurCameraMagnetSpeedTime = 0.0;
        MyAlicePawn.CurCameraMagnetRotSpeed = 0;
        MyAlicePawn.CurCameraMagnetEaseOut = -1.0;
        return;
    }
    MyAlicePawn.GetActorEyesViewPoint(AliceEyeLoc, AliceEyeRot);
    MagnetDir = ACM.Location - AliceEyeLoc;
    MagnetDir = Normal(MagnetDir);
    AliceEyeRot = rotator(MagnetDir);
    if (ACM.Magnet2DPos.Z > 0.0 && VSize2D(ACM.Magnet2DPos) < ACM.TargetRadius && TargetSpeed <= 0.0)
    {
        if (MyAlicePawn.CurCameraMagnetEaseOut < 0.0)
        {
            MyAlicePawn.CurCameraMagnetEaseOut = MyAlicePawn.CurCameraMagnetSpeedTime;
        }
        SpeedFactor = (ACM.EaseOut > 0.0 ? 1.0 - (MyAlicePawn.CurCameraMagnetSpeedTime - MyAlicePawn.CurCameraMagnetEaseOut) / ACM.EaseOut : 0.0);
    }
    else
    {
        GetYawPitchSpeed(float(ACM.InterpolateSpeed * 32767 / 180), AliceEyeRot, out_ViewRotation, CamYawSpeed, CamPitchSpeed);
        MyAlicePawn.CurCameraMagnetRotSpeed = ACM.InterpolateSpeed;
        SpeedFactor = (ACM.EaseIn > 0.0 ? MyAlicePawn.CurCameraMagnetSpeedTime / ACM.EaseIn : 1.0);
        MyAlicePawn.CurCameraMagnetEaseOut = -1.0;
    }
    if (SpeedFactor < 1.0)
    {
        YawSpeed = CamYawSpeed * (SpeedFactor < 0.0 ? 0.0 : SpeedFactor);
        PitchSpeed = CamPitchSpeed * (SpeedFactor < 0.0 ? 0.0 : SpeedFactor);
    }
    else
    {
        YawSpeed = CamYawSpeed;
        PitchSpeed = CamPitchSpeed;
    }
    DeltaAngle = NormalizeRotAxis(AliceEyeRot.Yaw - out_ViewRotation.Yaw);
    InterpolateCameraRotation(DeltaAngle, DeltaTime, int(YawSpeed), DeltaRot);
    out_DeltaRot.Yaw = DeltaRot;
    DeltaAngle = NormalizeRotAxis(AliceEyeRot.Pitch - out_ViewRotation.Pitch);
    InterpolateCameraRotation(DeltaAngle, DeltaTime, int(PitchSpeed), DeltaRot);
    out_DeltaRot.Pitch = DeltaRot;
    MyAlicePawn.CamRevolutionDelay = 0.0;
}

simulated function GetYawPitchSpeed(float MainRotSpeed, Rotator TargetRotation, Rotator ViewRotation, out float YawSpeed, out float PitchSpeed)
{
    local float DeltaYaw, DeltaPitch, BigDelta, DeltaTime;
    local bool bBigYaw;
    
    DeltaYaw = Abs(float(NormalizeRotAxis(TargetRotation.Yaw - ViewRotation.Yaw)));
    DeltaPitch = Abs(float(NormalizeRotAxis(TargetRotation.Pitch - ViewRotation.Pitch)));
    bBigYaw = DeltaYaw > DeltaPitch;
    BigDelta = (bBigYaw ? DeltaYaw : DeltaPitch);
    DeltaTime = BigDelta / MainRotSpeed;
    if (bBigYaw)
    {
        YawSpeed = MainRotSpeed;
        PitchSpeed = DeltaPitch / DeltaTime;
    }
    else
    {
        PitchSpeed = MainRotSpeed;
        YawSpeed = DeltaYaw / DeltaTime;
    }
}

simulated function ImplementAliceSprintCamera(AlicePlayerController APC, AlicePawn MyAlicePawn, float DeltaTime, out Rotator out_ViewRotation, out Rotator out_DeltaRot)
{
    local int DeltaAngleYaw, DeltaAnglePitch, DeltaYaw, DeltaPitch;
    local Rotator RevolSpeed;
    
    if (!bRightStickFree)
    {
        MyAlicePawn.bCamRevolBlending = false;
    }
    DeltaAngleYaw = int(GetAliceViewDeltaYaw(MyAlicePawn, out_ViewRotation + out_DeltaRot));
    DeltaAnglePitch = int(GetAliceViewDeltaPitch(MyAlicePawn, out_ViewRotation + out_DeltaRot));
    if (Abs(float(DeltaAngleYaw)) > float(10) || Abs(float(DeltaAnglePitch)) > float(10))
    {
        if (MyAlicePawn.bCamRevolBlending || bRightStickFree || !bRightStickFree && bLeftStickFree && !APC.bCameraReset)
        {
            RevolSpeed = MyAlicePawn.CamInitRevolutionSpeed;
            InterpolateCameraRotation(DeltaAngleYaw, DeltaTime, RevolSpeed.Yaw, out_DeltaRot.Yaw);
            InterpolateCameraRotation(DeltaAnglePitch, DeltaTime, RevolSpeed.Pitch, out_DeltaRot.Pitch);
        }
        else
        {
            RevolSpeed = MyAlicePawn.CamRevolutionSpeed;
            DeltaAngleYaw = NormalizeRotAxis(out_ViewRotation.Yaw + out_DeltaRot.Yaw - OldViewRotation.Yaw);
            InterpolateCameraRotation(DeltaAngleYaw, DeltaTime, RevolSpeed.Yaw, DeltaYaw);
            out_ViewRotation.Yaw = OldViewRotation.Yaw + DeltaYaw;
            out_DeltaRot.Yaw = 0;
            DeltaAnglePitch = NormalizeRotAxis(out_ViewRotation.Pitch + out_DeltaRot.Pitch - OldViewRotation.Pitch);
            InterpolateCameraRotation(DeltaAnglePitch, DeltaTime, RevolSpeed.Pitch, DeltaPitch);
            out_ViewRotation.Pitch = OldViewRotation.Pitch + DeltaPitch;
            out_DeltaRot.Pitch = 0;
        }
    }
    else
    {
        MyAlicePawn.bCamRevolBlending = false;
    }
    if (IsFacingCamera(MyAlicePawn))
    {
        MyAlicePawn.CamDistScale = MyAlicePawn.GetCamDistScaleWhenFacingCam();
    }
    MyAlicePawn.CamRevolutionDelay = 0.0;
}

simulated function ImplementAliceSteamVentCamera(AlicePawn MyAlicePawn, float DeltaTime, out Rotator out_ViewRotation, out Rotator out_DeltaRot, float TargetSpeed, bool bRotated)
{
    local float DeltaAngle;
    local Rotator T_ViewRotation, T_DeltaRot;
    local bool bIsNewHoverControl, bKeepCurRot;
    
    T_ViewRotation = out_ViewRotation;
    T_DeltaRot = out_DeltaRot;
    bKeepCurRot = false;
    bIsNewHoverControl = AlicePlayerController(MyAlicePawn.Controller).IsNewHoverControl();
    if (bRotated || TargetSpeed > 0.0)
    {
        EnableInterpolation = true;
    }
    AlicePlayerController(MyAlicePawn.Controller).bSteamVentRotating = false;
    DeltaAngle = -GetAliceViewDeltaYaw(MyAlicePawn, T_ViewRotation);
    if (TargetSpeed > 0.0 && Abs(DeltaAngle) > float(200) && !bIsNewHoverControl)
    {
        AlicePlayerController(MyAlicePawn.Controller).bSteamVentRotating = true;
        MyAlicePawn.CamRevolutionDelay = 0.0;
        T_ViewRotation.Yaw = MyAlicePawn.Rotation.Yaw;
        T_DeltaRot.Yaw = 0;
    }
    else if ((bRotated || TargetSpeed > 0.0) && bRightStickFree || bIsNewHoverControl)
    {
        T_ViewRotation.Yaw = MyAlicePawn.Rotation.Yaw;
        T_DeltaRot.Yaw = 0;
    }
    else if ((bRightStickFree || bIsNewHoverControl) && EnableInterpolation)
    {
        T_ViewRotation.Yaw = MyAlicePawn.Rotation.Yaw;
        T_DeltaRot.Yaw = 0;
    }
    else
    {
        if (EnableInterpolation && !bRotated)
        {
            EnableInterpolation = false;
        }
        bKeepCurRot = true;
    }
    if (MyAlicePawn.bCamRevolBlending && MyAlicePawn.CameraBlendTime > 0.0 && !bKeepCurRot)
    {
        MyAlicePawn.CameraElapsedBlendTime += DeltaTime;
        if (MyAlicePawn.CameraElapsedBlendTime >= MyAlicePawn.CameraBlendTime)
        {
            MyAlicePawn.CameraElapsedBlendTime = MyAlicePawn.CameraBlendTime;
            MyAlicePawn.bCamRevolBlending = false;
        }
        T_ViewRotation += T_DeltaRot;
        DeltaAngle = GetDeltaYaw(T_ViewRotation, out_ViewRotation);
        BlendCameraRotation(int(DeltaAngle), MyAlicePawn.CameraElapsedBlendTime / MyAlicePawn.CameraBlendTime, T_DeltaRot.Yaw);
        T_ViewRotation = out_ViewRotation;
    }
    out_ViewRotation = T_ViewRotation;
    out_DeltaRot = T_DeltaRot;
}

simulated function ImplementAliceDefaultCamera(AlicePlayerController APC, AlicePawn MyAlicePawn, float DeltaTime, out Rotator out_ViewRotation, out Rotator out_DeltaRot, float TargetSpeed, bool bRotated)
{
    local float DeltaAngle;
    local bool bFaceCam;
    
    if (APC.bCheatFlying)
    {
        return;
    }
    if (TargetSpeed > 0.0)
    {
        EnableInterpolation = true;
    }
    if (Abs(MyAlicePawn.AngleToRotate) > 0.0)
    {
        EnableInterpolation = false;
    }
    if (TargetSpeed > 0.0 && bRightStickFree)
    {
        DeltaAngle = GetAliceViewDeltaYaw(MyAlicePawn, out_ViewRotation);
        bFaceCam = JudgeFacingControl(Abs(DeltaAngle), DeltaTime);
        if (!bFaceCam)
        {
            InterpolateCameraRotation(int(DeltaAngle), DeltaTime, CalcRealBaseRotSpeed(Abs(DeltaAngle), MyAlicePawn.CamRevolutionSpeed.Yaw), out_DeltaRot.Yaw);
        }
        MyAlicePawn.CamRevolutionDelay = 0.0;
        ResetDelayTime = 0.0;
    }
    else if (bRightStickFree && EnableInterpolation)
    {
        DeltaAngle = GetAliceViewDeltaYaw(MyAlicePawn, out_ViewRotation);
        if (ResetDelayTime > ResetDelay)
        {
            InterpolateCameraRotation(int(DeltaAngle), DeltaTime, CalcRealBaseRotSpeed(Abs(DeltaAngle), MyAlicePawn.CamRevolutionSpeed.Yaw), out_DeltaRot.Yaw);
        }
        MyAlicePawn.CamRevolutionDelay = 0.0;
        ResetDelayTime += DeltaTime;
    }
    else if (EnableInterpolation && TargetSpeed < 0.0001)
    {
        EnableInterpolation = false;
    }
    if (TargetSpeed > 0.0)
    {
        if (!bRightStickFree)
        {
            DeltaAngle = GetAliceViewDeltaYaw(MyAlicePawn, out_ViewRotation);
        }
        if (JudgeFacingControl(Abs(DeltaAngle), DeltaTime))
        {
            MyAlicePawn.CamDistScale = MyAlicePawn.GetCamDistScaleWhenFacingCam();
        }
    }
}

simulated function ImplementAliceCamBehaviors(int CurCamBehavior, AlicePlayerController APC, AlicePawn MyAlicePawn, AlicePlayerInput PlayerInput, float DeltaTime, out Rotator out_ViewRotation, out Rotator out_DeltaRot)
{
    local float TargetSpeed;
    local bool bRotated;
    
    TargetSpeed = VSize2D(MyAlicePawn.Velocity);
    bRotated = !bLeftStickFree || !bRightStickFree && APC.IsNewHoverControl();
    MyAlicePawn.CamDistScale = MyAlicePawn.default.CamDistScale;
    if (CurCamBehavior == 4)
    {
        out_ViewRotation = rot(0, 0, 0);
        out_DeltaRot = rot(0, 0, 0);
    }
    else if (MyAlicePawn.bForceResetCamera)
    {
        ImplementAliceForceResetCamera(APC, MyAlicePawn, DeltaTime, out_ViewRotation, out_DeltaRot);
    }
    else if (CurCamBehavior == 1)
    {
        MyAlicePawn.CamRevolutionDelay = 0.0;
        return;
    }
    else
    {
        switch (CurCamBehavior)
        {
            case 3:
                ImplementAliceAutomaicCamera(MyAlicePawn, DeltaTime, out_ViewRotation, out_DeltaRot);
                break;
            case 2:
                ImplementAliceSemiAutomaicCamera(MyAlicePawn, DeltaTime, MyAlicePawn.CamRevolutionSpeed, out_ViewRotation, out_DeltaRot, TargetSpeed, bRotated);
                break;
            case 5:
                ImplementAliceStickToCamera(APC, MyAlicePawn, DeltaTime, out_ViewRotation, out_DeltaRot, false);
                break;
            case 6:
                out_DeltaRot = rot(0, 0, 0);
                break;
            case 6 + 10:
                ImplementCameraMagnet(MyAlicePawn, DeltaTime, out_ViewRotation, out_DeltaRot, TargetSpeed);
                break;
            case 6 + 11:
                ImplementAliceSteamVentCamera(MyAlicePawn, DeltaTime, out_ViewRotation, out_DeltaRot, TargetSpeed, bRotated);
                break;
            case 6 + 12:
                ImplementAliceFloatCamera(MyAlicePawn, DeltaTime, out_ViewRotation, out_DeltaRot, false);
                break;
            case 6 + 13:
                ImplementAliceSprintCamera(APC, MyAlicePawn, DeltaTime, out_ViewRotation, out_DeltaRot);
                break;
            case 6 + 14:
                ImplementAliceFPSCamera(APC, MyAlicePawn, DeltaTime, out_ViewRotation, out_DeltaRot);
                break;
            default:
                ImplementAliceDefaultCamera(APC, MyAlicePawn, DeltaTime, out_ViewRotation, out_DeltaRot, TargetSpeed, bRotated);
                break;
        }
        InterpolateRoll(MyAlicePawn, DeltaTime, out_ViewRotation, out_DeltaRot);
        if (MyAlicePawn.bSoftResetCamera)
        {
            ImplementAliceSoftResetCamera(MyAlicePawn, DeltaTime, out_ViewRotation, out_DeltaRot, TargetSpeed, bRotated);
        }
    }
}

simulated function bool ProcessViewRotation(Actor ViewTarget, float DeltaTime, out Rotator out_ViewRotation, out Rotator out_DeltaRot)
{
    local AlicePlayerController APC;
    local AlicePlayerInput PlayerInput;
    local int CurCamBehavior;
    local AlicePawn MyAlicePawn;
    local float StickEpsilon;
    
    StickEpsilon = 1.0;
    PlayerInput = AlicePlayerInput(CameraOwner.PCOwner.PlayerInput);
    APC = AlicePlayerController(CameraOwner.PCOwner);
    if (ViewTarget != none && PlayerInput != none && APC != none)
    {
        bRightStickFree = Abs(PlayerInput.aTurn) <= StickEpsilon && Abs(PlayerInput.aLookUp) <= StickEpsilon;
        bLeftStickFree = !(Abs(PlayerInput.aForward) > float(0) || Abs(PlayerInput.aStrafe) > float(0));
        APC.bCameraRightStickFree = bRightStickFree;
        MyAlicePawn = AlicePawn(ViewTarget);
        if (MyAlicePawn != none)
        {
            if (MyAlicePawn.ArcheTypeID == 3)
            {
                CurCamBehavior = 4;
            }
            else if (MyAlicePawn.ArcheTypeID == 5)
            {
                CurCamBehavior = 1;
            }
            else if (APC.bSpecialCameraEnabled || APC.bCameraInterpEnabled)
            {
                CurCamBehavior = 6;
            }
            else if (MyAlicePawn.bCameraMagnet)
            {
                CurCamBehavior = 6 + 10;
            }
            else if (APC.bProjectInputToControllerSpace)
            {
                CurCamBehavior = 3;
            }
            else if (MyAlicePawn.CamBehaviorStyle == 6)
            {
                if (MyAlicePawn.IsCurAbilityCamera(MyAlicePawn.SteamVentCamera))
                {
                    CurCamBehavior = 6 + 11;
                }
                else if (MyAlicePawn.IsCurAbilityCamera(MyAlicePawn.FloatCamera))
                {
                    CurCamBehavior = 6 + 12;
                }
                else if (MyAlicePawn.IsCurAbilityCamera(MyAlicePawn.SprintCamera) || MyAlicePawn.IsCurAbilityCamera(MyAlicePawn.FastSwimCamera))
                {
                    CurCamBehavior = 6 + 13;
                }
                else if (MyAlicePawn.IsCurAbilityCamera(MyAlicePawn.FPSCamera))
                {
                    CurCamBehavior = 6 + 14;
                }
                else
                {
                    CurCamBehavior = 0;
                }
            }
            else
            {
                CurCamBehavior = int(MyAlicePawn.CamBehaviorStyle);
            }
            if (OldCamBehavior != CurCamBehavior)
            {
                EnableInterpolation = false;
            }
            ImplementAliceCamBehaviors(CurCamBehavior, APC, MyAlicePawn, PlayerInput, DeltaTime, out_ViewRotation, out_DeltaRot);
            OldViewTargetRotation = ViewTarget.Rotation;
            OldViewRotation = Normalize(out_ViewRotation + out_DeltaRot);
            OldCamBehavior = CurCamBehavior;
        }
        else if (APC.MyAlicePawn.ArcheTypeID == 3)
        {
            out_ViewRotation = rot(0, 0, 0);
            out_DeltaRot = rot(0, 0, 0);
        }
    }
    return false;
}

simulated function ImplementAliceSemiAutomaicCamera(AlicePawn MyAlicePawn, float DeltaTime, Rotator RevolSpeed, Rotator ViewRotation, out Rotator out_DeltaRot, float TargetSpeed, bool bRotated)
{
    local int DeltaAngle;
    
    if (bRotated || TargetSpeed > 0.0)
    {
        EnableInterpolation = true;
    }
    if ((bRotated || TargetSpeed > 0.0) && bRightStickFree)
    {
        DeltaAngle = int(GetAliceViewDeltaYaw(MyAlicePawn, ViewRotation));
        InterpolateCameraRotation(DeltaAngle, DeltaTime, RevolSpeed.Yaw, out_DeltaRot.Yaw);
        MyAlicePawn.CamRevolutionDelay = 0.0;
    }
    else if (bRightStickFree && EnableInterpolation)
    {
        DeltaAngle = int(GetAliceViewDeltaYaw(MyAlicePawn, ViewRotation));
        InterpolateCameraRotation(DeltaAngle, DeltaTime, RevolSpeed.Yaw, out_DeltaRot.Yaw);
        MyAlicePawn.CamRevolutionDelay = 0.0;
    }
    else if (EnableInterpolation && !bRotated)
    {
        EnableInterpolation = false;
    }
    if (TargetSpeed > 0.0)
    {
        if (!bRightStickFree)
        {
            DeltaAngle = int(GetAliceViewDeltaYaw(MyAlicePawn, ViewRotation));
        }
        if (JudgeFacingControl(Abs(float(DeltaAngle)), DeltaTime))
        {
            MyAlicePawn.CamDistScale = MyAlicePawn.GetCamDistScaleWhenFacingCam();
        }
    }
}

simulated function ImplementAliceFloatCamera(AlicePawn MyAlicePawn, float DeltaTime, Rotator ViewRotation, out Rotator out_DeltaRot, optional bool bPitch = true)
{
    if (bRightStickFree)
    {
        out_DeltaRot = rot(0, 0, 0);
    }
}

simulated function ImplementAliceFPSCamera(AlicePlayerController APC, AlicePawn MyAlicePawn, float DeltaTime, out Rotator out_ViewRotation, out Rotator out_DeltaRot)
{
    local int DeltaAngle, DeltaYaw;
    local float Weight, FOVWeight;
    local Rotator AliceRot;
    
    DeltaAngle = NormalizeRotAxis(MyAlicePawn.Rotation.Yaw - out_ViewRotation.Yaw);
    if (MyAlicePawn.bCamRevolBlending && Abs(float(DeltaAngle)) > float(10))
    {
        out_DeltaRot = rot(0, 0, 0);
        if (MyAlicePawn.CameraBlendTime > 0.0)
        {
            MyAlicePawn.CameraElapsedBlendTime += DeltaTime;
            Weight = MyAlicePawn.CameraElapsedBlendTime / MyAlicePawn.CameraBlendTime;
            if (Weight >= 1.0)
            {
                Weight = 1.0;
                MyAlicePawn.bCamRevolBlending = false;
            }
            BlendCameraRotation(-DeltaAngle, Weight, DeltaYaw);
            AliceRot = MyAlicePawn.Rotation;
            AliceRot.Yaw += DeltaYaw;
            MyAlicePawn.SetRotation(AliceRot);
        }
    }
    else
    {
        out_DeltaRot.Yaw = 0;
        out_DeltaRot.Roll = 0;
        MyAlicePawn.bCamRevolBlending = false;
        out_ViewRotation.Yaw = MyAlicePawn.Rotation.Yaw;
        if (MyAlicePawn.ArcheTypeID != 0 && MyAlicePawn.ArcheTypeID != 8)
        {
            APC.bShowFPS_Reticule = true;
        }
    }
    MyAlicePawn.CamRevolutionDelay = 0.0;
    if (MyAlicePawn.ArcheTypeID != 0 && MyAlicePawn.ArcheTypeID != 8)
    {
        if (APC.AimingReticuleTarget != none && APC.AimingReticuleTarget.IsA('AliceGameKynapsePawn') || APC.AimingReticuleTarget.IsA('GameBreakableActor') || APC.AimingReticuleTarget.IsA('NoseActorBase') || APC.AimingReticuleTarget.IsA('AimSwitchActorBase'))
        {
            if (MyAlicePawn.AimingZoomDelayElapsed > MyAlicePawn.AimingZoomDelay)
            {
                FOVWeight = MyAlicePawn.AimingFOVBlendTimeElapsed / MyAlicePawn.AimingFOVBlendTime;
                MyAlicePawn.AliceCameraFOV = MyAlicePawn.FPSCameraFOVOnTarget * FOVWeight + (1.0 - FOVWeight) * MyAlicePawn.AliceCameraFOV;
                MyAlicePawn.AimingFOVBlendTimeElapsed = FClamp(MyAlicePawn.AimingFOVBlendTimeElapsed + DeltaTime, 0.0, MyAlicePawn.AimingFOVBlendTime);
            }
            else
            {
                MyAlicePawn.AimingZoomDelayElapsed += DeltaTime;
            }
            APC.UpdateAimTargetUI(true);
            MyAlicePawn.AimingFOVOffBlendTimeElapsed = 0.0;
        }
        else
        {
            APC.UpdateAimTargetUI(false);
            MyAlicePawn.AimingZoomDelayElapsed = 0.0;
            MyAlicePawn.AimingFOVBlendTimeElapsed = 0.0;
            FOVWeight = MyAlicePawn.AimingFOVOffBlendTimeElapsed / MyAlicePawn.AimingFOVOffBlendTime;
            MyAlicePawn.AliceCameraFOV = MyAlicePawn.FPSCamera.FOV * FOVWeight + (1.0 - FOVWeight) * MyAlicePawn.AliceCameraFOV;
            MyAlicePawn.AimingFOVOffBlendTimeElapsed = FClamp(MyAlicePawn.AimingFOVOffBlendTimeElapsed + DeltaTime, 0.0, MyAlicePawn.AimingFOVOffBlendTime);
        }
    }
    MyAlicePawn.AliceFPSCameraFOV = MyAlicePawn.AliceCameraFOV;
}

simulated function ImplementAliceStickToCamera(AlicePlayerController APC, AlicePawn MyAlicePawn, float DeltaTime, out Rotator ViewRotation, out Rotator out_DeltaRot, optional bool bPitch = true)
{
    local int DeltaAngle;
    local Rotator RevolSpeed;
    local float Weight;
    
    out_DeltaRot = rot(0, 0, 0);
    DeltaAngle = NormalizeRotAxis(MyAlicePawn.Rotation.Yaw - ViewRotation.Yaw);
    if (MyAlicePawn.bCamRevolBlending && Abs(float(DeltaAngle)) > float(10))
    {
        if (MyAlicePawn.CameraBlendTime > 0.0)
        {
            MyAlicePawn.CameraElapsedBlendTime += DeltaTime;
            Weight = MyAlicePawn.CameraElapsedBlendTime / MyAlicePawn.CameraBlendTime;
            if (Weight >= 1.0)
            {
                Weight = 1.0;
                MyAlicePawn.bCamRevolBlending = false;
            }
            BlendCameraRotation(DeltaAngle, Weight, out_DeltaRot.Yaw);
            if (bPitch)
            {
                DeltaAngle = int(GetAliceViewDeltaPitch(MyAlicePawn, ViewRotation));
                BlendCameraRotation(DeltaAngle, Weight, out_DeltaRot.Pitch);
            }
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
        }
    }
    else
    {
        MyAlicePawn.bCamRevolBlending = false;
        ViewRotation.Yaw = MyAlicePawn.Rotation.Yaw;
        if (bPitch)
        {
            ViewRotation.Pitch = MyAlicePawn.Rotation.Pitch + MyAlicePawn.AliceCameraOrientation.Pitch;
        }
    }
    MyAlicePawn.CamRevolutionDelay = 0.0;
}

simulated function ImplementAliceAutomaicCamera(AlicePawn MyAlicePawn, float DeltaTime, Rotator ViewRotation, out Rotator out_DeltaRot, optional bool bPitch = true)
{
    local int DeltaAngle;
    local Rotator RevolSpeed;
    
    out_DeltaRot = rot(0, 0, 0);
    DeltaAngle = int(GetAliceViewDeltaYaw(MyAlicePawn, ViewRotation));
    if (MyAlicePawn.bCamRevolBlending && Abs(float(DeltaAngle)) > float(10))
    {
        RevolSpeed = MyAlicePawn.CamInitRevolutionSpeed;
    }
    else
    {
        MyAlicePawn.bCamRevolBlending = false;
        RevolSpeed = MyAlicePawn.CamRevolutionSpeed;
    }
    InterpolateCameraRotation(DeltaAngle, DeltaTime, RevolSpeed.Yaw, out_DeltaRot.Yaw);
    if (bPitch)
    {
        DeltaAngle = int(GetAliceViewDeltaPitch(MyAlicePawn, ViewRotation));
        InterpolateCameraRotation(DeltaAngle, DeltaTime, RevolSpeed.Pitch, out_DeltaRot.Pitch);
    }
    MyAlicePawn.CamRevolutionDelay = 0.0;
}

function InterpolateRoll(AlicePawn MyAlicePawn, float DeltaTime, Rotator ViewRotation, out Rotator out_DeltaRot)
{
    local int DeltaAngle;
    
    DeltaAngle = int(GetAliceViewDeltaRoll(MyAlicePawn, ViewRotation));
    InterpolateCameraRotation(DeltaAngle, DeltaTime, MyAlicePawn.CamRevolutionSpeed.Roll, out_DeltaRot.Roll);
}

function InterpolateCameraDirection(Vector DeltaVector, float DeltaTime, float Speed, out Vector out_DeltaVector)
{
    AlicePlayerCamera(CameraOwner).InterpolateVector(DeltaVector, DeltaTime, Speed, out_DeltaVector);
}

function InterpolateCameraRotation(int DeltaAngle, float DeltaTime, int RotSpeed, out int out_DeltaRot)
{
    AlicePlayerCamera(CameraOwner).InterpolateRotation(DeltaAngle, DeltaTime, RotSpeed, out_DeltaRot);
}

function BlendCameraRotation(int DeltaAngle, float BlendWeight, out int out_DeltaRot)
{
    out_DeltaRot = int(Lerp(0.0, float(DeltaAngle), BlendWeight));
}

function bool IsRotated(Rotator NewRotation)
{
    local Rotator DeltaRot;
    
    DeltaRot = Normalize(NewRotation) - Normalize(OldViewTargetRotation);
    if (DeltaRot.Pitch != 0 || DeltaRot.Yaw != 0 || DeltaRot.Roll != 0)
    {
        return true;
    }
    return false;
}

function float GetAliceViewDeltaYaw(AlicePawn MyAlicePawn, Rotator ViewRotation)
{
    return GetDeltaYaw(MyAlicePawn.Rotation + MyAlicePawn.AliceCameraOrientation, ViewRotation);
}

function float GetAliceViewDeltaRoll(AlicePawn MyAlicePawn, Rotator ViewRotation)
{
    return float(NormalizeRotAxis(MyAlicePawn.Rotation.Roll + MyAlicePawn.AliceCameraOrientation.Roll - ViewRotation.Roll));
}

function float GetAliceViewDeltaPitch(AlicePawn MyAlicePawn, Rotator ViewRotation)
{
    return float(NormalizeRotAxis(MyAlicePawn.Rotation.Pitch + MyAlicePawn.AliceCameraOrientation.Pitch - ViewRotation.Pitch));
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

function GetDeltaRotation(Actor ViewTarget, Rotator ViewRotation, out Rotator out_DeltaRot)
{
    out_DeltaRot = Normalize(ViewTarget.Rotation - ViewRotation);
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

function bool IsFacingCamera(Pawn Pawn)
{
    local float cosA;
    
    cosA = vector(CameraOwner.CameraCache.POV.Rotation) Dot vector(Pawn.Rotation);
    if (cosA < -0.7)
    {
        return true;
    }
    else
    {
        return false;
    }
}

function bool JudgeFacingControl(float Angle, float DeltaTime)
{
    local int piby4, pi3by4, piby2;
    local bool bFaceCam;
    
    piby4 = 32678 / 4;
    piby2 = 32678 / 2;
    pi3by4 = piby2 + piby4;
    bFaceCam = false;
    if (Angle < float(pi3by4))
    {
        FacingTime = 0.0;
    }
    else
    {
        FacingTime += DeltaTime;
        bFaceCam = true;
    }
    return bFaceCam;
}

function int CalcRealBaseRotSpeed(float Angle, int BaseRotSpeed)
{
    local int piby4, pi3by4, piby2, Ret;
    local float factor;
    
    piby4 = 32678 / 4;
    piby2 = 32678 / 2;
    pi3by4 = piby2 + piby4;
    if (Angle < float(piby2))
    {
        factor = Abs(float(piby2) - Angle) / float(piby2);
        Ret = int((float(1) - factor) * float(BaseRotSpeed));
    }
    else if (Angle < float(pi3by4))
    {
        Ret = BaseRotSpeed;
    }
    else
    {
        Ret = BaseRotSpeed;
    }
    return Ret;
}

function bool IsInRotationRange(float Angle)
{
    return true;
}

native function UpdateGoBackOfPlayer(float DeltaTime, out TPOV OutPOV)
{
    DeltaTime;
    OutPOV;
}

native function bool ModifyCamera(Camera Camera, float DeltaTime, out TPOV OutPOV)
{
    Camera;
    DeltaTime;
    OutPOV;
}

defaultproperties
{
    bRightStickFree=True
    FacingWaitTime=2.0
    ResetDelay=1.0
    AllowedMinDeltaAngle=5461.0
}

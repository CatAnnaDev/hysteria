class AlicePlayerCamera extends GamePlayerCamera
    native
    notplaceable
    transient
    config(Camera)
    hidecategories(Navigation);

struct native AliceCameraTrack
{
    var array<AliceCameraTrackKey> KeyArray;
    var float ElapsedTime;
    var float TotalTime;
};

struct native AliceCameraTrackKey
{
    var Vector PrevPos;
    var Vector CurrentPos;
    var Rotator PrevRot;
    var Rotator CurrentRot;
    var Vector PrevLeaveTangent;
    var Vector CurrentArriveTangent;
    var float KeyTime;
    var float ElapsedTime;
};

var float FollowSpeed;
var CameraModifier CamMod_BackOfPlayer;
var CameraModifier CamMod_Targeting;
var float ClosestCameraThreshold;
var float CameraHeightExt;
var bool bDrawHintOnPawn;
var bool bAliceHiddenByCheatCommand;
var bool bAliceHidden;
var array<Actor> HideActors;
var export editinline array<PrimitiveComponent> HideComponents;
var TPOV OldCameraCachePOV;
var Matrix ProjectionMatrix;
var Matrix ViewMatrix;
var Matrix PerspectiveMatrix;
var float ClipX;
var float ClipY;
var AliceCameraTrack CameraTrackInst;

simulated function bool CanSeeEx(Vector vLocation, optional float Scale = 1.0, optional bool bNeedOcclusionTesting = false)
{
    local bool bResult;
    local Actor HitActor;
    local Vector HitLocation, HitNormal;
    
    bResult = false;
    if (InSight(vLocation, Scale))
    {
        bResult = true;
        if (bNeedOcclusionTesting)
        {
            HitActor = Trace(HitLocation, HitNormal, CameraCache.POV.Location, vLocation, false, vect(0.0, 0.0, 0.0));
            if (HitActor != none)
            {
                if (HitActor.IsA('BlockingVolume') || HitActor.IsA('WorldInfo') || HitActor.IsA('Terrain') && Terrain(HitActor).CanBlockCamera)
                {
                    bResult = false;
                }
            }
        }
    }
    return bResult;
}

simulated function bool InSight(Vector vLocation, optional float Scale = 1.0)
{
    local Plane ScreenPos;
    
    ScreenPos = Project(vLocation);
    if (ScreenPos.W > 0.0 && Abs(ScreenPos.X) < 0.5 * ClipX * Scale && Abs(ScreenPos.Y) < 0.5 * ClipY * Scale)
    {
        return true;
    }
    return false;
}

simulated function bool InSightEx(Vector vLocation, out int FlagX, out int FlagY, out int FlagZ, optional float Scale = 1.0)
{
    local Plane ScreenPos;
    local float RangeX, RangeY;
    
    ScreenPos = Project(vLocation);
    FlagX = 0;
    FlagY = 0;
    FlagZ = 0;
    if (ScreenPos.W <= 0.0)
    {
        FlagZ = -1;
        return false;
    }
    RangeX = 0.5 * ClipX * Scale;
    RangeY = 0.5 * ClipY * Scale;
    FlagX = (ScreenPos.X >= RangeX ? 1 : ScreenPos.X <= -RangeX ? -1 : 0);
    FlagY = (ScreenPos.Y >= RangeY ? 1 : ScreenPos.Y <= -RangeY ? -1 : 0);
    return FlagX == 0 && FlagY == 0;
}

simulated function bool WillBeInSight(Vector CamDir, Vector CamLoc, Vector ObjLoc, out int FlagX, out float PosX, out int FlagY, out float PosY, optional float Scale = 1.0)
{
    local Plane ScreenPos;
    local float RangeX, RangeY;
    local Rotator CamRot;
    local Matrix View, perspective, projection;
    
    CamRot = rotator(CamDir);
    View = CalcViewMatrix(CamRot, CamLoc);
    perspective = GetPerspectiveMatrix();
    projection = Multiply_MatrixMatrix(View, perspective);
    ScreenPos = ProjectWithMatrix(projection, ObjLoc);
    FlagX = 0;
    FlagY = 0;
    if (ScreenPos.W <= 0.0)
    {
        return false;
    }
    RangeX = 0.5 * ClipX * Scale;
    RangeY = 0.5 * ClipY * Scale;
    FlagX = (ScreenPos.X >= RangeX ? 1 : ScreenPos.X <= -RangeX ? -1 : 0);
    FlagY = (ScreenPos.Y >= RangeY ? 1 : ScreenPos.Y <= -RangeY ? -1 : 0);
    PosX = Abs(ScreenPos.X) / RangeX;
    PosY = Abs(ScreenPos.Y) / RangeY;
    return FlagX == 0 && FlagY == 0;
}

event bool InSightCheck(Vector vLocation)
{
    return InSight(vLocation);
}

simulated function bool CanSee(Vector vLocation, optional float CheckCoefficient = 1.0)
{
    local bool bResult;
    local Vector HitLocation, HitNormal, CamPos, TargetDir;
    local Rotator CamRot, TargetRot;
    local Actor HitActor;
    local float DeltaAngle, ViewAspectRatio, CamFOV;
    local TPOV POV;
    
    POV = CameraCache.POV;
    CamPos = POV.Location;
    CamRot = POV.Rotation;
    bResult = true;
    TargetDir = vLocation - CamPos;
    TargetRot = rotator(TargetDir);
    DeltaAngle = float(NormalizeRotAxis(CamRot.Yaw - TargetRot.Yaw));
    CamFOV = 0.5 * 0.017453292 * 10430.378 * POV.FOV * CheckCoefficient;
    if (Abs(DeltaAngle) > CamFOV)
    {
        bResult = false;
    }
    if (bResult)
    {
        DeltaAngle = float(NormalizeRotAxis(CamRot.Pitch - TargetRot.Pitch));
        ViewAspectRatio = GetCurViewAspectRatio();
        CamFOV = 0.5 * 0.017453292 * 10430.378 * POV.FOV / ViewAspectRatio * CheckCoefficient;
        if (Abs(DeltaAngle) > CamFOV)
        {
            bResult = false;
        }
    }
    if (bResult)
    {
        HitActor = Trace(HitLocation, HitNormal, CamPos, vLocation, false, vect(0.0, 0.0, 0.0));
        if (HitActor != none)
        {
            if (HitActor.IsA('BlockingVolume') || HitActor.IsA('WorldInfo') || HitActor.IsA('Terrain') && Terrain(HitActor).CanBlockCamera)
            {
                bResult = false;
            }
        }
    }
    return bResult;
}

function ResetCustomFOV(float AliceCameraFOV)
{
    ViewTarget.POV.FOV = AliceCameraFOV;
}

function bool GetActualLookatLocation(out Vector FocusLoc, Actor FocusActor)
{
    local AlicePointOfInterest POI;
    
    POI = AlicePointOfInterest(FocusActor);
    if (POI != none)
    {
        FocusLoc = POI.GetActualLookatLocation();
        return true;
    }
    else
    {
        return false;
    }
}

function ClearFocusActor()
{
    local AlicePlayerController APC;
    
    APC = AlicePlayerController(PCOwner);
    if (APC != none)
    {
        APC.CameraLookAtFocusActor = none;
    }
}

function TickCheatCommand()
{
    local Vector Start, End;
    local AlicePlayerController APC;
    
    if (!bDrawHintOnPawn)
    {
        return;
    }
    if (PCOwner != none)
    {
        APC = AlicePlayerController(PCOwner);
    }
    if (APC != none && APC.Pawn != none && bAliceHiddenByCheatCommand != APC.Pawn.bHidden)
    {
        APC.Pawn.SetHidden(bAliceHiddenByCheatCommand);
    }
    if (bDrawHintOnPawn && APC != none && APC.Pawn != none)
    {
        Start = APC.Pawn.Location;
        Start.Z -= float(100);
        End = APC.Pawn.Location;
        End.Z += float(100);
        DrawDebugCylinder(Start, End, 50.0, 32, 255, 0, 0);
    }
}

function ToggleHide(bool bHide, bool bDrawHint)
{
    local AlicePlayerController APC;
    
    if (PCOwner != none)
    {
        APC = AlicePlayerController(PCOwner);
    }
    if (APC != none && APC.Pawn != none)
    {
        APC.Pawn.SetHidden(bHide);
    }
    bAliceHiddenByCheatCommand = bHide;
    bDrawHintOnPawn = bDrawHint;
}

function PreventCameraPenetration(AlicePlayerController APC, out Vector vLocation, out Rotator rRotation, optional bool bCollisionTest = true)
{
    local Vector TargetLoc, CamPos, out_CamLoc, HitLocation, HitNormal, Rot;
    local Rotator out_CamRot;
    local Actor HitActor;
    local TraceHitInfo HitInfo;
    local bool bHideAlice;
    
    if (APC.bCinematicMode)
    {
        return;
    }
    if (APC.bCameraInterpEnabled)
    {
        TargetLoc = APC.CameraInterpFocusPoint;
        TargetLoc.Z = vLocation.Z;
    }
    else
    {
        TargetLoc = APC.MyAlicePawn.GetPawnViewLocation();
    }
    CamPos = vLocation;
    out_CamLoc = vLocation;
    out_CamRot = rRotation;
    if (VSize(out_CamLoc - TargetLoc) <= ClosestCameraThreshold)
    {
        if (!APC.bFirstPersonViewActive && bCollisionTest)
        {
            Rot = vector(out_CamRot);
            CamPos = TargetLoc - Rot * ClosestCameraThreshold;
            out_CamLoc = CamPos;
        }
    }
    bHideAlice = false;
    HitActor = CameraPenetrationCheck(HitLocation, HitNormal, CamPos, TargetLoc, true, vect(12.0, 12.0, 12.0), 8, HitInfo, 0.4, 1.0, 1.0);
    if (HitActor != none && bCollisionTest)
    {
        out_CamLoc = HitLocation + HitNormal * float(2);
        if (VSize(out_CamLoc - TargetLoc) < ClosestCameraThreshold)
        {
            bHideAlice = !APC.bCameraInterpEnabled;
        }
    }
    else if (VSize(out_CamLoc - TargetLoc) < ClosestCameraThreshold)
    {
        bHideAlice = !APC.bCameraInterpEnabled;
    }
    if (bHideAlice)
    {
        APC.MyAlicePawn.EnableForceTranslucency(true, 0.0, bCollisionTest ? 0.3 : 0.1, 1000, false);
    }
    else if (!(APC.MyAlicePawn.bInLondon && APC.bFirstPersonViewActive))
    {
        APC.MyAlicePawn.EnableForceTranslucency(false, 1.0, 0.3, 1000, false);
    }
    bAliceHidden = bHideAlice;
    vLocation = out_CamLoc;
    rRotation = out_CamRot;
}

event bool CanBlockCamera(Actor HitActor, PrimitiveComponent HitComponent)
{
    local bool canBlock;
    
    canBlock = false;
    if (HitActor.IsA('BlockingVolume') && BlockingVolume(HitActor).bBlockCamera || HitActor.IsA('WorldInfo') || HitActor.IsA('Terrain') && Terrain(HitActor).CanBlockCamera || HitActor.IsA('InterpActor') && InterpActor(HitActor).CollisionComponent != none && InterpActor(HitActor).CollisionComponent.CanBlockCamera || HitActor.IsA('StaticMeshActorBase') && StaticMeshActorBase(HitActor).CollisionComponent != none && StaticMeshActorBase(HitActor).CollisionComponent.CanBlockCamera || HitActor.IsA('GameBreakableActor') && GameBreakableActor(HitActor).CollisionComponent != none && GameBreakableActor(HitActor).CollisionComponent.CanBlockCamera)
    {
        canBlock = true;
    }
    if (HitActor.IsA('StaticMeshCollectionActor') && canBlock != true && HitComponent != none)
    {
        canBlock = HitComponent.CanBlockCamera;
    }
    return canBlock;
}

native function Plane ProjectWithMatrix(out Matrix ProjMatrix, Vector vLocation)
{
    ProjMatrix;
    vLocation;
}

native function Matrix GetPerspectiveMatrix()
{
}

native function Matrix CalcViewMatrix(Rotator ViewRotation, Vector ViewLocation)
{
    ViewRotation;
    ViewLocation;
}

native function Actor CameraPenetrationCheck(out Vector HitLocation, out Vector HitNormal, Vector cameraLoc, Vector TargetLoc, bool bIsCollideActors, Vector Extent, int ExtraTraceFlags, optional out TraceHitInfo HitInfo, optional float ForceAlpha, optional float ForceAlphaFadeOutTime, optional float ForceAlphaFadeInTime)
{
    HitLocation;
    HitNormal;
    cameraLoc;
    TargetLoc;
    bIsCollideActors;
    Extent;
    ExtraTraceFlags;
    HitInfo;
    ForceAlpha;
    ForceAlphaFadeOutTime;
    ForceAlphaFadeInTime;
}

function float ApplyCamDistInertia(float CamDistance, Vector out_CamLoc, float InertiaRate, float fDeltaTime)
{
    local Vector vDist;
    local float oldDist, newdist;
    local TPOV OldPOV;
    
    if (InertiaRate > 0.0)
    {
        OldPOV = CameraCache.POV;
        vDist = OldPOV.Location - out_CamLoc;
        oldDist = VSize(vDist);
        newdist = CameraFloatInertiaFunction(oldDist, CamDistance, InertiaRate, fDeltaTime);
    }
    else
    {
        newdist = CamDistance;
    }
    return newdist;
}

function ApplyCameraInertia(TPOV OldPOV, float TransInertiaRate, float RotInertiaRate, float FOVInertiaRate, float DeltaTime, out Vector OutCamLoc, out Rotator OutCamRot, out float OutFOV)
{
    if (RotInertiaRate > 0.0)
    {
        OutCamRot = CameraRotInertiaFunction(OldPOV.Rotation, OutCamRot, RotInertiaRate, DeltaTime);
    }
    if (TransInertiaRate > 0.0)
    {
        OutCamLoc = CameraVectInertiaFunction(OldPOV.Location, OutCamLoc, TransInertiaRate, DeltaTime);
    }
    if (FOVInertiaRate > 0.0)
    {
        OutFOV = CameraFloatInertiaFunction(OldPOV.FOV, OutFOV, FOVInertiaRate, DeltaTime);
    }
}

function float CameraFloatInertiaFunction(float OldVector, float TargetVector, float InertiaRate, float DeltaTime)
{
    local float CurVector, fFactor;
    
    if (InertiaRate <= 0.0)
    {
        return TargetVector;
    }
    fFactor = 1.0 - 0.98 ** (50.0 / InertiaRate * DeltaTime);
    CurVector = Lerp(OldVector, TargetVector, fFactor);
    return CurVector;
}

function Rotator CameraRotInertiaFunction(Rotator OldRotator, Rotator TargetRotator, float InertiaRate, float DeltaTime)
{
    local Rotator CurRotator;
    local float fFactor;
    
    if (InertiaRate <= 0.0)
    {
        return TargetRotator;
    }
    fFactor = 1.0 - 0.98 ** (50.0 / InertiaRate * DeltaTime);
    CurRotator = RLerp(OldRotator, TargetRotator, fFactor, true);
    return CurRotator;
}

function Vector CameraVectInertiaFunction(Vector OldVector, Vector TargetVector, float InertiaRate, float DeltaTime)
{
    local Vector CurVector;
    local float fFactor;
    
    if (InertiaRate <= 0.0)
    {
        return TargetVector;
    }
    fFactor = 1.0 - 0.98 ** (50.0 / InertiaRate * DeltaTime);
    CurVector = VLerp(OldVector, TargetVector, fFactor);
    return CurVector;
}

function InterpolateVector(Vector DeltaVector, float DeltaTime, float Speed, out Vector out_DeltaVector)
{
    local float DeltaSize;
    
    out_DeltaVector = vect(0.0, 0.0, 0.0);
    if (Speed < 0.0)
    {
        out_DeltaVector = DeltaVector;
    }
    else
    {
        DeltaSize = VSize(DeltaVector);
        if (DeltaSize > 0.0)
        {
            Speed *= DeltaTime;
            if (Speed > DeltaSize)
            {
                out_DeltaVector = DeltaVector;
            }
            else
            {
                out_DeltaVector = Normal(DeltaVector) * Speed;
            }
        }
    }
}

function InterpolateRotation(int DeltaAngle, float DeltaTime, int RotSpeed, out int out_DeltaRot)
{
    local int DeltaRot;
    
    out_DeltaRot = 0;
    if (RotSpeed < 0)
    {
        out_DeltaRot = DeltaAngle;
    }
    else if (Abs(float(DeltaAngle)) > float(0))
    {
        DeltaRot = int(float(RotSpeed) * DeltaTime * float(DeltaAngle) / Abs(float(DeltaAngle)));
        if (Abs(float(DeltaRot)) > Abs(float(DeltaAngle)))
        {
            DeltaRot = DeltaAngle;
        }
        out_DeltaRot = DeltaRot;
    }
}

simulated function DoInterpolation(out Vector OutCamLoc, out Rotator OutCamRot, out float OutFOV, float DeltaTime)
{
    local TPOV OldPOV;
    local AlicePlayerController APC;
    local AlicePawn Alice;
    local float CamLocDelay, CamRotDelay, CamFOVDelay;
    
    OldPOV = OldCameraCachePOV;
    if (PCOwner != none)
    {
        APC = AlicePlayerController(PCOwner);
    }
    if (APC != none && APC.MyAlicePawn != none)
    {
        Alice = APC.MyAlicePawn;
        if (!APC.bSetViewTargetImmediately && !APC.bCinematicMode || WorldInfo.GetMapName() == "AliceEntry")
        {
            if (APC.bEnableCameraInertia)
            {
                CamLocDelay = (APC.bSetViewTargetLocImmediately ? 0.0 : Alice.CamLocDelay);
                CamRotDelay = (APC.bSetViewTargetRotImmediately ? 0.0 : Alice.CamRotDelay);
                CamFOVDelay = (APC.bSetViewTargetFOVImmediately ? 0.0 : Alice.CamFOVDelay);
                ApplyCameraInertia(OldPOV, CamLocDelay, CamRotDelay, CamFOVDelay, DeltaTime, OutCamLoc, OutCamRot, OutFOV);
            }
        }
        APC.bSetViewTargetImmediately = false;
        APC.bSetViewTargetRotImmediately = false;
        APC.bSetViewTargetLocImmediately = false;
        APC.bSetViewTargetFOVImmediately = false;
    }
}

simulated event UpdateCamera(float DeltaTime)
{
    local AlicePlayerController APC;
    
    OldCameraCachePOV = CameraCache.POV;
    UpdateCamera(DeltaTime);
    APC = AlicePlayerController(PCOwner);
    if (APC != none && APC.MyAlicePawn != none)
    {
        if (bNonGamePlayCamera)
        {
            if (APC.bFirstPersonViewActive)
            {
                APC.QuitFPS();
            }
        }
        APC.MyAlicePawn.EnableCamPPEffects(!bNonGamePlayCamera);
        APC.MyAlicePawn.SetDelayedCameraPOV(CameraCache.POV, DeltaTime);
    }
    DoInterpolation(CameraCache.POV.Location, CameraCache.POV.Rotation, CameraCache.POV.FOV, DeltaTime);
    APC.PostUpdateCamera();
    ExecCameraLensEffects(CameraCache.POV.Location, CameraCache.POV.Rotation, CameraCache.POV.FOV);
    TickCheatCommand();
}

function InitializeFor(PlayerController PC)
{
    local AlicePawn Player;
    
    if (PC != none && PC.Pawn != none)
    {
        Player = AlicePawn(PC.Pawn);
        if (Player != none)
        {
            DefaultFOV = Player.AliceCameraFOV;
        }
    }
    CameraCache.POV.FOV = DefaultFOV;
    PCOwner = PC;
    SetViewTarget(PC.ViewTarget);
    SetDesiredColorScale(WorldInfo.DefaultColorScale, 5.0);
    UpdateCamera(0.0);
}

event PostBeginPlay()
{
    PostBeginPlay();
    CamMod_BackOfPlayer = CreateCameraModifier(class'AliceCamMod_BackOfPlayer');
    CamMod_BackOfPlayer.AddCameraModifier(self);
    CamMod_Targeting = CreateCameraModifier(class'AliceCamMod_Targeting');
}

simulated function SetProjectionInfo(Matrix ProjMatrix, float CX, float CY, Matrix VMatrix, Matrix PersMatrix)
{
    ProjectionMatrix = ProjMatrix;
    ViewMatrix = VMatrix;
    PerspectiveMatrix = PersMatrix;
    ClipX = CX;
    ClipY = CY;
}

native function BuildCameraTrack()
{
}

native function AddPointToCameraTrack(Vector InPosition, Rotator InRotation, float KeyTime)
{
    InPosition;
    InRotation;
    KeyTime;
}

native function ClearCameraTrack()
{
}

native function bool GetPositionOnCameraTrack(float fElapsedTime, out Vector OutPosition, out Rotator OutRotation)
{
    fElapsedTime;
    OutPosition;
    OutRotation;
}

native function float GetCameraTrackElapsedTime(float fDeltaTime)
{
    fDeltaTime;
}

native final function Plane Project(Vector Position)
{
    Position;
}

defaultproperties
{
    FollowSpeed=2.0
    ClosestCameraThreshold=20.0
    CameraHeightExt=50.0
    OldCameraCachePOV=(Location=(X=0.0,Y=0.0,Z=0.0),Rotation=(Pitch=0,Yaw=0,Roll=0),FOV=90.0)
}

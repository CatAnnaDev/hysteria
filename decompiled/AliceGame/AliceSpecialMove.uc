class AliceSpecialMove extends Object
    abstract
    native
    notplaceable
    config(Pawn);

var AliceGamePawn PawnOwner;
var AlicePlayerController PCOwner;
var float SpeedModifier;
var float HeavyWeaponSpeedModifier;
var float GravityScale;
var bool bCanFireWeapon;
var bool bLastCanDoSpecialMove;
var const bool bLockPawnRotation;
var bool bPawnRotationLocked;
var bool bDisableMovement;
var bool bMovementDisabled;
var const bool bDisableLook;
var const bool bDisableCollision;
var const bool bDisablePhysics;
var const bool bDisableAirControl;
var bool bAirControlDisabled;
var const bool bStopAtLedges;
var bool bStopAtLedgesActivated;
var const bool bStopAllConfigAnim;
var bool bRestoreMovementAfterMove;
var bool bCanRepeat;
var const bool UseCustomRMM;
var bool RMMChangedInAction;
var const bool UseCustomRRM;
var bool RRMChangedInAction;
var const bool bForceGod;
var bool bGodModeActivated;
var bool bPrevGodMode;
var float DamageScale;
var transient float LastCanDoSpecialMoveTime;
var Vector OldAccel;
var float OldAirControl;
var ERootMotionMode RMMInAction;
var ERootMotionRotationMode RRMInAction;
var float BlendOutTime;

function PostSpecialMove()
{
    if (PCOwner != none)
    {
        PCOwner.PostSpecialMove();
    }
}

function PreSpecialMove()
{
}

function RootMotionExtracted(SkeletalMeshComponent SkelComp, out BoneAtom ExtractedRootMotionDelta)
{
}

function RootMotionModeChanged(SkeletalMeshComponent SkelComp)
{
}

final function bool IsPawnRotationLocked()
{
    return bPawnRotationLocked;
}

final function SetLockPawnRotation(bool bLock)
{
    if (bPawnRotationLocked != bLock)
    {
        bPawnRotationLocked = bLock;
        if (!bLock)
        {
        }
    }
}

final function SetMovementLock(bool bEnable)
{
    if (bMovementDisabled != bEnable)
    {
        bMovementDisabled = bEnable;
        if (PCOwner != none)
        {
            PCOwner.IgnoreMoveInput(bEnable);
        }
        if (bEnable)
        {
            PawnOwner.Acceleration = vect(0.0, 0.0, 0.0);
        }
    }
}

final function TogglePawnCollision(AliceGamePawn aPawn, bool bToggleOn)
{
    if (bToggleOn)
    {
        aPawn.EnableCollision(true);
    }
    else
    {
        aPawn.EnableCollision(false);
    }
}

function AnimCfg_AnimEndNotify(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
    PawnOwner.EndSpecialMove();
}

function bool MessageEvent(name EventName, Object Sender)
{
    if (AliceGamePawn(Sender) != none)
    {
    }
    ScriptTrace();
    return false;
}

function Tick(float DeltaTime)
{
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
    if (PCOwner != none)
    {
        if (bDisableLook)
        {
            PCOwner.IgnoreLookInput(false);
        }
        PostSpecialMove();
    }
    if (NextMove != 0)
    {
        BlendOutTime = -1.0;
    }
    else
    {
        BlendOutTime = 0.25;
    }
    if (bRestoreMovementAfterMove)
    {
        PawnOwner.Acceleration = OldAccel;
    }
    if (bDisableCollision)
    {
        TogglePawnCollision(PawnOwner, true);
    }
    if (bDisablePhysics)
    {
        if (PawnOwner.Role == 3)
        {
            PawnOwner.SetPhysics(2);
        }
    }
    if (bMovementDisabled)
    {
        SetMovementLock(false);
    }
    if (bPawnRotationLocked)
    {
        SetLockPawnRotation(false);
    }
    if (bAirControlDisabled)
    {
        PawnOwner.AirControl = OldAirControl;
        bAirControlDisabled = false;
    }
    if (bStopAtLedgesActivated)
    {
        PawnOwner.bStopAtLedges--;
        bStopAtLedgesActivated = false;
    }
    if (RMMChangedInAction)
    {
        PawnOwner.Mesh.RootMotionMode = 0;
        RMMChangedInAction = false;
    }
    if (RRMChangedInAction)
    {
        PawnOwner.Mesh.RootMotionRotationMode = 0;
        RRMChangedInAction = false;
    }
    if (bGodModeActivated)
    {
        PCOwner.bGodMode = bPrevGodMode;
        bGodModeActivated = false;
    }
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
    PCOwner = AlicePlayerController(PawnOwner.Controller);
    if (PCOwner != none)
    {
        if (bDisableLook)
        {
            PCOwner.IgnoreLookInput(true);
        }
        PreSpecialMove();
    }
    if (bRestoreMovementAfterMove)
    {
        OldAccel = PawnOwner.Acceleration;
    }
    if (bDisableMovement)
    {
        SetMovementLock(true);
    }
    if (default.bLockPawnRotation)
    {
        SetLockPawnRotation(true);
    }
    if (bDisableCollision)
    {
        TogglePawnCollision(PawnOwner, false);
    }
    if (bStopAllConfigAnim)
    {
        PawnOwner.StopAllConfigAnim(0.05);
    }
    if (bDisablePhysics)
    {
        PawnOwner.ZeroMovementVariables();
        if (PawnOwner.Role == 3)
        {
            PawnOwner.SetPhysics(0);
        }
    }
    if (bDisableAirControl)
    {
        OldAirControl = PawnOwner.AirControl;
        PawnOwner.AirControl = 0.0;
        bAirControlDisabled = true;
    }
    if (bStopAtLedges)
    {
        PawnOwner.bStopAtLedges++;
        bStopAtLedgesActivated = true;
    }
    if (UseCustomRMM)
    {
        PawnOwner.Mesh.RootMotionMode = RMMInAction;
        RMMChangedInAction = true;
    }
    if (UseCustomRRM)
    {
        PawnOwner.Mesh.RootMotionRotationMode = RRMInAction;
        RRMChangedInAction = true;
    }
    if (bForceGod)
    {
        bPrevGodMode = PCOwner.bGodMode;
        PCOwner.bGodMode = true;
        bGodModeActivated = true;
    }
}

protected function bool InternalCanDoSpecialMove()
{
    return true;
}

final function bool CanDoSpecialMove(optional bool bForceCheck)
{
    if (PawnOwner != none)
    {
        if (bForceCheck || PawnOwner.WorldInfo.TimeSeconds != LastCanDoSpecialMoveTime)
        {
            bLastCanDoSpecialMove = InternalCanDoSpecialMove();
            LastCanDoSpecialMoveTime = PawnOwner.WorldInfo.TimeSeconds;
        }
        return bLastCanDoSpecialMove;
    }
    return false;
}

function bool CanOverrideSpecialMove(ESpecialMove InMove)
{
    return false;
}

function bool CanOverrideMoveWith(ESpecialMove NewMove)
{
    return false;
}

function bool CanChainMove(ESpecialMove NextMove)
{
    return false;
}

defaultproperties
{
    SpeedModifier=1.0
    GravityScale=1.0
    bCanFireWeapon=True
    bRestoreMovementAfterMove=True
    DamageScale=1.0
}

class ASM_ToggleShrink extends AliceSpecialMove
    native
    notplaceable;

var() AnimationParaConfig AnimCfg_ToggleShrink;
var float AnimLength;
var float ScaleSpeed;
var float BaseHight;
var InterpActor BaseActor;
var bool ShrinkFinished;
var bool bOldCombatValue;
var transient int PrevWeaponID;
var float UnShrinkUpSpeed;

function bool CanChainMove(ESpecialMove NextMove)
{
    if (NextMove == 3)
    {
        return true;
    }
    return false;
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
    local Vector Loc;
    local AlicePawn AlicePawn;
    
    AlicePawn = AlicePawn(PawnOwner);
    if (AlicePawn == none)
    {
        return;
    }
    SpecialMoveEnded(PrevMove, NextMove);
    PawnOwner.StopConfigAnim(AnimCfg_ToggleShrink, BlendOutTime);
    PawnOwner.bCanBeDamaged = true;
    if (ShrinkFinished && PawnOwner.DrawScale == AlicePawn(PawnOwner).ShrinkingCollisionScale)
    {
        AlicePawn.GetAliceFootPoint(Loc);
        PCOwner.EnteringShrinkingMode();
        AlicePawn.clearFakeAttached();
    }
    else
    {
        AlicePawn.SetAliceAbilityCamera(AlicePawn.ShrinkCamera, true);
        PCOwner.SetDrawScale(1.0);
        AlicePawn.UnshrinkOnBase = (BaseHight != float(0) ? true : false);
        if (BaseActor != none)
        {
            AlicePawn.SetBase(BaseActor);
            AlicePawn.UnshrinkOnBase = true;
        }
        else
        {
            AlicePawn.UnshrinkOnBase = false;
        }
        PCOwner.LeavingbShrinkingMode();
        AlicePawn.GetAliceFootPoint(Loc);
        ShrinkFinished = true;
    }
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
    local AlicePawn AlicePawn;
    local float OldAliceCameraDistance, OldAliceCameraMaxDistance, OldAliceCameraMinDistance;
    
    AlicePawn = AlicePawn(PawnOwner);
    if (AlicePawn == none)
    {
        return;
    }
    SpecialMoveStarted(bForced, PrevMove);
    AlicePawn.ClearTimerToHideWeapon();
    AlicePawn(PawnOwner).FadeOutWeapon();
    if (PawnOwner.DrawScale > AlicePawn.ShrinkingCollisionScale)
    {
        ScaleSpeed = (PawnOwner.DrawScale - AlicePawn.ShrinkingCollisionScale) / AlicePawn.ShrinkSpeed;
        OldAliceCameraDistance = AlicePawn.AliceCameraDistance;
        OldAliceCameraMaxDistance = AlicePawn.AliceCameraMaxDistance;
        OldAliceCameraMinDistance = AlicePawn.AliceCameraMinDistance;
        AlicePawn.SetAliceAbilityCamera(AlicePawn.ShrinkCamera);
        AlicePawn.AliceCameraDistance = OldAliceCameraDistance;
        AlicePawn.AliceCameraMaxDistance = OldAliceCameraMaxDistance;
        AlicePawn.AliceCameraMinDistance = OldAliceCameraMinDistance;
        AlicePawn.CameraElapsedBlendTime = 0.0;
        AlicePawn.checkFakeAttached();
        AlicePawn.LastSafeVerifyUnShrinkPoint = vect(0.0, 0.0, 0.0);
    }
    else
    {
        AlicePawn.EnableTranslateIK(false);
        if (AlicePawn.Base != none)
        {
            BaseActor = InterpActor(AlicePawn.Base);
            BaseHight = AlicePawn.Base.CollisionComponent.Bounds.Origin.Z;
        }
        else
        {
            BaseHight = 0.0;
            BaseActor = none;
        }
        ScaleSpeed = (PawnOwner.DrawScale - 1.0) / AlicePawn.UnShrinkSpeed;
        OldAliceCameraDistance = AlicePawn.AliceCameraDistance;
        OldAliceCameraMaxDistance = AlicePawn.AliceCameraMaxDistance;
        OldAliceCameraMinDistance = AlicePawn.AliceCameraMinDistance;
        AlicePawn.SetAliceAbilityCamera(AlicePawn.ShrinkCamera, true);
        AlicePawn.AliceCameraDistance = OldAliceCameraDistance;
        AlicePawn.AliceCameraMaxDistance = OldAliceCameraMaxDistance;
        AlicePawn.AliceCameraMinDistance = OldAliceCameraMinDistance;
        AlicePawn.CameraElapsedBlendTime = 0.0;
    }
    GetToggleShrinkAnimation();
    PawnOwner.bCanBeDamaged = true;
    ShrinkFinished = false;
    PawnOwner.PlayConfigAnim(AnimCfg_ToggleShrink);
    if (ScaleSpeed > float(0))
    {
    }
}

function GetToggleShrinkAnimation()
{
    AnimCfg_ToggleShrink.AnimationNames[0] = 'AliceW_Shrink';
    if (ScaleSpeed > float(0))
    {
        if (AlicePawn(PawnOwner) != none && AlicePawn(PawnOwner).IsInShadowMode())
        {
            AnimCfg_ToggleShrink.PlayRate = 2.0;
        }
        else
        {
            AnimCfg_ToggleShrink.PlayRate = AnimLength / AlicePawn(PawnOwner).ShrinkSpeed;
        }
    }
    else if (AlicePawn(PawnOwner) != none && AlicePawn(PawnOwner).IsInShadowMode())
    {
        AnimCfg_ToggleShrink.PlayRate = 2.0;
    }
    else
    {
        AnimCfg_ToggleShrink.PlayRate = 1.5;
    }
}

defaultproperties
{
    AnimCfg_ToggleShrink=(AnimationNames=("AliceW_Shrink"),BlendNodeIndex="EABLIdx_Slot_FullBody_Main",AnimType=0,BlendInTime=0.1,BlendOutTime=0.1,PlayRate=1.0,bLoop=False,bCauseActorAnimEnd=True,bTriggerFakeRootMotion=False,bNotExtendAnimTimeForFakeRootMotion=False,AnimPlayType="ECAPT_RandomPickupOne",RootBoneTransitionOption="RBA_Default",RootBoneTransitionOption[1]="RBA_Default",RootBoneTransitionOption[2]="RBA_Default",RootBoneRotationOption="RRO_Default",RootBoneRotationOption[1]="RRO_Default",RootBoneRotationOption[2]="RRO_Default",FakeRootMotionMode="RMM_Accel",AnimationDescName="")
    AnimLength=0.2
    ScaleSpeed=1.0
    UnShrinkUpSpeed=190.0
}

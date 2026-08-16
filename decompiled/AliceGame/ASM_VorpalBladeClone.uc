class ASM_VorpalBladeClone extends AliceSpecialMove
    notplaceable;

var() AnimationParaConfig AnimCfg_Animation_still;
var() AnimationParaConfig AnimCfg_Animation_run;
var transient bool bPlayRunningAnim;

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
    SpecialMoveEnded(PrevMove, NextMove);
    if (bPlayRunningAnim)
    {
        PawnOwner.StopConfigAnim(AnimCfg_Animation_run, BlendOutTime);
    }
    else
    {
        PawnOwner.StopConfigAnim(AnimCfg_Animation_still, BlendOutTime);
    }
    if (PCOwner.MyAlicePawn.bClockBombCountingDown && PCOwner.MyAlicePawn.MyClonePawn != none)
    {
        PCOwner.MyAlicePawn.ForceAttachWatchAfterDodge();
        PCOwner.HoldActionDone();
    }
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
    if (AlicePawn(PawnOwner).Weapon != none)
    {
        AlicePawn(PawnOwner).ClearTimerToHideWeapon();
        AlicePawn(PawnOwner).FadeOutWeapon();
    }
    SpecialMoveStarted(bForced, PrevMove);
    if (AlicePawn(PawnOwner).IsRunning() || PCOwner.bTargetingModeActive)
    {
        PawnOwner.PlayConfigAnim(AnimCfg_Animation_run);
        bPlayRunningAnim = true;
    }
    else
    {
        PawnOwner.PlayConfigAnim(AnimCfg_Animation_still);
        bPlayRunningAnim = false;
    }
}

defaultproperties
{
    AnimCfg_Animation_still=(AnimationNames=("AliceW_ClockBomb_Spawn_Still"),BlendNodeIndex="EABLIdx_Slot_FullBody_Main",AnimType=0,BlendInTime=0.1,BlendOutTime=0.1,PlayRate=1.0,bLoop=False,bCauseActorAnimEnd=True,bTriggerFakeRootMotion=False,bNotExtendAnimTimeForFakeRootMotion=False,AnimPlayType="ECAPT_RandomPickupOne",RootBoneTransitionOption="RBA_Default",RootBoneTransitionOption[1]="RBA_Default",RootBoneTransitionOption[2]="RBA_Default",RootBoneRotationOption="RRO_Default",RootBoneRotationOption[1]="RRO_Default",RootBoneRotationOption[2]="RRO_Default",FakeRootMotionMode="RMM_Accel",AnimationDescName="")
    AnimCfg_Animation_run=(AnimationNames=("AliceW_ClockBomb_Spawn_Run_UB"),BlendNodeIndex="EABLIdx_Slot_HalfBody_Upper_Main",AnimType=0,BlendInTime=0.1,BlendOutTime=0.1,PlayRate=1.0,bLoop=False,bCauseActorAnimEnd=True,bTriggerFakeRootMotion=False,bNotExtendAnimTimeForFakeRootMotion=False,AnimPlayType="ECAPT_RandomPickupOne",RootBoneTransitionOption="RBA_Default",RootBoneTransitionOption[1]="RBA_Default",RootBoneTransitionOption[2]="RBA_Default",RootBoneRotationOption="RRO_Default",RootBoneRotationOption[1]="RRO_Default",RootBoneRotationOption[2]="RRO_Default",FakeRootMotionMode="RMM_Accel",AnimationDescName="")
}

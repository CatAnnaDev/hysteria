class ASM_ContextSensitive extends AliceSpecialMove
    notplaceable;

var() AnimationParaConfig AnimCfg_Animation;

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
    SpecialMoveEnded(PrevMove, NextMove);
    PawnOwner.StopConfigAnim(AnimCfg_Animation, BlendOutTime);
    if (PCOwner.MyAlicePawn.CurrentContextActor.IsA('ClockBombContextActor'))
    {
        if (PCOwner.MyAlicePawn.bClockBombCountingDown && PCOwner.MyAlicePawn.MyClonePawn != none)
        {
            PCOwner.MyAlicePawn.AttachWatch();
        }
    }
    AlicePawn(PawnOwner).bIsDoingContextAction = false;
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
    SpecialMoveStarted(bForced, PrevMove);
    GetAnimation();
    PawnOwner.PlayConfigAnim(AnimCfg_Animation);
}

function GetAnimation()
{
    AnimCfg_Animation.AnimationNames[0] = AlicePawn(PawnOwner).AnimSeqForContext;
    if (AlicePawn(PawnOwner).DoRootTranslationForContext)
    {
        AnimCfg_Animation.RootBoneTransitionOption[0] = 2;
        AnimCfg_Animation.RootBoneTransitionOption[2] = 2;
    }
    else
    {
        AnimCfg_Animation.RootBoneTransitionOption[0] = 0;
        AnimCfg_Animation.RootBoneTransitionOption[2] = 0;
    }
    if (AlicePawn(PawnOwner).DoRootRotationForContext)
    {
        AnimCfg_Animation.RootBoneRotationOption[2] = 2;
    }
    else
    {
        AnimCfg_Animation.RootBoneRotationOption[2] = 0;
    }
}

defaultproperties
{
    AnimCfg_Animation=(AnimationNames=("AliceL_Idle"),BlendNodeIndex="EABLIdx_Slot_FullBody_Main",AnimType=0,BlendInTime=0.1,BlendOutTime=0.1,PlayRate=1.0,bLoop=False,bCauseActorAnimEnd=True,bTriggerFakeRootMotion=False,bNotExtendAnimTimeForFakeRootMotion=False,AnimPlayType="ECAPT_RandomPickupOne",RootBoneTransitionOption="RBA_Translate",RootBoneTransitionOption[1]="RBA_Default",RootBoneTransitionOption[2]="RBA_Translate",RootBoneRotationOption="RRO_Default",RootBoneRotationOption[1]="RRO_Default",RootBoneRotationOption[2]="RRO_Default",FakeRootMotionMode="RMM_Accel",AnimationDescName="")
    GravityScale=0.0
    bDisableMovement=True
}

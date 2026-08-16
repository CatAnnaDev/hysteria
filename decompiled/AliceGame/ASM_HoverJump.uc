class ASM_HoverJump extends AliceSpecialMove
    native
    notplaceable;

var AnimationParaConfig AnimCfg_Rising;
var AnimationParaConfig AnimCfg_Falling;
var AnimationParaConfig AnimCfg_Landing;
var bool bIsRising;
var float PreLandTime;

function PlayLand()
{
    PawnOwner.PlayConfigAnim(AnimCfg_Landing);
    PCOwner.MyAlicePawn.SetAliceAbilityCamera(PCOwner.MyAlicePawn.JumpCamera, true, !PCOwner.MyAlicePawn.bIsSprinting);
}

event Landed()
{
    PlayLand();
    PCOwner.OnSMLaned();
}

function AnimCfg_AnimEndNotify(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
    if (bIsRising)
    {
        PlayFalling();
    }
    else
    {
        PawnOwner.EndSpecialMove();
    }
}

function PlayFalling()
{
    bIsRising = false;
    PawnOwner.PlayConfigAnim(AnimCfg_Falling);
}

function PlayRising()
{
    bIsRising = true;
    PCOwner.MyAlicePawn.bAfterHoverJump = true;
    PawnOwner.Velocity = PawnOwner.PendingVelocity;
    PawnOwner.PlayConfigAnim(AnimCfg_Rising);
    PCOwner.MyAlicePawn.SetAliceAbilityCamera(PCOwner.MyAlicePawn.JumpCamera, false, !PCOwner.bShrinkingModeActive);
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
    SpecialMoveEnded(PrevMove, NextMove);
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
    SpecialMoveStarted(bForced, PrevMove);
    if (PCOwner != none && PCOwner.bPressedJump)
    {
        PlayRising();
    }
    else
    {
        PlayFalling();
    }
}

defaultproperties
{
    AnimCfg_Rising=(AnimationNames=("AliceW_Jump_Rise"),BlendNodeIndex="EABLIdx_Slot_FullBody_Main",AnimType=0,BlendInTime=0.0,BlendOutTime=0.0,PlayRate=1.0,bLoop=False,bCauseActorAnimEnd=True,bTriggerFakeRootMotion=False,bNotExtendAnimTimeForFakeRootMotion=False,AnimPlayType="ECAPT_RandomPickupOne",RootBoneTransitionOption="RBA_Default",RootBoneTransitionOption[1]="RBA_Default",RootBoneTransitionOption[2]="RBA_Default",RootBoneRotationOption="RRO_Default",RootBoneRotationOption[1]="RRO_Default",RootBoneRotationOption[2]="RRO_Default",FakeRootMotionMode="RMM_Accel",AnimationDescName="")
    AnimCfg_Falling=(AnimationNames=("AliceW_Jump_Fall"),BlendNodeIndex="EABLIdx_Slot_FullBody_Main",AnimType=0,BlendInTime=0.0,BlendOutTime=0.0,PlayRate=1.0,bLoop=True,bCauseActorAnimEnd=True,bTriggerFakeRootMotion=False,bNotExtendAnimTimeForFakeRootMotion=False,AnimPlayType="ECAPT_RandomPickupOne",RootBoneTransitionOption="RBA_Default",RootBoneTransitionOption[1]="RBA_Default",RootBoneTransitionOption[2]="RBA_Default",RootBoneRotationOption="RRO_Default",RootBoneRotationOption[1]="RRO_Default",RootBoneRotationOption[2]="RRO_Default",FakeRootMotionMode="RMM_Accel",AnimationDescName="")
    AnimCfg_Landing=(AnimationNames=("AliceW_Jump_Land"),BlendNodeIndex="EABLIdx_Slot_FullBody_Main",AnimType=0,BlendInTime=0.0,BlendOutTime=0.0,PlayRate=1.0,bLoop=False,bCauseActorAnimEnd=True,bTriggerFakeRootMotion=False,bNotExtendAnimTimeForFakeRootMotion=False,AnimPlayType="ECAPT_RandomPickupOne",RootBoneTransitionOption="RBA_Default",RootBoneTransitionOption[1]="RBA_Default",RootBoneTransitionOption[2]="RBA_Default",RootBoneRotationOption="RRO_Default",RootBoneRotationOption[1]="RRO_Default",RootBoneRotationOption[2]="RRO_Default",FakeRootMotionMode="RMM_Accel",AnimationDescName="")
    PreLandTime=0.1
}

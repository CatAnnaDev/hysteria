class ASM_SlideToTarget extends AliceSpecialMove
    native
    notplaceable;

var AnimationParaConfig AnimCfg_Vorpal;
var AnimationParaConfig AnimCfg_Horse;
var AnimationParaConfig AnimCfg_Pepper;
var AnimationParaConfig AnimCfg_Teapot;
var AnimationParaConfig AnimCfg_SlideToTarget;

function GetAnimByWeapon()
{
    local AnimSequence AnimSeq;
    local WeaponForAlice CurWeapon;
    
    CurWeapon = WeaponForAlice(AlicePawn(PawnOwner).Weapon);
    if (VorpalBlade(CurWeapon) != none)
    {
        AnimCfg_SlideToTarget = AnimCfg_Vorpal;
    }
    else if (HobbyHorse(CurWeapon) != none)
    {
        AnimCfg_SlideToTarget = AnimCfg_Horse;
    }
    else if (EyeStaff(CurWeapon) != none)
    {
        AnimCfg_SlideToTarget = AnimCfg_Pepper;
    }
    else if (TeapotCannon(CurWeapon) != none)
    {
        AnimCfg_SlideToTarget = AnimCfg_Teapot;
    }
    if (AlicePawn(PawnOwner) != none && CurWeapon != none)
    {
        AnimSeq = PawnOwner.Mesh.FindAnimSequence(AnimCfg_SlideToTarget.AnimationNames[0]);
        if (AnimSeq != none)
        {
            AnimCfg_SlideToTarget.PlayRate = AnimSeq.SequenceLength / CurWeapon.PawnSlideToTargetDuration;
        }
    }
}

function AnimCfg_AnimEndNotify(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
    PawnOwner.EndSpecialMove();
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
    SpecialMoveEnded(PrevMove, NextMove);
    PawnOwner.StopConfigAnim(AnimCfg_SlideToTarget, BlendOutTime);
    AlicePawn(PawnOwner).OnSlideToTargetEnd();
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
    SpecialMoveStarted(bForced, PrevMove);
    GetAnimByWeapon();
    PawnOwner.PlayConfigAnim(AnimCfg_SlideToTarget);
}

defaultproperties
{
    AnimCfg_Vorpal=(AnimationNames=("AliceW_WP1_Mele_Attack_Rush"),BlendNodeIndex="EABLIdx_Slot_FullBody_Main",AnimType=0,BlendInTime=0.0,BlendOutTime=0.0,PlayRate=1.0,bLoop=False,bCauseActorAnimEnd=True,bTriggerFakeRootMotion=False,bNotExtendAnimTimeForFakeRootMotion=False,AnimPlayType="ECAPT_RandomPickupOne",RootBoneTransitionOption="RBA_Default",RootBoneTransitionOption[1]="RBA_Default",RootBoneTransitionOption[2]="RBA_Default",RootBoneRotationOption="RRO_Default",RootBoneRotationOption[1]="RRO_Default",RootBoneRotationOption[2]="RRO_Default",FakeRootMotionMode="RMM_Accel",AnimationDescName="")
    AnimCfg_Horse=(AnimationNames=("AliceW_WP2_Mele_Attack_Rush"),BlendNodeIndex="EABLIdx_Slot_FullBody_Main",AnimType=0,BlendInTime=0.0,BlendOutTime=0.0,PlayRate=1.0,bLoop=False,bCauseActorAnimEnd=True,bTriggerFakeRootMotion=False,bNotExtendAnimTimeForFakeRootMotion=False,AnimPlayType="ECAPT_RandomPickupOne",RootBoneTransitionOption="RBA_Default",RootBoneTransitionOption[1]="RBA_Default",RootBoneTransitionOption[2]="RBA_Default",RootBoneRotationOption="RRO_Default",RootBoneRotationOption[1]="RRO_Default",RootBoneRotationOption[2]="RRO_Default",FakeRootMotionMode="RMM_Accel",AnimationDescName="")
    AnimCfg_Pepper=(AnimationNames=("AliceW_WP3_Mele_Attack_Rush"),BlendNodeIndex="EABLIdx_Slot_FullBody_Main",AnimType=0,BlendInTime=0.0,BlendOutTime=0.0,PlayRate=1.0,bLoop=False,bCauseActorAnimEnd=True,bTriggerFakeRootMotion=False,bNotExtendAnimTimeForFakeRootMotion=False,AnimPlayType="ECAPT_RandomPickupOne",RootBoneTransitionOption="RBA_Default",RootBoneTransitionOption[1]="RBA_Default",RootBoneTransitionOption[2]="RBA_Default",RootBoneRotationOption="RRO_Default",RootBoneRotationOption[1]="RRO_Default",RootBoneRotationOption[2]="RRO_Default",FakeRootMotionMode="RMM_Accel",AnimationDescName="")
    AnimCfg_Teapot=(AnimationNames=("AliceW_WP4_Mele_Attack_Rush"),BlendNodeIndex="EABLIdx_Slot_FullBody_Main",AnimType=0,BlendInTime=0.0,BlendOutTime=0.0,PlayRate=1.0,bLoop=False,bCauseActorAnimEnd=True,bTriggerFakeRootMotion=False,bNotExtendAnimTimeForFakeRootMotion=False,AnimPlayType="ECAPT_RandomPickupOne",RootBoneTransitionOption="RBA_Default",RootBoneTransitionOption[1]="RBA_Default",RootBoneTransitionOption[2]="RBA_Default",RootBoneRotationOption="RRO_Default",RootBoneRotationOption[1]="RRO_Default",RootBoneRotationOption[2]="RRO_Default",FakeRootMotionMode="RMM_Accel",AnimationDescName="")
    AnimCfg_SlideToTarget=(AnimationNames=(),BlendNodeIndex="EABLIdx_Slot_FullBody_Main",AnimType=0,BlendInTime=0.0,BlendOutTime=0.0,PlayRate=1.0,bLoop=False,bCauseActorAnimEnd=True,bTriggerFakeRootMotion=False,bNotExtendAnimTimeForFakeRootMotion=False,AnimPlayType="ECAPT_RandomPickupOne",RootBoneTransitionOption="RBA_Default",RootBoneTransitionOption[1]="RBA_Default",RootBoneTransitionOption[2]="RBA_Default",RootBoneRotationOption="RRO_Default",RootBoneRotationOption[1]="RRO_Default",RootBoneRotationOption[2]="RRO_Default",FakeRootMotionMode="RMM_Accel",AnimationDescName="")
    UseCustomRMM=True
    RMMInAction="RMM_Accel"
}

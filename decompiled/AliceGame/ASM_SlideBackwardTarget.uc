class ASM_SlideBackwardTarget extends AliceSpecialMove
    native
    notplaceable;

var() AnimationParaConfig AnimCfg_Start;
var array<AnimationParaConfig> AnimCfg_RandomStart;

function GetRandomStartAnim()
{
    local int Index;
    local AnimSequence AnimSeq;
    
    Index = Rand(AnimCfg_RandomStart.Length);
    AnimCfg_Start = AnimCfg_RandomStart[Index];
    if (AlicePawn(PawnOwner) != none && WeaponForAliceMelee(AlicePawn(PawnOwner).Weapon) != none)
    {
        AnimSeq = PawnOwner.Mesh.FindAnimSequence(AnimCfg_Start.AnimationNames[0]);
        if (AnimSeq != none)
        {
            AnimCfg_Start.PlayRate = AnimSeq.SequenceLength / WeaponForAlice(AlicePawn(PawnOwner).Weapon).PawnSlideToTargetDuration;
        }
    }
}

function AnimCfg_AnimEndNotify(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
    PawnOwner.EndSpecialMove();
}

function StopStart()
{
    PawnOwner.StopConfigAnim(AnimCfg_Start, BlendOutTime);
    AlicePawn(PawnOwner).OnSlideToTargetEnd();
}

function PlayStart()
{
    GetRandomStartAnim();
    PawnOwner.PlayConfigAnim(AnimCfg_Start);
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
    SpecialMoveEnded(PrevMove, NextMove);
    StopStart();
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
    SpecialMoveStarted(bForced, PrevMove);
    PlayStart();
}

defaultproperties
{
    AnimCfg_Start=(AnimationNames=("AliceW_WP1_Mele_Attack_BackHop_1"),BlendNodeIndex="EABLIdx_Slot_FullBody_Main",AnimType=0,BlendInTime=0.0,BlendOutTime=0.0,PlayRate=1.0,bLoop=False,bCauseActorAnimEnd=True,bTriggerFakeRootMotion=False,bNotExtendAnimTimeForFakeRootMotion=False,AnimPlayType="ECAPT_RandomPickupOne",RootBoneTransitionOption="RBA_Default",RootBoneTransitionOption[1]="RBA_Default",RootBoneTransitionOption[2]="RBA_Default",RootBoneRotationOption="RRO_Default",RootBoneRotationOption[1]="RRO_Default",RootBoneRotationOption[2]="RRO_Default",FakeRootMotionMode="RMM_Accel",AnimationDescName="")
    AnimCfg_RandomStart(0)=(AnimationNames=("AliceW_WP1_Mele_Attack_BackHop_1"),BlendNodeIndex="EABLIdx_Slot_FullBody_Main",AnimType=0,BlendInTime=0.0,BlendOutTime=0.0,PlayRate=1.0,bLoop=False,bCauseActorAnimEnd=True,bTriggerFakeRootMotion=False,bNotExtendAnimTimeForFakeRootMotion=False,AnimPlayType="ECAPT_RandomPickupOne",RootBoneTransitionOption="RBA_Default",RootBoneTransitionOption[1]="RBA_Default",RootBoneTransitionOption[2]="RBA_Default",RootBoneRotationOption="RRO_Default",RootBoneRotationOption[1]="RRO_Default",RootBoneRotationOption[2]="RRO_Default",FakeRootMotionMode="RMM_Accel",AnimationDescName="")
    AnimCfg_RandomStart(1)=(AnimationNames=("AliceW_WP1_Mele_Attack_BackHop_2"),BlendNodeIndex="EABLIdx_Slot_FullBody_Main",AnimType=0,BlendInTime=0.0,BlendOutTime=0.0,PlayRate=1.0,bLoop=False,bCauseActorAnimEnd=True,bTriggerFakeRootMotion=False,bNotExtendAnimTimeForFakeRootMotion=False,AnimPlayType="ECAPT_RandomPickupOne",RootBoneTransitionOption="RBA_Default",RootBoneTransitionOption[1]="RBA_Default",RootBoneTransitionOption[2]="RBA_Default",RootBoneRotationOption="RRO_Default",RootBoneRotationOption[1]="RRO_Default",RootBoneRotationOption[2]="RRO_Default",FakeRootMotionMode="RMM_Accel",AnimationDescName="")
    UseCustomRMM=True
    RMMInAction="RMM_Accel"
}

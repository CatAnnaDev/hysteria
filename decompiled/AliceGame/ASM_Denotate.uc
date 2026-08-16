class ASM_Denotate extends AliceSpecialMove
    notplaceable;

var() AnimationParaConfig AnimCfg_Animation;

function GetAnimation()
{
    if (PCOwner.bTargetingModeActive)
    {
        AnimCfg_Animation.AnimationNames[0] = 'ADD_AliceW_Watch_Trigger';
        AnimCfg_Animation.BlendNodeIndex = 5;
    }
    else
    {
        AnimCfg_Animation.AnimationNames[0] = 'AliceW_Watch_Trigger';
        AnimCfg_Animation.BlendNodeIndex = 1;
    }
}

function bool CanChainMove(ESpecialMove NextMove)
{
    return false;
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
    SpecialMoveEnded(PrevMove, NextMove);
    PawnOwner.StopConfigAnim(AnimCfg_Animation, BlendOutTime);
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
    SpecialMoveStarted(bForced, PrevMove);
    AliceClonePawn(PCOwner.MyAlicePawn.MyClonePawn).Detonate();
    GetAnimation();
    PawnOwner.PlayConfigAnim(AnimCfg_Animation);
}

defaultproperties
{
    AnimCfg_Animation=(AnimationNames=("ADD_AliceW_Watch_Trigger"),BlendNodeIndex="EABLIdx_Slot_Combat_HoldWatch_Additive",AnimType=0,BlendInTime=0.15,BlendOutTime=0.15,PlayRate=1.0,bLoop=False,bCauseActorAnimEnd=True,bTriggerFakeRootMotion=False,bNotExtendAnimTimeForFakeRootMotion=False,AnimPlayType="ECAPT_RandomPickupOne",RootBoneTransitionOption="RBA_Default",RootBoneTransitionOption[1]="RBA_Default",RootBoneTransitionOption[2]="RBA_Default",RootBoneRotationOption="RRO_Default",RootBoneRotationOption[1]="RRO_Default",RootBoneRotationOption[2]="RRO_Default",FakeRootMotionMode="RMM_Accel",AnimationDescName="")
}

class ASM_Brake extends AliceSpecialMove
    native
    notplaceable;

enum EBrakeLegState
{
    EBLS_None,
    EBLS_Idle,
    EBLS_LeftLeg,
    EBLS_RightLeg,
};

var() AnimationParaConfig AnimCfg_Brake;
var float Threshold_FootStep;
var transient EBrakeLegState LegState;
var transient EBrakeLegState oldLegState;

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
    SpecialMoveEnded(PrevMove, NextMove);
    PawnOwner.StopConfigAnim(AnimCfg_Brake, BlendOutTime);
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
    SpecialMoveStarted(bForced, PrevMove);
    GetBrakeAnimation();
    PawnOwner.PlayConfigAnim(AnimCfg_Brake);
}

function GetBrakeAnimation()
{
    CalculateStateOfLegs();
    if (LegState == 3)
    {
        AnimCfg_Brake.AnimationNames[0] = 'Alice_RunBreak_R';
    }
    else
    {
        AnimCfg_Brake.AnimationNames[0] = 'Alice_RunBreak_L';
    }
}

native function CalculateStateOfLegs()
{
}

defaultproperties
{
    AnimCfg_Brake=(AnimationNames=("Alice_RunBreak_L"),BlendNodeIndex="EABLIdx_Slot_FullBody_Main",AnimType=0,BlendInTime=0.1,BlendOutTime=0.4,PlayRate=1.0,bLoop=False,bCauseActorAnimEnd=True,bTriggerFakeRootMotion=False,bNotExtendAnimTimeForFakeRootMotion=False,AnimPlayType="ECAPT_RandomPickupOne",RootBoneTransitionOption="RBA_Default",RootBoneTransitionOption[1]="RBA_Default",RootBoneTransitionOption[2]="RBA_Default",RootBoneRotationOption="RRO_Default",RootBoneRotationOption[1]="RRO_Default",RootBoneRotationOption[2]="RRO_Default",FakeRootMotionMode="RMM_Accel",AnimationDescName="")
    Threshold_FootStep=18.0
    LegState="EBLS_Idle"
    bDisableMovement=True
}

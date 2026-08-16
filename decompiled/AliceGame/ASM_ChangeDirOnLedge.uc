class ASM_ChangeDirOnLedge extends AliceSpecialMove
    notplaceable;

var() AnimationParaConfig AnimCfg_Animation;

function GetAnimationForLedge()
{
    if (PawnOwner.OnLedge != none)
    {
        switch (PawnOwner.OnLedge.VolumeType)
        {
            case 1:
                break;
            default:
        }
    }
}

function EndOfChange()
{
    PawnOwner.bChangeDirOnLedge = false;
    PawnOwner.ChangeDirOnLedge = 0;
    PawnOwner.bPlayingTransitionAnim = false;
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
    SpecialMoveEnded(PrevMove, NextMove);
    PawnOwner.StopConfigAnim(AnimCfg_Animation, 0.0);
    EndOfChange();
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
    SpecialMoveStarted(bForced, PrevMove);
    GetAnimationForLedge();
    PawnOwner.PlayConfigAnim(AnimCfg_Animation);
}

defaultproperties
{
    AnimCfg_Animation=(AnimationNames=(),BlendNodeIndex="EABLIdx_Slot_FullBody_Main",AnimType=0,BlendInTime=0.0,BlendOutTime=0.0,PlayRate=1.0,bLoop=False,bCauseActorAnimEnd=True,bTriggerFakeRootMotion=False,bNotExtendAnimTimeForFakeRootMotion=False,AnimPlayType="ECAPT_RandomPickupOne",RootBoneTransitionOption="RBA_Default",RootBoneTransitionOption[1]="RBA_Default",RootBoneTransitionOption[2]="RBA_Default",RootBoneRotationOption="RRO_Default",RootBoneRotationOption[1]="RRO_Default",RootBoneRotationOption[2]="RRO_Default",FakeRootMotionMode="RMM_Accel",AnimationDescName="")
    bDisableMovement=True
    bDisableCollision=True
}

class ASM_GrabLedge_DropToLedge extends AliceSpecialMove
    native
    notplaceable;

var() AnimationParaConfig AnimCfg_Animation;

native final function SetCurrentLedgeVolume()
{
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
    SpecialMoveEnded(PrevMove, NextMove);
    PawnOwner.bReadyToDropToClimbLedgeWhenWalking = false;
    SetCurrentLedgeVolume();
    PawnOwner.StopConfigAnim(AnimCfg_Animation, 0.0);
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
    SpecialMoveStarted(bForced, PrevMove);
    GetAnimationForLedge();
    PawnOwner.PlayConfigAnim(AnimCfg_Animation);
}

function GetAnimationForLedge()
{
    if (PawnOwner.OnLedge != none)
    {
        AnimCfg_Animation.BlendInTime = 0.1;
        AnimCfg_Animation.BlendOutTime = 0.1;
        switch (PawnOwner.OnLedge.VolumeType)
        {
            case 0:
                AnimCfg_Animation.AnimationNames[0] = 'Alice_Ledge_Start_DropDown';
                AnimCfg_Animation.RootBoneTransitionOption[0] = 2;
                AnimCfg_Animation.RootBoneTransitionOption[2] = 2;
                AnimCfg_Animation.RootBoneRotationOption[2] = 2;
                break;
            case 1:
                AnimCfg_Animation.AnimationNames[0] = 'Alice_BB_Idle';
                AnimCfg_Animation.RootBoneTransitionOption[0] = 1;
                AnimCfg_Animation.RootBoneTransitionOption[2] = 1;
                AnimCfg_Animation.RootBoneRotationOption[2] = 0;
                break;
            default:
        }
    }
}

defaultproperties
{
    AnimCfg_Animation=(AnimationNames=("Alice_Ledge_Start_DropDown"),BlendNodeIndex="EABLIdx_Slot_FullBody_Main",AnimType=0,BlendInTime=0.0,BlendOutTime=0.0,PlayRate=1.0,bLoop=False,bCauseActorAnimEnd=True,bTriggerFakeRootMotion=False,bNotExtendAnimTimeForFakeRootMotion=False,AnimPlayType="ECAPT_RandomPickupOne",RootBoneTransitionOption="RBA_Translate",RootBoneTransitionOption[1]="RBA_Default",RootBoneTransitionOption[2]="RBA_Translate",RootBoneRotationOption="RRO_Default",RootBoneRotationOption[1]="RRO_Default",RootBoneRotationOption[2]="RRO_Extract",FakeRootMotionMode="RMM_Accel",AnimationDescName="")
    GravityScale=0.0
    bDisableMovement=True
    bDisableCollision=True
}

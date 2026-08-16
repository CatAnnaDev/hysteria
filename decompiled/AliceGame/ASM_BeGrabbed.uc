class ASM_BeGrabbed extends AliceSpecialMove
    notplaceable;

var() AnimationParaConfig AnimCfg_Animation;

function bool CanChainMove(ESpecialMove NextMove)
{
    return false;
}

function EndGrabbed()
{
    PawnOwner.SetCollision(true, true);
    PawnOwner.bBeingGrabbed = false;
    PCOwner.GotoState('PlayerWalking');
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
    SpecialMoveEnded(PrevMove, NextMove);
    PawnOwner.StopConfigAnim(AnimCfg_Animation, BlendOutTime);
    EndGrabbed();
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
    SpecialMoveStarted(bForced, PrevMove);
    if (AnimCfg_Animation.AnimationNames[0] == 'None')
    {
        GetDefaultAnimation();
    }
    AlicePawn(PawnOwner).ClearTimerToHideWeapon();
    AlicePawn(PawnOwner).FadeOutWeapon();
    PawnOwner.PlayConfigAnim(AnimCfg_Animation);
}

function GetDefaultAnimation()
{
    if (PawnOwner.GrabberPawn.IsA('AliceGameDoomTankPawn'))
    {
        AnimCfg_Animation.AnimationNames[0] = 'AliceW_Be_Grabed_Tank';
    }
}

defaultproperties
{
    AnimCfg_Animation=(AnimationNames=("AliceW_Be_Grabed_Tank"),BlendNodeIndex="EABLIdx_Slot_FullBody_Main",AnimType=0,BlendInTime=0.0,BlendOutTime=0.25,PlayRate=1.0,bLoop=False,bCauseActorAnimEnd=True,bTriggerFakeRootMotion=False,bNotExtendAnimTimeForFakeRootMotion=False,AnimPlayType="ECAPT_RandomPickupOne",RootBoneTransitionOption="RBA_Translate",RootBoneTransitionOption[1]="RBA_Translate",RootBoneTransitionOption[2]="RBA_Translate",RootBoneRotationOption="RRO_Default",RootBoneRotationOption[1]="RRO_Default",RootBoneRotationOption[2]="RRO_Default",FakeRootMotionMode="RMM_Accel",AnimationDescName="")
    bDisableMovement=True
    UseCustomRMM=True
    RMMInAction="RMM_Accel"
}

class ASM_GrabLedge_FallFromBalanceBeamToGrab extends AliceSpecialMove
    notplaceable;

var() AnimationParaConfig AnimCfg_Animation;

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
    local Rotator NewRot;
    local Vector NewDir;
    
    SpecialMoveEnded(PrevMove, NextMove);
    PawnOwner.StopConfigAnim(AnimCfg_Animation, 0.0);
    NewDir = vector(PawnOwner.Rotation);
    NewRot = rotator(-NewDir);
    PawnOwner.SetRotation(NewRot);
    PawnOwner.SetPhysics(2);
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
    SpecialMoveStarted(bForced, PrevMove);
    GetAnimation();
    PawnOwner.LeaningFactor = 0.0;
    PawnOwner.PlayConfigAnim(AnimCfg_Animation);
}

function GetAnimation()
{
    AnimCfg_Animation.RootBoneTransitionOption[0] = 2;
    AnimCfg_Animation.RootBoneTransitionOption[2] = 2;
    AnimCfg_Animation.RootBoneRotationOption[2] = 2;
    if (PawnOwner.LedgeBalancingDirection == 1)
    {
        AnimCfg_Animation.AnimationNames[0] = 'AliceL_BB_Fall_Left';
    }
    else
    {
        AnimCfg_Animation.AnimationNames[0] = 'AliceL_BB_Fall_Right';
    }
}

defaultproperties
{
    AnimCfg_Animation=(AnimationNames=("AliceL_BB_Fall_Left"),BlendNodeIndex="EABLIdx_Slot_FullBody_Main",AnimType=0,BlendInTime=0.0,BlendOutTime=0.0,PlayRate=1.0,bLoop=False,bCauseActorAnimEnd=True,bTriggerFakeRootMotion=False,bNotExtendAnimTimeForFakeRootMotion=False,AnimPlayType="ECAPT_RandomPickupOne",RootBoneTransitionOption="RBA_Translate",RootBoneTransitionOption[1]="RBA_Translate",RootBoneTransitionOption[2]="RBA_Translate",RootBoneRotationOption="RRO_Default",RootBoneRotationOption[1]="RRO_Default",RootBoneRotationOption[2]="RRO_Default",FakeRootMotionMode="RMM_Accel",AnimationDescName="")
    GravityScale=0.0
    bDisableMovement=True
    bDisableCollision=True
}

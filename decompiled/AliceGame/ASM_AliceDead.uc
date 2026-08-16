class ASM_AliceDead extends AliceSpecialMove
    notplaceable;

var AnimationParaConfig Anim;

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
    SpecialMoveEnded(PrevMove, NextMove);
    PawnOwner.StopConfigAnim(Anim, BlendOutTime);
    AlicePawn(PawnOwner).HideAlicePawn(true);
    if (AlicePawn(PawnOwner).DeathParticle == none)
    {
        AlicePlayerController(PawnOwner.Controller).OnDeathParticleFinished(none);
    }
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
    SpecialMoveStarted(bForced, PrevMove);
    PawnOwner.PlayConfigAnim(Anim);
}

defaultproperties
{
    Anim=(AnimationNames=("Alice_Death"),BlendNodeIndex="EABLIdx_Slot_FullBody_Main",AnimType=0,BlendInTime=0.1,BlendOutTime=0.1,PlayRate=1.0,bLoop=False,bCauseActorAnimEnd=True,bTriggerFakeRootMotion=False,bNotExtendAnimTimeForFakeRootMotion=False,AnimPlayType="ECAPT_RandomPickupOne",RootBoneTransitionOption="RBA_Default",RootBoneTransitionOption[1]="RBA_Default",RootBoneTransitionOption[2]="RBA_Default",RootBoneRotationOption="RRO_Default",RootBoneRotationOption[1]="RRO_Default",RootBoneRotationOption[2]="RRO_Default",FakeRootMotionMode="RMM_Accel",AnimationDescName="")
    bDisableMovement=True
}

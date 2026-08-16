class ASM_Hysteria extends AliceSpecialMove
    notplaceable;

var AnimationParaConfig Anim;
var int Index;

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
    SpecialMoveEnded(PrevMove, NextMove);
    PawnOwner.StopConfigAnim(Anim, BlendOutTime);
    if (PCOwner.bTargetingModeActive || PCOwner.bFirstPersonViewActive)
    {
        AlicePawn(PawnOwner).FadeInWeapon();
    }
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
    local int IndexMax;
    
    SpecialMoveStarted(bForced, PrevMove);
    IndexMax = AlicePawn(PawnOwner).TriggerAnimSequence.Length;
    if (IndexMax > 0)
    {
        Index = int(RandRange(0.0, float(IndexMax) * 0.9999));
        Anim.AnimationNames[0] = AlicePawn(PawnOwner).TriggerAnimSequence[Index];
    }
    if (AlicePawn(PawnOwner).Weapon != none)
    {
        AlicePawn(PawnOwner).ClearTimerToHideWeapon();
        AlicePawn(PawnOwner).FadeOutWeapon();
    }
    PawnOwner.PlayConfigAnim(Anim);
}

defaultproperties
{
    Anim=(AnimationNames=("AliceW_Hgsteria_On_1"),BlendNodeIndex="EABLIdx_Slot_FullBody_Main",AnimType=0,BlendInTime=0.1,BlendOutTime=0.1,PlayRate=1.0,bLoop=False,bCauseActorAnimEnd=True,bTriggerFakeRootMotion=False,bNotExtendAnimTimeForFakeRootMotion=False,AnimPlayType="ECAPT_RandomPickupOne",RootBoneTransitionOption="RBA_Default",RootBoneTransitionOption[1]="RBA_Default",RootBoneTransitionOption[2]="RBA_Default",RootBoneRotationOption="RRO_Default",RootBoneRotationOption[1]="RRO_Default",RootBoneRotationOption[2]="RRO_Default",FakeRootMotionMode="RMM_Accel",AnimationDescName="")
    bDisableMovement=True
}

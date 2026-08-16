class ASM_BlockReaction extends AliceSpecialMove
    notplaceable;

var() AnimationParaConfig AnimCfg_Animation;
var transient name UmbrellaAnimName;

function GetAnimation()
{
    if (PawnOwner.CurrentDmgStrength == 2)
    {
        AnimCfg_Animation.AnimationNames[0] = 'AliceW_StauePose_Damage';
        UmbrellaAnimName = 'Umb_Damage';
    }
    else if (PawnOwner.CurrentDmgStrength == 4 || PawnOwner.CurrentDmgStrength == 3)
    {
        AnimCfg_Animation.AnimationNames[0] = 'AliceW_StauePose_Throw';
        UmbrellaAnimName = 'Umb_Throw';
    }
}

function bool CanChainMove(ESpecialMove NextMove)
{
    return false;
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
    SpecialMoveEnded(PrevMove, NextMove);
    if (NextMove != 46 && PawnOwner.CurrentDmgStrength == 4 || PawnOwner.CurrentDmgStrength == 3)
    {
        AlicePawn(PawnOwner).ActivateShieldBlocking(false);
        AlicePawn(PawnOwner).FadeOutUmbrella();
        AlicePawn(PawnOwner).FadeInWeapon();
        PCOwner.OnDeactivateShieldBlocking();
    }
    PawnOwner.StopConfigAnim(AnimCfg_Animation, BlendOutTime);
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
    SpecialMoveStarted(bForced, PrevMove);
    GetAnimation();
    PawnOwner.PlayConfigAnim(AnimCfg_Animation);
    AlicePawn(PawnOwner).UmbrellaInstance.PlayWeaponSlotAnim(UmbrellaAnimName, , false);
}

defaultproperties
{
    AnimCfg_Animation=(AnimationNames=("AliceW_StauePose_Damage"),BlendNodeIndex="EABLIdx_Slot_FullBody_Main",AnimType=0,BlendInTime=0.15,BlendOutTime=0.15,PlayRate=1.0,bLoop=False,bCauseActorAnimEnd=True,bTriggerFakeRootMotion=False,bNotExtendAnimTimeForFakeRootMotion=False,AnimPlayType="ECAPT_RandomPickupOne",RootBoneTransitionOption="RBA_Translate",RootBoneTransitionOption[1]="RBA_Translate",RootBoneTransitionOption[2]="RBA_Default",RootBoneRotationOption="RRO_Default",RootBoneRotationOption[1]="RRO_Default",RootBoneRotationOption[2]="RRO_Default",FakeRootMotionMode="RMM_Accel",AnimationDescName="")
    bDisableMovement=True
    bStopAtLedges=True
    UseCustomRMM=True
    RMMInAction="RMM_Accel"
}

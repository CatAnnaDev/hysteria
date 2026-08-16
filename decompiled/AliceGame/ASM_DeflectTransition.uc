class ASM_DeflectTransition extends AliceSpecialMove
    notplaceable;

var() AnimationParaConfig AnimCfg_Animation;
var transient AlicePawn Alice;
var transient bool bStart;

function PlayEnd()
{
    AnimCfg_Animation.BlendOutTime = 0.3;
    AnimCfg_Animation.AnimationNames[0] = 'AliceW_StauePose_Out';
    PawnOwner.PlayConfigAnim(AnimCfg_Animation);
    AlicePawn(PawnOwner).UmbrellaInstance.PlayWeaponSlotAnim('Umb_Out', , false);
}

function PlayStart()
{
    AlicePawn(PawnOwner).ActivateShieldBlocking(true);
    AlicePawn(PawnOwner).FadeOutWeapon();
    AlicePawn(PawnOwner).FadeInUmbrella();
    AnimCfg_Animation.BlendOutTime = 0.05;
    AnimCfg_Animation.AnimationNames[0] = 'AliceW_StauePose_In';
    PawnOwner.PlayConfigAnim(AnimCfg_Animation);
    AlicePawn(PawnOwner).UmbrellaInstance.PlayWeaponSlotAnim('Umb_In', , false);
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
    SpecialMoveEnded(PrevMove, NextMove);
    PawnOwner.StopConfigAnim(AnimCfg_Animation, BlendOutTime);
    if (!bStart)
    {
        WeaponForAlice(PawnOwner.Weapon).SendDeactiveMeleeAttackMessage();
        PCOwner.DelayNextDeflect();
        if (!AlicePawn(PawnOwner).bHoldingWatch && NextMove != 45)
        {
            AlicePawn(PawnOwner).FadeInWeapon();
        }
        AlicePawn(PawnOwner).ActivateShieldBlocking(false);
        AlicePawn(PawnOwner).FadeOutUmbrella();
    }
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
    Alice = AlicePawn(PawnOwner);
    bStart = false;
    if (Alice != none && !Alice.bInShield)
    {
        bStart = true;
        AlicePawn(PawnOwner).StopWeaponParticleTrail();
        WeaponForAlice(PawnOwner.Weapon).CleanInfoWhenBreak();
    }
    SpecialMoveStarted(bForced, PrevMove);
    if (bStart)
    {
        PlayStart();
    }
    else
    {
        PlayEnd();
    }
}

defaultproperties
{
    AnimCfg_Animation=(AnimationNames=("AliceW_StauePose_In"),BlendNodeIndex="EABLIdx_Slot_FullBody_Main",AnimType=0,BlendInTime=0.05,BlendOutTime=0.0,PlayRate=1.0,bLoop=False,bCauseActorAnimEnd=True,bTriggerFakeRootMotion=False,bNotExtendAnimTimeForFakeRootMotion=False,AnimPlayType="ECAPT_RandomPickupOne",RootBoneTransitionOption="RBA_Default",RootBoneTransitionOption[1]="RBA_Default",RootBoneTransitionOption[2]="RBA_Default",RootBoneRotationOption="RRO_Default",RootBoneRotationOption[1]="RRO_Default",RootBoneRotationOption[2]="RRO_Default",FakeRootMotionMode="RMM_Accel",AnimationDescName="")
    bDisableMovement=True
    bCanRepeat=True
}

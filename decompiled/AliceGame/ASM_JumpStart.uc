class ASM_JumpStart extends AliceSpecialMove
    native
    notplaceable;

var() AnimationParaConfig AnimCfg_JumpStart;
var() AnimationParaConfig AnimCfg_JumpRising;
var() AnimationParaConfig AnimCfg_Jumping;
var() AnimationParaConfig AnimCfg_Landing;
var() float PreLandTime;
var Emitter JumpParticleEmitter;
var transient float ApexZ;
var transient bool bLandOutOfControl;

function BlendOutForNextAnim()
{
    if (PCOwner.IsInState('PlayerFloat'))
    {
        BlendOutTime = 1.25;
    }
}

function AnimCfg_AnimEndNotify(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
    if (PawnOwner.CurrentJumpStatus == 1)
    {
        PlayRise();
    }
    else if (PawnOwner.CurrentJumpStatus == 2)
    {
        PlayFall();
    }
    else if (PawnOwner.CurrentJumpStatus == 4)
    {
        PawnOwner.EndSpecialMove();
    }
}

event Landed()
{
    PlayLand();
    PCOwner.OnSMLaned();
}

function StopLand()
{
    PawnOwner.StopConfigAnim(AnimCfg_Landing, BlendOutTime);
}

function PlayLand()
{
    GetLandAnimationInAir();
    if (bLandOutOfControl)
    {
        SetMovementLock(true);
    }
    PawnOwner.CurrentJumpStatus = 4;
    PawnOwner.PlayConfigAnim(AnimCfg_Landing);
    PCOwner.MyAlicePawn.SetAliceAbilityCamera(PCOwner.MyAlicePawn.JumpCamera, true, !PCOwner.MyAlicePawn.bIsSprinting);
}

function StopFall()
{
    PawnOwner.StopConfigAnim(AnimCfg_Jumping, BlendOutTime);
}

function PlayFall()
{
    GravityScale = 1.0;
    PawnOwner.JumpFallingTime = 0.0;
    PawnOwner.CurrentJumpStatus = 3;
    PawnOwner.PlayConfigAnim(AnimCfg_Jumping);
    ApexZ = PawnOwner.Location.Z;
    bLandOutOfControl = false;
}

function StopRise()
{
    PawnOwner.StopConfigAnim(AnimCfg_JumpRising, BlendOutTime);
}

function PlayRise()
{
    AlicePawn(PawnOwner).bJustLeaveHover = false;
    PawnOwner.Velocity = PawnOwner.PendingVelocity;
    GravityScale = 1.0;
    PawnOwner.CurrentJumpStatus = 2;
    PawnOwner.PlayConfigAnim(AnimCfg_JumpRising);
    if (!PCOwner.bShrinkingModeActive)
    {
        PCOwner.MyAlicePawn.SetAliceAbilityCamera(PCOwner.MyAlicePawn.JumpCamera, false, true);
    }
}

function StopJump()
{
    PawnOwner.StopConfigAnim(AnimCfg_JumpStart, BlendOutTime);
}

function PlayJump()
{
    GravityScale = 0.0;
    PawnOwner.CurrentJumpStatus = 1;
    PawnOwner.PlayConfigAnim(AnimCfg_JumpStart);
    PawnOwner.PlaySound(AlicePawn(PawnOwner).JumpCue);
    AlicePawn(PawnOwner).bAfterHoverJump = false;
}

function StopCurrentMoveType()
{
    switch (PawnOwner.CurrentJumpStatus)
    {
        case 1:
            StopJump();
            break;
        case 2:
            StopRise();
            break;
        case 3:
            StopFall();
            break;
        case 4:
            StopLand();
            break;
        default:
    }
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
    SpecialMoveEnded(PrevMove, NextMove);
    BlendOutForNextAnim();
    StopCurrentMoveType();
    PCOwner.bJumpFromJumpPad = false;
    PawnOwner.CurrentJumpStatus = 0;
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
    SpecialMoveStarted(bForced, PrevMove);
    GetAnimations();
    if (PrevMove == 37)
    {
        AnimCfg_Jumping.BlendInTime = 0.2;
    }
    AlicePawn(PawnOwner).ClearTimerToHideWeapon();
    if (!PCOwner.bTargetingModeActive)
    {
        AlicePawn(PawnOwner).FadeOutWeapon();
    }
    if (PCOwner != none && PCOwner.bPressedJump || PCOwner.stuckManager.isStucking() || PCOwner == none)
    {
        PlayJump();
        PawnOwner.FirstJumpTap = PawnOwner.WorldInfo.TimeSeconds;
        PCOwner.onAliceJump();
    }
    else
    {
        PlayFall();
    }
}

function GetAnimations()
{
    local bool bInLondon;
    local float VelocitySize;
    
    bInLondon = AlicePawn(PawnOwner).bInLondon;
    VelocitySize = VSize2D(PawnOwner.PendingVelocity);
    AnimCfg_Jumping.BlendInTime = 0.5;
    AnimCfg_Landing.RootBoneTransitionOption[0] = 1;
    AnimCfg_Landing.RootBoneTransitionOption[1] = 1;
    if (bInLondon)
    {
        if (VelocitySize > float(1))
        {
            AnimCfg_JumpStart.AnimationNames[0] = 'AliceL_JumpFwd_Start';
            AnimCfg_JumpRising.AnimationNames[0] = 'AliceL_JumpFwd_Rise';
            AnimCfg_Jumping.AnimationNames[0] = 'AliceL_JumpFwd_Fall';
            AnimCfg_Landing.AnimationNames[0] = 'AliceL_JumpFwd_LandLow';
        }
        else
        {
            AnimCfg_JumpStart.AnimationNames[0] = 'AliceL_Jump_Start';
            AnimCfg_JumpRising.AnimationNames[0] = 'AliceL_Jump_Rise';
            AnimCfg_Jumping.AnimationNames[0] = 'AliceL_Jump_Fall';
            AnimCfg_Landing.AnimationNames[0] = 'AliceL_Jump_Land';
        }
    }
    else
    {
        if (PCOwner.bJustAfterFloatFail)
        {
            AnimCfg_Jumping.BlendInTime = 0.0;
            PCOwner.bJustAfterFloatFail = false;
        }
        if (VelocitySize > float(1))
        {
            AnimCfg_JumpStart.AnimationNames[0] = 'AliceW_JumpFwd_Start';
            AnimCfg_JumpRising.AnimationNames[0] = 'AliceW_JumpFwd_Rise';
            AnimCfg_Jumping.AnimationNames[0] = 'AliceW_JumpFwd_Fall';
            AnimCfg_Landing.AnimationNames[0] = 'AliceW_JumpFwd_LandLow';
        }
        else
        {
            AnimCfg_JumpStart.AnimationNames[0] = 'AliceW_Jump_Start';
            AnimCfg_JumpRising.AnimationNames[0] = 'AliceW_Jump_Rise';
            AnimCfg_Jumping.AnimationNames[0] = 'AliceW_Jump_Fall';
            AnimCfg_Landing.AnimationNames[0] = 'AliceW_Jump_Land';
        }
    }
}

function GetLandAnimationInAir()
{
    local bool bInLondon;
    local float VelocitySize, AccelSize, JumpHeight;
    
    bInLondon = AlicePawn(PawnOwner).bInLondon;
    VelocitySize = VSize2D(PawnOwner.Velocity);
    AccelSize = VSize(PawnOwner.Acceleration);
    JumpHeight = ApexZ - PawnOwner.Location.Z;
    if (VelocitySize > float(1) && AccelSize > float(1))
    {
        if (bInLondon)
        {
            AnimCfg_Landing.AnimationNames[0] = 'AliceL_JumpFwd_LandLow';
        }
        else
        {
            bLandOutOfControl = true;
            if (JumpHeight > AlicePawn(PawnOwner).HeavyFallingHeight)
            {
                AnimCfg_Landing.AnimationNames[0] = 'AliceW_JumpFwd_Land_Medium';
            }
            else if (JumpHeight > AlicePawn(PawnOwner).MediumFallingHeight)
            {
                AnimCfg_Landing.AnimationNames[0] = 'AliceW_JumpFwd_Land_Medium';
                AnimCfg_Landing.RootBoneTransitionOption[0] = 2;
                AnimCfg_Landing.RootBoneTransitionOption[1] = 2;
            }
            else
            {
                AnimCfg_Landing.AnimationNames[0] = 'AliceW_JumpFwd_LandLow';
                bLandOutOfControl = false;
            }
        }
    }
    else if (AccelSize <= 0.1)
    {
        if (bInLondon)
        {
            AnimCfg_Landing.AnimationNames[0] = 'AliceL_Jump_Land';
        }
        else
        {
            bLandOutOfControl = true;
            if (JumpHeight > AlicePawn(PawnOwner).HeavyFallingHeight)
            {
                AnimCfg_Landing.AnimationNames[0] = 'AliceW_Jump_Land_Medium';
            }
            else if (JumpHeight > AlicePawn(PawnOwner).MediumFallingHeight)
            {
                AnimCfg_Landing.AnimationNames[0] = 'AliceW_Jump_Land_Medium';
                AnimCfg_Landing.RootBoneTransitionOption[0] = 2;
                AnimCfg_Landing.RootBoneTransitionOption[1] = 2;
            }
            else
            {
                AnimCfg_Landing.AnimationNames[0] = 'AliceW_Jump_Land';
                bLandOutOfControl = false;
            }
        }
    }
}

defaultproperties
{
    AnimCfg_JumpStart=(AnimationNames=("AliceW_Jump_Start"),BlendNodeIndex="EABLIdx_Slot_FullBody_Main",AnimType=0,BlendInTime=0.1,BlendOutTime=0.1,PlayRate=1.0,bLoop=False,bCauseActorAnimEnd=True,bTriggerFakeRootMotion=False,bNotExtendAnimTimeForFakeRootMotion=False,AnimPlayType="ECAPT_RandomPickupOne",RootBoneTransitionOption="RBA_Discard",RootBoneTransitionOption[1]="RBA_Discard",RootBoneTransitionOption[2]="RBA_Discard",RootBoneRotationOption="RRO_Default",RootBoneRotationOption[1]="RRO_Default",RootBoneRotationOption[2]="RRO_Default",FakeRootMotionMode="RMM_Accel",AnimationDescName="")
    AnimCfg_JumpRising=(AnimationNames=("AliceW_Jump_Rise"),BlendNodeIndex="EABLIdx_Slot_FullBody_Main",AnimType=0,BlendInTime=0.1,BlendOutTime=0.1,PlayRate=1.0,bLoop=False,bCauseActorAnimEnd=True,bTriggerFakeRootMotion=False,bNotExtendAnimTimeForFakeRootMotion=False,AnimPlayType="ECAPT_RandomPickupOne",RootBoneTransitionOption="RBA_Discard",RootBoneTransitionOption[1]="RBA_Discard",RootBoneTransitionOption[2]="RBA_Discard",RootBoneRotationOption="RRO_Default",RootBoneRotationOption[1]="RRO_Default",RootBoneRotationOption[2]="RRO_Default",FakeRootMotionMode="RMM_Accel",AnimationDescName="")
    AnimCfg_Jumping=(AnimationNames=("AliceW_Jump_Fall"),BlendNodeIndex="EABLIdx_Slot_FullBody_Main",AnimType=0,BlendInTime=0.1,BlendOutTime=0.0,PlayRate=1.0,bLoop=True,bCauseActorAnimEnd=True,bTriggerFakeRootMotion=False,bNotExtendAnimTimeForFakeRootMotion=False,AnimPlayType="ECAPT_RandomPickupOne",RootBoneTransitionOption="RBA_Discard",RootBoneTransitionOption[1]="RBA_Discard",RootBoneTransitionOption[2]="RBA_Discard",RootBoneRotationOption="RRO_Default",RootBoneRotationOption[1]="RRO_Default",RootBoneRotationOption[2]="RRO_Default",FakeRootMotionMode="RMM_Accel",AnimationDescName="")
    AnimCfg_Landing=(AnimationNames=("AliceW_Jump_Land"),BlendNodeIndex="EABLIdx_Slot_FullBody_Main",AnimType=0,BlendInTime=0.1,BlendOutTime=0.1,PlayRate=1.0,bLoop=False,bCauseActorAnimEnd=True,bTriggerFakeRootMotion=False,bNotExtendAnimTimeForFakeRootMotion=False,AnimPlayType="ECAPT_RandomPickupOne",RootBoneTransitionOption="RBA_Discard",RootBoneTransitionOption[1]="RBA_Discard",RootBoneTransitionOption[2]="RBA_Discard",RootBoneRotationOption="RRO_Default",RootBoneRotationOption[1]="RRO_Default",RootBoneRotationOption[2]="RRO_Default",FakeRootMotionMode="RMM_Accel",AnimationDescName="")
    PreLandTime=0.1
    bCanRepeat=True
}

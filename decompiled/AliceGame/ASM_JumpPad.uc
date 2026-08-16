class ASM_JumpPad extends AliceSpecialMove
    native
    notplaceable;

var() AnimationParaConfig AnimCfg_JumpStart;
var() AnimationParaConfig AnimCfg_JumpRising;
var() AnimationParaConfig AnimCfg_Jumping;
var() AnimationParaConfig AnimCfg_Landing;
var() float PreLandTime;
var Emitter JumpParticleEmitter;

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
}

function StopLand()
{
    PawnOwner.StopConfigAnim(AnimCfg_Landing, BlendOutTime);
}

function PlayLand()
{
    PawnOwner.CurrentJumpStatus = 4;
    PawnOwner.PlayConfigAnim(AnimCfg_Landing);
    PCOwner.MyAlicePawn.SetAliceAbilityCamera(PCOwner.MyAlicePawn.JumpPadsCamera, true);
}

function StopFall()
{
    PawnOwner.StopConfigAnim(AnimCfg_Jumping, BlendOutTime);
}

event PlayFall()
{
    GravityScale = 1.0;
    PawnOwner.JumpFallingTime = 0.0;
    PawnOwner.CurrentJumpStatus = 3;
    PawnOwner.PlayConfigAnim(AnimCfg_Jumping);
}

function StopRise()
{
    PawnOwner.StopConfigAnim(AnimCfg_JumpRising, BlendOutTime);
}

function PlayRise()
{
    PawnOwner.Velocity = PawnOwner.PendingVelocity;
    GravityScale = 1.0;
    PawnOwner.CurrentJumpStatus = 2;
    PawnOwner.PlayConfigAnim(AnimCfg_JumpRising);
    PCOwner.MyAlicePawn.SetAliceAbilityCamera(PCOwner.MyAlicePawn.JumpPadsCamera, false, !PCOwner.bShrinkingModeActive);
}

function StopJump()
{
    PawnOwner.StopConfigAnim(AnimCfg_JumpStart, BlendOutTime);
}

function PlayJump()
{
    local Vector FootLoc;
    
    FootLoc = PawnOwner.Mesh.GetBoneLocation('Bip01-L-Foot', 0);
    GravityScale = 0.0;
    PawnOwner.CurrentJumpStatus = 1;
    PawnOwner.PlayConfigAnim(AnimCfg_JumpStart);
    JumpParticleEmitter = PawnOwner.Spawn(class'Engine.EmitterSpawnable', PawnOwner, , FootLoc);
    if (JumpParticleEmitter != none)
    {
        if (AlicePawn(PawnOwner).bInLondon == true)
        {
            JumpParticleEmitter.SetTemplate(ParticleSystem'GFX_Alice.Jump.JumpLiftOff_L', true);
        }
        else
        {
            JumpParticleEmitter.SetTemplate(ParticleSystem'GFX_Alice.Jump.JumpLiftOff_W', true);
        }
        JumpParticleEmitter.SetLocation(FootLoc);
    }
    PawnOwner.PlaySound(AlicePawn(PawnOwner).JumpCue);
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
    StopCurrentMoveType();
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
    SpecialMoveStarted(bForced, PrevMove);
    AlicePawn(PawnOwner).ClearTimerToHideWeapon();
    AlicePawn(PawnOwner).FadeOutWeapon();
    GetAnimations();
    PlayRise();
}

function GetAnimations()
{
    local bool bInLondon;
    
    bInLondon = AlicePawn(PawnOwner).bInLondon;
    if (bInLondon)
    {
        if (VSize2D(PawnOwner.PendingVelocity) > float(1))
        {
            AnimCfg_JumpStart.AnimationNames[0] = 'AliceL_JumpFwd_Start';
            AnimCfg_JumpStart.BlendInTime = 0.1;
            AnimCfg_JumpStart.BlendOutTime = 0.1;
            AnimCfg_JumpRising.AnimationNames[0] = 'AliceL_Pad_Jump_Raise_C';
            AnimCfg_JumpRising.BlendInTime = 0.1;
            AnimCfg_JumpRising.BlendOutTime = 0.2;
            AnimCfg_Jumping.AnimationNames[0] = 'AliceL_Pad_Jump_Fall';
            AnimCfg_Jumping.BlendInTime = 0.2;
            AnimCfg_Landing.AnimationNames[0] = 'AliceL_Pad_Jump_Land';
            AnimCfg_Landing.BlendInTime = 0.1;
            AnimCfg_Landing.BlendOutTime = 0.1;
            AnimCfg_JumpStart.RootBoneTransitionOption[0] = 1;
            AnimCfg_Landing.RootBoneTransitionOption[0] = 1;
        }
        else
        {
            AnimCfg_JumpStart.AnimationNames[0] = 'AliceL_Jump_Start';
            AnimCfg_JumpRising.AnimationNames[0] = 'AliceL_Pad_Jump_Raise_C';
            AnimCfg_Jumping.AnimationNames[0] = 'AliceL_Pad_Jump_Fall';
            AnimCfg_Landing.AnimationNames[0] = 'AliceL_Pad_Jump_Land';
            AnimCfg_JumpStart.RootBoneTransitionOption[0] = 2;
            AnimCfg_JumpStart.RootBoneTransitionOption[2] = 2;
            AnimCfg_JumpStart.BlendInTime = 0.1;
            AnimCfg_Landing.BlendOutTime = 0.1;
        }
    }
    else if (VSize2D(PawnOwner.PendingVelocity) > float(1))
    {
        AnimCfg_JumpStart.AnimationNames[0] = 'AliceW_JumpFwd_Start';
        AnimCfg_JumpStart.BlendInTime = 0.1;
        AnimCfg_JumpStart.BlendOutTime = 0.1;
        AnimCfg_JumpRising.AnimationNames[0] = 'AliceW_Pad_Jump_Raise_C';
        AnimCfg_JumpRising.BlendInTime = 0.1;
        AnimCfg_JumpRising.BlendOutTime = 0.2;
        AnimCfg_Jumping.AnimationNames[0] = 'AliceW_Pad_Jump_Fall';
        AnimCfg_Jumping.BlendInTime = 1.0;
        AnimCfg_Landing.AnimationNames[0] = 'AliceW_Pad_Jump_Land';
        AnimCfg_Landing.BlendInTime = 0.1;
        AnimCfg_Landing.BlendOutTime = 0.1;
        AnimCfg_JumpStart.RootBoneTransitionOption[0] = 1;
        AnimCfg_Landing.RootBoneTransitionOption[0] = 1;
    }
    else
    {
        AnimCfg_JumpStart.AnimationNames[0] = 'AliceW_Jump_Start';
        AnimCfg_JumpRising.AnimationNames[0] = 'AliceW_Pad_Jump_Raise_C';
        AnimCfg_Jumping.AnimationNames[0] = 'AliceW_Pad_Jump_Fall';
        AnimCfg_Landing.AnimationNames[0] = 'AliceW_Pad_Jump_Land';
        AnimCfg_JumpStart.RootBoneTransitionOption[0] = 2;
        AnimCfg_JumpStart.RootBoneTransitionOption[2] = 2;
        AnimCfg_JumpStart.BlendInTime = 0.1;
        AnimCfg_Landing.BlendOutTime = 0.1;
    }
}

defaultproperties
{
    AnimCfg_JumpStart=(AnimationNames=("Alice_Jump_Start"),BlendNodeIndex="EABLIdx_Slot_FullBody_Main",AnimType=0,BlendInTime=0.0,BlendOutTime=0.0,PlayRate=1.0,bLoop=False,bCauseActorAnimEnd=True,bTriggerFakeRootMotion=False,bNotExtendAnimTimeForFakeRootMotion=False,AnimPlayType="ECAPT_RandomPickupOne",RootBoneTransitionOption="RBA_Default",RootBoneTransitionOption[1]="RBA_Default",RootBoneTransitionOption[2]="RBA_Default",RootBoneRotationOption="RRO_Default",RootBoneRotationOption[1]="RRO_Default",RootBoneRotationOption[2]="RRO_Default",FakeRootMotionMode="RMM_Accel",AnimationDescName="")
    AnimCfg_JumpRising=(AnimationNames=("AliceW_Pad_Jump_Raise_C"),BlendNodeIndex="EABLIdx_Slot_FullBody_Main",AnimType=0,BlendInTime=0.0,BlendOutTime=0.0,PlayRate=1.0,bLoop=True,bCauseActorAnimEnd=True,bTriggerFakeRootMotion=False,bNotExtendAnimTimeForFakeRootMotion=False,AnimPlayType="ECAPT_RandomPickupOne",RootBoneTransitionOption="RBA_Default",RootBoneTransitionOption[1]="RBA_Default",RootBoneTransitionOption[2]="RBA_Default",RootBoneRotationOption="RRO_Default",RootBoneRotationOption[1]="RRO_Default",RootBoneRotationOption[2]="RRO_Default",FakeRootMotionMode="RMM_Accel",AnimationDescName="")
    AnimCfg_Jumping=(AnimationNames=("AliceW_Pad_Jump_Fall"),BlendNodeIndex="EABLIdx_Slot_FullBody_Main",AnimType=0,BlendInTime=0.0,BlendOutTime=0.0,PlayRate=1.0,bLoop=True,bCauseActorAnimEnd=True,bTriggerFakeRootMotion=False,bNotExtendAnimTimeForFakeRootMotion=False,AnimPlayType="ECAPT_RandomPickupOne",RootBoneTransitionOption="RBA_Default",RootBoneTransitionOption[1]="RBA_Default",RootBoneTransitionOption[2]="RBA_Default",RootBoneRotationOption="RRO_Default",RootBoneRotationOption[1]="RRO_Default",RootBoneRotationOption[2]="RRO_Default",FakeRootMotionMode="RMM_Accel",AnimationDescName="")
    AnimCfg_Landing=(AnimationNames=("AliceW_Pad_Jump_Land"),BlendNodeIndex="EABLIdx_Slot_FullBody_Main",AnimType=0,BlendInTime=0.0,BlendOutTime=0.0,PlayRate=1.0,bLoop=False,bCauseActorAnimEnd=True,bTriggerFakeRootMotion=False,bNotExtendAnimTimeForFakeRootMotion=False,AnimPlayType="ECAPT_RandomPickupOne",RootBoneTransitionOption="RBA_Default",RootBoneTransitionOption[1]="RBA_Default",RootBoneTransitionOption[2]="RBA_Default",RootBoneRotationOption="RRO_Default",RootBoneRotationOption[1]="RRO_Default",RootBoneRotationOption[2]="RRO_Default",FakeRootMotionMode="RMM_Accel",AnimationDescName="")
    PreLandTime=0.1
    bCanRepeat=True
}

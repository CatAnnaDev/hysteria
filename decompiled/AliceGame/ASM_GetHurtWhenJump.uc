class ASM_GetHurtWhenJump extends AliceSpecialMove
    native
    notplaceable;

var() AnimationParaConfig AnimCfg_Start;
var() AnimationParaConfig AnimCfg_Fall;
var() AnimationParaConfig AnimCfg_Land;
var() float PreLandTime;

function AnimCfg_AnimEndNotify(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
    if (PawnOwner.CurrentJumpStatus == 2)
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
    PawnOwner.StopConfigAnim(AnimCfg_Land, BlendOutTime);
}

function PlayLand()
{
    PawnOwner.CurrentJumpStatus = 4;
    PawnOwner.PlayConfigAnim(AnimCfg_Land);
    PCOwner.MyAlicePawn.SetAliceAbilityCamera(PCOwner.MyAlicePawn.JumpCamera, true, !PCOwner.MyAlicePawn.bIsSprinting);
}

function StopFall()
{
    PawnOwner.StopConfigAnim(AnimCfg_Fall, BlendOutTime);
}

function PlayFall()
{
    GravityScale = 1.0;
    PawnOwner.JumpFallingTime = 0.0;
    PawnOwner.CurrentJumpStatus = 3;
    PawnOwner.PlayConfigAnim(AnimCfg_Fall);
}

function StopStart()
{
    PawnOwner.StopConfigAnim(AnimCfg_Start, BlendOutTime);
}

function PlayStart()
{
    GravityScale = 1.0;
    PawnOwner.CurrentJumpStatus = 2;
    PawnOwner.PlayConfigAnim(AnimCfg_Start);
}

function StopCurrentMoveType()
{
    switch (PawnOwner.CurrentJumpStatus)
    {
        case 2:
            StopStart();
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
    if (PawnOwner.PreviousSpecialMove == 50)
    {
        PCOwner.GotoState('PlayerWalking');
        PCOwner.bJumpFromJumpPad = false;
    }
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
    SpecialMoveStarted(bForced, PrevMove);
    GetAnimations();
    PawnOwner.Velocity.Z = 0.0;
    PlayStart();
}

function GetAnimations()
{
    AnimCfg_Start.AnimationNames[0] = 'AliceW_Jump_Damage_A';
    AnimCfg_Fall.AnimationNames[0] = 'AliceW_Jump_Damage_B';
    AnimCfg_Land.AnimationNames[0] = 'AliceW_Jump_Damage_C';
}

defaultproperties
{
    AnimCfg_Start=(AnimationNames=("AliceW_Jump_Damage_A"),BlendNodeIndex="EABLIdx_Slot_FullBody_Main",AnimType=0,BlendInTime=0.0,BlendOutTime=0.0,PlayRate=1.0,bLoop=False,bCauseActorAnimEnd=True,bTriggerFakeRootMotion=False,bNotExtendAnimTimeForFakeRootMotion=False,AnimPlayType="ECAPT_RandomPickupOne",RootBoneTransitionOption="RBA_Default",RootBoneTransitionOption[1]="RBA_Default",RootBoneTransitionOption[2]="RBA_Default",RootBoneRotationOption="RRO_Default",RootBoneRotationOption[1]="RRO_Default",RootBoneRotationOption[2]="RRO_Default",FakeRootMotionMode="RMM_Accel",AnimationDescName="")
    AnimCfg_Fall=(AnimationNames=("AliceW_Jump_Damage_B"),BlendNodeIndex="EABLIdx_Slot_FullBody_Main",AnimType=0,BlendInTime=0.0,BlendOutTime=0.0,PlayRate=1.0,bLoop=True,bCauseActorAnimEnd=True,bTriggerFakeRootMotion=False,bNotExtendAnimTimeForFakeRootMotion=False,AnimPlayType="ECAPT_RandomPickupOne",RootBoneTransitionOption="RBA_Default",RootBoneTransitionOption[1]="RBA_Default",RootBoneTransitionOption[2]="RBA_Default",RootBoneRotationOption="RRO_Default",RootBoneRotationOption[1]="RRO_Default",RootBoneRotationOption[2]="RRO_Default",FakeRootMotionMode="RMM_Accel",AnimationDescName="")
    AnimCfg_Land=(AnimationNames=("AliceW_Jump_Damage_C"),BlendNodeIndex="EABLIdx_Slot_FullBody_Main",AnimType=0,BlendInTime=0.0,BlendOutTime=0.0,PlayRate=1.0,bLoop=False,bCauseActorAnimEnd=True,bTriggerFakeRootMotion=False,bNotExtendAnimTimeForFakeRootMotion=False,AnimPlayType="ECAPT_RandomPickupOne",RootBoneTransitionOption="RBA_Default",RootBoneTransitionOption[1]="RBA_Default",RootBoneTransitionOption[2]="RBA_Default",RootBoneRotationOption="RRO_Default",RootBoneRotationOption[1]="RRO_Default",RootBoneRotationOption[2]="RRO_Default",FakeRootMotionMode="RMM_Accel",AnimationDescName="")
    PreLandTime=0.1
    bDisableMovement=True
    bForceGod=True
}

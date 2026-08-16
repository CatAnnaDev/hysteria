class ASM_GrabLedge_SwitchToAnotherLedge extends AliceSpecialMove
    native
    notplaceable;

var() AnimationParaConfig AnimCfg_Animation;
var transient bool bStartMoving;
var transient Vector RotOrigin;
var transient Vector RotStart;
var transient float RotRadius;
var transient float RotAngle;

native final function SetCurrentLedgeVolume()
{
}

function GetAnimationForLedge()
{
    if (PawnOwner.OnLedge != none)
    {
        switch (PawnOwner.OnLedge.VolumeType)
        {
            case 0:
                AnimCfg_Animation.RootBoneTransitionOption[0] = 1;
                AnimCfg_Animation.RootBoneTransitionOption[1] = 1;
                AnimCfg_Animation.AnimationNames[0] = 'Alice_Ledge_StrafLeft';
                break;
            default:
        }
    }
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
    SpecialMoveEnded(PrevMove, NextMove);
    bStartMoving = false;
    PawnOwner.bSwitchToAnotherLedge = false;
    SetCurrentLedgeVolume();
    PawnOwner.StopConfigAnim(AnimCfg_Animation, 0.0);
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
    SpecialMoveStarted(bForced, PrevMove);
    GetRotParameters();
    GetAnimationForLedge();
    bStartMoving = true;
    PawnOwner.PlayConfigAnim(AnimCfg_Animation);
}

native function GetRotParameters()
{
}

defaultproperties
{
    AnimCfg_Animation=(AnimationNames=("Alice_Ledge_StrafLeft"),BlendNodeIndex="EABLIdx_Slot_FullBody_Main",AnimType=0,BlendInTime=0.0,BlendOutTime=0.0,PlayRate=1.0,bLoop=False,bCauseActorAnimEnd=True,bTriggerFakeRootMotion=False,bNotExtendAnimTimeForFakeRootMotion=False,AnimPlayType="ECAPT_RandomPickupOne",RootBoneTransitionOption="RBA_Default",RootBoneTransitionOption[1]="RBA_Default",RootBoneTransitionOption[2]="RBA_Default",RootBoneRotationOption="RRO_Default",RootBoneRotationOption[1]="RRO_Default",RootBoneRotationOption[2]="RRO_Default",FakeRootMotionMode="RMM_Accel",AnimationDescName="")
    GravityScale=0.0
    bDisableMovement=True
    bDisableCollision=True
}

class ASM_DoubleJump extends ASM_JumpStart
    notplaceable;

var bool bTurnLeft;
var ParticleSystem DoubleJumpLeftPS;
var ParticleSystem DoubleJumpRightPS;

function PlayParticle()
{
    local ParticleSystem PS;
    local Emitter DoubleJumpParticleEmitter;
    
    PS = (bTurnLeft ? DoubleJumpLeftPS : DoubleJumpRightPS);
    DoubleJumpParticleEmitter = PCOwner.Spawn(class'Engine.EmitterSpawnable', PCOwner, , PCOwner.MyAlicePawn.Location);
    if (DoubleJumpParticleEmitter != none)
    {
        DoubleJumpParticleEmitter.SetTemplate(PS, true);
        DoubleJumpParticleEmitter.SetLocation(PCOwner.MyAlicePawn.Location);
    }
}

function GetAnimations()
{
    bTurnLeft = (RandRange(-1.0, 1.0) > float(0) ? true : false);
    if (bTurnLeft)
    {
        AnimCfg_JumpStart.AnimationNames[0] = 'AliceW_JumpD_Rgt_Start';
        AnimCfg_JumpRising.AnimationNames[0] = 'AliceW_JumpD_Rgt_Rise';
        AnimCfg_Jumping.AnimationNames[0] = 'AliceW_JumpD_Rgt_Fall';
        AnimCfg_Landing.AnimationNames[0] = 'AliceW_JumpD_Rgt_Land';
    }
    else
    {
        AnimCfg_JumpStart.AnimationNames[0] = 'AliceW_JumpD_Lft_Start';
        AnimCfg_JumpRising.AnimationNames[0] = 'AliceW_JumpD_Lft_Rise';
        AnimCfg_Jumping.AnimationNames[0] = 'AliceW_JumpD_Lft_Fall';
        AnimCfg_Landing.AnimationNames[0] = 'AliceW_JumpD_Lft_Land';
    }
    AnimCfg_JumpStart.BlendInTime = 0.1;
    AnimCfg_JumpStart.BlendOutTime = 0.1;
    AnimCfg_JumpRising.BlendInTime = 0.1;
    AnimCfg_JumpRising.BlendOutTime = 0.1;
    AnimCfg_Jumping.BlendInTime = 0.1;
    AnimCfg_Landing.BlendInTime = 0.1;
    AnimCfg_Landing.BlendOutTime = 0.1;
    AnimCfg_JumpStart.RootBoneTransitionOption[0] = 1;
    AnimCfg_Landing.RootBoneTransitionOption[0] = 1;
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
    SpecialMoveStarted(bForced, PrevMove);
    GetAnimations();
    PlayRise();
    PlayParticle();
}

function PlayRise()
{
    AlicePawn(PawnOwner).bJustLeaveSteam = false;
    PawnOwner.PendingVelocity = PawnOwner.Velocity;
    GravityScale = 1.0;
    PawnOwner.CurrentJumpStatus = 2;
    PawnOwner.PlayConfigAnim(AnimCfg_JumpRising);
    PCOwner.MyAlicePawn.SetAliceAbilityCamera(PCOwner.MyAlicePawn.JumpCamera, false, !PCOwner.bShrinkingModeActive);
    PawnOwner.PlaySound(AlicePawn(PawnOwner).JumpCue);
}

defaultproperties
{
    DoubleJumpLeftPS="GFX_Alice.Jump.DoubleJump_Left"
    DoubleJumpRightPS="GFX_Alice.Jump.DoubleJump_Right"
    bRestoreMovementAfterMove=False
}

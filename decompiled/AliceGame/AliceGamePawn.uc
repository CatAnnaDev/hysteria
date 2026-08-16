class AliceGamePawn extends GamePawn
    native
    notplaceable
    config(Game)
    hidecategories(Navigation);

enum EPawnDamageCollisionMode
{
    EPawnDamageCollisionMode_BodyCylinderComponent,
    EPawnDamageCollisionMode_BonesAABB,
    EPawnDamageCollisionMode_BonesShapes,
};

enum EDodgeDirection
{
    EDD_None,
    EDD_Forward,
    EDD_Back,
    EDD_Left,
    EDD_Right,
};

enum EJumpStatus
{
    EMT_None,
    EMT_Jump,
    EMT_Rise,
    EMT_Fall,
    EMT_Land,
};

enum ESlideState
{
    ESlideState_Normal,
    ESlideState_Forward,
    ESlideState_Backward,
    ESlideState_Left,
    ESlideState_Right,
};

enum ESwimState
{
    ESS_Idle,
    ESS_SlowSwim,
    ESS_SwimUnderwater,
    ESS_TurnLeft,
    ESS_TurnRight,
    ESS_SwimUp,
    ESS_SwimDown,
    ESS_SwimToLeft,
    ESS_SwimToRight,
    ESS_IdleToSwim,
    ESS_TurnBack180FromLeft,
    ESS_TurnBack180FromRight,
    ESS_TurnDown90,
    ESS_TurnUp90,
    ESS_SwimToIdle,
};

enum EChangeDirOnLedge
{
    ECDL_None,
    ECDL_ToLeft,
    ECDL_ToRight,
    ECDL_Inverse,
};

enum ECarryState
{
    ECarryState_Idle,
    ECarryState_CarryWalk,
    ECarryState_Idle_Below,
    ECarryState_CarryWalk_Below,
};

enum ERadialPushPullState
{
    ERadialPushPullState_Idle,
    ERadialPushPullState_Push,
    ERadialPushPullState_Pull,
};

enum EPushState
{
    EPushState_Idle,
    EPushState_Push,
    EPushState_Left,
    EPushState_Right,
    EPushState_Pull,
};

enum ELedgeBalancingDir
{
    ELBD_None,
    ELBD_ToLeft,
    ELBD_ToRight,
};

enum ELedgeJumpDir
{
    ELJD_None,
    ELJD_Up,
    ELJD_Left,
    ELJD_Right,
    ELJD_Back,
};

enum ERotateState
{
    ERotateState_Left_90,
    ERotateState_Left_180,
    ERotateState_Right_180,
    ERotateState_Right_90,
    ERotateState_None,
};

enum EMovementState
{
    EMS_Idle,
    EMS_Walk,
    EMS_Run,
    EMS_Sprint,
    EMS_Rotate,
    EMS_Brake,
    EMS_UsingCommLink,
    EMS_Swim,
};

enum ESpecialMove
{
    SM_None,
    SM_Brake,
    SM_Rotate,
    SM_PHYS_Trans_Jump,
    SM_PHYS_Trans_DoubleJump,
    SM_PHYS_Trans_GrabLedge_WhenJump,
    SM_PHYS_Trans_GrabLedge_JumpToAnotherLedge,
    SM_PHYS_Trans_GrabLedge_SwitchToAnotherLedge,
    SM_PHYS_Trans_GrabLedge_DropToLedge,
    SM_PHYS_Trans_GrabLedge_DropFromLedge,
    SM_PHYS_Trans_GrabLedge_ClimbOverLedge,
    SM_ChangeDirOnLedge,
    SM_COMBO_begin,
    SM_MeleeComboCommon,
    SM_GiantAliceComboMeleeAttack1,
    SM_GiantAliceComboMeleeAttack2,
    SM_GiantAliceComboMeleeAttack3,
    SM_COMBO_end,
    SM_GiantAliceStompAttack,
    SM_Range_begin,
    SM_TeapotCannonFire,
    SM_TeapotCannonCharge,
    SM_EyeStaffFire,
    SM_EyeStaffNoAmmo,
    SM_EyeStaffDoubleFire,
    SM_EyeStaffDoubleFireReady,
    SM_EyeStaffRAStopWindUp,
    SM_EyeStaffCharge,
    SM_EyeStaffChargeComplete,
    SM_Range_end,
    SM_NonLock_Combat_Begin,
    SM_VorpalBladeNLMeleeAttack,
    SM_HobbyHorseNLMeleeAttack,
    SM_NonLock_Combat_End,
    SM_VorpalBladeClone_Complete,
    SM_Combat_Detonate,
    SM_Combat_Disarm,
    SM_Combat_Dodge,
    SM_Combat_JumpForward,
    SM_Combat_ShieldBreakingPrepare,
    SM_Combat_ShieldBreakingDash,
    SM_Combat_GetHurt,
    SM_Combat_GetHurtWhenJump,
    SM_Combat_HitShieldReaction,
    SM_Combat_BeingGrabbed,
    SM_Combat_GetNPCAttached,
    SM_Combat_DeflectTransition,
    SM_Combat_BlockReaction,
    SM_Combat_DeflectSpin,
    SM_JumpPad,
    SM_JumpPadPhysics,
    SM_PHYS_Trans_GrabLedge_FallFromBalanceBeamToClimb,
    SM_Toggle_Shrink,
    SM_SlideToTarget,
    SM_SlideBackwardTarget,
    SM_Context,
    SM_IdleToSwim,
    SM_SteamVentUp,
    SM_SteamVentIdle,
    SM_SteamVentBackward,
    SM_SteamVentForward,
    SM_SteamVentLeft,
    SM_SteamVentRight,
    SM_FloatFail,
    SM_HoverJump,
    SM_HoverHit,
    SM_Hysteria,
    SM_Dead,
    SM_Respawn,
    SM_BrustOutFromFlower,
};

enum EAnimConfigType
{
    EACT_None,
    EACT_Arbitrary,
    EACT_TakeDamage,
};

enum EAnimBlendNodeIndex
{
    EABLIdx_Slot_FullBody_Main,
    EABLIdx_Slot_HalfBody_Upper_Main,
    EABLIdx_PerBone_BlendUpperLower_Main,
    EABLIdx_Slot_Combat_Upper_Additive,
    EABLIdx_Slot_Combat_Lower_Additive,
    EABLIdx_Slot_Combat_HoldWatch_Additive,
};

enum EConfigAnimPlayType
{
    ECAPT_RandomPickupOne,
    ECAPT_OneByOne,
};

enum EBasePawnStance
{
    EBPS_Stand,
    EBPS_Combat,
    EBPS_Attached,
    EBPS_Climb,
    EBPS_Swim,
    EBPS_Slide,
    EBPS_Float,
    EBPS_Frozen,
};

struct native PhysicsImpactRBRemap
{
    var() name RB_FromName;
    var() name RB_ToName;
};

struct native SMStruct
{
    var ESpecialMove SpecialMove;
    var AliceGamePawn InteractionPawn;
    var int Flags;
};

struct native AnimationParaConfig
{
    var() array<name> AnimationNames;
    var() EAnimBlendNodeIndex BlendNodeIndex;
    var() int AnimType;
    var() float BlendInTime;
    var() float BlendOutTime;
    var() float PlayRate;
    var() bool bLoop;
    var() bool bCauseActorAnimEnd;
    var() bool bTriggerFakeRootMotion;
    var() bool bNotExtendAnimTimeForFakeRootMotion;
    var() EConfigAnimPlayType AnimPlayType;
    var() ERootBoneAxis RootBoneTransitionOption[3];
    var() ERootRotationOption RootBoneRotationOption[3];
    var() ERootMotionMode FakeRootMotionMode;
    var() editoronly string AnimationDescName;
};

struct native WeaponPara
{
    var() class<Weapon> WeaponClass;
    var() bool bAvailable;
    var() name DefaultAttachedSocketName;
    var() array<PhysicsAsset> CollisionPhysicsAssets;
    var() Weapon WeaponArcheType;
    var() int ComponentIndex;
    var() float WeaponMeleeRange;
    var() name RangeAttackSocket;
    var() array<name> RangeAttackSocketArray;
    var() Projectile ProjectileArchetype;
    var() bool bCannotBeShieldByAlice;
};

var() array<WeaponPara> WeaponParas;
var() int testvalue;
var EBasePawnStance PawnStance;
var EBasePawnStance PrevPawnStance;
var ESpecialMove SpecialMove;
var ESpecialMove PreviousSpecialMove;
var EMovementState BasicMovementState;
var ERotateState RotateState;
var EJumpStatus CurrentJumpStatus;
var EJumpStatus CurrentDodgeStatus;
var ELedgeJumpDir LedgeJumpDir;
var EChangeDirOnLedge ChangeDirOnLedge;
var ELedgeBalancingDir LedgeBalancingDirection;
var EPhysics PendingPhysics;
var EDodgeDirection DodgeDir;
var ESwimState SwimState;
var EPawnTypeFootStep PawnType;
var transient ESpeechPriority CurrentSpeechPriority;
var() EPawnDamageCollisionMode PawnDamageCollisionModeFilter;
var transient EDamageStrengthType CurrentDmgStrength;
var array<AliceGameAnimNode_BlendBase> AnimBlendNodes;
var() int AnimBlendNodeNum;
var AnimationParaConfig KismetAnimConfig;
var transient float KismetBackupPerBoneBlendWeight;
var SMStruct PendingSpecialMoveStruct;
var transient bool bEndingSpecialMove;
var() const bool bTranslateMeshByCollisionHeight;
var bool bDisableMeshTranslationChanges;
var bool bIsBraking;
var bool bIsTurning;
var bool bIsRunningJump;
var bool bTurningWhileRunning;
var bool bInJumpPad;
var transient bool bFacingALedge;
var bool bFacingLedgeDir;
var bool bIgnoredTriggerLedgeVolume;
var bool bJumpWithinALedgeVolume;
var bool bReadyToClimbUpLedge;
var bool bReadyToJumpToVerticleLedge;
var bool bReadyToJumpToHorizentalLedge;
var bool bReadyToJumpBackward;
var bool bReadyToDropFromLedge;
var bool bReadyToDropToClimbLedgeWhenWalking;
var bool bReadyToSwitchDirection;
var bool bJumpToAnotherLedge;
var bool bJumpToAnotherLedge_Landing;
var bool bChangeDirOnLedge;
var transient bool bSwitchToAnotherLedge;
var transient bool bSwitchLeftToLedge;
var bool bStandOnBalanceBeam;
var bool bClimbOnLeftSideOfBalanceBeam;
var bool FallToClimbBalanceBeam;
var bool bAutoSnappingToLedge;
var bool FirstSnappingToLedge;
var bool SecondSnappingToLedge;
var bool bReadyToAutoClimb;
var bool bIsPreparingClimbingLedge;
var bool bPlayingTransitionAnim;
var bool DoPendingPhysics;
var bool bSlideJump;
var bool bCanLunge;
var bool bWantToLeaveSwim;
var bool bEndSwimState;
var bool bInWaterWalk;
var bool bWaterWalkInited;
var bool bNeedSwimToTarget;
var transient bool bSpeaking;
var() bool bDebugSpeech;
var bool bForceDesiredRotation;
var bool ActivateRumbleOnWeaponHit;
var(HitReactions) bool bCanPlayPhysicsHitReactions;
var(HitReactions) bool bEnableHitReactionBoneSprings;
var bool bPainCausing;
var bool bKnockBack;
var bool bInvincible;
var bool bOnlyOnce;
var transient bool bCanBeGrabbed;
var transient bool bGrabbing;
var transient bool bBeingGrabbed;
var transient bool bGrabAlignBoxPositionReached;
var(SlideOff) bool bEnableFakeConeCollision;
var(SlideOff) bool bDrawFakeCone;
var transient bool bRotatePawnWhenDamage;
var bool bBeginCountFallingTime;
var array<class<AliceSpecialMove>> SpecialMoveClasses;
var transient array<AliceSpecialMove> SpecialMoves;
var AliceGamePawn InteractionPawn;
var int SpecialMoveFlags;
var array<ESpecialMove> PawnToPawnInteractionList;
var Vector SpecialMoveLocation;
var const float MeshTranslationNudgeOffset;
var transient AnimTree AnimTreeRootNode;
var transient float SlideFriction;
var() float MaxWalkingSpeed;
var() float MaxRunningSpeed;
var() float DoubleJumpZ;
var() float DelayToAllowDoubleJump;
var float RotSpeedFactor;
var() float RotSpeedFactorInAir;
var float AngleToRotate;
var const float RotAnimationLength;
var(RotateAnim) float AngleToFastTurn;
var transient float JumpFallingTime;
var LedgeVolume OnLedge;
var LedgeVolume OldLedge;
var LadderVolume OldLadder;
var float StartJumpHeight;
var(LedgeGrab) float SpeedOnCommonLedge;
var(LedgeGrab) float SpeedOnLadderLedge;
var(LedgeGrab) float SpeedOnBalanceBeam;
var(LedgeGrab) float SpeedOnWallEdge;
var LedgeVolume LedgeToJump;
var transient LedgeVolume LedgeToSwitchTo;
var float LeaningFactor;
var(LedgeGrab) float LeaningFactorThresholdToFallFromBalanceBeam;
var(LedgeGrab) float TimeWithoutFallFromBalanceBeamCheck;
var(LedgeGrab) int AutoSnappingAngularSpeed;
var LedgeVolume LedgeToAutoSnap;
var Vector LocLedgeEndToSnap;
var Rotator RotLedgeEndToSnap;
var float RotTimeAccumulated;
var int FirstAutoSnapYaw;
var int SecondAutoSnapYaw;
var(LedgeGrab) float SearchRadiusOfALedgeEnd;
var transient float AutoClimbTeleportHeight;
var float CollisionHeightLedgeClimbing;
var float CollisionRadiusLedgeClimbing;
var(LedgeGrab) float LedgeJumpInitialVelocity;
var(LedgeGrab) float HorizontalLedgeJumpMaxDistance;
var(LedgeGrab) float VerticalLedgeJumpMaxDistance;
var(LedgeGrab) float ForwardJumpMaxDistance;
var(LedgeGrab) const float MinAutoClimbHeight;
var(LedgeGrab) const float MaxAutoClimbHeight;
var Actor PendingFloor;
var Vector PendingFloorV;
var Vector PendingVelocity;
var(Slide) float SlideSpeed;
var float EntrySwimStateTime;
var float LeaveSwimStateTime;
var float waterSurfaceHeight;
var(swim) float SwimSpeed;
var(WaterWalk) float WaterWalkSpeedWalk;
var(WaterWalk) float WaterWalkSpeedRun;
var(WaterWalk) float WaterWalkJumpHeight;
var(WaterWalk) float WaterWalkGravityZ;
var(FootStepInfoID) int FootStepInfoID;
var transient array<AliceGameAnimNode_BlendBySlot> AliceGameMATSlotNodes;
var JumpPad JumpPad;
var AnimationParaConfig AnimCfg_GestureAnim;
var(Speak) float SpeakRotateRate;
var SpeakLineParamStruct ReplicatedSpeakLineParams;
var SpeakLineParamStruct QueuedSpeakLineParams;
var SpeakLineParamStruct CurrentSpeakLineParams;
var export editinline AudioComponent CurrentlySpeakingLine;
var float SpeechPitchMultiplier;
var array<SkelControlLookAt> HeadControl;
var Actor HeadLookAtActor;
var name HeadLookAtBoneName;
var() array<PhysicsAsset> CollisionPhysicsAssets;
var transient int CurrentCollisionPhysicsAssetID;
var ForceFeedbackWaveform attackForceFeedback;
var float PawnSyncRandFloatSlot0;
var float PawnSyncRandFloatSlot1;
var float PawnSyncRandFloatSlot2;
var() array<SkelMeshActorControlTarget> ControlTargets;
var(HitReactions) editinline array<name> PhysicsBodyImpactBoneList;
var float PhysicsImpactBlendTimeToGo;
var(HitReactions) float PhysicsHitReactionImpulseScale;
var(HitReactions) float PhysicsImpactBlendOutTime;
var(HitReactions) float PhysicsImpactMassEffectScale;
var(HitReactions) Vector2D PhysHRMotorStrength;
var(HitReactions) Vector2D PhysHRSpringStrength;
var transient float fStartingPhysicsWeight;
var(HitReactions) editinline array<PhysicsImpactRBRemap> PhysicsImpactRBRemapTable;
var(HitReactions) editinline array<name> PhysicsImpactSpringList;
var float PainInterval;
var float DamagePerSec;
var Actor DirectionActor;
var float KnockBackScale;
var float KnockBackTotalTime;
var SeqVar_Float SeqVarDamageFloat;
var(Damage) float InvincibleTime;
var float FirstJumpTap;
var(Grabbed) float TimeDelayToNextBeGrabbed;
var transient float fTimeInterpolationGrabAlignBoxPosition;
var transient float fMaxTimeInterpolationGrabAlignBoxPosition;
var transient AliceGamePawn GrabberPawn;
var transient name AnimSeq_BeGrabbed;
var transient Vector GrabAlignLocation;
var transient Vector StartGrabLocation;
var name AlignBoxBoneName;
var float FakeCollisionConeRadius;
var float FakeCollisionConeHeight;
var(SlideOff) float RatioOfConeRadiusAndHeight;
var(SlideOff) float ConeRadiusScale;
var StaticMesh ConeCollisionMesh;
var export editinline StaticMeshComponent ConeCollisionComponent;
var transient Vector DamageDir;
var float ContinueFallingTime;
var delegate<DecalTrace> __DecalTrace__Delegate;

function bool IsRunning()
{
    if (BasicMovementState != 0)
    {
        return true;
    }
    return false;
}

function DoSTTMiddleDuration()
{
}

function OnInInvincibleTime()
{
}

function bool IsInInvincibleState()
{
    if (IsTimerActive('OnInInvincibleTime'))
    {
        return true;
    }
    else
    {
        return false;
    }
}

function StartInvincibleState()
{
    SetTimer(InvincibleTime, false, 'OnInInvincibleTime');
}

function SetKnockBackPara()
{
    local Vector KnockBackdir;
    
    if (bKnockBack)
    {
        if (DirectionActor != none)
        {
            KnockBackdir = vector(DirectionActor.Rotation);
        }
        else
        {
            KnockBackdir = -vector(Rotation);
        }
        if (Mesh != none)
        {
            if (AbsKnockBackTotalTime >= 0.0 && AbsKnockBackScale >= 0.0)
            {
                Mesh.SetFakeRootMotionPara(AbsKnockBackScale, AbsKnockBackTotalTime, 10, rotator(KnockBackdir));
                Mesh.ActiveFakeRootMotion();
                Mesh.FakeRootMotionMode = 3;
            }
            else
            {
                Mesh.SetFakeRootMotionPara(KnockBackScale, KnockBackTotalTime, 10, rotator(KnockBackdir));
                Mesh.ActiveFakeRootMotion();
                Mesh.FakeRootMotionMode = 3;
            }
        }
    }
}

event PainTimer()
{
    if (bPainCausing && bCanBeDamaged && !IsInInvincibleState())
    {
        CausePain();
    }
}

function CausePain()
{
    if (DamagePerSec > float(0))
    {
        if (WorldInfo.bSoftKillZ && Physics != 1)
        {
            return;
        }
        TakeDamage(int(DamagePerSec * PainInterval), self.Controller, Location, vect(0.0, 0.0, 0.0), class'Engine.DamageType', , self);
        if (SeqVarDamageFloat != none)
        {
            SeqVarDamageFloat.FloatValue += DamagePerSec * PainInterval;
        }
    }
    else
    {
        HealDamage(int(-DamagePerSec * PainInterval), self.Controller, class'Engine.DamageType');
        if (SeqVarDamageFloat != none)
        {
            SeqVarDamageFloat.FloatValue += -DamagePerSec * PainInterval;
        }
    }
    SetKnockBackPara();
    if (bInvincible)
    {
        StartInvincibleState();
    }
    if (bOnlyOnce)
    {
        StopCauseDamage();
    }
}

function StopCauseDamage()
{
    bPainCausing = false;
    ClearTimer('PainTimer');
}

function SeqVar_Float GetDamageVar(SeqAct_CauseAliceDamage Action)
{
    local int I;
    
    for (I = 0; I < Action.VariableLinks.Length; I++)
    {
        if (Action.VariableLinks[I].ExpectedType == class'Engine.SeqVar_Float' && Action.VariableLinks[I].LinkedVariables.Length > 0)
        {
            return SeqVar_Float(Action.VariableLinks[I].LinkedVariables[0]);
        }
    }
}

simulated event OnCauseAliceDamage(SeqAct_CauseAliceDamage Action)
{
    if (Action.InputLinks[0].bHasImpulse)
    {
        bPainCausing = Action.bPainCausing;
        DamagePerSec = Action.DamagePerSec;
        PainInterval = Action.PainInterval;
        bKnockBack = Action.bKnockBack;
        CurrentDmgStrength = Action.KnockBackType;
        DirectionActor = Action.DirectionActor;
        bInvincible = Action.bInvincible;
        bOnlyOnce = Action.bOnlyOnce;
        KnockBackScale = Action.KnockBackParameter.KnockBackScale;
        KnockBackTotalTime = Action.KnockBackParameter.KnockBackTotalTime;
        SeqVarDamageFloat = GetDamageVar(Action);
        if (SeqVarDamageFloat != none)
        {
            SeqVarDamageFloat.FloatValue = 0.0;
        }
        if (bPainCausing)
        {
            ClearTimer('PainTimer');
            SetTimer(PainInterval, true, 'PainTimer');
        }
        else
        {
            ClearTimer('PainTimer');
        }
    }
    else if (Action.InputLinks[1].bHasImpulse)
    {
        StopCauseDamage();
    }
}

event MAT_PreAnimControl()
{
    EndSpecialMove();
}

final simulated function LeaveDecalOnPawn(Vector DecalLocation, Rotator DecalOrientation, PrimitiveComponent HitComponent, name HitBone, DecalData Decal)
{
    local MaterialInstanceTimeVarying MITV_Decal;
    
    if (Decal.WidthSK == float(0) || Decal.HeightSK == float(0))
    {
        return;
    }
    if (MaterialInstanceTimeVarying(Decal.DecalMaterial) != none)
    {
        MITV_Decal = new(none) class'Engine.MaterialInstanceTimeVarying';
        MITV_Decal.SetParent(Decal.DecalMaterial);
        WorldInfo.MyDecalManager.SpawnDecal(MITV_Decal, DecalLocation, DecalOrientation, Decal.WidthSK, Decal.HeightSK, Decal.Thickness, false, Decal.bRandomizeRotation ? FRand() * 360.0 : 0.0, HitComponent, false, true, HitBone, , , Decal.LifeSpan, , , Decal.BlendRange);
        MITV_Decal.SetScalarStartTime('FadeOut', 0.0);
    }
    else
    {
        WorldInfo.MyDecalManager.SpawnDecal(Decal.DecalMaterial, DecalLocation, DecalOrientation, Decal.WidthSK, Decal.HeightSK, Decal.Thickness, true, Decal.bRandomizeRotation ? FRand() * 360.0 : 0.0, HitComponent, false, true, HitBone, , , Decal.LifeSpan, , , Decal.BlendRange);
    }
}

final simulated function LeaveADecal(delegate<DecalTrace> DecalTraceFunc, DecalData Decal, float TraceRadius, optional bool bProjectOnTerrain = false)
{
    local Actor TraceActor;
    local Vector out_HitLocation, out_HitNormal, TraceDest, TraceStart, TraceExtent, TraceDir;
    local TraceHitInfo HitInfo;
    local MaterialInstanceTimeVarying MITV_Decal;
    
    __DecalTrace__Delegate = DecalTraceFunc;
    DecalTrace(TraceRadius, TraceStart, TraceDest, Decal.RandomRadiusOffset, TraceDir);
    __DecalTrace__Delegate = None;
    TraceActor = Trace(out_HitLocation, out_HitNormal, TraceDest, TraceStart, true, TraceExtent, HitInfo, 1);
    if (out_HitNormal.X == float(0) && out_HitNormal.Y == float(0) && out_HitNormal.Z == float(0))
    {
        return;
    }
    if (TraceDir Dot out_HitNormal > -0.087)
    {
        return;
    }
    if (TraceActor != none)
    {
        if (Decal.bIsValid && Decal.Width != float(0) && Decal.Height != float(0))
        {
            if (Decal.DecalMaterial != none)
            {
                if (MaterialInstanceTimeVarying(Decal.DecalMaterial) != none)
                {
                    MITV_Decal = new(none) class'Engine.MaterialInstanceTimeVarying';
                    MITV_Decal.SetParent(Decal.DecalMaterial);
                    WorldInfo.MyDecalManager.SpawnDecal(MITV_Decal, out_HitLocation, rotator(-out_HitNormal), Decal.Width, Decal.Height, Decal.Thickness, false, Decal.bRandomizeRotation ? FRand() * 360.0 : 0.0, HitInfo.HitComponent, bProjectOnTerrain, true, HitInfo.BoneName, , , Decal.LifeSpan, , , Decal.BlendRange);
                    MITV_Decal.SetScalarStartTime('FadeOut', 0.0);
                }
                else
                {
                    WorldInfo.MyDecalManager.SpawnDecal(Decal.DecalMaterial, out_HitLocation, rotator(-out_HitNormal), Decal.Width, Decal.Height, Decal.Thickness, true, Decal.bRandomizeRotation ? FRand() * 360.0 : 0.0, HitInfo.HitComponent, bProjectOnTerrain, true, HitInfo.BoneName, , , Decal.LifeSpan, , , Decal.BlendRange);
                }
            }
        }
    }
}

final simulated function LeaveDecal360AroundPawn(DecalData Decal, float TraceRadius)
{
    LeaveADecal(DecalTrace_360AroundPawn_Forward, Decal, TraceRadius);
    LeaveADecal(DecalTrace_360AroundPawn_Left, Decal, TraceRadius);
    LeaveADecal(DecalTrace_360AroundPawn_Backward, Decal, TraceRadius);
    LeaveADecal(DecalTrace_360AroundPawn_Right, Decal, TraceRadius);
    LeaveADecal(DecalTrace_360AroundPawn_Down, Decal, TraceRadius, true);
}

final simulated function DecalTrace_360AroundPawn_Down(float TraceRadius, out Vector out_TraceStart, out Vector out_TraceDest, const float RandomOffsetRadius, out Vector out_TraceDir, optional Vector ForceStartLocation)
{
    local Vector RandomOffsetVect;
    
    RandomOffsetVect = GetRandomOffsetVector_XY(-1.0 * RandomOffsetRadius, RandomOffsetRadius);
    out_TraceStart = Location + RandomOffsetVect;
    out_TraceDest = out_TraceStart + vect(0.0, 0.0, -1.0) * TraceRadius;
    out_TraceDir = vect(0.0, 0.0, -1.0);
}

final simulated function DecalTrace_360AroundPawn_Up(float TraceRadius, out Vector out_TraceStart, out Vector out_TraceDest, const float RandomOffsetRadius, out Vector out_TraceDir, optional Vector ForceStartLocation)
{
    local Vector RandomOffsetVect;
    
    RandomOffsetVect = GetRandomOffsetVector_XY(-1.0 * RandomOffsetRadius, RandomOffsetRadius);
    out_TraceStart = Location + RandomOffsetVect;
    out_TraceDest = out_TraceStart + vect(0.0, 0.0, 1.0) * TraceRadius;
    out_TraceDir = vect(0.0, 0.0, 1.0);
}

final simulated function DecalTrace_360AroundPawn_Backward(float TraceRadius, out Vector out_TraceStart, out Vector out_TraceDest, const float RandomOffsetRadius, out Vector out_TraceDir, optional Vector ForceStartLocation)
{
    local Vector RandomOffsetVect;
    
    RandomOffsetVect = GetRandomOffsetVector_XY(-1.0 * RandomOffsetRadius, RandomOffsetRadius);
    out_TraceStart = Location + RandomOffsetVect;
    out_TraceDest = out_TraceStart + vect(0.0, -1.0, 0.0) * TraceRadius;
    out_TraceDir = vect(0.0, -1.0, 0.0);
}

final simulated function DecalTrace_360AroundPawn_Right(float TraceRadius, out Vector out_TraceStart, out Vector out_TraceDest, const float RandomOffsetRadius, out Vector out_TraceDir, optional Vector ForceStartLocation)
{
    local Vector RandomOffsetVect;
    
    RandomOffsetVect = GetRandomOffsetVector_XY(-1.0 * RandomOffsetRadius, RandomOffsetRadius);
    out_TraceStart = Location + RandomOffsetVect;
    out_TraceDest = out_TraceStart + vect(1.0, 0.0, 0.0) * TraceRadius;
    out_TraceDir = vect(1.0, 0.0, 0.0);
}

final simulated function DecalTrace_360AroundPawn_Left(float TraceRadius, out Vector out_TraceStart, out Vector out_TraceDest, const float RandomOffsetRadius, out Vector out_TraceDir, optional Vector ForceStartLocation)
{
    local Vector RandomOffsetVect;
    
    RandomOffsetVect = GetRandomOffsetVector_XY(-1.0 * RandomOffsetRadius, RandomOffsetRadius);
    out_TraceStart = Location + RandomOffsetVect;
    out_TraceDest = out_TraceStart + vect(-1.0, 0.0, 0.0) * TraceRadius;
    out_TraceDir = vect(-1.0, 0.0, 0.0);
}

final simulated function DecalTrace_360AroundPawn_Forward(float TraceRadius, out Vector out_TraceStart, out Vector out_TraceDest, const float RandomOffsetRadius, out Vector out_TraceDir, optional Vector ForceStartLocation)
{
    local Vector RandomOffsetVect;
    
    RandomOffsetVect = GetRandomOffsetVector_XY(-1.0 * RandomOffsetRadius, RandomOffsetRadius);
    out_TraceStart = Location + RandomOffsetVect;
    out_TraceDest = out_TraceStart + vect(0.0, 1.0, 0.0) * TraceRadius;
    out_TraceDir = vect(0.0, 1.0, 0.0);
}

final simulated function Vector GetRandomOffsetVector_XY(float MinVal, float MaxVal)
{
    local Vector2D RandomOffset;
    local Vector RandomOffsetVect;
    
    RandomOffset.X = MinVal;
    RandomOffset.Y = MaxVal;
    RandomOffsetVect.X = GetRangeValueByPct(RandomOffset, FRand());
    RandomOffsetVect.Y = GetRangeValueByPct(RandomOffset, FRand());
    RandomOffsetVect.Z = GetRangeValueByPct(RandomOffset, FRand());
    return RandomOffsetVect;
}

simulated delegate DecalTrace(float TraceRadius, out Vector out_TraceStart, out Vector out_TraceDest, const float RandomOffsetRadius, out Vector out_TraceDir, optional Vector ForceStartLocation)
{
    LogInternal("DecalTrace Delegate was not set");
}

simulated function BodyImpactBlendOutNotifyPhysicsModify()
{
    Mesh.SetRBChannel(default.Mesh.RBChannel);
    Mesh.SetRBCollidesWithChannel(2, default.Mesh.RBCollideWithChannels.Pawn);
}

final simulated event BodyImpactBlendOutNotify()
{
    Mesh.PhysicsWeight = 0.0;
    PhysicsImpactBlendTimeToGo = 0.0;
    Mesh.PhysicsAssetInstance.SetAllBodiesFixed(true);
    Mesh.PhysicsAssetInstance.SetFullAnimWeightBonesFixed(false, Mesh);
    EnableSpringForImpactBones(false);
    BodyImpactBlendOutNotifyPhysicsModify();
    Mesh.bUpdateJointsFromAnimation = false;
    Mesh.PhysicsAssetInstance.SetAllMotorsAngularPositionDrive(false, false, Mesh, true);
    if (PhysicsImpactSpringList.Length > 0)
    {
        Mesh.PhysicsAssetInstance.SetNamedRBBoneSprings(false, PhysicsImpactSpringList, 0.0, 0.0, Mesh);
    }
}

final simulated function bool IsBlendingPhysicsBodyImpact()
{
    if (Mesh.PhysicsWeight > float(0) && PhysicsImpactBlendTimeToGo > float(0))
    {
        return true;
    }
    return false;
}

simulated function StartPhysicsBodyImpactPhysicsModify()
{
    Mesh.SetRBChannel(1);
    Mesh.SetRBCollidesWithChannel(2, false);
}

final simulated function StartPhysicsBodyImpact(name HitBoneName, bool bUseMotors, class<DamageType> DamageType)
{
    local bool bFoundBone;
    local int I;
    
    if (Mesh == none || Mesh.PhysicsAsset == none || Mesh.PhysicsAssetInstance == none)
    {
        LogInternal(string(WorldInfo.TimeSeconds) @ "StartPhysicsBodyImpact. Pawn is missing needed assets for Body Impact " $ string(self));
        return;
    }
    for (I = 0; I < PhysicsBodyImpactBoneList.Length; I++)
    {
        if (PhysicsBodyImpactBoneList[I] == HitBoneName)
        {
            bFoundBone = true;
            break;
        }
    }
    if (!bFoundBone)
    {
        LogInternal(string(WorldInfo.TimeSeconds) @ "StartPhysicsBodyImpact. Hit a Bone that is kinematic and not dynamic. So don't do anything HitBoneName:" @ string(HitBoneName));
        return;
    }
    Mesh.PhysicsAssetInstance.SetNamedBodiesFixed(false, PhysicsBodyImpactBoneList, Mesh, false, true);
    EnableSpringForImpactBones(true);
    StartPhysicsBodyImpactPhysicsModify();
    if (bUseMotors)
    {
        Mesh.bUpdateJointsFromAnimation = true;
        Mesh.PhysicsAssetInstance.SetAllMotorsAngularDriveParams(PhysHRMotorStrength.X, PhysHRMotorStrength.Y, 0.0, Mesh, true);
        Mesh.PhysicsAssetInstance.SetAllMotorsAngularPositionDrive(true, true, Mesh, true);
    }
    else
    {
        Mesh.bUpdateJointsFromAnimation = false;
        Mesh.PhysicsAssetInstance.SetAllMotorsAngularPositionDrive(false, false, Mesh, true);
    }
    if (bEnableHitReactionBoneSprings && PhysicsImpactSpringList.Length > 0 && Base != none && !Base.bMovable)
    {
        Mesh.PhysicsAssetInstance.SetNamedRBBoneSprings(true, PhysicsImpactSpringList, PhysHRSpringStrength.X, PhysHRSpringStrength.Y, Mesh);
    }
    Mesh.WakeRigidBody();
    fStartingPhysicsWeight = DamageType.default.default.KStartingWeight;
    Mesh.PhysicsWeight = DamageType.default.default.KStartingWeight;
    PhysicsImpactBlendTimeToGo = PhysicsImpactBlendOutTime;
}

final simulated function EnableSpringForImpactBones(bool bEnable)
{
    local int BoneIndex, I;
    local Matrix BoneMatrix;
    local RB_BodyInstance BodyInstance;
    
    if (Mesh == none)
    {
        return;
    }
    for (I = 0; I < PhysicsBodyImpactBoneList.Length; I++)
    {
        BoneIndex = Mesh.MatchRefBone(PhysicsBodyImpactBoneList[I]);
        BoneMatrix = Mesh.GetBoneMatrix(BoneIndex);
        BodyInstance = Mesh.FindBodyInstanceNamed(PhysicsBodyImpactBoneList[I]);
        if (BodyInstance != none)
        {
            BodyInstance.EnableBoneSpring(bEnable, bEnable, BoneMatrix);
        }
    }
}

final simulated function name GetPhysicsImpactRemappedBone(name InBoneName)
{
    local int I;
    
    for (I = 0; I < PhysicsImpactRBRemapTable.Length; I++)
    {
        if (PhysicsImpactRBRemapTable[I].RB_FromName == InBoneName)
        {
            return PhysicsImpactRBRemapTable[I].RB_ToName;
        }
    }
    return InBoneName;
}

final simulated function Vector GetImpactPhysicsImpulse(class<DamageType> DamageType, Vector HitLoc, Vector Momentum, out TraceHitInfo OutHitInfo, optional bool bIsHitReaction)
{
    local float TotalMass, ImpulseScale;
    local Vector BaseImpulse;
    
    if (DamageType == none || IsZero(Momentum) || DamageType.default.default.KDamageImpulse == 0.0 && DamageType.default.default.KDeathUpKick == 0.0)
    {
        if (IsZero(Momentum))
        {
            LogInternal(string(WorldInfo.TimeSeconds) @ "Zero Momentum!!!" @ string(GetFuncName()) @ "returning 0." @ "DamageType:" @ string(DamageType) @ "Momentum:" @ string(Momentum) @ "KDamageImpulse:" @ string(DamageType.default.default.KDamageImpulse) @ "KDeathUpKick:" @ string(DamageType.default.default.KDeathUpKick));
            ScriptTrace();
        }
        return vect(0.0, 0.0, 0.0);
    }
    BaseImpulse = Momentum * DamageType.default.default.KDamageImpulse;
    if (!bIsHitReaction)
    {
        BaseImpulse += VSize(Momentum) * vect(0.0, 0.0, 1.0) * DamageType.default.default.KDeathUpKick;
    }
    if (OutHitInfo.BoneName == 'None')
    {
        CheckHitInfo(OutHitInfo, Mesh, Normal(Momentum), HitLoc);
    }
    if (OutHitInfo.BoneName == 'None')
    {
        LogInternal(string(GetFuncName()) @ "No Bone to figure out damage :(");
        return BaseImpulse;
    }
    if (!bIsHitReaction)
    {
        return BaseImpulse;
    }
    if (PhysicsImpactRBRemapTable.Length > 0)
    {
        OutHitInfo.BoneName = GetPhysicsImpactRemappedBone(OutHitInfo.BoneName);
    }
    ImpulseScale = 1.0;
    if (Mesh.PhysicsAssetInstance != none)
    {
        TotalMass = Mesh.PhysicsAssetInstance.GetTotalMassBelowBone(OutHitInfo.BoneName, Mesh.PhysicsAsset, Mesh.SkeletalMesh);
        ImpulseScale = 1.0 + (TotalMass - 1.0) * PhysicsImpactMassEffectScale;
    }
    return ImpulseScale * BaseImpulse;
}

final simulated function PlayPhysicsBodyImpact(Vector HitLocation, Vector Momentum, class<DamageType> DamageType, TraceHitInfo HitInfo)
{
    local Vector BodyImpactImpulse;
    local bool bAlreadyHit;
    local float ImpactScale, CurrentHitPct;
    
    if (!bCanPlayPhysicsHitReactions || Mesh == none || Mesh.bNotUpdatingKinematicDueToDistance || Physics == 10 || bPlayedDeath || IsInState('Dying'))
    {
        return;
    }
    if (Base != none && Base.Physics == 7)
    {
        return;
    }
    if (IsDoingASpecialMove())
    {
        return;
    }
    CurrentHitPct = PhysicsImpactBlendTimeToGo / PhysicsImpactBlendOutTime;
    bAlreadyHit = CurrentHitPct > 0.0;
    BodyImpactImpulse = GetImpactPhysicsImpulse(DamageType, HitLocation, Momentum, HitInfo, true);
    if (HitInfo.BoneName != 'None' && !IsZero(BodyImpactImpulse))
    {
        ImpactScale = (bAlreadyHit ? 0.75 * (0.25 + FRand()) : 1.0);
        BodyImpactImpulse = PhysicsHitReactionImpulseScale * ImpactScale * BodyImpactImpulse;
        if (!IsHumanControlled() || !IsLocallyControlled())
        {
            BodyImpactImpulse *= 2.5;
        }
        LogInternal("  PlayPhysicsBodyImpact on Bone:" @ string(HitInfo.BoneName) @ "DamageType:" @ string(DamageType) @ "Momentum:" @ string(Momentum));
        Mesh.AddImpulse(BodyImpactImpulse, HitLocation, HitInfo.BoneName);
        StartPhysicsBodyImpact(HitInfo.BoneName, true, DamageType);
    }
}

event DoHitShieldReaction()
{
}

function DoDamageEffects(float Damage, Pawn InstigatedBy, Vector HitLocation, class<DamageType> DamageType, Vector Momentum, TraceHitInfo HitInfo)
{
}

native simulated function Vector VerifyTranslatedRootMotion(Vector DeltaMove, float DeltaTime)
{
    DeltaMove;
    DeltaTime;
}

function StopToggleLookAt()
{
    local int I;
    local SkelControlLookAt ControlLookAt;
    
    for (I = 0; I < ControlTargets.Length; I++)
    {
        ControlLookAt = SkelControlLookAt(Mesh.FindSkelControl(ControlTargets[I].ControlName));
        if (ControlLookAt != none)
        {
            ControlLookAt.SetSkelControlStrength(0.0, 1.0);
        }
    }
    ControlTargets.Remove(0, ControlTargets.Length);
}

simulated event OnHeadLookAt(SeqAct_HeadLookAt Action)
{
    local int I;
    local SkelControlLookAt ControlLookAt;
    
    if (Action.SkelControlName == 'None' || Action.TargetActors.Length == 0)
    {
        return;
    }
    if (Action.InputLinks[1].bHasImpulse)
    {
        ClearTimer('StopToggleLookAt');
        StopToggleLookAt();
        return;
    }
    for (I = 0; I < ControlTargets.Length; I++)
    {
        if (ControlTargets[I].ControlName == Action.SkelControlName)
        {
            ControlTargets[I].TargetActor = Actor(Action.TargetActors[Rand(Action.TargetActors.Length)]);
            return;
        }
    }
    ControlLookAt = SkelControlLookAt(Mesh.FindSkelControl(Action.SkelControlName));
    if (ControlLookAt != none)
    {
        ControlTargets.Length = ControlTargets.Length + 1;
        ControlTargets[ControlTargets.Length - 1].ControlName = Action.SkelControlName;
        ControlTargets[ControlTargets.Length - 1].TargetActor = Actor(Action.TargetActors[Rand(Action.TargetActors.Length)]);
        ControlLookAt.SetSkelControlStrength(1.0, 1.0);
        if (Action.LookAtDuration > 0.0)
        {
            SetTimer(Action.LookAtDuration, false, 'StopToggleLookAt');
        }
    }
}

event ResetClothHair(optional bool bResetPose = true, optional bool bResetWind = false)
{
    local HairComponent HairComponent;
    local ClothComponent ClothComponent;
    
    foreach AllOwnedComponents(class'Engine.HairComponent', HairComponent)
    {
        if (bResetPose)
        {
            HairComponent.Reset();
        }
        if (bResetWind)
        {
            HairComponent.Force = HairComponent.default.Force;
            HairComponent.Damping = HairComponent.default.Damping;
            HairComponent.PerturbAmplitude = HairComponent.default.PerturbAmplitude;
        }
    }
    foreach AllOwnedComponents(class'Engine.ClothComponent', ClothComponent)
    {
        if (bResetPose)
        {
            ClothComponent.Reset();
        }
        if (bResetWind)
        {
            ClothComponent.Force = ClothComponent.default.Force;
            ClothComponent.Damping = ClothComponent.default.Damping;
            ClothComponent.PerturbAmplitude = ClothComponent.default.PerturbAmplitude;
        }
    }
}

simulated function bool ShouldDoKnockBack(EDamageStrengthType DmgStrength)
{
    return false;
}

function CrushedBy(Pawn OtherPawn)
{
    return;
}

function gibbedBy(Actor Other)
{
    return;
}

final simulated event SpeakLineFinished()
{
    local SpeakLineParamStruct EmptyLine;
    
    bSpeaking = false;
    if (CurrentlySpeakingLine != none)
    {
        AliceGameInfo(WorldInfo.Game).SpeechManager.NotifyDialogueFinish(self, CurrentlySpeakingLine.SoundCue);
        CurrentlySpeakingLine = none;
    }
    ClearTimer('SpeakLineFinished');
    KismetFinished();
    if (HeadLookAtActor != none && HeadLookAtActor == CurrentSpeakLineParams.Addressee || HeadLookAtActor == Controller(CurrentSpeakLineParams.Addressee).Pawn)
    {
        if (CurrentSpeakLineParams.ExtraHeadTrackTime > 0.0)
        {
            SetTimer(CurrentSpeakLineParams.ExtraHeadTrackTime, false, 'DisableHeadTrack');
        }
        else
        {
            DisableHeadTrack();
        }
    }
    ReplicatedSpeakLineParams = EmptyLine;
}

simulated event KismetFinished()
{
}

simulated event KismetStarted()
{
}

simulated exec event PlaySpeechGesture(name GestureAnim)
{
    if (!IsDoingASpecialMove())
    {
        AnimCfg_GestureAnim.AnimationNames[0] = GestureAnim;
        PlayConfigAnim(AnimCfg_GestureAnim);
    }
}

native private final simulated function PlayQueuedSpeakLine()
{
}

function OnInterruptSpeech(SeqAct_InterruptSpeech Action)
{
    if (CurrentlySpeakingLine != none)
    {
        CurrentlySpeakingLine.FadeOut(0.2, 0.0);
        SpeakLineFinished();
    }
}

native private final simulated function bool ShouldFilterOutSpeech(ESpeakLineBroadcastFilter Filter, Actor Addressee)
{
    Filter;
    Addressee;
}

native private final simulated function bool ShouldSuppressSubtitlesForQueuedSpeakLine(bool bVersusMulti)
{
    bVersusMulti;
}

native final simulated function bool SpeakLine(Actor Addressee, SoundCue Audio, string DebugText, float DelaySec, optional ESpeechPriority Priority, optional ESpeechInterruptCondition IntCondition, optional bool bNoHeadTrack, optional int BroadcastFilter, optional bool bSuppressSubtitle, optional float InExtraHeadTrackTime, optional bool bClientSide)
{
    Addressee;
    Audio;
    DebugText;
    DelaySec;
    Priority;
    IntCondition;
    bNoHeadTrack;
    BroadcastFilter;
    bSuppressSubtitle;
    InExtraHeadTrackTime;
    bClientSide;
}

function bool WasPawnInAStance(const EBasePawnStance Instance)
{
    if (PrevPawnStance == Instance)
    {
        return true;
    }
    else
    {
        return false;
    }
}

function bool IsPawnInAStance(const EBasePawnStance Instance)
{
    if (PawnStance == Instance)
    {
        return true;
    }
    else
    {
        return false;
    }
}

event SetPawnStance(const EBasePawnStance Instance)
{
    PrevPawnStance = PawnStance;
    PawnStance = Instance;
}

native final simulated function bool FitCollision()
{
}

final simulated function bool SpecialMoveMessageEvent(name EventName, Object Sender)
{
    return SpecialMove != 0 && SpecialMoves[int(SpecialMove)] != none && SpecialMoves[int(SpecialMove)].MessageEvent(EventName, Sender);
}

final simulated function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
    if (PrevMove != 0)
    {
        if (SpecialMoves[int(PrevMove)] != none)
        {
            SpecialMoves[int(PrevMove)].SpecialMoveEnded(PrevMove, NextMove);
        }
    }
}

final simulated function SpecialMoveStarted(ESpecialMove NewMove, ESpecialMove PrevMove, bool bForced)
{
    local AlicePlayerController PC;
    
    if (NewMove != 0)
    {
        PC = AlicePlayerController(Controller);
        if (PC != none)
        {
            PC.SpecialMoveStarted(NewMove);
        }
        if (SpecialMoves[int(NewMove)] != none)
        {
            SpecialMoves[int(NewMove)].SpecialMoveStarted(bForced, PrevMove);
        }
        else
        {
            LogInternal("No class for special move:" @ string(NewMove) @ string(self));
        }
    }
}

simulated function SpecialMoveAssigned(ESpecialMove NewMove, ESpecialMove PrevMove)
{
    PreviousSpecialMove = PrevMove;
}

final simulated event LocalEndSpecialMove(optional ESpecialMove SpecialMoveToEnd)
{
    if (SpecialMoveToEnd == 0)
    {
        SpecialMoveToEnd = SpecialMove;
    }
    if (SpecialMoveToEnd != 0)
    {
        EndSpecialMove(SpecialMoveToEnd);
    }
}

final simulated exec function EndSpecialMove(optional ESpecialMove SpecialMoveToEnd)
{
    if (IsDoingASpecialMove())
    {
        if (SpecialMoveToEnd != 0 && PendingSpecialMoveStruct.SpecialMove == SpecialMoveToEnd)
        {
            PendingSpecialMoveStruct = FillSMStructFromParams(0);
        }
        if (SpecialMoveToEnd == 0 || IsDoingSpecialMove(SpecialMoveToEnd))
        {
            DoSpecialMove(0, true);
        }
    }
}

final simulated function bool CanChainSpecialMove(ESpecialMove NextMove)
{
    return SpecialMove == 0 || SpecialMoves[int(SpecialMove)].CanChainMove(NextMove) || SpecialMoves[int(SpecialMove)].CanOverrideMoveWith(NextMove) || SpecialMoves[int(NextMove)].CanOverrideSpecialMove(SpecialMove);
}

simulated event GetActorEyesViewPoint(out Vector out_Location, out Rotator out_Rotation)
{
    out_Location = GetPawnViewLocation();
    out_Rotation = GetViewRotation();
}

simulated event bool IsDoingDeflectSpinning()
{
    if ((IsDoingSpecialMove(46) || PreviousSpecialMove == 46) && AlicePawn(self).IsShieldBlocking() && AlicePawn(self).bCanDeflect)
    {
        return true;
    }
    return IsDoingSpecialMove(48);
}

simulated function bool IsDoingAttackSpecialMove()
{
    return IsDoingComboBlendSpecialMove() || IsDoingRangeBlendSpecialMove() || IsDoingSpecialMove(18);
}

final simulated function bool IsDoingNonLockMeleeAttackSpecialMove()
{
    return SpecialMove > 30 && SpecialMove < 33;
}

native final simulated function bool IsDoingRangeBlendSpecialMove()
{
}

native final simulated function bool IsDoingComboBlendSpecialMove()
{
}

native simulated function bool IsDoingASpecialMove()
{
}

native final simulated function bool IsDoingSpecialMove(ESpecialMove AMove)
{
    AMove;
}

native simulated function AutoSetMaterialsForAllSkelComponents(optional bool bIgnoreUserSet = false)
{
    bIgnoreUserSet;
}

final simulated event bool CanDoSpecialMove(ESpecialMove AMove, optional bool bForceCheck)
{
    if (Physics != 10 && AMove != 0 && SpecialMoveClasses.Length > int(AMove) && SpecialMoveClasses[int(AMove)] != none)
    {
        if (VerifySMHasBeenInstanced(AMove))
        {
            return CanChainSpecialMove(AMove) && SpecialMoves[int(AMove)].CanDoSpecialMove(bForceCheck);
        }
        LogInternal(string(GetFuncName()) @ "Failed with special move:" @ string(AMove) @ "class:" @ string(SpecialMoveClasses[int(AMove)]) @ string(self));
    }
    return false;
}

simulated function LocalDoSpecialMove(ESpecialMove NewMove, optional bool bForceMove = false, optional AliceGamePawn InInteractionPawn, optional int InSpecialMoveFlags = 0)
{
    if (bForceMove || CanDoSpecialMove(NewMove))
    {
        if (Controller.IsA('AlicePlayerController'))
        {
            AlicePlayerController(Controller).DoSpecialMove(NewMove, bForceMove, InInteractionPawn, InSpecialMoveFlags);
        }
        else
        {
            DoSpecialMove(NewMove, true, InInteractionPawn, InSpecialMoveFlags);
        }
    }
}

final simulated function DoSpecialMoveFromStruct(SMStruct InSpecialMoveStruct, optional bool bForceMove)
{
    DoSpecialMove(InSpecialMoveStruct.SpecialMove, bForceMove, InSpecialMoveStruct.InteractionPawn, InSpecialMoveStruct.Flags);
}

simulated event bool DoSpecialMove(ESpecialMove NewMove, optional bool bForceMove, optional AliceGamePawn InInteractionPawn, optional int InSpecialMoveFlags)
{
    local ESpecialMove PrevMove;
    local SMStruct NewMoveStruct;
    
    if (NewMove == SpecialMove && !SpecialMoves[int(NewMove)].bCanRepeat)
    {
        return false;
    }
    if (NewMove != 0 && !VerifySMHasBeenInstanced(NewMove))
    {
        WarnInternal(string(WorldInfo.TimeSeconds) @ string(self) @ string(GetFuncName()) @ "couldn't instance special move" @ string(NewMove));
        return false;
    }
    NewMoveStruct = FillSMStructFromParams(NewMove, InInteractionPawn, InSpecialMoveFlags);
    if (bEndingSpecialMove)
    {
        PendingSpecialMoveStruct = NewMoveStruct;
        return true;
    }
    if (SpecialMove != 0 && !bForceMove && NewMove != 0)
    {
        if (SpecialMoves[int(SpecialMove)].CanOverrideMoveWith(NewMove) || SpecialMoves[int(NewMove)].CanOverrideSpecialMove(SpecialMove))
        {
            bForceMove = true;
        }
        else if (SpecialMoves[int(SpecialMove)].CanChainMove(NewMove))
        {
            PendingSpecialMoveStruct = NewMoveStruct;
            return true;
        }
        else
        {
            WarnInternal(string(WorldInfo.TimeSeconds) @ string(self) @ string(GetFuncName()) @ "Cannot override, cannot chain." @ string(NewMove) @ "is lost! SpecialMove:" @ string(SpecialMove) @ "Pending:" @ SMStructToString(PendingSpecialMoveStruct));
            return false;
        }
    }
    if (NewMove != 0 && !bForceMove && !CanDoSpecialMove(NewMove))
    {
        WarnInternal(string(WorldInfo.TimeSeconds) @ string(self) @ string(GetFuncName()) @ "cannot do requested special move" @ string(NewMove));
        return false;
    }
    PrevMove = SpecialMove;
    if (SpecialMove != 0)
    {
        bEndingSpecialMove = true;
        SpecialMove = 0;
        SpecialMoveEnded(PrevMove, NewMove);
        bEndingSpecialMove = false;
    }
    SpecialMove = NewMove;
    InteractionPawn = InInteractionPawn;
    SpecialMoveFlags = InSpecialMoveFlags;
    SpecialMoveAssigned(NewMove, PrevMove);
    if (NewMove != 0)
    {
        SpecialMoveStarted(NewMove, PrevMove, bForceMove);
        if (bForceMove)
        {
            PendingSpecialMoveStruct = FillSMStructFromParams(0, none, 0);
        }
    }
    else if (PendingSpecialMoveStruct.SpecialMove != 0)
    {
        NewMoveStruct = PendingSpecialMoveStruct;
        PendingSpecialMoveStruct = FillSMStructFromParams(0, none, 0);
        DoSpecialMoveFromStruct(NewMoveStruct, false);
    }
    return true;
}

final simulated function string SpecialMoveToString(ESpecialMove InSpecialMove, AliceGamePawn InInteractionPawn, int InSpecialMoveFlags)
{
    return "[SpecialMove:" @ string(InSpecialMove) $ ", InteractionPawn:" @ string(InInteractionPawn) $ ", SpecialMoveFlags:" @ string(InSpecialMoveFlags) $ "]";
}

final simulated function string SMStructToString(SMStruct InSMStruct)
{
    return "[SpecialMove:" @ string(InSMStruct.SpecialMove) $ ", InteractionPawn:" @ string(InSMStruct.InteractionPawn) $ ", SpecialMoveFlags:" @ string(InSMStruct.Flags) $ "]";
}

final simulated function SMStruct FillSMStructFromParams(ESpecialMove InSpecialMove, optional AliceGamePawn InInteractionPawn, optional int InSpecialMoveFlags = 0)
{
    local SMStruct OutSpecialMoveStruct;
    
    OutSpecialMoveStruct.SpecialMove = InSpecialMove;
    OutSpecialMoveStruct.InteractionPawn = InInteractionPawn;
    OutSpecialMoveStruct.Flags = InSpecialMoveFlags;
    return OutSpecialMoveStruct;
}

final simulated function bool VerifySMHasBeenInstanced(ESpecialMove AMove)
{
    if (AMove != 0)
    {
        if (int(AMove) >= SpecialMoves.Length || SpecialMoves[int(AMove)] == none)
        {
            if (int(AMove) < SpecialMoveClasses.Length && SpecialMoveClasses[int(AMove)] != none)
            {
                SpecialMoves[int(AMove)] = new(Outer) SpecialMoveClasses[int(AMove)];
                SpecialMoves[int(AMove)].PawnOwner = self;
            }
            else
            {
                LogInternal(string(GetFuncName()) @ "Failed with special move:" @ string(AMove) @ "class:" @ string(SpecialMoveClasses[int(AMove)]) @ string(self));
                SpecialMoves[int(AMove)] = none;
                return false;
            }
        }
        return true;
    }
    return false;
}

simulated function ClearAnimNodes()
{
    CacheAnimNodes();
    AliceGameMATSlotNodes.Length = 0;
}

simulated function CacheAnimNodes()
{
    local AliceGameAnimNode_BlendBySlot_Pawn SlotNode;
    
    foreach Mesh.AllAnimNodes(class'AliceGameAnimNode_BlendBySlot_Pawn', SlotNode)
    {
        AliceGameMATSlotNodes[AliceGameMATSlotNodes.Length] = SlotNode;
    }
}

native function Vector GetDefaultMeshTranslation()
{
}

native simulated function SetMeshTranslationOffset(Vector NewOffset, optional bool bForce)
{
    NewOffset;
    bForce;
}

function SoundCue GetWaterSplashCue(PhysicalMaterial PhysMaterial, name AnimSeqName)
{
    local int I;
    local AlicePhysicalMaterialProperty Property;
    
    if (PhysMaterial != none && PhysMaterial.PhysicalMaterialProperty != none && AlicePhysicalMaterialProperty(PhysMaterial.PhysicalMaterialProperty) != none)
    {
        Property = AlicePhysicalMaterialProperty(PhysMaterial.PhysicalMaterialProperty);
        for (I = 0; I < Property.FootStepInfo[FootStepInfoID].AnimNotify.Length; I++)
        {
            if (Property.FootStepInfo[FootStepInfoID].AnimNotify[I].AnimSeqName == AnimSeqName)
            {
                if (Property.FootStepInfo[FootStepInfoID].AnimNotify[I].AnimSound == none)
                {
                    return Property.FootStepInfo[FootStepInfoID].DefaultSound;
                    continue;
                }
                return Property.FootStepInfo[FootStepInfoID].AnimNotify[I].AnimSound;
            }
        }
        return Property.FootStepInfo[FootStepInfoID].DefaultSound;
    }
    else
    {
        return none;
    }
}

function ParticleSystem GetWaterSplashParticle(PhysicalMaterial PhysMaterial, name AnimSeqName)
{
    local int I;
    local AlicePhysicalMaterialProperty Property;
    
    if (PhysMaterial != none && PhysMaterial.PhysicalMaterialProperty != none && AlicePhysicalMaterialProperty(PhysMaterial.PhysicalMaterialProperty) != none)
    {
        Property = AlicePhysicalMaterialProperty(PhysMaterial.PhysicalMaterialProperty);
        for (I = 0; I < Property.FootStepInfo[FootStepInfoID].AnimNotify.Length; I++)
        {
            if (Property.FootStepInfo[FootStepInfoID].AnimNotify[I].AnimSeqName == AnimSeqName)
            {
                if (Property.FootStepInfo[FootStepInfoID].AnimNotify[I].AnimParticle == none)
                {
                    return Property.FootStepInfo[FootStepInfoID].DefaultParticle;
                    continue;
                }
                return Property.FootStepInfo[FootStepInfoID].AnimNotify[I].AnimParticle;
            }
        }
        return Property.FootStepInfo[FootStepInfoID].DefaultParticle;
    }
    else
    {
        return none;
    }
}

final simulated function DisableHeadTrack(optional name SkelControlName = 'None')
{
    local SkelControlLookAt SkelControlItem;
    
    SetHeadTrackActor(none, SkelControlName);
    if (SkelControlName == 'None')
    {
        foreach HeadControl(SkelControlItem)
        {
            if (SkelControlItem != none)
            {
                SkelControlItem.SetSkelControlStrength(0.0, 1.0);
            }
        }
    }
    else
    {
        SkelControlItem = SkelControlLookAt(Mesh.FindSkelControl(SkelControlName));
        if (SkelControlItem != none)
        {
            SkelControlItem.SetSkelControlStrength(0.0, 1.0);
        }
    }
}

simulated event Vector GetHeadLookTargetLocation()
{
    local Pawn P;
    
    if (HeadLookAtActor != none)
    {
        P = Pawn(HeadLookAtActor);
        if (P != none && P.Mesh != none && HeadLookAtBoneName != 'None')
        {
            return P.Mesh.GetBoneLocation(HeadLookAtBoneName);
        }
        else
        {
            return HeadLookAtActor.Location;
        }
    }
    return Location + vector(Rotation) * 1024.0;
}

function bool SetLookAtControllerTrackActor(SkelControlLookAt SkelController, Actor ActorToTrack, optional name LookatBoneName, optional bool bEnableStrength = true)
{
    local Controller ControllerActor;
    
    if (SkelController == none)
    {
        return false;
    }
    if (ActorToTrack != none)
    {
        ControllerActor = Controller(ActorToTrack);
        if (ControllerActor != none && ControllerActor.Pawn != none)
        {
            ActorToTrack = ControllerActor.Pawn;
        }
        if (ActorToTrack != self)
        {
            HeadLookAtActor = ActorToTrack;
            SkelController.TargetLocation = GetHeadLookTargetLocation();
            if (bEnableStrength)
            {
                SkelController.SetSkelControlActive(true);
            }
            HeadLookAtBoneName = LookatBoneName;
            return true;
        }
        else
        {
            HeadLookAtActor = none;
            SkelController.SetSkelControlActive(false);
            HeadLookAtBoneName = 'None';
            return true;
        }
    }
    else
    {
        HeadLookAtActor = none;
        SkelController.SetSkelControlActive(false);
        HeadLookAtBoneName = 'None';
        return true;
    }
    return false;
}

final simulated event bool SetHeadTrackActor(Actor ActorToTrack, optional name SkelControlName = 'None', optional name LookatBoneName, optional bool bEnableStrength = true)
{
    local SkelControlLookAt SkelControlItem;
    
    if (SkelControlName == 'None')
    {
        foreach HeadControl(SkelControlItem)
        {
            if (SkelControlItem != none)
            {
                if (!SetLookAtControllerTrackActor(SkelControlItem, ActorToTrack, LookatBoneName, bEnableStrength))
                {
                    return false;
                }
            }
        }
    }
    else
    {
        SkelControlItem = SkelControlLookAt(Mesh.FindSkelControl(SkelControlName));
        SetLookAtControllerTrackActor(SkelControlItem, ActorToTrack, LookatBoneName, bEnableStrength);
    }
    return true;
}

event Swimming(float DeltaTime, int Iterations)
{
}

function SetNormalWalkParameters()
{
    WorldInfo.WorldGravityZ = WorldInfo.DefaultGravityZ;
    MaxWalkingSpeed = default.MaxWalkingSpeed;
    MaxRunningSpeed = default.MaxRunningSpeed;
}

function SetWaterWalkParameters()
{
    WorldInfo.WorldGravityZ = WaterWalkGravityZ;
    MaxWalkingSpeed = WaterWalkSpeedWalk;
    MaxRunningSpeed = WaterWalkSpeedRun;
}

function SetSwimParameters()
{
    SwimState = 0;
    if (bInWaterWalk)
    {
        bInWaterWalk = false;
    }
}

function PhysicalMaterial GetPhysMatFromTerrain(Terrain TerrainActor, Vector Loc)
{
    local int I, LayerIndex;
    local float MaxAlpha;
    local Material t_Material;
    local array<float> LayerAlphaArray;
    
    if (TerrainActor.Layers.Length == 0)
    {
        return none;
    }
    LayerIndex = 0;
    LayerAlphaArray.Length = 0;
    TerrainActor.GetLayerAlpha(Loc, LayerAlphaArray);
    MaxAlpha = 0.0;
    for (I = 0; I < LayerAlphaArray.Length; I++)
    {
        if (LayerAlphaArray[I] > MaxAlpha)
        {
            MaxAlpha = LayerAlphaArray[I];
            LayerIndex = I;
        }
    }
    if (TerrainActor.Layers[LayerIndex].Setup != none && TerrainActor.Layers[LayerIndex].Setup.Materials.Length > 0 && TerrainActor.Layers[LayerIndex].Setup.Materials[0].Material != none && TerrainActor.Layers[LayerIndex].Setup.Materials[0].Material.Material != none)
    {
        t_Material = Material(TerrainActor.Layers[LayerIndex].Setup.Materials[0].Material.Material);
        if (t_Material != none)
        {
            return t_Material.PhysMaterial;
        }
        else
        {
            return none;
        }
    }
    else
    {
        return none;
    }
}

function PhysicalMaterial GetPhysicalMaterial(Actor TraceActor, TraceHitInfo HitInfo, Vector Loc)
{
    if (TraceActor.IsA('Terrain'))
    {
        return GetPhysMatFromTerrain(Terrain(TraceActor), Loc);
    }
    else if (TraceActor.IsA('InterpActor'))
    {
        return class'AlicePhysicalMaterialProperty'.static.GetPhysMatFromInterpActor(InterpActor(TraceActor));
    }
    else if (HitInfo.PhysMaterial != none)
    {
        return HitInfo.PhysMaterial;
    }
    else
    {
        return none;
    }
}

event PlayFootStepWaterEffect(const AnimNotify_WaterEffect AnimNotifyData, const AnimNodeSequence NodeSeq)
{
    local Rotator Rot;
    local Emitter WaterImpactEmitter;
    local ParticleSystem WaterImpactParticle;
    local SoundCue WaterImpactCue;
    local TraceHitInfo HitInfo;
    local Actor TraceActor;
    local PhysicalMaterial PM, SavedPM;
    local Vector Loc, MiddleLoc, out_HitLocation, out_HitNormal, TraceDest, TraceStart, TraceExtent;
    local MaterialInstanceTimeVarying MITV_Decal;
    local DecalData DecalData;
    local float DecalRot;
    
    if (AnimNotifyData.SocketName != 'None')
    {
        if (AnimNotifyData.SocketName == 'MiddleSole')
        {
            Mesh.GetSocketWorldLocationAndRotation('LeftSole', MiddleLoc, Rot);
            Mesh.GetSocketWorldLocationAndRotation('RightSole', Loc, Rot);
            Loc = (MiddleLoc + Loc) / float(2);
        }
        else
        {
            Mesh.GetSocketWorldLocationAndRotation(AnimNotifyData.SocketName, Loc, Rot);
        }
    }
    else
    {
        return;
    }
    TraceStart = Loc + vect(0.0, 0.0, 1.0) * float(100);
    TraceDest = TraceStart + vect(0.0, 0.0, -1.0) * float(1000);
    TraceActor = Trace(out_HitLocation, out_HitNormal, TraceDest, TraceStart, true, TraceExtent, HitInfo, 8411);
    if (TraceActor != none)
    {
        PM = GetPhysicalMaterial(TraceActor, HitInfo, Loc);
        SavedPM = PM;
        if (PM != none)
        {
            WorldInfo.LogPhysMatInfo("FootStepInfo", "None", string(PM.Name));
        }
        WaterImpactParticle = GetWaterSplashParticle(PM, NodeSeq.AnimSeqName);
        while (WaterImpactParticle == none && PM != none && PM.Parent != none)
        {
            PM = PM.Parent;
            WaterImpactParticle = GetWaterSplashParticle(PM, NodeSeq.AnimSeqName);
        }
        if (WaterImpactParticle != none)
        {
            WaterImpactEmitter = Spawn(class'Engine.EmitterSpawnable', self, , out_HitLocation);
            if (WaterImpactEmitter != none)
            {
                WaterImpactEmitter.SetLocation(out_HitLocation);
                WaterImpactEmitter.SetTemplate(WaterImpactParticle, true);
            }
        }
        PM = SavedPM;
        WaterImpactCue = GetWaterSplashCue(PM, NodeSeq.AnimSeqName);
        while (WaterImpactCue == none && PM != none && PM.Parent != none)
        {
            PM = PM.Parent;
            WaterImpactCue = GetWaterSplashCue(PM, NodeSeq.AnimSeqName);
        }
        if (WaterImpactCue != none)
        {
            PlaySound(WaterImpactCue);
        }
        DecalRot = float(-Rot.Yaw) * (180.0 / 32768.0);
        PM = SavedPM;
        Loc.Z = out_HitLocation.Z;
        DecalData = class'AlicePhysicalMaterialProperty'.static.DetermineFootStepDecalData(PM, FootStepInfoID, NodeSeq.AnimSeqName);
        if (DecalData.bIsValid && DecalData.Width != float(0) && DecalData.Height != float(0))
        {
            if (DecalData.DecalMaterial != none)
            {
                if (MaterialInstanceTimeVarying(DecalData.DecalMaterial) != none)
                {
                    MITV_Decal = new(none) class'Engine.MaterialInstanceTimeVarying';
                    MITV_Decal.SetParent(DecalData.DecalMaterial);
                    WorldInfo.MyDecalManager.SpawnDecal(MITV_Decal, Loc, rotator(-out_HitNormal), DecalData.Width, DecalData.Height, DecalData.Thickness, false, DecalData.bRandomizeRotation ? FRand() * 360.0 : DecalRot, , , , , , , DecalData.LifeSpan, , , DecalData.BlendRange);
                    MITV_Decal.SetScalarStartTime('FadeOut', 0.0);
                }
                else
                {
                    WorldInfo.MyDecalManager.SpawnDecal(DecalData.DecalMaterial, Loc, rotator(-out_HitNormal), DecalData.Width, DecalData.Height, DecalData.Thickness, true, DecalData.bRandomizeRotation ? FRand() * 360.0 : DecalRot, , , , , , , DecalData.LifeSpan, , , DecalData.BlendRange);
                }
            }
        }
    }
}

function ClimbEdge(LedgeVolume L)
{
    local Vector NewLoc;
    local Rotator NewRot, CamRot;
    
    StartPreparingClimbing();
    OnLedge = L;
    if (OnLedge.VolumeType == 1)
    {
        bStandOnBalanceBeam = Location.Z > L.Location.Z;
    }
    Velocity = vect(0.0, 0.0, 0.0);
    FindoutCollisionHeightWhenClimbing(L);
    NewLoc = FindClimbLocation(L);
    SetLocation(NewLoc);
    NewRot = FindClimbRotation(L);
    SetRotation(NewRot);
    if (Controller != none)
    {
        CamRot = NewRot;
        if (OnLedge.VolumeType == 3)
        {
            CamRot = OnLedge.WallDir;
        }
        Controller.SetRotation(CamRot);
    }
    SetClimbingCollisionSize(L, CylinderComponent(default.CollisionComponent).CollisionRadius, CollisionHeightLedgeClimbing);
    if (OnLedge.VolumeType == 0)
    {
        CheckClimbingMeshTranslation();
    }
    if (bJumpToAnotherLedge)
    {
        bJumpToAnotherLedge_Landing = true;
    }
    bJumpToAnotherLedge = false;
    bAutoSnappingToLedge = false;
    FirstSnappingToLedge = false;
    SecondSnappingToLedge = false;
    SetPhysics(9);
    if (IsHumanControlled())
    {
        Controller.GotoState('PlayerClimbing');
    }
    EndPreparingClimbing();
}

function EndPreparingClimbing()
{
    bIsPreparingClimbingLedge = false;
}

function StartPreparingClimbing()
{
    bIsPreparingClimbingLedge = true;
}

function Rotator FindClimbRotation(LedgeVolume L)
{
    local Rotator NewRot;
    local Vector vLeft;
    
    if (L.VolumeType == 1)
    {
        if (bStandOnBalanceBeam)
        {
            if (vector(Rotation) Dot L.LookDir > float(0))
            {
                NewRot = rotator(L.ClimbDir);
                bFacingLedgeDir = true;
            }
            else
            {
                NewRot = rotator(-L.ClimbDir);
                bFacingLedgeDir = false;
            }
        }
        else
        {
            vLeft = L.LookDir Cross vect(0.0, 0.0, 1.0);
            if (vector(Rotation) Dot vLeft > float(0))
            {
                bClimbOnLeftSideOfBalanceBeam = true;
                NewRot = rotator(vLeft);
            }
            else
            {
                bClimbOnLeftSideOfBalanceBeam = false;
                NewRot = rotator(-vLeft);
            }
        }
    }
    else if (L.VolumeType == 3)
    {
        bFacingLedgeDir = false;
        NewRot = rotator(-L.LookDir);
    }
    else
    {
        bFacingLedgeDir = true;
        NewRot = L.WallDir;
    }
    NewRot.Pitch = 0;
    NewRot.Roll = 0;
    return NewRot;
}

function Vector FindClimbLocation(LedgeVolume L)
{
    local Vector NewLoc;
    
    NewLoc = Location;
    NewLoc.Z = L.RefLoc.Z;
    NewLoc = CalcPositionOnLedge(L);
    return NewLoc;
}

native function Vector CalcPositionOnLedge(LedgeVolume L)
{
    L;
}

function EndClimbEdge(LedgeVolume OldEdge)
{
    ResetCollisionSize();
    CheckDefaultMeshTranslation();
    bJumpWithinALedgeVolume = false;
    bIgnoredTriggerLedgeVolume = false;
    if (Physics == 9)
    {
        SetPhysics(2);
    }
}

function ResetCollisionSize()
{
    CollisionHeightLedgeClimbing = CylinderComponent(default.CollisionComponent).CollisionHeight;
    CollisionRadiusLedgeClimbing = CylinderComponent(default.CollisionComponent).CollisionRadius;
    SetCollisionSize(CylinderComponent(default.CollisionComponent).CollisionRadius, CollisionHeightLedgeClimbing);
}

function SetClimbingCollisionSize(LedgeVolume L, float Radius, float Height)
{
    if (L != none)
    {
        SetCollisionSize(Radius, Height);
    }
}

function FindoutCollisionHeightWhenClimbing(LedgeVolume L)
{
}

event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
    local int I;
    
    OnAnimEnd(SeqNode, PlayedTime, ExcessTime);
    for (I = 0; I < AnimBlendNodes.Length; I++)
    {
        if (AnimBlendNodes[I] != none)
        {
            if (SeqNode == AnimBlendNodes[I].GetCustomAnimNodeSequence())
            {
                AnimCfg_AnimEndNotify(SeqNode, PlayedTime, ExcessTime);
                return;
            }
        }
    }
}

function ClearFlagOfPlayingTransitionAnim()
{
    bPlayingTransitionAnim = false;
}

simulated function PostWeaponListInit()
{
}

simulated function WeaponListInit()
{
    local Weapon tempweapon;
    local WeaponPara tempweaponpara;
    local AliceGameWeaponBase tempWeaponBase;
    
    if (Role == 3 && InvManager != none)
    {
        tempweapon = none;
        InvManager.DiscardInventory();
        foreach WeaponParas(tempweaponpara)
        {
            if (tempweaponpara.WeaponClass != none && tempweaponpara.bAvailable)
            {
                if (tempweaponpara.WeaponArcheType != none)
                {
                    tempweapon = Spawn(tempweaponpara.WeaponClass, self, , , , tempweaponpara.WeaponArcheType);
                }
                else
                {
                    tempweapon = Spawn(tempweaponpara.WeaponClass, self);
                }
                if (tempweapon == none)
                {
                    continue;
                }
                if (WeaponForNPC(tempweapon) != none && !WeaponForNPC(tempweapon).bMeleeWeaponAbility)
                {
                    WeaponForNPC(tempweapon).ProjectileArchetype = tempweaponpara.ProjectileArchetype;
                }
                InvManager.AddInventory(tempweapon, true);
                tempWeaponBase = AliceGameWeaponBase(tempweapon);
                if (tempWeaponBase != none)
                {
                    SetWeaponParaInfo(tempWeaponBase, tempweaponpara);
                    tempWeaponBase.CacheAnimNodes();
                }
                tempWeaponBase.WeaponMeleeRange = tempweaponpara.WeaponMeleeRange;
                if (WeaponForNPC(tempweapon) != none)
                {
                    WeaponForNPC(tempweapon).bCannotBeShieldByAlice = tempweaponpara.bCannotBeShieldByAlice;
                }
            }
        }
    }
}

simulated function SetWeaponParaInfo(AliceGameWeaponBase DesiredWeapon, WeaponPara DesiredWeaponPara)
{
    if (DesiredWeaponPara.CollisionPhysicsAssets.Length > 0)
    {
        DesiredWeapon.SelfCollisionPhysicsAsset.Length = 0;
        DesiredWeapon.SelfCollisionPhysicsAsset = DesiredWeaponPara.CollisionPhysicsAssets;
        if (DesiredWeapon.Mesh != none)
        {
            DesiredWeapon.Mesh.SetPhysicsAsset(DesiredWeapon.SelfCollisionPhysicsAsset[0]);
        }
    }
}

function InitSkelControl()
{
    local AnimTree TheAnimTree;
    local SkelControlLookAt Control;
    local int I;
    
    TheAnimTree = AnimTree(Mesh.Animations);
    if (TheAnimTree != none)
    {
        for (I = 0; I < TheAnimTree.SkelControlLists.Length; I++)
        {
            Control = SkelControlLookAt(TheAnimTree.SkelControlLists[I].ControlHead);
            if (Control != none && HeadControl.Find(Control) == -1)
            {
                HeadControl.AddItem(Control);
            }
        }
    }
}

event PostBeginPlay()
{
    PostBeginPlay();
    InitSkelControl();
    CheckDefaultMeshTranslation();
    Health = (Health > HealthMax ? HealthMax : Health);
    if (CollisionPhysicsAssets.Length == 0 && Mesh.PhysicsAsset != none)
    {
        CollisionPhysicsAssets.Add(1);
        CollisionPhysicsAssets[0] = Mesh.PhysicsAsset;
    }
    CurrentCollisionPhysicsAssetID = 0;
    WeaponListInit();
    PostWeaponListInit();
    if (bEnableFakeConeCollision)
    {
        FakeCollisionConeRadius = CylinderComponent.CollisionRadius * ConeRadiusScale;
        FakeCollisionConeHeight = FakeCollisionConeRadius * RatioOfConeRadiusAndHeight;
        ConeCollisionComponent = new(self, "Cone") class'Engine.StaticMeshComponent';
        ConeCollisionComponent.SetStaticMesh(ConeCollisionMesh);
        ConeCollisionComponent.SetTranslation(vect(0.0, 0.0, 1.0) * CylinderComponent.CollisionHeight);
        ConeCollisionComponent.SetScale3D(vect(1.0, 1.0, 0.0) * FakeCollisionConeRadius / 32.0 + vect(0.0, 0.0, 1.0) * FakeCollisionConeHeight / 64.0);
        ConeCollisionComponent.SetHidden(true);
        AttachComponent(ConeCollisionComponent);
    }
}

simulated event PreBeginPlay()
{
    PreBeginPlay();
    PawnSyncRandFloatSlot0 = FRand();
    PawnSyncRandFloatSlot1 = FRand();
    PawnSyncRandFloatSlot2 = FRand();
}

function CheckClimbingMeshTranslation()
{
    local Vector vOffset;
    
    if (bTranslateMeshByCollisionHeight && default.Mesh != none)
    {
        vOffset = vect(0.0, 0.0, -1.0) * (CylinderComponent.CollisionHeight * float(3));
        default.Mesh.SetTranslation(vOffset);
        SetMeshTranslationOffset(MeshTranslationOffset, true);
    }
}

simulated function CheckDefaultMeshTranslation()
{
    local Vector vOffset;
    
    if (bTranslateMeshByCollisionHeight && default.Mesh != none)
    {
        vOffset = vect(0.0, 0.0, -1.0) * (CylinderComponent.CollisionHeight + MeshTranslationNudgeOffset);
        default.Mesh.SetTranslation(vOffset);
        SetMeshTranslationOffset(MeshTranslationOffset, true);
    }
}

simulated function AnimCfg_AnimEndNotify(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
    if (SpecialMove != 0)
    {
        SpecialMoves[int(SpecialMove)].AnimCfg_AnimEndNotify(SeqNode, PlayedTime, ExcessTime);
    }
}

simulated event ForceStopBeingGrabbed()
{
    if (!IsDoingSpecialMove(44))
    {
        return;
    }
    DoSpecialMove(0, true);
}

simulated event StartBeingGrabbed(AliceGamePawn Grabber)
{
    local AlicePlayerController APC;
    
    GrabberPawn = Grabber;
    if (GrabberPawn == none || !bCanBeGrabbed)
    {
        return;
    }
    StopAllConfigAnim(0.05);
    APC = AlicePlayerController(Controller);
    if (APC != none)
    {
        if (APC.IsInState('Grabbed'))
        {
            LogInternal("prev grabbed is not finished yet, ignore grab event this time");
            return;
        }
        if (APC.bFirstPersonViewActive)
        {
            APC.QuitFPS();
        }
        APC.GotoState('Grabbed');
    }
    SetCollision(false, false);
    bBeingGrabbed = true;
    if (APC != none && !APC.IsInState('Grabbed'))
    {
        APC.GotoState('Grabbed');
    }
    if (AnimSeq_BeGrabbed != 'None')
    {
        VerifySMHasBeenInstanced(44);
        ASM_BeGrabbed(SpecialMoves[44]).AnimCfg_Animation.AnimationNames[0] = AnimSeq_BeGrabbed;
    }
    DoSpecialMove(44, true);
}

native function float GetBottomHeight()
{
}

native function Vector GetAlignBoxBonePosition()
{
}

native function MAT_AutoReduceSlotAnimWeight(array<AnimSlotInfo> SlotInfos, float RevertTime)
{
    SlotInfos;
    RevertTime;
}

native function MAT_SetAnimWeights(array<AnimSlotInfo> SlotInfos)
{
    SlotInfos;
}

native function MAT_SetAnimPosition(name SlotName, int ChannelIndex, name InAnimSeqName, float InPosition, bool bFireNotifies, bool bLooping, int RootMotionLevel)
{
    SlotName;
    ChannelIndex;
    InAnimSeqName;
    InPosition;
    bFireNotifies;
    bLooping;
    RootMotionLevel;
}

native function StopAllConfigAnim(float BlendOutTime, optional bool bForceStop = false, optional bool bForceAnimNotify = false, optional bool bForceAnimEnd = false)
{
    BlendOutTime;
    bForceStop;
    bForceAnimNotify;
    bForceAnimEnd;
}

native function StopConfigAnim(out const AnimationParaConfig AnimConfig, float BlendOutTime, optional bool bForceStop = false, optional bool bForceAnimNotify = false, optional bool bForceAnimEnd = false)
{
    AnimConfig;
    BlendOutTime;
    bForceStop;
    bForceAnimNotify;
    bForceAnimEnd;
}

native final function bool IsPlayingConfigAnim(out const AnimationParaConfig AnimConfig)
{
    AnimConfig;
}

native final function PlayConfigAnim(out const AnimationParaConfig AnimConfig, optional int BlendNodeIndex = 0, optional int configtype = -1)
{
    AnimConfig;
    BlendNodeIndex;
    configtype;
}

native function PrepareEndingOfJumpToAnotherLedge()
{
}

native function PrepareStartingOfJumpToAnotherLedge(ELedgeJumpDir jumpDir)
{
    jumpDir;
}

native function EnableCollision(bool bEnable)
{
    bEnable;
}

native function ApplyPendingPhysics()
{
}

defaultproperties
{
    testvalue=13
    KismetAnimConfig=(AnimationNames=("None"),BlendNodeIndex="EABLIdx_Slot_FullBody_Main",AnimType=0,BlendInTime=0.0,BlendOutTime=0.0,PlayRate=1.0,bLoop=False,bCauseActorAnimEnd=False,bTriggerFakeRootMotion=False,bNotExtendAnimTimeForFakeRootMotion=False,AnimPlayType="ECAPT_RandomPickupOne",RootBoneTransitionOption="RBA_Default",RootBoneTransitionOption[1]="RBA_Default",RootBoneTransitionOption[2]="RBA_Default",RootBoneRotationOption="RRO_Default",RootBoneRotationOption[1]="RRO_Default",RootBoneRotationOption[2]="RRO_Default",FakeRootMotionMode="RMM_Accel",AnimationDescName="")
    bTranslateMeshByCollisionHeight=True
    bCanPlayPhysicsHitReactions=True
    bEnableHitReactionBoneSprings=True
    bCanBeGrabbed=True
    bEnableFakeConeCollision=True
    DoubleJumpZ=300.0
    DelayToAllowDoubleJump=0.3
    SpeedOnCommonLedge=100.0
    SpeedOnLadderLedge=200.0
    SpeedOnBalanceBeam=150.0
    SpeedOnWallEdge=100.0
    LeaningFactorThresholdToFallFromBalanceBeam=0.8
    TimeWithoutFallFromBalanceBeamCheck=0.5
    SlideSpeed=800.0
    AnimCfg_GestureAnim=(AnimationNames=("None"),BlendNodeIndex="EABLIdx_Slot_FullBody_Main",AnimType=0,BlendInTime=0.0,BlendOutTime=0.0,PlayRate=1.0,bLoop=False,bCauseActorAnimEnd=False,bTriggerFakeRootMotion=False,bNotExtendAnimTimeForFakeRootMotion=False,AnimPlayType="ECAPT_RandomPickupOne",RootBoneTransitionOption="RBA_Default",RootBoneTransitionOption[1]="RBA_Default",RootBoneTransitionOption[2]="RBA_Default",RootBoneRotationOption="RRO_Default",RootBoneRotationOption[1]="RRO_Default",RootBoneRotationOption[2]="RRO_Default",FakeRootMotionMode="RMM_Accel",AnimationDescName="")
    SpeakRotateRate=1.0
    PhysicsBodyImpactBoneList(0)="Bip01-Pelvis"
    PhysicsBodyImpactBoneList(1)="Bip01-Spine"
    PhysicsBodyImpactBoneList(2)="Bip01-Spine1"
    PhysicsBodyImpactBoneList(3)="Bip01-Head"
    PhysicsBodyImpactBoneList(4)="Bip01-Neck"
    PhysicsBodyImpactBoneList(5)="Bip01-L-Clavicle"
    PhysicsBodyImpactBoneList(6)="Bip01-L-UpperArm"
    PhysicsBodyImpactBoneList(7)="Bip01-L-Forearm"
    PhysicsBodyImpactBoneList(8)="Bip01-L-Hand"
    PhysicsBodyImpactBoneList(9)="Bip01-R-Clavicle"
    PhysicsBodyImpactBoneList(10)="Bip01-R-UpperArm"
    PhysicsBodyImpactBoneList(11)="Bip01-R-Hand"
    PhysicsBodyImpactBoneList(12)="Bip01-R-Forearm"
    PhysicsHitReactionImpulseScale=1.0
    PhysicsImpactBlendOutTime=0.45
    PhysicsImpactMassEffectScale=0.9
    PhysHRMotorStrength=(X=5000.0,Y=0.0)
    PhysHRSpringStrength=(X=5.0,Y=5.0)
    PhysicsImpactRBRemapTable(0)=(RB_FromName="Bip01-Pelvis",RB_ToName="Bip01-Spine1")
    PhysicsImpactRBRemapTable(1)=(RB_FromName="Bip01-Spine",RB_ToName="Bip01-Spine1")
    PhysicsImpactSpringList(0)="Bip01-L-Hand"
    PhysicsImpactSpringList(1)="Bip01-R-Hand"
    TimeDelayToNextBeGrabbed=0.5
    AlignBoxBoneName="Refbox_Align"
    RatioOfConeRadiusAndHeight=1.0
    ConeRadiusScale=0.8
    ConeCollisionMesh="CH_Alice.ConeCollision"
    bStopAtLedges=1
    CylinderComponent="Default__AliceGamePawn.CollisionCylinder"
    FacialAudioComp="Default__AliceGamePawn.FaceAudioComponent"
    Components(0)="Default__AliceGamePawn.Sprite"
    Components(1)="Default__AliceGamePawn.CollisionCylinder"
    Components(2)="Default__AliceGamePawn.Arrow"
    Components(3)="Default__AliceGamePawn.FaceAudioComponent"
    CollisionComponent="Default__AliceGamePawn.CollisionCylinder"
}

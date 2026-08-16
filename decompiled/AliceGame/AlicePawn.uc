class AlicePawn extends AliceGamePawn
    native
    placeable
    config(Game)
    hidecategories(Navigation);

const HysteriaWeaponLevel = 5;

enum EAliceDressLoadStep
{
    AWL_Idle,
    AWL_LoadingPackage,
    AWL_PreStreamInTexture,
    AWL_StreamingInTexture,
    AWL_FinishedLoading,
};

enum EAliceWonderlandDresses
{
    AWD_DefaultDress,
    AWD_HatterDress,
    AWD_WaterDress,
    AWD_OrientalDress,
    AWD_QueenDress,
    AWD_DollDress,
    AWD_Caterpillar,
    AWD_Cheshire,
    AWD_Chess,
    AWD_QFlesh,
    AWD_WRabbit,
    AWD_MadHatter,
};

enum ECostEnduranceType
{
    ECET_Run,
    ECET_Grab,
    ECET_Max,
};

enum AbilityCameraStyle
{
    ACS_Default,
    ACS_Manual,
    ACS_SemiAutomatic,
    ACS_Automatic,
    ACS_ShadowMode,
    ACS_StickTo,
    ACS_User,
};

struct native XPEnum
{
    var() int Easy;
    var() int Normal;
    var() int Hard;
    var() int VeryHard;
};

struct native DelayedChangeDressData
{
    var EAliceWonderlandDresses NewDress;
    var bool bShouldBlock;
    var GFxMovie pGFXMovie;
};

struct native WonderlandDress
{
    var() SkeletalMesh SkelMesh;
    var() SkeletalMesh Bow;
    var() SkeletalMesh Ribbon;
    var() SkeletalMesh Skirt;
    var() SkeletalMesh Ear;
};

struct native AttachNPCSocketInfo
{
    var() name SocketName;
    var bool bOccupied;
    var transient AliceGameKynapsePawn AttachedNPC;
    var Vector Location;
    var Rotator Rotation;
};

struct native AliceShieldInfo
{
    var() array<class<WeaponForNPC>> NoBlockingWeaponFileter;
    var() PhysicsAsset ShieldPhysicsAsset;
    var() float KnockBackDistScale;
    var() float KnockBackTimeScale;
    var() Rotator ShieldOrientRefAngle;
    var() float ShieldAreaAngle0;
    var() float ShieldAreaAngle1;
};

struct native DamageElement
{
    var() EDamageStrengthType DmgStrength;
    var() bool bKnockBack;
    var() bool bPhysicalAnim;
    var() SoundCue DamageSound;
    var() CameraAnim DamageCameraAnim;
};

struct native HealthLevel
{
    var() float HPPercentage;
    var() float RegenRate;
    var() SoundCue HealthSound;
    var() CameraAnim HealthCameraAnim;
    var() ForceFeedbackWaveform FFWaveform;
    var() bool bPlaysDamagedAnims;
    var() array<name> PPEffectName;
    var array<PostProcessEffect> PPEffects;
};

struct native WeaponFadeParEffect
{
    var() ParticleSystem EffectParticle;
    var() name SocketToPlay;
};

struct native DeathMaterials
{
    var() int MaterialID;
    var() name ParameterName;
};

struct native DeathParticles
{
    var() ParticleSystem Particle;
    var() name Socket;
    var() name Bone;
};

struct native EnduranceParams
{
    var() float TotalEndurance;
    var() float Cost[2];
    var() float Recovery;
    var() float ThresholdToRest;
};

struct native HairSimulationInfo
{
    var() export editinline Hair HairTemplate;
    var() PhysicsAsset PhysicsAsset;
    var() Vector Force;
    var() Vector PerturbAmplitude;
    var() Vector PerturbTemporalPeriod;
    var() Vector PerturbSpatialPeriod;
    var() Vector PerturbPhaseShift;
    var() float Damping;
    var() int Iteration;
    var() float LengthScale;
    var() MaterialInterface Material;
    var() int TessellationStep;
    var() float StrandWidth;
    var() Vector FloatForce;
    var() Vector FloatPerturbAmplitude;
    var() float FloatDamping;
};

struct native LockOnDOFSettings
{
    var() float FalloffExponent;
    var() float BlurKernelSize;
    var() float FocusNearInnerRadius;
    var() float FocusFarInnerRadius;
    var() float NearFocusDistance;
    var() float FarFocusDistanceOffset;
    var() float AdaptationRate;
    var bool bEnableDOF;
    var bool bEnableDynamicDoF;
    var float FarFocusDistance;
};

struct native AliceEnvironmentLockZone
{
    var Vector Center;
    var float Radius;
    var Pawn LockPawn;
};

struct native AliceCameraAnimInfo
{
    var CameraAnim Anim;
    var CameraAnimInst AnimInst;
};

struct native AliceCloseCameraProperties
{
    var() float DistanceScale;
    var() Vector Offset;
};

struct native AliceCameraProperties
{
    var() float Distance;
    var() float MaxDistance;
    var() float MinDistance;
    var() Rotator Orientation;
    var() Rotator RevolutionSpeed;
    var() Rotator InitRevolutionSpeed;
    var() float FOV;
    var() Vector Offset;
    var() CameraAnim Animation;
    var() AbilityCameraStyle BehaviorStyle;
    var() float DistScaleWhenFacingCam;
    var() float BlendTime;
    var() float RevolutionAccelTime;
    var() float RevolutionAccelExponent;
    var() float HeightUpDelay;
    var() float HeightDownDelay;
    var float LocationDelay;
    var float RotationDelay;
    var float FOVDelay;
    var float DistanceDelay;
    var float RevolutionDelay;
    var int CameraID;
};

struct native StrafeSpeed
{
    var() float Forward;
    var() float Backward;
    var() float Left;
    var() float Right;
};

var array<AliceEnvironmentLockZone> LockedZones;
var bool bCamRevolBlending;
var bool bCloseFollowCamera;
var bool bKimetAbilityCamera;
var bool bCameraPreset;
var bool bCameraMagnet;
var bool bCameraForcedStickTo;
var bool bEnableCameraMagnet;
var bool bJustPostBeginPlay;
var bool bBlendCameraPresets;
var bool bStopSettingAbilityCamera;
var bool bAliceStartCombatCam;
var bool bAliceCombatCamReady;
var bool bForceResetCamera;
var bool bSoftResetCamera;
var bool bOldSwitchTargetDelay;
var bool bSwitchTargetDelay;
var bool bCombatToStrafeCamWait;
var bool bCombatToStrafeCamBlend;
var bool bMiddleModeBlend;
var bool bOldMiddleMode;
var(LockOnMode) bool bYawOffsetRuntime;
var(LockOnMode) bool bEnableTargetOnDestroyedActor;
var(LockOnMode) bool bLockOnFromCamera;
var(LockOnMode) bool bBlockFromPawn;
var(LockOnMode) bool bBlockFromCamera;
var(LockOnMode) bool bCycleSwitch;
var(PotentialField) bool bUsePotentialField;
var(PotentialField) bool bUseCameraView;
var(Abilities) bool bCanDoubleJump;
var(Abilities) bool bCanFloat;
var(Abilities) bool bCanSprint;
var(Abilities) bool bCanCombat;
var(Abilities) bool bCanShrink;
var(Abilities) bool bCanLockon;
var(Abilities) bool bCanAiming;
var(Abilities) bool bCanShowPath;
var(Abilities) bool bCanShowCat;
var(Abilities) bool bCanEnableSonar;
var(Abilities) bool bCanClockBomb;
var(Abilities) bool bCanHysteria;
var(Abilities) bool bCanBlock;
var(Abilities) bool bCanDeflect;
var(Abilities) bool bCanDodge;
var bool bCanDoubleJumpBackupWonderLand;
var bool bCanFloatBackupWonderLand;
var bool bCanSprintBackupWonderLand;
var bool bCanCombatBackupWonderLand;
var bool bCanShrinkBackupWonderLand;
var bool bCanLockonBackupWonderLand;
var bool bCanAimingBackupWonderLand;
var bool bCanShowPathBackupWonderLand;
var bool bCanShowCatBackupWonderLand;
var bool bCanEnableSonarBackupWonderLand;
var bool bCanClockBombBackupWonderLand;
var bool bCanHysteriaBackupWonderLand;
var bool bCanBlockBackupWonderLand;
var bool bCanDeflectBackupWonderLand;
var bool bCanDodgeBackupWonderLand;
var(Abilities) bool bArchetypeWonderLand;
var() bool bUseStopMotion;
var(LockOnMode) bool bEnableNonLockOnAutoTargeting;
var(LockOnMode) bool bEnableNoNPCInCamLocking;
var transient bool bAllowFacingTargetInSpeicalMove;
var transient bool bDrawTargetCone;
var(LockOnMode) bool NoCamOffsetYWhenNoTarget;
var(LockOnMode) bool DynamicCamOffsetY;
var bool bInLockOnMode;
var bool bCommandDress;
var(ShadowMode) bool EnableShadowCameraZoom;
var bool bShrinkingModeActive;
var bool UnshrinkOnBase;
var bool bInGiantMode;
var bool bInRollingMode;
var bool bInLondon;
var(Glide) bool bHoldToTriggerFloat;
var bool bFloatDown;
var bool bInPushOrPull;
var bool bCollideWithSomething;
var bool bEnableEndurance;
var bool bUpdateEyeheight;
var bool bUsingCommLink;
var bool bWantToUseCommLink;
var bool bInCommLinkStance;
var bool bIsConversing;
var bool bWantToConverse;
var(Death) bool bUseDeathMaterial;
var bool bSwimKnockBack;
var bool bBoostingSwim;
var bool bBoostCoolDownFinished;
var bool bIdleToSwimEnd;
var bool bSwitchToSwim;
var bool bInSwimCloth;
var bool bIsSprinting;
var bool bSprintRTHold;
var bool bStopUpdating;
var(Health) bool bHasHealth;
var transient bool bClockBombCountingDown;
var transient bool bHoldingWatch;
var transient bool bClockBombIsRecharging;
var transient bool DoRootTranslationForContext;
var transient bool DoRootRotationForContext;
var transient bool bIsDoingContextAction;
var bool bIsJumping;
var bool bIsDoubleJumping;
var bool bEnableGlideCameraInertia;
var bool bGlideYawEnd;
var bool bGlidePitchEnd;
var transient bool bSlideOffPawnWhenFalling;
var bool bDeathInLondon;
var bool bShouldBeHide;
var bool bFloatFixCamera;
var bool bStepUp;
var bool bStepDown;
var bool bColdBreathActive;
var bool bBubbleEffectActive;
var bool bFloatAfterHover;
var bool bJustLeaveHover;
var bool bJustLeaveSteam;
var bool bAfterHoverJump;
var bool bInShield;
var transient bool bRollingCurrentSlide;
var transient bool bRollingSlideActive;
var transient bool bRollingSlideFast;
var transient bool bRollingCurrentSlideFast;
var bool bAttractedByCannon;
var bool bRepulsor;
var bool bOldShowBlobShadow;
var bool bJustLeaveEdge;
var bool bInHysteriaMode;
var bool bHysteriaPlaying;
var bool bHysteriaTriggered;
var bool bCanHysteriaRetrigger;
var bool bEverAboveRetriggerHealth;
var bool bMatchHysteriaModeCondition;
var bool bOnQuitHysteriaMode;
var bool bDeferredLeaveHysteriaMode;
var(Hysteria) bool bEnableHysteria;
var(Hysteria) bool bAllowToDropExpPickUp;
var(Hysteria) bool bAllowToDropHpPickUp;
var(Hysteria) bool bHysteriaGodMode;
var(Hysteria) bool bRecoverHealth;
var(Hysteria) bool bRecoverHealthAtHysterialBegin;
var(Hysteria) bool bIADuringHysteria;
var bool bDelayedChangeWonderlandDress;
var bool bIsFrozen;
var bool bInPickRadius;
var bool bExitFloatWhenMissWindow;
var bool bJumpPadHeightestPositionKeep;
var bool bShrinkFlowerEating;
var bool ShowPathTriggerParticleFinished;
var transient bool bIsDeflectSpinning;
var transient bool bTryToEndDeflectBeforeMinTime;
var() bool bNewHoverControl;
var transient bool bCanDodgeToEndGrabbed;
var bool bHasDodgeInAir;
var bool bCanPlayHurtAnim;
var transient bool bDoingTeapotCannonFireSpecialMove;
var bool bActivateHysterialAnytime;
var transient bool bDisableHPDrops;
var transient bool bSonarAlwaysVisible;
var(DLC) bool MODDLC_Flesh_DLCVB_HysterialAnytime;
var(DLC) bool MODDLC_Cheshire_DLCHH_DisableHPDrops;
var(DLC) bool MODDLC_Caterpillar_DLCVB_SonarAlwaysVisible;
var AliceCameraMagnet CurCameraMagnet;
var float CurCameraMagnetElapsedTime;
var int CurCameraMagnetRotSpeed;
var float CurCameraMagnetSpeedTime;
var float CurCameraMagnetEaseOut;
var(Camera) AliceCloseCameraProperties CloseFollowCamera;
var(Camera) float CamClosestThreshold;
var(Camera) float CameraRotationSpeed;
var(Camera) array<name> CamPPEffectNames;
var(Camera) float CamLocDelay;
var(Camera) float CamRotDelay;
var(Camera) float CamFOVDelay;
var(Camera) float CamDistDelay;
var(Camera) float CamRevolutionDelay;
var(Camera) float CamOffsetDelay;
var(Camera) float CamHeightExt;
var(Camera) float IdleCameraTimeOutDuration;
var CameraAnim IdleCameraTimeOutAnim;
var(Camera) float FPSCameraFOVOnTarget;
var(Camera) float ClosestCameraThreshold;
var float AliceFPSCameraFOV;
var float CamHeightUpDelay;
var float CamHeightDownDelay;
var float CameraElapsedBlendTime;
var float CameraBlendTime;
var float AliceCameraRevolAccelTime;
var float AliceCameraRevolAccelExponent;
var float AliceCameraDistance;
var float AliceCameraMaxDistance;
var float AliceCameraMinDistance;
var Rotator AliceCameraOrientation;
var float AliceCameraFOV;
var Vector AliceCameraOffset;
var Rotator CamRevolutionSpeed;
var AbilityCameraStyle CamBehaviorStyle;
var EGlideType GlideType;
var EPushState PushPullState;
var ERadialPushPullState RadialPushPullState;
var ECarryState CarryState;
var EAliceArcheType ArcheTypeID;
var ESlideState SlideState;
var EAliceWonderlandDresses CurWonderlandDress;
var EAliceWonderlandDresses PendingWonderlandDress;
var EAliceDressLoadStep AliceDressLoadStep;
var Rotator CamInitRevolutionSpeed;
var Vector POICameraOffset;
var float CamDistScale;
var float CamDistDelayScale;
var array<PostProcessEffect> CamPPEffects;
var Vector OldAliceCameraOffset;
var float AliceCameraDistScale;
var Vector AliceCameraExtraOffset;
var float OldCamMaxDistance;
var float OldCamMinDistance;
var float DelayedAliceCameraFOV;
var Vector OldAliceEyeLoc;
var(AbilityCameras) AliceCameraProperties IdleCamera;
var(AbilityCameras) AliceCameraProperties WalkCamera;
var(AbilityCameras) AliceCameraProperties SprintCamera;
var(AbilityCameras) AliceCameraProperties RunCamera;
var(AbilityCameras) AliceCameraProperties JumpCamera;
var(AbilityCameras) AliceCameraProperties FloatCamera;
var(AbilityCameras) AliceCameraProperties SlideCamera;
var(AbilityCameras) AliceCameraProperties SteamVentCamera;
var(AbilityCameras) AliceCameraProperties ShrinkCamera;
var(AbilityCameras) AliceCameraProperties JumpPadsCamera;
var(AbilityCameras) AliceCameraProperties PushPullCamera;
var(AbilityCameras) AliceCameraProperties CombatCamera;
var(AbilityCameras) AliceCameraProperties SwimCamera;
var(AbilityCameras) AliceCameraProperties FastSwimCamera;
var(AbilityCameras) AliceCameraProperties WaterWalkCamera;
var(AbilityCameras) AliceCameraProperties InhabitPushPullCamera;
var(AbilityCameras) AliceCameraProperties StrafeCamera;
var(AbilityCameras) AliceCameraProperties FPSCamera;
var(AbilityCameras) AliceCameraProperties DefaultCamera;
var native Pointer pCurAbilityCamera;
var native Pointer pCurCameraPreset;
var native array<Pointer> ActiveCameraPresets;
var native Pointer pPreAbilityCamera;
var(CameraPresets) AliceCameraProperties IntNormalCamera;
var(CameraPresets) AliceCameraProperties IntShrinkCamera;
var(CameraPresets) AliceCameraProperties ExtPlatformCamera;
var(CameraPresets) AliceCameraProperties ExtFarCamera;
var(CameraPresets) AliceCameraProperties ExtNearCamera;
var AliceCameraProperties BackupCamera;
var AliceCameraProperties TargetCamera;
var AliceCameraProperties PreCameraPreset;
var AliceCameraProperties CombinedCameraPreset;
var float CameraPresetBlendTimeToGo;
var ViewTargetTransitionParams CameraPresetBlendParams;
var int CurCameraPresetStyle;
var AliceCameraProperties TmpCamera;
var AliceCameraProperties TmpTargetCamera;
var(CameraAnim) CameraAnim SwimmingMinSpeedCameraAnim;
var(CameraAnim) CameraAnim SwimmingMaxSpeedCameraAnim;
var CameraAnimInst CurrentCameraAnimInst;
var CameraAnim CurrentCameraAnim;
var CameraAnim OldCameraAnim;
var array<AliceCameraAnimInfo> CameraAnimInfo;
var float OldForceResetCameraElapsedTime;
var float ForceResetCameraElapsedTime;
var float ForceResetCameraWaitTime;
var(LockOnMode) float MaxLockOnPitchDeclination;
var(LockOnMode) float MaxLockOnYawDeclination;
var(LockOnMode) float OutOfFrameRotSpeed;
var(LockOnMode) float BorderFOV;
var(LockOnMode) float LockOnCameraRotSpeed;
var(LockOnMode) float ReadjustBlendSpeed;
var(LockOnMode) float SwitchTargetBlendDelay;
var float LockOnSwitchTargetBlendTime;
var Vector OldLockOnAimTarget;
var int LockOnTargetCount;
var(LockOnMode) float CombatToStrafeCamBlendDelay;
var(LockOnMode) Vector LockOnSocketOffset;
var float CombatToStrafeCamBlendTime;
var(LockOnMode) float MiddleModeBlendTime;
var float MiddleModeBlendElapsedTime;
var(LockOnMode) float SwitchMiddleModeFOVScale;
var Vector OldLockOnTargetLoc;
var Rotator OldRotation;
var(LockOnMode) float LockOnYawOffset;
var float LockOnElapsedTime;
var(LockOnMode) float TargetOnDestroyedActorTimer;
var(LockOnMode) float LockConeAngle;
var(LockOnMode) float RSHoldSwitchDuration;
var(LockOnMode) float RTTapThreshold;
var(LockOnMode) float FOVScale;
var(LockOnMode) float MinNPCToCamDistance;
var(LockOnMode) float MaxNPCToCamDistance;
var(LockOnMode) float MinLockUIScale;
var(LockOnMode) float MaxLockUIScale;
var(PotentialField) float Zrear;
var(PotentialField) float Zfar;
var(PotentialField) float Zxyfar;
var(PotentialField) float Xfar;
var(PotentialField) float Yfar;
var() const export editinline KynapseHandle KynapseHandle;
var const float ExtraSplinRollLimitWhenRunning;
var const float ExtraHeadRollLimitWhenRunning;
var const float ExtraSplinYawLimitWhenRunning;
var const float ExtraHeadYawLimitWhenRunning;
var(LockOnMode) float TargetingSearchRadius;
var float CamRotDelayCombatTargeting;
var(LockOnMode) name PostProcessEffectCombatTargeting;
var(LockOnMode) float LungeRange;
var(LockOnMode) float CombatJumpZ;
var(LockOnMode) float AdditionalOffsetForAutoRotateDistanceCheck;
var(LockOnMode) float NonLockOnAutoTargetAngleRange;
var(LockOnMode) float NonLockOnAutoTargetDistance;
var(LockOnMode) float fNoNPCInCamLockingRadius;
var(LockOnMode) float fNoNPCInCamLockingHeight;
var float DelayTimeForNextDodge;
var transient Actor CurrentTouchingBlockingActor;
var Vector2D AimOffsetPct;
var(CombatStrafe) StrafeSpeed VorpalBlade_StrafeSpeed;
var(CombatStrafe) StrafeSpeed TeapotCannon_StrafeSpeed;
var(CombatStrafe) StrafeSpeed TeapotCannon_Charge_StrafeSpeed;
var(CombatStrafe) StrafeSpeed EyeStaff_StrafeSpeed;
var(CombatStrafe) StrafeSpeed HobbyHorse_StrafeSpeed;
var(CombatStrafe) StrafeSpeed EyeStaff_StrafeSpeed_Aiming;
var(CombatStrafe) StrafeSpeed TeapotCannon_StrafeSpeed_Aiming;
var(CombatStrafe) StrafeSpeed TeapotCannon_Charge_StrafeSpeed_Aiming;
var(LockOnMode) LockOnDOFSettings CamLockOnDOFSettings;
var(LockOnMode) float TargetRangeForDynamicYOffset;
var(LockOnMode) float DynamicPitchExponentModifier;
var() float TargetCameraOffsetY;
var Vector OldAliceDir;
var(LockOnMode) float MaxDistForLockOnCamDrop;
var(LockOnMode) float TimeDelayToCancelLockOnCameraParameters;
var() const export editconst editinline DynamicLightEnvironmentComponent LightEnvironment;
var name AliceCurrentDress;
var name CommandDress;
var int ShadowCameraZoomType;
var(ShadowMode) float ShadowCameraZoomIn;
var(ShadowMode) float ShadowCameraZoomOut;
var(ShadowMode) float ShadowCameraZoomNormal;
var(Shrink) SoundCue SoundCueToPlay;
var(Shrink) SoundCue ShrinkingSound;
var(Shrink) SoundCue ShrinkBubbleSound;
var(Shrink) SoundCue UnShrinkingSound;
var(Shrink) float ShrinkingCollisionScale;
var(Shrink) float ShrinkBaseEyeHeight;
var(Shrink) float ShrinkJumpHeight;
var(Shrink) float ShrinkMaxWalkingSpeed;
var(Shrink) float ShrinkMaxRunningSpeed;
var(Shrink) float ShrinkParticleIntermittentTime;
var(Shrink) ParticleSystem StartShrink;
var(Shrink) ParticleSystem EndShrink;
var(Shrink) float ShrunkSprintSpeed;
var(Shrink) float ShrinkSpeed;
var(Shrink) float UnShrinkSpeed;
var(UnShrink) float UnshrinkRadius;
var(UnShrink) float UnshrinkHeight;
var Vector LastSafeVerifyUnShrinkPoint;
var Emitter ShrinkEmitter;
var() float LowJumpAccel;
var float OldAirControl;
var float OldTerminalVelocity;
var(Glide) float TimeToCancelFloatModeWhenNoTapping;
var(Glide) float FloatDownGravityZ;
var(Glide) float MaxFloatBoundSpeed;
var(Glide) float MinFloatBoundSpeed;
var(Glide) float GlideDownGravityZ;
var(Glide) float ForceIgnoreInputWindow;
var(Glide) float FirstCycle;
var(Glide) float CycleRatio;
var export editinline AudioComponent GlideAC;
var SoundCue GlideLoopingCue;
var SoundCue JumpCue;
var config float FloatFadeInTime;
var config float FloatFadeOutTime;
var config float FloatFadeInVolume;
var config float FloatFadeOutVolume;
var(PushAndPull) float PushSpeed;
var(PushAndPull) int SuperPushGridNumber;
var float HoldJumpTime;
var() float TriggerFloatDownTime;
var() float MinFallingVelocityZ;
var() float MaxFloatDuration;
var() float PrePreDuration;
var() float PreDuration;
var() int MaxCycleFloat;
var float HoldFloatTime;
var(Hair) export editinline Hair Hair;
var(Hair) export editinline HairComponent HairComponent;
var(Hair) array<MaterialInterface> HairDebugMaterials;
var(HairInfo) HairSimulationInfo HysteriaHair;
var(HairInfo) HairSimulationInfo WaterHair;
var(HairInfo) HairSimulationInfo WRabbitHair;
var(HairInfo) HairSimulationInfo MadHatterHair;
var HairSimulationInfo DefaultHair;
var HairSimulationInfo CurHair;
var(Hair) Vector HairFloatForce;
var(Hair) Vector HairFloatPerturbAmplitude;
var(Hair) float HairFloatDamping;
var(Cloth) export editinline ClothComponent SkirtComponent;
var(Cloth) export editinline ClothComponent BowComponent;
var(Cloth) export editinline ClothComponent RibbonComponent;
var(Cloth) Vector SkirtFloatRadialForceDisplacement;
var(Cloth) float SkirtFloatRadialForceMagnitude;
var(Cloth) Vector SkirtFallingRadialForceDisplacement;
var(Cloth) float SkirtFallingRadialForceMagnitudeScale;
var(Cloth) float SkirtFallingRadialForceMagnitudeMax;
var(Cloth) float RibbonFloatRadialForceMagnitude;
var(Cloth) float RibbonFallingRadialForceMagnitudeScale;
var(Cloth) float RibbonFallingRadialForceMagnitudeMax;
var(Cloth) float SkirtFloatInitialDuration;
var(Cloth) float SkirtFloatInitialScale;
var(Cloth) Vector SkirtFloatInitialDisplacement;
var(Cloth) export editinline ClothComponent EarComponent;
var Vector HairLastPerturbAmplitude;
var(Hair) Vector HairPerturbAmplitudeScale;
var Vector RibbonLastPerturbAmplitude;
var(Cloth) Vector RibbonPerturbAmplitudeScale;
var(Cloth) export editinline SkeletalMeshComponent UpperBodyComponent;
var(Sonar) float SonarRadius;
var(Sonar) float SonarDuration;
var(Sonar) CameraAnim SonarCameraAnim;
var(Sonar) float ShrinkDuration;
var(Hallucination) CameraAnim HallucinationCameraAnim;
var(Hallucination) float HallucinationWaitTime;
var transient AliceDodgeParticleTrace DodgeEmitter;
var AliceDummyWeapon DummyWeapon;
var float CurEndurance;
var() const EnduranceParams Endurance;
var const name RightHandSocketName;
var export editinline StaticMeshComponent Umbrella;
var float AccumulateDamage;
var InventoryManager OldInvManager;
var() SkeletalMesh TestMesh;
var() PhysicsAsset TestPhysicsAsset;
var(Death) PhysicsAsset RagdollPhysicsAsset;
var transient PhysicsAsset BackUpBodyPhysicsAsset;
var(Death) float DeathRagdollDelay;
var(Death) array<DeathParticles> DeathRagdollParticleArray;
var(Death) array<DeathMaterials> DeathMaterialArray;
var(Death) SoundCue DeathSoundFX;
var(Death) float RespawnRagdollDelay;
var(Death) array<DeathParticles> RespawnRagdollParticleArray;
var(Death) array<DeathMaterials> RespawnMaterialArray;
var(Death) SoundCue RespawnSoundFX;
var(swim) float SwimCameraHeight;
var(swim) CameraAnim Turn180DegreeCamAnim;
var(swim) float SwimCameraInertia;
var(swim) float SwimTurnSpeed;
var(swim) float BarrelRollDelayTime;
var float curBarrelRollDelayTime;
var(swim) float BoostSwimSpeed;
var(swim) float BoostSwimTurnSpeed;
var(swim) float BoostCoolDownTime;
var(swim) float BootSwimTime;
var(swim) float SlowSwimSpeed;
var(swim) ParticleSystem ChangeSwimModleParticle;
var(swim) ParticleSystem SwimAttackParticle;
var(swim) float AttackRadius;
var(swim) SoundCue SwimAmbientSoundCue;
var(swim) SoundCue SwimAttackSoundCue;
var export editinline AudioComponent SwimAmbientAudio;
var Vector SwimKnockBackDir;
var float curSwimSpeed;
var float curSwimTurnSpeed;
var Vector LastSwimSpeed;
var Vector DirAfterTurn180;
var(swim) export editinline SkeletalMeshComponent SwimSkeletalMeshComponent;
var(swim) export editinline SkeletalMeshComponent WaterWalkSkeletalMeshComponent;
var(swim) export editinline ClothComponent WaterWalkBow;
var(swim) export editinline ClothComponent WaterWalkLight;
var(swim) export editinline ClothComponent WaterWalkTailfin;
var(swim) export editinline ClothComponent SwimBow;
var(swim) export editinline ClothComponent SwimLight;
var(swim) export editinline ClothComponent SwimTailfin;
var(swim) PhysicsAsset SwimHairPhysicsAsset;
var(swim) export editinline Hair SwimHair;
var(DamageToBreakable) float SwimBoostDamage;
var(swim) float SwimSpeedInertia;
var(swim) float SlowSwimSpeedInertia;
var(WaterWalk) float WaterWalkCameraHeight;
var(WaterWalk) float WaterWalkCameraInertia;
var(Sprint) float SprintSpeed;
var(Sprint) float SprintOffSpeed;
var(Sprint) float PreSprintDuration;
var float HorizonThreshold;
var float VerticalThreshold;
var Emitter GlideEmitter;
var() ParticleSystem TempProjPS;
var() ParticleSystem TempSplashPS;
var() Vector TempSplashLocationOffset;
var(Weapon) float MorphTime_EyeStaff;
var(Weapon) float MorphTime_TeapotCannon;
var(Weapon) float MorphTime_HobbyHorse;
var(Weapon) float MorphTime_VorpalBlade;
var name MorphNameSrc;
var name MorphNameDest;
var name MorphNameDefault;
var(Weapon) Vector MorphWindForce;
var(Weapon) Vector MorphWindPerturbAmplitude;
var(Weapon) float WeaponFadeInTime;
var(Weapon) float WeaponFadeInDelay;
var(Weapon) float WeaponFadeOutTime;
var(Weapon) array<WeaponFadeParEffect> ShowWeaponParticles;
var(Weapon) array<WeaponFadeParEffect> HideWeaponParticles;
var(Slide) float SlideTurnSpeed;
var(Slide) float SlideBrakeSpeed;
var(Slide) float SlideBoostSpeed;
var(Slide) float SlideTurnCorrectionTime;
var(Slide) float SlideMinSpeedToRotate;
var(Slide) Emitter SlideParticleEmitter;
var(DamageToBreakable) float SlideBumpDamage;
var(DamageToBreakable) float RollBumpDamage;
var float InputJoyUp;
var float InputJoyRight;
var(Health) float RegenDelay;
var(Health) array<HealthLevel> HealthLevels;
var() GamePawn MyClonePawn;
var() export editinline SkeletalMeshComponent WatchComponent;
var() float RespawnCloneDelay;
var(Damage) array<DamageElement> DamageArray;
var int CurHealthLevel;
var int OldHealthLevel;
var float HealthRegenWaitCount;
var float HealthRegen;
var transient ContextActor CurrentContextActor;
var transient name AnimSeqForContext;
var float LastJumpHeight;
var float OldJumpPitch;
var(Glide) float MinJumpPitch;
var(Glide) float JumpPitchFactor;
var(Glide) float AButtonPress;
var transient Vector VelocityOfSlideOffPawn;
var(Dead) CameraAnim DeathCamera;
var(Dead) CameraAnim RespawnCamera;
var(Dead) ParticleSystem DeathParticle;
var(Dead) ParticleSystem RespawnParticle;
var(Dead) SoundCue DeathSound;
var(Dead) SoundCue RespawnSound;
var Emitter DeathParticleEmitter;
var Emitter DoubleJumpParticleEmitter;
var(FaceFX) float BlinkTime;
var(FaceFX) int BlinkMinTime;
var(FaceFX) int BlinkDeltaTime;
var(Collision) PhysicalMaterial PhysMaterial;
var(Collision) name PhysicalMaterialSocket;
var Emitter SmokeParticleEmitter;
var Material SmokeSkinMaterial;
var(Health) array<SmartHP> SmartDropHealthEasyLevel;
var(Health) array<SmartHP> SmartDropHealthNormalLevel;
var(Health) array<SmartHP> SmartDropHealthHardLevel;
var(Health) array<SmartHP> SmartDropHealthVeryHardLevel;
var CheshireCatSkeletalMeshActor CheshireCatSkelActor;
var float fStepUpAccumZ;
var float fStepUpBugZ;
var ParticleSystem ColdBreathParticle;
var ParticleSystem BubbleParticle;
var ParticleSystem EntryInhabitParticle;
var ParticleSystem LeaveInhabitParticle;
var SoundCue EntryInhaitSound;
var SoundCue LeaveInhaitSound;
var() AliceShieldInfo AliceShield;
var(Rolling) PhysicsAsset RollPhysicsAsset;
var(Rolling) export editinline StaticMeshComponent RollSphere;
var(Rolling) StaticMesh RollMesh;
var(Rolling) float RollMaxAngularVelocity;
var(Rolling) float RollMoveImpulse;
var(Rolling) float RollJumpImpulse;
var(Rolling) float RollHorizontalDamping;
var(Rolling) float RollVerticalDamping;
var(Rolling) float RollExtraGravity;
var(Rolling) float RollJumpTraceHeight;
var(Rolling) float RollJumpTraceDistance;
var export editinline AudioComponent RollingSlideSoundComponent_Slow;
var export editinline AudioComponent RollingSlideSoundComponent_Fast;
var(Rolling) SoundCue RollingSlideSound_Slow;
var(Rolling) SoundCue RollingSlideSound_Fast;
var(Rolling) float RollingSlideThreshold_Slow;
var(Rolling) float RollingSlideThreshold_Fast;
var(Rolling) float RollingSlideRefireDelay;
var(Rolling) float RollingSlideDisableDelay;
var(Rolling) float RollingSlideSoundFadeInTime;
var(Rolling) float RollingSlideSoundFadeOutTime;
var transient float RollingLastSlideTime;
var(Rolling) SoundCue RollingImpactSound;
var export editinline AudioComponent RollingImpactSoundComponent;
var(Rolling) float RollingImpactThreshold;
var(Rolling) float RollingImpactRefireDelay;
var transient float RollingLastImpactTime;
var transient int HeadSwitchStep;
var transient float HeadSwitchTime;
var transient HeadSwitchActor HeadSwitch;
var transient float HeadSwitchStep2TickTime;
var PinballCannon Pinball_Cannon;
var() AliceClonePawn CloneArcheType;
var VorpalBlade pVorpalBlade;
var HobbyHorse pHobbyHorse;
var Actor FakeBase;
var(Giant) int StompDamege;
var(Giant) float RepulsorSecond;
var(Giant) class<DamageType> StompDamageType;
var(Giant) interp float Repulsion;
var float AnimSlowFactor;
var() PhysicsAsset DashBreakPhysicsAsset;
var(AimingMode) float DelayToActivateAimingModeWhenQuitLockOn;
var(AimingMode) float ViewPictchMaxWhenAiming;
var(AimingMode) float ViewPictchMinWhenAiming;
var(AimingMode) float AimingFOVBlendTime;
var(AimingMode) float AimingFOVOffBlendTime;
var(AimingMode) float AimingZoomDelay;
var float AimingZoomDelayElapsed;
var float AimingFOVOffBlendTimeElapsed;
var float AimingFOVBlendTimeElapsed;
var(BlobShadow) float TerminationDistance;
var(BlobShadow) float FadeDistance;
var(BlobShadow) float MinDistance;
var(BlobShadow) DecalData BlobShadow;
var(BlobShadow) float ShadowScale;
var(BlobShadow) float DistanceScale;
var(BlobShadow) name BlobShadowMatAlpha;
var export editinline DecalComponent BlobShadowComponent;
var Vector OldBlobShadowLoc;
var float OldShadowScale;
var() float MaxTimeFallingEdgeToJump;
var(NPCAttachment) array<AttachNPCSocketInfo> AttachNPCSockets;
var(NPCAttachment) float TimeDelayToCauseDamageWhenNPCAttached;
var(NPCAttachment) float TimeIntervalToCauseDamageWhenNPCAttached;
var transient int NbOfAttachedNPC;
var transient SoundCue AttachedNPCBiteAliceSoundCue;
var transient SoundCue AttachedNPCAliceDamagedSoundCue;
var export editinline AudioComponent AttachedNPCScareAliceSoundComp;
var(NPCAttachment) float AttachedNPCScareAliceSoundRepeatDelay;
var transient float HysteriaLeftTime;
var transient int HysteriaClockCounter;
var(Hysteria) float HysteriaDuration;
var(Hysteria) float IncraseDamagePercent;
var(Hysteria) float TriggrHealth;
var(Hysteria) float ReactiveHealth;
var(Hysteria) float RecoverHealth;
var(Hysteria) SoundCue HysteriaReadySound;
var(Hysteria) ParticleSystem HysteriaParticle;
var(Hysteria) array<name> TriggerAnimSequence;
var(Hysteria) CameraAnim TriggerCameraAnim;
var(Hysteria) CameraAnim HysteriaCameraAnim;
var(Hysteria) ParticleSystem EnterHysteriaParticle;
var(Hysteria) SoundCue EnterHysteriaSnd;
var(Hysteria) SoundCue EnterHysteriaSnd2;
var(Hysteria) WonderlandDress HysteriaDress;
var WonderlandDress DefaultDress;
var WonderlandDress DomainDress;
var DelayedChangeDressData DelayedDressData;
var GFxMovie pAliceDressLoadingGFXMovieCallBack;
var(Frozen) float MaxFrozenTime;
var(Frozen) float TimeLimitToCountFreezingHit;
var(Frozen) int FreezingHitTimesToTriggerFrozenState;
var(Frozen) SoundCue StartFrozenSound;
var(Frozen) SoundCue EndFrozenSound;
var(Frozen) float DelayTimeToShowDodgeToEscapeUI;
var(Frozen) ParticleSystem FrozenParticle;
var(Frozen) ParticleSystem FrozenBreakParticle;
var export editinline ParticleSystemComponent FrozenLoopPS;
var transient float CurFrozenTime;
var transient float LastTimeOfFreezingHit;
var transient int CurFreezingHitTimes;
var(XP) int XPToTokenConversion;
var(XP) XPEnum T2SmlXPAmount;
var(XP) XPEnum T2MedXPAmount;
var(XP) XPEnum T2LgeXPAmount;
var(XP) XPEnum T1MedXPAmount;
var(XP) XPEnum T1LgeXPAmount;
var(XP) XPEnum T1BossXPAmount;
var(XP) int SmallAmountXP;
var(XP) int MiddleAmountXP;
var(XP) int LargeAmountXP;
var ShrinkFlowerInteractive ShrinkFlower;
var(ShowPath) ParticleSystem ShowPathTriggerParticle;
var(ShowPath) ParticleSystem ShowPathTrailParticle;
var(ShowPath) float ShowPathLifeTime;
var SplineActor NearestSplineActor;
var Vector ShowPathParticleLocation;
var(Deflect) Umbrella UmbrellaArcheType;
var(Deflect) name UmbrellaAttachSocketName;
var(Deflect) float MinDeflectTime;
var(Deflect) float MaxDeflectTime;
var(Deflect) float MaxDeflectSpinningTime;
var(Deflect) float CylinderRadiusWhileDeflect;
var int bCanDeflectSpin;
var transient Umbrella UmbrellaInstance;
var transient float DeflectTime;
var() float HoverJumpZ;
var(Jump) float MediumFallingHeight;
var(Jump) float HeavyFallingHeight;
var float WeaponDefence_Percent;
var float ClothDefence_Percent;
var float ClothWithWeaponDefence_Percent;
var float NPCDropMoreXP_Percent;
var float NPCDropMoreHP_Percent;
var float BreakableDropMoreXP_Percent;
var float BreakableDropMoreHP_Percent;
var float ShrinkRecoverHPTimePerHP_AbsValue;
var() float ShrinkFlower_RecoverHPTimePerHP_AbsValue;
var transient float ShrinkHPRecoverAccumulateTime;
var int HPMaxClamp;
var float SonarVisibleTimeInc_Percent;
var int XPInsteadOfHP_AbsValue;
var float AttackInc_Percent;
var float RecoverHPTimePerHP_AbsValue;
var transient float HPRecoverAccumulateTime;
var(DLC) float MODDLC_Flesh_NPCDropMoreXP_Percent;
var(DLC) float MODDLC_Chess_NPCDropMoreHP_Percent;
var(DLC) float MODDLC_MadHatter_BreakableDropMoreXP_Percent;
var(DLC) float MODDLC_MadHatter_BreakableDropMoreHP_Percent;
var(DLC) float MODDLC_Rabbit_HPShrinkRecPerHP_AbsValue;
var(DLC) int MODDLC_Cheshire_HPMaxClamp_AbsValue;
var(DLC) float MODDLC_Caterpillar_SonarVisibleTimeInc_Percent;
var(DLC) int MODDLC_MatHatter_DLCTC_XPToHP_AbsValue;
var(DLC) float MODDLC_Chess_DLCHH_AttackInc_Percent;
var(DLC) float MODDLC_Rabbit_DLCPG_AutoHPRecTimePerHP_AbsValue;

event PostSetPhysFalling()
{
    local bool bForce;
    
    bForce = false;
    if (IsDoingSpecialMove(3) || IsDoingSpecialMove(26))
    {
        bForce = true;
    }
    DoSpecialMove(3, bForce);
}

event float GetUnshrinkBaseOffsetZ()
{
    return AliceCheatManager(AlicePlayerController(Controller).CheatManager).fUnshrinkBaseOffsetZ;
}

simulated event TriggerPushDown()
{
    bJustLeaveHover = true;
}

simulated event ForceDoJumpSpecialMove()
{
    local bool bForce;
    
    if (IsDoingSpecialMove(3))
    {
        bForce = true;
    }
    if (IsDoingSpecialMove(26))
    {
        bForce = true;
    }
    DoSpecialMove(3, bForce);
    TriggerEdgeJump();
}

function clearFakeAttached()
{
    FakeBase.FakeAttached = none;
    FakeBase = none;
}

function checkFakeAttached()
{
    local InterpActor interpBase;
    
    if (Base != none)
    {
        interpBase = InterpActor(Base);
        if (interpBase != none)
        {
            FakeBase = interpBase;
            interpBase.FakeAttached = self;
        }
    }
}

function tryResolveEncroach()
{
    local Vector NewLocation;
    
    NewLocation = Location;
    NewLocation.Z += float(10);
    SetLocation(NewLocation);
}

function bool isInEncroachState()
{
    return bShrinkingModeActive;
}

event Vector getUnshrinkExtent()
{
    return AliceCheatManager(AlicePlayerController(Controller).CheatManager).getUnshrinkExtent();
}

simulated function SetWonderlandDressWithWeaponDLCMODInfo(EAliceWonderlandDresses UserDress)
{
    local AlicePlayerController APC;
    
    APC = AlicePlayerController(Controller);
    if (APC != none && APC.GetGStoryMode())
    {
        return;
    }
    switch (UserDress)
    {
        case 9:
            if (AliceGameInfo(WorldInfo.Game).GetDressAbilityActive_QFlesh())
            {
                bActivateHysterialAnytime = MODDLC_Flesh_DLCVB_HysterialAnytime;
            }
            break;
        case 8:
            if (AliceGameInfo(WorldInfo.Game).GetDressAbilityActive_Chess())
            {
                AttackInc_Percent = MODDLC_Chess_DLCHH_AttackInc_Percent;
            }
            break;
        case 11:
            if (AliceGameInfo(WorldInfo.Game).GetDressAbilityActive_MatHatter())
            {
                XPInsteadOfHP_AbsValue = MODDLC_MatHatter_DLCTC_XPToHP_AbsValue;
            }
            break;
        case 10:
            if (AliceGameInfo(WorldInfo.Game).GetDressAbilityActive_WRabbit())
            {
                RecoverHPTimePerHP_AbsValue = MODDLC_Rabbit_DLCPG_AutoHPRecTimePerHP_AbsValue;
            }
            break;
        case 7:
            if (AliceGameInfo(WorldInfo.Game).GetDressAbilityActive_Cheshire())
            {
                bDisableHPDrops = MODDLC_Cheshire_DLCHH_DisableHPDrops;
            }
            break;
        case 6:
            if (AliceGameInfo(WorldInfo.Game).GetDressAbilityActive_Caterpillar())
            {
                bSonarAlwaysVisible = MODDLC_Caterpillar_DLCVB_SonarAlwaysVisible;
            }
            break;
        default:
            break;
    }
}

simulated function SetWonderlandDressDLCMODInfo(EAliceWonderlandDresses UserDress)
{
    local AlicePlayerController APC;
    
    APC = AlicePlayerController(Controller);
    if (APC != none && APC.GetGStoryMode())
    {
        return;
    }
    if (APC != none && APC.ChapterCompleted[5] > 0)
    {
        switch (UserDress)
        {
            case 3:
                if (AliceGameInfo(WorldInfo.Game).GetDressAbilityActive_Oriental())
                {
                    NPCDropMoreXP_Percent = MODDLC_Flesh_NPCDropMoreXP_Percent;
                }
                break;
            case 2:
                if (AliceGameInfo(WorldInfo.Game).GetDressAbilityActive_Water())
                {
                    NPCDropMoreHP_Percent = MODDLC_Chess_NPCDropMoreHP_Percent;
                }
                break;
            case 1:
                if (AliceGameInfo(WorldInfo.Game).GetDressAbilityActive_Hatter())
                {
                    BreakableDropMoreHP_Percent = MODDLC_MadHatter_BreakableDropMoreHP_Percent;
                    BreakableDropMoreXP_Percent = MODDLC_MadHatter_BreakableDropMoreXP_Percent;
                }
                break;
            case 0:
                if (AliceGameInfo(WorldInfo.Game).GetDressAbilityActive_Default())
                {
                    ShrinkRecoverHPTimePerHP_AbsValue = MODDLC_Rabbit_HPShrinkRecPerHP_AbsValue;
                }
                break;
            case 4:
                if (AliceGameInfo(WorldInfo.Game).GetDressAbilityActive_Queen())
                {
                    HPMaxClamp = MODDLC_Cheshire_HPMaxClamp_AbsValue;
                    if (HPMaxClamp > 0)
                    {
                        HealthMax = HPMaxClamp;
                        Health = HealthMax;
                    }
                }
                break;
            case 5:
                if (AliceGameInfo(WorldInfo.Game).GetDressAbilityActive_Doll())
                {
                    SonarVisibleTimeInc_Percent = MODDLC_Caterpillar_SonarVisibleTimeInc_Percent;
                }
                break;
            default:
                break;
        }
    }
    SetWonderlandDressWithWeaponDLCMODInfo(UserDress);
}

exec function SetCanSpin()
{
    if (bCanDeflectSpin == 0)
    {
        bCanDeflectSpin = 1;
    }
    else
    {
        bCanDeflectSpin = 0;
    }
}

function string showSaveLoadConfigInfo()
{
    local string Info;
    
    Info = "GameDifficulty: " $ string(AliceGameInfo(WorldInfo.Game).getCurrentGameDifficulty()) $ " \n" $ "Brightness: " $ string(AliceGameInfo(WorldInfo.Game).getAliceGameEngine().Brightness) $ " \n" $ "InvertY: " $ (AliceGameInfo(WorldInfo.Game).getAliceGameEngine().InvertY ? "true" : "false" $ " \n" $ "SoundEffectVolume: " $ string(AliceGameInfo(WorldInfo.Game).getAliceGameEngine().SoundEffectVolume) $ " \n" $ "MusicVolume: " $ string(AliceGameInfo(WorldInfo.Game).getAliceGameEngine().MusicVolume) $ " \n" $ "VoiceVolume: " $ string(AliceGameInfo(WorldInfo.Game).getAliceGameEngine().VoiceVolume) $ " \n" $ "Subtitles: " $ (AliceGameInfo(WorldInfo.Game).getAliceGameEngine().Subtitles ? "true" : "false" $ " \n" $ "ScreenPositionX: " $ string(AliceGameInfo(WorldInfo.Game).getAliceGameEngine().ScreenPositionX) $ " \n" $ "ScreenPositionY: " $ string(AliceGameInfo(WorldInfo.Game).getAliceGameEngine().ScreenPositionY) $ " \n" $ "Gamma: " $ string(AliceGameInfo(WorldInfo.Game).getAliceGameEngine().Gamma) $ " \n" $ "GraphicsQuality: " $ string(AliceGameInfo(WorldInfo.Game).getAliceGameEngine().GraphicsQuality) $ " \n" $ "ResolutionX: " $ string(AliceGameInfo(WorldInfo.Game).getAliceGameEngine().ResolutionX) $ " \n" $ "ResolutionY: " $ string(AliceGameInfo(WorldInfo.Game).getAliceGameEngine().ResolutionY) $ " \n" $ "AntiAlias: " $ (AliceGameInfo(WorldInfo.Game).getAliceGameEngine().AntiAlias ? "true" : "false" $ " \n" $ "Stereo3D: " $ (AliceGameInfo(WorldInfo.Game).getAliceGameEngine().Stereo3D ? "true" : "false" $ " \n" $ "PhysXLevel: " $ string(AliceGameInfo(WorldInfo.Game).getAliceGameEngine().PhysXLevel) $ " \n" $ "MotionBlur: " $ (AliceGameInfo(WorldInfo.Game).getAliceGameEngine().MotionBlur ? "true" : "false" $ " \n" $ "GamepadType: " $ string(AliceGameInfo(WorldInfo.Game).getAliceGameEngine().GamepadType) $ " \n" $ "ControlLayout: " $ string(AliceGameInfo(WorldInfo.Game).getAliceGameEngine().ControlLayout))))));
    return Info;
}

event bool isNewCycleControl()
{
    return AliceCheatManager(AlicePlayerController(Controller).CheatManager).isNewCycleControl();
}

singular event BaseChange()
{
    local DynamicSMActor Dyn;
    local bool bBaseChangeSuccess;
    
    bBaseChangeSuccess = true;
    if (Pawn(Base) != none && DrivenVehicle == none || !DrivenVehicle.IsBasedOn(Base))
    {
        if (!Pawn(Base).CanBeBaseForPawn(self))
        {
            Pawn(Base).CrushedBy(self);
            JumpOffPawn();
            bBaseChangeSuccess = false;
        }
    }
    Dyn = DynamicSMActor(Base);
    if (Dyn != none && !Dyn.CanBasePawn(self))
    {
        JumpOffPawn();
        bBaseChangeSuccess = false;
    }
    if (Controller != none)
    {
        AlicePlayerController(Controller).stuckManager.onBaseChange(bBaseChangeSuccess);
    }
}

exec function DiscardWatch()
{
    if (bClockBombCountingDown && bHoldingWatch)
    {
        DetachWatch();
        bHoldingWatch = false;
    }
}

function bool IsAliceHoldingWatch()
{
    return bClockBombCountingDown;
}

function DetachWatch()
{
    ClearTimer('AttachWatch');
    Mesh.DetachComponent(WatchComponent);
}

function AttachWatch()
{
    local Rotator RelRot;
    
    if (IsDoingSpecialMove(50) || Physics == 2 || IsDoingSpecialMove(37))
    {
        return;
    }
    if (WeaponForAlice(Weapon) != none && !WeaponForAlice(Weapon).IsInState('Inactive'))
    {
        return;
    }
    RelRot.Yaw = int(float(32767) * 0.5);
    Mesh.AttachComponent(WatchComponent, 'Bip01-Prop1', , RelRot);
    WatchComponent.SetLightEnvironment(Mesh.LightEnvironment);
    WatchComponent.SetShadowParent(Mesh);
    bHoldingWatch = true;
}

function ForceAttachWatchAfterDodge()
{
    local Rotator RelRot;
    
    if (IsDoingSpecialMove(50) || Physics == 2 || IsDoingSpecialMove(37))
    {
        return;
    }
    RelRot.Yaw = int(float(32767) * 0.5);
    Mesh.AttachComponent(WatchComponent, 'Bip01-Prop1', , RelRot);
    WatchComponent.SetLightEnvironment(Mesh.LightEnvironment);
    WatchComponent.SetShadowParent(Mesh);
    bHoldingWatch = true;
}

function NotifyAllNpcAliceTakeDamage()
{
    local Pawn NPCPawn;
    
    NPCPawn = WorldInfo.PawnList;
    while (NPCPawn != none)
    {
        if (!NPCPawn.IsPlayerPawn())
        {
            AliceGameKynapseAIController(NPCPawn.Controller).RegisterSphinxEvent(17);
        }
        NPCPawn = NPCPawn.NextPawn;
    }
    if (AliceGameInfo(WorldInfo.Game).Achievement41 == 0)
    {
        AliceGameInfo(WorldInfo.Game).Achievement41 = 1;
    }
}

exec function KillAllNpc()
{
    local Pawn NPCPawn;
    
    NPCPawn = WorldInfo.PawnList;
    while (NPCPawn != none)
    {
        if (!NPCPawn.IsPlayerPawn())
        {
            NPCPawn.TakeDamage(NPCPawn.HealthMax + 1, NPCPawn.Controller, NPCPawn.Location, NPCPawn.Location, class'Engine.DamageType');
        }
        NPCPawn = NPCPawn.NextPawn;
    }
}

event bool IsCycleExpiredEX()
{
    return AlicePlayerController(Controller).CycleFloatManager.IsCycleExpiredEX();
}

event bool IsCycleExpired()
{
    return AlicePlayerController(Controller).CycleFloatManager.IsCycleExpired();
}

native function GetContextEvents(class<SequenceObject> DesiredClass, out array<SequenceObject> OutContextEvents)
{
    DesiredClass;
    OutContextEvents;
}

final simulated function bool ActivateContextEventClass(EContextItem InContextItem, out const array<SequenceEvent> EventList, optional out const array<int> ActivateIndices, optional bool bTest, optional out array<SequenceEvent> ActivatedEvents)
{
    local SequenceObject Evt;
    local SeqEvent_AliceContext ContextEvt;
    local array<SequenceObject> ContextEvents;
    
    GetContextEvents(class'SeqEvent_AliceContext', ContextEvents);
    foreach ContextEvents(Evt)
    {
        ContextEvt = SeqEvent_AliceContext(Evt);
        if (ContextEvt != none && ContextEvt.ContextItem == InContextItem)
        {
            ContextEvt.CheckActivate(self, self, bTest, ActivateIndices);
        }
    }
    return true;
}

simulated function bool TriggerContextEventClass(EContextItem ContextItem, optional int ActivateIndex = -1, optional bool bTest, optional out array<SequenceEvent> ActivatedEvents)
{
    local array<int> ActivateIndices;
    
    if (ActivateIndex >= 0)
    {
        ActivateIndices[0] = ActivateIndex;
    }
    return ActivateContextEventClass(ContextItem, GeneratedEvents, ActivateIndices, bTest, ActivatedEvents);
}

simulated function bool CanDoContextAction(bool bClockBomb)
{
    if (Physics != 1 || !IsPawnInAStance(0))
    {
        return false;
    }
    if (IsDoingASpecialMove() || !IsAliveAndWell())
    {
        return false;
    }
    if (CurrentContextActor == none || bIsDoingContextAction || !CurrentContextActor.CanStartContext())
    {
        return false;
    }
    if (!bClockBomb && CurrentContextActor != none && CurrentContextActor.IsA('ClockBombContextActor'))
    {
        return false;
    }
    return true;
}

function EndGrabbed()
{
    if (bBeingGrabbed)
    {
        if (GrabberPawn != none)
        {
            GrabberPawn.StopAllConfigAnim(0.05, true, true, true);
        }
        SetCollision(true, true);
        bBeingGrabbed = false;
    }
}

function PlayFrozenBreakParticle()
{
    FrozenLoopPS.DeactivateSystem();
    DetachComponent(FrozenLoopPS);
    PlayParticle(Location, Rotation, FrozenBreakParticle, true);
}

function PlayFrozenParticle()
{
    FrozenLoopPS.SetTemplate(FrozenParticle);
    FrozenLoopPS.SetAbsolute(false, false, false);
    FrozenLoopPS.SetLODLevel(WorldInfo.bDropDetail ? 1 : 0);
    FrozenLoopPS.bUpdateComponentInTick = true;
    AttachComponent(FrozenLoopPS);
}

function EndFrozen()
{
    if (bIsFrozen)
    {
        AlicePlayerController(Controller).GotoState('PlayerWalking');
    }
}

function StartFrozen()
{
    local AlicePlayerController APC;
    
    APC = AlicePlayerController(Controller);
    if (APC != none && !APC.IsInState('Frozen'))
    {
        if (APC.bFirstPersonViewActive)
        {
            APC.QuitFPS();
        }
        if (Weapon != none && Weapon.IsA('WeaponForAliceMelee'))
        {
            WeaponForAliceMelee(Weapon).ResetWeaponInput();
        }
        APC.RecoverToDefaultStatus(false, false, false);
        APC.GotoState('Frozen');
    }
}

function bool IsLockOnBlocked(Vector TargetLoc)
{
    local bool bCameraBlock, bPawnBlock;
    local Vector out_HitLocation, out_HitNormal, TraceExtent, cameraLoc;
    local Rotator cameraRot;
    local Actor TraceActor;
    local TraceHitInfo HitInfo;
    
    if (bBlockFromCamera)
    {
        AlicePlayerCamera(AlicePlayerController(Controller).PlayerCamera).GetCameraViewPoint(cameraLoc, cameraRot);
        TraceActor = Trace(out_HitLocation, out_HitNormal, TargetLoc, cameraLoc, true, TraceExtent, HitInfo, 8411);
        bCameraBlock = TraceActor != none && AlicePlayerController(Controller).shouldBlockLockOn(TraceActor) && !TraceActor.IsA('AliceGameKynapsePawn') && !TraceActor.IsA('GameBreakableActor') && !TraceActor.IsA('AlicePawn');
        if (bCameraBlock || TraceActor == none)
        {
            AliceCheatManager(AlicePlayerController(Controller).CheatManager).setLockonBlockActor(TraceActor);
        }
    }
    if (bBlockFromPawn)
    {
        TraceActor = Trace(out_HitLocation, out_HitNormal, TargetLoc, Location, true, TraceExtent, HitInfo, 8411);
        bPawnBlock = TraceActor != none && AlicePlayerController(Controller).shouldBlockLockOn(TraceActor) && !TraceActor.IsA('AliceGameKynapsePawn') && !TraceActor.IsA('GameBreakableActor') && !TraceActor.IsA('AlicePawn');
        if (bPawnBlock || TraceActor == none)
        {
            AliceCheatManager(AlicePlayerController(Controller).CheatManager).setLockonBlockActor(TraceActor);
        }
    }
    return bCameraBlock || bPawnBlock;
}

function float CalcPotentialValue(Vector TargetLoc, out Vector NewCoorLoc)
{
    local float fResult, X, Y, Z, P, Q, A, B, C, D;
    
    ConvertToPawnSpace(TargetLoc, X, Y, Z, NewCoorLoc);
    P = Zfar - Zrear;
    Q = Zfar * Zrear;
    A = (P - 2.0 * Zxyfar) / (Xfar * Xfar);
    C = (Q + Zxyfar * Zxyfar) / (Xfar * Xfar);
    B = (P - 2.0 * Zxyfar) / (Yfar * Yfar);
    D = (Q + Zxyfar * Zxyfar) / (Yfar * Yfar);
    fResult = (Z * Z + (A * Z + C) * X * X + (B * Z + D) * Y * Y) / (P * Z + Q);
    return fResult;
}

function ConvertToPawnSpace(Vector InLoc, out float X, out float Y, out float Z, out Vector _NewCoorLoc)
{
    local Vector NewLoc, cameraLoc;
    local Rotator NewRot, cameraRot;
    
    NewLoc = InLoc - Location;
    NewRot = rotator(NewLoc);
    if (bUseCameraView)
    {
        AlicePlayerCamera(AlicePlayerController(Controller).PlayerCamera).GetCameraViewPoint(cameraLoc, cameraRot);
        NewRot.Yaw -= cameraRot.Yaw;
    }
    else
    {
        NewRot.Yaw -= Rotation.Yaw;
    }
    NewLoc = Normal(vector(NewRot)) * VSize(NewLoc);
    Z = NewLoc.X;
    X = NewLoc.Y;
    Y = NewLoc.Z;
    _NewCoorLoc = NewLoc;
}

function OnSlideToTargetEnd()
{
    if (WeaponForAlice(Weapon) != none)
    {
        WeaponForAlice(Weapon).bIsSlideToTarget = false;
        bSlidingToTarget = false;
        if (WeaponForAliceMelee(Weapon) != none)
        {
            WeaponForAliceMelee(Weapon).GotoState('Active');
        }
    }
}

function DebugLeaveHysteria()
{
    bDeferredLeaveHysteriaMode = true;
}

function CheckHysteriaMode(float DeltaTime)
{
    local HobbyHorse Horse;
    local int CurrentHysteriaCounter;
    local float HysteriaTriggerHealth, HysteriaReactiveHealth;
    
    if (!bCanHysteria || !bEnableHysteria)
    {
        return;
    }
    HysteriaTriggerHealth = TriggrHealth;
    HysteriaReactiveHealth = ReactiveHealth;
    if (bActivateHysterialAnytime)
    {
        bEverAboveRetriggerHealth = true;
        bCanHysteriaRetrigger = true;
    }
    else if (!bEverAboveRetriggerHealth)
    {
        if (!bInHysteriaMode && float(Health) > HysteriaReactiveHealth)
        {
            bEverAboveRetriggerHealth = true;
        }
    }
    else if (!bCanHysteriaRetrigger)
    {
        if (!bInHysteriaMode && float(Health) < HysteriaTriggerHealth)
        {
            bCanHysteriaRetrigger = true;
        }
    }
    if (bCanHysteriaRetrigger)
    {
        if (!bMatchHysteriaModeCondition)
        {
            if (!bInHysteriaMode && Health > 0 && float(Health) < HysteriaTriggerHealth || bActivateHysterialAnytime)
            {
                AliceGameInfo(WorldInfo.Game).GFxHUDMenu.UpdateAliceHealth(Health, HealthMax);
                AliceGameInfo(WorldInfo.Game).GFxHUDMenu.HysteriaReady();
                if (HysteriaReadySound != none)
                {
                    PlaySound(HysteriaReadySound);
                }
                bMatchHysteriaModeCondition = true;
            }
        }
        else if (!bInHysteriaMode && !bActivateHysterialAnytime && float(Health) >= HysteriaTriggerHealth)
        {
            AliceGameInfo(WorldInfo.Game).GFxHUDMenu.UpdateAliceHealth(Health, HealthMax);
            AliceGameInfo(WorldInfo.Game).GFxHUDMenu.CancelHysteriaReady();
            bCanHysteriaRetrigger = false;
            bMatchHysteriaModeCondition = false;
        }
    }
    if (bInHysteriaMode)
    {
        HysteriaLeftTime -= DeltaTime;
        if (HysteriaDuration > float(0))
        {
            CurrentHysteriaCounter = int(HysteriaLeftTime / HysteriaDuration * 360.0);
            CurrentHysteriaCounter = Clamp(CurrentHysteriaCounter, 0, 360);
            if (CurrentHysteriaCounter < HysteriaClockCounter)
            {
                for (; HysteriaClockCounter != CurrentHysteriaCounter; HysteriaClockCounter--)
                {
                    AliceGameInfo(WorldInfo.Game).GFxHUDMenu.CancelHysteriaCount(HysteriaClockCounter - 1);
                }
                if (CurrentHysteriaCounter == 0)
                {
                    StopHysteriaMode();
                }
            }
        }
    }
    Horse = HobbyHorse(Weapon);
    if (Horse != none && Horse.IsMeleeWeaponInComboProcess(3))
    {
        return;
    }
    if (bDeferredLeaveHysteriaMode)
    {
        if (bInHysteriaMode)
        {
            LeaveHysteriaMode();
        }
    }
    else if (!bInHysteriaMode)
    {
        if (!bHysteriaPlaying && bHysteriaTriggered && bCanHysteriaRetrigger && Health > 0 && float(Health) < HysteriaTriggerHealth || bActivateHysterialAnytime && !AlicePlayerInput(AlicePlayerController(Controller).PlayerInput).bDisableInputInCinematic)
        {
            EntryHysteriaMode();
        }
    }
    else if (!bHysteriaPlaying || AlicePlayerInput(AlicePlayerController(Controller).PlayerInput).bDisableInputInCinematic)
    {
        LeaveHysteriaMode();
    }
    bHysteriaTriggered = false;
}

function showHysteriaInfo(Canvas Canvas, out float out_YL, out float out_YPos)
{
    Canvas.SetDrawColor(0, 255, 0);
    out_YPos += float(50);
    Canvas.SetPos(4.0, out_YPos);
    Canvas.DrawText("===== bCanHysteria: " $ string(bCanHysteria) $ " , bEnableHysteria: " $ string(bEnableHysteria) $ " , =====");
    out_YPos += float(20);
    Canvas.SetPos(4.0, out_YPos);
    Canvas.DrawText("===== bEverAboveRetriggerHealth : " $ string(bEverAboveRetriggerHealth) $ " , bInHysteriaMode: " $ string(bInHysteriaMode) $ " , =====");
    out_YPos += float(20);
    Canvas.SetPos(4.0, out_YPos);
    Canvas.DrawText("===== Health : " $ string(Health) $ " , HysteriaReactiveHealth : " $ string(ReactiveHealth) $ " , HysteriaTriggerHealth : " $ string(TriggrHealth) $ " , =====");
    out_YPos += float(20);
    Canvas.SetPos(4.0, out_YPos);
    Canvas.DrawText("===== bCanHysteriaRetrigger : " $ string(bCanHysteriaRetrigger) $ " , bMatchHysteriaModeCondition : " $ string(bMatchHysteriaModeCondition) $ " , bActivateHysterialAnytime : " $ string(bActivateHysterialAnytime) $ " , =====");
}

exec function TriggerHysteria()
{
    local float HysterialTriggerHealth;
    
    if (Health <= 0)
    {
        return;
    }
    HysterialTriggerHealth = TriggrHealth;
    if (!bInHysteriaMode && float(Health) < HysterialTriggerHealth || bActivateHysterialAnytime)
    {
        bHysteriaTriggered = true;
    }
}

function StopHysteriaMode()
{
    bHysteriaPlaying = false;
}

function StartHysteriaMode()
{
    bHysteriaPlaying = true;
}

function LeaveHysteriaMode()
{
    local TeapotCannon TC;
    
    if (!bInHysteriaMode)
    {
        return;
    }
    bDeferredLeaveHysteriaMode = false;
    bOnQuitHysteriaMode = true;
    TriggerContextEventClass(20, 1);
    StopHysteriaMode();
    bInHysteriaMode = false;
    EnableHysteriaMeshes(false);
    ChangeWeaponLevelForHysteriaMode(false);
    AliceForceStopCameraAnim(HysteriaCameraAnim);
    bHysteriaTriggered = false;
    TC = TeapotCannon(InvManager.FindInventoryType(class'TeapotCannon'));
    if (TC != none)
    {
        TC.ShotCost[0] = 1;
        TC.ShotCost[2] = 1;
    }
    if (bRecoverHealth && !bRecoverHealthAtHysterialBegin)
    {
        Health = int(float(HealthMax) * RecoverHealth * 0.01);
        HealthRegen = float(Health);
        HealthRegenWaitCount = 0.0;
        Health = int(FClamp(float(Health), 0.0, float(HealthMax)));
        if (bActivateHysterialAnytime)
        {
            Health = HealthMax;
        }
        AliceGameInfo(WorldInfo.Game).GFxHUDMenu.UpdateAliceHealth(Health, HealthMax);
    }
    AliceGameInfo(WorldInfo.Game).GFxHUDMenu.HysteriaOut();
    HysteriaLeftTime = 0.0;
    AlicePlayerController(Controller).SoundModeManager.SetHysteriaMode(false);
}

function bool CanPlayHysteriaAnim()
{
    local AlicePlayerController APC;
    
    APC = AlicePlayerController(Controller);
    if (APC == none || !APC.CanSwitchRangeWeapon())
    {
        return false;
    }
    return true;
}

function PlayEnterHysteriaEffect3()
{
    PlayParticle(Location, Rotation, EnterHysteriaParticle, true);
    TriggerEnterHysteriaRadiusDamage();
}

function PlayEnterHysteriaEffect2()
{
    PlaySound(EnterHysteriaSnd2);
    SetTimer(0.25, false, 'PlayEnterHysteriaEffect3');
}

function PlayEnterHysteriaEffect()
{
    PlaySound(EnterHysteriaSnd);
    SetTimer(0.25, false, 'PlayEnterHysteriaEffect2');
}

function EntryHysteriaMode()
{
    local TeapotCannon TC;
    
    if (!AliceCheatManager(AlicePlayerController(Controller).CheatManager).canHysteria())
    {
        return;
    }
    if (bInHysteriaMode)
    {
        return;
    }
    if (AlicePlayerController(Controller).IsInState('Dead'))
    {
        return;
    }
    if (AlicePlayerController(Controller).bShrinkingModeActive)
    {
        AlicePlayerController(Controller).UnShrinking();
    }
    TriggerContextEventClass(20, 0);
    ForceDetachAllNPC();
    HysteriaLeftTime = HysteriaDuration;
    HysteriaClockCounter = 360;
    StartHysteriaMode();
    bInHysteriaMode = true;
    EnableHysteriaMeshes(true);
    ChangeWeaponLevelForHysteriaMode(true);
    DeactivateHealthLevel(OldHealthLevel);
    OldHealthLevel = -1;
    AliceForcePlayCameraAnim(TriggerCameraAnim, false);
    AliceForcePlayCameraAnim(HysteriaCameraAnim, true);
    TC = TeapotCannon(InvManager.FindInventoryType(class'TeapotCannon'));
    if (TC != none)
    {
        TC.ShotCost[0] = 0;
        TC.ShotCost[2] = 0;
    }
    if (WeaponForAliceRange(Weapon) != none)
    {
        WeaponForAliceRange(Weapon).ClearOverHeatTimeOver();
    }
    AliceGameInfo(WorldInfo.Game).GFxHUDMenu.HysteriaInto(HysteriaDuration);
    AlicePlayerController(Controller).StopWeaponFire();
    if (CanPlayHysteriaAnim())
    {
        DoSpecialMove(66, true);
    }
    else
    {
        PlayEnterHysteriaEffect();
    }
    PlayParticle(Location, Rotation, HysteriaParticle, true);
    if (bRecoverHealth && bRecoverHealthAtHysterialBegin)
    {
        Health = int(float(HealthMax) * RecoverHealth * 0.01);
        HealthRegen = float(Health);
        HealthRegenWaitCount = 0.0;
        Health = int(FClamp(float(Health), 0.0, float(HealthMax)));
        if (bActivateHysterialAnytime)
        {
            Health = HealthMax;
        }
        AliceGameInfo(WorldInfo.Game).GFxHUDMenu.UpdateAliceHealth(Health, HealthMax);
    }
    AlicePlayerController(Controller).SoundModeManager.SetHysteriaMode(true);
    bCanHysteriaRetrigger = false;
    bEverAboveRetriggerHealth = false;
    bMatchHysteriaModeCondition = false;
    AliceGameInfo(WorldInfo.Game).UseHysteriaCounter++;
}

function ChangeWeaponLevelForHysteriaMode(bool bEnter)
{
    local WeaponForAlice W;
    
    if (bEnter)
    {
        W = WeaponForAlice(InvManager.FindInventoryType(class'VorpalBlade'));
        if (W != none)
        {
            W.ChangeLevel(5);
        }
        W = WeaponForAlice(InvManager.FindInventoryType(class'EyeStaff'));
        if (W != none)
        {
            W.ChangeLevel(5);
        }
        W = WeaponForAlice(InvManager.FindInventoryType(class'HobbyHorse'));
        if (W != none)
        {
            W.ChangeLevel(5);
        }
        W = WeaponForAlice(InvManager.FindInventoryType(class'TeapotCannon'));
        if (W != none)
        {
            W.ChangeLevel(5);
        }
    }
    else
    {
        W = WeaponForAlice(InvManager.FindInventoryType(class'VorpalBlade'));
        if (W != none)
        {
            W.ChangeLevel(W.SaveWeaponLevel);
        }
        W = WeaponForAlice(InvManager.FindInventoryType(class'EyeStaff'));
        if (W != none)
        {
            W.ChangeLevel(W.SaveWeaponLevel);
        }
        W = WeaponForAlice(InvManager.FindInventoryType(class'HobbyHorse'));
        if (W != none)
        {
            W.ChangeLevel(W.SaveWeaponLevel);
        }
        W = WeaponForAlice(InvManager.FindInventoryType(class'TeapotCannon'));
        if (W != none)
        {
            W.ChangeLevel(W.SaveWeaponLevel);
        }
    }
}

function EnableHysteriaMeshes(bool bEnabled)
{
    local WeaponPara tempweaponpara;
    
    if (bEnabled)
    {
        if (GetCurrentWeaponType() != 0)
        {
            Weapon.Mesh.DetachFromAny();
        }
        SetWonderlandDress(HysteriaDress);
        if (GetCurrentWeaponType() != 0)
        {
            foreach WeaponParas(tempweaponpara)
            {
                if (tempweaponpara.WeaponClass != none && tempweaponpara.WeaponClass == Weapon.Class)
                {
                    WeaponForAlice(Weapon).AttachWeaponToAlice(tempweaponpara.DefaultAttachedSocketName);
                    WeaponForAlice(Weapon).AttachOwnerData();
                }
            }
            Mesh.AttachComponentToSocket(Weapon.Mesh, tempweaponpara.DefaultAttachedSocketName);
            WeaponForAlice(Weapon).AttachOwnerData();
        }
    }
    else
    {
        if (GetCurrentWeaponType() != 0)
        {
            Weapon.Mesh.DetachFromAny();
        }
        ChangeWonderlandDress(CurWonderlandDress, false, none, true);
        if (GetCurrentWeaponType() != 0)
        {
            foreach WeaponParas(tempweaponpara)
            {
                if (tempweaponpara.WeaponClass != none && tempweaponpara.WeaponClass == Weapon.Class)
                {
                    WeaponForAlice(Weapon).AttachWeaponToAlice(tempweaponpara.DefaultAttachedSocketName);
                    WeaponForAlice(Weapon).AttachOwnerData();
                }
            }
            Mesh.AttachComponentToSocket(Weapon.Mesh, tempweaponpara.DefaultAttachedSocketName);
            WeaponForAlice(Weapon).AttachOwnerData();
            FadeInWeapon();
        }
    }
}

function ResetTimeVaryingMaterials()
{
    local int Index;
    local MaterialInstanceTimeVarying MITV;
    
    for (Index = 0; Index < Mesh.Materials.Length; Index++)
    {
        MITV = MaterialInstanceTimeVarying(Mesh.Materials[Index]);
        if (MITV != none)
        {
            MITV.ClearRenderingThreadParameterMaps();
        }
    }
}

function SetMaterialsIntoAliceSkelComponents()
{
    local int Index;
    
    AutoSetMaterialsForAllSkelComponents(true);
    Mesh.SetMaterial(Mesh.Materials.Length, HairComponent.Material);
    for (Index = 0; Index < SkirtComponent.Materials.Length; Index++)
    {
        Mesh.SetMaterial(Mesh.Materials.Length, SkirtComponent.Materials[Index]);
    }
    ResetTimeVaryingMaterials();
}

function SwitchHairInTransition()
{
    Mesh.DetachComponent(HairComponent);
    SetHairInfoToHairComponent(WaterHair);
    Mesh.AttachComponent(HairComponent, 'Bip01-Head');
}

event SetWonderlandDress(out WonderlandDress NewDress)
{
    local bool bUpdateHair;
    local EAliceWonderlandDresses NextDress;
    
    if (NewDress.SkelMesh == none)
    {
        return;
    }
    bUpdateHair = CheckPendingAndCurrentDress(2) || CheckPendingAndCurrentDress(10) || CheckPendingAndCurrentDress(11) || bInHysteriaMode || bOnQuitHysteriaMode;
    Mesh.DetachComponent(SkirtComponent);
    Mesh.DetachComponent(BowComponent);
    Mesh.DetachComponent(RibbonComponent);
    Mesh.DetachComponent(EarComponent);
    if (bUpdateHair)
    {
        Mesh.DetachComponent(HairComponent);
    }
    SkirtComponent.DeleteSimulator();
    SkirtComponent.SetSkeletalMesh(NewDress.Skirt);
    BowComponent.DeleteSimulator();
    BowComponent.SetSkeletalMesh(NewDress.Bow);
    RibbonComponent.DeleteSimulator();
    RibbonComponent.SetSkeletalMesh(NewDress.Ribbon);
    Mesh.SetSkeletalMesh(NewDress.SkelMesh);
    if (NewDress.Ear != none)
    {
        EarComponent.DeleteSimulator();
        EarComponent.SetSkeletalMesh(NewDress.Ear);
    }
    if (bUpdateHair)
    {
        if (bInHysteriaMode)
        {
            SetHairInfoToHairComponent(HysteriaHair);
        }
        else
        {
            if (bOnQuitHysteriaMode)
            {
                NextDress = CurWonderlandDress;
                bOnQuitHysteriaMode = false;
            }
            else
            {
                NextDress = PendingWonderlandDress;
            }
            switch (NextDress)
            {
                case 11:
                    SetHairInfoToHairComponent(MadHatterHair);
                    break;
                case 10:
                    SetHairInfoToHairComponent(WRabbitHair);
                    break;
                case 2:
                    SetHairInfoToHairComponent(WaterHair);
                    break;
                default:
                    SetHairInfoToHairComponent(DefaultHair);
                    break;
            }
        }
    }
    Mesh.AttachComponent(SkirtComponent, 'Bip01-Pelvis');
    if (PendingWonderlandDress == 6)
    {
        Mesh.AttachComponent(BowComponent, 'Bip01-Spine2');
        Mesh.AttachComponent(RibbonComponent, 'Bip01-Head');
    }
    else
    {
        Mesh.AttachComponent(BowComponent, 'Bip01-Pelvis');
        Mesh.AttachComponent(RibbonComponent, 'Bip01-Pelvis');
    }
    if (NewDress.Ear != none)
    {
        Mesh.AttachComponent(EarComponent, 'Bip01-Head');
    }
    if (bUpdateHair && HairComponent.Template != none)
    {
        Mesh.AttachComponent(HairComponent, 'Bip01-Head');
    }
    SetMaterialsIntoAliceSkelComponents();
}

function bool CheckPendingAndCurrentDress(EAliceWonderlandDresses DressID)
{
    return PendingWonderlandDress == DressID || CurWonderlandDress == DressID;
}

function int DelayedChangeWonderlandDress(EAliceWonderlandDresses NewDress, optional bool bShouldBlock = false, optional GFxMovie pGFXMovie = none)
{
    if (CurWonderlandDress != NewDress && !bDelayedChangeWonderlandDress && !IsLoadingWonderlandDressPackage(PendingWonderlandDress))
    {
        DelayedDressData.NewDress = NewDress;
        DelayedDressData.bShouldBlock = bShouldBlock;
        DelayedDressData.pGFXMovie = pGFXMovie;
        bDelayedChangeWonderlandDress = true;
        return 1;
    }
    else if (pGFXMovie != none)
    {
        AlicePlayerController(Controller).SetCurAliceDressFinished(pGFXMovie);
        return 1;
    }
    return -1;
}

function int ChangeWonderlandDress(EAliceWonderlandDresses NewDress, optional bool bShouldBlock = false, optional GFxMovie pGFXMovie = none, optional bool bWithoutDressCheck = false)
{
    if (CurWonderlandDress != NewDress || bWithoutDressCheck)
    {
        return LoadWonderlandDressPackage(NewDress, bShouldBlock, pGFXMovie);
    }
    else if (pGFXMovie != none)
    {
        AlicePlayerController(Controller).SetCurAliceDressFinished(pGFXMovie);
    }
    return 1;
}

native function RevertDeathRagdoll()
{
}

native function PlayDeathRagdoll()
{
}

native function UpdateAliceDressLoading()
{
}

native function bool DoesWonderlandDressPackageExist(EAliceWonderlandDresses Dress)
{
    Dress;
}

native function EAliceWonderlandDresses GetUserWonderlandDress()
{
}

native function SetUserWonderlandDress(EAliceWonderlandDresses Dress)
{
    Dress;
}

native function bool IsLoadingWonderlandDressPackage(EAliceWonderlandDresses Dress)
{
    Dress;
}

native function int LoadWonderlandDressPackage(EAliceWonderlandDresses Dress, bool bShouldBlock, GFxMovie pGFXMovie)
{
    Dress;
    bShouldBlock;
    pGFXMovie;
}

function GetDefaultWonderlandDress()
{
    DefaultDress.SkelMesh = Mesh.SkeletalMesh;
    DefaultDress.Bow = BowComponent.SkeletalMesh;
    DefaultDress.Ribbon = RibbonComponent.SkeletalMesh;
    DefaultDress.Skirt = SkirtComponent.SkeletalMesh;
    CurWonderlandDress = 0;
    GetHairInfoFromHairComponent(DefaultHair);
    CurHair = DefaultHair;
}

event GetHairInfoFromHairComponent(out HairSimulationInfo HairInfo)
{
    HairInfo.HairTemplate = HairComponent.Template;
    HairInfo.PhysicsAsset = HairComponent.PhysicsAsset;
    HairInfo.Force = HairComponent.Force;
    HairInfo.PerturbAmplitude = HairComponent.PerturbAmplitude;
    HairInfo.PerturbTemporalPeriod = HairComponent.PerturbTemporalPeriod;
    HairInfo.PerturbSpatialPeriod = HairComponent.PerturbSpatialPeriod;
    HairInfo.PerturbPhaseShift = HairComponent.PerturbPhaseShift;
    HairInfo.Damping = HairComponent.Damping;
    HairInfo.Iteration = HairComponent.Iteration;
    HairInfo.LengthScale = HairComponent.LengthScale;
    HairInfo.Material = HairComponent.Material;
    HairInfo.TessellationStep = HairComponent.TessellationStep;
    HairInfo.StrandWidth = HairComponent.StrandWidth;
    HairInfo.FloatForce = HairFloatForce;
    HairInfo.FloatPerturbAmplitude = HairFloatPerturbAmplitude;
    HairInfo.FloatDamping = HairFloatDamping;
}

event SetHairInfoToHairComponent(out HairSimulationInfo HairInfo)
{
    HairComponent.Template = HairInfo.HairTemplate;
    HairComponent.PhysicsAsset = HairInfo.PhysicsAsset;
    HairComponent.Force = HairInfo.Force;
    HairComponent.PerturbAmplitude = HairInfo.PerturbAmplitude;
    HairComponent.PerturbTemporalPeriod = HairInfo.PerturbTemporalPeriod;
    HairComponent.PerturbSpatialPeriod = HairInfo.PerturbSpatialPeriod;
    HairComponent.PerturbPhaseShift = HairInfo.PerturbPhaseShift;
    HairComponent.Damping = HairInfo.Damping;
    HairComponent.Iteration = HairInfo.Iteration;
    HairComponent.LengthScale = HairInfo.LengthScale;
    HairComponent.Material = HairInfo.Material;
    HairComponent.TessellationStep = HairInfo.TessellationStep;
    HairComponent.StrandWidth = HairInfo.StrandWidth;
    HairFloatForce = HairInfo.FloatForce;
    HairFloatPerturbAmplitude = HairInfo.FloatPerturbAmplitude;
    HairFloatDamping = HairInfo.FloatDamping;
    CurHair = HairInfo;
}

function ForceDetachAllNPC()
{
    local int I;
    
    for (I = 0; I < AttachNPCSockets.Length; I++)
    {
        if (AttachNPCSockets[I].AttachedNPC != none && AttachNPCSockets[I].bOccupied)
        {
            AttachNPCSockets[I].AttachedNPC.ForceDetechFromAlice();
        }
    }
}

function bool DetachNPC(AliceGameKynapsePawn PawnToBeDetached)
{
    local int SocketIndex;
    local bool bSucceed, bIsAnyDetachedNPC;
    local AlicePlayerController APC;
    
    APC = AlicePlayerController(Controller);
    for (SocketIndex = 0; SocketIndex < AttachNPCSockets.Length; SocketIndex++)
    {
        if (AttachNPCSockets[SocketIndex].bOccupied && AttachNPCSockets[SocketIndex].AttachedNPC == PawnToBeDetached)
        {
            AttachNPCSockets[SocketIndex].AttachedNPC = none;
            AttachNPCSockets[SocketIndex].bOccupied = false;
            bSucceed = true;
            PawnToBeDetached.SetCollision(true, true);
            PawnToBeDetached.DetachFromAlice(self);
            NbOfAttachedNPC--;
            break;
        }
    }
    if (!bSucceed)
    {
    }
    else
    {
        for (SocketIndex = 0; SocketIndex < AttachNPCSockets.Length; SocketIndex++)
        {
            if (AttachNPCSockets[SocketIndex].bOccupied)
            {
                bIsAnyDetachedNPC = true;
                break;
            }
        }
        if (!bIsAnyDetachedNPC && APC != none && APC.IsInState('AttachedByNPCs'))
        {
            StopHealthDamageEffect(false, HealthLevels[3].HealthSound, HealthLevels[3].HealthCameraAnim);
            APC.GotoState('PlayerWalking');
        }
    }
    return bSucceed;
}

function bool AttachNPC(AliceGameKynapsePawn PawnToBeAttached)
{
    local int SocketIndex;
    local bool bSucceed;
    local AlicePlayerController APC;
    local int Count;
    
    APC = AlicePlayerController(Controller);
    SocketIndex = Rand(AttachNPCSockets.Length);
    for (; Count < AttachNPCSockets.Length; Count++)
    {
        if (!AttachNPCSockets[SocketIndex].bOccupied)
        {
            AttachNPCSockets[SocketIndex].AttachedNPC = PawnToBeAttached;
            AttachNPCSockets[SocketIndex].bOccupied = true;
            bSucceed = true;
            PawnToBeAttached.SetCollision(true, false, true);
            PawnToBeAttached.AttachToAlice(self, AttachNPCSockets[SocketIndex].SocketName);
            NbOfAttachedNPC++;
            break;
        }
        SocketIndex++;
        if (SocketIndex >= AttachNPCSockets.Length)
        {
            SocketIndex = 0;
        }
    }
    if (!bSucceed)
    {
    }
    else if (APC != none && !APC.IsInState('AttachedByNPCs'))
    {
        if (APC.bFirstPersonViewActive)
        {
            APC.QuitFPS();
        }
        if (Weapon != none && Weapon.IsA('WeaponForAliceMelee'))
        {
            WeaponForAliceMelee(Weapon).ResetWeaponInput();
        }
        APC.RecoverToDefaultStatus(false, false, false);
        AttachedNPCBiteAliceSoundCue = PawnToBeAttached.AttachedNPCBiteAliceSoundCue;
        AttachedNPCAliceDamagedSoundCue = PawnToBeAttached.AttachedNPCAliceDamagedSoundCue;
        APC.GotoState('AttachedByNPCs');
    }
    return bSucceed;
}

event bool AllowNPCAttach()
{
    if (bShrinkingModeActive || IsDoingSpecialMove(37) || bInHysteriaMode)
    {
        return false;
    }
    return true;
}

event NotifyDetachNPC(Pawn DetachPawn)
{
    local AliceGameKynapsePawn kPawn;
    
    kPawn = AliceGameKynapsePawn(DetachPawn);
    if (kPawn != none)
    {
        DetachNPC(kPawn);
    }
}

event NotifyAttachNPC(Pawn AttachPawn)
{
    local AliceGameKynapsePawn kPawn;
    
    kPawn = AliceGameKynapsePawn(AttachPawn);
    if (kPawn != none && kPawn.IsAliveAndWell())
    {
        AttachNPC(kPawn);
    }
}

simulated event FadeOutUmbrella()
{
    if (UmbrellaInstance != none)
    {
        ClearTimer('ForceHideFadeOutUmbrella');
        UmbrellaInstance.Mesh.EnableForceTranslucency(true, 0.0, WeaponFadeOutTime, 1, false);
        if (!UmbrellaInstance.Mesh.HiddenGame)
        {
            SetTimer(WeaponFadeOutTime + 0.01, false, 'ForceHideFadeOutUmbrella');
        }
    }
}

simulated function FadeInUmbrella()
{
    if (UmbrellaInstance != none)
    {
        ClearTimer('ForceHideFadeOutUmbrella');
        UmbrellaInstance.Mesh.SetHidden(false);
        UmbrellaInstance.Mesh.EnableForceTranslucency(false, 1.0, WeaponFadeInTime, 1, false);
    }
}

function ForceHideFadeOutUmbrella()
{
    if (UmbrellaInstance != none)
    {
        UmbrellaInstance.Mesh.SetHidden(true);
    }
}

simulated function AttachUmbrella()
{
    if (UmbrellaArcheType != none && UmbrellaInstance == none)
    {
        UmbrellaInstance = Spawn(class'Umbrella', self, , , , UmbrellaArcheType);
        if (UmbrellaInstance != none)
        {
            UmbrellaInstance.AttachWeaponToAlice(UmbrellaAttachSocketName);
            ForceHideFadeOutUmbrella();
            UmbrellaInstance.CacheAnimNodes();
        }
    }
}

simulated function FadeOutWeapon(optional bool bDetachFromPawn = true)
{
    local Vector Loc;
    local Rotator Rot;
    local int iWeaponType;
    local name SktName;
    
    if (Weapon == none || WeaponForAlice(Weapon).CurMeshComponent == none || WeaponForAlice(Weapon).IsWeaponFadeToHide() || bInGiantMode)
    {
        return;
    }
    if (WeaponForAlice(Weapon).CurMeshComponent.EnableForceTranslucency(true, 0.0, WeaponFadeOutTime, 1, false))
    {
        iWeaponType = GetCurrentWeaponType();
        if (iWeaponType != 0 && HideWeaponParticles.Length > 0)
        {
            SktName = HideWeaponParticles[iWeaponType - 1].SocketToPlay;
            if (SktName != 'None')
            {
                WeaponForAlice(Weapon).CurMeshComponent.GetSocketWorldLocationAndRotation(SktName, Loc, Rot);
                PlayParticle(Loc, Rot, HideWeaponParticles[iWeaponType - 1].EffectParticle, true);
            }
        }
    }
    WeaponForAlice(Weapon).FadeOutWeapon();
    if (bDetachFromPawn)
    {
        Weapon.Mesh.DetachFromAny();
    }
}

simulated function DelayAttachWeapon()
{
    local WeaponPara tempweaponpara;
    
    WeaponForAlice(Weapon).bFadeToHide = false;
    foreach WeaponParas(tempweaponpara)
    {
        if (tempweaponpara.WeaponClass != none && tempweaponpara.WeaponClass == Weapon.Class)
        {
            WeaponForAlice(Weapon).AttachWeaponToAlice(tempweaponpara.DefaultAttachedSocketName);
            WeaponForAlice(Weapon).AttachOwnerData();
        }
    }
    FadeInWeapon();
}

simulated function ClearDelayAttachWeapon()
{
    ClearTimer('FadeInWeapon');
    ClearTimer('DelayAttachWeapon');
    WeaponForAlice(Weapon).ClearPressFireButtonTimer();
}

simulated function DelayWeaponFadeIn()
{
    ClearTimer('FadeInWeapon');
    ClearTimer('DelayAttachWeapon');
    if (!WeaponForAlice(Weapon).bFadeToHide)
    {
        return;
    }
    if (TeapotCannon(Weapon) != none)
    {
        SetTimer(0.1, false, 'DelayAttachWeapon');
    }
    else
    {
        SetTimer(WeaponFadeInDelay, false, 'DelayAttachWeapon');
    }
}

simulated function FadeInWeapon()
{
    local Vector Loc;
    local Rotator Rot;
    local int iWeaponType;
    local name SktName;
    local WeaponPara tempweaponpara;
    
    if (Weapon == none || WeaponForAlice(Weapon).CurMeshComponent == none || !WeaponForAlice(Weapon).IsWeaponFadeToHide())
    {
        return;
    }
    foreach WeaponParas(tempweaponpara)
    {
        if (tempweaponpara.WeaponClass != none && tempweaponpara.WeaponClass == Weapon.Class)
        {
            WeaponForAlice(Weapon).AttachWeaponToAlice(tempweaponpara.DefaultAttachedSocketName);
            WeaponForAlice(Weapon).AttachOwnerData();
        }
    }
    if (WeaponForAlice(Weapon).CurMeshComponent.EnableForceTranslucency(false, 1.0, WeaponFadeInTime, 1, false))
    {
        iWeaponType = GetCurrentWeaponType();
        if (iWeaponType != 0 && ShowWeaponParticles.Length > 0)
        {
            SktName = ShowWeaponParticles[iWeaponType - 1].SocketToPlay;
            if (SktName != 'None')
            {
                WeaponForAlice(Weapon).CurMeshComponent.GetSocketWorldLocationAndRotation(SktName, Loc, Rot);
                PlayParticle(Loc, Rot, ShowWeaponParticles[iWeaponType - 1].EffectParticle, true);
            }
        }
    }
    WeaponForAlice(Weapon).FadeInWeapon();
}

simulated function ClearTimerToHideWeapon()
{
    if (IsTimerActive('PendingHideWeapon'))
    {
        ClearTimer('PendingHideWeapon');
    }
}

simulated function SetTimerToHideWeapon()
{
    if (!IsTimerActive('PendingHideWeapon'))
    {
        SetTimer(WeaponForAlice(Weapon).NoLockHideWeaponTime, false, 'PendingHideWeapon');
    }
}

simulated function PendingHideWeapon()
{
    if (WeaponForAliceRange(Weapon) != none)
    {
        if (Weapon.PendingFire(0) || Weapon.PendingFire(1))
        {
            return;
        }
    }
    WeaponForAlice(Weapon).bInUse = false;
    if (!(WeaponForAlice(Weapon).IsWeaponHidden() || WeaponForAlice(Weapon).IsWeaponFadeToHide()))
    {
        if (!bInLockOnMode)
        {
            FadeOutWeapon();
        }
    }
}

event PlayAttackForceFeedback(AliceGamePawn ConfigPawn)
{
    if (ConfigPawn.ActivateRumbleOnWeaponHit == false)
    {
        return;
    }
    PlayerController(Controller).ClientPlayForceFeedbackWaveform(ConfigPawn.attackForceFeedback);
}

simulated function Rotator GetAdjustedAimFor(Weapon W, Vector StartFireLoc)
{
    local Vector CrossHairLocation, AimDir, Loc;
    local Rotator Rot;
    
    if (!AlicePlayerController(Controller).IsInState('FirstPersonView') || EyeStaff(W) == none)
    {
        return GetAdjustedAimFor(W, StartFireLoc);
    }
    CrossHairLocation = AlicePlayerController(Controller).CrossHairLocation;
    if (W.Mesh != none)
    {
        W.Mesh.GetSocketWorldLocationAndRotation(WeaponForAlice(W).RangeAttackSocket, Loc, Rot);
    }
    AimDir = CrossHairLocation - Loc;
    return rotator(AimDir);
}

function ResetRepulsor()
{
    bRepulsor = false;
}

event GiantStomp(float HitRadius, float HitAngle)
{
    local AliceGameCrowdAgent CrowdAgent;
    local GameBreakableActor BreakableActor;
    local Vector pos, Start, End, HitLoc, HitNorm;
    local Actor npc;
    local float Angle;
    local ApexDestructibleActor DestructibleActor;
    local Vector LPos;
    
    foreach VisibleActors(class'AliceGameCrowdAgent', CrowdAgent, HitRadius, Location)
    {
        Angle = AlicePlayerController(Controller).CalcAngleBetweenVectors(vector(Rotation), CrowdAgent.Location - Location);
        if (Abs(Angle) < HitAngle * 0.017453292 * 0.5)
        {
            CrowdAgent.TakeDamage(StompDamege, AlicePlayerController(Controller), Location, vector(Rotation), StompDamageType);
        }
    }
    pos = Mesh.GetBoneLocation('Bip01-R-Foot', 0);
    foreach CollidingActors(class'GameBreakableActor', BreakableActor, HitRadius * float(3), pos)
    {
        Angle = AlicePlayerController(Controller).CalcAngleBetweenVectors(vector(Rotation), BreakableActor.Location - Location);
        if (Abs(Angle) < HitAngle * 0.017453292 * 0.5)
        {
            Start = Location;
            End = BreakableActor.Location - Location;
            if (VSize(End) < HitRadius)
            {
                BreakableActor.TakeDamage(StompDamege, AlicePlayerController(Controller), pos, vector(Rotation), StompDamageType);
                continue;
            }
            End = Normal(End) * HitRadius;
            npc = Trace(HitLoc, HitNorm, End, Start, true);
            if (GameBreakableActor(npc) == BreakableActor)
            {
                npc.TakeDamage(StompDamege, AlicePlayerController(Controller), pos, vector(Rotation), StompDamageType);
            }
        }
    }
    LPos = Mesh.GetBoneLocation('Bip01-L-Foot', 0);
    foreach CollidingActors(class'Engine.ApexDestructibleActor', DestructibleActor, HitRadius * float(4), LPos)
    {
        DestructibleActor.TakeDamage(StompDamege, AlicePlayerController(Controller), LPos, vect(0.0, 0.0, -1.0), StompDamageType);
    }
    if (RepulsorSecond > float(1))
    {
        if (bRepulsor)
        {
            SetTimer(0.0, false, 'ResetRepulsor');
        }
        bRepulsor = true;
        SetTimer(RepulsorSecond, false, 'ResetRepulsor');
    }
}

function LeaveSprintState()
{
    local AlicePlayer_MovementStateBase PlayerState;
    
    PlayerState = AlicePlayerController(Controller).GetCurrentMovementState();
    if (PlayerState != none && PlayerState.IsInState('Sprint'))
    {
        PlayerState.SetPlayerBasicMovementState(1);
        PlayerState.GotoState('Walking');
    }
}

event HitWall(Vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
{
    local Vector NewLoc;
    
    if (bBoostingSwim && !Wall.IsA('SkeletalMeshActor') && !Wall.IsA('GameBreakableActor'))
    {
        LastSwimSpeed = Normal(MirrorVectorByNormal(Normal(LastSwimSpeed), HitNormal));
        curSwimSpeed *= 0.1;
        SetRotation(rotator(LastSwimSpeed));
        AlicePlayerController(Controller).SwimBounceOff();
    }
    else if (Wall.IsA('JumpPadPhysics') && Abs(HitNormal.Z) < 0.2)
    {
        NewLoc = Location;
        NewLoc.Z -= float(10);
        SetLocation(NewLoc);
    }
    HitWall(HitNormal, Wall, WallComp);
}

simulated function bool IsMeleeFiring()
{
    return IsDoingComboBlendSpecialMove() || IsDoingNonLockMeleeAttackSpecialMove() || IsDoingSpecialMove(37) || IsShieldBlocking() || IsDoingSpecialMove(39) || IsDoingSpecialMove(40) || IsDoingSpecialMove(41) || IsDoingSpecialMove(42) || IsDoingSpecialMove(43) || IsDoingSpecialMove(44) || IsDoingSpecialMove(18) || IsDoingSpecialMove(47);
}

simulated function bool IsRangeFiring()
{
    return IsDoingRangeBlendSpecialMove();
}

simulated function bool IsFighting()
{
    return IsRangeFiring() || IsMeleeFiring();
}

event AliceVopalBladeGhost CreateGhost()
{
    local AliceVopalBladeGhost Ghost;
    
    Ghost = Spawn(class'AliceVopalBladeGhost', self, , Location);
    if (Ghost != none && !Ghost.bDeleteMe)
    {
        Ghost.Instigator = self;
    }
    return Ghost;
}

exec function DrawTargetCone()
{
    bDrawTargetCone = !bDrawTargetCone;
}

function bool CannotUnShrink()
{
    return !CanUnShrinking();
}

function float GetMaxStrafeSpeed()
{
    local float BlendedStrafeSpeed;
    local StrafeSpeed sWeaponStrafeSpeed;
    local float A, B, InputSize;
    local Vector vInput;
    
    switch (GetCurrentWeaponType())
    {
        case 1:
            sWeaponStrafeSpeed = VorpalBlade_StrafeSpeed;
            break;
        case 4:
            if (TeapotCannon(Weapon).bFinishCharge || IsDoingSpecialMove(21))
            {
                sWeaponStrafeSpeed = (bInLockOnMode ? TeapotCannon_Charge_StrafeSpeed : TeapotCannon_Charge_StrafeSpeed_Aiming);
            }
            else
            {
                sWeaponStrafeSpeed = (bInLockOnMode ? TeapotCannon_StrafeSpeed : TeapotCannon_StrafeSpeed_Aiming);
            }
            break;
        case 3:
            sWeaponStrafeSpeed = (bInLockOnMode ? EyeStaff_StrafeSpeed : EyeStaff_StrafeSpeed_Aiming);
            break;
        case 2:
            sWeaponStrafeSpeed = HobbyHorse_StrafeSpeed;
            break;
        case 0:
            return 0.0;
        default:
    }
    vInput.X = AlicePlayerController(Controller).PlayerInput.aStrafe;
    vInput.Y = AlicePlayerController(Controller).PlayerInput.aForward;
    vInput.Z = 0.0;
    InputSize = VSize(vInput);
    if (InputSize == float(0))
    {
        return 0.0;
    }
    vInput.X = vInput.X / InputSize;
    vInput.Y = vInput.Y / InputSize;
    if (vInput.X == float(0))
    {
        BlendedStrafeSpeed = (vInput.Y < float(0) ? sWeaponStrafeSpeed.Backward : sWeaponStrafeSpeed.Forward);
    }
    else if (vInput.Y == float(0))
    {
        BlendedStrafeSpeed = (vInput.X < float(0) ? sWeaponStrafeSpeed.Left : sWeaponStrafeSpeed.Right);
    }
    else
    {
        if (vInput.X > float(0) && vInput.Y > float(0))
        {
            A = sWeaponStrafeSpeed.Right;
            B = sWeaponStrafeSpeed.Forward;
        }
        else if (vInput.X < float(0) && vInput.Y > float(0))
        {
            A = -sWeaponStrafeSpeed.Left;
            B = sWeaponStrafeSpeed.Forward;
        }
        else if (vInput.X < float(0) && vInput.Y < float(0))
        {
            A = -sWeaponStrafeSpeed.Left;
            B = -sWeaponStrafeSpeed.Backward;
        }
        else if (vInput.X > float(0) && vInput.Y < float(0))
        {
            A = sWeaponStrafeSpeed.Right;
            B = -sWeaponStrafeSpeed.Backward;
        }
        A = A * vInput.X;
        B = B * vInput.Y;
        BlendedStrafeSpeed = Sqrt(A * A + B * B);
    }
    return BlendedStrafeSpeed;
}

event Bump(Actor Other, PrimitiveComponent OtherComp, Vector HitNormal)
{
    AlicePlayerController(Controller).Bump(Other, OtherComp, HitNormal);
}

event Vector AdjustSteamVentVelocity(Volume Volume, out Vector Curvelocity, float DeltaTime)
{
    local AliceHoverVolume HVolume;
    
    HVolume = AliceHoverVolume(Volume);
    if (HVolume != none)
    {
        Curvelocity = HVolume.GetAdjustVelocity(self, DeltaTime);
    }
    else if (AlicePlayerController(Controller).ventActor != none)
    {
        Curvelocity = AlicePlayerController(Controller).ventActor.GetAdjustVelocity(self, DeltaTime);
    }
    return Curvelocity;
}

event Vector GetSteamVentAccel(Volume Volume)
{
    local AliceHoverVolume HVolume;
    
    HVolume = AliceHoverVolume(Volume);
    if (HVolume != none)
    {
        return HVolume.GetAccel(self);
    }
    else if (AlicePlayerController(Controller).ventActor != none)
    {
        return AlicePlayerController(Controller).ventActor.GetAccel(self);
    }
    return vect(0.0, 0.0, 0.0);
}

function bool IsNewSteamVent()
{
    return AliceCheatManager(AlicePlayerController(Controller).CheatManager).bNewSteamVent;
}

function CheshireCatSkeletalMeshActor GetCheshireCatSkelActor()
{
    if (CheshireCatSkelActor == none)
    {
        CheshireCatSkelActor = Spawn(class'CheshireCatSkeletalMeshActor', self);
    }
    return CheshireCatSkelActor;
}

event AddMorphWindEffect(float Scale)
{
    local HairComponent HairCom;
    local ClothComponent ClothComponent;
    
    foreach AllOwnedComponents(class'Engine.HairComponent', HairCom)
    {
        HairCom.Force += MorphWindForce * Scale;
        HairCom.PerturbAmplitude += MorphWindPerturbAmplitude * Scale;
    }
    foreach AllOwnedComponents(class'Engine.ClothComponent', ClothComponent)
    {
        ClothComponent.Force += MorphWindForce * Scale;
        ClothComponent.PerturbAmplitude += MorphWindPerturbAmplitude * Scale;
    }
}

simulated function float GetSpeedThresholdWalkNRun()
{
    return MaxWalkingSpeed + (MaxRunningSpeed - MaxWalkingSpeed) / float(2);
}

simulated function SetDamageEffect(Actor DamageCauser)
{
    local AlicePlayerController APC;
    local AliceGameProjectile localProjectile;
    
    APC = AlicePlayerController(Controller);
    if (APC == none)
    {
        return;
    }
    localProjectile = AliceGameProjectile(DamageCauser);
    if (localProjectile != none && AlicePlayerCamera(APC.PlayerCamera).CanSee(DamageCauser.Location))
    {
        APC.ClientSpawnCameraLensEffect(localProjectile.CameraExplosionEffectClass);
    }
}

function bool PickedUpNewWeapon(class<WeaponForAlice> NewWeaponClass)
{
    local WeaponPara NewWeaponPara;
    local WeaponForAlice NewW;
    
    foreach WeaponParas(NewWeaponPara)
    {
        if (NewWeaponPara.WeaponClass == NewWeaponClass && !NewWeaponPara.bAvailable)
        {
            break;
        }
    }
    NewW = WeaponForAlice(AliceInventoryManager(InvManager).HasInventoryOfClass(NewWeaponClass));
    if (NewW.WeaponPositionType == 0 && NewW.Mesh != none && NewWeaponPara.DefaultAttachedSocketName != 'None')
    {
        if (NewW.bMeleeWeaponAbility)
        {
            NewW.Mesh.InitRBPhys();
        }
        NewW.CurMeshComponent.EnableForceTranslucency(true, 0.0, WeaponFadeOutTime, 1, false);
        NewW.FadeOutWeapon();
    }
    return true;
}

event int GetCurrentWeaponType(optional bool bCheckHidden = true)
{
    local int Id;
    local WeaponForAlice AliceWeapon;
    local AlicePlayerController APC;
    
    Id = 0;
    EnableAirControl(true);
    if (Weapon == none)
    {
        return 0;
    }
    AliceWeapon = WeaponForAlice(Weapon);
    APC = AlicePlayerController(Controller);
    if (bCheckHidden && !bInLockOnMode && !APC.bFirstPersonViewActive && AliceWeapon != none && AliceWeapon.IsWeaponHidden() || AliceWeapon.IsWeaponFadeToHide())
    {
        return 0;
    }
    switch (Weapon.Class)
    {
        case class'VorpalBlade':
            Id = 1;
            break;
        case class'TeapotCannon':
            Id = 4;
            break;
        case class'HobbyHorse':
            Id = 2;
            break;
        case class'EyeStaff':
            Id = 3;
            break;
        case class'GiantAliceWeapon':
            Id = 5;
            break;
        default:
    }
    return Id;
}

function bool Died(Controller Killer, class<DamageType> DamageType, Vector HitLocation)
{
    AlicePlayerController(Controller).RecoverToDefaultStatus();
    AlicePlayerController(Controller).bHoldToggleLockOnButton = false;
    if (Controller.IsInState('Dead') == false)
    {
        Controller.GotoState('Dead');
    }
    return true;
}

function JumpOffPawn()
{
    local AlicePlayerController APC;
    
    JumpOffPawn();
    APC = AlicePlayerController(Controller);
    if (APC != none && APC.stuckManager != none)
    {
        APC.stuckManager.onJumpOffPawn();
    }
}

function ResetGlideCameraInertiaFlags()
{
    bEnableGlideCameraInertia = true;
    bGlideYawEnd = false;
    bGlidePitchEnd = false;
}

function ClampAngle(out Rotator Angle)
{
    while (Abs(float(Angle.Roll)) >= float(65535))
    {
        Angle.Roll += (Angle.Roll > 0 ? -65535 : 65535);
    }
    while (Abs(float(Angle.Yaw)) >= float(65535))
    {
        Angle.Yaw += (Angle.Yaw > 0 ? -65535 : 65535);
    }
    while (Abs(float(Angle.Pitch)) >= float(65535))
    {
        Angle.Pitch += (Angle.Pitch > 0 ? -65535 : 65535);
    }
}

function PlayParticle(Vector Loc, Rotator Rot, ParticleSystem NewTemplate, bool bDestroyOnFinish, optional Actor MyBase = none)
{
    local Emitter ParticleEmitter;
    
    ParticleEmitter = Spawn(class'Engine.EmitterSpawnable', self, , Loc, Rot);
    if (ParticleEmitter != none)
    {
        ParticleEmitter.SetLocation(Loc);
        ParticleEmitter.SetRotation(Rot);
        ParticleEmitter.SetTemplate(NewTemplate, bDestroyOnFinish);
        if (MyBase != none)
        {
            ParticleEmitter.SetBase(MyBase);
        }
    }
}

function SetGlideType(int iType)
{
    if (iType >= 0 && iType <= 1)
    {
        GlideType = byte(iType);
    }
}

exec function ThrowWeapon()
{
    if (AlicePlayerInput(AlicePlayerController(Controller).PlayerInput).bDisableInputInCinematic)
    {
        return;
    }
    ThrowActiveWeapon();
}

function EndGlideLoopingEffect()
{
    if (GlideAC != none)
    {
        GlideAC.FadeOut(FloatFadeOutTime, FloatFadeOutVolume);
    }
}

function StartGlideLoopingEffect()
{
    if (GlideAC == none)
    {
        GlideAC = CreateAudioComponent(GlideLoopingCue);
    }
    if (GlideAC != none)
    {
        GlideAC.FadeIn(FloatFadeInTime, FloatFadeInVolume);
    }
}

function StopSlideCameraAnim()
{
    SetAliceAbilityCamera(SlideCamera, true);
}

function PlaySlideCameraAnim()
{
    if (!AlicePlayerController(Controller).bShrinkingModeActive)
    {
        SetAliceAbilityCamera(SlideCamera);
    }
}

function PlayGlideBeginParticle()
{
    local Emitter GlideBeginEmitter;
    
    if (GlideType == 0)
    {
        return;
    }
    GlideBeginEmitter = Spawn(class'Engine.EmitterSpawnable', self, , Location);
    if (GlideBeginEmitter != none)
    {
        GlideBeginEmitter.SetLocation(Location);
        GlideBeginEmitter.SetTemplate(ParticleSystem'GFX_Alice.Glide.GlideStart', true);
    }
}

function PlayGlideParticle(bool bTurnOn)
{
    if (!bTurnOn || !AlicePlayerController(Controller).AtTimeTick(3))
    {
        return;
    }
    GlideEmitter = Spawn(class'Engine.EmitterSpawnable', self, , Location);
    if (GlideEmitter != none)
    {
        GlideEmitter.SetTemplate(ParticleSystem'GFX_Alice.Glide.GlideTrail', true);
        GlideEmitter.SetLocation(Location);
    }
}

function TriggerDressPhysic(bool TurnOn, float Intensity)
{
    if (SkirtComponent != none && SkirtComponent.SkeletalMesh != none)
    {
        SkirtComponent.SkeletalMesh.bDressFloating = TurnOn;
        SkirtComponent.SkeletalMesh.DressFloatingParam.Intensity = Intensity;
    }
    if (RibbonComponent != none && RibbonComponent.SkeletalMesh != none)
    {
        RibbonComponent.SkeletalMesh.bDressFloating = TurnOn;
        RibbonComponent.SkeletalMesh.DressFloatingParam.Intensity = Intensity;
    }
    if (BowComponent != none && BowComponent.SkeletalMesh != none)
    {
        BowComponent.SkeletalMesh.bDressFloating = TurnOn;
        BowComponent.SkeletalMesh.DressFloatingParam.Intensity = Intensity;
    }
}

function SetNormalWalkParameters()
{
    SetNormalWalkParameters();
}

function SetForegroundUIDOFParameters(out PostProcessSettings PPSettings)
{
    PPSettings.DOF_EnableDynamicDoF = false;
    PPSettings.DOF_FocusNearInnerRadius = 100000.0;
    PPSettings.DOF_FocusDistance = 0.0;
    PPSettings.DOF_FocusType = 0;
}

function SetLockOnDOFParameters(out PostProcessSettings PPSettings)
{
    PPSettings.bEnableDOF = true;
    PPSettings.DOF_EnableDynamicDoF = false;
    PPSettings.DOF_FalloffExponent = CamLockOnDOFSettings.FalloffExponent;
    PPSettings.DOF_BlurKernelSize = CamLockOnDOFSettings.BlurKernelSize;
    PPSettings.DOF_FocusNearInnerRadius = CamLockOnDOFSettings.FocusNearInnerRadius;
    PPSettings.DOF_FocusFarInnerRadius = CamLockOnDOFSettings.FocusFarInnerRadius;
    PPSettings.DOF_FocusDistance = CamLockOnDOFSettings.NearFocusDistance;
    PPSettings.DOF_ResetAdaptationRate = CamLockOnDOFSettings.AdaptationRate;
    PPSettings.DOF_FocusType = 2;
}

event ModifyCameraPostProcessSettings_AfterSuper(out PostProcessSettings PPSettings, bool bGamePlayCamera)
{
}

event ModifyCameraPostProcessSettings(out PostProcessSettings PPSettings, bool bGamePlayCamera)
{
    local AlicePlayerController APC;
    local float DistToCamera;
    local int FlagX, FlagY, FlagZ;
    
    APC = AlicePlayerController(Controller);
    if (APC == none)
    {
        return;
    }
    else if (bGamePlayCamera && APC.bTargetingModeActive && APC.TargetNPCSocket.Pawn != none)
    {
        SetLockOnDOFParameters(PPSettings);
        PPSettings.DOF_FarFocusDistance = 0.5 * VSize(APC.MyAlicePawn.Location - APC.TargetNPCSocket.Pawn.GetCameraTargetSocketLoc(APC.TargetNPCSocket.SocketIndex)) + CamLockOnDOFSettings.FarFocusDistanceOffset;
        PPSettings.DOF_FocusPosition = 0.5 * (APC.MyAlicePawn.Location + APC.TargetNPCSocket.Pawn.GetCameraTargetSocketLoc(APC.TargetNPCSocket.SocketIndex));
    }
    else if (bGamePlayCamera && APC.bTargetingModeActive && APC.TargetBActorInfo.BActor != none)
    {
        SetLockOnDOFParameters(PPSettings);
        PPSettings.DOF_FarFocusDistance = 0.5 * VSize(APC.MyAlicePawn.Location - APC.TargetBActorInfo.BActor.Location) + CamLockOnDOFSettings.FarFocusDistanceOffset;
        PPSettings.DOF_FocusPosition = 0.5 * (APC.MyAlicePawn.Location + APC.TargetBActorInfo.BActor.Location);
    }
    else if (APC.bKeepAliceInFocus && PPSettings.bEnableDOF)
    {
        AlicePlayerCamera(APC.PlayerCamera).InSightEx(Location, FlagX, FlagY, FlagZ);
        if (FlagZ != -1)
        {
            DistToCamera = VSize(Location - APC.PlayerCamera.CameraCache.POV.Location);
            if (DistToCamera < PPSettings.DOF_FocusDistance)
            {
                PPSettings.DOF_FocusDistance = DistToCamera;
            }
        }
    }
}

function SwitchLockOnCamera(bool bCombat)
{
    if (bCombat)
    {
        TargetCameraOffsetY = CombatCamera.Offset.Y;
        bAliceStartCombatCam = true;
        bAliceCombatCamReady = false;
        LockOnTargetCount = 0;
    }
    else
    {
        bAliceStartCombatCam = false;
        bAliceCombatCamReady = false;
    }
}

function SetLockOnCameraParameters()
{
}

function SetWaterWalkParameters()
{
    SetWaterWalkParameters();
    SetAliceAbilityCamera(WaterWalkCamera);
}

function SetSwimParameters()
{
    SetAliceAbilityCamera(SwimCamera);
    SetSwimParameters();
}

exec function ToggleCommLink()
{
    if (AlicePlayerInput(AlicePlayerController(Controller).PlayerInput).bDisableInputInCinematic)
    {
        return;
    }
    SetConversing(!bIsConversing, !bUsingCommLink);
}

function bool isInConversationMode()
{
    return bIsConversing;
}

simulated function SetUsingCommLink(bool bUsing)
{
    if (bUsing)
    {
        bCanClimbLadders = false;
        OldInvManager = InvManager;
        InvManager = none;
        Controller.ClientSetWeapon(none);
    }
    else
    {
        InvManager = OldInvManager;
        bCanClimbLadders = true;
        AlicePlayerController(Controller).bPressedJump = false;
    }
    if (!bUsing && bUsingCommLink)
    {
        if (bIsConversing)
        {
        }
        else
        {
            bUsingCommLink = false;
        }
    }
    bWantToUseCommLink = bUsing;
}

simulated event SetConversing(bool bConv, optional bool bUseCommLink)
{
    if (bConv && !bIsConversing)
    {
        if (bUseCommLink)
        {
            bIsConversing = true;
            SetUsingCommLink(true);
        }
    }
    else if (!bConv && bIsConversing)
    {
        SetUsingCommLink(false);
        bIsConversing = false;
    }
    bWantToConverse = bConv;
    if (!bWantToConverse)
    {
        bWantToUseCommLink = false;
    }
}

event StopRoll()
{
    local HairComponent Local_HairComponent;
    
    Mesh.DetachComponent(RollSphere);
    RollSphere = none;
    Mesh.SetPhysicsAsset(Mesh.default.PhysicsAsset, true);
    Mesh.SetNotifyRigidBodyCollision(false);
    Mesh.PhysicsWeight = 0.0;
    Mesh.SetHidden(false);
    AttachComponent(CylinderComponent);
    CollisionComponent = CylinderComponent;
    foreach AllOwnedComponents(class'Engine.HairComponent', Local_HairComponent)
    {
        Local_HairComponent.SetHidden(false);
    }
}

event StartRoll()
{
    local HairComponent Local_HairComponent;
    local SkeletalMeshComponent Local_SkeletalMeshComponent;
    
    Mesh.SetPhysicsAsset(RollPhysicsAsset);
    Mesh.SetHasPhysicsAssetInstance(true);
    Mesh.SetNotifyRigidBodyCollision(true);
    Mesh.PhysicsWeight = 1.0;
    Mesh.PhysicsAssetInstance.SetAllBodiesFixed(false);
    CollisionComponent = Mesh;
    Mesh.bUpdateJointsFromAnimation = false;
    Mesh.bUpdateKinematicBonesFromAnimation = false;
    Mesh.SetRBMaxAngularVelocity(RollMaxAngularVelocity);
    Mesh.SetActorCollision(true, true, true);
    DetachComponent(CylinderComponent);
    foreach AllOwnedComponents(class'Engine.HairComponent', Local_HairComponent)
    {
        Local_HairComponent.SetHidden(true);
    }
    foreach AllOwnedComponents(class'Engine.SkeletalMeshComponent', Local_SkeletalMeshComponent)
    {
        Local_SkeletalMeshComponent.SetHidden(true);
    }
    SetPhysics(10);
    RollSphere = new(self, "RollSphere") class'Engine.StaticMeshComponent';
    RollSphere.SetStaticMesh(RollMesh);
    RollSphere.SetLightEnvironment(Mesh.LightEnvironment);
    Mesh.AttachComponent(RollSphere, 'Root');
    Mesh.SetRBPosition(Mesh.GetBoneLocation('Bip01-Pelvis', 0));
    bInRollingMode = true;
}

function LeaveSwimMode()
{
    if (!bInSwimCloth)
    {
        return;
    }
    PlayParticle(Location, Rotation, ChangeSwimModleParticle, true);
    bInSwimCloth = false;
}

exec function SwimmingDressTest()
{
    local ClothComponent ClothComponent;
    
    if (bInSwimCloth)
    {
        return;
    }
    foreach AllOwnedComponents(class'Engine.ClothComponent', ClothComponent)
    {
        ClothComponent.SetHidden(true);
    }
    HairComponent.Force = vect(0.0, 0.0, 0.0);
    HairComponent.Damping = 10.0;
    HairComponent.PhysicsAsset = SwimHairPhysicsAsset;
    HairComponent.Template = SwimHair;
    HairComponent.Template.UpdateStrands();
    HairComponent.OverrideMesh = none;
    Mesh.AttachComponent(SwimBow, 'Dummy_Bow');
    Mesh.AttachComponent(SwimLight, 'Dummy_Streamer');
    Mesh.AttachComponent(SwimTailfin, 'CATRigTail7');
    PlayParticle(Location, Rotation, ChangeSwimModleParticle, true);
    bInSwimCloth = true;
}

exec function SwitchToWaterWalkDress()
{
    local ClothComponent ClothComponent;
    
    foreach AllOwnedComponents(class'Engine.ClothComponent', ClothComponent)
    {
        ClothComponent.SetHidden(true);
    }
    HairComponent.Force = default.HairComponent.Force;
    HairComponent.Damping = default.HairComponent.Damping;
    HairComponent.PhysicsAsset = default.HairComponent.PhysicsAsset;
    HairComponent.Template = Hair;
    HairComponent.Template.GuideRestitutionRoot = HairComponent.Template.default.GuideRestitutionRoot;
    HairComponent.Template.GuideRestitutionDecay = HairComponent.Template.default.GuideRestitutionDecay;
    HairComponent.Template.UpdateStrands();
    HairComponent.OverrideMesh = none;
    PlayParticle(Location, Rotation, ChangeSwimModleParticle, true);
    Mesh.AttachComponent(HairComponent, 'Bip01-Head');
    Mesh.AttachComponent(WaterWalkBow, 'Dummy_Bow');
    Mesh.AttachComponent(WaterWalkTailfin, 'Bip01-Pelvis');
}

event SmokeSkinTest()
{
    local int I;
    local ClothComponent ClothComponent;
    local HairComponent Local_HairComponent;
    local SkeletalMeshComponent SkeletalMeshComponent;
    
    foreach AllOwnedComponents(class'Engine.SkeletalMeshComponent', SkeletalMeshComponent)
    {
        for (I = 0; I < SkeletalMeshComponent.Materials.Length; I++)
        {
            SkeletalMeshComponent.SetMaterial(I, SmokeSkinMaterial);
        }
    }
    foreach AllOwnedComponents(class'Engine.ClothComponent', ClothComponent)
    {
        for (I = 0; I < ClothComponent.Materials.Length; I++)
        {
            ClothComponent.SetMaterial(I, SmokeSkinMaterial);
        }
    }
    foreach AllOwnedComponents(class'Engine.HairComponent', Local_HairComponent)
    {
        Local_HairComponent.Material = SmokeSkinMaterial;
    }
}

event RevertDeathMaterial()
{
    local int Index;
    local Vector Loc;
    local Rotator Rot;
    local MaterialInstanceTimeVarying pMaterial;
    
    Loc = Location;
    Rot = Rotation;
    if (DeathSoundFX != none)
    {
        PlaySound(RespawnSoundFX);
    }
    for (Index = 0; Index < RespawnRagdollParticleArray.Length; Index++)
    {
        if (RespawnRagdollParticleArray[Index].Particle != none)
        {
            if (RespawnRagdollParticleArray[Index].Socket != 'None')
            {
                Mesh.GetSocketWorldLocationAndRotation(RespawnRagdollParticleArray[Index].Socket, Loc, Rot);
            }
            else if (RespawnRagdollParticleArray[Index].Bone != 'None')
            {
                Loc = Mesh.GetBoneLocation(RespawnRagdollParticleArray[Index].Bone);
                Rot = rot(0, 0, 1);
            }
            PlayParticle(Loc, Rot, RespawnRagdollParticleArray[Index].Particle, true);
        }
    }
    for (Index = 0; Index < RespawnMaterialArray.Length; Index++)
    {
        pMaterial = MaterialInstanceTimeVarying(Mesh.GetMaterial(RespawnMaterialArray[Index].MaterialID));
        if (pMaterial != none)
        {
            pMaterial.SetScalarStartTime(RespawnMaterialArray[Index].ParameterName, 0.0);
        }
    }
}

event PlayDeathParticleAndSound()
{
    local int Index;
    local Vector Loc;
    local Rotator Rot;
    local MaterialInstanceTimeVarying pMaterial;
    
    Loc = Location;
    Rot = Rotation;
    if (DeathSoundFX != none)
    {
        PlaySound(DeathSoundFX);
    }
    for (Index = 0; Index < DeathRagdollParticleArray.Length; Index++)
    {
        if (DeathRagdollParticleArray[Index].Particle != none)
        {
            if (DeathRagdollParticleArray[Index].Socket != 'None')
            {
                Mesh.GetSocketWorldLocationAndRotation(DeathRagdollParticleArray[Index].Socket, Loc, Rot);
            }
            else if (DeathRagdollParticleArray[Index].Bone != 'None')
            {
                Loc = Mesh.GetBoneLocation(DeathRagdollParticleArray[Index].Bone);
                Rot = rot(0, 0, 1);
            }
            PlayParticle(Loc, Rot, DeathRagdollParticleArray[Index].Particle, true);
        }
    }
    for (Index = 0; Index < DeathMaterialArray.Length; Index++)
    {
        pMaterial = MaterialInstanceTimeVarying(Mesh.GetMaterial(DeathMaterialArray[Index].MaterialID));
        if (pMaterial != none)
        {
            pMaterial.SetScalarStartTime(DeathMaterialArray[Index].ParameterName, 0.0);
        }
    }
}

event SmokeParticleTest()
{
    if (SmokeParticleEmitter == none)
    {
        SmokeParticleEmitter = Spawn(class'Engine.EmitterSpawnable', self);
        SmokeParticleEmitter.SetBase(self);
        SmokeParticleEmitter.SetTemplate(ParticleSystem'Fluid_Test.OilSkeleton_Particle');
    }
    else
    {
        SmokeParticleEmitter.Destroy();
        SmokeParticleEmitter = none;
    }
}

function SetBubbleEffect()
{
    if (bBubbleEffectActive)
    {
        SetTimer(0.5, true, 'PlayBubbleEffect');
    }
    else
    {
        SetTimer(0.0, false, 'PlayBubbleEffect');
    }
}

function PlayBubbleEffect()
{
    local Vector SocketLoc;
    local Rotator SocketRot;
    
    Mesh.GetSocketWorldLocationAndRotation('Tongue', SocketLoc, SocketRot);
    PlayParticle(SocketLoc, Rotation, BubbleParticle, true);
}

event SetColdBreath()
{
    if (bColdBreathActive)
    {
        SetTimer(1.5, true, 'PlayColdBreath');
    }
    else
    {
        SetTimer(0.0, false, 'PlayColdBreath');
    }
}

function PlayColdBreath()
{
    local Vector SocketLoc;
    local Rotator SocketRot;
    
    Mesh.GetSocketWorldLocationAndRotation('Tongue', SocketLoc, SocketRot);
    PlayParticle(SocketLoc, Rotation, ColdBreathParticle, true);
}

simulated function Tick(float DeltaTime)
{
    local HairComponent hc;
    local ClothComponent CC;
    local Volume wv;
    local int Idx;
    
    foreach AllOwnedComponents(class'Engine.HairComponent', hc)
    {
        hc.Force = CurHair.Force;
        hc.Damping = CurHair.Damping;
        hc.PerturbAmplitude = CurHair.PerturbAmplitude;
        if (Controller.IsInState('PlayerFloat'))
        {
            hc.Force += HairFloatForce;
            hc.Damping += HairFloatDamping;
            hc.PerturbAmplitude += HairFloatPerturbAmplitude;
        }
    }
    foreach AllOwnedComponents(class'Engine.ClothComponent', CC)
    {
        CC.Force = CC.default.Force;
        CC.Damping = CC.default.Damping;
        CC.PerturbAmplitude = CC.default.PerturbAmplitude;
    }
    for (Idx = 0; Idx < Touching.Length; Idx++)
    {
        wv = Volume(Touching[Idx]);
        if (wv != none)
        {
            wv.ApplyWind(self);
        }
    }
    if (AlicePlayerController(Controller).ventActor != none)
    {
        AlicePlayerController(Controller).ventActor.ApplyWind(self);
    }
    HairComponent.PerturbAmplitude += VSize(Velocity) * HairPerturbAmplitudeScale;
    if (RibbonComponent != none)
    {
        RibbonComponent.PerturbAmplitude += VSize(Velocity) * RibbonPerturbAmplitudeScale;
    }
    if (!bIsConversing && bWantToConverse)
    {
        if (bWantToUseCommLink)
        {
        }
    }
    CheckCurrentHealth(DeltaTime);
    UpdateAliceDressLoading();
    if (bDelayedChangeWonderlandDress)
    {
        ChangeWonderlandDress(DelayedDressData.NewDress, DelayedDressData.bShouldBlock, DelayedDressData.pGFXMovie);
        bDelayedChangeWonderlandDress = false;
    }
    UpdateInUIMode(DeltaTime);
    if (AlicePlayerController(Controller).bCinematicMode)
    {
        RibbonComponent.RadialForceMagnitude = 0.001;
        RibbonComponent.Force = vect(0.0, 0.0, 0.0);
        RibbonComponent.Damping = (CurWonderlandDress == 2 ? 100.0 : 0.1);
        RibbonComponent.PerturbAmplitude = vect(0.0, 0.0, 0.0);
        RibbonComponent.RadialForcePosition = vect(0.0, 0.0, 0.0);
    }
    UpdateBlobShadow();
}

simulated function UpdateInUIMode(float DeltaTime)
{
    local AlicePlayerController APC;
    
    APC = AlicePlayerController(Controller);
    if (APC != none && APC.bInUIMode)
    {
        APC.UI_AliceTargetRotation.Yaw = NormalizeRotAxis(int(float(APC.UI_AliceTargetRotation.Yaw) + APC.UI_RotateSpeed * DeltaTime));
        SetRotation(AlicePlayerCamera(APC.PlayerCamera).CameraRotInertiaFunction(Rotation, APC.UI_AliceTargetRotation, 0.1, DeltaTime));
    }
}

event DoHitShieldReaction()
{
    WeaponForAlice(Weapon).CleanInfoWhenBreak();
    DoSpecialMove(43, true);
}

event TakeDamage(int Damage, Controller InstigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    local Rotator NewRot;
    local int I;
    local bool bbb;
    
    if (bInHysteriaMode && bHysteriaGodMode)
    {
        return;
    }
    if (DamageType == class'DmgType_IceSnark')
    {
        UpdateFreezingHit();
        return;
    }
    else if (Damage > 0)
    {
        EndFrozen();
    }
    if (bIsDoingContextAction)
    {
        return;
    }
    if (!bInGiantMode && IsAliveAndWell())
    {
        NotifyAllNpcAliceTakeDamage();
    }
    Damage = int(float(Damage) * AliceGameInfo(WorldInfo.Game).DamageMultiplierArray[AliceGameInfo(WorldInfo.Game).getCurrentGameDifficulty()]);
    Damage = int(float(Damage) * (1.0 - WeaponDefence_Percent) * (1.0 - ClothDefence_Percent) * (1.0 - ClothWithWeaponDefence_Percent));
    if (Damage < 0)
    {
        Damage = 0;
    }
    if (XPInsteadOfHP_AbsValue > 0)
    {
        for (; XPValue >= XPInsteadOfHP_AbsValue && Damage > 0; Damage--)
        {
            XPValue -= XPInsteadOfHP_AbsValue;
        }
        AliceGameInfo(WorldInfo.Game).UpdateTeethNumber(XPValue);
    }
    TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    if (AlicePlayerController(Controller).IsFirstPersonViewActivated())
    {
        AlicePlayerController(Controller).QuitFPS();
    }
    if (bInShield)
    {
        bTryToEndDeflectBeforeMinTime = false;
        AlicePlayerController(Controller).OnDeactivateShieldBlocking();
        ActivateShieldBlocking(false);
        FadeOutUmbrella();
        FadeInWeapon();
    }
    if (IsAttachedByNPCs())
    {
        if (DamageType != class'Engine.DmgType_Fell')
        {
            ForceDetachAllNPC();
        }
        else
        {
            bbb = true;
            if (InstigatedBy == none)
            {
                bbb = false;
            }
            else
            {
                for (I = 0; I < AttachNPCSockets.Length; I++)
                {
                    if (AttachNPCSockets[I].AttachedNPC == InstigatedBy.Pawn)
                    {
                        bbb = false;
                        break;
                    }
                }
            }
            if (bbb)
            {
                ForceDetachAllNPC();
            }
        }
    }
    if (Mesh != none && CurrentDmgStrength >= 2)
    {
        StopWeaponFire();
        if (bCanPlayHurtAnim)
        {
            if (Physics == 2 || Physics == 17)
            {
                if (AlicePlayerController(Controller).IsShrinking)
                {
                    SetLocation(Location + vect(0.0, 0.0, 30.0));
                }
                if (!IsDoingSpecialMove(42))
                {
                    DoSpecialMove(42, true);
                }
            }
            else if (Physics == 20)
            {
                if (!IsDoingSpecialMove(65))
                {
                    DoSpecialMove(65, true);
                }
            }
            else if (!IsDoingSpecialMove(41))
            {
                if ((CurrentDmgStrength == 3 || CurrentDmgStrength == 2) && InstigatedBy != none && InstigatedBy.Pawn != none)
                {
                    NewRot = rotator(DamageDir);
                    NewRot.Pitch = Rotation.Pitch;
                    NewRot.Roll = Rotation.Roll;
                    SetRotation(NewRot);
                }
                if (AlicePlayerController(Controller).IsInState('PlayerSwimming') == false)
                {
                    if (bShrinkingModeActive)
                    {
                        AlicePlayerController(Controller).UnShrinking();
                    }
                    if (!IsDoingSpecialMove(67) && !IsDoingSpecialMove(68))
                    {
                        DoSpecialMove(41, true);
                    }
                }
            }
        }
    }
    ActivateDamage(CurrentDmgStrength);
    HealthRegenWaitCount = 0.0;
    HealthRegen = float(Health);
    AlicePlayerController(Controller).ShowHealthUI(Health, HealthMax);
    if (bCanPlayHurtAnim)
    {
        DoDamageEffects(float(Damage), InstigatedBy.Pawn, HitLocation, DamageType, Momentum, HitInfo);
    }
}

function bool IsAttachedByNPCs()
{
    return AlicePlayerController(Controller).IsInState('AttachedByNPCs');
}

event ShieldDamage(int Damage, Controller InstigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    if (CurrentDmgStrength >= 2)
    {
        DoSpecialMove(47, true);
    }
}

function StopWeaponFire()
{
    if (WeaponForAlice(Weapon) != none)
    {
        WeaponForAlice(Weapon).CleanInfoWhenBreak();
        WeaponForAlice(Weapon).ReSetAllFlag();
        Weapon.ForceEndFire();
        Weapon.HandleFinishedFiring();
        Weapon.ClearAllPendingFire();
    }
}

function UpdateFreezingHit()
{
    local float DeltaTime, CurHitTime;
    
    if (!bIsFrozen)
    {
        if (CurFreezingHitTimes > 0)
        {
            CurHitTime = WorldInfo.TimeSeconds;
            DeltaTime = CurHitTime - LastTimeOfFreezingHit;
            LastTimeOfFreezingHit = CurHitTime;
            if (DeltaTime < TimeLimitToCountFreezingHit)
            {
                CurFreezingHitTimes++;
                if (CurFreezingHitTimes >= FreezingHitTimesToTriggerFrozenState)
                {
                    CurFreezingHitTimes = 0;
                    StartFrozen();
                    return;
                }
            }
            else
            {
                CurFreezingHitTimes = 1;
            }
        }
        else
        {
            CurFreezingHitTimes = 1;
            LastTimeOfFreezingHit = WorldInfo.TimeSeconds;
        }
    }
    return;
}

simulated function bool ShouldDoKnockBack(EDamageStrengthType DmgStrength)
{
    if (IsShieldBlocking())
    {
        return false;
    }
    return DamageArray[int(DmgStrength)].bKnockBack;
}

function DoDamageEffects(float Damage, Pawn InstigatedBy, Vector HitLocation, class<DamageType> DamageType, Vector Momentum, TraceHitInfo HitInfo)
{
    if (Damage > float(0))
    {
        if (DamageArray[int(CurrentDmgStrength)].bPhysicalAnim == true)
        {
            PlayPhysicsBodyImpact(HitLocation, Momentum, DamageType, HitInfo);
        }
    }
}

simulated function int GetLookAtPriority(AlicePlayerController PC, int DefaultPriority)
{
    return DefaultPriority;
}

simulated function ResetDressMorphingData()
{
    switch (ArcheTypeID)
    {
        case 2:
            ResetMorphingData('AliceTMorph');
            break;
        default:
            break;
    }
}

native simulated function ResetMorphingData(name MorphNodeName)
{
    MorphNodeName;
}

native simulated function AliceSetMorphWeight(SkeletalMeshComponent Component, name MorphNodeName, float MorphWeight)
{
    Component;
    MorphNodeName;
    MorphWeight;
}

simulated function GetAliceFootPoint(out Vector Point)
{
    local Vector LeftSoleLoc, RightSoleLoc;
    local Rotator Rot;
    
    Mesh.GetSocketWorldLocationAndRotation('LeftSole', LeftSoleLoc, Rot);
    Mesh.GetSocketWorldLocationAndRotation('RightSole', RightSoleLoc, Rot);
    Point = (LeftSoleLoc + RightSoleLoc) / 2.0;
}

simulated function bool SwitchToDress(int Index)
{
    local array<name> DressNames;
    
    DressNames.AddItem('None');
    DressNames.AddItem('Alice_MorphBlack');
    DressNames.AddItem('Alice_MorphWhite');
    DressNames.AddItem('Alice_MorphOrange');
    if (Index >= DressNames.Length)
    {
        return false;
    }
    if (Index < 0)
    {
        if (bCommandDress)
        {
            StartAliceMorphing(CommandDress, AliceCurrentDress, 0.1);
        }
        bCommandDress = false;
        return true;
    }
    if (bCommandDress)
    {
        StartAliceMorphing(CommandDress, DressNames[Index], 0.1);
        CommandDress = DressNames[Index];
    }
    else
    {
        StartAliceMorphing(AliceCurrentDress, DressNames[Index], 0.1);
        CommandDress = DressNames[Index];
    }
    bCommandDress = true;
    return true;
}

simulated function PlayWeaponSwitch(Weapon OldWeapon, Weapon NewWeapon)
{
    local WeaponPara tempweaponpara;
    local AliceGameWeapon NewW;
    
    NewW = AliceGameWeapon(NewWeapon);
    if (NewW != none)
    {
        foreach WeaponParas(tempweaponpara)
        {
            if (tempweaponpara.WeaponClass != none && tempweaponpara.WeaponClass == NewW.Class)
            {
                if (NewW.WeaponPositionType == 0 && NewW.Mesh != none && tempweaponpara.DefaultAttachedSocketName != 'None')
                {
                    if (NewW.bMeleeWeaponAbility)
                    {
                        NewW.Mesh.InitRBPhys();
                    }
                }
            }
        }
    }
}

simulated function PostWeaponListInit()
{
}

simulated function float GetWeaponMorphTime(WeaponForAlice DesiredWeapon)
{
    if (DesiredWeapon.IsA('EyeStaff'))
    {
        return MorphTime_EyeStaff;
    }
    else if (DesiredWeapon.IsA('TeapotCannon'))
    {
        return MorphTime_TeapotCannon;
    }
    else if (DesiredWeapon.IsA('HobbyHorse'))
    {
        return MorphTime_HobbyHorse;
    }
    else if (DesiredWeapon.IsA('VorpalBlade'))
    {
        return MorphTime_VorpalBlade;
    }
    else
    {
        return 0.0;
    }
}

exec function EnableEndurance()
{
    if (AlicePlayerInput(AlicePlayerController(Controller).PlayerInput).bDisableInputInCinematic)
    {
        return;
    }
    bEnableEndurance = !bEnableEndurance;
}

function bool EnduanceUsedUp()
{
    if (!bEnableEndurance)
    {
        return false;
    }
    if (CurEndurance <= Endurance.ThresholdToRest && bInLondon)
    {
        return true;
    }
    else
    {
        return false;
    }
}

function CostEndurance(float DeltaTime, ECostEnduranceType CostType)
{
    local float costSpeed;
    
    costSpeed = Endurance.Cost[int(CostType)];
    if (CurEndurance > Endurance.ThresholdToRest)
    {
        CurEndurance -= DeltaTime * costSpeed;
    }
}

function RecoverEndurance(float DeltaTime)
{
    if (CurEndurance < Endurance.TotalEndurance)
    {
        CurEndurance += DeltaTime * Endurance.Recovery;
        if (CurEndurance > Endurance.TotalEndurance)
        {
            CurEndurance = Endurance.TotalEndurance;
        }
    }
}

exec function TriggerFloatDown(bool bTriggerFloatDown)
{
    if (AlicePlayerInput(AlicePlayerController(Controller).PlayerInput).bDisableInputInCinematic)
    {
        return;
    }
    if (Physics == 2 && Velocity.Z < float(0) && !AlicePlayerController(Controller).bTriggerFloatJump)
    {
        if (Physics == 2)
        {
            bFloatDown = bTriggerFloatDown;
            if (Velocity.Z > float(0))
            {
                Velocity.Z = 0.0;
            }
        }
        else
        {
            bFloatDown = false;
        }
    }
}

function TryToResetSprintCameraAnim()
{
    local AlicePlayer_MovementStateBase PlayerState;
    
    PlayerState = AlicePlayerController(Controller).GetCurrentMovementState();
    if (PlayerState != none)
    {
        if (PlayerState.IsInState('Sprint'))
        {
            if (AlicePlayerController(Controller).bShrinkingModeActive)
            {
                AlicePlayCameraAnim(SprintCamera.Animation);
            }
        }
    }
}

function PlayLandedParticle()
{
    local Emitter LandedEmitter;
    local Vector TraceStart, TraceDest, out_HitLocation, out_HitNormal, TraceExtent, ParticleLoc;
    local TraceHitInfo HitInfo;
    local Actor TraceActor;
    local PhysicalMaterial PM;
    local ParticleSystem LandedParticle;
    local SoundCue LandedSound;
    
    TraceStart = Location;
    TraceDest = Location - vect(0.0, 0.0, 1.0) * GetCollisionHeight() - vect(0.0, 0.0, 50.0);
    TraceActor = Trace(out_HitLocation, out_HitNormal, TraceDest, TraceStart, true, TraceExtent, HitInfo, 8411);
    if (TraceActor != none)
    {
        PM = GetPhysicalMaterial(TraceActor, HitInfo, out_HitLocation);
        if (PM != none)
        {
            LandedParticle = class'AlicePhysicalMaterialProperty'.static.DetermineLandedParticle(PM, FootStepInfoID);
            if (LandedParticle != none)
            {
                LandedEmitter = Spawn(class'Engine.EmitterSpawnable', self, , ParticleLoc);
                if (LandedEmitter != none)
                {
                    GetAliceFootPoint(ParticleLoc);
                    LandedEmitter.SetLocation(ParticleLoc);
                    LandedEmitter.SetTemplate(LandedParticle, true);
                }
            }
            LandedSound = class'AlicePhysicalMaterialProperty'.static.DetermineLandedSound(PM, FootStepInfoID);
            if (LandedSound != none)
            {
                PlaySound(LandedSound);
            }
        }
    }
}

event Landed(Vector HitNormal, Actor FloorActor)
{
    HoldJumpTime = 0.0;
    bFloatDown = false;
    HoldFloatTime = 0.0;
    if (bInJumpPad && FloorActor != JumpPad && !AlicePlayerController(Controller).IsInState('PlayerJumpPad'))
    {
        bInJumpPad = false;
        AlicePlayerController(Controller).GotoState('PlayerWalking');
        SetPhysics(1);
    }
    if (Physics == 17)
    {
        if (bCanFloat)
        {
            AlicePlayerController(Controller).bEnableFloat = true;
        }
    }
    if (bInWaterWalk)
    {
        bWaterWalkInited = true;
        PlayerController(Controller).IgnoreMoveInput(false);
    }
    bWantToLeaveSwim = false;
    if (Physics == 2)
    {
        TriggerDressPhysic(false, 0.0);
    }
    bIsJumping = false;
    bIsDoubleJumping = false;
    bHasDodgeInAir = false;
    SkirtComponent.RadialForceMagnitude = 0.0;
    RibbonComponent.RadialForceMagnitude = 0.0;
    BowComponent.RadialForceMagnitude = 0.0;
    TryToResetSprintCameraAnim();
    bJustLeaveHover = false;
    bFloatAfterHover = false;
    bJustLeaveSteam = false;
    bAfterHoverJump = false;
    AlicePlayerController(Controller).bJustAfterFloatFail = false;
    PlayLandedParticle();
    AlicePlayerController(Controller).CycleFloatManager.Init();
    Landed(HitNormal, FloorActor);
    if (Physics == 2 || Physics == 17)
    {
        if (AlicePlayerController(Controller).bHoldToggleLockOnButton)
        {
            if (AlicePlayerInput(AlicePlayerController(Controller).PlayerInput).IsKeyPressed('XboxTypeS_LeftTrigger'))
            {
                SetPhysics(1);
                AlicePlayerController(Controller).ChangeCameraMode(true);
            }
            else if (AlicePlayerController(Controller).BlockPuzzleActor != none && AlicePlayerController(Controller).BlockPuzzleActor.IsReadyToPlay())
            {
                AlicePlayerController(Controller).GotoState('PlayerBlockPuzzle');
            }
            else
            {
                AlicePlayerController(Controller).GotoState('PlayerWalking');
            }
        }
        else if (Physics == 17)
        {
            AlicePlayerController(Controller).GotoState('PlayerWalking');
        }
    }
    AlicePlayerController(Controller).CycleFloatManager.indicatorManager.stopEffect();
    if (bClockBombCountingDown && MyClonePawn != none)
    {
        SetTimer(0.1, false, 'AttachWatch');
    }
}

function ResetRotation()
{
    local Rotator NewRotation;
    
    NewRotation = Rotation;
    NewRotation.Pitch = 0;
    NewRotation.Roll = 0;
    SetRotation(NewRotation);
}

event bool IsDoubleJumping()
{
    return bIsDoubleJumping;
}

function bool DoJump(bool bUpdating)
{
    local float OldVelocityZ;
    
    if (!CanJump())
    {
        return false;
    }
    if ((bJumpCapable || AlicePlayerController(Controller).isContextActorPressurePad()) && !bIsJumping && Physics == 1 || Physics == 9 || Physics == 8 || Physics == 15 || Physics == 2 && bJustLeaveEdge)
    {
        if (Physics == 8)
        {
            Velocity = JumpZ * Floor;
        }
        else if (Physics == 9)
        {
            if (bReadyToDropFromLedge)
            {
                DoSpecialMove(9, true);
                PendingVelocity = Velocity;
                PendingVelocity.Z = 0.0;
                Velocity = vect(0.0, 0.0, 0.0);
            }
        }
        else if (Physics == 15)
        {
            PendingVelocity = Velocity;
            OldVelocityZ = Velocity.Z;
            PendingVelocity.Z = Sqrt(4.0 * JumpZ * Abs(GetGravityZ()));
            Velocity = vect(0.0, 0.0, 0.0);
            if (!DoSpecialMove(3, true))
            {
                Velocity = PendingVelocity;
                Velocity.Z = OldVelocityZ;
                PendingVelocity = vect(0.0, 0.0, 0.0);
            }
        }
        else if (bIsWalking)
        {
            Velocity.Z = default.JumpZ;
        }
        else if (Physics == 20)
        {
            PendingVelocity = Velocity;
            OldVelocityZ = Velocity.Z;
            PendingVelocity.Z = HoverJumpZ;
            Velocity = vect(0.0, 0.0, 0.0);
            if (!DoSpecialMove(64, true))
            {
                Velocity = PendingVelocity;
                Velocity.Z = OldVelocityZ;
                PendingVelocity = vect(0.0, 0.0, 0.0);
            }
        }
        else
        {
            PendingVelocity = Velocity;
            OldVelocityZ = Velocity.Z;
            PendingVelocity.Z = Sqrt(4.0 * JumpZ * Abs(GetGravityZ()));
            Velocity = vect(0.0, 0.0, 0.0);
            if (!DoSpecialMove(3, true))
            {
                Velocity = PendingVelocity;
                Velocity.Z = OldVelocityZ;
                PendingVelocity = vect(0.0, 0.0, 0.0);
            }
        }
        if (Base != none && !Base.bWorldGeometry && Base.Velocity.Z > 0.0)
        {
            Velocity.Z += Base.Velocity.Z;
        }
        SetPhysics(2);
        if (bCanFloat)
        {
            AlicePlayerController(Controller).bCanFloatJump = true;
            AlicePlayerController(Controller).bTriggerFloatJump = false;
            AlicePlayerController(Controller).bEnableFloat = true;
            HoldJumpTime = 0.0;
            bFloatDown = false;
        }
        if (!IsDoingSpecialMove(64))
        {
            bIsJumping = true;
        }
        LastJumpHeight = Location.Z;
        ClearDelayAttachWeapon();
        AlicePlayerController(Controller).stuckManager.clearStuckFlag();
    }
    else if ((Physics == 2 || Physics == 17 || Physics == 20) && CurrentJumpStatus < 4 || CurrentJumpStatus == 3 && IsDoingSpecialMove(3) || bJustLeaveHover || Physics == 20 && bCanDoubleJump && !bIsSprinting && WorldInfo.TimeSeconds - FirstJumpTap > DelayToAllowDoubleJump && !bIsDoubleJumping && !AlicePlayerController(Controller).bInFloatVolume && !isNewCycleControl())
    {
        bJustLeaveHover = false;
        OldVelocityZ = Velocity.Z;
        DoSpecialMove(4, true);
        Velocity.Z = Sqrt(4.0 * DoubleJumpZ * Abs(GetGravityZ()));
        if (Physics == 20)
        {
            AlicePlayerController(Controller).GotoState('PlayerWalking');
            SetPhysics(2);
        }
        SkirtComponent.RadialForceMagnitude = 0.0;
        bIsDoubleJumping = true;
        if (bCanFloat)
        {
            AlicePlayerController(Controller).bEnableFloat = true;
        }
        bAfterHoverJump = false;
        AlicePlayerController(Controller).stuckManager.clearStuckFlag();
        AlicePlayerController(Controller).CycleFloatManager.setDoubleJumpTime();
    }
    if (AlicePlayerController(Controller).IsInState('FirstPersonView'))
    {
        AlicePlayerController(Controller).QuitFPS();
    }
    bJustLeaveHover = false;
    return false;
}

function ResetEdgeJump()
{
    bJustLeaveEdge = false;
}

event TriggerEdgeJump()
{
    bJustLeaveEdge = true;
    SetTimer(MaxTimeFallingEdgeToJump, false, 'ResetEdgeJump');
}

exec function InteractBlockPiece()
{
    if (IsReadyToCollectBlockPiece())
    {
        DiscardWatch();
        AlicePlayerController(Controller).CollectBlockPiece();
    }
}

function bool IsReadyToCollectBlockPiece()
{
    if (AlicePlayerController(Controller) == none || AlicePlayerController(Controller).BlockPuzzleActor == none)
    {
        return false;
    }
    return AlicePlayerController(Controller).BlockPuzzleActor.bCollectUIShowed;
}

function bool CanJump()
{
    if (bInLondon)
    {
        return false;
    }
    if (AlicePlayerController(Controller).IsShrinking || AlicePlayerController(Controller).IsUnShrinking || bInGiantMode || AlicePlayerController(Controller).bLookingAtPointOfInterest)
    {
        return false;
    }
    if (AlicePlayerInput(AlicePlayerController(Controller).PlayerInput).bDisableInputInCinematic)
    {
        return false;
    }
    if (IsPawnInAStance(2))
    {
        return false;
    }
    if (WeaponForAliceRange(Weapon) != none && WeaponForAliceRange(Weapon).IsInState('NormalFireState') || WeaponForAliceRange(Weapon).IsInState('AliceWeaponRangeFire'))
    {
        AlicePlayerController(Controller).bPressedJump = false;
        return false;
    }
    if (WeaponForAliceRange(Weapon) != none)
    {
        if (Weapon.PendingFire(0) || Weapon.PendingFire(1))
        {
            AlicePlayerController(Controller).bPressedJump = false;
            return false;
        }
    }
    if (IsDoingSpecialMove(26))
    {
        return true;
    }
    if (IsDoingSpecialMove(44))
    {
        return false;
    }
    if (IsDoingSpecialMove(41) || IsDoingSpecialMove(42))
    {
        if (IsRangeFiring() && !AlicePlayerController(Controller).IsInState('FirstPersonView') && !AlicePlayerController(Controller).bTargetingModeActive)
        {
        }
        else
        {
            return false;
        }
    }
    if (IsDoingAttackSpecialMove())
    {
        if (IsRangeFiring() && !AlicePlayerController(Controller).IsInState('FirstPersonView') && !AlicePlayerController(Controller).bTargetingModeActive)
        {
        }
        else
        {
            return false;
        }
    }
    if (IsDoingNonLockMeleeAttackSpecialMove())
    {
        return false;
    }
    if (AlicePlayerController(Controller).IsMeleeCharging())
    {
        return false;
    }
    if (AlicePlayerController(Controller).IsDodging())
    {
        return false;
    }
    if (WeaponForAlice(Weapon) != none && WeaponForAlice(Weapon).bIsSlideToTarget)
    {
        return false;
    }
    if (AlicePlayerController(Controller).isJumpPadJumping())
    {
        return false;
    }
    if (bHasDodgeInAir)
    {
        return false;
    }
    if (AlicePlayerController(Controller).bInFloatVolume)
    {
        return false;
    }
    return true;
}

exec function SwitchHowToTriggerFloatMode()
{
    bHoldToTriggerFloat = !bHoldToTriggerFloat;
}

exec function JumpButtonReleased()
{
    if (bCanFloat && CurrentJumpStatus == 3 && IsDoubleJumping() && !bIsSprinting && !bHoldToTriggerFloat)
    {
        bFloatDown = true;
        HoldJumpTime = 0.0;
    }
}

event bool isAButtonPressed()
{
    return GetaUp() > AButtonPress;
}

event float GetaUp()
{
    return AlicePlayerController(Controller).InputaUp;
}

native function bool CanUnShrinking()
{
}

function ResetUpperBodyComponent()
{
    DetachComponent(UpperBodyComponent);
    AttachComponent(UpperBodyComponent);
    UpperBodyComponent.SetParentAnimComponent(Mesh);
}

simulated function SetBaseEyeheight()
{
    local AlicePlayerController APC;
    
    APC = AlicePlayerController(Controller);
    if (APC != none && APC.bShrinkingModeActive)
    {
        BaseEyeHeight = ShrinkBaseEyeHeight;
    }
    else
    {
        BaseEyeHeight = default.BaseEyeHeight;
    }
}

native function StandUpToFloor(float DeltaFloor)
{
    DeltaFloor;
}

native function Vector CalcPositionOnLedge(LedgeVolume L)
{
    L;
}

function ClimbEdge(LedgeVolume L)
{
    local bool bAboveBeam;
    
    if (bReadyToDropToClimbLedgeWhenWalking)
    {
        bReadyToDropToClimbLedgeWhenWalking = false;
    }
    else if (!bJumpToAnotherLedge && !bSwitchToAnotherLedge)
    {
        if (OnLedge == none)
        {
            StopAllConfigAnim(0.05);
            OnLedge = L;
            if (OnLedge.VolumeType == 1)
            {
                bAboveBeam = Location.Z > L.Location.Z;
                if (!bAboveBeam)
                {
                    DoSpecialMove(5, true);
                }
                else
                {
                    DoSpecialMove(0, true);
                }
            }
            else if (OnLedge.VolumeType == 0)
            {
                DoSpecialMove(5, true);
            }
            else
            {
                DoSpecialMove(0, true);
            }
        }
    }
    ClimbEdge(L);
}

function FindoutCollisionHeightWhenClimbing(LedgeVolume L)
{
    if (L != none)
    {
        if (L.VolumeType == 0)
        {
            CollisionHeightLedgeClimbing = 36.0;
            CollisionRadiusLedgeClimbing = 34.0;
        }
        else if (L.VolumeType == 1)
        {
            if (!bStandOnBalanceBeam)
            {
                CollisionHeightLedgeClimbing = 90.0;
                CollisionRadiusLedgeClimbing = 34.0;
            }
            else
            {
                CollisionHeightLedgeClimbing = default.CylinderComponent.CollisionHeight;
                CollisionRadiusLedgeClimbing = default.CylinderComponent.CollisionRadius;
            }
        }
        else if (L.VolumeType == 3)
        {
            CollisionHeightLedgeClimbing = default.CylinderComponent.CollisionHeight;
            CollisionRadiusLedgeClimbing = default.CylinderComponent.CollisionRadius;
        }
        else if (L.VolumeType == 2)
        {
            CollisionHeightLedgeClimbing = default.CylinderComponent.CollisionHeight;
            CollisionRadiusLedgeClimbing = 34.0;
        }
    }
}

function UpdateBlobShadow()
{
    local Actor HitActor;
    local Vector Downward, HitLocation, HitNormal, vEnd, vStart;
    local float HitDistance, fOpacity, fScale;
    local bool bShowBlobShadow;
    
    bShowBlobShadow = false;
    if (BlobShadow.DecalMaterial != none && !bHidden)
    {
        if (AlicePlayerController(Controller).bCinematicMode == false)
        {
            Downward = vect(0.0, 0.0, -1.0);
            vEnd = Location + Downward * TerminationDistance;
            vStart = Location;
            HitActor = Trace(HitLocation, HitNormal, vEnd, vStart, true, vect(12.0, 12.0, 12.0), , 8);
            if (HitActor != none)
            {
                HitDistance = VSize(HitLocation - vStart);
                if (HitDistance > MinDistance)
                {
                    bShowBlobShadow = true;
                    fOpacity = FClamp((HitDistance - MinDistance) / (FadeDistance - MinDistance), 0.0, 1.0);
                    fScale = 1.0 + (DistanceScale - 1.0) * (HitDistance - MinDistance) / (TerminationDistance - MinDistance);
                    fScale *= ShadowScale;
                }
            }
        }
        if (bShowBlobShadow)
        {
            if (BlobShadowMatAlpha != 'None' && MaterialInstanceConstant(BlobShadow.DecalMaterial) != none)
            {
                MaterialInstanceConstant(BlobShadow.DecalMaterial).SetScalarParameterValue(BlobShadowMatAlpha, fOpacity);
            }
            if (VSize(OldBlobShadowLoc - HitLocation) > 1.0 || Abs(OldShadowScale - fScale) > 0.0001 || bOldShowBlobShadow == false)
            {
                if (BlobShadowComponent != none)
                {
                    BlobShadowComponent.ResetToDefaults();
                    BlobShadowComponent = none;
                }
                BlobShadowComponent = WorldInfo.MyDecalManager.SpawnDecal(BlobShadow.DecalMaterial, HitLocation, rotator(Downward), BlobShadow.Width * fScale, BlobShadow.Height * fScale, BlobShadow.Thickness, true, 0.0, , , , , , , , , , BlobShadow.BlendRange);
            }
            OldBlobShadowLoc = HitLocation;
            OldShadowScale = fScale;
        }
        else if (BlobShadowComponent != none)
        {
            BlobShadowComponent.ResetToDefaults();
            BlobShadowComponent = none;
            OldShadowScale = -1.0;
        }
    }
    bOldShowBlobShadow = bShowBlobShadow;
}

function bool CannotJumpNow()
{
    if (bIsBraking || bIsTurning || isInConversationMode() || bInJumpPad || bIsSprinting || bShrinkingModeActive || IsPawnInAStance(2))
    {
        return true;
    }
    return false;
}

function ChangeFloatCamera()
{
    bFloatFixCamera = (bFloatFixCamera ? false : true);
}

function InitShadowMode()
{
    if (EnableShadowCameraZoom)
    {
        DelayedAliceCameraFOV = ShadowCameraZoomNormal;
    }
}

function SetDelayedCameraPOV(out TPOV CameraPOV, float fDeltaTime)
{
    local AlicePlayerController APC;
    
    APC = AlicePlayerController(Controller);
    if (IsInShadowMode())
    {
        CameraPOV.Location += DefaultCamera.Offset;
        if (EnableShadowCameraZoom)
        {
            CameraPOV.FOV = DelayedAliceCameraFOV;
        }
    }
    CameraPOV.FOV *= APC.CommandFOVScale;
    APC.CommandCameraOffset += APC.CommandCameraOffsetSpeed * fDeltaTime;
    APC.CommandCameraOffset = ClampVector(APC.CommandCameraOffset, APC.CommandCameraOffsetMin, APC.CommandCameraOffsetMax);
    CameraPOV.Location += APC.CommandCameraOffset;
    bJustPostBeginPlay = false;
}

function Vector ClampVector(Vector V, Vector Min, Vector Max)
{
    local Vector vResult;
    
    vResult.X = FClamp(V.X, Min.X, Max.X);
    vResult.Y = FClamp(V.Y, Min.Y, Max.Y);
    vResult.Z = FClamp(V.Z, Min.Z, Max.Z);
    return vResult;
}

function SwitchCameraZoom()
{
    if (EnableShadowCameraZoom)
    {
        ShadowCameraZoomType = (ShadowCameraZoomType + 1) % 3;
        switch (ShadowCameraZoomType)
        {
            case 1:
                DelayedAliceCameraFOV = ShadowCameraZoomIn;
                break;
            case 2:
                DelayedAliceCameraFOV = ShadowCameraZoomOut;
                break;
            case 0:
            default:
                DelayedAliceCameraFOV = ShadowCameraZoomNormal;
                break;
        }
    }
}

simulated function bool CalcCamera(float fDeltaTime, out Vector out_CamLoc, out Rotator out_CamRot, out float out_FOV)
{
    local bool Result;
    local AlicePlayerController APC;
    
    APC = AlicePlayerController(Controller);
    if (APC == none)
    {
        return false;
    }
    if (APC.PlayerCamera.CameraStyle == 'ThirdPerson')
    {
        BlendCameraPreset(fDeltaTime);
        switch (ArcheTypeID)
        {
            case 3:
                Result = CalcCamera2D(APC, fDeltaTime, out_CamLoc, out_CamRot);
                break;
            default:
                if (APC.bSpecialCameraEnabled)
                {
                    Result = CalcCameraSpecial(APC, fDeltaTime, out_CamLoc, out_CamRot);
                }
                else if (APC.bCameraInterpEnabled)
                {
                    Result = CalcCameraInterp(APC, fDeltaTime, out_CamLoc, out_CamRot);
                }
                else
                {
                    Result = CalcCamera3D(APC, fDeltaTime, out_CamLoc, out_CamRot);
                }
                break;
        }
        out_FOV = (bCameraMagnet && CurCameraMagnet != none && CurCameraMagnet.FOV > float(0) ? CurCameraMagnet.FOV : AliceCameraFOV);
    }
    if (AlicePlayerCamera(APC.PlayerCamera).FreeCam != none && APC.PlayerCamera.CameraStyle != 'FreeCam')
    {
        APC.CommandCameraRoll += int(float(APC.CommandCameraRollDir) * GameFreeCamera(AlicePlayerCamera(APC.PlayerCamera).FreeCam).RotSpeed * fDeltaTime);
        APC.CommandCameraRollDir = 0;
        out_CamRot.Roll += APC.CommandCameraRoll;
    }
    return Result;
}

simulated function bool CalcCameraInterp(AlicePlayerController APC, float fDeltaTime, out Vector out_CamLoc, out Rotator out_CamRot)
{
    local Vector AliceEyeLoc;
    local Rotator AliceEyeRot;
    local float fElapsedTime;
    local AlicePlayerCamera AliceCamera;
    
    AliceCamera = AlicePlayerCamera(APC.PlayerCamera);
    fElapsedTime = AliceCamera.GetCameraTrackElapsedTime(fDeltaTime);
    AliceCamera.GetPositionOnCameraTrack(fElapsedTime, AliceEyeLoc, AliceEyeRot);
    AliceCamera.PreventCameraPenetration(APC, AliceEyeLoc, AliceEyeRot);
    out_CamLoc = AliceEyeLoc;
    out_CamRot = AliceEyeRot;
    return true;
}

simulated function bool CalcCamera2D(AlicePlayerController APC, float fDeltaTime, out Vector out_CamLoc, out Rotator out_CamRot)
{
    local Vector pos, AliceEyeLoc;
    local float CamDistance, CamDistanceDelay;
    local AlicePlayerCamera AliceCamera;
    local Rotator AliceEyeRot;
    
    AliceCamera = AlicePlayerCamera(APC.PlayerCamera);
    GetActorEyesViewPoint(AliceEyeLoc, AliceEyeRot);
    if (!bJustPostBeginPlay)
    {
        if (AliceEyeLoc.Z > OldAliceEyeLoc.Z)
        {
            AliceEyeLoc.Z = AliceCamera.CameraFloatInertiaFunction(OldAliceEyeLoc.Z, AliceEyeLoc.Z, CamHeightUpDelay, fDeltaTime);
        }
        else
        {
            AliceEyeLoc.Z = AliceCamera.CameraFloatInertiaFunction(OldAliceEyeLoc.Z, AliceEyeLoc.Z, CamHeightDownDelay, fDeltaTime);
        }
    }
    OldAliceEyeLoc = AliceEyeLoc;
    CamDistanceDelay = CamDistDelay;
    CamDistance = AliceCameraDistance;
    if (BasicMovementState == 2 || bIsSprinting)
    {
        CamDistance = CamDistance + (AliceCameraMaxDistance - CamDistance) * (VSize(Velocity) / MaxRunningSpeed);
    }
    if (!APC.bSetViewTargetImmediately)
    {
        if (APC.bEnableCameraInertia)
        {
            CamDistance = AliceCamera.ApplyCamDistInertia(CamDistance, AliceEyeLoc, CamDistanceDelay, fDeltaTime);
            if (CamDistance > AliceCameraMaxDistance)
            {
                CamDistance = AliceCameraMaxDistance;
            }
            if (CamDistance < AliceCameraMinDistance)
            {
                CamDistance = AliceCameraMinDistance;
            }
            if (bInJumpPad)
            {
                APC.bSetViewTargetLocImmediately = true;
            }
        }
    }
    pos = AliceEyeLoc - vector(AliceEyeRot) * CamDistance;
    out_CamLoc = pos;
    out_CamRot = AliceEyeRot;
    return true;
}

simulated function bool CalcCameraSpecial(AlicePlayerController APC, float fDeltaTime, out Vector out_CamLoc, out Rotator out_CamRot)
{
    local float CamDistance;
    local Vector AliceEyeLoc, OffsetVector;
    local Rotator AliceEyeRot, TargetEyeRot;
    local Matrix RM;
    local AlicePlayerCamera AliceCamera;
    
    AliceCamera = AlicePlayerCamera(APC.PlayerCamera);
    GetActorEyesViewPoint(AliceEyeLoc, AliceEyeRot);
    RM = MakeRotationTranslationMatrix(vect(0.0, 0.0, 0.0), Rotation);
    OffsetVector = TransformVector(RM, APC.SpecialCameraLoc);
    CamDistance = VSize(OffsetVector);
    CamDistance = AliceCamera.ApplyCamDistInertia(CamDistance, AliceEyeLoc, CamDistDelay, fDeltaTime);
    TargetEyeRot = rotator(-OffsetVector);
    AliceEyeRot = AliceCamera.CameraRotInertiaFunction(AliceEyeRot, TargetEyeRot, CamRevolutionDelay, fDeltaTime);
    out_CamLoc = AliceEyeLoc - vector(AliceEyeRot) * CamDistance;
    APC.SetRotation(AliceEyeRot);
    AliceCamera.PreventCameraPenetration(APC, out_CamLoc, AliceEyeRot);
    out_CamRot = (APC.bSpecialTargetCamera ? AliceEyeRot : APC.SpecialCameraRot);
    return true;
}

simulated function bool CalcCamera3D(AlicePlayerController APC, float fDeltaTime, out Vector out_CamLoc, out Rotator out_CamRot)
{
    local Vector pos, POILocation, AliceEyeLoc, DirY, DirX, TargetCamOffset, CamOffset;
    local float CamDistance, CamMaxDistance, CamMinDistance, CamDistanceDelay, DeltaYaw;
    local AlicePlayerCamera AliceCamera;
    local Rotator PosOffset, AliceEyeRot;
    
    if (APC == none)
    {
        return false;
    }
    AliceCamera = AlicePlayerCamera(APC.PlayerCamera);
    if (bDeathInLondon)
    {
        out_CamLoc = AliceCamera.Location;
        out_CamRot = rotator(Location - AliceCamera.Location);
        return true;
    }
    BaseEyeHeight = default.BaseEyeHeight * DrawScale;
    GetActorEyesViewPoint(AliceEyeLoc, AliceEyeRot);
    if (!bJustPostBeginPlay)
    {
        if (!APC.bSetViewTargetImmediately && APC.bEnableCameraInertia)
        {
            if (AliceEyeLoc.Z > OldAliceEyeLoc.Z)
            {
                AliceEyeLoc.Z = AliceCamera.CameraFloatInertiaFunction(OldAliceEyeLoc.Z, AliceEyeLoc.Z, CamHeightUpDelay, fDeltaTime);
            }
            else
            {
                AliceEyeLoc.Z = AliceCamera.CameraFloatInertiaFunction(OldAliceEyeLoc.Z, AliceEyeLoc.Z, CamHeightDownDelay, fDeltaTime);
            }
        }
    }
    OldAliceEyeLoc = AliceEyeLoc;
    CamDistanceDelay = CamDistDelay;
    if (!bCameraPreset && APC.IsShrinking || APC.IsUnShrinking)
    {
        BlendShrinkCameraDistance(fDeltaTime, APC.IsShrinking);
    }
    else if (IsCurAbilityCamera(FPSCamera))
    {
        BlendFPSCameraSettings(fDeltaTime, true);
    }
    if (APC.bTargetingModeActive)
    {
        LockOnModeCameraOffsetAdjustment(fDeltaTime, AliceCameraOffset);
    }
    TargetCamOffset = AliceCameraOffset + AliceCameraExtraOffset;
    CamOffset = AliceCamera.CameraVectInertiaFunction(OldAliceCameraOffset, TargetCamOffset, CamOffsetDelay, fDeltaTime);
    AliceEyeLoc = ApplyCameraOffset(AliceEyeLoc, AliceEyeRot, CamOffset);
    OldAliceCameraOffset = CamOffset;
    CamDistance = AliceCameraDistance * AliceCameraDistScale;
    CamMaxDistance = AliceCameraMaxDistance * AliceCameraDistScale;
    CamMinDistance = AliceCameraMinDistance * AliceCameraDistScale;
    if (BasicMovementState == 2 || bIsSprinting)
    {
        CamDistance = CamDistance + (CamMaxDistance - CamDistance) * (VSize(Velocity) / default.MaxRunningSpeed);
    }
    if (!APC.bSetViewTargetImmediately)
    {
        if (APC.bEnableCameraInertia)
        {
            CamDistance *= CamDistScale;
            CamDistance = AliceCamera.ApplyCamDistInertia(CamDistance, AliceEyeLoc, CamDistanceDelay, fDeltaTime);
            CamMaxDistance = AliceCamera.CameraFloatInertiaFunction(OldCamMaxDistance, CamMaxDistance, CamDistanceDelay, fDeltaTime);
            CamMinDistance = AliceCamera.CameraFloatInertiaFunction(OldCamMinDistance, CamMinDistance, CamDistanceDelay, fDeltaTime);
            if (CamDistance > CamMaxDistance && !APC.IsShrinking)
            {
                CamDistance = CamMaxDistance;
            }
            if (CamDistance < CamMinDistance)
            {
                CamDistance = CamMinDistance;
            }
            OldCamMaxDistance = CamMaxDistance;
            OldCamMinDistance = CamMinDistance;
            if (bInJumpPad)
            {
                APC.bSetViewTargetImmediately = true;
            }
        }
    }
    AliceCamera.ClosestCameraThreshold = CamClosestThreshold;
    AliceCamera.CameraHeightExt = CamHeightExt;
    if (APC.IsInPOIMode() && !APC.bPOIOverrideCamera)
    {
        if (APC.GetPOILocation(POILocation))
        {
            DeltaYaw = float(APC.bCameraLocOnLeft ? -4000 : 4000);
            pos = AliceEyeLoc - Normal(POILocation - AliceEyeLoc) * CamDistance;
            PosOffset = rotator(AliceEyeLoc - pos);
            PosOffset.Yaw += int(DeltaYaw);
            pos = AliceEyeLoc - Normal(vector(PosOffset)) * CamDistance;
            pos.Z = AliceEyeLoc.Z + POICameraOffset.Z;
            DirX = POILocation - AliceEyeLoc;
            DirX.Z = 0.0;
            DirX = Normal(DirX);
            pos += DirX * POICameraOffset.X;
            DirY = DirX Cross vect(0.0, 0.0, 1.0);
            DirY = Normal(DirY);
            pos += (APC.bCameraLocOnLeft ? DirY * -POICameraOffset.Y : DirY * POICameraOffset.Y);
            out_CamLoc = pos;
            out_CamRot = AliceEyeRot;
        }
    }
    else
    {
        if (!APC.bSetViewTargetImmediately && APC.bEnableCameraInertia)
        {
            if (bForceResetCamera)
            {
                AliceEyeRot = AliceCamera.CameraRotInertiaFunction(AliceCamera.CameraCache.POV.Rotation, AliceEyeRot, CamRotDelay, fDeltaTime);
                APC.bSetViewTargetRotImmediately = true;
            }
        }
        pos = AliceEyeLoc - vector(AliceEyeRot) * CamDistance;
        out_CamLoc = pos;
    }
    TranferToCombatCamera(AliceEyeLoc, AliceEyeRot, out_CamLoc);
    AliceCamera.PreventCameraPenetration(APC, out_CamLoc, AliceEyeRot);
    AdjustCombatCameraRotation(out_CamLoc, fDeltaTime, AliceEyeRot);
    out_CamRot = AliceEyeRot;
    return true;
}

simulated function AdjustCameraDistInLockOnBActor(GameBreakableActor NPCPawn, float DistAliceToNPC)
{
    local float CamDistDiff, NPCDistDiff, factor;
    
    if (NPCPawn.MinAliceToNPCDistance <= float(0) || NPCPawn.MaxAliceToNPCDistance <= float(0))
    {
        AliceCameraDistance = CombatCamera.Distance;
        AliceCameraMaxDistance = CombatCamera.MaxDistance;
        return;
    }
    if (DistAliceToNPC <= NPCPawn.MinAliceToNPCDistance)
    {
        AliceCameraDistance = NPCPawn.MinCamDistance;
    }
    else if (DistAliceToNPC >= NPCPawn.MaxAliceToNPCDistance)
    {
        AliceCameraDistance = NPCPawn.MaxCamDistance;
    }
    else
    {
        NPCDistDiff = NPCPawn.MaxAliceToNPCDistance - NPCPawn.MinAliceToNPCDistance;
        factor = (DistAliceToNPC - NPCPawn.MinAliceToNPCDistance) / NPCDistDiff;
        CamDistDiff = NPCPawn.MaxCamDistance - NPCPawn.MinCamDistance;
        AliceCameraDistance = NPCPawn.MinCamDistance + CamDistDiff * factor ** NPCPawn.MinToMaxCamDistanceFactor;
    }
    AliceCameraMaxDistance = AliceCameraDistance + 50.0;
}

simulated function AdjustCameraDistInLockOn(AliceGameKynapsePawn NPCPawn, float DistAliceToNPC)
{
    local float CamDistDiff, NPCDistDiff, factor;
    
    if (NPCPawn.MinAliceToNPCDistance <= float(0) || NPCPawn.MaxAliceToNPCDistance <= float(0))
    {
        AliceCameraDistance = CombatCamera.Distance;
        AliceCameraMaxDistance = CombatCamera.MaxDistance;
        return;
    }
    if (DistAliceToNPC <= NPCPawn.MinAliceToNPCDistance)
    {
        AliceCameraDistance = NPCPawn.MinCamDistance;
    }
    else if (DistAliceToNPC >= NPCPawn.MaxAliceToNPCDistance)
    {
        AliceCameraDistance = NPCPawn.MaxCamDistance;
    }
    else
    {
        NPCDistDiff = NPCPawn.MaxAliceToNPCDistance - NPCPawn.MinAliceToNPCDistance;
        factor = (DistAliceToNPC - NPCPawn.MinAliceToNPCDistance) / NPCDistDiff;
        CamDistDiff = NPCPawn.MaxCamDistance - NPCPawn.MinCamDistance;
        AliceCameraDistance = NPCPawn.MinCamDistance + CamDistDiff * factor ** NPCPawn.MinToMaxCamDistanceFactor;
    }
    AliceCameraMaxDistance = AliceCameraDistance + 50.0;
}

simulated function float GetCamDistScaleWhenFacingCam()
{
    local AliceCameraProperties ACP;
    
    return GetCurAbilityCamera(ACP) && ACP.DistScaleWhenFacingCam > float(0) ? ACP.DistScaleWhenFacingCam : DefaultCamera.DistScaleWhenFacingCam;
}

simulated function BlendFPSCameraSettings(float fDeltaTime, bool bEnter)
{
    local float Weight;
    
    CameraElapsedBlendTime += fDeltaTime;
    if (CameraElapsedBlendTime < FPSCamera.BlendTime)
    {
        if (bEnter)
        {
            Weight = CameraElapsedBlendTime / FPSCamera.BlendTime;
            AliceCameraDistance = Lerp(AliceCameraDistance, FPSCamera.Distance, Weight);
            AliceCameraMaxDistance = Lerp(AliceCameraMaxDistance, FPSCamera.MaxDistance, Weight);
            AliceCameraMinDistance = Lerp(AliceCameraMinDistance, FPSCamera.MinDistance, Weight);
            AliceCameraOffset = VLerp(AliceCameraOffset, FPSCamera.Offset, Weight);
        }
        else
        {
            Weight = CameraElapsedBlendTime / FPSCamera.BlendTime;
            AliceCameraDistance = Lerp(AliceCameraDistance, DefaultCamera.Distance, Weight);
            AliceCameraMaxDistance = Lerp(AliceCameraMaxDistance, DefaultCamera.MaxDistance, Weight);
            AliceCameraMinDistance = Lerp(AliceCameraMinDistance, DefaultCamera.MinDistance, Weight);
            AliceCameraOffset = VLerp(AliceCameraOffset, DefaultCamera.Offset, Weight);
        }
    }
    else if (bCameraPreset && bEnter)
    {
        AliceCameraDistance = FPSCamera.Distance;
        AliceCameraMaxDistance = FPSCamera.MaxDistance;
        AliceCameraMinDistance = FPSCamera.MinDistance;
        AliceCameraFOV = AliceFPSCameraFOV;
    }
    if (bCameraPreset)
    {
        AliceCameraFOV = AliceFPSCameraFOV;
        AliceCameraOffset = FPSCamera.Offset;
    }
}

simulated function BlendShrinkCameraDistance(float fDeltaTime, bool bShrinking, optional bool bForceSet = false)
{
    local float Weight;
    
    CameraElapsedBlendTime += fDeltaTime;
    if (bShrinking)
    {
        if (bForceSet)
        {
            SetAliceCameraFloat(AliceCameraDistance, ShrinkCamera.Distance, ShrinkCamera.Distance);
            SetAliceCameraFloat(AliceCameraMaxDistance, ShrinkCamera.MaxDistance, ShrinkCamera.MaxDistance);
            SetAliceCameraFloat(AliceCameraMinDistance, ShrinkCamera.MinDistance, ShrinkCamera.MinDistance);
        }
        else
        {
            Weight = float(Clamp(int(CameraElapsedBlendTime / ShrinkSpeed), 0, 1));
            BaseEyeHeight = Lerp(BaseEyeHeight, ShrinkBaseEyeHeight, Weight);
            if (IsAliceCameraFloatDirty(ShrinkCamera.Distance))
            {
                AliceCameraDistance = Lerp(AliceCameraDistance, ShrinkCamera.Distance, Weight);
            }
            if (IsAliceCameraFloatDirty(ShrinkCamera.MaxDistance))
            {
                AliceCameraMaxDistance = Lerp(AliceCameraMaxDistance, ShrinkCamera.MaxDistance, Weight);
            }
            if (IsAliceCameraFloatDirty(ShrinkCamera.MinDistance))
            {
                AliceCameraMinDistance = Lerp(AliceCameraMinDistance, ShrinkCamera.MinDistance, Weight);
            }
        }
    }
    else if (bForceSet)
    {
        SetAliceCameraFloat(AliceCameraDistance, ShrinkCamera.Distance, DefaultCamera.Distance);
        SetAliceCameraFloat(AliceCameraMaxDistance, ShrinkCamera.MaxDistance, DefaultCamera.MaxDistance);
        SetAliceCameraFloat(AliceCameraMinDistance, ShrinkCamera.MinDistance, DefaultCamera.MinDistance);
    }
    else
    {
        Weight = float(Clamp(int(CameraElapsedBlendTime / UnShrinkSpeed), 0, 1));
        BaseEyeHeight = Lerp(BaseEyeHeight, default.BaseEyeHeight, Weight);
        AliceCameraDistance = Lerp(AliceCameraDistance, DefaultCamera.Distance, Weight);
        AliceCameraMaxDistance = Lerp(AliceCameraMaxDistance, DefaultCamera.MaxDistance, Weight);
        AliceCameraMinDistance = Lerp(AliceCameraMinDistance, DefaultCamera.MinDistance, Weight);
    }
}

simulated function bool IsCurCameraMagnet(AliceCameraMagnet Candidate)
{
    return CurCameraMagnet != none && CurCameraMagnet == Candidate;
}

simulated function SetCameraMagnet(AliceCameraMagnet Candidate)
{
    local SeqAct_HeadLookAt LookAtAct;
    
    if (Candidate != none && bEnableCameraMagnet)
    {
        if (CurCameraMagnet != Candidate)
        {
            CurCameraMagnet = Candidate;
            CurCameraMagnetElapsedTime = 0.0;
            CurCameraMagnetSpeedTime = 0.0;
            CurCameraMagnetRotSpeed = 0;
            CurCameraMagnetEaseOut = -1.0;
            if (Candidate.MaxTriggerCount > 0)
            {
                Candidate.MaxTriggerCount--;
                if (Candidate.MaxTriggerCount == 0)
                {
                    Candidate.MaxTriggerCount = -1;
                }
            }
            bCameraMagnet = true;
            if (CurCameraMagnet.TurnHeadDuration > 0.0)
            {
                LookAtAct = new class'SeqAct_HeadLookAt';
                LookAtAct.TargetActors.AddItem(CurCameraMagnet);
                LookAtAct.LookAtDuration = CurCameraMagnet.TurnHeadDuration;
                OnHeadLookAt(LookAtAct);
            }
        }
    }
    else
    {
        bCameraMagnet = false;
        bSoftResetCamera = (CurCameraMagnet != none ? CurCameraMagnet.bResetCameraAfterDisabled : false);
        CurCameraMagnet = none;
        CurCameraMagnetElapsedTime = 0.0;
        CurCameraMagnetSpeedTime = 0.0;
        CurCameraMagnetRotSpeed = 0;
        CurCameraMagnetEaseOut = -1.0;
    }
}

simulated function UpdateCameraMagnet(float DeltaTime)
{
    local int J;
    local float fDistance;
    local AlicePlayerController APC;
    local bool bIgnore, bResetCamera, bDisabled;
    local Plane MagnetScreenPos;
    
    APC = AlicePlayerController(Controller);
    if (CurCameraMagnet == none)
    {
        return;
    }
    bResetCamera = CurCameraMagnet.bResetCameraAfterDisabled;
    MagnetScreenPos = AlicePlayerCamera(APC.PlayerCamera).Project(CurCameraMagnet.Location);
    CurCameraMagnet.Magnet2DPos.Z = MagnetScreenPos.W;
    CurCameraMagnet.Magnet2DPos.X = MagnetScreenPos.X;
    CurCameraMagnet.Magnet2DPos.Y = MagnetScreenPos.Y;
    bDisabled = false;
    if (CurCameraMagnet.DeActivationContext.Length > 0)
    {
        for (J = 0; J < CurCameraMagnet.DeActivationContext.Length; J++)
        {
            if (CurCameraMagnet.DeActivationContext[J] == Physics)
            {
                bDisabled = true;
                break;
            }
        }
    }
    fDistance = VSize(Location - CurCameraMagnet.Location);
    if (!(fDistance < CurCameraMagnet.AttractionRange && fDistance > CurCameraMagnet.DisableRange) || CurCameraMagnet.bEnabled == false || bDisabled)
    {
        SetCameraMagnet(none);
        return;
    }
    bIgnore = false;
    bCameraMagnet = true;
    CurCameraMagnetElapsedTime += DeltaTime;
    CurCameraMagnetSpeedTime += DeltaTime;
    if (CurCameraMagnet.CamDuration > 0.0)
    {
        if (CurCameraMagnetElapsedTime > CurCameraMagnet.CamDuration)
        {
            bIgnore = true;
        }
    }
    if (CurCameraMagnet.bEnableOnSight)
    {
        if (!AlicePlayerCamera(APC.PlayerCamera).CanSeeEx(CurCameraMagnet.Location, 1.0, true))
        {
            bIgnore = true;
        }
    }
    if (bIgnore)
    {
        if (bCameraMagnet && APC.bCameraRightStickFree && bResetCamera)
        {
            bSoftResetCamera = true;
        }
        bCameraMagnet = false;
    }
}

simulated function SetCameraStickToAlice(bool bEnable)
{
    local AliceCameraProperties ACP;
    
    if (bCameraForcedStickTo == bEnable)
    {
        return;
    }
    if (bEnable)
    {
        CamBehaviorStyle = 5;
        bCamRevolBlending = true;
        CameraElapsedBlendTime = 0.0;
        CameraBlendTime = 0.3;
    }
    else
    {
        GetCurAbilityCamera(ACP);
        CamBehaviorStyle = ACP.BehaviorStyle;
    }
    bCameraForcedStickTo = bEnable;
}

simulated function BlendToTargetCameraDistance(float Weight)
{
    AliceCameraDistance = Lerp(TmpCamera.Distance, TmpTargetCamera.Distance, Weight);
    AliceCameraMaxDistance = Lerp(TmpCamera.MaxDistance, TmpTargetCamera.MaxDistance, Weight);
    AliceCameraMinDistance = Lerp(TmpCamera.MinDistance, TmpTargetCamera.MinDistance, Weight);
    AliceCameraFOV = Lerp(TmpCamera.FOV, TmpTargetCamera.FOV, Weight);
}

simulated function SaveTargetCameraDistFOVInfo()
{
    TmpTargetCamera.Distance = AliceCameraDistance;
    TmpTargetCamera.MaxDistance = AliceCameraMaxDistance;
    TmpTargetCamera.MinDistance = AliceCameraMinDistance;
    TmpTargetCamera.FOV = AliceCameraFOV;
}

simulated function LoadCurCameraDistFOVInfo()
{
    AliceCameraDistance = TmpCamera.Distance;
    AliceCameraMaxDistance = TmpCamera.MaxDistance;
    AliceCameraMinDistance = TmpCamera.MinDistance;
    AliceCameraFOV = TmpCamera.FOV;
}

simulated function SaveCurCameraDistFOVInfo()
{
    TmpCamera.Distance = AliceCameraDistance;
    TmpCamera.MaxDistance = AliceCameraMaxDistance;
    TmpCamera.MinDistance = AliceCameraMinDistance;
    TmpCamera.FOV = AliceCameraFOV;
}

simulated event SetAliceAbilityCamera(out AliceCameraProperties ACP, optional bool bSetBackToDefault = false, optional bool bChangeAnim = true)
{
    local AliceCameraProperties CamPreset, FlagACP;
    local int I;
    
    if (bStopSettingAbilityCamera)
    {
        return;
    }
    if (bSetBackToDefault && !IsCurAbilityCamera(ACP))
    {
        return;
    }
    if (bSetBackToDefault == false)
    {
        SetCurAbilityCamera(ACP);
        if (ACP.BehaviorStyle != 0)
        {
            CamBehaviorStyle = ACP.BehaviorStyle;
        }
        bCamRevolBlending = IsAliceCameraRotatorDirty(ACP.InitRevolutionSpeed) || ACP.BlendTime > 0.0;
        SetAliceCameraRotator(CamInitRevolutionSpeed, ACP.InitRevolutionSpeed, ACP.InitRevolutionSpeed);
        SetAliceCameraRotator(CamRevolutionSpeed, ACP.RevolutionSpeed, ACP.RevolutionSpeed);
        CameraElapsedBlendTime = 0.0;
        CameraBlendTime = ACP.BlendTime;
    }
    else
    {
        SetCurAbilityCameraNull();
        if (ACP.BehaviorStyle != 0)
        {
            CamBehaviorStyle = 0;
        }
        bCamRevolBlending = false;
        SetAliceCameraRotator(CamInitRevolutionSpeed, ACP.InitRevolutionSpeed, DefaultCamera.InitRevolutionSpeed);
        SetAliceCameraRotator(CamRevolutionSpeed, ACP.RevolutionSpeed, DefaultCamera.RevolutionSpeed);
        bCameraForcedStickTo = false;
        CameraBlendTime = -1.0;
        CameraElapsedBlendTime = 0.0;
    }
    SetAliceCameraProperties(ACP, bSetBackToDefault, bChangeAnim);
    if (GetCurCameraPreset(CamPreset))
    {
        if (!bCameraPreset)
        {
            BackupAliceCameraPropertiesWithFlags(ACP, TargetCamera);
        }
        else if (bBlendCameraPresets)
        {
            MergeACP(FlagACP, ACP);
            for (I = 0; I < GetActiveCameraPresetNum(); I++)
            {
                if (GetActiveCameraPreset(I, CamPreset))
                {
                    SetAliceCameraProperties(CamPreset);
                    MergeACP(FlagACP, CamPreset);
                }
            }
            BackupAliceCameraPropertiesWithFlags(FlagACP, TargetCamera);
        }
    }
}

simulated function BackupAliceCameraPropertiesWithFlags(AliceCameraProperties Flag_ACP, out AliceCameraProperties ACP)
{
    SetAliceCameraFloat(ACP.Distance, Flag_ACP.Distance, AliceCameraDistance);
    SetAliceCameraFloat(ACP.MaxDistance, Flag_ACP.MaxDistance, AliceCameraMaxDistance);
    SetAliceCameraFloat(ACP.MinDistance, Flag_ACP.MinDistance, AliceCameraMinDistance);
    SetAliceCameraFloat(ACP.FOV, Flag_ACP.FOV, AliceCameraFOV);
    SetAliceCameraVector(ACP.Offset, Flag_ACP.Offset, AliceCameraOffset);
    SetAliceCameraRotator(ACP.Orientation, Flag_ACP.Orientation, AliceCameraOrientation);
    SetAliceCameraFloat(ACP.RevolutionAccelTime, Flag_ACP.RevolutionAccelTime, AliceCameraRevolAccelTime);
    SetAliceCameraFloat(ACP.RevolutionAccelExponent, Flag_ACP.RevolutionAccelExponent, AliceCameraRevolAccelExponent);
    SetAliceCameraFloat(ACP.HeightUpDelay, Flag_ACP.HeightUpDelay, CamHeightUpDelay);
    SetAliceCameraFloat(ACP.HeightDownDelay, Flag_ACP.HeightDownDelay, CamHeightDownDelay);
}

simulated event BackupAliceCameraProperties(out AliceCameraProperties ACP)
{
    ACP.Distance = AliceCameraDistance;
    ACP.MaxDistance = AliceCameraMaxDistance;
    ACP.MinDistance = AliceCameraMinDistance;
    ACP.FOV = AliceCameraFOV;
    ACP.Offset = AliceCameraOffset;
    ACP.Orientation = AliceCameraOrientation;
    ACP.RevolutionAccelTime = AliceCameraRevolAccelTime;
    ACP.RevolutionAccelExponent = AliceCameraRevolAccelExponent;
    ACP.HeightUpDelay = CamHeightUpDelay;
    ACP.HeightDownDelay = CamHeightDownDelay;
}

simulated event MergeACP(out AliceCameraProperties NewACP, out AliceCameraProperties ACP)
{
    SetAliceCameraFloat(NewACP.Distance, ACP.Distance, ACP.Distance);
    SetAliceCameraFloat(NewACP.MaxDistance, ACP.MaxDistance, ACP.MaxDistance);
    SetAliceCameraFloat(NewACP.MinDistance, ACP.MinDistance, ACP.MinDistance);
    SetAliceCameraFloat(NewACP.FOV, ACP.FOV, ACP.FOV);
    SetAliceCameraVector(NewACP.Offset, ACP.Offset, ACP.Offset);
    SetAliceCameraRotator(NewACP.Orientation, ACP.Orientation, ACP.Orientation);
    SetAliceCameraFloat(NewACP.RevolutionAccelTime, ACP.RevolutionAccelTime, ACP.RevolutionAccelTime);
    SetAliceCameraFloat(NewACP.RevolutionAccelExponent, ACP.RevolutionAccelExponent, ACP.RevolutionAccelExponent);
    SetAliceCameraFloat(NewACP.HeightUpDelay, ACP.HeightUpDelay, ACP.HeightUpDelay);
    SetAliceCameraFloat(NewACP.HeightDownDelay, ACP.HeightDownDelay, ACP.HeightDownDelay);
}

simulated event SetAliceCameraProperties(AliceCameraProperties ACP, optional bool bSetBackToDefault = false, optional bool bChangeAnim = true)
{
    if (bSetBackToDefault == false)
    {
        SetAliceCameraFloat(AliceCameraDistance, ACP.Distance, ACP.Distance);
        SetAliceCameraFloat(AliceCameraMaxDistance, ACP.MaxDistance, ACP.MaxDistance);
        SetAliceCameraFloat(AliceCameraMinDistance, ACP.MinDistance, ACP.MinDistance);
        SetAliceCameraFloat(AliceCameraFOV, ACP.FOV, ACP.FOV);
        SetAliceCameraVector(AliceCameraOffset, ACP.Offset, ACP.Offset);
        SetAliceCameraRotator(AliceCameraOrientation, ACP.Orientation, ACP.Orientation);
        if (ACP.Animation != none && bChangeAnim)
        {
            AlicePlayCameraAnim(ACP.Animation);
        }
        SetAliceCameraFloat(AliceCameraRevolAccelTime, ACP.RevolutionAccelTime, ACP.RevolutionAccelTime);
        SetAliceCameraFloat(AliceCameraRevolAccelExponent, ACP.RevolutionAccelExponent, ACP.RevolutionAccelExponent);
        SetAliceCameraFloat(CamHeightUpDelay, ACP.HeightUpDelay, ACP.HeightUpDelay);
        SetAliceCameraFloat(CamHeightDownDelay, ACP.HeightDownDelay, ACP.HeightDownDelay);
    }
    else
    {
        SetAliceCameraFloat(AliceCameraDistance, ACP.Distance, DefaultCamera.Distance);
        SetAliceCameraFloat(AliceCameraMaxDistance, ACP.MaxDistance, DefaultCamera.MaxDistance);
        SetAliceCameraFloat(AliceCameraMinDistance, ACP.MinDistance, DefaultCamera.MinDistance);
        SetAliceCameraFloat(AliceCameraFOV, ACP.FOV, DefaultCamera.FOV);
        SetAliceCameraVector(AliceCameraOffset, ACP.Offset, DefaultCamera.Offset);
        SetAliceCameraRotator(AliceCameraOrientation, ACP.Orientation, DefaultCamera.Orientation);
        if (bChangeAnim)
        {
            AliceStopCameraAnim();
        }
        SetAliceCameraFloat(AliceCameraRevolAccelTime, ACP.RevolutionAccelTime, DefaultCamera.RevolutionAccelTime);
        SetAliceCameraFloat(AliceCameraRevolAccelExponent, ACP.RevolutionAccelExponent, DefaultCamera.RevolutionAccelExponent);
        SetAliceCameraFloat(CamHeightUpDelay, ACP.HeightUpDelay, DefaultCamera.HeightUpDelay);
        SetAliceCameraFloat(CamHeightDownDelay, ACP.HeightDownDelay, DefaultCamera.HeightDownDelay);
    }
}

simulated function BlendAliceCameraProperties(AliceCameraProperties ACP, AliceCameraProperties DestACP, AliceCameraProperties SrcACP, float BlendWeight)
{
    BlendAliceCameraFloat(AliceCameraDistance, ACP.Distance, DestACP.Distance, SrcACP.Distance, BlendWeight);
    BlendAliceCameraFloat(AliceCameraMaxDistance, ACP.MaxDistance, DestACP.MaxDistance, SrcACP.MaxDistance, BlendWeight);
    BlendAliceCameraFloat(AliceCameraMinDistance, ACP.MinDistance, DestACP.MinDistance, SrcACP.MinDistance, BlendWeight);
    BlendAliceCameraFloat(AliceCameraFOV, ACP.FOV, DestACP.FOV, SrcACP.FOV, BlendWeight);
    BlendAliceCameraVector(AliceCameraOffset, ACP.Offset, DestACP.Offset, SrcACP.Offset, BlendWeight);
    BlendAliceCameraRotator(AliceCameraOrientation, ACP.Orientation, DestACP.Orientation, SrcACP.Orientation, BlendWeight);
    BlendAliceCameraFloat(AliceCameraRevolAccelTime, ACP.RevolutionAccelTime, DestACP.RevolutionAccelTime, SrcACP.RevolutionAccelTime, BlendWeight);
    BlendAliceCameraFloat(AliceCameraRevolAccelExponent, ACP.RevolutionAccelExponent, DestACP.RevolutionAccelExponent, SrcACP.RevolutionAccelExponent, BlendWeight);
    BlendAliceCameraFloat(CamHeightUpDelay, ACP.HeightUpDelay, DestACP.HeightUpDelay, SrcACP.HeightUpDelay, BlendWeight);
    BlendAliceCameraFloat(CamHeightDownDelay, ACP.HeightDownDelay, DestACP.HeightDownDelay, SrcACP.HeightDownDelay, BlendWeight);
}

simulated function BlendAliceCameraRotator(out Rotator out_Rotator, Rotator in_FlagRotator, Rotator dest_Rotator, Rotator src_Rotator, float BlendWeight)
{
    if (in_FlagRotator.Pitch > -32700)
    {
        out_Rotator.Pitch = int((float(1) - BlendWeight) * float(src_Rotator.Pitch) + BlendWeight * float(dest_Rotator.Pitch));
    }
    if (in_FlagRotator.Yaw > -32700)
    {
        out_Rotator.Yaw = int((float(1) - BlendWeight) * float(src_Rotator.Yaw) + BlendWeight * float(dest_Rotator.Yaw));
    }
    if (in_FlagRotator.Roll > -32700)
    {
        out_Rotator.Roll = int((float(1) - BlendWeight) * float(src_Rotator.Roll) + BlendWeight * float(dest_Rotator.Roll));
    }
}

simulated function BlendAliceCameraVector(out Vector out_vector, Vector in_FlagVector, Vector dest_Vector, Vector src_Vector, float BlendWeight)
{
    if (in_FlagVector.X > -998.0)
    {
        out_vector.X = (1.0 - BlendWeight) * src_Vector.X + BlendWeight * dest_Vector.X;
    }
    if (in_FlagVector.Y > -998.0)
    {
        out_vector.Y = (1.0 - BlendWeight) * src_Vector.Y + BlendWeight * dest_Vector.Y;
    }
    if (in_FlagVector.Z > -998.0)
    {
        out_vector.Z = (1.0 - BlendWeight) * src_Vector.Z + BlendWeight * dest_Vector.Z;
    }
}

simulated function BlendAliceCameraFloat(out float out_Float, float in_FlagFloat, float dest_Float, float src_Float, float BlendWeight)
{
    if (in_FlagFloat > -998.0)
    {
        out_Float = (1.0 - BlendWeight) * src_Float + BlendWeight * dest_Float;
    }
}

simulated function BlendCameraPreset(float DeltaTime)
{
    local AliceCameraProperties CamPreset;
    local float DurationPct, BlendPct;
    
    if (GetCurCameraPreset(CamPreset))
    {
        CameraPresetBlendTimeToGo -= DeltaTime;
        if (CameraPresetBlendTimeToGo < 0.0)
        {
            CameraPresetBlendTimeToGo = -1.0;
        }
        DurationPct = (CameraPresetBlendTimeToGo > 0.0 ? 1.0 - CameraPresetBlendTimeToGo / CameraPresetBlendParams.BlendTime : 1.0);
        switch (CameraPresetBlendParams.BlendFunction)
        {
            case 0:
                BlendPct = Lerp(0.0, 1.0, DurationPct);
                break;
            case 1:
                BlendPct = FCubicInterp(0.0, 0.0, 1.0, 0.0, DurationPct);
                break;
            case 2:
                BlendPct = FInterpEaseIn(0.0, 1.0, DurationPct, CameraPresetBlendParams.BlendExp);
                break;
            case 3:
                BlendPct = FInterpEaseOut(0.0, 1.0, DurationPct, CameraPresetBlendParams.BlendExp);
                break;
            case 4:
                BlendPct = FInterpEaseInOut(0.0, 1.0, DurationPct, CameraPresetBlendParams.BlendExp);
                break;
            default:
        }
        if (bCameraPreset)
        {
            if (!bBlendCameraPresets)
            {
                BlendAliceCameraProperties(CombinedCameraPreset, CombinedCameraPreset, BackupCamera, BlendPct);
            }
            else
            {
                BlendAliceCameraProperties(PreCameraPreset, TargetCamera, BackupCamera, BlendPct);
                if (BlendPct > 0.999)
                {
                    bBlendCameraPresets = false;
                }
            }
        }
        else
        {
            BlendAliceCameraProperties(CamPreset, TargetCamera, BackupCamera, BlendPct);
            if (BlendPct > 0.999)
            {
                SetCurCameraPresetNull();
            }
        }
    }
}

native function bool GetCurCameraPreset(out AliceCameraProperties ACP)
{
    ACP;
}

native function bool IsCurCameraPreset(out AliceCameraProperties ACP)
{
    ACP;
}

native function SetCurCameraPresetNull()
{
}

native function SetCurCameraPreset(out AliceCameraProperties ACP)
{
    ACP;
}

native function RestorePreviousAbilityCamera()
{
}

native function bool GetPreviousAbilityCamera(out AliceCameraProperties ACP)
{
    ACP;
}

native function SavePreviousAbilityCamera()
{
}

native function bool IsPreviousAbilityCamera(out AliceCameraProperties ACP)
{
    ACP;
}

native function bool GetCurAbilityCamera(out AliceCameraProperties ACP)
{
    ACP;
}

native function bool IsCurAbilityCamera(out AliceCameraProperties ACP)
{
    ACP;
}

native function SetCurAbilityCameraNull()
{
}

native function SetCurAbilityCamera(out AliceCameraProperties ACP)
{
    ACP;
}

native function DisactiveCameraPreset(out AliceCameraProperties ACP)
{
    ACP;
}

native function DisactiveCurCameraPreset()
{
}

native function bool GetActiveCameraPreset(int I, out AliceCameraProperties ACP)
{
    I;
    ACP;
}

native function int GetActiveCameraPresetNum()
{
}

native simulated function DisableCameraPreset(int nCameraPreset, out ViewTargetTransitionParams BlendParams, optional out AliceCameraProperties UserPreset)
{
    nCameraPreset;
    BlendParams;
    UserPreset;
}

native simulated function EnableCameraPreset(int nCameraPreset, out ViewTargetTransitionParams BlendParams, optional out AliceCameraProperties UserPreset)
{
    nCameraPreset;
    BlendParams;
    UserPreset;
}

simulated function ToggleCloseFollowCamera(bool bEnable)
{
    bCloseFollowCamera = bEnable;
    if (bCloseFollowCamera)
    {
        AliceCameraDistScale = CloseFollowCamera.DistanceScale;
        AliceCameraExtraOffset = CloseFollowCamera.Offset;
    }
    else
    {
        AliceCameraDistScale = 1.0;
        AliceCameraExtraOffset = vect(0.0, 0.0, 0.0);
    }
}

simulated function bool IsAliceCameraRotatorDirty(Rotator in_Rotator)
{
    if (in_Rotator.Pitch > -32700 || in_Rotator.Yaw > -32700 || in_Rotator.Roll > -32700)
    {
        return true;
    }
    return false;
}

simulated function SetAliceCameraRotator(out Rotator out_Rotator, Rotator in_FlagRotator, Rotator in_Rotator)
{
    if (in_FlagRotator.Pitch > -32700)
    {
        out_Rotator.Pitch = in_Rotator.Pitch;
    }
    if (in_FlagRotator.Yaw > -32700)
    {
        out_Rotator.Yaw = in_Rotator.Yaw;
    }
    if (in_FlagRotator.Roll > -32700)
    {
        out_Rotator.Roll = in_Rotator.Roll;
    }
}

simulated function bool IsAliceCameraVectorDirty(Vector in_Vector)
{
    if (in_Vector.X > -998.0 || in_Vector.Y > -998.0 || in_Vector.Z > -998.0)
    {
        return true;
    }
    return false;
}

simulated function SetAliceCameraVector(out Vector out_vector, Vector in_FlagVector, Vector in_Vector)
{
    if (in_FlagVector.X > -998.0)
    {
        out_vector.X = in_Vector.X;
    }
    if (in_FlagVector.Y > -998.0)
    {
        out_vector.Y = in_Vector.Y;
    }
    if (in_FlagVector.Z > -998.0)
    {
        out_vector.Z = in_Vector.Z;
    }
}

simulated function bool IsAliceCameraFloatDirty(float in_Float)
{
    if (in_Float > -998.0)
    {
        return true;
    }
    return false;
}

simulated function SetAliceCameraFloat(out float out_Float, float in_FlagFloat, float in_Float)
{
    if (in_FlagFloat > -998.0)
    {
        out_Float = in_Float;
    }
}

simulated event SetBlankACP(out AliceCameraProperties ACP)
{
    ACP.Distance = -999.0;
    ACP.MaxDistance = -999.0;
    ACP.MinDistance = -999.0;
    ACP.Orientation = rot(-32767, -32767, -32767);
    ACP.RevolutionSpeed = rot(-32767, -32767, -32767);
    ACP.InitRevolutionSpeed = rot(-32767, -32767, -32767);
    ACP.FOV = -999.0;
    ACP.Offset = vect(-999.0, -999.0, -999.0);
    ACP.Animation = none;
    ACP.BehaviorStyle = 0;
    ACP.LocationDelay = -999.0;
    ACP.RotationDelay = -999.0;
    ACP.FOVDelay = -999.0;
    ACP.DistanceDelay = -999.0;
    ACP.RevolutionDelay = -999.0;
    ACP.RevolutionAccelTime = -999.0;
    ACP.RevolutionAccelExponent = -999.0;
    ACP.HeightUpDelay = -999.0;
    ACP.HeightDownDelay = -999.0;
}

simulated event ResetAliceCameraProperties(optional bool bClearCurAbilityCamera = true)
{
    AliceCameraDistance = DefaultCamera.Distance;
    AliceCameraMaxDistance = DefaultCamera.MaxDistance;
    AliceCameraMinDistance = DefaultCamera.MinDistance;
    AliceCameraFOV = DefaultCamera.FOV;
    AliceCameraOffset = DefaultCamera.Offset;
    AliceCameraOrientation = DefaultCamera.Orientation;
    AliceStopCameraAnim();
    CamRevolutionSpeed = DefaultCamera.RevolutionSpeed;
    CamInitRevolutionSpeed = DefaultCamera.InitRevolutionSpeed;
    bCamRevolBlending = false;
    CamBehaviorStyle = 0;
    if (bClearCurAbilityCamera)
    {
        SetCurAbilityCameraNull();
    }
    AliceCameraRevolAccelTime = DefaultCamera.RevolutionAccelTime;
    AliceCameraRevolAccelExponent = DefaultCamera.RevolutionAccelExponent;
    CamHeightUpDelay = DefaultCamera.HeightUpDelay;
    CamHeightDownDelay = DefaultCamera.HeightDownDelay;
    ResetAliceCameraDelays();
}

simulated function ClearAliceCameraDelays()
{
    CamLocDelay = 0.0;
    CamRotDelay = 0.0;
    CamFOVDelay = 0.0;
    CamDistDelay = 0.0;
    CamRevolutionDelay = 0.0;
    CamOffsetDelay = 0.0;
    CamHeightUpDelay = 0.0;
    CamHeightDownDelay = 0.0;
}

simulated function ResetAliceCameraDelays()
{
    CamLocDelay = default.CamLocDelay;
    CamRotDelay = default.CamRotDelay;
    CamFOVDelay = default.CamFOVDelay;
    CamDistDelay = default.CamDistDelay;
    CamRevolutionDelay = default.CamRevolutionDelay;
    CamOffsetDelay = default.CamOffsetDelay;
    CamHeightUpDelay = DefaultCamera.HeightUpDelay;
    CamHeightDownDelay = DefaultCamera.HeightDownDelay;
}

event TriggerCameraEvent(int ActivateIndex)
{
    TriggerEventClass(class'SeqEvent_AliceCamera', self, ActivateIndex);
}

simulated function LockOnModeCameraOffsetAdjustment(float fDeltaTime, out Vector CamOffset)
{
    local Vector TargetDir, AliceDir, DirCross;
    local AlicePlayerController APC;
    local float TargetAliceAngle;
    
    APC = AlicePlayerController(Controller);
    AliceDir = vector(APC.MyAlicePawn.Rotation);
    AliceDir.Z = 0.0;
    AliceDir = Normal(AliceDir);
    if (IsCurAbilityCamera(CombatCamera))
    {
        CamOffset = CombatCamera.Offset;
    }
    if (APC.TargetingActor == none && NoCamOffsetYWhenNoTarget || bAliceStartCombatCam)
    {
        TargetCameraOffsetY = 0.0;
    }
    else if (DynamicCamOffsetY)
    {
        if (APC.IsLockOnNPC())
        {
            TargetDir = Normal(APC.TargetNPCSocket.Pawn.GetCameraTargetSocketLoc(APC.TargetNPCSocket.SocketIndex) - APC.MyAlicePawn.Location);
        }
        else if (APC.IsLockOnBActor())
        {
            TargetDir = Normal(APC.TargetBActorInfo.vLocation - APC.MyAlicePawn.Location);
        }
        if (TargetDir.Z < 0.99)
        {
            TargetDir.Z = 0.0;
            TargetDir = Normal(TargetDir);
            DirCross = AliceDir Cross TargetDir;
            if (VSize(DirCross) > 0.001)
            {
                TargetAliceAngle = TargetDir Dot OldAliceDir;
                if (TargetAliceAngle < Cos(TargetRangeForDynamicYOffset * 0.017453292))
                {
                    DirCross = Normal(DirCross);
                    if (DirCross Dot vect(0.0, 0.0, 1.0) > 0.0)
                    {
                        TargetCameraOffsetY = Abs(CombatCamera.Offset.Y);
                    }
                    else
                    {
                        TargetCameraOffsetY = -Abs(CombatCamera.Offset.Y);
                    }
                }
            }
        }
    }
    if (IsCurAbilityCamera(CombatCamera))
    {
        CamOffset.Y = TargetCameraOffsetY;
    }
    if (APC.TargetingActor != none && APC.TargetingActor.IsA('GameBreakableActor') && APC.TargetBActorInfo.BActor != none)
    {
        CamOffset += APC.TargetBActorInfo.LockOffsetCamera;
    }
    OldAliceDir = AliceDir;
}

simulated function AdjustCombatCameraRotation(Vector CamLocation, float fDeltaTime, out Rotator AliceEyeRot)
{
    local AlicePlayerController APC;
    local AlicePlayerCamera AliceCamera;
    local Vector NpcLocation, Middle, NPCDir, AliceDir;
    local Rotator BiasAngle;
    local float DeltaAngle, MiddleDelay, Weight, fPosX, fPosY;
    local int DeltaRot, FlagX, FlagY;
    local bool bOutOfSight, bCurMiddleMode;
    
    APC = AlicePlayerController(Controller);
    AliceCamera = AlicePlayerCamera(APC.PlayerCamera);
    if (!(APC != none && APC.bTargetingModeActive))
    {
        return;
    }
    if (IsCurAbilityCamera(CombatCamera) && APC.IsLockOnNPC() || APC.IsLockOnBActor() || bCombatToStrafeCamWait)
    {
        if (!bCombatToStrafeCamWait && !bSwitchTargetDelay && !APC.IsLockOnDeadNPC())
        {
            NpcLocation = (APC.IsLockOnNPC() ? APC.TargetNPCSocket.Pawn.GetCameraTargetSocketLoc(APC.TargetNPCSocket.SocketIndex) : APC.TargetBActorInfo.vLocation);
            OldLockOnTargetLoc = NpcLocation;
        }
        else
        {
            NpcLocation = OldLockOnTargetLoc;
        }
        AliceDir = Normal(Location + LockOnSocketOffset - CamLocation);
        NPCDir = Normal(NpcLocation - CamLocation);
        Middle = Normal(0.5 * (AliceDir + NPCDir));
        bCurMiddleMode = false;
        MiddleDelay = CamLocDelay;
        bOutOfSight = !AliceCamera.WillBeInSight(Middle, CamLocation, NpcLocation, FlagX, fPosX, FlagY, fPosY, SwitchMiddleModeFOVScale);
        if (bOutOfSight && FlagY == 1)
        {
            Weight = FClamp(SwitchMiddleModeFOVScale * (fPosY - 1.0) / (2.0 - SwitchMiddleModeFOVScale), 0.0, 1.0);
            Middle = Normal(Middle * (1.0 - Weight) + Normal(NpcLocation - CamLocation) * Weight);
        }
        if (bOldMiddleMode != bCurMiddleMode)
        {
            bMiddleModeBlend = true;
            MiddleModeBlendElapsedTime = 0.0;
        }
        bOldMiddleMode = bCurMiddleMode;
        if (APC.bLockOnStateFirstFrame)
        {
            APC.bLockOnStateFirstFrame = false;
            OldLockOnAimTarget = vector(AliceEyeRot);
        }
        if (bCamRevolBlending)
        {
            Middle = VLerp(OldLockOnAimTarget, Middle, CameraElapsedBlendTime / CameraBlendTime);
        }
        if (!bMiddleModeBlend)
        {
            Middle = AliceCamera.CameraVectInertiaFunction(OldLockOnAimTarget, Middle, MiddleDelay, fDeltaTime);
        }
        else
        {
            MiddleModeBlendElapsedTime += fDeltaTime;
            if (MiddleModeBlendElapsedTime > MiddleModeBlendTime)
            {
                MiddleModeBlendElapsedTime = MiddleModeBlendTime;
                bMiddleModeBlend = false;
            }
            Middle = VLerp(OldLockOnAimTarget, Middle, MiddleModeBlendElapsedTime / MiddleModeBlendTime);
        }
        OldLockOnAimTarget = Middle;
        BiasAngle = rotator(Middle);
        DeltaAngle = float(NormalizeRotAxis(BiasAngle.Yaw - AliceCamera.CameraCache.POV.Rotation.Yaw));
        AliceCamera.InterpolateRotation(int(DeltaAngle), fDeltaTime, int(LockOnCameraRotSpeed * 0.017453292 * 10430.378), DeltaRot);
        AliceEyeRot.Yaw = AliceCamera.CameraCache.POV.Rotation.Yaw + DeltaRot;
        AliceEyeRot.Pitch = BiasAngle.Pitch;
        if (!bAliceCombatCamReady)
        {
            if (bAliceStartCombatCam)
            {
                bAliceStartCombatCam = false;
                bAliceCombatCamReady = false;
            }
            else if (!bAliceCombatCamReady && DeltaAngle < 10.0)
            {
                bAliceCombatCamReady = true;
            }
        }
        APC.bSetViewTargetRotImmediately = true;
    }
    else if (IsCurAbilityCamera(StrafeCamera))
    {
        if (bCamRevolBlending && bCombatToStrafeCamBlend)
        {
            AliceDir = vector(AliceEyeRot);
            AliceDir = VLerp(OldLockOnAimTarget, AliceDir, CameraElapsedBlendTime / CameraBlendTime);
            OldLockOnAimTarget = AliceDir;
            BiasAngle = rotator(AliceDir);
            AliceEyeRot.Yaw = BiasAngle.Yaw;
            AliceEyeRot.Pitch = BiasAngle.Pitch;
        }
    }
}

simulated function CheckSwitchTargetDelay(float fDeltaTime)
{
    bSwitchTargetDelay = false;
    if (LockOnSwitchTargetBlendTime < SwitchTargetBlendDelay && LockOnTargetCount > 0)
    {
        bSwitchTargetDelay = true;
        LockOnSwitchTargetBlendTime += fDeltaTime;
    }
    if (bOldSwitchTargetDelay != bSwitchTargetDelay && bSwitchTargetDelay == false)
    {
        bCamRevolBlending = true;
        CameraElapsedBlendTime = 0.0;
        SaveCurCameraDistFOVInfo();
        LockOnElapsedTime = 0.0;
    }
    bOldSwitchTargetDelay = bSwitchTargetDelay;
}

simulated function bool EnableSwitchLockOnCamera(float fDeltaTime)
{
    CombatToStrafeCamBlendTime += fDeltaTime;
    return CombatToStrafeCamBlendTime >= CombatToStrafeCamBlendDelay;
}

simulated function StartCombatToStrafeCamBlendDelay()
{
    bCombatToStrafeCamWait = true;
    CombatToStrafeCamBlendTime = 0.0;
}

simulated function OnSwitchLockOnTarget()
{
    LockOnSwitchTargetBlendTime = 0.0;
    LockOnTargetCount++;
    bCombatToStrafeCamWait = false;
}

simulated function TranferToCombatCamera(Vector AliceEyeLoc, Rotator AliceEyeRot, out Vector out_CamLoc)
{
    local AlicePlayerController APC;
    
    APC = AlicePlayerController(Controller);
    if (!(APC != none && APC.bTargetingModeActive && IsCurAbilityCamera(CombatCamera)))
    {
        return;
    }
    if (AliceEyeLoc.Z - out_CamLoc.Z > MaxDistForLockOnCamDrop)
    {
        out_CamLoc.Z = AliceEyeLoc.Z - MaxDistForLockOnCamDrop;
    }
}

simulated function Vector ApplyCameraOffset(Vector eyePos, Rotator ViewRot, Vector Offset)
{
    local Vector NewPos, NewOffset, X, Y, Z;
    
    ViewRot.Pitch = 0;
    ViewRot.Roll = 0;
    GetAxes(ViewRot, X, Y, Z);
    NewPos = eyePos;
    NewOffset = Offset.X * X + Offset.Y * Y + Offset.Z * Z;
    NewPos += NewOffset;
    return NewPos;
}

simulated event GetActorEyesViewPoint(out Vector out_Location, out Rotator out_Rotation)
{
    out_Location = GetPawnViewLocation() + Mesh.Translation + vect(0.0, 0.0, 1.0) * CylinderComponent.CollisionHeight;
    out_Rotation = GetViewRotation();
}

function TakeFallingDamage()
{
}

exec function SetClothSpec(name TargetClothName, float NewGuideRestitutionDecay)
{
    SkirtComponent.SetClothSpec(TargetClothName, NewGuideRestitutionDecay);
}

exec function AliceHairAir()
{
    HairComponent.Force = vect(0.0, 0.0, -980.0);
    HairComponent.Damping = 5.0;
    HairComponent.Template.GuideRestitutionRoot = 0.9;
    HairComponent.Template.GuideRestitutionDecay = 0.6;
    HairComponent.Template.UpdateStrands();
    Mesh.DetachComponent(HairComponent);
    Mesh.AttachComponent(HairComponent, 'Bip01-Head');
}

exec function AliceHairWater()
{
    HairComponent.Force = vect(0.0, 0.0, 0.1);
    HairComponent.Damping = 10.0;
    HairComponent.Template.GuideRestitutionRoot = 0.01;
    HairComponent.Template.GuideRestitutionDecay = 0.6;
    HairComponent.Template.UpdateStrands();
    Mesh.DetachComponent(HairComponent);
    Mesh.AttachComponent(HairComponent, 'Bip01-Head');
}

exec function AliceStopMotion()
{
    bUseStopMotion = !bUseStopMotion;
    if (bUseStopMotion)
    {
        Mesh.SetAnimTreeTemplate(AnimTree'ANI_Alice.Alice_AnimTree_StopMotion');
    }
    else
    {
        Mesh.SetAnimTreeTemplate(AnimTree'ANI_Alice.Alice_AnimTree');
    }
}

function ForceWeaponSetHidden(bool Set)
{
    WeaponSetHidden(Set, true);
}

function WeaponSetHidden(bool Set, optional bool bForce = false)
{
    if (Weapon == none)
    {
        Controller.SwitchToBestWeapon();
    }
    WeaponForAlice(Weapon).WeaponSetHidden(Set, bForce);
    StopWeaponParticleTrail();
}

function StopWeaponParticleTrail()
{
    WeaponForAlice(Weapon).StopParticleTrail();
}

simulated event Vector GetWeaponStartTraceLocation(optional Weapon CurrentWeapon)
{
    if (Weapon != none)
    {
        return Weapon.GetPhysicalFireStartLoc();
    }
    return GetWeaponStartTraceLocation(CurrentWeapon);
}

simulated function CacheAnimNodes()
{
    local AliceGameAnimNode_BlendBase Node;
    local int I;
    
    CacheAnimNodes();
    AnimTreeRootNode = AnimTree(Mesh.Animations);
    for (I = 0; I < AnimBlendNodes.Length; I++)
    {
        AnimBlendNodes[I] = none;
    }
    foreach Mesh.AllAnimNodes(class'AliceGameAnimNode_BlendBase', Node)
    {
        switch (Node.NodeName)
        {
            case 'Slot_FullBody_Main':
                AnimBlendNodes[0] = Node;
                continue;
            case 'Slot_HalfBody_Upper_Main':
                AnimBlendNodes[1] = Node;
                continue;
            case 'PerBone_BlendUpperLower_Main':
                AnimBlendNodes[2] = Node;
                continue;
            case 'Slot_Combat_Upper_Additive':
                AnimBlendNodes[3] = Node;
                continue;
            case 'Slot_Combat_Lower_Additive':
                AnimBlendNodes[4] = Node;
                continue;
            case 'Slot_Combat_HoldWatch_Additive':
                AnimBlendNodes[5] = Node;
                continue;
            default:
                continue;
        }
    }
}

simulated event EnableCamPPEffects(bool bEnable)
{
    local int I;
    
    if (CamPPEffects.Length <= 0)
    {
        FindCamPPEffects();
    }
    for (I = 0; I < CamPPEffects.Length; I++)
    {
        CamPPEffects[I].bShowInGame = bEnable;
    }
}

simulated function FindCamPPEffects()
{
    local LocalPlayer LP;
    local PostProcessEffect PPEffect;
    local int I;
    
    for (I = 0; I < CamPPEffectNames.Length; I++)
    {
        LP = LocalPlayer(PlayerController(Controller).Player);
        if (LP != none && CamPPEffectNames[I] != 'None')
        {
            PPEffect = LP.PlayerPostProcess.FindPostProcessEffect(CamPPEffectNames[I]);
            if (PPEffect != none)
            {
                CamPPEffects.AddItem(PPEffect);
            }
        }
    }
}

simulated function ClearCamMatEffects()
{
    local LocalPlayer LP;
    local int I;
    local MaterialEffect PPEffect;
    
    if (Controller == none)
    {
        return;
    }
    LP = LocalPlayer(PlayerController(Controller).Player);
    if (LP != none)
    {
        for (I = 0; I < LP.PlayerPostProcess.Effects.Length; I++)
        {
            PPEffect = MaterialEffect(LP.PlayerPostProcess.Effects[I]);
            if (PPEffect != none)
            {
                PPEffect.Material = none;
            }
        }
    }
}

simulated function NameAbilityCameras()
{
    DefaultCamera.CameraID = 0;
    IdleCamera.CameraID = 1;
    WalkCamera.CameraID = 2;
    SprintCamera.CameraID = 3;
    RunCamera.CameraID = 4;
    JumpCamera.CameraID = 5;
    FloatCamera.CameraID = 6;
    SlideCamera.CameraID = 7;
    SteamVentCamera.CameraID = 8;
    ShrinkCamera.CameraID = 9;
    JumpPadsCamera.CameraID = 10;
    PushPullCamera.CameraID = 11;
    CombatCamera.CameraID = 12;
    SwimCamera.CameraID = 13;
    FastSwimCamera.CameraID = 14;
    WaterWalkCamera.CameraID = 15;
    InhabitPushPullCamera.CameraID = 16;
    StrafeCamera.CameraID = 17;
    FPSCamera.CameraID = 18;
}

event PostBeginPlay()
{
    local int Idx;
    local AlicePlayerController APC;
    local AlicePlayerCamera AliceCamera;
    
    APC = AlicePlayerController(Controller);
    AliceCamera = (APC != none ? AlicePlayerCamera(APC.PlayerCamera) : none);
    ArcheTypeID = AliceGameInfo(WorldInfo.Game).AliceArcheTypeID;
    WeaponDefence_Percent = 0.0;
    ClothDefence_Percent = 0.0;
    ClothWithWeaponDefence_Percent = 0.0;
    NPCDropMoreXP_Percent = 0.0;
    NPCDropMoreHP_Percent = 0.0;
    BreakableDropMoreXP_Percent = 0.0;
    BreakableDropMoreHP_Percent = 0.0;
    ShrinkRecoverHPTimePerHP_AbsValue = 0.0;
    ShrinkHPRecoverAccumulateTime = 0.0;
    HPMaxClamp = 0;
    SonarVisibleTimeInc_Percent = 0.0;
    bActivateHysterialAnytime = false;
    XPInsteadOfHP_AbsValue = 0;
    AttackInc_Percent = 0.0;
    RecoverHPTimePerHP_AbsValue = 0.0;
    HPRecoverAccumulateTime = 0.0;
    bDisableHPDrops = false;
    bSonarAlwaysVisible = false;
    PostBeginPlay();
    NameAbilityCameras();
    CameraAnimInfo.Length = 0;
    InvManager.SetCurrentWeapon(none);
    GetVorpalBlade();
    GetHobbyHorse();
    AttachUmbrella();
    CurEndurance = Endurance.TotalEndurance;
    OldAirControl = AirControl;
    AttachToEvent(class'SeqEvent_AliceCamera');
    AttachToEvent(class'SeqEvent_AliceSwimMode');
    SetAliceAbilityCamera(DefaultCamera);
    SetCurCameraPresetNull();
    OldCamMaxDistance = DefaultCamera.MaxDistance;
    OldCamMinDistance = DefaultCamera.MinDistance;
    IdleCameraTimeOutAnim = IdleCamera.Animation;
    DodgeEmitter = Spawn(class'AliceDodgeParticleTrace', self);
    bJumpPadHeightestPositionKeep = false;
    SetMaterialsIntoAliceSkelComponents();
    GetDefaultWonderlandDress();
    if (ArcheTypeID == 1)
    {
        if (class'Engine.WorldInfo'.static.IsConsoleBuild() && class'AlicePlayerController'.static.DLCGetStatus(2) != 2 && class'AlicePlayerController'.static.DLCGetStatus(3) != 2 && GetUserWonderlandDress() >= 6)
        {
            SetUserWonderlandDress(0);
        }
        else
        {
            ChangeWonderlandDress(GetUserWonderlandDress(), true);
        }
        SetWonderlandDressDLCMODInfo(GetUserWonderlandDress());
        HealthMax = 64;
    }
    if (ArcheTypeID == 1)
    {
        if (class'Engine.WorldInfo'.static.IsConsoleBuild() && class'AlicePlayerController'.static.DLCGetStatus(3) != 2)
        {
            APC.DisableAllDLCWeapons();
        }
    }
    bJustPostBeginPlay = true;
    if (Mesh != none && Mesh.SkeletalMesh != none && Mesh.SkeletalMesh.FaceFXAsset != none)
    {
        for (Idx = 0; Idx < FacialAnimSets.Length; ++Idx)
        {
            Mesh.SkeletalMesh.FaceFXAsset.MountFaceFXAnimSet(FacialAnimSets[Idx]);
        }
    }
    SetAliceAbilityCamera(IdleCamera, false, false);
    if (AliceCamera != none)
    {
        AliceCamera.ClosestCameraThreshold = ClosestCameraThreshold;
    }
    EnableForceTranslucency(false, 1.0, 0.0, 1000, false);
    DummyWeapon = Spawn(class'AliceDummyWeapon', self);
    if (RollingImpactSound != none)
    {
        RollingImpactSoundComponent = new(self) class'Engine.AudioComponent';
        AttachComponent(RollingImpactSoundComponent);
        RollingImpactSoundComponent.bAutoPlay = false;
        RollingImpactSoundComponent.SoundCue = RollingImpactSound;
    }
    if (RollingSlideSound_Fast != none)
    {
        RollingSlideSoundComponent_Fast = new(self) class'Engine.AudioComponent';
        AttachComponent(RollingSlideSoundComponent_Fast);
        RollingSlideSoundComponent_Fast.bAutoPlay = false;
        RollingSlideSoundComponent_Fast.SoundCue = RollingSlideSound_Fast;
    }
    if (RollingSlideSound_Slow != none)
    {
        RollingSlideSoundComponent_Slow = new(self) class'Engine.AudioComponent';
        AttachComponent(RollingSlideSoundComponent_Slow);
        RollingSlideSoundComponent_Slow.bAutoPlay = false;
        RollingSlideSoundComponent_Slow.SoundCue = RollingSlideSound_Slow;
    }
}

simulated event PreBeginPlay()
{
    PreBeginPlay();
    HairComponent.Template = Hair;
    if (HairComponent.Template != none)
    {
        Mesh.AttachComponent(HairComponent, 'Bip01-Head');
    }
    Mesh.AttachComponent(SkirtComponent, 'Bip01-Pelvis');
    Mesh.AttachComponent(BowComponent, 'Bip01-Pelvis');
    Mesh.AttachComponent(RibbonComponent, 'Bip01-Pelvis');
    UpperBodyComponent.SetParentAnimComponent(Mesh);
    MeshHeightOffset = -(CylinderComponent.CollisionHeight + MeshTranslationNudgeOffset);
    SwimSkeletalMeshComponent.AttachComponent(SwimBow, 'Dummy_Bow');
    SwimSkeletalMeshComponent.AttachComponent(SwimLight, 'Dummy_Streamer');
    SwimSkeletalMeshComponent.AttachComponent(SwimTailfin, 'CATRigTail7');
    WaterWalkSkeletalMeshComponent.AttachComponent(WaterWalkBow, 'Dummy_Bow');
    WaterWalkSkeletalMeshComponent.AttachComponent(WaterWalkTailfin, 'Bip01-Pelvis');
}

event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
    if (Mesh != none)
    {
        Mesh.RootMotionMode = 0;
    }
    if (bIsDoingContextAction && CurrentContextActor != none)
    {
        CurrentContextActor.EndContextAction();
    }
    if (AlicePlayerController(Controller).FlagComboInputAcceptFinish)
    {
        AlicePlayerController(Controller).ResetInputFlags();
    }
    bAllowFacingTargetInSpeicalMove = false;
    OnAnimEnd(SeqNode, PlayedTime, ExcessTime);
}

function drawlineFacingSlideTarget()
{
    local Actor Target;
    
    Target = AlicePlayerController(Controller).getFacingSlideTarget();
    if (Target != none)
    {
        DrawDebugLine(Location, Target.Location, 0, 255, 0);
        DrawDebugSphere(Location, 125.0, 10, 0, 255, 0);
    }
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
    local float XL, k0, b0, k1, b1;
    local Canvas Canvas;
    local Color DrawColor;
    local Vector Hpdrawlocation;
    local AlicePlayerController APC;
    local int I;
    local string ActorNames, sJumpStuck;
    
    Canvas = HUD.Canvas;
    if (HUD.ShouldDisplayDebug('AI'))
    {
        DrawColor.R = 0;
        DrawColor.G = 0;
        DrawColor.B = 255;
        Hpdrawlocation = Location;
        Hpdrawlocation.Z += float(50);
        Draw3Dtext(Canvas, Hpdrawlocation, " Alice HP is " $ string(Health), DrawColor);
    }
    APC = AlicePlayerController(Controller);
    if (false)
    {
        Canvas.StrLen("Endurance", XL, out_YL);
        out_YPos += out_YL;
        Canvas.SetPos(4.0, out_YPos);
        Canvas.DrawText("CurEndurance:" $ string(CurEndurance), false);
        AliceCheatManager(APC.CheatManager).GetSteamVentParam(k0, b0, 0);
        AliceCheatManager(APC.CheatManager).GetSteamVentParam(k1, b1, 1);
        Canvas.StrLen("SteamVent Param k, b ", XL, out_YL);
        out_YPos += out_YL;
        Canvas.SetPos(4.0, out_YPos);
        Canvas.DrawText("SteamVent Param k0, b0 :" $ string(k0) $ "   " $ string(b0), false);
        out_YPos += out_YL;
        Canvas.SetPos(4.0, out_YPos);
        Canvas.DrawText("SteamVent Param k1, b1 :" $ string(k1) $ "   " $ string(b1), false);
        out_YPos += out_YL;
        Canvas.SetPos(4.0, out_YPos);
        for (I = 0; I < AliceCheatManager(APC.CheatManager).TD_Actors.Length; I++)
        {
            ActorNames = ActorNames $ (string(AliceCheatManager(APC.CheatManager).TD_Actors[I].Name) $ " ");
        }
        Canvas.DrawText("TraceDetect :" $ ActorNames, false);
        if (AliceCheatManager(APC.CheatManager).bCalcPFInfo)
        {
            AliceCheatManager(APC.CheatManager).ShowPFInfos(Canvas);
        }
        out_YPos += out_YL;
        Canvas.SetDrawColor(240, 15, 240);
        Canvas.SetPos(200.0, out_YPos);
        Canvas.DrawText(APC.SoundModeManager.showDebugInfo());
    }
    if (false)
    {
        Canvas.SetDrawColor(240, 15, 240);
        out_YPos += float(100);
        Canvas.SetPos(4.0, out_YPos);
        Canvas.DrawText("Physic: " $ GetPhysicsName());
        out_YPos += out_YL;
        Canvas.SetPos(4.0, out_YPos);
        Canvas.DrawText("State: " $ APC.getAliceStateName());
        out_YPos += out_YL;
        Canvas.SetPos(4.0, out_YPos);
        Canvas.DrawText("bFloatDown: " $ string(bFloatDown));
        out_YPos += out_YL;
        Canvas.SetPos(4.0, out_YPos);
        Canvas.DrawText("CurrentJumpStatus: " $ string(CurrentJumpStatus));
        out_YPos += out_YL;
        Canvas.SetPos(4.0, out_YPos);
        sJumpStuck = (AlicePlayerController(Controller).stuckManager.isStucking() ? "Stucking" : "no stuck");
        Canvas.DrawText(sJumpStuck);
        out_YPos += out_YL;
        Canvas.SetPos(4.0, out_YPos);
        Canvas.DrawText("PreStance: " $ string(PrevPawnStance) $ "NewStance: " $ string(PawnStance));
        out_YPos += out_YL;
        Canvas.SetPos(4.0, out_YPos);
        Canvas.DrawText("bIsDoubleJumping: " $ string(bIsDoubleJumping));
        out_YPos += out_YL;
        Canvas.SetPos(4.0, out_YPos);
        Canvas.DrawText("GetaUp(): " $ string(GetaUp()));
        out_YPos += out_YL;
        Canvas.SetPos(4.0, out_YPos);
        Canvas.DrawText("bExitFloatWhenMissWindow: " $ string(bExitFloatWhenMissWindow));
        out_YPos += out_YL;
        Canvas.SetPos(4.0, out_YPos);
        Canvas.DrawText("IsCycleExpired(): " $ string(IsCycleExpired()) $ "  CurCycle: " $ string(AlicePlayerController(Controller).CycleFloatManager.CycleNum));
        out_YPos += out_YL;
        Canvas.SetPos(4.0, out_YPos);
        Canvas.DrawText(AlicePlayerController(Controller).CycleFloatManager.showDebugTime());
    }
    if (false)
    {
        out_YPos += float(50);
        Canvas.SetDrawColor(240, 15, 240);
        Canvas.SetPos(4.0, out_YPos);
        Canvas.DrawText(showSaveLoadConfigInfo());
    }
    if (false)
    {
        out_YPos += float(50);
        Canvas.SetPos(4.0, out_YPos);
        Canvas.DrawText(string(AliceCheatManager(AlicePlayerController(Controller).CheatManager).getTracedActor()));
        out_YPos += float(70);
        Canvas.SetDrawColor(240, 15, 240);
        Canvas.SetPos(4.0, out_YPos);
        Canvas.DrawText("===== FacingSlideTarget: " $ string(AlicePlayerController(Controller).getFacingSlideTarget()) $ " =====");
        drawlineFacingSlideTarget();
    }
    out_YPos += float(20);
    Canvas.SetDrawColor(240, 15, 240);
    Canvas.SetPos(4.0, out_YPos);
    Canvas.DrawText("===== Lockon Block Actor: " $ string(AliceCheatManager(AlicePlayerController(Controller).CheatManager).getLockonBlockActor()) $ " =====");
    out_YPos += float(20);
    Canvas.SetPos(4.0, out_YPos);
    Canvas.DrawText("===== Unshrink Block Actor: " $ string(AliceCheatManager(AlicePlayerController(Controller).CheatManager).getUnshrinkBlockActor()) $ " =====");
    out_YPos += float(20);
    Canvas.SetPos(4.0, out_YPos);
    Canvas.DrawText("===== Base Actor: " $ string(Base) $ " =====");
    out_YPos += float(20);
    Canvas.SetPos(4.0, out_YPos);
    Canvas.DrawText("===== Health: " $ string(Health) $ ", HealthMax: " $ string(HealthMax) $ ", Difficulty: " $ string(AlicePlayerController(Controller).configDataManager.getDifficulty()) $ ", =====");
    out_YPos += float(20);
    Canvas.SetPos(4.0, out_YPos);
    Canvas.DrawText("===== LastSafeVerifyUnShrinkPoint: " $ string(LastSafeVerifyUnShrinkPoint) $ ", =====");
    out_YPos += float(20);
    Canvas.SetPos(4.0, out_YPos);
    Canvas.DrawText("State: " $ APC.getAliceStateName());
    out_YPos += float(20);
    Canvas.SetPos(4.0, out_YPos);
    Canvas.DrawText("Physics: " $ string(Physics));
    out_YPos += float(20);
    Canvas.SetPos(4.0, out_YPos);
    Canvas.DrawText("AliceGameEngine::InvertY: " $ (AliceGameInfo(WorldInfo.Game).getAliceGameEngine().InvertY ? "true" : "false"));
    out_YPos += float(20);
    Canvas.SetPos(4.0, out_YPos);
    Canvas.DrawText("PlayerInput.bInvertMouse: " $ (APC.PlayerInput.bInvertMouse ? "true" : "false"));
    out_YPos += float(20);
    Canvas.SetPos(4.0, out_YPos);
    Canvas.DrawText("X360InvertControls: " $ (AliceGameInfo(WorldInfo.Game).getAliceGameEngine().shouldDefaultInvertControls() ? "true" : "false"));
    out_YPos += float(20);
    Canvas.SetPos(4.0, out_YPos);
    Canvas.DrawText("total Vent Duration: " $ string(AliceGameInfo(WorldInfo.Game).getAliceGameEngine().totalVentDuration));
    if (true)
    {
        out_YPos += float(50);
        Canvas.SetDrawColor(0, 255, 0);
        Canvas.SetPos(4.0, out_YPos);
        Canvas.DrawText(AlicePlayerController(Controller).persistentDataManager.showDebugInfo());
    }
}

simulated function CheckCurrentHealth(float DeltaTime)
{
    local int I;
    local float HPPercentage;
    
    if (bInHysteriaMode)
    {
        return;
    }
    if (AlicePlayerController(Controller).bCinematicMode)
    {
        DeactivateHealthLevel(OldHealthLevel);
        OldHealthLevel = -1;
        return;
    }
    if (HealthLevels.Length <= 0 || !bHasHealth)
    {
        return;
    }
    if (Health == HealthMax)
    {
        CurHealthLevel = -1;
    }
    else
    {
        HPPercentage = float(Health) / float(HealthMax);
        for (I = HealthLevels.Length - 1; I >= 0; I--)
        {
            if (I == HealthLevels.Length - 2 && float(Health) < HealthLevels[I].HPPercentage)
            {
                CurHealthLevel = I;
                break;
                continue;
            }
            if (HPPercentage <= HealthLevels[I].HPPercentage * 0.01)
            {
                CurHealthLevel = I;
                break;
            }
        }
    }
    if (OldHealthLevel != CurHealthLevel)
    {
        DeactivateHealthLevel(OldHealthLevel);
        ActivateHealthLevel(CurHealthLevel);
    }
    OldHealthLevel = CurHealthLevel;
    if (HealthRegenWaitCount > RegenDelay && Health < HealthMax)
    {
        HealthRegen += HealthLevels[CurHealthLevel].RegenRate * DeltaTime;
        if (Health <= int(HealthRegen))
        {
            Health = int(HealthRegen);
        }
        else
        {
            HealthRegen = float(Health);
        }
        if (Health > HealthMax)
        {
            Health = HealthMax;
        }
    }
    HealthRegenWaitCount += DeltaTime;
}

simulated function DeactivateDamage(EDamageStrengthType DamageStrength)
{
    local DamageElement DE;
    local int I;
    
    for (I = 0; I < DamageArray.Length; I++)
    {
        DE = DamageArray[I];
        if (DE.DmgStrength == DamageStrength)
        {
            StopHealthDamageEffect(false, DE.DamageSound, DE.DamageCameraAnim);
            break;
        }
    }
}

simulated function ActivateDamage(EDamageStrengthType DamageStrength)
{
    local DamageElement DE;
    local int I;
    
    for (I = 0; I < DamageArray.Length; I++)
    {
        DE = DamageArray[I];
        if (DE.DmgStrength == DamageStrength)
        {
            PlayHealthDamageEffect(false, DE.DamageSound, DE.DamageCameraAnim);
            break;
        }
    }
}

simulated function DeactivateHealthLevel(int Index)
{
    local HealthLevel HL;
    
    if (!bHasHealth || Index >= HealthLevels.Length || Index < 0)
    {
        return;
    }
    HL = HealthLevels[Index];
    StopHealthDamageEffect(true, HL.HealthSound, HL.HealthCameraAnim, HL.FFWaveform, HL.PPEffectName, HL.PPEffects);
}

simulated function ActivateHealthLevel(int Index)
{
    local HealthLevel HL;
    
    if (!bHasHealth || Index >= HealthLevels.Length || Index < 0)
    {
        return;
    }
    HL = HealthLevels[Index];
    PlayHealthDamageEffect(true, HL.HealthSound, HL.HealthCameraAnim, true, HL.FFWaveform, HL.PPEffectName, HL.PPEffects);
}

simulated function StopHealthDamageEffect(bool bHealth, SoundCue Sound, CameraAnim CameraAnimation, optional ForceFeedbackWaveform FFWaveform, optional array<name> PPEffectName, optional out array<PostProcessEffect> PPEffects)
{
    local PlayerController Ctrl;
    
    Ctrl = PlayerController(Controller);
    if (Ctrl == none)
    {
        return;
    }
    if (bHealth)
    {
        if (Sound != none)
        {
            Ctrl.Kismet_ClientStopSound(Sound, Ctrl, 0.0);
        }
    }
    AliceForceStopCameraAnim(CameraAnimation);
    EnablePPEffect(PPEffectName, PPEffects, false);
}

simulated function PlayHealthDamageEffect(bool bHealth, SoundCue Sound, CameraAnim CameraAnimation, optional bool bLoopCameraAnim = false, optional ForceFeedbackWaveform FFWaveform, optional array<name> PPEffectName, optional out array<PostProcessEffect> PPEffects)
{
    local PlayerController Ctrl;
    
    Ctrl = PlayerController(Controller);
    if (Ctrl == none)
    {
        return;
    }
    if (bHealth)
    {
        if (Sound != none)
        {
            Ctrl.Kismet_ClientPlaySound(Sound, Ctrl, 1.0, 1.0, 0.0, false, true);
        }
    }
    else
    {
        PlaySound(Sound);
    }
    AliceForcePlayCameraAnim(CameraAnimation, bLoopCameraAnim);
    if (FFWaveform != none)
    {
        Ctrl.ClientPlayForceFeedbackWaveform(FFWaveform);
    }
    EnablePPEffect(PPEffectName, PPEffects, true);
}

simulated function EnablePPEffect(array<name> PPEffectName, out array<PostProcessEffect> PPEffects, bool bEnable)
{
    local LocalPlayer LP;
    local PostProcessEffect PPEffect;
    local int I;
    
    if (PPEffects.Length <= 0)
    {
        for (I = 0; I < PPEffectName.Length; I++)
        {
            LP = LocalPlayer(PlayerController(Controller).Player);
            if (LP != none && PPEffectName[I] != 'None')
            {
                PPEffect = LP.PlayerPostProcess.FindPostProcessEffect(PPEffectName[I]);
                if (PPEffect != none)
                {
                    PPEffect.bShowInGame = bEnable;
                    PPEffects.AddItem(PPEffect);
                }
            }
        }
    }
    else
    {
        for (I = 0; I < PPEffects.Length; I++)
        {
            PPEffects[I].bShowInGame = bEnable;
        }
    }
}

function Draw3Dtext(Canvas in_canvas, Vector TextLocation, string Text, Color TextColor)
{
    local Vector tempScreen;
    
    tempScreen = in_canvas.Project(TextLocation);
    if (tempScreen.X >= float(0) && tempScreen.X < in_canvas.ClipX && tempScreen.Y >= float(0) && tempScreen.Y < in_canvas.ClipY)
    {
        in_canvas.Font = class'Engine.Engine'.static.GetMediumFont();
        in_canvas.SetDrawColor(TextColor.R, TextColor.G, TextColor.B);
        in_canvas.SetPos(tempScreen.X, tempScreen.Y);
        in_canvas.DrawText(Text, true);
    }
}

event AliceUpdateCameraAnim()
{
    local AlicePlayerCamera Camera;
    local AlicePlayerController APC;
    
    APC = AlicePlayerController(Controller);
    if (APC == none)
    {
        return;
    }
    if (OldCameraAnim != CurrentCameraAnim || CurrentCameraAnim == none)
    {
        if (CurrentCameraAnim == none && DefaultCamera.Animation != none)
        {
            if (APC.bShrinkingModeActive)
            {
                CurrentCameraAnim = ShrinkCamera.Animation;
            }
            else
            {
                CurrentCameraAnim = DefaultCamera.Animation;
            }
        }
        Camera = AlicePlayerCamera(APC.PlayerCamera);
        if (Camera != none)
        {
            if (CurrentCameraAnimInst != none)
            {
                Camera.StopCameraAnim(CurrentCameraAnimInst);
                CurrentCameraAnimInst = none;
            }
            if (CurrentCameraAnim != none)
            {
                CurrentCameraAnimInst = Camera.PlayCameraAnim(CurrentCameraAnim, true, 1.0, 1.0, 0.0, 0.0, true);
            }
        }
    }
    OldCameraAnim = CurrentCameraAnim;
}

simulated function AliceForceStopCameraAnim(CameraAnim CameraAnimation)
{
    local AlicePlayerCamera Camera;
    local int Index;
    
    Camera = AlicePlayerCamera(AlicePlayerController(Controller).PlayerCamera);
    if (Camera != none && CameraAnimation != none)
    {
        for (Index = 0; Index < CameraAnimInfo.Length; Index++)
        {
            if (CameraAnimInfo[Index].Anim == CameraAnimation)
            {
                Camera.StopCameraAnim(CameraAnimInfo[Index].AnimInst);
                CameraAnimInfo.Remove(Index, 1);
                return;
            }
        }
    }
}

simulated function CameraAnimInst AliceForcePlayCameraAnim(CameraAnim CameraAnimation, bool bLoop)
{
    local AlicePlayerCamera Camera;
    local AliceCameraAnimInfo CAInfo;
    
    Camera = AlicePlayerCamera(AlicePlayerController(Controller).PlayerCamera);
    if (Camera != none && CameraAnimation != none)
    {
        CAInfo.Anim = CameraAnimation;
        CAInfo.AnimInst = Camera.PlayCameraAnim(CameraAnimation, true, 1.0, 1.0, 0.0, 0.0, bLoop);
        if (bLoop)
        {
            CameraAnimInfo.AddItem(CAInfo);
        }
        return CAInfo.AnimInst;
    }
    else
    {
        return none;
    }
}

simulated function AliceStopCameraAnim()
{
    CurrentCameraAnim = none;
}

simulated function AlicePlayCameraAnim(CameraAnim CameraAnimation)
{
    CurrentCameraAnim = CameraAnimation;
}

simulated function StopAllAliceCameraAnims()
{
    local AlicePlayerCamera Camera;
    local int Index;
    
    if (Controller == none)
    {
        return;
    }
    Camera = AlicePlayerCamera(AlicePlayerController(Controller).PlayerCamera);
    if (CurrentCameraAnimInst != none)
    {
        Camera.StopCameraAnim(CurrentCameraAnimInst);
        CurrentCameraAnimInst = none;
        CurrentCameraAnim = none;
        OldCameraAnim = CurrentCameraAnim;
    }
    if (Camera != none)
    {
        for (Index = 0; Index < CameraAnimInfo.Length; Index++)
        {
            Camera.StopCameraAnim(CameraAnimInfo[Index].AnimInst);
            CameraAnimInfo.Remove(Index, 1);
        }
    }
    Camera.ClearAllCameraShakes();
    ClearCamMatEffects();
}

simulated function PlayRespawnEffect()
{
    SetTimer(RespawnRagdollDelay, false, 'RevertDeathRagdoll');
}

simulated function PlayDeathEffect()
{
    SetTimer(DeathRagdollDelay, false, 'PlayDeathRagdoll');
}

event PreLoadCheckpoint()
{
    StopAllAliceCameraAnims();
}

simulated function PrepareForSwitchArchetype()
{
    StopAllAliceCameraAnims();
    AliceCheatManager(AlicePlayerController(Controller).CheatManager).backupDataForLondonSwitchArcheType();
}

simulated event Destroyed()
{
    StopAllAliceCameraAnims();
    if (RollingImpactSoundComponent != none)
    {
        RollingImpactSoundComponent.bAutoDestroy = true;
        RollingImpactSoundComponent.Stop();
        RollingImpactSoundComponent = none;
    }
    if (RollingSlideSoundComponent_Fast != none)
    {
        RollingSlideSoundComponent_Fast.bAutoDestroy = true;
        RollingSlideSoundComponent_Fast.Stop();
        RollingSlideSoundComponent_Fast = none;
    }
    if (RollingSlideSoundComponent_Slow != none)
    {
        RollingSlideSoundComponent_Slow.bAutoDestroy = true;
        RollingSlideSoundComponent_Slow.Stop();
        RollingSlideSoundComponent_Slow = none;
    }
    Destroyed();
}

event PostDealWithDataAfterSwitched()
{
    AlicePlayerController(Controller).ResetWeaponCurrentWeaponLevel();
}

event DeliverDataWhenSwitched(AlicePawn NewPawn)
{
}

event HideAlicePawn(bool bHide)
{
    SetHidden(bHide);
    bShouldBeHide = bHide;
}

event StopUpdateSpecialComponents(bool bStop)
{
}

simulated function bool IsInShadowMode()
{
    return ArcheTypeID == 3;
}

function int GetT1BossXPAmount()
{
    switch (AliceGameInfo(WorldInfo.Game).getCurrentGameDifficulty())
    {
        case 0:
            return T1BossXPAmount.Easy;
        case 1:
            return T1BossXPAmount.Normal;
        case 2:
            return T1BossXPAmount.Hard;
        case 3:
            return T1BossXPAmount.VeryHard;
        default:
    }
}

function int GetT1LgeXPAmount()
{
    switch (AliceGameInfo(WorldInfo.Game).getCurrentGameDifficulty())
    {
        case 0:
            return T1LgeXPAmount.Easy;
        case 1:
            return T1LgeXPAmount.Normal;
        case 2:
            return T1LgeXPAmount.Hard;
        case 3:
            return T1LgeXPAmount.VeryHard;
        default:
    }
}

function int GetT1MedXPAmount()
{
    switch (AliceGameInfo(WorldInfo.Game).getCurrentGameDifficulty())
    {
        case 0:
            return T1MedXPAmount.Easy;
        case 1:
            return T1MedXPAmount.Normal;
        case 2:
            return T1MedXPAmount.Hard;
        case 3:
            return T1MedXPAmount.VeryHard;
        default:
    }
}

function int GetT2LgeXPAmount()
{
    switch (AliceGameInfo(WorldInfo.Game).getCurrentGameDifficulty())
    {
        case 0:
            return T2LgeXPAmount.Easy;
        case 1:
            return T2LgeXPAmount.Normal;
        case 2:
            return T2LgeXPAmount.Hard;
        case 3:
            return T2LgeXPAmount.VeryHard;
        default:
    }
}

function int GetT2MedXPAmount()
{
    switch (AliceGameInfo(WorldInfo.Game).getCurrentGameDifficulty())
    {
        case 0:
            return T2MedXPAmount.Easy;
        case 1:
            return T2MedXPAmount.Normal;
        case 2:
            return T2MedXPAmount.Hard;
        case 3:
            return T2MedXPAmount.VeryHard;
        default:
    }
}

function int GetT2SmlXPAmount()
{
    switch (AliceGameInfo(WorldInfo.Game).getCurrentGameDifficulty())
    {
        case 0:
            return T2SmlXPAmount.Easy;
        case 1:
            return T2SmlXPAmount.Normal;
        case 2:
            return T2SmlXPAmount.Hard;
        case 3:
            return T2SmlXPAmount.VeryHard;
        default:
    }
}

function array<SmartHP> GetSmartDropHealthArray()
{
    switch (AliceGameInfo(WorldInfo.Game).getCurrentGameDifficulty())
    {
        case 0:
            return SmartDropHealthEasyLevel;
        case 1:
            return SmartDropHealthNormalLevel;
        case 2:
            return SmartDropHealthHardLevel;
        case 3:
            return SmartDropHealthVeryHardLevel;
        default:
    }
}

function SetXPValue(int Value)
{
    XPValue = Value;
}

function int GetXPValue()
{
    return XPValue;
}

function int GetTokenAmount()
{
    if (XPToTokenConversion > 0 && XPValue >= 0)
    {
        return XPValue / XPToTokenConversion;
    }
    else
    {
        return 0;
    }
}

simulated event bool IsInContextActorRange()
{
    return CurrentContextActor != none;
}

native final function FarMoveSetLocation(Vector SetLocation, bool bNoCheck)
{
    SetLocation;
    bNoCheck;
}

native function TriggerEnterHysteriaRadiusDamage()
{
}

native function EnableTranslateIK(bool bEnable)
{
    bEnable;
}

native function float GetShieldKnockBackTimeScale(int ShieldIndex)
{
    ShieldIndex;
}

native function float GetShieldKnockBackDistScale(int ShieldIndex)
{
    ShieldIndex;
}

native function bool IsShieldBlocking()
{
}

native function ActivateShieldBlocking(bool bActive)
{
    bActive;
}

native function Actor GetCurrentAttackTargetActor()
{
}

native function HobbyHorse GetHobbyHorse()
{
}

native function VorpalBlade GetVorpalBlade()
{
}

native function AttachToEvent(class<SequenceObject> DesiredClass)
{
    DesiredClass;
}

native function StopUpdate(bool bStop)
{
    bStop;
}

native function StartAliceMorphing(name CurMorphName, name NextMorphName, float MorphTime)
{
    CurMorphName;
    NextMorphName;
    MorphTime;
}

native function SetCollisionWithoutCheck(bool bEnable)
{
    bEnable;
}

native function MoveMe(Vector Delta)
{
    Delta;
}

native function EnableAirControl(bool bEnable)
{
    bEnable;
}

native function PrepareEndingOfJumpToAnotherLedge()
{
}

native function PrepareStartingOfJumpToAnotherLedge(ELedgeJumpDir jumpDir)
{
    jumpDir;
}

defaultproperties
{
    bEnableCameraMagnet=True
    bEnableTargetOnDestroyedActor=True
    bUsePotentialField=True
    bCanShrink=True
    bCanLockon=True
    bCanAiming=True
    bCanShowPath=True
    bCanShowCat=True
    bCanEnableSonar=True
    bCanClockBomb=True
    bCanHysteria=True
    bCanBlock=True
    bCanDeflect=True
    bCanDodge=True
    bCanDoubleJumpBackupWonderLand=True
    bCanShowPathBackupWonderLand=True
    bCanShowCatBackupWonderLand=True
    NoCamOffsetYWhenNoTarget=True
    DynamicCamOffsetY=True
    EnableShadowCameraZoom=True
    bHoldToTriggerFloat=True
    bEnableGlideCameraInertia=True
    bFloatFixCamera=True
    bAllowToDropExpPickUp=True
    bAllowToDropHpPickUp=True
    bHysteriaGodMode=True
    bRecoverHealth=True
    bRecoverHealthAtHysterialBegin=True
    bCanPlayHurtAnim=True
    MODDLC_Flesh_DLCVB_HysterialAnytime=True
    MODDLC_Cheshire_DLCHH_DisableHPDrops=True
    MODDLC_Caterpillar_DLCVB_SonarAlwaysVisible=True
    CurCameraMagnetEaseOut=-1.0
    CloseFollowCamera=(DistanceScale=1.0,Offset=(X=0.0,Y=0.0,Z=0.0))
    CamClosestThreshold=100.0
    CameraRotationSpeed=1.0
    CamLocDelay=0.1
    CamRotDelay=0.1
    CamFOVDelay=0.1
    CamDistDelay=0.1
    CamRevolutionDelay=0.3
    CamOffsetDelay=0.1
    CamHeightExt=50.0
    IdleCameraTimeOutDuration=5.0
    FPSCameraFOVOnTarget=60.0
    ClosestCameraThreshold=20.0
    CameraBlendTime=-1.0
    AliceCameraDistance=600.0
    AliceCameraMaxDistance=700.0
    AliceCameraMinDistance=50.0
    AliceCameraFOV=90.0
    AliceCameraOffset=(X=0.0,Y=0.0,Z=16.0)
    CamRevolutionSpeed=(Pitch=0,Yaw=13000,Roll=0)
    ArcheTypeID="AType_Wonderland"
    CamDistScale=1.0
    CamDistDelayScale=1.0
    AliceCameraDistScale=1.0
    IdleCamera=(Distance=-999.0,MaxDistance=-999.0,MinDistance=-999.0,Orientation=(Pitch=-32767,Yaw=-32767,Roll=-32767),RevolutionSpeed=(Pitch=-32767,Yaw=-32767,Roll=-32767),InitRevolutionSpeed=(Pitch=-32767,Yaw=-32767,Roll=-32767),FOV=-999.0,Offset=(X=-999.0,Y=-999.0,Z=-999.0),Animation="None",BehaviorStyle="ACS_Default",DistScaleWhenFacingCam=-999.0,BlendTime=-1.0,RevolutionAccelTime=-999.0,RevolutionAccelExponent=-999.0,HeightUpDelay=-999.0,HeightDownDelay=-999.0,LocationDelay=-999.0,RotationDelay=-999.0,FOVDelay=-999.0,DistanceDelay=-999.0,RevolutionDelay=-999.0,CameraID=-1)
    WalkCamera=(Distance=-999.0,MaxDistance=-999.0,MinDistance=-999.0,Orientation=(Pitch=-32767,Yaw=-32767,Roll=-32767),RevolutionSpeed=(Pitch=-32767,Yaw=-32767,Roll=-32767),InitRevolutionSpeed=(Pitch=-32767,Yaw=-32767,Roll=-32767),FOV=-999.0,Offset=(X=-999.0,Y=-999.0,Z=-999.0),Animation="None",BehaviorStyle="ACS_Default",DistScaleWhenFacingCam=-999.0,BlendTime=-1.0,RevolutionAccelTime=-999.0,RevolutionAccelExponent=-999.0,HeightUpDelay=-999.0,HeightDownDelay=-999.0,LocationDelay=-999.0,RotationDelay=-999.0,FOVDelay=-999.0,DistanceDelay=-999.0,RevolutionDelay=-999.0,CameraID=-1)
    SprintCamera=(Distance=-999.0,MaxDistance=-999.0,MinDistance=-999.0,Orientation=(Pitch=-32767,Yaw=-32767,Roll=-32767),RevolutionSpeed=(Pitch=-32767,Yaw=-32767,Roll=-32767),InitRevolutionSpeed=(Pitch=-32767,Yaw=-32767,Roll=-32767),FOV=-999.0,Offset=(X=-999.0,Y=-999.0,Z=-999.0),Animation="None",BehaviorStyle="ACS_Default",DistScaleWhenFacingCam=-999.0,BlendTime=-1.0,RevolutionAccelTime=-999.0,RevolutionAccelExponent=-999.0,HeightUpDelay=-999.0,HeightDownDelay=-999.0,LocationDelay=-999.0,RotationDelay=-999.0,FOVDelay=-999.0,DistanceDelay=-999.0,RevolutionDelay=-999.0,CameraID=-1)
    RunCamera=(Distance=-999.0,MaxDistance=-999.0,MinDistance=-999.0,Orientation=(Pitch=-32767,Yaw=-32767,Roll=-32767),RevolutionSpeed=(Pitch=-32767,Yaw=-32767,Roll=-32767),InitRevolutionSpeed=(Pitch=-32767,Yaw=-32767,Roll=-32767),FOV=-999.0,Offset=(X=-999.0,Y=-999.0,Z=-999.0),Animation="None",BehaviorStyle="ACS_Default",DistScaleWhenFacingCam=-999.0,BlendTime=-1.0,RevolutionAccelTime=-999.0,RevolutionAccelExponent=-999.0,HeightUpDelay=-999.0,HeightDownDelay=-999.0,LocationDelay=-999.0,RotationDelay=-999.0,FOVDelay=-999.0,DistanceDelay=-999.0,RevolutionDelay=-999.0,CameraID=-1)
    JumpCamera=(Distance=-999.0,MaxDistance=-999.0,MinDistance=-999.0,Orientation=(Pitch=-32767,Yaw=-32767,Roll=-32767),RevolutionSpeed=(Pitch=-32767,Yaw=-32767,Roll=-32767),InitRevolutionSpeed=(Pitch=-32767,Yaw=-32767,Roll=-32767),FOV=-999.0,Offset=(X=-999.0,Y=-999.0,Z=-999.0),Animation="None",BehaviorStyle="ACS_Default",DistScaleWhenFacingCam=-999.0,BlendTime=-1.0,RevolutionAccelTime=-999.0,RevolutionAccelExponent=-999.0,HeightUpDelay=-999.0,HeightDownDelay=-999.0,LocationDelay=-999.0,RotationDelay=-999.0,FOVDelay=-999.0,DistanceDelay=-999.0,RevolutionDelay=-999.0,CameraID=-1)
    FloatCamera=(Distance=-999.0,MaxDistance=-999.0,MinDistance=-999.0,Orientation=(Pitch=-32767,Yaw=-32767,Roll=-32767),RevolutionSpeed=(Pitch=-32767,Yaw=-32767,Roll=-32767),InitRevolutionSpeed=(Pitch=-32767,Yaw=-32767,Roll=-32767),FOV=-999.0,Offset=(X=-999.0,Y=-999.0,Z=-999.0),Animation="None",BehaviorStyle="ACS_Default",DistScaleWhenFacingCam=-999.0,BlendTime=-1.0,RevolutionAccelTime=-999.0,RevolutionAccelExponent=-999.0,HeightUpDelay=-999.0,HeightDownDelay=-999.0,LocationDelay=-999.0,RotationDelay=-999.0,FOVDelay=-999.0,DistanceDelay=-999.0,RevolutionDelay=-999.0,CameraID=-1)
    SlideCamera=(Distance=-999.0,MaxDistance=-999.0,MinDistance=-999.0,Orientation=(Pitch=-32767,Yaw=-32767,Roll=-32767),RevolutionSpeed=(Pitch=-32767,Yaw=-32767,Roll=-32767),InitRevolutionSpeed=(Pitch=-32767,Yaw=-32767,Roll=-32767),FOV=-999.0,Offset=(X=-999.0,Y=-999.0,Z=-999.0),Animation="None",BehaviorStyle="ACS_Default",DistScaleWhenFacingCam=-999.0,BlendTime=-1.0,RevolutionAccelTime=-999.0,RevolutionAccelExponent=-999.0,HeightUpDelay=-999.0,HeightDownDelay=-999.0,LocationDelay=-999.0,RotationDelay=-999.0,FOVDelay=-999.0,DistanceDelay=-999.0,RevolutionDelay=-999.0,CameraID=-1)
    SteamVentCamera=(Distance=-999.0,MaxDistance=-999.0,MinDistance=-999.0,Orientation=(Pitch=-32767,Yaw=-32767,Roll=-32767),RevolutionSpeed=(Pitch=-32767,Yaw=-32767,Roll=-32767),InitRevolutionSpeed=(Pitch=-32767,Yaw=-32767,Roll=-32767),FOV=-999.0,Offset=(X=-999.0,Y=-999.0,Z=-999.0),Animation="None",BehaviorStyle="ACS_Default",DistScaleWhenFacingCam=-999.0,BlendTime=-1.0,RevolutionAccelTime=-999.0,RevolutionAccelExponent=-999.0,HeightUpDelay=-999.0,HeightDownDelay=-999.0,LocationDelay=-999.0,RotationDelay=-999.0,FOVDelay=-999.0,DistanceDelay=-999.0,RevolutionDelay=-999.0,CameraID=-1)
    ShrinkCamera=(Distance=-999.0,MaxDistance=-999.0,MinDistance=-999.0,Orientation=(Pitch=-32767,Yaw=-32767,Roll=-32767),RevolutionSpeed=(Pitch=-32767,Yaw=-32767,Roll=-32767),InitRevolutionSpeed=(Pitch=-32767,Yaw=-32767,Roll=-32767),FOV=-999.0,Offset=(X=-999.0,Y=-999.0,Z=-999.0),Animation="None",BehaviorStyle="ACS_Default",DistScaleWhenFacingCam=-999.0,BlendTime=-1.0,RevolutionAccelTime=-999.0,RevolutionAccelExponent=-999.0,HeightUpDelay=-999.0,HeightDownDelay=-999.0,LocationDelay=-999.0,RotationDelay=-999.0,FOVDelay=-999.0,DistanceDelay=-999.0,RevolutionDelay=-999.0,CameraID=-1)
    JumpPadsCamera=(Distance=-999.0,MaxDistance=-999.0,MinDistance=-999.0,Orientation=(Pitch=-32767,Yaw=-32767,Roll=-32767),RevolutionSpeed=(Pitch=-32767,Yaw=-32767,Roll=-32767),InitRevolutionSpeed=(Pitch=-32767,Yaw=-32767,Roll=-32767),FOV=-999.0,Offset=(X=-999.0,Y=-999.0,Z=-999.0),Animation="None",BehaviorStyle="ACS_Default",DistScaleWhenFacingCam=-999.0,BlendTime=-1.0,RevolutionAccelTime=-999.0,RevolutionAccelExponent=-999.0,HeightUpDelay=-999.0,HeightDownDelay=-999.0,LocationDelay=-999.0,RotationDelay=-999.0,FOVDelay=-999.0,DistanceDelay=-999.0,RevolutionDelay=-999.0,CameraID=-1)
    PushPullCamera=(Distance=-999.0,MaxDistance=-999.0,MinDistance=-999.0,Orientation=(Pitch=-32767,Yaw=-32767,Roll=-32767),RevolutionSpeed=(Pitch=-32767,Yaw=-32767,Roll=-32767),InitRevolutionSpeed=(Pitch=-32767,Yaw=-32767,Roll=-32767),FOV=-999.0,Offset=(X=-999.0,Y=-999.0,Z=-999.0),Animation="None",BehaviorStyle="ACS_Default",DistScaleWhenFacingCam=-999.0,BlendTime=-1.0,RevolutionAccelTime=-999.0,RevolutionAccelExponent=-999.0,HeightUpDelay=-999.0,HeightDownDelay=-999.0,LocationDelay=-999.0,RotationDelay=-999.0,FOVDelay=-999.0,DistanceDelay=-999.0,RevolutionDelay=-999.0,CameraID=-1)
    CombatCamera=(Distance=-999.0,MaxDistance=-999.0,MinDistance=-999.0,Orientation=(Pitch=-32767,Yaw=-32767,Roll=-32767),RevolutionSpeed=(Pitch=-32767,Yaw=-32767,Roll=-32767),InitRevolutionSpeed=(Pitch=-32767,Yaw=-32767,Roll=-32767),FOV=-999.0,Offset=(X=-999.0,Y=-999.0,Z=-999.0),Animation="None",BehaviorStyle="ACS_Default",DistScaleWhenFacingCam=-999.0,BlendTime=-1.0,RevolutionAccelTime=-999.0,RevolutionAccelExponent=-999.0,HeightUpDelay=-999.0,HeightDownDelay=-999.0,LocationDelay=-999.0,RotationDelay=-999.0,FOVDelay=-999.0,DistanceDelay=-999.0,RevolutionDelay=-999.0,CameraID=-1)
    SwimCamera=(Distance=-999.0,MaxDistance=-999.0,MinDistance=-999.0,Orientation=(Pitch=-32767,Yaw=-32767,Roll=-32767),RevolutionSpeed=(Pitch=-32767,Yaw=-32767,Roll=-32767),InitRevolutionSpeed=(Pitch=-32767,Yaw=-32767,Roll=-32767),FOV=-999.0,Offset=(X=-999.0,Y=-999.0,Z=-999.0),Animation="None",BehaviorStyle="ACS_Default",DistScaleWhenFacingCam=-999.0,BlendTime=-1.0,RevolutionAccelTime=-999.0,RevolutionAccelExponent=-999.0,HeightUpDelay=-999.0,HeightDownDelay=-999.0,LocationDelay=-999.0,RotationDelay=-999.0,FOVDelay=-999.0,DistanceDelay=-999.0,RevolutionDelay=-999.0,CameraID=-1)
    FastSwimCamera=(Distance=-999.0,MaxDistance=-999.0,MinDistance=-999.0,Orientation=(Pitch=-32767,Yaw=-32767,Roll=-32767),RevolutionSpeed=(Pitch=-32767,Yaw=-32767,Roll=-32767),InitRevolutionSpeed=(Pitch=-32767,Yaw=-32767,Roll=-32767),FOV=-999.0,Offset=(X=-999.0,Y=-999.0,Z=-999.0),Animation="None",BehaviorStyle="ACS_Default",DistScaleWhenFacingCam=-999.0,BlendTime=-1.0,RevolutionAccelTime=-999.0,RevolutionAccelExponent=-999.0,HeightUpDelay=-999.0,HeightDownDelay=-999.0,LocationDelay=-999.0,RotationDelay=-999.0,FOVDelay=-999.0,DistanceDelay=-999.0,RevolutionDelay=-999.0,CameraID=-1)
    WaterWalkCamera=(Distance=-999.0,MaxDistance=-999.0,MinDistance=-999.0,Orientation=(Pitch=-32767,Yaw=-32767,Roll=-32767),RevolutionSpeed=(Pitch=-32767,Yaw=-32767,Roll=-32767),InitRevolutionSpeed=(Pitch=-32767,Yaw=-32767,Roll=-32767),FOV=-999.0,Offset=(X=-999.0,Y=-999.0,Z=-999.0),Animation="None",BehaviorStyle="ACS_Default",DistScaleWhenFacingCam=-999.0,BlendTime=-1.0,RevolutionAccelTime=-999.0,RevolutionAccelExponent=-999.0,HeightUpDelay=-999.0,HeightDownDelay=-999.0,LocationDelay=-999.0,RotationDelay=-999.0,FOVDelay=-999.0,DistanceDelay=-999.0,RevolutionDelay=-999.0,CameraID=-1)
    InhabitPushPullCamera=(Distance=-999.0,MaxDistance=-999.0,MinDistance=-999.0,Orientation=(Pitch=-32767,Yaw=-32767,Roll=-32767),RevolutionSpeed=(Pitch=-32767,Yaw=-32767,Roll=-32767),InitRevolutionSpeed=(Pitch=-32767,Yaw=-32767,Roll=-32767),FOV=-999.0,Offset=(X=-999.0,Y=-999.0,Z=-999.0),Animation="None",BehaviorStyle="ACS_Default",DistScaleWhenFacingCam=-999.0,BlendTime=-1.0,RevolutionAccelTime=-999.0,RevolutionAccelExponent=-999.0,HeightUpDelay=-999.0,HeightDownDelay=-999.0,LocationDelay=-999.0,RotationDelay=-999.0,FOVDelay=-999.0,DistanceDelay=-999.0,RevolutionDelay=-999.0,CameraID=-1)
    StrafeCamera=(Distance=-999.0,MaxDistance=-999.0,MinDistance=-999.0,Orientation=(Pitch=-32767,Yaw=-32767,Roll=-32767),RevolutionSpeed=(Pitch=-32767,Yaw=-32767,Roll=-32767),InitRevolutionSpeed=(Pitch=-32767,Yaw=-32767,Roll=-32767),FOV=-999.0,Offset=(X=-999.0,Y=-999.0,Z=-999.0),Animation="None",BehaviorStyle="ACS_Default",DistScaleWhenFacingCam=-999.0,BlendTime=-1.0,RevolutionAccelTime=-999.0,RevolutionAccelExponent=-999.0,HeightUpDelay=-999.0,HeightDownDelay=-999.0,LocationDelay=-999.0,RotationDelay=-999.0,FOVDelay=-999.0,DistanceDelay=-999.0,RevolutionDelay=-999.0,CameraID=-1)
    FPSCamera=(Distance=-999.0,MaxDistance=-999.0,MinDistance=-999.0,Orientation=(Pitch=-32767,Yaw=-32767,Roll=-32767),RevolutionSpeed=(Pitch=-32767,Yaw=-32767,Roll=-32767),InitRevolutionSpeed=(Pitch=-32767,Yaw=-32767,Roll=-32767),FOV=-999.0,Offset=(X=-999.0,Y=-999.0,Z=-999.0),Animation="None",BehaviorStyle="ACS_Default",DistScaleWhenFacingCam=-999.0,BlendTime=-1.0,RevolutionAccelTime=-999.0,RevolutionAccelExponent=-999.0,HeightUpDelay=-999.0,HeightDownDelay=-999.0,LocationDelay=-999.0,RotationDelay=-999.0,FOVDelay=-999.0,DistanceDelay=-999.0,RevolutionDelay=-999.0,CameraID=-1)
    DefaultCamera=(Distance=-999.0,MaxDistance=-999.0,MinDistance=-999.0,Orientation=(Pitch=-32767,Yaw=-32767,Roll=-32767),RevolutionSpeed=(Pitch=-32767,Yaw=-32767,Roll=-32767),InitRevolutionSpeed=(Pitch=-32767,Yaw=-32767,Roll=-32767),FOV=-999.0,Offset=(X=-999.0,Y=-999.0,Z=-999.0),Animation="None",BehaviorStyle="ACS_Default",DistScaleWhenFacingCam=-999.0,BlendTime=-1.0,RevolutionAccelTime=-999.0,RevolutionAccelExponent=-999.0,HeightUpDelay=-999.0,HeightDownDelay=-999.0,LocationDelay=-999.0,RotationDelay=-999.0,FOVDelay=-999.0,DistanceDelay=-999.0,RevolutionDelay=-999.0,CameraID=-1)
    IntNormalCamera=(Distance=-999.0,MaxDistance=-999.0,MinDistance=-999.0,Orientation=(Pitch=-32767,Yaw=-32767,Roll=-32767),RevolutionSpeed=(Pitch=-32767,Yaw=-32767,Roll=-32767),InitRevolutionSpeed=(Pitch=-32767,Yaw=-32767,Roll=-32767),FOV=-999.0,Offset=(X=-999.0,Y=-999.0,Z=-999.0),Animation="None",BehaviorStyle="ACS_Default",DistScaleWhenFacingCam=-999.0,BlendTime=-1.0,RevolutionAccelTime=-999.0,RevolutionAccelExponent=-999.0,HeightUpDelay=-999.0,HeightDownDelay=-999.0,LocationDelay=-999.0,RotationDelay=-999.0,FOVDelay=-999.0,DistanceDelay=-999.0,RevolutionDelay=-999.0,CameraID=-1)
    IntShrinkCamera=(Distance=-999.0,MaxDistance=-999.0,MinDistance=-999.0,Orientation=(Pitch=-32767,Yaw=-32767,Roll=-32767),RevolutionSpeed=(Pitch=-32767,Yaw=-32767,Roll=-32767),InitRevolutionSpeed=(Pitch=-32767,Yaw=-32767,Roll=-32767),FOV=-999.0,Offset=(X=-999.0,Y=-999.0,Z=-999.0),Animation="None",BehaviorStyle="ACS_Default",DistScaleWhenFacingCam=-999.0,BlendTime=-1.0,RevolutionAccelTime=-999.0,RevolutionAccelExponent=-999.0,HeightUpDelay=-999.0,HeightDownDelay=-999.0,LocationDelay=-999.0,RotationDelay=-999.0,FOVDelay=-999.0,DistanceDelay=-999.0,RevolutionDelay=-999.0,CameraID=-1)
    ExtPlatformCamera=(Distance=-999.0,MaxDistance=-999.0,MinDistance=-999.0,Orientation=(Pitch=-32767,Yaw=-32767,Roll=-32767),RevolutionSpeed=(Pitch=-32767,Yaw=-32767,Roll=-32767),InitRevolutionSpeed=(Pitch=-32767,Yaw=-32767,Roll=-32767),FOV=-999.0,Offset=(X=-999.0,Y=-999.0,Z=-999.0),Animation="None",BehaviorStyle="ACS_Default",DistScaleWhenFacingCam=-999.0,BlendTime=-1.0,RevolutionAccelTime=-999.0,RevolutionAccelExponent=-999.0,HeightUpDelay=-999.0,HeightDownDelay=-999.0,LocationDelay=-999.0,RotationDelay=-999.0,FOVDelay=-999.0,DistanceDelay=-999.0,RevolutionDelay=-999.0,CameraID=-1)
    ExtFarCamera=(Distance=-999.0,MaxDistance=-999.0,MinDistance=-999.0,Orientation=(Pitch=-32767,Yaw=-32767,Roll=-32767),RevolutionSpeed=(Pitch=-32767,Yaw=-32767,Roll=-32767),InitRevolutionSpeed=(Pitch=-32767,Yaw=-32767,Roll=-32767),FOV=-999.0,Offset=(X=-999.0,Y=-999.0,Z=-999.0),Animation="None",BehaviorStyle="ACS_Default",DistScaleWhenFacingCam=-999.0,BlendTime=-1.0,RevolutionAccelTime=-999.0,RevolutionAccelExponent=-999.0,HeightUpDelay=-999.0,HeightDownDelay=-999.0,LocationDelay=-999.0,RotationDelay=-999.0,FOVDelay=-999.0,DistanceDelay=-999.0,RevolutionDelay=-999.0,CameraID=-1)
    ExtNearCamera=(Distance=-999.0,MaxDistance=-999.0,MinDistance=-999.0,Orientation=(Pitch=-32767,Yaw=-32767,Roll=-32767),RevolutionSpeed=(Pitch=-32767,Yaw=-32767,Roll=-32767),InitRevolutionSpeed=(Pitch=-32767,Yaw=-32767,Roll=-32767),FOV=-999.0,Offset=(X=-999.0,Y=-999.0,Z=-999.0),Animation="None",BehaviorStyle="ACS_Default",DistScaleWhenFacingCam=-999.0,BlendTime=-1.0,RevolutionAccelTime=-999.0,RevolutionAccelExponent=-999.0,HeightUpDelay=-999.0,HeightDownDelay=-999.0,LocationDelay=-999.0,RotationDelay=-999.0,FOVDelay=-999.0,DistanceDelay=-999.0,RevolutionDelay=-999.0,CameraID=-1)
    BackupCamera=(Distance=-999.0,MaxDistance=-999.0,MinDistance=-999.0,Orientation=(Pitch=-32767,Yaw=-32767,Roll=-32767),RevolutionSpeed=(Pitch=-32767,Yaw=-32767,Roll=-32767),InitRevolutionSpeed=(Pitch=-32767,Yaw=-32767,Roll=-32767),FOV=-999.0,Offset=(X=-999.0,Y=-999.0,Z=-999.0),Animation="None",BehaviorStyle="ACS_Default",DistScaleWhenFacingCam=-999.0,BlendTime=-1.0,RevolutionAccelTime=-999.0,RevolutionAccelExponent=-999.0,HeightUpDelay=-999.0,HeightDownDelay=-999.0,LocationDelay=-999.0,RotationDelay=-999.0,FOVDelay=-999.0,DistanceDelay=-999.0,RevolutionDelay=-999.0,CameraID=-1)
    TargetCamera=(Distance=-999.0,MaxDistance=-999.0,MinDistance=-999.0,Orientation=(Pitch=-32767,Yaw=-32767,Roll=-32767),RevolutionSpeed=(Pitch=-32767,Yaw=-32767,Roll=-32767),InitRevolutionSpeed=(Pitch=-32767,Yaw=-32767,Roll=-32767),FOV=-999.0,Offset=(X=-999.0,Y=-999.0,Z=-999.0),Animation="None",BehaviorStyle="ACS_Default",DistScaleWhenFacingCam=-999.0,BlendTime=-1.0,RevolutionAccelTime=-999.0,RevolutionAccelExponent=-999.0,HeightUpDelay=-999.0,HeightDownDelay=-999.0,LocationDelay=-999.0,RotationDelay=-999.0,FOVDelay=-999.0,DistanceDelay=-999.0,RevolutionDelay=-999.0,CameraID=-1)
    PreCameraPreset=(Distance=-999.0,MaxDistance=-999.0,MinDistance=-999.0,Orientation=(Pitch=-32767,Yaw=-32767,Roll=-32767),RevolutionSpeed=(Pitch=-32767,Yaw=-32767,Roll=-32767),InitRevolutionSpeed=(Pitch=-32767,Yaw=-32767,Roll=-32767),FOV=-999.0,Offset=(X=-999.0,Y=-999.0,Z=-999.0),Animation="None",BehaviorStyle="ACS_Default",DistScaleWhenFacingCam=-999.0,BlendTime=-1.0,RevolutionAccelTime=-999.0,RevolutionAccelExponent=-999.0,HeightUpDelay=-999.0,HeightDownDelay=-999.0,LocationDelay=-999.0,RotationDelay=-999.0,FOVDelay=-999.0,DistanceDelay=-999.0,RevolutionDelay=-999.0,CameraID=-1)
    CombinedCameraPreset=(Distance=-999.0,MaxDistance=-999.0,MinDistance=-999.0,Orientation=(Pitch=-32767,Yaw=-32767,Roll=-32767),RevolutionSpeed=(Pitch=-32767,Yaw=-32767,Roll=-32767),InitRevolutionSpeed=(Pitch=-32767,Yaw=-32767,Roll=-32767),FOV=-999.0,Offset=(X=-999.0,Y=-999.0,Z=-999.0),Animation="None",BehaviorStyle="ACS_Default",DistScaleWhenFacingCam=-999.0,BlendTime=-1.0,RevolutionAccelTime=-999.0,RevolutionAccelExponent=-999.0,HeightUpDelay=-999.0,HeightDownDelay=-999.0,LocationDelay=-999.0,RotationDelay=-999.0,FOVDelay=-999.0,DistanceDelay=-999.0,RevolutionDelay=-999.0,CameraID=-1)
    CameraPresetBlendParams=(BlendTime=0.0,BlendFunction="VTBlend_Cubic",BlendExp=2.0,bLockOutgoing=False,MaxAngle=180.0)
    CurCameraPresetStyle=-1
    TmpCamera=(Distance=-999.0,MaxDistance=-999.0,MinDistance=-999.0,Orientation=(Pitch=-32767,Yaw=-32767,Roll=-32767),RevolutionSpeed=(Pitch=-32767,Yaw=-32767,Roll=-32767),InitRevolutionSpeed=(Pitch=-32767,Yaw=-32767,Roll=-32767),FOV=-999.0,Offset=(X=-999.0,Y=-999.0,Z=-999.0),Animation="None",BehaviorStyle="ACS_Default",DistScaleWhenFacingCam=-999.0,BlendTime=-1.0,RevolutionAccelTime=-999.0,RevolutionAccelExponent=-999.0,HeightUpDelay=-999.0,HeightDownDelay=-999.0,LocationDelay=-999.0,RotationDelay=-999.0,FOVDelay=-999.0,DistanceDelay=-999.0,RevolutionDelay=-999.0,CameraID=-1)
    TmpTargetCamera=(Distance=-999.0,MaxDistance=-999.0,MinDistance=-999.0,Orientation=(Pitch=-32767,Yaw=-32767,Roll=-32767),RevolutionSpeed=(Pitch=-32767,Yaw=-32767,Roll=-32767),InitRevolutionSpeed=(Pitch=-32767,Yaw=-32767,Roll=-32767),FOV=-999.0,Offset=(X=-999.0,Y=-999.0,Z=-999.0),Animation="None",BehaviorStyle="ACS_Default",DistScaleWhenFacingCam=-999.0,BlendTime=-1.0,RevolutionAccelTime=-999.0,RevolutionAccelExponent=-999.0,HeightUpDelay=-999.0,HeightDownDelay=-999.0,LocationDelay=-999.0,RotationDelay=-999.0,FOVDelay=-999.0,DistanceDelay=-999.0,RevolutionDelay=-999.0,CameraID=-1)
    ForceResetCameraWaitTime=0.3
    MaxLockOnPitchDeclination=1.0
    MaxLockOnYawDeclination=1.0
    LockOnCameraRotSpeed=250.0
    ReadjustBlendSpeed=0.3
    SwitchTargetBlendDelay=0.3
    CombatToStrafeCamBlendDelay=5.0
    MiddleModeBlendTime=1.0
    SwitchMiddleModeFOVScale=0.5
    LockOnYawOffset=60.0
    TargetOnDestroyedActorTimer=5.0
    LockConeAngle=120.0
    RSHoldSwitchDuration=0.3
    RTTapThreshold=0.7
    FOVScale=1.7
    MinNPCToCamDistance=500.0
    MaxNPCToCamDistance=3000.0
    MinLockUIScale=1.0
    MaxLockUIScale=0.2
    Zrear=50.0
    Zfar=4000.0
    Zxyfar=2000.0
    Xfar=1000.0
    Yfar=1000.0
    KynapseHandle="Default__AlicePawn.PawnKynapseHandle"
    ExtraSplinRollLimitWhenRunning=10.0
    ExtraHeadRollLimitWhenRunning=10.0
    ExtraSplinYawLimitWhenRunning=20.0
    ExtraHeadYawLimitWhenRunning=15.0
    TargetingSearchRadius=1600.0
    CamRotDelayCombatTargeting=0.1
    LungeRange=600.0
    CombatJumpZ=800.0
    NonLockOnAutoTargetAngleRange=90.0
    NonLockOnAutoTargetDistance=200.0
    fNoNPCInCamLockingRadius=2000.0
    fNoNPCInCamLockingHeight=1000.0
    DelayTimeForNextDodge=1.0
    VorpalBlade_StrafeSpeed=(Forward=400.0,Backward=200.0,Left=400.0,Right=400.0)
    TeapotCannon_StrafeSpeed=(Forward=400.0,Backward=200.0,Left=400.0,Right=400.0)
    TeapotCannon_Charge_StrafeSpeed=(Forward=400.0,Backward=200.0,Left=400.0,Right=400.0)
    EyeStaff_StrafeSpeed=(Forward=400.0,Backward=200.0,Left=400.0,Right=400.0)
    HobbyHorse_StrafeSpeed=(Forward=400.0,Backward=200.0,Left=400.0,Right=400.0)
    EyeStaff_StrafeSpeed_Aiming=(Forward=400.0,Backward=200.0,Left=400.0,Right=400.0)
    TeapotCannon_StrafeSpeed_Aiming=(Forward=400.0,Backward=200.0,Left=400.0,Right=400.0)
    TeapotCannon_Charge_StrafeSpeed_Aiming=(Forward=400.0,Backward=200.0,Left=400.0,Right=400.0)
    CamLockOnDOFSettings=(FalloffExponent=1.0,BlurKernelSize=4.0,FocusNearInnerRadius=10.0,FocusFarInnerRadius=100.0,NearFocusDistance=10.0,FarFocusDistanceOffset=100.0,AdaptationRate=120.0,bEnableDOF=False,bEnableDynamicDoF=False,FarFocusDistance=100000.0)
    TargetRangeForDynamicYOffset=2.0
    DynamicPitchExponentModifier=1.0
    OldAliceDir=(X=1.0,Y=0.0,Z=0.0)
    MaxDistForLockOnCamDrop=50.0
    TimeDelayToCancelLockOnCameraParameters=1.0
    LightEnvironment="Default__AlicePawn.MyLightEnvironment"
    ShadowCameraZoomIn=45.0
    ShadowCameraZoomOut=120.0
    ShadowCameraZoomNormal=60.0
    ShrinkingSound="Alice_Actions.Alice_Shrink_Cue"
    ShrinkBubbleSound="SFX_Alice_Actions.sfx_alice_hiccup01_Cue"
    UnShrinkingSound="Alice_Actions.Alice_Unshrink_Cue"
    ShrinkingCollisionScale=0.5
    ShrinkBaseEyeHeight=32.0
    ShrinkJumpHeight=425.0
    ShrinkMaxWalkingSpeed=100.0
    ShrinkMaxRunningSpeed=200.0
    ShrinkParticleIntermittentTime=5.0
    StartShrink="GFX_Alice.Shrink.AliceShrinkStart"
    EndShrink="GFX_Alice.Shrink.AliceShrinkEnd"
    ShrunkSprintSpeed=600.0
    ShrinkSpeed=0.2
    UnShrinkSpeed=0.2
    UnshrinkRadius=40.0
    UnshrinkHeight=120.0
    LowJumpAccel=-800.0
    TimeToCancelFloatModeWhenNoTapping=0.5
    FloatDownGravityZ=-150.0
    MaxFloatBoundSpeed=300.0
    GlideDownGravityZ=-150.0
    FirstCycle=3.5
    CycleRatio=0.7
    GlideLoopingCue="SFX_Alice_Actions.sfx_alice_jump_float_Cue"
    JumpCue="SFX_Alice_Actions.sfx_alice_jump01_Cue"
    FloatFadeOutTime=1.0
    FloatFadeInVolume=1.0
    PushSpeed=2.0
    SuperPushGridNumber=2
    TriggerFloatDownTime=0.5
    MinFallingVelocityZ=-150.0
    PrePreDuration=0.3
    PreDuration=0.7
    MaxCycleFloat=3
    HairComponent="Default__AlicePawn.AliceHairComponent"
    HysteriaHair=(HairTemplate="None",PhysicsAsset="None",Force=(X=0.0,Y=0.0,Z=-980.0),PerturbAmplitude=(X=0.0,Y=0.0,Z=0.0),PerturbTemporalPeriod=(X=2.0,Y=2.1,Z=2.2),PerturbSpatialPeriod=(X=0.1,Y=0.1,Z=0.1),PerturbPhaseShift=(X=0.0,Y=0.0,Z=0.0),Damping=7.0,Iteration=1,LengthScale=1.0,Material="None",TessellationStep=2,StrandWidth=1.5,FloatForce=(X=0.0,Y=0.0,Z=2000.0),FloatPerturbAmplitude=(X=0.0,Y=0.0,Z=0.0),FloatDamping=-5.0)
    WaterHair=(HairTemplate="None",PhysicsAsset="None",Force=(X=0.0,Y=0.0,Z=-980.0),PerturbAmplitude=(X=0.0,Y=0.0,Z=0.0),PerturbTemporalPeriod=(X=2.0,Y=2.1,Z=2.2),PerturbSpatialPeriod=(X=0.1,Y=0.1,Z=0.1),PerturbPhaseShift=(X=0.0,Y=0.0,Z=0.0),Damping=7.0,Iteration=1,LengthScale=1.0,Material="None",TessellationStep=2,StrandWidth=1.5,FloatForce=(X=0.0,Y=0.0,Z=2000.0),FloatPerturbAmplitude=(X=0.0,Y=0.0,Z=0.0),FloatDamping=-5.0)
    WRabbitHair=(HairTemplate="None",PhysicsAsset="None",Force=(X=0.0,Y=0.0,Z=-980.0),PerturbAmplitude=(X=0.0,Y=0.0,Z=0.0),PerturbTemporalPeriod=(X=2.0,Y=2.1,Z=2.2),PerturbSpatialPeriod=(X=0.1,Y=0.1,Z=0.1),PerturbPhaseShift=(X=0.0,Y=0.0,Z=0.0),Damping=7.0,Iteration=1,LengthScale=1.0,Material="None",TessellationStep=2,StrandWidth=1.5,FloatForce=(X=0.0,Y=0.0,Z=2000.0),FloatPerturbAmplitude=(X=0.0,Y=0.0,Z=0.0),FloatDamping=-5.0)
    MadHatterHair=(HairTemplate="None",PhysicsAsset="None",Force=(X=0.0,Y=0.0,Z=-980.0),PerturbAmplitude=(X=0.0,Y=0.0,Z=0.0),PerturbTemporalPeriod=(X=2.0,Y=2.1,Z=2.2),PerturbSpatialPeriod=(X=0.1,Y=0.1,Z=0.1),PerturbPhaseShift=(X=0.0,Y=0.0,Z=0.0),Damping=7.0,Iteration=1,LengthScale=1.0,Material="None",TessellationStep=2,StrandWidth=1.5,FloatForce=(X=0.0,Y=0.0,Z=2000.0),FloatPerturbAmplitude=(X=0.0,Y=0.0,Z=0.0),FloatDamping=-5.0)
    DefaultHair=(HairTemplate="None",PhysicsAsset="None",Force=(X=0.0,Y=0.0,Z=-980.0),PerturbAmplitude=(X=0.0,Y=0.0,Z=0.0),PerturbTemporalPeriod=(X=2.0,Y=2.1,Z=2.2),PerturbSpatialPeriod=(X=0.1,Y=0.1,Z=0.1),PerturbPhaseShift=(X=0.0,Y=0.0,Z=0.0),Damping=7.0,Iteration=1,LengthScale=1.0,Material="None",TessellationStep=2,StrandWidth=1.5,FloatForce=(X=0.0,Y=0.0,Z=2000.0),FloatPerturbAmplitude=(X=0.0,Y=0.0,Z=0.0),FloatDamping=-5.0)
    CurHair=(HairTemplate="None",PhysicsAsset="None",Force=(X=0.0,Y=0.0,Z=-980.0),PerturbAmplitude=(X=0.0,Y=0.0,Z=0.0),PerturbTemporalPeriod=(X=2.0,Y=2.1,Z=2.2),PerturbSpatialPeriod=(X=0.1,Y=0.1,Z=0.1),PerturbPhaseShift=(X=0.0,Y=0.0,Z=0.0),Damping=7.0,Iteration=1,LengthScale=1.0,Material="None",TessellationStep=2,StrandWidth=1.5,FloatForce=(X=0.0,Y=0.0,Z=2000.0),FloatPerturbAmplitude=(X=0.0,Y=0.0,Z=0.0),FloatDamping=-5.0)
    HairFloatForce=(X=0.0,Y=0.0,Z=2000.0)
    HairFloatDamping=-5.0
    SkirtComponent="Default__AlicePawn.AliceSkirt"
    BowComponent="Default__AlicePawn.AliceBow"
    RibbonComponent="Default__AlicePawn.AliceRibbon"
    SkirtFloatRadialForceDisplacement=(X=-15.0,Y=0.0,Z=0.0)
    SkirtFloatRadialForceMagnitude=15000.0
    SkirtFallingRadialForceDisplacement=(X=-15.0,Y=0.0,Z=0.0)
    SkirtFallingRadialForceMagnitudeScale=10.0
    SkirtFallingRadialForceMagnitudeMax=2500.0
    RibbonFloatRadialForceMagnitude=2000.0
    RibbonFallingRadialForceMagnitudeScale=2500.0
    RibbonFallingRadialForceMagnitudeMax=250.0
    SkirtFloatInitialDuration=0.2
    SkirtFloatInitialScale=20.0
    SkirtFloatInitialDisplacement=(X=-30.0,Y=0.0,Z=0.0)
    EarComponent="Default__AlicePawn.AliceEar"
    HairPerturbAmplitudeScale=(X=2.0,Y=2.0,Z=2.0)
    RibbonPerturbAmplitudeScale=(X=2.0,Y=2.0,Z=2.0)
    SonarRadius=500.0
    SonarDuration=3.0
    ShrinkDuration=3.0
    Endurance=(TotalEndurance=100.0,Cost=10.0,Cost[1]=10.0,Recovery=10.0,ThresholdToRest=0.0)
    RightHandSocketName="knife"
    TestMesh="CH_Alice_Graphic.AliceW.SK_AliceW"
    TestPhysicsAsset="ANI_Test_HairCloth.Alice_Test_Physics"
    DeathRagdollDelay=0.2
    RespawnRagdollDelay=0.2
    SwimTurnSpeed=150.0
    BarrelRollDelayTime=0.5
    BoostSwimSpeed=30.0
    BoostSwimTurnSpeed=0.02
    BoostCoolDownTime=1.0
    BootSwimTime=0.3
    SlowSwimSpeed=20.0
    ChangeSwimModleParticle="GFX_GamePlay.Sprint.AliceSprintAction"
    SwimAttackParticle="FX_NPC_LostSoul.P_NPC_LostSoul_SoulCore_TEMP"
    AttackRadius=300.0
    SwimAmbientSoundCue="SFX_C2_Common.c2_common_amb_underwater01_Cue"
    SwimAttackSoundCue="SFX_Alice_Electric.sfx_meralice_shock01_Cue"
    SwimBoostDamage=100.0
    SwimSpeedInertia=75.0
    SlowSwimSpeedInertia=25.0
    SprintSpeed=800.0
    SprintOffSpeed=400.0
    PreSprintDuration=0.2
    HorizonThreshold=200.0
    VerticalThreshold=-700.0
    MorphTime_EyeStaff=0.1
    MorphTime_TeapotCannon=0.1
    MorphTime_HobbyHorse=0.1
    MorphTime_VorpalBlade=0.1
    MorphNameDefault="Alice_MorphDefault"
    MorphWindForce=(X=1000.0,Y=0.0,Z=5000.0)
    MorphWindPerturbAmplitude=(X=1500.0,Y=1500.0,Z=1500.0)
    WeaponFadeInTime=0.5
    WeaponFadeInDelay=0.2
    WeaponFadeOutTime=0.1
    SlideTurnSpeed=6000.0
    SlideBrakeSpeed=0.75
    SlideBoostSpeed=1200.0
    SlideTurnCorrectionTime=0.1
    SlideMinSpeedToRotate=10.0
    SlideBumpDamage=100.0
    RollBumpDamage=100.0
    RespawnCloneDelay=5.0
    CurHealthLevel=-1
    OldHealthLevel=-1
    MinJumpPitch=-6500.0
    JumpPitchFactor=10.0
    AButtonPress=0.7
    DeathCamera="LD_CameraAnims.Gameplay.CA_Death_Generic"
    RespawnCamera="LD_CameraAnims.Gameplay.CA_Respawn"
    DeathParticle="GFX_Alice.Death.DT_W_NPC"
    RespawnParticle="GFX_Alice.Death.RP_W_NPC"
    DeathSound="SFX_Alice_Actions.sfx_alice_death_Cue"
    RespawnSound="Alice_Actions.AliceRespawn_Cue"
    BlinkMinTime=256
    BlinkDeltaTime=512
    SmokeSkinMaterial="Smoke_Test.Fire_Small01_Mat"
    ColdBreathParticle="GFX_WonderlandSmoke.Breath.ColdBreathing_P"
    BubbleParticle="GFX_WonderlandWater.Bubbles.BreathingBubbles"
    EntryInhabitParticle="GFX_GamePlay.Sprint.AliceSprintAction"
    LeaveInhabitParticle="GFX_GamePlay.Sprint.AliceSprintAction"
    EntryInhaitSound="Alice_Actions.Alice_Shrink_Cue"
    LeaveInhaitSound="Alice_Actions.Alice_Unshrink_Cue"
    AliceShield=(NoBlockingWeaponFileter=(),ShieldPhysicsAsset="None",KnockBackDistScale=1.0,KnockBackTimeScale=1.0,ShieldOrientRefAngle=(Pitch=0,Yaw=0,Roll=0),ShieldAreaAngle0=90.0,ShieldAreaAngle1=90.0)
    RollPhysicsAsset="CH_AliceRoll.SK_AliceW_RollPhysics"
    RollMesh="Dollheads.Dollhead_A"
    RollMaxAngularVelocity=50.0
    RollMoveImpulse=0.01
    RollJumpImpulse=5000.0
    RollHorizontalDamping=0.01
    RollVerticalDamping=0.001
    RollExtraGravity=100.0
    RollJumpTraceHeight=80.0
    RollJumpTraceDistance=100.0
    RollingSlideThreshold_Slow=10.0
    RollingSlideThreshold_Fast=500.0
    RollingSlideDisableDelay=0.1
    RollingSlideSoundFadeInTime=0.1
    RollingSlideSoundFadeOutTime=0.1
    CloneArcheType="AliceWeapon_Archetype.AliceClone_Archetype"
    StompDamege=100
    RepulsorSecond=3.0
    StompDamageType="Engine.DamageType"
    Repulsion=400.0
    DashBreakPhysicsAsset="CH_Alice_Graphic.PhysicsAsset.SK_AliceW_SkirtPhysics"
    DelayToActivateAimingModeWhenQuitLockOn=0.2
    ViewPictchMaxWhenAiming=10977.0
    ViewPictchMinWhenAiming=-3000.0
    AimingFOVBlendTime=2.0
    AimingFOVOffBlendTime=1.0
    AimingZoomDelay=1.0
    BlobShadow=(bIsValid=True,DecalMaterial="None",Width=30.0,Height=30.0,WidthSK=10.0,HeightSK=10.0,Thickness=10.0,bRandomizeRotation=False,RandomScalingRange=(X=1.0,Y=1.2),LifeSpan=0.0,BlendRange=(X=89.5,Y=180.0),RandomRadiusOffset=0.0,WeaponLevel=0)
    ShadowScale=1.0
    DistanceScale=1.0
    MaxTimeFallingEdgeToJump=0.1
    TimeDelayToCauseDamageWhenNPCAttached=1.0
    TimeIntervalToCauseDamageWhenNPCAttached=2.0
    AttachedNPCScareAliceSoundComp="Default__AlicePawn.AttachedNPCScareAliceSoundComponent"
    AttachedNPCScareAliceSoundRepeatDelay=0.1
    HysteriaDuration=60.0
    IncraseDamagePercent=2000.0
    TriggrHealth=20.0
    ReactiveHealth=50.0
    RecoverHealth=50.0
    HysteriaReadySound="SFX_Alice_Actions.sfx_hysteria_ready_Cue"
    HysteriaParticle="FX_NPC_LostSoul.P_NPC_LostSoul_SoulCore_TEMP"
    HysteriaDress=(SkelMesh="CH_Alice_Hysteria.SK_Alice_Hysteria",Bow="CH_Alice_Hysteria.SK_Alice_Hysteria_Bow",Ribbon="CH_Alice_Hysteria.SK_Alice_Hysteria_Ribbon",Skirt="CH_Alice_Hysteria.SK_Alice_Hysteria_Skirt",Ear="None")
    MaxFrozenTime=10.0
    TimeLimitToCountFreezingHit=3.0
    FreezingHitTimesToTriggerFrozenState=3
    DelayTimeToShowDodgeToEscapeUI=0.5
    FrozenParticle="FX_NPC_IceSnark.AliceFreeze_P"
    FrozenBreakParticle="FX_NPC_IceSnark.AliceFreeze_Break_P"
    FrozenLoopPS="Default__AlicePawn.LoopPS"
    XPToTokenConversion=5
    T2SmlXPAmount=(Easy=40,Normal=30,Hard=20,VeryHard=10)
    T2MedXPAmount=(Easy=40,Normal=30,Hard=20,VeryHard=10)
    T2LgeXPAmount=(Easy=40,Normal=30,Hard=20,VeryHard=10)
    T1MedXPAmount=(Easy=40,Normal=30,Hard=20,VeryHard=10)
    T1LgeXPAmount=(Easy=40,Normal=30,Hard=20,VeryHard=10)
    T1BossXPAmount=(Easy=40,Normal=30,Hard=20,VeryHard=10)
    ShowPathTriggerParticle="GFX_WonderlandWater.Bubbles.BreathingBubbles"
    ShowPathTrailParticle="GFX_WonderlandWater.Bubbles.BreathingBubbles"
    ShowPathLifeTime=3.0
    MinDeflectTime=0.5
    MaxDeflectTime=10.0
    MaxDeflectSpinningTime=5.0
    CylinderRadiusWhileDeflect=100.0
    bCanDeflectSpin=1
    HoverJumpZ=840.0
    MediumFallingHeight=400.0
    HeavyFallingHeight=800.0
    ShrinkFlower_RecoverHPTimePerHP_AbsValue=1.0
    MODDLC_Flesh_NPCDropMoreXP_Percent=0.25
    MODDLC_Chess_NPCDropMoreHP_Percent=0.25
    MODDLC_MadHatter_BreakableDropMoreXP_Percent=0.5
    MODDLC_MadHatter_BreakableDropMoreHP_Percent=0.5
    MODDLC_Rabbit_HPShrinkRecPerHP_AbsValue=2.0
    MODDLC_Cheshire_HPMaxClamp_AbsValue=32
    MODDLC_Caterpillar_SonarVisibleTimeInc_Percent=1.0
    MODDLC_MatHatter_DLCTC_XPToHP_AbsValue=10
    MODDLC_Chess_DLCHH_AttackInc_Percent=0.5
    MODDLC_Rabbit_DLCPG_AutoHPRecTimePerHP_AbsValue=2.0
    RotateState="ERotateState_None"
    AnimBlendNodes(0)="None"
    AnimBlendNodeNum=1
    bEnableFakeConeCollision=False
    SpecialMoveClasses(0)="None"
    SpecialMoveClasses(1)="ASM_Brake"
    SpecialMoveClasses(2)="ASM_Rotate"
    SpecialMoveClasses(3)="ASM_JumpStart"
    SpecialMoveClasses(4)="ASM_DoubleJump"
    SpecialMoveClasses(5)="ASM_GrabLedgeWhenJump"
    SpecialMoveClasses(6)="ASM_GrabLedge_JumpToAnotherLedge"
    SpecialMoveClasses(7)="ASM_GrabLedge_SwitchToAnotherLedge"
    SpecialMoveClasses(8)="ASM_GrabLedge_DropToLedge"
    SpecialMoveClasses(9)="ASM_GrabLedge_DropFromLedge"
    SpecialMoveClasses(10)="ASM_GrabLedge_ClimbOverLedge"
    SpecialMoveClasses(11)="ASM_ChangeDirOnLedge"
    SpecialMoveClasses(12)="None"
    SpecialMoveClasses(13)="ASM_MeleeComboCommon"
    SpecialMoveClasses(14)="ASM_GiantAliceCMA_One"
    SpecialMoveClasses(15)="ASM_GiantAliceCMA_Two"
    SpecialMoveClasses(16)="ASM_GiantAliceCMA_Thr"
    SpecialMoveClasses(17)="None"
    SpecialMoveClasses(18)="ASM_GiantStomp"
    SpecialMoveClasses(19)="None"
    SpecialMoveClasses(20)="ASM_TeapotCannonRA_Fire"
    SpecialMoveClasses(21)="ASM_TeapotCannonRA_Charge"
    SpecialMoveClasses(22)="ASM_EyeStaffRA_Fire"
    SpecialMoveClasses(23)="ASM_EyeStaffRA_NoAmmo"
    SpecialMoveClasses(24)="ASM_EyeStaffRA_DoubleFire"
    SpecialMoveClasses(25)="ASM_EyeStaffRA_DoubleFireReady"
    SpecialMoveClasses(26)="ASM_EyeStaffRA_StopWindUp"
    SpecialMoveClasses(27)="ASM_EyeStaffRA_Charge"
    SpecialMoveClasses(28)="ASM_EyeStaffRA_ChargeComplete"
    SpecialMoveClasses(29)="None"
    SpecialMoveClasses(30)="None"
    SpecialMoveClasses(31)="ASM_VorpalBladeCMANL"
    SpecialMoveClasses(32)="ASM_HobbyHorseCMANL"
    SpecialMoveClasses(33)="None"
    SpecialMoveClasses(34)="ASM_VorpalBladeClone"
    SpecialMoveClasses(35)="ASM_Denotate"
    SpecialMoveClasses(36)="ASM_Disarm"
    SpecialMoveClasses(37)="ASM_Combat_Dodge"
    SpecialMoveClasses(38)="ASM_Combat_Jump"
    SpecialMoveClasses(39)="ASM_ShieldBreakingPrepare"
    SpecialMoveClasses(40)="ASM_ShieldBreakingDash"
    SpecialMoveClasses(41)="ASM_GetHurt"
    SpecialMoveClasses(42)="ASM_GetHurtWhenJump"
    SpecialMoveClasses(43)="ASM_HitShieldReaction"
    SpecialMoveClasses(44)="ASM_BeGrabbed"
    SpecialMoveClasses(45)="ASM_GetNPCAttached"
    SpecialMoveClasses(46)="ASM_DeflectTransition"
    SpecialMoveClasses(47)="ASM_BlockReaction"
    SpecialMoveClasses(48)="ASM_DeflectSpin"
    SpecialMoveClasses(49)="ASM_JumpPad"
    SpecialMoveClasses(50)="ASM_JumpPadPhysics"
    SpecialMoveClasses(51)="ASM_GrabLedge_FallFromBalanceBeamToGrab"
    SpecialMoveClasses(52)="ASM_ToggleShrink"
    SpecialMoveClasses(53)="ASM_SlideToTarget"
    SpecialMoveClasses(54)="ASM_SlideBackwardTarget"
    SpecialMoveClasses(55)="ASM_ContextSensitive"
    SpecialMoveClasses(56)="ASM_SwimIdleToForward"
    SpecialMoveClasses(57)="ASM_SteamVentUp"
    SpecialMoveClasses(58)="ASM_SteamVentIdle"
    SpecialMoveClasses(59)="ASM_SteamVentBackward"
    SpecialMoveClasses(60)="ASM_SteamVentForward"
    SpecialMoveClasses(61)="ASM_SteamVentLeft"
    SpecialMoveClasses(62)="ASM_SteamVentRight"
    SpecialMoveClasses(63)="ASM_FloatFail"
    SpecialMoveClasses(64)="ASM_HoverJump"
    SpecialMoveClasses(65)="ASM_HoverHit"
    SpecialMoveClasses(66)="ASM_Hysteria"
    SpecialMoveClasses(67)="ASM_AliceDead"
    SpecialMoveClasses(68)="ASM_AliceRespawn"
    SpecialMoveClasses(69)="ASM_BrustOutFromFlower"
    MeshTranslationNudgeOffset=0.5
    MaxWalkingSpeed=200.0
    MaxRunningSpeed=400.0
    RotSpeedFactor=3.1415925
    RotSpeedFactorInAir=1.57
    RotAnimationLength=1.7
    AngleToFastTurn=1.0472
    AutoSnappingAngularSpeed=8192
    SearchRadiusOfALedgeEnd=60.0
    CollisionHeightLedgeClimbing=74.0
    LedgeJumpInitialVelocity=500.0
    HorizontalLedgeJumpMaxDistance=200.0
    VerticalLedgeJumpMaxDistance=210.0
    ForwardJumpMaxDistance=400.0
    MinAutoClimbHeight=64.0
    MaxAutoClimbHeight=196.0
    SwimSpeed=15.0
    WaterWalkSpeedWalk=100.0
    WaterWalkSpeedRun=200.0
    WaterWalkJumpHeight=5.0
    WaterWalkGravityZ=-200.0
    SpeechPitchMultiplier=1.0
    InvincibleTime=5.0
    bCanClimbLadders=True
    bCanPickupInventory=True
    bUseTranslateIK=True
    bStopAtLedges=0
    XPMaxValue=1000000
    GroundSpeed=400.0
    JumpZ=840.0
    Health=10000
    HealthMax=100
    Mesh="Default__AlicePawn.AlicePawnSkeletalMeshComponent"
    CylinderComponent="Default__AlicePawn.CollisionCylinder"
    ViewPitchMin=-5488.0
    ViewPitchMax=10977.0
    InventoryManagerClass="AliceInventoryManager"
    FacialAudioComp="Default__AlicePawn.FaceAudioComponent"
    FacialAnimSets(0)="CH_Alice.Alice_InGame_FaceFX_AnimSet_VS"
    FacialAnimInfo(0)=(FacialAnimSetIndex=0,FacialAnimName="Blink",FacialAnimGroupName="Alice_FaceFX_AnimSet_VS",FacialSoundCue="None")
    FacialAnimInfo(1)=(FacialAnimSetIndex=0,FacialAnimName="Sad",FacialAnimGroupName="Alice_FaceFX_AnimSet_VS",FacialSoundCue="None")
    FacialAnimInfo(2)=(FacialAnimSetIndex=0,FacialAnimName="Shock",FacialAnimGroupName="Alice_FaceFX_AnimSet_VS",FacialSoundCue="None")
    FacialAnimInfo(3)=(FacialAnimSetIndex=0,FacialAnimName="Smile",FacialAnimGroupName="Alice_FaceFX_AnimSet_VS",FacialSoundCue="None")
    bCanStepUpOn=False
    Components(0)="Default__AlicePawn.CollisionCylinder"
    Components(1)="Default__AlicePawn.Arrow"
    Components(2)="Default__AlicePawn.FaceAudioComponent"
    Components(3)="Default__AlicePawn.MyLightEnvironment"
    Components(4)="Default__AlicePawn.AlicePawnSkeletalMeshComponent"
    Components(5)="Default__AlicePawn.AliceSkirt"
    Components(6)="Default__AlicePawn.AliceBow"
    Components(7)="Default__AlicePawn.AliceRibbon"
    Components(8)="Default__AlicePawn.PawnKynapseHandle"
    Components(9)="Default__AlicePawn.AttachedNPCScareAliceSoundComponent"
    Components(10)="Default__AlicePawn.AttachedForceFieldComponent"
    CollisionComponent="Default__AlicePawn.CollisionCylinder"
    SupportedEvents(0)="Engine.SeqEvent_Touch"
    SupportedEvents(1)="Engine.SeqEvent_Destroyed"
    SupportedEvents(2)="Engine.SeqEvent_TakeDamage"
    SupportedEvents(3)="Engine.SeqEvent_HitWall"
    SupportedEvents(4)="SeqEvent_AliceCamera"
    SupportedEvents(5)="SeqEvent_AliceContext"
    SupportedEvents(6)="Engine.SeqEvent_Death"
    SupportedEvents(7)="SeqEvent_AliceSwimMode"
}

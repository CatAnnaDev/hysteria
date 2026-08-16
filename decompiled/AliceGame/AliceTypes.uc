class AliceTypes extends Object
    abstract
    native
    notplaceable;

enum ClockBombType
{
    CBT_FallFromAliceHand,
    CBT_SetupByAlice,
};

enum EAliceCombatAbilityInput
{
    EACAI_None,
    EACAI_Dodge,
    EACAI_Deflect,
    EACAI_ClockBomb,
    EACAI_WeaponStart,
    EACAI_VorpalBlade,
    EACAI_HobbyHorse,
    EACAI_PiperGrinder,
    EACAI_TeapotCannon,
    EACAI_WeaponEnd,
};

enum EAliceAbilityControl
{
    EAAC_Combat,
    EAAC_DoubleJump,
    EAAC_Float,
    EAAC_Shrink,
    EAAC_ClockBomb,
    EAAC_Hysteria,
    EAAC_Block,
    EAAC_Deflect,
    EAAC_Dodge,
    EAAC_Sonar,
    EAAC_Aiming,
    EAAC_Lockon,
    EAAC_Cat,
    EAAC_ShowPath,
    EAAC_VorpalBlade,
    EAAC_PepperGrinder,
    EAAC_HobbyHorse,
    EAAC_TeapotCannon,
};

enum EContextItem
{
    EC_Floating,
    EC_FiringGrinder,
    EC_FiringGrinderAlt,
    EC_VorpalCombo,
    EC_SwitchedTarget,
    EC_AimingMode,
    EC_SteamVent,
    EC_Hovering,
    EC_Sliding,
    EC_JumpPad,
    EC_Shrink,
    EC_Dodge,
    EC_Block,
    EC_LockON,
    EC_Vorpal,
    EC_CycleFloat,
    EC_VentMoving,
    EC_VentRotating,
    EC_ClockWork,
    EC_ClockWorkDetonate,
    EC_Hysteria,
};

enum ESpecialButtonInput
{
    ESBI_None,
    ESBI_ShieldBreak,
    ESBI_Clone,
};

enum EChessTrapAction
{
    ECTA_Idle,
    ECTA_Trap,
};

enum EChessMoveAction
{
    ECMA_Idle,
    ECMA_Left,
    ECMA_Right,
    ECMA_Up,
    ECMA_Down,
    ECMA_Goal,
    ECMA_Fail,
    ECMA_BlockUp,
    ECMA_BlockDown,
    ECMA_BlockLeft,
    ECMA_BlockRight,
    ECMA_EdgeUp,
    ECMA_EdgeDown,
    ECMA_EdgeLeft,
    ECMA_EdgeRight,
    ECMA_Dizzy,
};

enum EChessMoveCommand
{
    ECMC_Left,
    ECMC_Right,
    ECMC_Up,
    ECMC_Down,
};

enum EDamageStrengthType
{
    EDSTR_Weak,
    EDSTR_Light,
    EDSTR_Medium,
    EDSTR_Heavy,
    EDSTR_HeaveyWithoutKnockback,
};

enum CameraPresetStyle
{
    CPS_Int_Normal,
    CPS_Int_Shrink,
    CPS_Ext_Platform,
    CPS_Ext_Far,
    CPS_Ext_Near,
};

enum EAliceWeaponType
{
    EAWT_None,
    EAWT_VorpalBlade,
    EAWT_HobbyHorse,
    EAWT_EyeStaff,
    EAWT_TeapotCannon,
    EAWT_GiantCombat,
    EAWT_ClonePawnWeapon,
    EAWT_Clock,
    EAWT_DummyWeapon,
};

enum EKismetToggleUIType
{
    EUITYPE_Tutorial,
    EUITYPE_Inspect,
    EUITYPE_Poi,
    EUITYPE_ChapterInfo,
    EUITYPE_EnemyInfo,
    EUITYPE_Others,
};

enum EGlideType
{
    EGT_Float,
    EGT_Glide,
};

enum EPawnTypeFootStep
{
    PTF_Alice,
    PTF_Npc1,
};

enum EImpactTypeExplosion
{
    ITE_None,
    ITE_Boomshot,
};

enum EPOIForceLookType
{
    ePOIFORCELOOK_None,
    ePOIFORCELOOK_Automatic,
    ePOIFORCELOOK_PlayerInduced,
};

struct native PieceLoc
{
    var() int I;
    var() int J;
};

struct native SkeletalMeshActorLockOnInfo
{
    var SkeletalMeshActor Actor;
    var Vector UILockOnLoc;
    var Vector CollisionLockOnLoc;
    var Vector CameraLockOnLoc;
    var Rotator UILockOnRot;
    var Rotator CollisionLockOnRot;
    var Rotator CameraLockOnRot;
};

struct native BreakableActorLockOnInfo
{
    var GameBreakableActor BActor;
    var bool bIsLockable;
    var int iPriority;
    var Vector LockOffsetCamera;
    var Vector LockOffsetUI;
    var Vector vLocation;
};

struct native TargetingNPCInfo
{
    var AliceGameKynapsePawn Pawn;
    var int SocketIndex;
    var Vector LockOnSocketLocation;
    var Rotator LockOnSocketRotation;
    var Vector CollisionSocketLocation;
    var Rotator CollisionSocketRotation;
};

struct native DecalData
{
    var bool bIsValid;
    var() MaterialInterface DecalMaterial;
    var() float Width;
    var() float Height;
    var() float WidthSK;
    var() float HeightSK;
    var() float Thickness;
    var() bool bRandomizeRotation;
    var() Vector2D RandomScalingRange;
    var() float LifeSpan;
    var() Vector2D BlendRange;
    var() float RandomRadiusOffset;
    var() int WeaponLevel;
};

defaultproperties
{
}

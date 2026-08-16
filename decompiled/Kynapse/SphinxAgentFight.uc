class SphinxAgentFight extends KynapseAgent
    native
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object)
    autoexpandcategories(SphinxAgentFight);

enum EAliceWeaponType_REF
{
    EAWTR_None,
    EAWTR_VorpalBlade,
    EAWTR_HobbyHorse,
    EAWTR_EyeStaff,
    EAWTR_TeapotCannon,
    EAWTR_NpcProject,
    EAWTR_All,
};

enum SphinxMiscActionConditionType
{
    e_SMACT_IsLockedOn,
    e_SMACT_NPCNumReduceChange,
    e_SMACT_NameTrigger,
    e_SMACT_DetectLightRange,
    e_SMACT_DetectHeavyRange,
    e_SMACT_DetectLightMelee,
    e_SMACT_DetectHeavyMelee,
    e_SMACT_DetectDamage,
    e_SMACT_DetectCollisionWithPlayer,
    e_SMACT_DetectDistSmallThanHappen,
    e_SMACT_DetectDistBigThanHappen,
    e_SMACT_DetectAllNPCAttachedActorDead,
    e_SMACT_DetectNPCAttachedActorDead,
    e_SMACT_DetectNPCAttachedActorDamage,
    e_SMACT_DetectNPCLandedFromFalling,
    e_SMACT_DetectAliceEscapeGrab,
    e_SMACT_DetectPawnOccupyCurrentGotoIndex,
    e_SMACT_DetectAliceDamage,
    e_SMACT_DetectNPCAttachedActorDamagePercent,
    e_SMACT_Detect_Absoult_Height_Different_SmallThan_Happen,
    e_SMACT_Detect_Absoult_Height_Different_BigThan_Happen,
    e_SMACT_NoCondition,
};

struct native SphinxFightSwitchCondition
{
    var() const bool m_bFaceAliceOnlyInScriptedSphinxSequenceEvent;
    var() const float m_Speed;
    var() const Rotator m_RotationRate;
    var(AttackMelee) const float MConditionStateAttackDelay;
    var(AttackMelee) const array<float> NearGroup_MConditionAttackChance;
    var(AttackMelee) const bool NearGroup_UseSubConditionAction;
    var(AttackRange) const float RConditionStateAttackDelay;
    var(AttackRange) const bool FarGroup_UseDefaultMeleeAttack;
    var(AttackRange) const int FarGroup_DefaultMeleeAttackIndex;
    var(AttackRange) const bool FarGroup_SwitchBackToFarGroupAfterMeleeAttackIM;
    var(AttackRange) const array<float> FarGroup_RConditionAttackChance;
    var(AttackRange) const bool FarGroup_UseSubConditionAction;
    var(StrikBack) const array<StrikBackConditionData> StrikBackDataArray;
    var(SubCondition) const bool bRestoreMaxTriggerForSubConditions;
    var(SubCondition) const array<SphinxMiscActionData> SubConditionChance;
    var(Event) const string ConditionNameTag;
};

struct native StrikBackConditionData
{
    var() EAliceWeaponType_REF WeaponType;
    var() bool bIsShield;
    var() bool bUseSpecialAssignShieldIndex;
    var() int SpecialAssignShieldIndex1;
    var() int SpecialAssignShieldIndex2;
    var() bool bHaveStrikBackAblity;
    var() int MinComboCountActiveStrikBack;
    var() const float ComboInterval;
    var() const string StrikBackEventsNameTag;
    var const int StrikBackEventsIndex;
    var() const float ChangeActiveStrikBack;
};

struct native SphinxMiscActionData
{
    var() float MiscActionChance;
    var() int MaxTriggerTimes;
    var int MaxTriggerTimesBackUp;
    var() int MiscEventIndex;
    var() const float ParamValue1;
    var() const float ParamValue2;
    var() const string ParamStr1;
    var() EAliceWeaponType_REF ParmWeaponType;
    var name ParamStr1Fname;
    var() bool DoBreakCurrentSubConditionEvent;
    var() bool DoReturnOriginalPackage;
    var() SphinxMiscActionConditionType ConditionType;
    var() bool bAlwaysCheck;
    var bool bActived;
};

struct native SphinxMiscActionInfo
{
    var() const string MiscEventNameTag;
    var int MiscEventIndex;
};

struct native SphinxRangeAttackInfo
{
    var() const string RAttackEventNameTag;
    var int RAttackEventIndex;
};

struct native SphinxMeleeAttackInfo
{
    var() const string MAttackEventNameTag;
    var int MAttackEventIndex;
};

var(Group) const float m_NearGroupDistance;
var(Group) const float m_NearGroupSkipCheckMultiFactor;
var(Group) const float m_NearGroupDistanceOffset;
var(Group) const int m_NearGroupFormationAngle;
var(Group) const float m_FarGroupDistance;
var(Group) const float m_FarGroupDistanceOffset;
var(Group) const int m_FarGroupFormationAngle;
var(Group) const int m_NearGroupMaxPawn;
var(Group) const int m_FarGroupMaxPawn;
var(Group) const float m_ChanceSwitchToFarGroup;
var(Group) const float m_ChanceSwitchToNearGroup;
var(Group) const bool m_ChooseNearGroupFirst;
var(Swarm) const bool m_SwarmCircleActived;
var(Group) const float m_ShuffleDelay;
var(Swarm) const int m_SwarmFanAngle;
var(Swarm) const float m_SwarmSubOffset;
var(Swarm) const int m_SwarmMainCount;
var(Swarm) const int m_SwarmSubCount;
var(MeleeAttackInfo) const array<SphinxMeleeAttackInfo> m_MeleeAttackInfo;
var(RangeAttackInfo) const array<SphinxRangeAttackInfo> m_RangeAttackInfo;
var(MiscActionInfo) const array<SphinxMiscActionInfo> m_MiscActionInfo;
var(Condition) const array<SphinxFightSwitchCondition> m_ConditionArray;

defaultproperties
{
    m_NearGroupDistance=400.0
    m_NearGroupSkipCheckMultiFactor=3.0
    m_NearGroupFormationAngle=21845
    m_FarGroupDistance=1000.0
    m_FarGroupFormationAngle=21845
    m_NearGroupMaxPawn=3
    m_FarGroupMaxPawn=3
    m_ChooseNearGroupFirst=True
    m_SwarmCircleActived=True
    m_ShuffleDelay=-1.0
    m_SwarmFanAngle=30947
    m_SwarmSubOffset=100.0
    m_SwarmMainCount=3
    m_SwarmSubCount=6
    agentName="SphinxFightAgent"
    ClassName="SphinxFightAgent"
}

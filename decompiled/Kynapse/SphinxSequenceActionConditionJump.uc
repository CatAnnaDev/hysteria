class SphinxSequenceActionConditionJump extends SphinxSequenceEventBase
    native
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object);

enum SphinxConditionExpressionType
{
    e_SSET_Equal,
    e_SSET_GreaterThan,
    e_SSET_LessThan,
};

enum SphinxSequenceConditionCheckType
{
    e_SSCCT_LastSequenceHitPlayer,
    e_SSCCT_NoBlockToPlayer,
    e_SSCCT_DistPlayer,
    e_SSCCT_DistPlayer2D,
    e_SSCCT_AnglePlayer,
    e_SSCCT_SelfHpPercent,
    e_SSCCT_SelfHpAbsolute,
    e_SSCCT_SelfInPlayerCamaraView,
    e_SSCCT_PlayerHpPercent,
    e_SSCCT_CheckComponentAttach,
    e_SSCCT_CheckCurrentConditionIndex,
    e_SSCCT_NumberOfTeammatesAttacking,
    e_SSCCT_TriggerCountZero,
    e_SSCCT_CheckPreviousConditionIndex,
    e_SSCCT_DistPlayer_X,
    e_SSCCT_DistPlayer_Y,
    e_SSCCT_DistPlayer_Z,
    e_SSCCT_AliceDodgeing,
    e_SSCCT_AliceDeflecting,
    e_SSCCT_AliceJumping,
    e_SSCCT_AliceShield,
    e_SSCCT_NoWallInNPC_Direct,
    e_SSCCT_NoWallInNPC_Left,
    e_SSCCT_NoWallInNPC_Right,
    e_SSCCT_CheckNPCAttachedActorAlive,
    e_SSCCT_CheckNPCAttachedActorAwake,
    e_SSCCT_CheckAliceAtNPCLeftOrRight,
    e_SSCCT_CheckNPCAtAliceLeftOrRight,
    e_SSCCT_CheckGD_GlobeValue,
    e_SSCCT_CheckCurrentDifficult,
    e_SSCCT_CheckSelfInSideCollision,
    e_SSCCT_CheckAliceWeaponLevel,
    e_SSCCT_CheckCountOfAttachedActorAlive,
};

struct native ConditionCheckList
{
    var() SphinxSequenceConditionCheckType CheckCondition;
    var() int AdditionPassParam;
    var() SphinxConditionExpressionType ExpressionType;
    var() int CheckParam;
};

var() array<ConditionCheckList> Conditions;
var() int FailJumpIndex;

defaultproperties
{
    SequenceType="e_SphinxSequenceAC_ConditionJump"
}

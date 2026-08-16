class AliceGameAnimNode_Sequence extends AnimNodeSequence
    native
    notplaceable
    hidecategories(Object,Object,Object);

enum ESequenceRandomType
{
    ESeqRand_NoRand,
    ESeqRand_SelfRand,
    ESeqRand_PawnSyncRandSlot_0,
    ESeqRand_PawnSyncRandSlot_1,
    ESeqRand_PawnSyncRandSlot_2,
};

struct native StopMotionParams
{
    var() float RotationNoise;
    var() float TranslationNoise;
    var() float LimitedFPS;
};

var() bool bPhysicsTransitionAnimation;
var() bool bEnableStopMotion;
var() const StopMotionParams StopMotion;
var float DiffTime;
var() ESequenceRandomType RandomInitTimeType;

defaultproperties
{
    bEnableStopMotion=True
    StopMotion=(RotationNoise=0.0,TranslationNoise=0.0,LimitedFPS=24.0)
}

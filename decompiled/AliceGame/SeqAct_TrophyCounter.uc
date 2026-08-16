class SeqAct_TrophyCounter extends SequenceAction
    native
    notplaceable
    hidecategories(Object);

var() bool ChallengeRoomCounter;
var() bool InteractiveObjectCounter;
var() bool UseGoldenPathCount;
var() bool Chapter1Completed;
var() bool Chapter2Completed;
var() bool Chapter3Completed;
var() bool Chapter4Completed;
var() bool Chapter5Completed;
var() bool Chapter6Completed;

defaultproperties
{
    ObjName="Trophy Counter"
    ObjCategory="Alice"
}

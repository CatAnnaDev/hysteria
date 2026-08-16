class SphinxSequenceEventPreAttackDist extends SphinxSequenceEventBase
    native
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object);

var() const float Dist;
var() const bool MoveIntoCameraDir;
var() const bool bStopWhenMeetNPCBlock;
var() const bool bFacingAlice;
var() const float Speed;
var() const float DefaultUpdateTime;
var() const float UpdateTolerateRadius;

defaultproperties
{
    Dist=4.0
    bFacingAlice=True
    Speed=4.0
    DefaultUpdateTime=1.0
    UpdateTolerateRadius=1.0
    SequenceType="e_SphinxSequenceET_PreAttackDist"
}

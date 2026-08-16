class SphinxSequenceEventSetNPCFightAgentParam extends SphinxSequenceEventBase
    native
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object);

var() float m_NearGroupDistance;
var() float m_NearGroupDistanceOffset;
var() float m_FarGroupDistance;
var() float m_FarGroupDistanceOffset;
var() bool m_ChooseNearGroupFirst;

defaultproperties
{
    m_NearGroupDistance=400.0
    m_FarGroupDistance=1000.0
    m_ChooseNearGroupFirst=True
    SequenceType="e_SphinxSequenceET_SetNPCFightAgentParam"
}

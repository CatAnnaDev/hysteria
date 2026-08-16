class SphinxAgentWayPath extends KynapseAgent
    native
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object)
    autoexpandcategories(SphinxAgentWayPath);

var() const float m_Speed;
var() const Rotator m_RotationRate;
var() const bool m_bAvoidsPawn;
var() const bool m_bPushPawn;
var() const bool m_bStopsWithPawn;
var() const float m_PathEndTime;

defaultproperties
{
    m_Speed=3.0
    m_RotationRate=(Pitch=0,Yaw=65535,Roll=0)
    m_bAvoidsPawn=True
    m_PathEndTime=10.0
    agentName="SphinxWayPathAgent"
    ClassName="SphinxWayPathAgent"
}

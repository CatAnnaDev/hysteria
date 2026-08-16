class SphinxAgentGoto extends KynapseAgent
    native
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object)
    autoexpandcategories(SphinxAgentGoto);

var() const float Speed;
var() const Rotator m_DefaultRotatorRate;
var() const float m_SpeedReduceFactor;
var() const float m_ReachedFactor;

defaultproperties
{
    Speed=4.0
    m_DefaultRotatorRate=(Pitch=0,Yaw=65535,Roll=0)
    m_SpeedReduceFactor=3.0
    m_ReachedFactor=0.8
    agentName="SphinxGotoAgent"
    ClassName="SphinxGotoAgent"
}

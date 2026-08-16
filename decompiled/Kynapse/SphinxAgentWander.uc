class SphinxAgentWander extends KynapseAgent
    native
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object)
    autoexpandcategories(SphinxAgentWander);

var() const SphinxTraversalDefinitionWander HierarchicalWanderTraversal;
var() const float m_Speed;
var() const Rotator m_RotationRate;
var() const bool m_bAvoidsPlayer;
var() const bool m_bAvoidsNPCs;
var() const float m_WanderTime;
var() const float m_IdleChance;
var() const float m_IdleTime;

defaultproperties
{
    m_Speed=4.0
    m_RotationRate=(Pitch=0,Yaw=65535,Roll=0)
    m_bAvoidsPlayer=True
    m_bAvoidsNPCs=True
    m_WanderTime=60.0
    m_IdleChance=100.0
    m_IdleTime=10.0
    agentName="SphinxWanderAgent"
    ClassName="SphinxWanderAgent"
}

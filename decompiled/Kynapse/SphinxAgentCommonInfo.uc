class SphinxAgentCommonInfo extends KynapseAgent
    native
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object)
    autoexpandcategories(SphinxAgentCommonInfo);

defaultproperties
{
    time_aperiodicTasksList(0)=(taskName="SphinxCommonInfoAgent::ComputeCommonInformation",Priority=1.0,tpf=1.0,maxCall=1)
    time_aperiodicTasksList(1)=(taskName="SphinxCommonInfoAgent::ComputeSeeEnemy",Priority=1.0,tpf=1.0,maxCall=1)
    time_aperiodicTasksList(2)=(taskName="SphinxCommonInfoAgent::ComputeIsCollisionWithEnemy",Priority=1.0,tpf=1.0,maxCall=1)
    time_aperiodicTasksList(3)=(taskName="SphinxCommonInfoAgent::ComputeInterestingActor",Priority=1.0,tpf=1.0,maxCall=1)
    agentName="SphinxCommonInfoAgent"
    ClassName="SphinxCommonInfoAgent"
}

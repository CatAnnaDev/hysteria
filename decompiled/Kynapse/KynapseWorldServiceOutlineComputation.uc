class KynapseWorldServiceOutlineComputation extends KynapseWorldService
    native
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object);

defaultproperties
{
    time_aperiodicTasksList(0)=(taskName="COutlineComputationService::ComputeOutline",Priority=1.0,tpf=0.25,maxCall=100)
    serviceName="OutlineComputationService"
    ClassName="COutlineComputationService"
}

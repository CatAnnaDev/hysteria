class KynapseWorldServiceLpfManager extends KynapseWorldService
    native
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object);

enum ELpf3dMode
{
    LPF2D,
    LPF3D,
};

struct native LpfContext
{
    var() const string Name;
    var() const array<KynapseAiMeshLayerDefinition> Layers;
    var() const KynapseTag DataTag;
    var() const float edgeRadius;
    var() const float minDeltaHeight;
    var() const float inhibitionPeriod;
    var() const export editinline KynapseLpfPreMerger lpfPreMerger;
    var() const ELpf3dMode lpf3dMode;
};

var() const array<LpfContext> contexts;

defaultproperties
{
    time_aperiodicTasksList(0)=(taskName="LpfManager::PreAggregateComputation",Priority=1.0,tpf=340282346638528859811704183484516925440.0,maxCall=2147483647)
    time_aperiodicTasksList(1)=(taskName="LpfManager::AreaComputation",Priority=1.0,tpf=340282346638528859811704183484516925440.0,maxCall=2147483647)
    serviceName="LpfManager"
    ClassName="Fpd::CLpfManager"
}

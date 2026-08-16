class KynapseObstacleLpf extends KActorSpawnable
    notplaceable
    config(Game);

var() const export editinline KynapseHandle KynapseHandle;

defaultproperties
{
    KynapseHandle="Default__KynapseObstacleLpf.ObstacleLpfKynapseHandle"
    StaticMeshComponent="Default__KynapseObstacleLpf.StaticMeshComponent0"
    LightEnvironment="Default__KynapseObstacleLpf.MyLightEnvironment"
    Components(0)="Default__KynapseObstacleLpf.MyLightEnvironment"
    Components(1)="Default__KynapseObstacleLpf.StaticMeshComponent0"
    Components(2)="Default__KynapseObstacleLpf.ObstacleLpfKynapseHandle"
    CollisionComponent="Default__KynapseObstacleLpf.StaticMeshComponent0"
}

class KynapseKAsset extends KAsset
    placeable
    config(Game)
    hidecategories(Navigation);

var() const export editinline KynapseHandle KynapseHandle;

defaultproperties
{
    KynapseHandle="Default__KynapseKAsset.DemoPawnKynapseHandle"
    SkeletalMeshComponent="Default__KynapseKAsset.KAssetSkelMeshComponent"
    Components(0)="Default__KynapseKAsset.MyLightEnvironment"
    Components(1)="Default__KynapseKAsset.KAssetSkelMeshComponent"
    Components(2)="Default__KynapseKAsset.DemoPawnKynapseHandle"
    CollisionComponent="Default__KynapseKAsset.KAssetSkelMeshComponent"
}

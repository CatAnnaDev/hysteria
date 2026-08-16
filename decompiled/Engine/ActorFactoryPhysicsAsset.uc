class ActorFactoryPhysicsAsset extends ActorFactory
    native
    notplaceable
    editinlinenew
    collapsecategories
    config(Editor)
    hidecategories(Object,Object);

var() PhysicsAsset PhysicsAsset;
var() SkeletalMesh SkeletalMesh;
var() bool bStartAwake;
var() bool bDamageAppliesImpulse;
var() bool bNotifyRigidBodyCollision;
var() bool bUseCompartment;
var() bool bCastDynamicShadow;
var() Vector InitialVelocity;
var() Vector DrawScale3D;

defaultproperties
{
    bStartAwake=True
    bDamageAppliesImpulse=True
    bCastDynamicShadow=True
    DrawScale3D=(X=1.0,Y=1.0,Z=1.0)
    GameplayActorClass="KAssetSpawnable"
    MenuName="Add PhysicsAsset"
    NewActorClass="KAsset"
}

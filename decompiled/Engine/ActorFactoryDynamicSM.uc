class ActorFactoryDynamicSM extends ActorFactory
    abstract
    native
    notplaceable
    editinlinenew
    collapsecategories
    config(Editor)
    hidecategories(Object);

var() StaticMesh StaticMesh;
var() Vector DrawScale3D;
var() bool bNoEncroachCheck;
var() bool bNotifyRigidBodyCollision;
var() bool bBlockRigidBody;
var() bool bUseCompartment;
var() bool bCastDynamicShadow;
var() ECollisionType CollisionType;

defaultproperties
{
    DrawScale3D=(X=1.0,Y=1.0,Z=1.0)
    bCastDynamicShadow=True
    CollisionType="COLLIDE_NoCollision"
}

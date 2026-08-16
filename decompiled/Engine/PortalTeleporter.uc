class PortalTeleporter extends SceneCapturePortalActor
    abstract
    native
    notplaceable
    hidecategories(Navigation);

var() PortalTeleporter SisterPortal;
var() int TextureResolutionX;
var() int TextureResolutionY;
var PortalMarker MyMarker;
var() bool bMovablePortal;
var bool bAlwaysTeleportNonPawns;
var bool bCanTeleportVehicles;

simulated function bool StopsProjectile(Projectile P)
{
    return !TransformActor(P);
}

native final function TextureRenderTarget2D CreatePortalTexture()
{
}

native final function Vector TransformHitLocation(Vector HitLocation)
{
    HitLocation;
}

native final function Vector TransformVectorDir(Vector V)
{
    V;
}

native final function bool TransformActor(Actor A)
{
    A;
}

defaultproperties
{
    TextureResolutionX=256
    TextureResolutionY=256
    bAlwaysTeleportNonPawns=True
    StaticMesh="Default__PortalTeleporter.StaticMeshComponent2"
    SceneCapture="Default__PortalTeleporter.SceneCapturePortalComponent0"
    bWorldGeometry=True
    bMovable=False
    bCollideActors=True
    bBlockActors=True
    Components(0)="Default__PortalTeleporter.SceneCapturePortalComponent0"
    Components(1)="Default__PortalTeleporter.StaticMeshComponent1"
    Components(2)="Default__PortalTeleporter.StaticMeshComponent2"
    CollisionComponent="Default__PortalTeleporter.StaticMeshComponent2"
}

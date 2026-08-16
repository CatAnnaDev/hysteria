class GamePawn extends Pawn
    abstract
    native
    nativereplication
    notplaceable
    config(Game)
    hidecategories(Navigation);

var transient repretry bool bLastHitWasHeadShot;
var bool bRespondToExplosions;

replication
{
    if (Role == 3)
        bLastHitWasHeadShot;
}

event SphinxNotifyDestory()
{
}

event PlayCustomParticleOnSocket(ParticleSystem PS, name Socket)
{
    local ParticleSystemComponent CustomParticleSC;
    local Vector SocketLoc;
    local Rotator SocketRotator;
    
    if (Mesh != none)
    {
        Mesh.GetSocketWorldLocationAndRotation(Socket, SocketLoc, SocketRotator);
        CustomParticleSC = WorldInfo.MyEmitterPool.SpawnEmitter(PS, SocketLoc, SocketRotator, self);
        CustomParticleSC.SetActive(true);
    }
}

simulated function ReattachMeshWithoutBeingSeen()
{
    if (LastRenderTime > WorldInfo.TimeSeconds - 1.0)
    {
        SetTimer(0.5 + FRand() * 0.5, false, 'ReattachMeshWithoutBeingSeen');
    }
    else
    {
        ReattachMesh();
    }
}

simulated function ReattachMesh()
{
    ClearTimer('ReattachMeshWithoutBeingSeen');
    ReattachComponent(Mesh);
}

simulated event UpdateShadowSettings(bool bInWantShadow)
{
    local bool bNewCastShadow, bNewCastDynamicShadow;
    
    if (Mesh != none)
    {
        bNewCastShadow = default.Mesh.CastShadow && bInWantShadow;
        bNewCastDynamicShadow = default.Mesh.bCastDynamicShadow && bInWantShadow;
        if (bNewCastShadow != Mesh.CastShadow || bNewCastDynamicShadow != Mesh.bCastDynamicShadow)
        {
            Mesh.CastShadow = bNewCastShadow;
            Mesh.bCastDynamicShadow = bNewCastDynamicShadow;
            if (WorldInfo.bAggressiveLOD == true)
            {
                ReattachMesh();
            }
            else
            {
                ReattachMeshWithoutBeingSeen();
            }
        }
    }
}

event Cringe(optional float Duration = -1.0)
{
}

reliable server function ServerKnockdown(optional Vector RBLinearVelocity, optional Vector RBAngularVelocity, optional Vector RadialOrigin, optional float RadialRadius, optional float RadialStrength, optional Vector PointImpulse, optional Vector PointImpulsePosition, optional name PointImpulseBoneName)
{
}

simulated function GetTargetFrictionCylinder(out float CylinderRadius, out float CylinderHeight)
{
    GetBoundingCylinder(CylinderRadius, CylinderHeight);
}

native function StopAllConfigAnim(float BlendOutTime, optional bool bForceStop = false, optional bool bForceAnimNotify = false, optional bool bForceAnimEnd = false)
{
    BlendOutTime;
    bForceStop;
    bForceAnimNotify;
    bForceAnimEnd;
}

defaultproperties
{
    CylinderComponent="Default__GamePawn.CollisionCylinder"
    bCanBeAdheredTo=True
    bCanBeFrictionedTo=True
    bMoveIgnoresDestruction=True
    Components(0)="Default__GamePawn.Sprite"
    Components(1)="Default__GamePawn.CollisionCylinder"
    Components(2)="Default__GamePawn.Arrow"
    CollisionComponent="Default__GamePawn.CollisionCylinder"
}

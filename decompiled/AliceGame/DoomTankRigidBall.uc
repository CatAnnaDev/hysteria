class DoomTankRigidBall extends ProjectileRigidBallBase
    notplaceable;

defaultproperties
{
    ExplodeParticle="FX_NPC_DoomTank.Projectile.P_Projectile_SelfBlow"
    ExplodeSound="SFX_Doom_Tank.sfx_npc_tank_bomb01_Cue"
    StaticMeshComponent="Default__DoomTankRigidBall.StaticMeshComponent0"
    LightEnvironment="Default__DoomTankRigidBall.MyLightEnvironment"
    Components(0)="Default__DoomTankRigidBall.MyLightEnvironment"
    Components(1)="Default__DoomTankRigidBall.StaticMeshComponent0"
    CollisionComponent="Default__DoomTankRigidBall.StaticMeshComponent0"
}

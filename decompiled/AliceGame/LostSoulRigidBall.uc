class LostSoulRigidBall extends ProjectileRigidBallBase
    notplaceable;

function bool ShouldTriggerCollisionEvent(Actor CollisionCauser)
{
    if (CollisionCauser != none)
    {
        return !CollisionCauser.IsA('AliceGameKynapsePawn') || AliceGameKynapsePawn(CollisionCauser).MagicAcheivmentIdentify != 3;
    }
    else
    {
        return ShouldTriggerCollisionEvent(CollisionCauser);
    }
}

defaultproperties
{
    ExplodeParticle="FX_NPC_LostSoul.P_NPC_LostSoul_ExplosionAtk"
    ExplodeSound="SFX_LostSoul.sfx_lostsouls_bomb_explode01_Cue"
    StaticMeshComponent="Default__LostSoulRigidBall.StaticMeshComponent0"
    LightEnvironment="Default__LostSoulRigidBall.MyLightEnvironment"
    Components(0)="Default__LostSoulRigidBall.MyLightEnvironment"
    Components(1)="Default__LostSoulRigidBall.StaticMeshComponent0"
    CollisionType="COLLIDE_BlockAll"
    CollisionComponent="Default__LostSoulRigidBall.StaticMeshComponent0"
}

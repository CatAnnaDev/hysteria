class AliceTurretMineExplode extends Actor
    notplaceable
    hidecategories(Navigation);

var float ExplosionRadius;
var Turret2DManager MyOwner;
var array<Actor> ActorList;
var Alice2DTurretMine MyTurretMine;

event Tick(float DeltaTime)
{
    local Actor Other;
    local Alice2DTurret turret;
    
    foreach VisibleActors(class'Engine.Actor', Other, ExplosionRadius, Location)
    {
        if (!MyOwner.CheckActorType(Other))
        {
            break;
        }
        if (BounceVolume(Other) != none || Alice2DTurret(Other) != none)
        {
            break;
        }
        if (ActorList.Find(Other) == -1)
        {
            MyOwner.TriggerEventClass(class'Engine.SeqEvent_TakeDamage', Other, -1);
            ActorList.AddItem(Other);
        }
    }
    foreach DynamicActors(class'Alice2DTurret', turret)
    {
        if (VSize(turret.Location - Location) > ExplosionRadius)
        {
            break;
        }
        if (ActorList.Find(turret) == -1 && turret != MyTurretMine && turret.bCanBeDestroyed)
        {
            MyOwner.TriggerEventClass(class'Engine.SeqEvent_TakeDamage', turret, -1);
            ActorList.AddItem(turret);
            turret.bKilled = true;
        }
    }
}

defaultproperties
{
}

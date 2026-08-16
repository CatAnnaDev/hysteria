class GameCrowdReplicationActor extends Actor
    native
    notplaceable
    hidecategories(Navigation);

var repnotify SeqAct_GameCrowdSpawner Spawner;
var repnotify bool bSpawningActive;
var repnotify int DestroyAllCount;

replication
{
    if (Role == 3)
        Spawner, bSpawningActive, DestroyAllCount;
}

simulated event ReplicatedEvent(name VarName)
{
    if (VarName == 'Spawner' || VarName == 'bSpawningActive')
    {
        if (Spawner != none)
        {
            Spawner.bSpawningActive = bSpawningActive;
            if (bSpawningActive)
            {
                Spawner.CacheSpawnerVars();
            }
        }
    }
    else if (VarName == 'DestroyAllCount')
    {
        Spawner.KillAgents();
        Spawner.bSpawningActive = false;
    }
    else
    {
        ReplicatedEvent(VarName);
    }
}

auto state ReceivingReplication
{
    simulated event Tick(float DeltaTime)
    {
        Tick(DeltaTime);
        if (Role == 3)
        {
            GotoState('None');
        }
        else if (Spawner != none && Spawner.bSpawningActive)
        {
            Spawner.UpdateSpawning(DeltaTime);
        }
    }
    
    Stop;
}

defaultproperties
{
    bAlwaysRelevant=True
    bReplicateMovement=False
    bSkipActorPropertyReplication=True
    bOnlyDirtyReplication=True
    RemoteRole="ROLE_SimulatedProxy"
    CollisionType="COLLIDE_CustomDefault"
    TickGroup="TG_DuringAsyncWork"
    NetUpdateFrequency=1.0
    NetPriority=2.7
}

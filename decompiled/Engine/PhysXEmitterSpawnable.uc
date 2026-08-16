class PhysXEmitterSpawnable extends Emitter
    native
    notplaceable
    hidecategories(Navigation);

struct native RBVolumeFill
{
    var array<IndexedRBState> RBStates;
    var array<Vector> Positions;
};

struct native IndexedRBState
{
    var Vector CenterOfMass;
    var Vector LinearVelocity;
    var Vector AngularVelocity;
    var int Index;
};

var native Pointer VolumeFill;
var repnotify ParticleSystem ParticleTemplate;

replication
{
    if (bNetInitial)
        ParticleTemplate;
}

simulated event ReplicatedEvent(name VarName)
{
    if (VarName == 'ParticleTemplate')
    {
        SetTemplate(ParticleTemplate, bDestroyOnSystemFinish);
        ParticleSystemComponent.ActivateSystem();
        if (ParticleTemplate == none && bDestroyOnSystemFinish)
        {
            Destroy();
        }
    }
    else
    {
        ReplicatedEvent(VarName);
    }
}

simulated event SetTemplate(ParticleSystem NewTemplate, optional bool bDestroyOnFinish)
{
    SetTemplate(NewTemplate, bDestroyOnFinish);
    ParticleTemplate = NewTemplate;
}

event Destroyed()
{
    Destroyed();
    Term();
}

native function Term()
{
}

defaultproperties
{
    ParticleSystemComponent="Default__PhysXEmitterSpawnable.ParticleSystemComponent0"
    bDestroyOnSystemFinish=True
    bNoDelete=False
    bNetTemporary=True
    Components(0)="Default__PhysXEmitterSpawnable.Sprite"
    Components(1)="Default__PhysXEmitterSpawnable.ParticleSystemComponent0"
    Components(2)="Default__PhysXEmitterSpawnable.ArrowComponent0"
}

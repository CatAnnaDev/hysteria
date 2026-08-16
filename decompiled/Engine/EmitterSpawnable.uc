class EmitterSpawnable extends Emitter
    notplaceable
    hidecategories(Navigation);

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

defaultproperties
{
    ParticleSystemComponent="Default__EmitterSpawnable.ParticleSystemComponent0"
    bDestroyOnSystemFinish=True
    bFirstTick=True
    bNoDelete=False
    bNetTemporary=True
    Components(0)="Default__EmitterSpawnable.Sprite"
    Components(1)="Default__EmitterSpawnable.ParticleSystemComponent0"
    Components(2)="Default__EmitterSpawnable.ArrowComponent0"
}

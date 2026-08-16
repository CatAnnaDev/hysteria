class ClockBombContextActor extends ContextActor
    placeable
    hidecategories(Navigation);

function GetBlendRotationDest()
{
    local Vector vOffset;
    
    if (Alice != none)
    {
        vOffset = Location - Alice.Location;
        vOffset = Normal(vOffset);
        BlendRotationDest = rotator(vOffset);
    }
    else
    {
        BlendRotationDest = Rotation;
    }
}

event StartPlayAnimation()
{
    local AnimNodeSequence SeqNode;
    
    if (AnimNameForAlice != 'None' && Alice != none)
    {
        ClearBlendingFlags();
        APC.IgnoreMoveInput(false);
        Alice.DoRootTranslationForContext = bDoRootTranslationForAlice;
        Alice.DoRootRotationForContext = bDoRootRotationForAlice;
        Alice.AnimSeqForContext = AnimNameForAlice;
        Alice.DoSpecialMove(55, true);
        bDoAliceAnim = true;
        AlicePlayerController(Alice.Controller).CloneAlice('ClockBomb3', 10.0);
    }
    if (SkeletalMeshComponent != none)
    {
        SeqNode = AnimNodeSequence(SkeletalMeshComponent.Animations);
        SeqNode.SetAnim(AnimNameForContextActor);
        SeqNode.bCauseActorAnimEnd = true;
        SeqNode.PlayAnim(false, SeqNode.Rate, 0.0);
        bDoActorAnim = true;
    }
    PlayParticle(Particle_Activating, false);
    PlayAmbientSound(Sound_Activating);
    if (Alice != none)
    {
        Alice.Velocity = vect(0.0, 0.0, 0.0);
    }
    if (!bDoAliceAnim && !bDoActorAnim)
    {
        EndContextAction();
    }
}

defaultproperties
{
    AnimNameForAlice="AliceW_Put_Bomb"
    MaxTriggerTimers=-1
    SkeletalMeshComponent="Default__ClockBombContextActor.SkeletalMeshComponent0"
    LightEnvironment="Default__ClockBombContextActor.MyLightEnvironment"
    CylinderComponent="Default__ClockBombContextActor.CollisionCylinder"
    bNoDelete=False
    Components(0)="Default__ClockBombContextActor.Sprite"
    Components(1)="Default__ClockBombContextActor.CollisionCylinder"
    Components(2)="Default__ClockBombContextActor.MyLightEnvironment"
    Components(3)="Default__ClockBombContextActor.SkeletalMeshComponent0"
    CollisionComponent="Default__ClockBombContextActor.CollisionCylinder"
    SupportedEvents(0)="Engine.SeqEvent_Touch"
    SupportedEvents(1)="Engine.SeqEvent_Destroyed"
    SupportedEvents(2)="Engine.SeqEvent_TakeDamage"
    SupportedEvents(3)="Engine.SeqEvent_HitWall"
    SupportedEvents(4)="Engine.SeqEvent_Used"
    SupportedEvents(5)="SeqEvent_ContextActionActivated"
    SupportedEvents(6)="SeqEvent_ContextActionActivated"
}

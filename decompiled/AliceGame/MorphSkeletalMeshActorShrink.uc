class MorphSkeletalMeshActorShrink extends MorphSkeletalMeshActor
    placeable
    hidecategories(Navigation);

var bool bActived;

simulated function Tick(float DeltaTime)
{
    InitAPC();
    if (AlicePC != none)
    {
        DisFromAlice = VSize(AlicePC.Pawn.Location - Location);
        bIsInDis = DisFromAlice <= TriggerDistance;
        if (bIsInDis && AlicePawn(AlicePC.Pawn).bShrinkingModeActive)
        {
            if (!bActived)
            {
                bActived = true;
                TriggerEventClass(class'SeqEvent_ShrinkMorphActived', self);
            }
            DoMorph(true);
        }
        else if (!bIsInDis || !AlicePawn(AlicePC.Pawn).bShrinkingModeActive)
        {
            if (bActived)
            {
                bActived = false;
                TriggerEventClass(class'SeqEvent_ShrinkMorphDeactived', self);
            }
            DoMorph(false);
        }
        bLastTickIsInDis = bIsInDis;
    }
}

defaultproperties
{
    SkeletalMeshComponent="Default__MorphSkeletalMeshActorShrink.SkeletalMeshComponent1"
    LightEnvironment="Default__MorphSkeletalMeshActorShrink.MyLightEnvironment"
    FacialAudioComp="Default__MorphSkeletalMeshActorShrink.FaceAudioComponent"
    Components(0)="Default__MorphSkeletalMeshActorShrink.MyLightEnvironment"
    Components(1)="Default__MorphSkeletalMeshActorShrink.FaceAudioComponent"
    Components(2)="Default__MorphSkeletalMeshActorShrink.SkeletalMeshComponent1"
    CollisionComponent="Default__MorphSkeletalMeshActorShrink.SkeletalMeshComponent1"
    SupportedEvents(0)="Engine.SeqEvent_Touch"
    SupportedEvents(1)="Engine.SeqEvent_Destroyed"
    SupportedEvents(2)="Engine.SeqEvent_TakeDamage"
    SupportedEvents(3)="Engine.SeqEvent_HitWall"
    SupportedEvents(4)="SeqEvent_ShrinkMorphActived"
    SupportedEvents(5)="SeqEvent_ShrinkMorphDeactived"
}

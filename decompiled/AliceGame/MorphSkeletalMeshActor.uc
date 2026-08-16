class MorphSkeletalMeshActor extends SkeletalMeshActor
    native
    placeable
    hidecategories(Navigation);

var AlicePlayerController AlicePC;
var float DisFromAlice;
var float NewWeight;
var() float TriggerDistance;
var() float MorphOnSpeed;
var() float MorphOffSpeed;
var() SoundCue FlowerOpenCue;
var bool bLastTickIsInDis;
var bool bIsInDis;
var bool bDuplicated;

function InitAPC()
{
    local AlicePlayerController PC;
    
    if (AlicePC == none)
    {
        foreach LocalPlayerControllers(class'AlicePlayerController', PC)
        {
            AlicePC = PC;
        }
    }
}

native function InitDuplicatedMaterial()
{
}

function DoMorph(bool TurnOn)
{
    local MorphNodeWeight WeightNode;
    
    InitDuplicatedMaterial();
    if (TurnOn)
    {
        if (NewWeight <= 0.0)
        {
            PlaySound(FlowerOpenCue);
        }
        if (NewWeight < 1.0)
        {
            NewWeight += MorphOnSpeed;
        }
        else
        {
            return;
        }
    }
    else if (NewWeight > 0.0)
    {
        NewWeight -= MorphOffSpeed;
    }
    else
    {
        return;
    }
    NewWeight = FClamp(NewWeight, 0.0, 1.0);
    WeightNode = MorphNodeWeight(SkeletalMeshComponent.FindMorphNode('MorphNodeWeight'));
    if (WeightNode != none)
    {
        WeightNode.SetNodeWeight(NewWeight);
    }
}

simulated function Tick(float DeltaTime)
{
    InitAPC();
    if (AlicePC != none)
    {
        DisFromAlice = VSize(AlicePC.Pawn.Location - Location);
        bIsInDis = DisFromAlice <= TriggerDistance;
        if (bIsInDis)
        {
            DoMorph(true);
        }
        else if (!bIsInDis)
        {
            DoMorph(false);
        }
        bLastTickIsInDis = bIsInDis;
    }
}

defaultproperties
{
    TriggerDistance=500.0
    MorphOnSpeed=0.05
    MorphOffSpeed=0.05
    SkeletalMeshComponent="Default__MorphSkeletalMeshActor.SkeletalMeshComponent1"
    LightEnvironment="Default__MorphSkeletalMeshActor.MyLightEnvironment"
    FacialAudioComp="Default__MorphSkeletalMeshActor.FaceAudioComponent"
    Components(0)="Default__MorphSkeletalMeshActor.MyLightEnvironment"
    Components(1)="Default__MorphSkeletalMeshActor.FaceAudioComponent"
    Components(2)="Default__MorphSkeletalMeshActor.SkeletalMeshComponent1"
    CollisionComponent="Default__MorphSkeletalMeshActor.SkeletalMeshComponent1"
}

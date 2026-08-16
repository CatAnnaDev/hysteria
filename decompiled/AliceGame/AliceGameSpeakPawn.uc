class AliceGameSpeakPawn extends AliceGamePawn
    native
    placeable
    config(Game)
    hidecategories(Navigation);

event PostBeginPlay()
{
    PostBeginPlay();
    CacheAnimNodes();
}

simulated function CacheAnimNodes()
{
    local AliceGameAnimNode_BlendBase Node;
    local int I;
    
    AnimTreeRootNode = AnimTree(Mesh.Animations);
    for (I = 0; I < AnimBlendNodes.Length; I++)
    {
        AnimBlendNodes[I] = none;
    }
    foreach Mesh.AllAnimNodes(class'AliceGameAnimNode_BlendBase', Node)
    {
        switch (Node.NodeName)
        {
            case 'Slot_FullBody_Main':
                AnimBlendNodes[0] = Node;
                continue;
            case 'Slot_HalfBody_Upper_Main':
                AnimBlendNodes[1] = Node;
                continue;
            case 'PerBone_BlendUpperLower_Main':
                AnimBlendNodes[2] = Node;
                continue;
            default:
                continue;
        }
    }
}

defaultproperties
{
    MeshTranslationNudgeOffset=3.0
    Mesh="Default__AliceGameSpeakPawn.SpeakPawnSkeletalMeshComponent"
    CylinderComponent="Default__AliceGameSpeakPawn.CollisionCylinder"
    FacialAudioComp="Default__AliceGameSpeakPawn.FaceAudioComponent"
    Components(0)="Default__AliceGameSpeakPawn.CollisionCylinder"
    Components(1)="Default__AliceGameSpeakPawn.Arrow"
    Components(2)="Default__AliceGameSpeakPawn.FaceAudioComponent"
    Components(3)="Default__AliceGameSpeakPawn.SpeakPawnSkeletalMeshComponent"
    CollisionType="COLLIDE_CustomDefault"
    CollisionComponent="Default__AliceGameSpeakPawn.CollisionCylinder"
}

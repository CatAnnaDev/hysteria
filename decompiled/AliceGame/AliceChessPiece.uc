class AliceChessPiece extends SkeletalMeshActor
    abstract
    native
    placeable
    hidecategories(Navigation);

var EChessMoveAction MoveAction;

event CancelDizzy()
{
}

event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
    MoveAction = 0;
}

defaultproperties
{
    SkeletalMeshComponent="Default__AliceChessPiece.SkeletalMeshComponent0"
    LightEnvironment="Default__AliceChessPiece.MyLightEnvironment"
    FacialAudioComp="Default__AliceChessPiece.FaceAudioComponent"
    Components(0)="Default__AliceChessPiece.MyLightEnvironment"
    Components(1)="Default__AliceChessPiece.SkeletalMeshComponent0"
    Components(2)="Default__AliceChessPiece.FaceAudioComponent"
    CollisionComponent="Default__AliceChessPiece.SkeletalMeshComponent0"
}

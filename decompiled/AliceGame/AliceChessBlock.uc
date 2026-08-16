class AliceChessBlock extends InterpActor
    placeable
    hidecategories(Navigation);

var() int I;
var() int J;

defaultproperties
{
    I=1
    J=1
    StaticMeshComponent="Default__AliceChessBlock.StaticMeshComponent0"
    LightEnvironment="Default__AliceChessBlock.MyLightEnvironment"
    Components(0)="Default__AliceChessBlock.MyLightEnvironment"
    Components(1)="Default__AliceChessBlock.StaticMeshComponent0"
    CollisionComponent="Default__AliceChessBlock.StaticMeshComponent0"
}

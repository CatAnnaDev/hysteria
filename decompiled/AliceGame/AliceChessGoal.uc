class AliceChessGoal extends InterpActor
    placeable
    hidecategories(Navigation);

var() int I;
var() int J;

defaultproperties
{
    I=2
    J=2
    StaticMeshComponent="Default__AliceChessGoal.StaticMeshComponent0"
    LightEnvironment="Default__AliceChessGoal.MyLightEnvironment"
    Components(0)="Default__AliceChessGoal.MyLightEnvironment"
    Components(1)="Default__AliceChessGoal.StaticMeshComponent0"
    CollisionComponent="Default__AliceChessGoal.StaticMeshComponent0"
}

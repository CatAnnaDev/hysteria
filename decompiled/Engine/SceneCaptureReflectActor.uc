class SceneCaptureReflectActor extends SceneCaptureActor
    native
    placeable
    hidecategories(Navigation);

var() const export editinline StaticMeshComponent StaticMesh;
var transient MaterialInstanceConstant ReflectMaterialInst;

defaultproperties
{
    StaticMesh="Default__SceneCaptureReflectActor.StaticMeshComponent0"
    SceneCapture="Default__SceneCaptureReflectActor.SceneCaptureReflectComponent0"
    Components(0)="Default__SceneCaptureReflectActor.Sprite"
    Components(1)="Default__SceneCaptureReflectActor.SceneCaptureReflectComponent0"
    Components(2)="Default__SceneCaptureReflectActor.StaticMeshComponent0"
    Rotation=(Pitch=16384,Yaw=0,Roll=0)
}

class AssetActor extends SkeletalMeshActor
    placeable
    hidecategories(Navigation);

var Camera PlayerCamera;
var Rotator Rot;

event Tick(float DeltaTime)
{
    local Vector pos;
    
    if (PlayerCamera != none)
    {
        Rot.Yaw += 400;
        if (Rot.Yaw >= 65536)
        {
            Rot.Yaw = 0;
        }
        pos = PlayerCamera.CameraCache.POV.Location + vector(PlayerCamera.CameraCache.POV.Rotation) * float(300);
        pos.Y -= float(50);
        pos.Z -= float(90);
        SetLocation(pos);
        SetRotation(Rot);
    }
}

defaultproperties
{
    SkeletalMeshComponent="Default__AssetActor.SkeletalMeshComponent0"
    LightEnvironment="Default__AssetActor.MyLightEnvironment"
    FacialAudioComp="Default__AssetActor.FaceAudioComponent"
    bNoDelete=False
    bAlwaysTick=True
    Components(0)="Default__AssetActor.MyLightEnvironment"
    Components(1)="Default__AssetActor.SkeletalMeshComponent0"
    Components(2)="Default__AssetActor.FaceAudioComponent"
    TickGroup="TG_PostAsyncWork"
    CollisionComponent="Default__AssetActor.SkeletalMeshComponent0"
}

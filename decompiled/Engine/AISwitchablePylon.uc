class AISwitchablePylon extends Pylon
    native
    placeable
    hidecategories(Navigation,Lighting,LightColor,Force,Lighting,LightColor,Force);

var() bool bOpen;

event bool IsEnabled()
{
    return bOpen;
}

event SetEnabled(bool bEnabled)
{
    bOpen = bEnabled;
    bForceObstacleMeshCollision = !bOpen;
}

function PostBeginPlay()
{
    PostBeginPlay();
    SetEnabled(bOpen);
}

defaultproperties
{
    PylonRadiusPreview="Default__AISwitchablePylon.DrawPylonRadius0"
    bNeedsCostCheck=True
    RenderingComp="Default__AISwitchablePylon.NavMeshRenderer"
    BrokenSprite="Default__AISwitchablePylon.Sprite3"
    CylinderComponent="Default__AISwitchablePylon.CollisionCylinder"
    GoodSprite="Default__AISwitchablePylon.Sprite"
    BadSprite="Default__AISwitchablePylon.Sprite2"
    Components(0)="Default__AISwitchablePylon.Sprite"
    Components(1)="Default__AISwitchablePylon.Sprite2"
    Components(2)="Default__AISwitchablePylon.Arrow"
    Components(3)="Default__AISwitchablePylon.CollisionCylinder"
    Components(4)="Default__AISwitchablePylon.PathRenderer"
    Components(5)="Default__AISwitchablePylon.NavMeshRenderer"
    Components(6)="Default__AISwitchablePylon.DrawPylonRadius0"
    Components(7)="Default__AISwitchablePylon.Sprite3"
    CollisionComponent="Default__AISwitchablePylon.CollisionCylinder"
}

class DynamicPylon extends Pylon
    native
    placeable
    hidecategories(Navigation,Lighting,LightColor,Force,Lighting,LightColor,Force);

var bool bMoving;

event StoppedMoving()
{
    LogInternal(string(self) @ string(GetFuncName()) @ "-----------");
    bMoving = false;
    RebuildDynamicEdges();
}

event StartedMoving()
{
    LogInternal(string(self) @ string(GetFuncName()) @ "-----------");
    bMoving = true;
    FlushDynamicEdges();
}

native function FlushDynamicEdges()
{
}

native function RebuildDynamicEdges()
{
}

function PostBeginPlay()
{
    PostBeginPlay();
    RebuildDynamicEdges();
}

defaultproperties
{
    PylonRadiusPreview="Default__DynamicPylon.DrawPylonRadius0"
    RenderingComp="Default__DynamicPylon.NavMeshRenderer"
    BrokenSprite="Default__DynamicPylon.Sprite3"
    CylinderComponent="Default__DynamicPylon.CollisionCylinder"
    GoodSprite="Default__DynamicPylon.Sprite"
    BadSprite="Default__DynamicPylon.Sprite2"
    bStatic=False
    Components(0)="Default__DynamicPylon.Sprite"
    Components(1)="Default__DynamicPylon.Sprite2"
    Components(2)="Default__DynamicPylon.Arrow"
    Components(3)="Default__DynamicPylon.CollisionCylinder"
    Components(4)="Default__DynamicPylon.PathRenderer"
    Components(5)="Default__DynamicPylon.NavMeshRenderer"
    Components(6)="Default__DynamicPylon.DrawPylonRadius0"
    Components(7)="Default__DynamicPylon.Sprite3"
    CollisionComponent="Default__DynamicPylon.CollisionCylinder"
}

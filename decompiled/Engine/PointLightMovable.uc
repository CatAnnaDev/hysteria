class PointLightMovable extends PointLight
    native
    placeable
    hidecategories(Navigation);

defaultproperties
{
    LightComponent="Default__PointLightMovable.PointLightComponent0"
    bStatic=False
    bHardAttach=True
    bMovable=True
    Components(0)="Default__PointLightMovable.Sprite"
    Components(1)="Default__PointLightMovable.DrawLightRadius0"
    Components(2)="Default__PointLightMovable.DrawLightSourceRadius0"
    Components(3)="Default__PointLightMovable.PointLightComponent0"
    TickGroup="TG_DuringAsyncWork"
}

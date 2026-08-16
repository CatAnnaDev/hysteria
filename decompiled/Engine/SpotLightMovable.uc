class SpotLightMovable extends SpotLight
    native
    placeable
    hidecategories(Navigation);

defaultproperties
{
    LightComponent="Default__SpotLightMovable.SpotLightComponent0"
    bStatic=False
    bHardAttach=True
    bMovable=True
    Components(0)="Default__SpotLightMovable.Sprite"
    Components(1)="Default__SpotLightMovable.DrawLightRadius0"
    Components(2)="Default__SpotLightMovable.DrawInnerCone0"
    Components(3)="Default__SpotLightMovable.DrawOuterCone0"
    Components(4)="Default__SpotLightMovable.DrawLightSourceRadius0"
    Components(5)="Default__SpotLightMovable.SpotLightComponent0"
    Components(6)="Default__SpotLightMovable.ArrowComponent0"
    TickGroup="TG_DuringAsyncWork"
}

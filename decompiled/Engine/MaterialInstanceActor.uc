class MaterialInstanceActor extends Actor
    native
    placeable
    hidecategories(Navigation,Movement,Advanced,Collision,Display,Actor,Attachment);

var() MaterialInstanceConstant MatInst;

defaultproperties
{
    bNoDelete=True
    Components(0)="Default__MaterialInstanceActor.Sprite"
    CollisionType="COLLIDE_CustomDefault"
    TickGroup="TG_DuringAsyncWork"
}

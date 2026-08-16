class GameCrowdAttractor extends GameCrowdForcePoint
    native
    placeable
    hidecategories(Navigation,Advanced,Collision,Display,Actor,Movement,Physics);

var() interp float Attraction;
var() bool bAttractionFalloff;

event Vector AppliedForce(GameCrowdAgent Agent)
{
    local Vector ToAttractor;
    local float CurrentAttraction, Distance;
    
    ToAttractor = Location - Agent.Location;
    Distance = VSize(ToAttractor);
    ToAttractor = ToAttractor / Distance;
    CurrentAttraction = Attraction;
    if (bAttractionFalloff)
    {
        CurrentAttraction *= FMax(0.0, 1.0 - Distance / CylinderComponent.CollisionRadius);
    }
    return ToAttractor * CurrentAttraction;
}

defaultproperties
{
    Attraction=100.0
    bAttractionFalloff=True
    CylinderComponent="Default__GameCrowdAttractor.CollisionCylinder"
    Components(0)="Default__GameCrowdAttractor.CollisionCylinder"
    Components(1)="Default__GameCrowdAttractor.Sprite"
    CollisionComponent="Default__GameCrowdAttractor.CollisionCylinder"
}

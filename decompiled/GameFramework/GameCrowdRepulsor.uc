class GameCrowdRepulsor extends GameCrowdForcePoint
    native
    placeable
    hidecategories(Navigation,Advanced,Collision,Display,Actor,Movement,Physics);

var() interp float Repulsion;
var() bool bAttractionFalloff;

event Vector AppliedForce(GameCrowdAgent Agent)
{
    local Vector FromAttractor;
    local float CurrentRepulsion, Distance;
    
    FromAttractor = Agent.Location - Location;
    Distance = VSize(FromAttractor);
    FromAttractor = FromAttractor / Distance;
    CurrentRepulsion = Repulsion;
    if (bAttractionFalloff)
    {
        CurrentRepulsion *= FMax(0.0, 1.0 - Distance / CylinderComponent.CollisionRadius);
    }
    return FromAttractor * CurrentRepulsion;
}

defaultproperties
{
    Repulsion=180.0
    bAttractionFalloff=True
    CylinderComponent="Default__GameCrowdRepulsor.CollisionCylinder"
    Components(0)="Default__GameCrowdRepulsor.CollisionCylinder"
    Components(1)="Default__GameCrowdRepulsor.Sprite"
    CollisionComponent="Default__GameCrowdRepulsor.CollisionCylinder"
}

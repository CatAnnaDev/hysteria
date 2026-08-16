class GameCrowdForcePoint extends GameCrowdInteractionPoint
    abstract
    native
    placeable
    hidecategories(Navigation,Advanced,Collision,Display,Actor,Movement,Physics);

event Vector AppliedForce(GameCrowdAgent Agent)
{
}

event UnTouch(Actor Other)
{
    local GameCrowdAgent Agent;
    local int I;
    
    Agent = GameCrowdAgent(Other);
    if (Agent != none)
    {
        for (I = 0; I < Agent.RelevantAttractors.Length; I++)
        {
            if (Agent.RelevantAttractors[I] == self)
            {
                Agent.RelevantAttractors[I] = none;
                return;
            }
        }
        LogInternal(string(Agent) $ " DIDN'T HAVE ATTRACTOR IN LIST " $ string(self));
    }
}

event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    local GameCrowdAgent Agent;
    local int I;
    
    Agent = GameCrowdAgent(Other);
    if (Agent != none)
    {
        for (I = 0; I < Agent.RelevantAttractors.Length; I++)
        {
            if (Agent.RelevantAttractors[I] == self)
            {
                LogInternal(string(Agent) $ " UNEXPECTED ATTRACTOR IN LIST " $ string(self));
                return;
            }
        }
        for (I = 0; I < Agent.RelevantAttractors.Length; I++)
        {
            if (Agent.RelevantAttractors[I] == none)
            {
                Agent.RelevantAttractors[I] = self;
                return;
            }
        }
        Agent.RelevantAttractors[Agent.RelevantAttractors.Length] = self;
    }
}

defaultproperties
{
    CylinderComponent="Default__GameCrowdForcePoint.CollisionCylinder"
    bCollideActors=True
    Components(0)="Default__GameCrowdForcePoint.CollisionCylinder"
    Components(1)="Default__GameCrowdForcePoint.Sprite"
    CollisionComponent="Default__GameCrowdForcePoint.CollisionCylinder"
}

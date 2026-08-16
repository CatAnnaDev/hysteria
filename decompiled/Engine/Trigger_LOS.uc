class Trigger_LOS extends Trigger
    placeable
    hidecategories(Navigation);

var array<PlayerController> PCsWithLOS;

simulated event Tick(float DeltaTime)
{
    local array<SequenceEvent> losEvents;
    local SeqEvent_LOS Evt;
    local PlayerController Player;
    local int Idx;
    local Vector cameraLoc;
    local Rotator cameraRot;
    local float cameraDist;
    local array<int> ActivateIndices;
    
    if (FindEventsOfClass(class'SeqEvent_LOS', losEvents))
    {
        foreach WorldInfo.AllControllers(class'PlayerController', Player)
        {
            if (Player.Pawn != none)
            {
                Player.GetPlayerViewPoint(cameraLoc, cameraRot);
                cameraDist = PointDistToLine(Location, vector(cameraRot), cameraLoc);
                for (Idx = 0; Idx < losEvents.Length; Idx++)
                {
                    Evt = SeqEvent_LOS(losEvents[Idx]);
                    if (cameraDist <= Evt.ScreenCenterDistance && VSize(Player.Pawn.Location - Location) <= Evt.TriggerDistance && Normal(Location - cameraLoc) Dot vector(cameraRot) > 0.0 && !Evt.bCheckForObstructions || Player.LineOfSightTo(self, cameraLoc))
                    {
                        ActivateIndices[0] = 0;
                        if (PCsWithLOS.Find(Player) == -1 && losEvents[Idx].CheckActivate(self, Player.Pawn, false, ActivateIndices))
                        {
                            PCsWithLOS.AddItem(Player);
                        }
                        continue;
                    }
                    if (PCsWithLOS.Find(Player) != -1)
                    {
                        ActivateIndices[0] = 1;
                        if (losEvents[Idx].CheckActivate(self, Player.Pawn, false, ActivateIndices))
                        {
                            PCsWithLOS.RemoveItem(Player);
                        }
                    }
                }
            }
        }
    }
}

defaultproperties
{
    CylinderComponent="Default__Trigger_LOS.CollisionCylinder"
    Components(0)="Default__Trigger_LOS.Sprite"
    Components(1)="Default__Trigger_LOS.CollisionCylinder"
    CollisionType="COLLIDE_CustomDefault"
    CollisionComponent="Default__Trigger_LOS.CollisionCylinder"
    SupportedEvents(0)="SeqEvent_LOS"
}

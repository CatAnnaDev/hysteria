class TriggerStreamingLevel extends Trigger
    placeable
    hidecategories(Navigation);

struct LevelStreamingData
{
    var() bool bShouldBeLoaded;
    var() bool bShouldBeVisible;
    var() bool bShouldBlockOnLoad;
    var() LevelStreaming Level;
};

var() editinline array<LevelStreamingData> Levels;

event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    local PlayerController PlayerCon;
    local int Index;
    
    Touch(Other, OtherComp, HitLocation, HitNormal);
    for (Index = 0; Index < Levels.Length; Index++)
    {
        foreach WorldInfo.AllControllers(class'PlayerController', PlayerCon)
        {
            Levels[Index].Level.bShouldBlockOnLoad = Levels[Index].bShouldBlockOnLoad;
            PlayerCon.LevelStreamingStatusChanged(Levels[Index].Level, Levels[Index].bShouldBeLoaded, Levels[Index].bShouldBeVisible, Levels[Index].bShouldBlockOnLoad);
        }
    }
}

defaultproperties
{
    CylinderComponent="Default__TriggerStreamingLevel.CollisionCylinder"
    Components(0)="Default__TriggerStreamingLevel.Sprite"
    Components(1)="Default__TriggerStreamingLevel.CollisionCylinder"
    CollisionType="COLLIDE_CustomDefault"
    CollisionComponent="Default__TriggerStreamingLevel.CollisionCylinder"
}

class HeightFogVolume extends Volume
    native
    placeable
    hidecategories(Navigation,Object,Movement,Display,Advanced,Collision,Volume);

var() float Priority;
var() const export editconst editinline HeightFogComponent Component;
var() float Height;
var const transient HeightFogVolume NextLowerPriorityVolume;
var() repretry bool bEnabled;

replication
{
    if (bNetDirty)
        bEnabled;
}

simulated function OnToggle(SeqAct_Toggle Action)
{
    if (Action.InputLinks[0].bHasImpulse)
    {
        Component.SetEnabled(true);
    }
    else if (Action.InputLinks[1].bHasImpulse)
    {
        Component.SetEnabled(false);
    }
    else if (Action.InputLinks[2].bHasImpulse)
    {
        Component.SetEnabled(!Component.bEnabled);
    }
    bEnabled = Component.bEnabled;
    ForceNetRelevant();
    SetForcedInitialReplicatedProperty(BoolProperty'HeightFog.bEnabled', bEnabled == default.bEnabled);
}

simulated event EnableHeightFogActor(bool bSetEnabled)
{
    local HeightFog HF;
    
    foreach AllActors(class'HeightFog', HF)
    {
        if (HF.bEnabled)
        {
            HF.Component.SetEnabled(bSetEnabled);
        }
    }
}

simulated event Toggle(optional int Flag = -1)
{
    local bool bSetEnabled;
    
    if (Flag == 1)
    {
        bSetEnabled = true;
    }
    else if (Flag == 0)
    {
        bSetEnabled = false;
    }
    else
    {
        bSetEnabled = !Component.bEnabled;
    }
    if (Component.bEnabled != bSetEnabled)
    {
        Component.SetEnabled(bSetEnabled);
    }
}

defaultproperties
{
    Component="Default__HeightFogVolume.HeightFogComponent0"
    bEnabled=True
    BrushComponent="Default__HeightFogVolume.BrushComponent0"
    bStatic=False
    bCollideActors=False
    Components(0)="Default__HeightFogVolume.BrushComponent0"
    Components(1)="Default__HeightFogVolume.HeightFogComponent0"
    CollisionComponent="Default__HeightFogVolume.BrushComponent0"
    SupportedEvents(0)="SeqEvent_Touch"
}

class SonarActor_Decal extends AliceSonarActor
    placeable
    hidecategories(Navigation);

var() const export editconst editinline DecalComponent Decal;
var bool bPosDirty;
var Vector InitPos;

function StopSonar()
{
    if (bPosDirty)
    {
        SetLocation(InitPos);
    }
    SetHidden(true);
}

function UpdateSonar()
{
    SetLocation(Location + vect(0.0, 0.0, 5.0));
    SetHidden(false);
}

function BeginSonar()
{
    bPosDirty = true;
    InitPos = Location;
}

defaultproperties
{
    Decal="Default__SonarActor_Decal.NewDecalComponent"
    bHidden=True
    Components(0)="Default__SonarActor_Decal.NewDecalComponent"
    Components(1)="Default__SonarActor_Decal.Sprite"
    Components(2)="Default__SonarActor_Decal.ArrowComponent0"
    Rotation=(Pitch=-16384,Yaw=0,Roll=0)
    TickGroup="TG_DuringAsyncWork"
}

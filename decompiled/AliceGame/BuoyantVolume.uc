class BuoyantVolume extends Volume
    native
    placeable
    hidecategories(Navigation,Object,Movement,Display);

var() float Density;
var() float AngularDrag;
var() float LinearDrag;

event UnTouch(Actor Other)
{
    local BuoyantActor B;
    
    UnTouch(Other);
    if (Other != none)
    {
        B = BuoyantActor(Other);
        if (B != none)
        {
            B.BuoyantVolume = none;
        }
    }
}

simulated event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    local BuoyantActor B;
    
    Touch(Other, OtherComp, HitLocation, HitNormal);
    if (Other != none)
    {
        B = BuoyantActor(Other);
        if (B != none)
        {
            B.BuoyantVolume = self;
        }
    }
}

defaultproperties
{
    Density=1e-05
    AngularDrag=0.5
    LinearDrag=5.0
    BrushComponent="Default__BuoyantVolume.BrushComponent0"
    Components(0)="Default__BuoyantVolume.BrushComponent0"
    CollisionComponent="Default__BuoyantVolume.BrushComponent0"
}

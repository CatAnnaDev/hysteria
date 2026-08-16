class WindVolume extends Volume
    placeable
    hidecategories(Navigation,Object,Movement,Display);

var() Vector Force;
var() Vector PerturbAmplitude;
var() float Damping;

function ApplyWind(Actor Actor)
{
    local HairComponent HairComponent;
    local ClothComponent ClothComponent;
    
    foreach Actor.AllOwnedComponents(class'Engine.HairComponent', HairComponent)
    {
        HairComponent.Force += Force;
        HairComponent.Damping += Damping;
        HairComponent.PerturbAmplitude += PerturbAmplitude;
    }
    foreach Actor.AllOwnedComponents(class'Engine.ClothComponent', ClothComponent)
    {
        ClothComponent.Force += Force;
        ClothComponent.Damping += Damping;
        ClothComponent.PerturbAmplitude += PerturbAmplitude;
    }
}

defaultproperties
{
    Force=(X=2000.0,Y=0.0,Z=0.0)
    PerturbAmplitude=(X=1500.0,Y=1500.0,Z=1500.0)
    BrushComponent="Default__WindVolume.BrushComponent0"
    Components(0)="Default__WindVolume.BrushComponent0"
    CollisionComponent="Default__WindVolume.BrushComponent0"
}

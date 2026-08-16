class AliceFloatVolume extends DynamicPhysicsVolume
    placeable
    hidecategories(Navigation,Object,Display);

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

simulated event PawnLeavingVolume(Pawn P)
{
    local AlicePlayerController APC;
    
    APC = AlicePlayerController(P.Controller);
    if (APC != none)
    {
        APC.bInFloatVolume = false;
        APC.GotoState('PlayerWalking');
        APC.MyAlicePawn.DoSpecialMove(3, true);
        APC.MyAlicePawn.TriggerContextEventClass(6, 1);
        APC.MyAlicePawn.bIsJumping = false;
        APC.MyAlicePawn.bJustLeaveSteam = true;
    }
}

simulated event PawnEnteredVolume(Pawn P)
{
    local AlicePlayerController APC;
    
    APC = AlicePlayerController(P.Controller);
    if (APC != none)
    {
        APC.bInFloatVolume = true;
        APC.GotoState('PlayerWalking');
        APC.Pawn.SetPhysics(2);
        APC.MyAlicePawn.DoSpecialMove(57, true);
        APC.MyAlicePawn.TriggerContextEventClass(6, 0);
        APC.MyAlicePawn.bIsDoubleJumping = false;
        APC.MyAlicePawn.bAfterHoverJump = false;
        APC.MyAlicePawn.bFloatDown = false;
        APC.CycleFloatManager.bDisableAfterLanded = true;
        APC.CycleFloatManager.indicatorManager.stopEffect();
    }
}

defaultproperties
{
    Force=(X=0.0,Y=0.0,Z=5000.0)
    PerturbAmplitude=(X=5000.0,Y=5000.0,Z=5000.0)
    BrushComponent="Default__AliceFloatVolume.BrushComponent0"
    Components(0)="Default__AliceFloatVolume.BrushComponent0"
    CollisionComponent="Default__AliceFloatVolume.BrushComponent0"
}

class JumpPadNPC extends JumpPad
    native
    placeable
    hidecategories(Navigation,Lighting,LightColor,Force,VehicleUsage);

var AliceGameKynapsePawn P;
var bool bPadInUsing;

function OnLaunchAnimOverTimer()
{
    CalculateJumpVelocity();
    P.SetPhysics(2);
    P.Velocity = JumpVelocity;
    if (WorldInfo.WorldGravityZ != WorldInfo.DefaultGravityZ && P.GetGravityZ() == WorldInfo.WorldGravityZ)
    {
        P.Velocity *= Sqrt(P.GetGravityZ() / WorldInfo.DefaultGravityZ);
    }
    P.Acceleration = vect(0.0, 0.0, 0.0);
    if (JumpSound != none)
    {
        P.PlaySound(JumpSound);
    }
}

function OrientToucherToTarget()
{
    local Vector TargetDir;
    local Rotator R;
    
    TargetDir = JumpTarget.Location - Location;
    R = rotator(TargetDir);
    R.Pitch = 0;
    P.SetRotation(R);
}

function Launch()
{
    P.JumpPad = self;
    P.Controller.GotoState('NPCJumpPad');
    OrientToucherToTarget();
    OnLaunchAnimOverTimer();
}

function NotifyLanded()
{
    bPadInUsing = false;
}

event bool IsJumpPadInUsing()
{
    return bPadInUsing;
}

event NPCJumpPadLand(Actor JumpNpcPawn)
{
    P = AliceGameKynapsePawn(JumpNpcPawn);
    P.bSkipCheckWithJumpingNPC = false;
}

event NPCJumpPadLauch(Actor JumpNpcPawn)
{
    P = AliceGameKynapsePawn(JumpNpcPawn);
    bPadInUsing = true;
    Launch();
}

event NPCJumpPadPreLauch(Actor JumpNpcPawn)
{
    P = AliceGameKynapsePawn(JumpNpcPawn);
    P.bSkipCheckWithJumpingNPC = true;
}

event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
}

event PostBeginPlay()
{
    PostBeginPlay();
}

function CalculateJumpVelocity()
{
    local Vector Flight, GravityV;
    
    Flight = JumpTarget.Location - P.Location;
    if (Flight.X == 0.0 && Flight.Y == 0.0)
    {
        JumpVelocity.X = 0.0;
        JumpVelocity.Y = 0.0;
        JumpVelocity.Z = 0.0;
        return;
    }
    GravityV.X = 0.0;
    GravityV.Y = 0.0;
    GravityV.Z = GetGravityZ();
    JumpVelocity = Flight / JumpTime - GravityV * JumpTime;
}

defaultproperties
{
    JumpTime=2.0
    JumpPadForNpcOnly=True
    bSpecialMove=True
    bDestinationOnly=True
    bBlockedForVehicles=True
    CylinderComponent="Default__JumpPadNPC.CollisionCylinder"
    GoodSprite="Default__JumpPadNPC.Sprite"
    BadSprite="Default__JumpPadNPC.Sprite2"
    bStatic=False
    bMovable=False
    bCollideActors=True
    Components(0)="Default__JumpPadNPC.Sprite"
    Components(1)="Default__JumpPadNPC.Sprite2"
    Components(2)="Default__JumpPadNPC.Arrow"
    Components(3)="Default__JumpPadNPC.CollisionCylinder"
    Components(4)="Default__JumpPadNPC.PathRenderer"
    Components(5)="Default__JumpPadNPC.JumpPadLightEnvironment"
    Components(6)="Default__JumpPadNPC.Sprite"
    CollisionComponent="Default__JumpPadNPC.CollisionCylinder"
}

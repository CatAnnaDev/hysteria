class KynapsePawn extends GamePawn
    native
    notplaceable
    config(Game)
    hidecategories(Navigation);

var() const export editinline KynapseHandle KynapseHandle;
var() const export editconst editinline DynamicLightEnvironmentComponent LightEnvironment;

event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
    SphinxAnimEnd(SeqNode, PlayedTime, ExcessTime);
}

event Bump(Actor Other, PrimitiveComponent OtherComp, Vector HitNormal)
{
    if (Other.IsA('KynapseObstacleSmall'))
    {
        if (OtherComp != none)
        {
            OtherComp.AddImpulse(-200.0 * HitNormal, 0.5 * (Other.Location + Location));
        }
    }
}

native final function SphinxAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
    SeqNode;
    PlayedTime;
    ExcessTime;
}

defaultproperties
{
    KynapseHandle="Default__KynapsePawn.PawnKynapseHandle"
    LightEnvironment="Default__KynapsePawn.MyLightEnvironment"
    bCanClimbLadders=True
    ControllerClass="KynapseAIController"
    Mesh="Default__KynapsePawn.DemoPawnSkeletalMeshComponent"
    CylinderComponent="Default__KynapsePawn.CollisionCylinder"
    Components(0)="Default__KynapsePawn.CollisionCylinder"
    Components(1)="Default__KynapsePawn.Arrow"
    Components(2)="Default__KynapsePawn.MyLightEnvironment"
    Components(3)="Default__KynapsePawn.DemoPawnSkeletalMeshComponent"
    Components(4)="Default__KynapsePawn.PawnKynapseHandle"
    CollisionType="COLLIDE_CustomDefault"
    CollisionComponent="Default__KynapsePawn.CollisionCylinder"
}

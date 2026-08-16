class AliceGameDropActor extends Actor
    native
    notplaceable
    hidecategories(Navigation);

var export editinline SkeletalMeshComponent SkelComp;
var export editinline LightEnvironmentComponent LightEnvironment;

event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
    if (Owner != none)
    {
        Owner.OnAnimEnd(SeqNode, PlayedTime, ExcessTime);
    }
    else
    {
        OnAnimEnd(SeqNode, PlayedTime, ExcessTime);
    }
}

defaultproperties
{
    LightEnvironment="Default__AliceGameDropActor.MyLightEnvironment"
    bCollideActors=True
    bCollideWorld=True
    Components(0)="Default__AliceGameDropActor.CollisionCylinder"
    Components(1)="Default__AliceGameDropActor.MyLightEnvironment"
    CollisionType="COLLIDE_CustomDefault"
    CollisionComponent="Default__AliceGameDropActor.CollisionCylinder"
}

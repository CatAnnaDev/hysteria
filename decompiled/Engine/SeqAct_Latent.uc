class SeqAct_Latent extends SequenceAction
    abstract
    native
    notplaceable
    hidecategories(Object);

var array<Actor> LatentActors;
var bool bAborted;

event bool Update(float DeltaTime)
{
}

native function AbortFor(Actor latentActor)
{
    latentActor;
}

defaultproperties
{
    bLatentExecution=True
    OutputLinks(0)=(Links=(),LinkDesc="Finished",bHasImpulse=False,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",ActivateDelay=0.0,DrawY=0,bHidden=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    OutputLinks(1)=(Links=(),LinkDesc="Aborted",bHasImpulse=False,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",ActivateDelay=0.0,DrawY=0,bHidden=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    ObjName="Undefined Latent"
    ObjColor=(B=0,G=128,R=128,A=255)
}

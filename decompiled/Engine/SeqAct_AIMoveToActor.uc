class SeqAct_AIMoveToActor extends SeqAct_Latent
    native
    notplaceable
    hidecategories(Object);

var() bool bInterruptable;
var() bool bPickClosest;
var() bool bTurnOnAIAfterArrival;
var() array<Actor> Destination;
var() float MovementSpeedModifier;
var() Actor LookAt;
var transient int LastDestinationChoice;

function Actor PickDestination(Actor Requestor)
{
    local float Dist, bestDist;
    local Actor Dest, BestDest;
    
    if (bPickClosest)
    {
        foreach Destination(Dest)
        {
            Dist = VSize(Dest.Location - Requestor.Location);
            if (BestDest == none || Dist < bestDist)
            {
                BestDest = Dest;
                bestDist = Dist;
            }
        }
        return BestDest;
    }
    else
    {
        if (LastDestinationChoice < 0 || LastDestinationChoice >= Destination.Length)
        {
            LastDestinationChoice = 0;
        }
        return Destination[LastDestinationChoice++];
    }
}

static event int GetObjClassVersion()
{
    return GetObjClassVersion() + 2;
}

defaultproperties
{
    MovementSpeedModifier=1.0
    OutputLinks(0)=(Links=(),LinkDesc="Finished",bHasImpulse=False,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",ActivateDelay=0.0,DrawY=0,bHidden=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    OutputLinks(1)=(Links=(),LinkDesc="Aborted",bHasImpulse=False,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",ActivateDelay=0.0,DrawY=0,bHidden=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    OutputLinks(2)=(Links=(),LinkDesc="Out",bHasImpulse=False,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",ActivateDelay=0.0,DrawY=0,bHidden=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(0)=(ExpectedType="SeqVar_Object",LinkedVariables=(),LinkDesc="Target",LinkVar="None",PropertyName="Targets",bWriteable=False,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(1)=(ExpectedType="SeqVar_Object",LinkedVariables=(),LinkDesc="Destination",LinkVar="None",PropertyName="Destination",bWriteable=False,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(2)=(ExpectedType="SeqVar_Object",LinkedVariables=(),LinkDesc="Look At",LinkVar="None",PropertyName="LookAt",bWriteable=False,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    ObjName="Move To Actor"
    ObjCategory="AI"
    ObjRemoveInProject(0)="Gear"
}

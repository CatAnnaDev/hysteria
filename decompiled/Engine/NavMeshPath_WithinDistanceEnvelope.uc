class NavMeshPath_WithinDistanceEnvelope extends NavMeshPathConstraint
    native
    notplaceable;

var() float MaxDistance;
var() float MinDistance;
var() bool bSoft;
var() bool bOnlyThrowOutNodesThatLeaveEnvelope;
var() float SoftStartPenalty;
var() Vector EnvelopeTestPoint;

function Recycle()
{
    Recycle();
    MaxDistance = default.MaxDistance;
    MinDistance = default.MinDistance;
    bSoft = default.bSoft;
    SoftStartPenalty = default.SoftStartPenalty;
    EnvelopeTestPoint = default.EnvelopeTestPoint;
    bOnlyThrowOutNodesThatLeaveEnvelope = default.bOnlyThrowOutNodesThatLeaveEnvelope;
}

static function bool StayWithinEnvelopeToLoc(NavigationHandle NavHandle, Vector InEnvelopeTestPoint, float InMaxDistance, float InMinDistance, optional bool bInSoft = true, optional float InSoftStartPenalty = -1.0, optional bool bOnlyTossOutSpecsThatLeave)
{
    local NavMeshPath_WithinDistanceEnvelope Con;
    
    if (NavHandle != none)
    {
        Con = NavMeshPath_WithinDistanceEnvelope(NavHandle.CreatePathConstraint(default.Class));
        if (Con != none)
        {
            Con.EnvelopeTestPoint = InEnvelopeTestPoint;
            Con.bSoft = bInSoft;
            Con.MaxDistance = InMaxDistance;
            Con.MinDistance = InMinDistance;
            Con.bOnlyThrowOutNodesThatLeaveEnvelope = bOnlyTossOutSpecsThatLeave;
            if (InSoftStartPenalty > -1.0)
            {
                Con.SoftStartPenalty = InSoftStartPenalty;
            }
            NavHandle.AddPathConstraint(Con);
            return true;
        }
    }
    return false;
}

defaultproperties
{
    bSoft=True
    SoftStartPenalty=320.0
}

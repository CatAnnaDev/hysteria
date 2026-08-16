class TargetingMode_PointOfInterest extends TargetingModeBase
    notplaceable
    hidecategories(Navigation);

var transient array<AlicePointOfInterest> POIsToBeTargeted;
var transient array<AlicePointOfInterest> POIsToBeTargetedSortedByAngle;

function SwitchTargetingNPCs(bool bLeft)
{
    local int I, Index;
    
    if (!bInitialized || !bActive)
    {
        return;
    }
    FindAvailableTargets(SearchCenter, SearchRadius, SearchZDiff, false);
    if (POIsToBeTargetedSortedByAngle.Length <= 1)
    {
        return;
    }
    Index = -1;
    for (I = 0; I < POIsToBeTargetedSortedByAngle.Length; I++)
    {
        if (POIsToBeTargetedSortedByAngle[I] == TargetingActor)
        {
            Index = I;
            break;
        }
    }
    if (Index == -1)
    {
        return;
    }
    if (bLeft)
    {
        Index--;
    }
    else
    {
        Index++;
    }
    if (Index < 0 || Index >= POIsToBeTargetedSortedByAngle.Length)
    {
        return;
    }
    if (TargetingActor != none)
    {
        TargetingActor.TriggerEventClass(class'SeqEvent_LockedOn', self, 1);
    }
    TargetingActor = POIsToBeTargetedSortedByAngle[Index];
    TargetingActor.TriggerEventClass(class'SeqEvent_LockedOn', self, 0);
    APC.TargetingActorSwitched();
    SetAPCTargetingInfo();
}

simulated function SetAPCTargetingInfo()
{
    APC.TargetingActor = TargetingActor;
}

simulated function FindAvailableTargets(Vector vCenterOfSearch, float fRadius, float fZDiff, bool bUpdateTargetingActor)
{
    local AlicePointOfInterest POI, A, B, AWithMinDist;
    local float MinDist, curDist, nextDist;
    local bool bTargetingActorInList;
    local int I, J, T;
    local Vector vPlayerFacing, vTarget;
    local array<float> Angles;
    local float fAngle;
    
    MinDist = fRadius;
    POIsToBeTargeted.Length = 0;
    foreach DynamicActors(class'AlicePointOfInterest', POI)
    {
        if (POI != none && POI.bCanBeLockedOn)
        {
            curDist = VSize2D(vCenterOfSearch - POI.Location);
            if (curDist < fRadius && Abs(vCenterOfSearch.Z - POI.Location.Z) < fZDiff)
            {
                POIsToBeTargeted.AddItem(POI);
                if (MinDist > curDist)
                {
                    AWithMinDist = POI;
                    MinDist = curDist;
                }
                if (TargetingActor != none && POI == TargetingActor)
                {
                    bTargetingActorInList = true;
                }
            }
        }
    }
    if (POIsToBeTargeted.Length == 0)
    {
        TargetingActor = none;
        return;
    }
    for (I = 0; I < POIsToBeTargeted.Length; I++)
    {
        T = POIsToBeTargeted.Length - I - 1;
        for (J = 0; J < T; J++)
        {
            A = POIsToBeTargeted[J];
            curDist = VSize2D(PlayerPawn.Location - A.Location);
            B = POIsToBeTargeted[J + 1];
            nextDist = VSize2D(PlayerPawn.Location - B.Location);
            if (curDist > nextDist)
            {
                POIsToBeTargeted[J] = POIsToBeTargeted[J + 1];
                POIsToBeTargeted[J + 1] = A;
            }
        }
    }
    vPlayerFacing = vector(PlayerPawn.Rotation);
    vPlayerFacing = Normal(vPlayerFacing);
    POIsToBeTargetedSortedByAngle.Length = 0;
    Angles.Length = 0;
    for (I = 0; I < POIsToBeTargeted.Length; I++)
    {
        vTarget = POIsToBeTargeted[I].Location - PlayerPawn.Location;
        vTarget = Normal(vTarget);
        fAngle = APC.CalcAngleBetweenVectors(vPlayerFacing, vTarget);
        POIsToBeTargetedSortedByAngle.AddItem(POIsToBeTargeted[I]);
        Angles.AddItem(fAngle);
    }
    for (I = 0; I < POIsToBeTargetedSortedByAngle.Length; I++)
    {
        T = POIsToBeTargetedSortedByAngle.Length - I - 1;
        for (J = 0; J < T; J++)
        {
            if (Angles[J] > Angles[J + 1])
            {
                A = POIsToBeTargetedSortedByAngle[J];
                POIsToBeTargetedSortedByAngle[J] = POIsToBeTargetedSortedByAngle[J + 1];
                POIsToBeTargetedSortedByAngle[J + 1] = A;
                fAngle = Angles[J];
                Angles[J] = Angles[J + 1];
                Angles[J + 1] = fAngle;
            }
        }
    }
    if (bUpdateTargetingActor && TargetingActor == none || TargetingActor != none && !bTargetingActorInList)
    {
        TargetingActor = AWithMinDist;
        SetAPCTargetingInfo();
    }
}

simulated function ResetDefaultTransientVariables()
{
    POIsToBeTargeted.Length = 0;
    POIsToBeTargetedSortedByAngle.Length = 0;
    TargetingActor = none;
}

simulated function LeavingMode()
{
    if (!bInitialized || !bActive)
    {
        return;
    }
    ResetDefaultTransientVariables();
    Deactivated();
    APC.LockOnModeDeactivated();
}

simulated function EnteringMode()
{
    if (!bInitialized || bActive)
    {
        return;
    }
    if (APC == none)
    {
        bInitialized = false;
        bActive = false;
        return;
    }
    PlayerPawn = APC.MyAlicePawn;
    if (PlayerPawn == none)
    {
        return;
    }
    ResetDefaultTransientVariables();
    GetSearchConditionParameters();
    FindAvailableTargets(SearchCenter, SearchRadius, SearchZDiff, true);
    if (TargetingActor == none)
    {
        return;
    }
    Activated();
    APC.LockOnModeActivated();
}

defaultproperties
{
    SearchTargetType="AlicePointOfInterest"
}

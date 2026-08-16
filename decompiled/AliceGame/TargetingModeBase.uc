class TargetingModeBase extends Actor
    notplaceable
    hidecategories(Navigation);

var bool bActive;
var bool bInitialized;
var class<Object> SearchTargetType;
var Vector SearchCenter;
var float SearchRadius;
var float SearchZDiff;
var transient Actor TargetingActor;
var transient AlicePlayerController APC;
var transient AlicePawn PlayerPawn;

simulated function PostLockOff()
{
}

simulated function PostLockOn()
{
}

simulated function PostUpdate()
{
    if (!bInitialized || !bActive)
    {
        return;
    }
    if (APC != none && !APC.IsInState('PlayerWalking') && !APC.IsInState('PlayerLockOn'))
    {
        return;
    }
}

simulated function SetAPCTargetingInfo()
{
}

simulated function SwitchTargetingActor(bool bLeft)
{
}

simulated function FindAvailableTargets(Vector vCenterOfSearch, float fRadius, float fZDiff, bool bUpdateTargetingActor)
{
}

simulated function LeavingMode()
{
}

simulated function EnteringMode()
{
}

simulated function Deactivated()
{
    bActive = false;
}

simulated function Activated()
{
    bActive = true;
}

simulated function GetSearchConditionParameters()
{
    SearchCenter = PlayerPawn.Location;
    SearchRadius = PlayerPawn.TargetingSearchRadius;
    SearchZDiff = 10000.0;
}

simulated function Update(float DeltaTime)
{
    if (!bInitialized || !bActive)
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
    SetLocation(APC.Location);
    GetSearchConditionParameters();
    if (bActive)
    {
        FindAvailableTargets(SearchCenter, SearchRadius, SearchZDiff, true);
    }
}

final simulated function Initialize(AlicePlayerController inPC)
{
    if (bInitialized)
    {
        return;
    }
    APC = inPC;
    PlayerPawn = APC.MyAlicePawn;
    if (APC != none)
    {
        bInitialized = true;
    }
}

final simulated function Toggle(bool bTurnOn)
{
    if (!bInitialized)
    {
        return;
    }
    if (bTurnOn)
    {
        EnteringMode();
    }
    else
    {
        LeavingMode();
    }
}

final simulated function bool IsInitialized()
{
    return bInitialized;
}

final simulated function bool IsActivated()
{
    return bActive;
}

defaultproperties
{
    CollisionType="COLLIDE_CustomDefault"
}

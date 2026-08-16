class AlicePointOfInterest extends Keypoint
    native
    placeable
    config(Game)
    hidecategories(Navigation);

var const int POIPriority_ScriptedEvent;
var const int POIPriority_RevivableComrade;
var const int POIPriority_MoveOrder;
var const int POIPriority_TargetOrder;
var const int POIPriority_ComradeHuman;
var const int POIPriority_Comrade;
var const int POIPriority_Pickup;
var string DisplayName;
var bool bEnabled;
var bool bForceLookCheckLineOfSight;
var() bool bDoTraceForFOV;
var bool bDisableOtherPOIs;
var bool bLeavePlayerFacingPOI;
var bool bIsInitialized;
var() bool bCanBeLockedOn;
var() bool bOverrideCamera;
var() float IconDuration;
var EPOIForceLookType ForceLookType;
var float ForceLookDuration;
var() int LookAtPriority;
var() float DesiredFOV;
var int FOVCount;
var() float EnableDuration;
var float CurrIconDuration;
var Actor AttachedToActor;
var SeqAct_ManagePOI POIAction;
var() Vector CameraOffset;

final simulated function ServerFirePOIActionOutputLink(int POIOutputType)
{
    if (POIAction != none)
    {
        POIAction.OutputLinks[POIOutputType].bHasImpulse = true;
        if (POIOutputType == 3)
        {
            POIAction.POI_bEnabled = false;
        }
    }
}

final simulated function Vector GetActualLookatLocation()
{
    local Vector FocusLocation;
    local Actor LookatActor;
    local AlicePawn ap;
    
    LookatActor = self;
    if (AttachedToActor != none)
    {
        ap = AlicePawn(AttachedToActor);
        if (ap != none)
        {
            LookatActor = ap;
        }
    }
    FocusLocation = LookatActor.Location;
    return FocusLocation;
}

final simulated function float GetDesiredFOV(Vector cameraLoc)
{
    if (FOVCount >= 0 && DesiredFOV >= float(0))
    {
        if (!bDoTraceForFOV || FastTrace(Location, cameraLoc))
        {
            return DesiredFOV;
        }
    }
    return 0.0;
}

simulated function Destroyed()
{
    DisablePOI();
}

simulated function string GetDisplayName()
{
    local string DisplayText;
    
    if (Len(DisplayName) <= 0)
    {
        if (AttachedToActor != none)
        {
            DisplayText = string(AttachedToActor.Name);
        }
    }
    else
    {
        DisplayText = RetrievePOIString(DisplayName);
    }
    return DisplayText;
}

native simulated function string RetrievePOIString(string TagName)
{
    TagName;
}

simulated event PostBeginPlay()
{
    CurrIconDuration = IconDuration;
    AttachToActor(Base == none ? Owner : Base);
    InitializePOI();
}

simulated function InitializePOI()
{
    if (!bIsInitialized)
    {
        if (AttachedToActor != none)
        {
        }
        if (bEnabled)
        {
            EnablePOI();
        }
        bIsInitialized = true;
    }
}

simulated function int GetLookAtPriority(AlicePlayerController PC)
{
    if (PC != none && AttachedToActor != none)
    {
        if (AttachedToActor.IsA('AlicePawn'))
        {
            return AlicePawn(AttachedToActor).GetLookAtPriority(PC, -1);
        }
    }
    return LookAtPriority;
}

protected simulated function AttachToActor(Actor Host)
{
    AttachedToActor = Host;
    if (AttachedToActor != none)
    {
        SetBase(AttachedToActor);
    }
}

simulated function DisablePOI()
{
    local AlicePlayerController LPC;
    
    if (Role == 3)
    {
        if (IsTimerActive('DisablePOI'))
        {
            ClearTimer('DisablePOI');
        }
        bEnabled = false;
        bForceNetUpdate = true;
        if (POIAction != none)
        {
            POIAction.bIsDone = true;
        }
    }
    foreach LocalPlayerControllers(class'AlicePlayerController', LPC)
    {
        LPC.RemovePointOfInterest(self, ForceLookType);
        LPC.ShowPOIUIHint(-2.0);
    }
}

simulated function EnablePOI()
{
    local AlicePlayerController LPC;
    
    if (Role == 3)
    {
        if (EnableDuration > float(0))
        {
            SetTimer(EnableDuration, false, 'DisablePOI');
        }
    }
    CurrIconDuration = IconDuration;
    foreach LocalPlayerControllers(class'AlicePlayerController', LPC)
    {
        if (ShouldControllerHavePOI(LPC))
        {
            LPC.AddPointOfInterest(self);
        }
    }
}

simulated function bool ShouldControllerHavePOI(AlicePlayerController AlicePCToTest)
{
    return true;
}

simulated event SetEnabled(bool bOn)
{
    local bool OldbEnabled;
    
    OldbEnabled = bEnabled;
    if (bOn)
    {
        bEnabled = true;
    }
    else
    {
        bEnabled = false;
    }
    if (OldbEnabled != bEnabled)
    {
        bForceNetUpdate = true;
    }
    if (bEnabled)
    {
        EnablePOI();
    }
    else
    {
        DisablePOI();
    }
}

simulated event ReplicatedEvent(name VarName)
{
    switch (VarName)
    {
        case 'AttachedToActor':
            InitializePOI();
            break;
        case 'bEnabled':
            if (bEnabled)
            {
                EnablePOI();
            }
            else
            {
                DisablePOI();
            }
            break;
        default:
            break;
    }
}

defaultproperties
{
    POIPriority_ScriptedEvent=1000
    POIPriority_RevivableComrade=750
    POIPriority_MoveOrder=650
    POIPriority_TargetOrder=700
    POIPriority_ComradeHuman=-1
    POIPriority_Comrade=-1
    POIPriority_Pickup=500
    bDoTraceForFOV=True
    IconDuration=5.0
    LookAtPriority=1000
    DesiredFOV=60.0
    EnableDuration=5.0
    SpriteComp="Default__AlicePointOfInterest.Sprite"
    bStatic=False
    bAlwaysRelevant=True
    Components(0)="Default__AlicePointOfInterest.Sprite"
    RemoteRole="ROLE_SimulatedProxy"
    TickGroup="TG_DuringAsyncWork"
    SupportedEvents(0)="Engine.SeqEvent_Touch"
    SupportedEvents(1)="Engine.SeqEvent_Destroyed"
    SupportedEvents(2)="Engine.SeqEvent_TakeDamage"
    SupportedEvents(3)="Engine.SeqEvent_HitWall"
    SupportedEvents(4)="SeqEvent_LockedOn"
}

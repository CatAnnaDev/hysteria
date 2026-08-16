class HeadSwitchActor extends StaticMeshActor
    placeable
    hidecategories(Navigation);

var() const export editconst editinline CylinderComponent CylinderComponent;
var() Vector AttractionLocation;
var() float AttractionForce;
var() float AttractionTorque;
var() Vector SnapOffset;
var() float DelayBeforeEjection;
var() float EjectionForce;
var() Vector EjectionDirection;
var() bool RevMode;
var() bool bEnableActivation;
var transient float RevSpeed;
var() float RevMaxSpeed;
var() float RevAcceleration;
var() float RevDecceleration;
var() float RevDamping;
var() transient editconst float RevOutput;
var() float HeadSwitchStep2Time;
var() SoundCue ActiveSound;

function HeadSwitchEjected()
{
    TriggerEventClass(class'SeqEvent_HeadSwitchEjected', self);
}

function HeadSwitchActivated()
{
    TriggerEventClass(class'SeqEvent_HeadSwitchActivated', self);
    if (ActiveSound != none)
    {
        PlaySound(ActiveSound);
    }
}

simulated event OnToggleHeadSwitchActivation(SeqAct_ToggleHeadSwitchActivation inAction)
{
    if (inAction.InputLinks[0].bHasImpulse)
    {
        bEnableActivation = true;
    }
    else if (inAction.InputLinks[1].bHasImpulse)
    {
        bEnableActivation = false;
    }
    else
    {
        bEnableActivation = !bEnableActivation;
    }
}

event UnTouch(Actor Other)
{
    local AlicePawn ap;
    
    ap = AlicePawn(Other);
    if (ap != none)
    {
        PlayerController(ap.Controller).ClientMessage("Entrance Untouch");
        if (ap.HeadSwitchStep == 1 || ap.HeadSwitchStep == 3)
        {
            ap.HeadSwitchStep = 0;
            ap.HeadSwitch = none;
        }
    }
}

event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    local AlicePawn ap;
    
    if (!bEnableActivation)
    {
        return;
    }
    ap = AlicePawn(Other);
    if (ap != none && ap.HeadSwitchStep == 0)
    {
        PlayerController(ap.Controller).ClientMessage("Entrance Touch");
        ap.HeadSwitchStep = 1;
        ap.HeadSwitchStep2TickTime = HeadSwitchStep2Time;
        ap.HeadSwitch = self;
    }
}

defaultproperties
{
    CylinderComponent="Default__HeadSwitchActor.CollisionCylinder"
    AttractionLocation=(X=0.0,Y=0.0,Z=-500.0)
    AttractionForce=1000.0
    AttractionTorque=500.0
    SnapOffset=(X=0.0,Y=0.0,Z=-20.0)
    DelayBeforeEjection=1.0
    EjectionForce=20000.0
    EjectionDirection=(X=0.0,Y=0.0,Z=1.0)
    bEnableActivation=True
    RevMaxSpeed=2000.0
    RevAcceleration=2000.0
    RevDecceleration=4000.0
    RevDamping=100.0
    HeadSwitchStep2Time=0.4
    ActiveSound="SFX_C5_OWHH.sfx_owhh_roll_lock_Cue"
    StaticMeshComponent="Default__HeadSwitchActor.StaticMeshComponent0"
    bStatic=False
    bNoDelete=True
    bWorldGeometry=False
    bProjTarget=True
    Components(0)="Default__HeadSwitchActor.StaticMeshComponent0"
    Components(1)="Default__HeadSwitchActor.CollisionCylinder"
    CollisionComponent="Default__HeadSwitchActor.CollisionCylinder"
    SupportedEvents(0)="Engine.SeqEvent_Touch"
    SupportedEvents(1)="Engine.SeqEvent_Destroyed"
    SupportedEvents(2)="Engine.SeqEvent_TakeDamage"
    SupportedEvents(3)="Engine.SeqEvent_HitWall"
    SupportedEvents(4)="SeqEvent_HeadSwitchActivated"
    SupportedEvents(5)="SeqEvent_HeadSwitchEjected"
}

class RB_Handle extends ActorComponent
    native
    notplaceable
    collapsecategories
    hidecategories(Object);

var export editinline PrimitiveComponent GrabbedComponent;
var name GrabbedBoneName;
var const native transient int SceneIndex;
var const native transient bool bInHardware;
var const native transient bool bRotationConstrained;
var bool bInterpolating;
var const native transient Pointer HandleData;
var const native transient Pointer KinActorData;
var() float LinearDamping;
var() float LinearStiffness;
var() Vector LinearStiffnessScale3D;
var() Vector LinearDampingScale3D;
var() float AngularDamping;
var() float AngularStiffness;
var Vector Destination;
var Vector StepSize;
var Vector Location;

native function Quat GetOrientation()
{
}

native function SetOrientation(out const Quat NewOrientation)
{
    NewOrientation;
}

native function UpdateSmoothLocation(out const Vector NewLocation)
{
    NewLocation;
}

native function SetSmoothLocation(Vector NewLocation, float MoveTime)
{
    NewLocation;
    MoveTime;
}

native function SetLocation(Vector NewLocation)
{
    NewLocation;
}

native function ReleaseComponent()
{
}

native function GrabComponent(PrimitiveComponent Component, name InBoneName, Vector GrabLocation, bool bConstrainRotation)
{
    Component;
    InBoneName;
    GrabLocation;
    bConstrainRotation;
}

defaultproperties
{
    LinearDamping=100.0
    LinearStiffness=1300.0
    LinearStiffnessScale3D=(X=1.0,Y=1.0,Z=1.0)
    LinearDampingScale3D=(X=1.0,Y=1.0,Z=1.0)
    AngularDamping=200.0
    AngularStiffness=1000.0
    TickGroup="TG_PreAsyncWork"
}

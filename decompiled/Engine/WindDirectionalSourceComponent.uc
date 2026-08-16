class WindDirectionalSourceComponent extends ActorComponent
    native
    notplaceable
    editinlinenew
    collapsecategories
    hidecategories(Object);

var const native transient Pointer SceneProxy;
var() interp float Strength;
var() interp float Phase;
var() interp float Frequency;
var() interp float Speed;

defaultproperties
{
    Strength=1.0
    Frequency=1.0
    Speed=1.0
}

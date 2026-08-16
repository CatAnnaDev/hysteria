class PhysXDestructibleComponent extends PrimitiveComponent
    native
    notplaceable;

var RB_BodySetup DetailedCollision;
var array<byte> Fragmented;
var array<int> BoxElemStart;
var array<int> ConvexElemStart;

defaultproperties
{
    ReplacementPrimitive="None"
}

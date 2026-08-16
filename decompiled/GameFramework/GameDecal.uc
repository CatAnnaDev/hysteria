class GameDecal extends DecalComponent
    abstract
    native
    notplaceable
    editinlinenew
    hidecategories(Collision,Object,Physics,PrimitiveComponent);

var transient MaterialInstanceTimeVarying MITV_Decal;
var transient Pawn Instigator;

defaultproperties
{
    ReplacementPrimitive="None"
    MaxDrawDistance=4000.0
}

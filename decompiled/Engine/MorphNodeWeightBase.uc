class MorphNodeWeightBase extends MorphNodeBase
    abstract
    native
    notplaceable
    hidecategories(Object,Object,Object);

struct native MorphNodeConn
{
    var array<MorphNodeBase> ChildNodes;
    var name ConnName;
    var int DrawY;
};

var array<MorphNodeConn> NodeConns;

defaultproperties
{
    CategoryDesc="Weight"
}

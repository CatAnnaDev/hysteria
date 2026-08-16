class SeqAct_ChangeCollision extends SequenceAction
    native
    notplaceable
    hidecategories(Object);

var() const editconst bool bCollideActors;
var() const editconst bool bBlockActors;
var() const editconst bool bIgnoreEncroachers;
var() ECollisionType CollisionType;

static event int GetObjClassVersion()
{
    return GetObjClassVersion() + 4;
}

defaultproperties
{
    ObjName="Change Collision"
    ObjCategory="Actor"
}

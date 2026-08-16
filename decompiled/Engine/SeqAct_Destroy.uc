class SeqAct_Destroy extends SequenceAction
    notplaceable
    hidecategories(Object);

var() bool bDestroyBasedActors;
var() array<class<Actor>> IgnoreBasedClasses;

defaultproperties
{
    ObjName="Destroy"
    ObjCategory="Actor"
}

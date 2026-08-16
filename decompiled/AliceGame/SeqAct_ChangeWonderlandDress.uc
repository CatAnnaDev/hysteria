class SeqAct_ChangeWonderlandDress extends SequenceAction
    notplaceable
    hidecategories(Object);

var() EAliceWonderlandDresses AliceDress;
var() bool bShouldBlock;

defaultproperties
{
    bShouldBlock=True
    ObjName="Change Wonderland Dress"
    ObjCategory="Alice"
}

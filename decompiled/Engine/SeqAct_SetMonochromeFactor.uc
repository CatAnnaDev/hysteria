class SeqAct_SetMonochromeFactor extends SequenceAction
    native
    notplaceable
    hidecategories(Object);

var() float BlendTime;
var() float NewMonochromeFactor;

static event int GetObjClassVersion()
{
    return GetObjClassVersion() + 1;
}

defaultproperties
{
    BlendTime=3.0
    NewMonochromeFactor=1.0
    ObjName="Set Monochrome Factor"
    ObjCategory="Camera"
}

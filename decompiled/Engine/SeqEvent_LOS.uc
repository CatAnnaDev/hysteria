class SeqEvent_LOS extends SequenceEvent
    notplaceable
    hidecategories(Object);

var() float ScreenCenterDistance;
var() float TriggerDistance;
var() bool bCheckForObstructions;

static event int GetObjClassVersion()
{
    return GetObjClassVersion() + 1;
}

defaultproperties
{
    ScreenCenterDistance=50.0
    TriggerDistance=2048.0
    bCheckForObstructions=True
    OutputLinks(0)=(Links=(),LinkDesc="Look",bHasImpulse=False,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",ActivateDelay=0.0,DrawY=0,bHidden=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    OutputLinks(1)=(Links=(),LinkDesc="Stop Look",bHasImpulse=False,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",ActivateDelay=0.0,DrawY=0,bHidden=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    ObjName="Line Of Sight"
    ObjCategory="Pawn"
}

class SeqAct_UpgradeHealth extends SequenceAction
    notplaceable
    hidecategories(Object);

var() EUpgradeHealth Chapter;

defaultproperties
{
    InputLinks(0)=(LinkDesc="Enable",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    ObjName="Upgrade Health"
    ObjCategory="Persistent Data"
}

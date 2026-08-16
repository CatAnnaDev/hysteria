class SeqAct_AddRemoveFaceFXAnimSet extends SequenceAction
    notplaceable
    hidecategories(Object);

var() deprecated array<FaceFXAnimSet> FaceFXAnimSets;

defaultproperties
{
    InputLinks(0)=(LinkDesc="Add FaceFXAnimSets",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    InputLinks(1)=(LinkDesc="Remove FaceFXAnimSets",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    ObjName="Add Remove FaceFXAnimSet"
    ObjCategory="Pawn"
}

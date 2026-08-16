class SeqAct_ChapterCompleted extends SequenceAction
    notplaceable
    hidecategories(Object);

var() EChapterCompleted ChapterName;

defaultproperties
{
    InputLinks(0)=(LinkDesc="Enable",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    ObjName="Chapter Completed"
    ObjCategory="Persistent Data"
}

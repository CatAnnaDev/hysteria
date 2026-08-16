class SeqAct_Chapterpoint extends SeqAct_Latent
    notplaceable
    hidecategories(Object);

var() ChapterNameList LoadChapterName;

exec function LoadChapterPoint()
{
    GetWorldInfo().Game.MyCheckPointManager.LoadChapter(LoadChapterName);
}

event Activated()
{
    if (InputLinks[0].bHasImpulse)
    {
        LogInternal("load Checkpoint triggered from Kismet action" @ PathName(self));
        LoadChapterPoint();
    }
    OutputLinks[0].bHasImpulse = true;
}

defaultproperties
{
    bCallHandler=False
    bAutoActivateOutputLinks=False
    InputLinks(0)=(LinkDesc="Load",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    OutputLinks(0)=(Links=(),LinkDesc="Out",bHasImpulse=False,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",ActivateDelay=0.0,DrawY=0,bHidden=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    OutputLinks(1)=(Links=(),LinkDesc="Finished",bHasImpulse=False,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",ActivateDelay=0.0,DrawY=0,bHidden=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    ObjName="LoadChapterPoint"
    ObjCategory="CheckPoint"
}

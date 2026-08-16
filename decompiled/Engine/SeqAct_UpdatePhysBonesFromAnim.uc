class SeqAct_UpdatePhysBonesFromAnim extends SequenceAction
    notplaceable
    hidecategories(Object);

static event int GetObjClassVersion()
{
    return GetObjClassVersion() + 1;
}

defaultproperties
{
    InputLinks(0)=(LinkDesc="Update",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    InputLinks(1)=(LinkDesc="Disable Physics",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    InputLinks(2)=(LinkDesc="Enable Physics",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    ObjName="Force Phys Bones To Anim Pose"
    ObjCategory="Physics"
}

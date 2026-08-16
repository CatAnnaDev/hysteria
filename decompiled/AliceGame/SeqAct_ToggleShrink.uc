class SeqAct_ToggleShrink extends SequenceAction
    native
    notplaceable
    hidecategories(Object);

var() bool NeedShrink;

event ToggleShrinkMode(AlicePlayerController PC)
{
    if (NeedShrink)
    {
        if (!PC.bShrinkingModeActive)
        {
            PC.ChangeShrinkingMode();
        }
    }
    else if (PC.bShrinkingModeActive)
    {
        PC.UnShrinking();
    }
}

defaultproperties
{
    ObjName="Toggle Shrink"
    ObjCategory="Alice"
}

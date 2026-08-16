class AnimNotify extends Object
    abstract
    native
    notplaceable
    editinlinenew
    collapsecategories
    hidecategories(Object);

var() bool bLoadIfPhysXLevel0;
var() bool bLoadIfPhysXLevel1;
var() bool bLoadIfPhysXLevel2;

simulated function bool FindNextNotifyOfClass(AnimNodeSequence AnimSeqInstigator, class<AnimNotify> NotifyClass, out AnimNotifyEvent OutEvent)
{
    local AnimSequence Seq;
    local int I;
    local bool bFoundThis;
    
    if (AnimSeqInstigator.AnimSeq != none)
    {
        Seq = AnimSeqInstigator.AnimSeq;
        for (I = 0; I < Seq.Notifies.Length; I++)
        {
            if (Seq.Notifies[I].Notify == self)
            {
                bFoundThis = true;
            }
            if (bFoundThis && ClassIsChildOf(Seq.Notifies[I].Notify.Class, NotifyClass))
            {
                OutEvent = Seq.Notifies[I];
                return true;
            }
        }
    }
    return false;
}

defaultproperties
{
    bLoadIfPhysXLevel0=True
    bLoadIfPhysXLevel1=True
    bLoadIfPhysXLevel2=True
}

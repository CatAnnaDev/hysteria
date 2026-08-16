class AliceGameAnimNode_BlendBase extends AnimNodeBlendBase
    abstract
    native
    notplaceable
    hidecategories(Object,Object,Object);

var transient bool bIsExclusive;
var transient bool bIsSuspending;
var() bool bSuspendBranchWhenActivateChild;
var const bool bIsPlayingCustomAnim;

native function AnimNodeSequence GetCustomAnimNodeSequence()
{
}

defaultproperties
{
}

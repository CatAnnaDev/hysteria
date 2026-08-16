class AnimNodeRandom extends AnimNodeBlendList
    native
    notplaceable
    hidecategories(Object,Object,Object,Object,Object);

struct native RandomAnimInfo
{
    var() float Chance;
    var() byte LoopCountMin;
    var() byte LoopCountMax;
    var() float BlendInTime;
    var() Vector2D PlayRateRange;
    var() bool bStillFrame;
    var transient byte LoopCount;
};

var() editfixedsize editinline array<RandomAnimInfo> RandomInfo;
var transient AnimNodeSequence PlayingSeqNode;
var transient int PendingChildIndex;

defaultproperties
{
    PendingChildIndex=-1
    ActiveChildIndex=-1
    bSkipTickWhenZeroWeight=True
    CategoryDesc="Random"
}

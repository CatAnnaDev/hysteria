class AnimNodeCrossfader extends AnimNodeBlend
    native
    notplaceable
    hidecategories(Object,Object,Object,Object,Object);

var() name DefaultAnimSeqName;
var const bool bDontBlendOutOneShot;
var const float PendingBlendOutTimeOneShot;

native final function AnimNodeSequence GetActiveChild()
{
}

native final function name GetAnimName()
{
}

native final function BlendToLoopingAnim(name AnimSeqName, optional float BlendInTime, optional float Rate)
{
    AnimSeqName;
    BlendInTime;
    Rate;
}

native final function PlayOneShotAnim(name AnimSeqName, optional float BlendInTime, optional float BlendOutTime, optional bool bDontBlendOut, optional float Rate)
{
    AnimSeqName;
    BlendInTime;
    BlendOutTime;
    bDontBlendOut;
    Rate;
}

defaultproperties
{
}

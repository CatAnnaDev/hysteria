class SoundNodeDistanceCrossFade extends SoundNode
    native
    notplaceable
    editinlinenew
    hidecategories(Object,Object);

struct native DistanceDatum
{
    var() float FadeInDistanceStart;
    var() float FadeInDistanceEnd;
    var() float FadeOutDistanceStart;
    var() float FadeOutDistanceEnd;
    var() float Volume;
    var deprecated RawDistributionFloat FadeInDistance;
    var deprecated RawDistributionFloat FadeOutDistance;
};

var() export editfixedsize array<DistanceDatum> CrossFadeInput;

defaultproperties
{
}

class AnimNotify_PlayFaceFXAnim extends AnimNotify_Scripted
    native
    notplaceable
    editinlinenew
    collapsecategories
    hidecategories(Object);

var() FaceFXAnimSet FaceFXAnimSetRef;
var() string GroupName;
var() string AnimName;
var() SoundCue SoundCueToPlay;
var() bool bOverridePlayingAnim;
var() float PlayFrequency;

event EditorNotify(AnimNodeSequence AnimSeqInstigator)
{
    AnimSeqInstigator.SkelComponent.PlayFaceFXAnim(FaceFXAnimSetRef, AnimName, GroupName, SoundCueToPlay);
}

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    if (PlayFrequency < 1.0)
    {
        if (FRand() > PlayFrequency)
        {
            return;
        }
    }
    else if (PlayFrequency > 1.0)
    {
        LogInternal("Play FaceFX animation from notify" @ string(AnimSeqInstigator.AnimSeqName) @ "for" @ string(Owner) @ "GroupName:" @ GroupName @ "AnimName:" @ AnimName);
        LogInternal(" PlayFrequency > 1.0 is useless. Chance to play valid range is from 0.0 to 1.0.");
    }
    if (Owner != none)
    {
        if (Owner.CanActorPlayFaceFXAnim())
        {
            if (bOverridePlayingAnim || !Owner.IsActorPlayingFaceFXAnim())
            {
                Owner.PlayActorFaceFXAnim(FaceFXAnimSetRef, GroupName, AnimName, SoundCueToPlay);
            }
        }
    }
}

defaultproperties
{
    bOverridePlayingAnim=True
    PlayFrequency=1.0
}

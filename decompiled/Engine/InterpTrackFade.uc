class InterpTrackFade extends InterpTrackFloatBase
    native
    notplaceable
    collapsecategories
    hidecategories(Object);

var() bool bPersistFade;
var() Color FadeColor;

defaultproperties
{
    TrackInstClass="InterpTrackInstFade"
    TrackTitle="Fade"
    bOnePerGroup=True
    bDirGroupOnly=True
}

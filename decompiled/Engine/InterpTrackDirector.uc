class InterpTrackDirector extends InterpTrack
    native
    notplaceable
    collapsecategories
    hidecategories(Object);

struct native DirectorTrackCut
{
    var float Time;
    var float TransitionTime;
    var() name TargetCamGroup;
};

var array<DirectorTrackCut> CutTrack;
var() bool bSimulateCameraCutsOnClients;

defaultproperties
{
    bSimulateCameraCutsOnClients=True
    TrackInstClass="InterpTrackInstDirector"
    TrackTitle="Director"
    bOnePerGroup=True
    bDirGroupOnly=True
}

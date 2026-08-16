class InterpTrackMove extends InterpTrack
    native
    notplaceable
    collapsecategories
    hidecategories(Object);

enum EInterpTrackMoveRotMode
{
    IMR_Keyframed,
    IMR_LookAtGroup,
};

enum EInterpTrackMoveFrame
{
    IMF_World,
    IMF_RelativeToInitial,
};

struct native InterpLookupTrack
{
    var array<InterpLookupPoint> Points;
};

struct native InterpLookupPoint
{
    var name GroupName;
    var float Time;
};

var InterpCurveVector PosTrack;
var InterpCurveVector EulerTrack;
var InterpLookupTrack LookupTrack;
var() name LookAtGroupName;
var() float LinCurveTension;
var() float AngCurveTension;
var() bool bUseQuatInterpolation;
var() bool bShowArrowAtKeys;
var() bool bDisableMovement;
var() bool bShowTranslationOnCurveEd;
var() bool bShowRotationOnCurveEd;
var() bool bHide3DTrack;
var() bool bConsiderBaseTransform;
var() bool bRefreshPositionForAlice;
var() editconst EInterpTrackMoveFrame MoveFrame;
var() EInterpTrackMoveRotMode RotMode;

defaultproperties
{
    bShowTranslationOnCurveEd=True
    TrackInstClass="InterpTrackInstMove"
    TrackTitle="Movement"
    bOnePerGroup=True
}

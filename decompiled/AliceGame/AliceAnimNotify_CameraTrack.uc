class AliceAnimNotify_CameraTrack extends AnimNotify
    native
    notplaceable
    editinlinenew
    collapsecategories
    hidecategories(Object);

struct native CameraTrackSocket
{
    var() name SocketName;
    var() float KeyTime;
};

var() array<CameraTrackSocket> SocketArray;
var float ElapsedTime;
var float TotalTime;

defaultproperties
{
}

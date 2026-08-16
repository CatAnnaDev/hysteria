class SoundCue extends Object
    native
    notplaceable
    hidecategories(Object);

struct native export SoundNodeEditorData
{
    var const native int NodePosX;
    var const native int NodePosY;
};

var() editconst name SoundClass;
var SoundNode FirstNode;
var const native map<int, int> EditorData;
var transient float MaxAudibleDistance;
var() float VolumeMultiplier;
var() float PitchMultiplier;
var float Duration;
var() FaceFXAnimSet FaceFXAnimSetRef;
var() string FaceFXGroupName;
var() string FaceFXAnimName;
var() int MaxConcurrentPlayCount;
var const transient duplicatetransient int CurrentPlayCount;
var deprecated name SoundGroup;

native function float GetCueDuration()
{
}

defaultproperties
{
    VolumeMultiplier=0.75
    PitchMultiplier=1.0
    MaxConcurrentPlayCount=16
}

class SoundClass extends Object
    native
    notplaceable
    hidecategories(Object);

struct native SoundClassProperties
{
    var() float Volume;
    var() float Pitch;
    var() float StereoBleed;
    var() float LFEBleed;
    var() float VoiceCenterChannelVolume;
    var() float VoiceRadioVolume;
    var() bool bApplyEffects;
    var() bool bAlwaysPlay;
    var() bool bIsUISound;
    var() bool bIsMusic;
    var() bool bReverb;
};

struct native export SoundClassEditorData
{
    var const native int NodePosX;
    var const native int NodePosY;
};

var() SoundClassProperties Properties;
var() array<name> ChildClassNames;
var bool bIsChild;
var editoronly int MenuID;
var const native map<int, int> EditorData;

defaultproperties
{
    Properties=(Volume=1.0,Pitch=1.0,StereoBleed=0.25,LFEBleed=0.5,VoiceCenterChannelVolume=0.0,VoiceRadioVolume=0.0,bApplyEffects=False,bAlwaysPlay=False,bIsUISound=False,bIsMusic=False,bReverb=True)
}

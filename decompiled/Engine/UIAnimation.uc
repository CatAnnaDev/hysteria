class UIAnimation extends UIRoot
    abstract
    native
    notplaceable
    hidecategories(Object,UIRoot,Object);

enum EUIAnimNotifyType
{
    EANT_WidgetFunction,
    EANT_SceneFunction,
    EANT_KismetEvent,
    EANT_Sound,
};

enum EUIAnimationLoopMode
{
    UIANIMLOOP_None,
    UIANIMLOOP_Continuous,
    UIANIMLOOP_Bounce,
};

enum EUIAnimationInterpMode
{
    UIANIMMODE_Linear,
    UIANIMMODE_EaseIn,
    UIANIMMODE_EaseOut,
    UIANIMMODE_EaseInOut,
};

enum EUIAnimType
{
    EAT_None,
    EAT_Position,
    EAT_PositionOffset,
    EAT_RelPosition,
    EAT_Rotation,
    EAT_RelRotation,
    EAT_Color,
    EAT_Opacity,
    EAT_Visibility,
    EAT_Scale,
    EAT_Left,
    EAT_Top,
    EAT_Right,
    EAT_Bottom,
    EAT_PPBloom,
    EAT_PPBlurSampleSize,
    EAT_PPBlurAmount,
};

struct native transient UIAnimSequence
{
    var UIAnimationSeq SequenceRef;
    var array<UIAnimTrack> AnimationTracks;
    var EUIAnimationLoopMode LoopMode;
    var float PlaybackRate;
};

struct native UIAnimTrack
{
    var EUIAnimType TrackType;
    var array<UIAnimationKeyFrame> KeyFrames;
    var transient array<UIAnimationKeyFrame> LoopFrames;
};

struct native UIAnimationKeyFrame
{
    var float RemainingTime;
    var EUIAnimationInterpMode InterpMode;
    var float InterpExponent;
    var UIAnimationRawData Data;
};

struct native UIAnimationRawData
{
    var float DestAsFloat;
    var LinearColor DestAsColor;
    var Rotator DestAsRotator;
    var Vector DestAsVector;
    var UIAnimationNotify DestAsNotify;
};

struct native UIAnimationNotify
{
    var EUIAnimNotifyType NotifyType;
    var name NotifyName;
};

defaultproperties
{
}

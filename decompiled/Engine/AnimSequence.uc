class AnimSequence extends Object
    native
    notplaceable
    config(Engine)
    hidecategories(Object);

enum AnimationKeyFormat
{
    AKF_ConstantKeyLerp,
    AKF_VariableKeyLerp,
};

enum AnimationCompressionFormat
{
    ACF_None,
    ACF_Float96NoW,
    ACF_Fixed48NoW,
    ACF_IntervalFixed32NoW,
    ACF_Fixed32NoW,
    ACF_Float32NoW,
};

struct native AnimTag
{
    var string Tag;
    var array<string> Contains;
};

struct NativeStructGuy
{
    var Pointer dummydata0;
    var int dummyint1;
    var int dummyint2;
};

struct native CompressedTrack
{
    var array<byte> ByteStream;
    var array<float> Times;
    var float Mins[3];
    var float Ranges[3];
};

struct native CurveTrack
{
    var name CurveName;
    var array<float> CurveWeights;
};

struct native RotationTrack
{
    var array<Quat> RotKeys;
    var array<float> Times;
};

struct native TranslationTrack
{
    var array<Vector> PosKeys;
    var array<float> Times;
};

struct native SkelControlModifier
{
    var() name SkelControlName;
    var() editinline array<TimeModifier> Modifiers;
};

struct native TimeModifier
{
    var() float Time;
    var() float TargetStrength;
};

struct RawAnimSequenceTrack
{
    var array<Vector> PosKeys;
    var array<Quat> RotKeys;
};

struct native AnimNotifyEvent
{
    var() float Time;
    var() export editinline AnimNotify Notify;
    var() name Comment;
    var() float Duration;
};

var name SequenceName;
var() editinline array<AnimNotifyEvent> Notifies;
var() editconst array<float> NonSkipTimes;
var() export editinline array<AnimMetaData> MetaData;
var editinline deprecated array<SkelControlModifier> BoneControlModifiers;
var float SequenceLength;
var int NumFrames;
var() float RateScale;
var() bool bNoLoopingInterpolation;
var const bool bIsAdditive;
var editoronly bool bAdditiveBuiltLooping;
var() const editoronly bool bDoNotOverrideCompression;
var const transient bool bHasBeenUsed;
var const deprecated array<RawAnimSequenceTrack> RawAnimData;
var const native array<RawAnimSequenceTrack> RawAnimationData;
var const transient array<TranslationTrack> TranslationData;
var const transient array<RotationTrack> RotationData;
var const array<CurveTrack> CurveData;
var() editconst editinline editoronly AnimationCompressionAlgorithm CompressionScheme;
var const AnimationCompressionFormat TranslationCompressionFormat;
var const AnimationCompressionFormat RotationCompressionFormat;
var const AnimationKeyFormat KeyEncodingFormat;
var array<int> CompressedTrackOffsets;
var native NativeStructGuy CompressedByteStream;
var native transient Pointer CompressedByteData;
var native transient int CompressedByteDataSize;
var native transient int GpuTransferEntryId;
var native transient Pointer TranslationCodec;
var native transient Pointer RotationCodec;
var const deprecated array<BoneAtom> AdditiveRefPose;
var const array<RawAnimSequenceTrack> AdditiveBasePose;
var const editoronly name AdditiveRefName;
var editoronly array<AnimSequence> AdditiveBasePoseAnimSeq;
var editoronly array<AnimSequence> AdditiveTargetPoseAnimSeq;
var editoronly array<AnimSequence> RelatedAdditiveAnimSeqs;
var const int EncodingPkgVersion;
var const transient float UseScore;
var config editoronly array<AnimTag> AnimTags;

native function float GetNotifyTime(AnimNotify Notify)
{
    Notify;
}

native function float GetNotifyTimeByClass(class<AnimNotify> NotifyClass, optional float PlayRate = 1.0, optional float StartPosition = -1.0)
{
    NotifyClass;
    PlayRate;
    StartPosition;
}

defaultproperties
{
    RateScale=1.0
    bNoLoopingInterpolation=True
}

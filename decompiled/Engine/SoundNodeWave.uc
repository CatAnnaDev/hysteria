class SoundNodeWave extends SoundNode
    native
    notplaceable
    perobjectconfig
    editinlinenew
    hidecategories(Object,Object);

enum EDecompressionType
{
    DTYPE_Setup,
    DTYPE_Invalid,
    DTYPE_Preview,
    DTYPE_Native,
    DTYPE_RealTime,
    DTYPE_Procedural,
    DTYPE_Xenon,
};

var(Compression) int CompressionQuality;
var(Compression) bool bForceRealTimeDecompression;
var(Compression) bool bLoopingSound;
var const transient bool bDynamicResource;
var(TTS) bool bUseTTS;
var transient bool bProcedural;
var transient bool bIsFlaggedForUnload;
var(Subtitles) const localized bool bMature;
var(Subtitles) const localized bool bManualWordWrap;
var(TTS) ETTSSpeaker TTSSpeaker;
var const transient EDecompressionType DecompressionType;
var(TTS) const localized string SpokenText;
var(Info) const editconst float Volume;
var(Info) const editconst float Pitch;
var(Info) const editconst float Duration;
var(Info) const editconst int NumChannels;
var(Info) const editconst int SampleRate;
var const array<int> ChannelOffsets;
var const array<int> ChannelSizes;
var const native UntypedBulkData_Mirror RawData;
var const native Pointer VorbisDecompressor;
var const native Pointer RawPCMData;
var const int RawPCMDataSize;
var const native UntypedBulkData_Mirror CompressedPCData;
var const native UntypedBulkData_Mirror CompressedXbox360Data;
var const native UntypedBulkData_Mirror CompressedPS3Data;
var const transient int ResourceID;
var const transient int ResourceSize;
var const native Pointer ResourceData;
var(Subtitles) const localized array<SubtitleCue> Subtitles;
var(Subtitles) const localized editoronly string Comment;
var array<LocalizedSubtitle> LocalizedSubtitles;
var() const editconst editoronly string SourceFilePath;
var() const editconst editoronly string SourceFileTimestamp;

event GeneratePCMData(out array<byte> Buffer, int SamplesNeeded)
{
}

defaultproperties
{
    CompressionQuality=40
    bLoopingSound=True
    Volume=0.75
    Pitch=1.0
}

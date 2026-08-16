class SoundNodeWaveStreaming extends SoundNodeWave
    native
    notplaceable
    perobjectconfig
    editinlinenew
    hidecategories(Object,Object);

var array<byte> QueuedAudio;

native event GeneratePCMData(out array<byte> Buffer, int SamplesNeeded)
{
    Buffer;
    SamplesNeeded;
}

native event int AvailableAudioBytes()
{
}

native event ResetAudio()
{
}

native event QueueAudio(array<byte> Data)
{
    Data;
}

defaultproperties
{
    bLoopingSound=False
    bProcedural=True
}

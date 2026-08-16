class TextureMovie extends Texture
    native
    notplaceable
    hidecategories(Object);

enum EMovieStreamSource
{
    MovieStream_File,
    MovieStream_Memory,
};

var const int SizeX;
var const int SizeY;
var const EPixelFormat Format;
var() TextureAddress AddressX;
var() TextureAddress AddressY;
var() EMovieStreamSource MovieStreamSource;
var const class<CodecMovie> DecoderClass;
var const transient CodecMovie Decoder;
var const transient bool Paused;
var const transient bool Stopped;
var() bool Looping;
var() bool AutoPlay;
var const native UntypedBulkData_Mirror Data;
var const native transient Pointer ReleaseCodecFence;

native function Stop()
{
}

native function Pause()
{
}

native function Play()
{
}

defaultproperties
{
    MovieStreamSource="MovieStream_Memory"
    DecoderClass="CodecMovieFallback"
    Looping=True
    AutoPlay=True
    NeverStream=True
}

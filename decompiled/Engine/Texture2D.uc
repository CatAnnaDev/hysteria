class Texture2D extends Texture
    native
    notplaceable
    hidecategories(Object);

struct TextureLinkedListMirror
{
    var const native Pointer Element;
    var const native Pointer Next;
    var const native Pointer PrevLink;
};

struct native Texture2DMipMap
{
    var native UntypedBulkData_Mirror Data;
    var native int SizeX;
    var native int SizeY;
};

var const native IndirectArray_Mirror Mips;
var const native IndirectArray_Mirror CachedPVRTCMips;
var const int SizeX;
var const int SizeY;
var const int OriginalSizeX;
var const int OriginalSizeY;
var const EPixelFormat Format;
var() TextureAddress AddressX;
var() TextureAddress AddressY;
var const transient bool bIsStreamable;
var const transient bool bHasCancelationPending;
var const transient bool bHasBeenLoadedFromPersistentArchive;
var transient bool bForceMiplevelsToBeResident;
var() const bool bGlobalForceMipLevelsToBeResident;
var transient float ForceMipLevelsToBeResidentTimestamp;
var name TextureFileCacheName;
var const native Guid TextureFileCacheGuid;
var const transient int RequestedMips;
var const transient int ResidentMips;
var const native transient ThreadSafeCounter PendingMipChangeRequestStatus;
var array<byte> SystemMemoryData;
var const native duplicatetransient TextureLinkedListMirror StreamableTexturesLink;
var const int MipTailBaseIdx;
var const native transient Pointer ResourceMem;
var const native transient int FirstResourceMemMip;
var const native transient float Timer;

native static final function Texture2D Create(int InSizeX, int InSizeY, optional EPixelFormat InFormat = 2)
{
    InSizeX;
    InSizeY;
    InFormat;
}

native final function SetForceMipLevelsToBeResident(float Seconds, optional int CinematicTextureGroups = 0)
{
    Seconds;
    CinematicTextureGroups;
}

defaultproperties
{
}

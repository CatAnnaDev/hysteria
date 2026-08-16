class GameTypes extends Object
    native
    notplaceable;

const LOADING_MOVIE = "LoadingMovie";

enum EShakeParam
{
    ESP_OffsetRandom,
    ESP_OffsetZero,
};

struct native SpecialMoveStruct
{
    var name SpecialMoveName;
    var GamePawn InteractionPawn;
    var Actor InteractionActor;
    var int Flags;
};

struct native GameSpecialMoveInfo
{
    var() name SpecialMoveName;
    var() class<GameSpecialMove> SpecialMoveClass;
    var() GameSpecialMove SpecialMoveInstance;
};

struct native TakeHitInfo
{
    var Vector HitLocation;
    var Vector Momentum;
    var class<DamageType> DamageType;
    var Pawn InstigatedBy;
    var byte HitBoneIndex;
    var PhysicalMaterial PhysicalMaterial;
    var float Damage;
    var Vector RadialDamageOrigin;
};

struct native ScreenShakeStruct
{
    var float TimeToGo;
    var float TimeDuration;
    var Vector RotAmplitude;
    var Vector RotFrequency;
    var Vector RotSinOffset;
    var ShakeParams RotParam;
    var Vector LocAmplitude;
    var Vector LocFrequency;
    var Vector LocSinOffset;
    var ShakeParams LocParam;
    var float FOVAmplitude;
    var float FOVFrequency;
    var float FOVSinOffset;
    var EShakeParam FOVParam;
    var name ShakeName;
    var bool bOverrideTargetingDampening;
    var float TargetingDampening;
};

struct native ShakeParams
{
    var EShakeParam X;
    var EShakeParam Y;
    var EShakeParam Z;
    var const transient byte Padding;
};

struct native ScreenShakeAnimStruct
{
    var CameraAnim Anim;
    var bool bUseDirectionalAnimVariants;
    var CameraAnim Anim_Left;
    var CameraAnim Anim_Right;
    var CameraAnim Anim_Rear;
    var float AnimPlayRate;
    var float AnimScale;
    var float AnimBlendInTime;
    var float AnimBlendOutTime;
    var bool bRandomSegment;
    var float RandomSegmentDuration;
    var bool bSingleInstance;
};

defaultproperties
{
}

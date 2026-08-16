class CheshireCatSpawnPoint extends Keypoint
    placeable
    hidecategories(Navigation);

struct HintsComponent
{
    var() SoundCue SoundCue;
    var() name Anim;
    var() Actor Target;
    var() bool bOrientToTarget;
    var() Actor LookAtTarget;
};

var CheshireCatSkeletalMeshActor CheshireCatSkelActor;
var() array<HintsComponent> CheshireCatHintsComponent;
var() array<HintsComponent> CheshireCatUltimateHintComponent;
var() bool bRandomizeHints;
var() bool bRandomizeUltimateHints;
var(CameraMagnet) bool bFocusCamera;
var bool bInitialized;
var bool bUltimateHint;
var bool bPlayHintsOver;
var bool bSoundOnlyZone;
var bool bUsed;
var bool bPlayFaceFXAnim;
var() int MaxNumberOfHintBeforeUltimateHint;
var() float TimeBeforeDisappear;
var() float FadeInTime;
var() float FadeOutTime;
var(CameraMagnet) int InterpolateSpeed;
var(CameraMagnet) float EaseIn;
var(CameraMagnet) float EaseOut;
var(CameraMagnet) float TargetRadius;
var(CameraMagnet) Vector MagnetOffset;
var array<int> HintIndices;
var array<int> UltimateHintIndices;
var int HintIndicesLength;
var int CurrentHint;
var int nPlayedHints;
var int CurrentUltimateHint;
var int nPlayedUltimateHint;
var CheshireCatVolume CheshireCatVolume;
var export editinline AudioComponent CatAudioComponent;
var export editinline SkeletalMeshComponent CatBody;
var SoundCue AppearSound;
var SoundCue DisappearSound;

function bool IsInNoHintZone()
{
    if (CheshireCatVolume != none)
    {
        return CheshireCatVolume.bNoHintsZone;
    }
    else
    {
        return false;
    }
}

function CheshireCatVolume GetCheshireCatVolume()
{
    local CheshireCatVolume CCVolume;
    
    foreach WorldInfo.AllActors(class'CheshireCatVolume', CCVolume)
    {
        if (CCVolume.IsInside(Location))
        {
            return CCVolume;
        }
    }
    return none;
}

function Initialize()
{
    local int Idx;
    local bool bApplyOrientToTarget;
    local int Index;
    local Actor OrientTarget;
    
    CurrentHint = -1;
    CurrentUltimateHint = -1;
    bUltimateHint = false;
    nPlayedUltimateHint = 0;
    nPlayedHints = 0;
    bPlayHintsOver = false;
    CheshireCatSkelActor = AlicePawn(WorldInfo.GetLocalPlayerPawn()).GetCheshireCatSkelActor();
    if (CheshireCatSkelActor != none)
    {
        CatAudioComponent = CheshireCatSkelActor.CatAudioComponent;
        CheshireCatSkelActor.SetLocation(Location);
        CheshireCatSkelActor.SetRotation(Rotation);
        CheshireCatSkelActor.FadeInTime = FadeInTime;
        CheshireCatSkelActor.FadeOutTime = FadeOutTime;
    }
    if (bRandomizeHints)
    {
        HintIndices.Length = 0;
        for (Idx = 0; Idx < CheshireCatHintsComponent.Length; Idx++)
        {
            HintIndices.AddItem(Idx);
        }
        HintIndicesLength = HintIndices.Length;
    }
    if (bRandomizeUltimateHints)
    {
        UltimateHintIndices.Length = 0;
        for (Idx = 0; Idx < CheshireCatUltimateHintComponent.Length; Idx++)
        {
            UltimateHintIndices.AddItem(Idx);
        }
    }
    bInitialized = true;
    SetCollisionType(1);
    bApplyOrientToTarget = false;
    for (Index = 0; Index < CheshireCatHintsComponent.Length; Index++)
    {
        if (CheshireCatHintsComponent[Index].bOrientToTarget)
        {
            bApplyOrientToTarget = true;
            OrientTarget = CheshireCatHintsComponent[Index].Target;
            break;
        }
    }
    if (bApplyOrientToTarget == false)
    {
        for (Index = 0; Index < CheshireCatUltimateHintComponent.Length; Index++)
        {
            if (CheshireCatUltimateHintComponent[Index].bOrientToTarget)
            {
                bApplyOrientToTarget = true;
                OrientTarget = CheshireCatUltimateHintComponent[Index].Target;
                break;
            }
        }
    }
    if (bApplyOrientToTarget)
    {
        if (OrientTarget != none)
        {
            OrientToTarget(OrientTarget);
        }
        else
        {
            OrientToTarget(WorldInfo.GetLocalPlayerPawn());
        }
    }
}

function Disappear()
{
    SetHidden(true);
    SetCollisionType(1);
    if (CheshireCatSkelActor != none)
    {
        CheshireCatSkelActor.Disappear();
    }
    ClearTimer('OnCheshireCatDisappear');
    Disable('Tick');
}

function CheshireCatAppear()
{
    local bool bCatHidden;
    
    if (bSoundOnlyZone)
    {
        if (CheshireCatSkelActor != none)
        {
            CheshireCatSkelActor.SetHidden(true);
        }
        SetHidden(true);
    }
    else
    {
        if (CheshireCatSkelActor != none)
        {
            bCatHidden = CheshireCatSkelActor.bHidden;
            CheshireCatSkelActor.SetHidden(false);
            if (bCatHidden)
            {
                CheshireCatSkelActor.MorphIn();
            }
        }
        SetHidden(false);
    }
    PlaySound(AppearSound);
}

event OnCheshireCatDisappear()
{
    Disappear();
}

function OnCheshireCatFadeOut()
{
    PlaySound(DisappearSound);
    CheshireCatSkelActor.MorphOut();
    ClearTimer('OnCheshireCatFadeOut');
    SetTimer(CheshireCatSkelActor.FadeOutTime, false, 'OnCheshireCatDisappear');
}

function OnPlayFaceFXAnimOver()
{
    local AlicePlayerController APC;
    
    if (nPlayedHints == CheshireCatHintsComponent.Length && nPlayedUltimateHint == CheshireCatUltimateHintComponent.Length)
    {
        TriggerEventClass(class'SeqEvent_CheshireCatAllHintsUsed', self);
        OnCheshireCatFadeOut();
    }
    else
    {
        SetTimer(TimeBeforeDisappear, false, 'OnCheshireCatFadeOut');
    }
    Disable('Tick');
    APC = AlicePlayerController(WorldInfo.GetLocalPlayerPawn().Controller);
    if (APC != none)
    {
        APC.DisableCheshireCatMagnet();
    }
    bPlayFaceFXAnim = false;
}

function bool IsPlayingHint()
{
    return CatAudioComponent.IsPlaying();
}

event Tick(float DeltaTime)
{
    if (CheshireCatSkelActor != none && bPlayFaceFXAnim && !CheshireCatSkelActor.IsActorPlayingFaceFXAnim() || !bPlayFaceFXAnim && CatAudioComponent.bFinished)
    {
        OnPlayFaceFXAnimOver();
    }
}

function SetLookAtTarget(Actor LookAtTarget)
{
    if (LookAtTarget != none)
    {
        CheshireCatSkelActor.SetLookAtTarget('HeadLook', LookAtTarget);
    }
    else
    {
        CheshireCatSkelActor.SetLookAtTarget('HeadLook', WorldInfo.GetLocalPlayerPawn());
    }
}

function OrientToTarget(Actor Target)
{
    local Vector Dir;
    local Rotator CatNewRotator;
    
    if (Target != none)
    {
        Dir = Target.Location - Location;
        CatNewRotator = CheshireCatSkelActor.Rotation;
        CatNewRotator.Yaw = rotator(Dir).Yaw;
        CheshireCatSkelActor.SetRotation(CatNewRotator);
    }
}

function PlayHintSoundCue(SoundCue SC)
{
    if (SC != none)
    {
        bPlayFaceFXAnim = CheshireCatSkelActor.PlayActorFaceFXAnim(SC.FaceFXAnimSetRef, SC.FaceFXGroupName, SC.FaceFXAnimName, SC);
        if (!CheshireCatSkelActor.IsActorPlayingFaceFXAnim() || bSoundOnlyZone)
        {
            CatAudioComponent.SoundCue = SC;
            CatAudioComponent.SubtitlePriority = 100.0;
            CatAudioComponent.Play();
        }
    }
}

function PlayHintAnimation(name AnimName)
{
    CheshireCatSkelActor.PlayCustomAnim(AnimName, 1.0, 0.2, 0.2, true);
}

function PlayHintContent(HintsComponent HintContent)
{
    PlayHintAnimation(HintContent.Anim);
    PlayHintSoundCue(HintContent.SoundCue);
    SetLookAtTarget(HintContent.LookAtTarget);
}

function PlayUltimateHint()
{
    local int RandIndex;
    
    if (CheshireCatUltimateHintComponent.Length == 0)
    {
        bPlayHintsOver = true;
        bUsed = true;
        AlicePlayerController(WorldInfo.GetLocalPlayerPawn().Controller).showCat(false);
        return;
    }
    if (bRandomizeUltimateHints)
    {
        RandIndex = Rand(UltimateHintIndices.Length);
        CurrentUltimateHint = UltimateHintIndices[RandIndex];
        UltimateHintIndices.RemoveItem(CurrentUltimateHint);
    }
    else
    {
        CurrentUltimateHint++;
    }
    if (CurrentUltimateHint < CheshireCatUltimateHintComponent.Length)
    {
        nPlayedUltimateHint++;
        PlayHintContent(CheshireCatUltimateHintComponent[CurrentUltimateHint]);
    }
    if (nPlayedUltimateHint >= CheshireCatUltimateHintComponent.Length)
    {
        bPlayHintsOver = true;
        bUsed = true;
        AlicePlayerController(WorldInfo.GetLocalPlayerPawn().Controller).showCat(false);
    }
}

function PlayHint()
{
    local int RandIndex;
    
    if (CheshireCatHintsComponent.Length == 0)
    {
        bUltimateHint = true;
        PlayUltimateHint();
        return;
    }
    if (bRandomizeHints)
    {
        RandIndex = Rand(HintIndicesLength);
        CurrentHint = HintIndices[RandIndex];
        HintIndices.RemoveItem(CurrentHint);
        HintIndices.AddItem(CurrentHint);
        HintIndicesLength--;
        if (HintIndicesLength <= 0)
        {
            HintIndicesLength = HintIndices.Length;
        }
    }
    else
    {
        CurrentHint++;
    }
    if (CurrentHint < CheshireCatHintsComponent.Length)
    {
        nPlayedHints++;
        PlayHintContent(CheshireCatHintsComponent[CurrentHint]);
    }
    if (MaxNumberOfHintBeforeUltimateHint == 0 && nPlayedHints >= CheshireCatHintsComponent.Length || nPlayedHints == MaxNumberOfHintBeforeUltimateHint)
    {
        bUltimateHint = true;
    }
    if (nPlayedHints == CheshireCatHintsComponent.Length && CheshireCatUltimateHintComponent.Length == 0)
    {
        bUsed = true;
        AlicePlayerController(WorldInfo.GetLocalPlayerPawn().Controller).showCat(false);
    }
}

function Play()
{
    if (bUltimateHint)
    {
        PlayUltimateHint();
    }
    else
    {
        PlayHint();
    }
    ClearTimer('OnCheshireCatFadeOut');
    ClearTimer('OnCheshireCatDisappear');
    Enable('Tick');
}

function OnPressHintButton()
{
    if (IsInNoHintZone() || IsPlayingHint())
    {
        return;
    }
    if (!bInitialized)
    {
        Initialize();
    }
    if (CheshireCatSkelActor.bMorphing)
    {
        return;
    }
    CheshireCatAppear();
    SetTimer(FadeInTime + 0.02, false, 'Play');
}

event PostBeginPlay()
{
    PostBeginPlay();
    CheshireCatVolume = GetCheshireCatVolume();
    if (CheshireCatVolume != none)
    {
        bSoundOnlyZone = CheshireCatVolume.bSoundOnlyZone;
    }
    DetachComponent(CatBody);
    Disable('Tick');
}

defaultproperties
{
    bFocusCamera=True
    TimeBeforeDisappear=3.0
    FadeInTime=1.5
    FadeOutTime=1.5
    InterpolateSpeed=60
    EaseIn=0.5
    EaseOut=0.5
    TargetRadius=100.0
    MagnetOffset=(X=100.0,Y=100.0,Z=-100.0)
    CurrentHint=-1
    CurrentUltimateHint=-1
    CatBody="Default__CheshireCatSpawnPoint.SkeletalMeshCatBody"
    AppearSound="SFX_Cat.sfx_cat_appear_mono_Cue"
    DisappearSound="SFX_Cat.sfx_cat_dissappear_mono_Cue"
    SpriteComp="Default__CheshireCatSpawnPoint.Sprite"
    bStatic=False
    Components(0)="Default__CheshireCatSpawnPoint.Sprite"
    Components(1)="Default__CheshireCatSpawnPoint.CollisionCylinder"
    Components(2)="Default__CheshireCatSpawnPoint.SkeletalMeshCatBody"
    CollisionType="COLLIDE_NoCollision"
    TickFrequency=0.1
    CollisionComponent="Default__CheshireCatSpawnPoint.CollisionCylinder"
    SupportedEvents(0)="Engine.SeqEvent_Touch"
    SupportedEvents(1)="Engine.SeqEvent_Destroyed"
    SupportedEvents(2)="Engine.SeqEvent_TakeDamage"
    SupportedEvents(3)="Engine.SeqEvent_HitWall"
    SupportedEvents(4)="SeqEvent_CheshireCatAllHintsUsed"
}

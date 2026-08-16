class AlicePlayerController extends GamePlayerController
    native
    notplaceable
    config(Game)
    hidecategories(Navigation);

enum EWeaponHand
{
    HAND_Right,
    HAND_Left,
    HAND_Centered,
    HAND_Hidden,
};

enum EMovementCategory
{
    EMC_Stand,
    EMC_Combat,
    EMC_Climb,
};

enum EGameLevel
{
    EGL_AnyLevel,
    EGL_London,
    EGL_Wonderland,
};

struct native ButtonInputStatus
{
    var ESpecialButtonInput BtnType;
    var bool Button_In_Pressed;
    var bool HoldFinshedEventDone;
    var bool bInDoingHoldFinishEvent;
    var bool bInDoingTap2HoldEvent;
    var float TapTime;
    var float HoldTime;
    var name ButtonName;
};

struct CheckpointRecord
{
    var Vector Location;
    var Rotator Rotation;
    var int Health;
    var array<ObjectiveInfo> Objectives;
    var EAliceArcheType AliceArcheTypeID;
    var EAliceWonderlandDresses StoryModeSaveDressID;
};

struct native ObjectiveInfo
{
    var() name ObjectiveName;
    var() string ObjectiveDesc;
    var() bool bUpdated;
    var() bool bCompleted;
    var() bool bFailed;
    var() float UpdatedTime;
    var bool bNotifyPlayer;
};

struct native RespawnInfo
{
    var EGameLevel Level;
    var ParticleSystem ParticleRespawn;
    var SoundCue ParticleRespawnSound;
};

var transient AlicePawn MyAlicePawn;
var transient editinline PlayerInput SecondPlayerInput;
var bool bSupportSecondController;
var bool bProjectInputToControllerSpace;
var bool bProjectInputToPreCameraSpace;
var bool bFirstPersonViewActive;
var bool bShowFPS_Reticule;
var transient bool bEnterFPSByRSPress;
var transient bool bJournalPause;
var bool bConfirmToRespawn;
var bool bCanSwitchMelee;
var bool bInputAForwardChangedSinceClimbing;
var transient bool bFireToActivateLockOnMode;
var config bool bHoldTiggerToMaintainTargeting;
var transient bool bLockOnTriggeredByShiftKey;
var bool bTargetingModeActive;
var bool bUseLockOnCameraParameters;
var config bool bEnableARM;
var bool bTargetSwitched;
var transient bool bCanDoDodge;
var transient bool bCanDoDeflect;
var bool bShrinkingModeActive;
var bool bCanNotGrowBig;
var bool ShrinkingCoolDown;
var bool bCanFloatJump;
var bool bTriggerFloatJump;
var bool bAllowForceResetCamera;
var bool bAllowAutoResetCamera;
var bool bAutoResetCamCountingTimer;
var bool bEnableCameraInertia;
var bool bCameraReset;
var bool bFastSwimTurning;
var bool bKeepAliceInFocus;
var bool bCameraRightStickFree;
var bool bSpecialCameraEnabled;
var bool bSpecialTargetCamera;
var bool bCameraInterpEnabled;
var bool bCanSwimTurnLeftOrRight;
var bool bInMainMenu;
var transient bool bTargetUIPrevCritical;
var bool bPOIOverrideCamera;
var bool bPOITriggered;
var bool bCameraLocOnLeft;
var bool bLookingAtPointOfInterest;
var bool bIsHoldingPOIButton;
var bool bCameraLookAtIsFromKismet;
var transient bool bPendingConversationAbort;
var transient bool bHavingAnAbortableConversation;
var bool bPressedBackButton;
var bool bCanControlWhenSlide;
var bool bCanJumpWhenSlide;
var bool bAlreadyCarried;
var bool bEnableFloat;
var bool bCancelMatineeHintExisting;
var bool bInFloatVolume;
var bool IsShrinking;
var bool IsUnShrinking;
var bool bDelayCameraInSteam;
var bool bFloatLeaveSteam;
var bool bEnableWeaponEnviormentCollision;
var bool bTryUnShrinkNow;
var bool bSteamVentRotating;
var bool bInRailRideMode;
var transient bool bBoostRoll;
var transient bool bBoostVolumeActive;
var transient bool bBoostVolumeFalloff;
var transient bool bMaintainMovement;
var bool bJumpFromJumpPad;
var bool bLockOnStateFirstFrame;
var bool bJustAfterFloatFail;
var bool bSwitchWeaponOnly;
var bool bToggleCheshireCatOn;
var transient bool bHoldToggleLockOnButton;
var transient bool bPendingShrinkRequest;
var transient bool FlagComboInputAcceptStart;
var transient bool FlagComboInputAcceptFinish;
var transient bool FlagComboBlendingStart;
var transient bool FlagHasComboInputBeforeBlendingStart;
var transient bool bPauseTickForNextClockBomb;
var bool bVentLastTickMove;
var bool bVentLastTickRotate;
var bool bAimOnTarget;
var bool bPickupAction;
var bool bLastTickOnGround;
var bool bInUIMode;
var bool UI_bUpdateKeySettings;
var transient bool bPendingQuitLockOnMode;
var transient bool bPendingQuitAimingMode;
var float CommandFOVScale;
var int CommandCameraRoll;
var int CommandCameraRollDir;
var Vector CommandCameraOffset;
var Vector CommandCameraOffsetSpeed;
var Vector CommandCameraOffsetMax;
var Vector CommandCameraOffsetMin;
var Rotator UI_AliceTargetRotation;
var Rotator PreCameraRot;
var Rotator OldCameraRot;
var CameraActor PreCameraActor;
var Actor AimingReticuleTarget;
var Vector AimingReticuleLocation;
var transient float aTurnElapsedTime;
var transient float aLookUpElapsedTime;
var transient float aOldTurn;
var transient float aOldLookUp;
var Vector CrossHairLocation;
var transient Vector CrossHairLocation2D;
var transient Actor BackUpNonLockOnTarget;
var RespawnInfo respawn_info;
var Emitter RespawnParticleEmitter;
var EAliceWonderlandDresses StoryModeSaveDressID;
var transient EDodgeDirection PendingDodge;
var EWeaponHand WeaponHand;
var transient EAliceCombatAbilityInput CombatInputBeforeBlendingStart;
var ESpecialMove curSteamAnim;
var byte UI_CurActiveKeyType;
var byte UI_CurActiveKeyGroup;
var float PlayedSecond;
var int DestroyedDoomBarriers;
var int FrozenTotalCountEnemy;
var int DefeatTotalRuinNpcs;
var int DefeatTotalCardGuardNpcs;
var int Achievements43Npcs;
var int Achievements30Npcs;
var int AchievementsNew38Npcs;
var AliceObjectiveManager ObjectiveMgr;
var float AccelThresholdToRun;
var const float AngleThresholdToCancelAccel;
var float AngleBetweenInputAndPlayer;
var Vector PawnDirWhenRotateStarts;
var transient array<AlicePlayer_MovementStateBase> PlayerMovementStates;
var array<class<Object>> PlayerMovementStatesClasses;
var int curIndexOfPlayerMovementState;
var Rotator BackupedCamRot;
var transient TargetingMode_CombatLockon TMode_CombatLockOn;
var transient TargetingMode_PointOfInterest TMode_POI;
var transient TargetingMode_BreakableActor TMode_BreakableActor;
var transient TargetingMode_SkeletalMeshActor TMode_SkeletalMeshActor;
var transient TargetingMode_MergeManager TargetMergeManager;
var transient PreTargetingMode_MergeManager PreTargetMergeManager;
var int nLastMeleeWeapon;
var transient Vector TargetNPCSocketLocation2D;
var transient TargetingNPCInfo TargetNPCSocket;
var transient BreakableActorLockOnInfo TargetBActorInfo;
var transient SkeletalMeshActorLockOnInfo TargetSMAInfo;
var transient TargetingNPCInfo PreTargetNPCSocket;
var transient BreakableActorLockOnInfo PreTargetBActorInfo;
var transient SkeletalMeshActorLockOnInfo PreTargetSMAInfo;
var SoundCue Snd_TargetLockOn;
var SoundCue Snd_TargetLockOff;
var SoundCue Snd_TargetLockSwitch;
var SoundCue CloseInGameMenuSound;
var transient PostProcessEffect LockOnEffect;
var transient ButtonInputStatus CurButtonStatus;
var float InputaUp;
var float ClimbingTime;
var int OldPitch;
var float fTimeToTriggerAutoResetCamera;
var Vector SpecialCameraLoc;
var Rotator SpecialCameraRot;
var SeqAct_SpecialCameraBehavior CurSpecialCameraBehavior;
var Vector CameraInterpFocusPoint;
var Actor CameraInterpFocusActor;
var int WeaponLevel[4];
var int iFirstTimeWeaponUpgrade;
var int CaveCompleted[16];
var int MemoryCompleted[5];
var int ChapterCompleted[6];
var int ChapterCompletedHighestDifficulty[6];
var int UnlockEnemy[20];
var int UpgradeHealth[6];
var int TheVeryLastCheckPointGot;
var float CompletePercent;
var array<string> BinkPlayed;
var array<string> AbilityGot;
var array<string> MemoryFragment;
var array<string> SountActive;
var array<string> SecretPick;
var transient int PendingRangeWeaponType;
var transient int LatestRangeWeaponType;
var transient int LastPresenceSet[4];
var Vector WaterWalkLandPos;
var Vector BackToSwimPos;
var float SwimPitch;
var float SwimRoll;
var float SwimUpDownDelay;
var SoundCue Sound_PGTOTC;
var SoundCue Sound_TCTOPG;
var Vector PushDir;
var Vector PushInitOffset;
var Vector CratePos;
var array<AlicePointOfInterest> EnabledPointsOfInterest;
var array<bool> POILookedAtList;
var AlicePointOfInterest CurrLookedAtPOI;
var SoundCue PointOfInterestAdded;
var float LastPoITime;
var() float PoIRepeatTime;
var array<AliceCameraMagnet> CameraMagnets;
var AliceCameraMagnet CheshireCatMagnet;
var AliceCameraMagnet ShowPathMagnet;
var Actor CameraLookAtFocusActor;
var() Vector2D PointOfInterestLookatInterpSpeedRange;
var EmitterCameraLensEffectBase CameraEffect;
var float fBackButtonHoldTime;
var AliceCombatInputManager CombatInputManager;
var float LeaveGlideTime;
var Rotator GlideRotation;
var float GlideAccumulateYaw;
var float GlideYawThreshold;
var float LastRawJoyRight;
var AssetActor AssetActor;
var AliceGFXMovieInput GFXMovieInput;
var AliceGFXMovie FocusedMovie;
var AliceHoverVolume SteamVentVolume;
var AliceVentActor ventActor;
var array<Turret2DManager> AliceTurret2DManager;
var ParticleSystem SlideParticle;
var AliceChessBoard ChessBoardActor;
var AliceBlockPuzzleBoard BlockPuzzleActor;
var int CrowdAgentsCount;
var int SlowFactor;
var Emitter SlideLoopingEmitter;
var transient float BoostVolumeTime;
var transient Vector BoostVolumeForce;
var transient float BoostVolumeDuration;
var transient Vector OriginalInputVector;
var transient float fTimeThresholdToMaintainMove;
var transient float fTimeLeftToMaintainMove;
var AliceCycleFloatManager CycleFloatManager;
var AliceSoundModeManager SoundModeManager;
var AliceConfigDataManager configDataManager;
var AlicePersistentDataManager persistentDataManager;
var int WeaponGroup;
var AliceSonarManager SonarManager;
var float LastSwitchTargetTime;
var float LastTickRSValue;
var export editinline AudioComponent slideLoopAudio;
var SoundCue slideLoopSoundCue;
var float fAliceIdleDuration;
var float fOldAliceIdleDuration;
var SeqAct_InteractInLondon InteractLondonActor;
var AliceStuckManager stuckManager;
var int GiantAliceTakeDamageCount;
var int AgentDamage;
var transient int LockonModeDeltaYaw;
var Actor FacingSlideTarget;
var export editinline AudioComponent pinballSoundComp1;
var export editinline AudioComponent pinballSoundComp2;
var SoundCue pinballSound1;
var SoundCue pinballSound2;
var export editinline AudioComponent meleeSlomoSoundComp;
var SoundCue MeleeSlomoSoundCue;
var export editinline AudioComponent uniqueAudio;
var float UI_RotateSpeed;
var array<int> UI_RemovedAliceKeys;
var AliceGFXMovie UI_AliceGFXMovie;
var int UI_CurControllerType;
var config int WeaponUpgradeToLevel2XPCost[4];
var config int WeaponUpgradeToLevel3XPCost[4];
var config int WeaponUpgradeToLevel4XPCost[4];
var float AliceShadowModePos_X;
var string UI_BinkFileName;
var int UI_SetResCount;
var delegate<CanUnpause> __CanUnpause__Delegate;

function RemoveSonarDetectedActor(Actor DesiredActor)
{
    SonarManager.DetectedActors.RemoveItem(DesiredActor);
}

function AddSonarDetectedActor(Actor DesiredActor)
{
    SonarManager.DetectedActors.AddItem(DesiredActor);
}

native function int GetUserProfileSettings(int UserID, string UserSettings)
{
    UserID;
    UserSettings;
}

native function AliceLocErrorMsgBox(string TagTitle, string TagMsg)
{
    TagTitle;
    TagMsg;
}

native function DLCExitToStore()
{
}

native function DLCPurchase(int Item)
{
    Item;
}

native function DLCRedeemCode()
{
}

native static function int DLCGetStatus(int Item)
{
    Item;
}

native function DLCStopCheckThread()
{
}

native function DLCStartCheckThread()
{
}

function float GetClockBombCountDownTime()
{
    if (MyAlicePawn.CloneArcheType != none)
    {
        return MyAlicePawn.CloneArcheType.CountdownTime + MyAlicePawn.CloneArcheType.CriticalTime;
    }
    return 0.0;
}

function OnLoginStatusChange(ELoginStatus NewStatus, ELoginStatus PreviousStatus, UniqueNetId NewId)
{
    LogInternal("OnLoginStatusChange Deprecated");
}

function OnLoginChange(byte LocalUserNum)
{
    if (int(LocalUserNum) == getAliceGameEngine().CurrentUserID)
    {
        if (getAliceGameEngine().CurrentUserID != -1)
        {
            LastPresenceSet[getAliceGameEngine().CurrentUserID] = -1;
        }
        backtoTitle();
        DLCLoginStatusChange();
        AliceLocErrorMsgBox("GenericError", "SignInChangeError");
    }
}

native function DLCLoginStatusChange()
{
}

event OnDLCContentInstalled()
{
    if (WorldInfo.GetMapName() == "AliceEntry")
    {
        LogInternal("OnDLCContentInstalled triggered");
        reloadTitleMenu();
    }
}

function backtoTitle()
{
    local OnlinePlayerInterface PlayerInterface;
    
    if (getAliceGameEngine().CurrentUserID != -1)
    {
        OnlineSub = class'Engine.GameEngine'.static.GetOnlineSubsystem();
        if (OnlineSub != none)
        {
            PlayerInterface = OnlineSub.PlayerInterface;
            PlayerInterface.ClearLoginChangeDelegate(OnLoginChange);
        }
    }
    bNoCurrentUser = true;
    SetCurrentPlayDataIndex(-1);
    getAliceGameEngine().SetCurrentDeviceID(-2);
    getAliceGameEngine().ShowStartScreen();
    ConsoleCommand("open AliceEntry");
    UpdatePresence();
}

function SetCurrentPlayDataIndex(int Index)
{
    getAliceGameEngine().SetCurrentPlayDataIndex(Index);
    getAliceGameEngine().CurrentUserID = Index;
}

event LoadingBinkIsFinished()
{
    local AliceGameEngine Age;
    
    Age = getAliceGameEngine();
    if (MyAlicePawn.Physics != 7 && !bCinematicMode)
    {
        if (Age.StartStateName == 'AliceRespawn')
        {
            MyAlicePawn.HideAlicePawn(true);
            MyAlicePawn.CurrentCameraAnim = MyAlicePawn.RespawnCamera;
            MyAlicePawn.DeathParticleEmitter = Spawn(class'Engine.EmitterSpawnable', self, , MyAlicePawn.Location);
            if (MyAlicePawn.DeathParticleEmitter != none && MyAlicePawn.RespawnParticle != none)
            {
                MyAlicePawn.DeathParticleEmitter.SetLocation(MyAlicePawn.Location);
                MyAlicePawn.DeathParticleEmitter.SetTemplate(MyAlicePawn.RespawnParticle, true);
            }
            PlaySound(MyAlicePawn.RespawnSound);
            GotoState('AliceRespawn');
        }
    }
}

event LoadingMapIsStart()
{
    if (MyAlicePawn.bClockBombCountingDown)
    {
        AliceClonePawn(MyAlicePawn.MyClonePawn).Detonate();
    }
}

event setUnshrinkBlockActor(Actor blocker)
{
    AliceCheatManager(CheatManager).setUnshrinkBlockActor(blocker);
}

function TryRestoreWatch()
{
    if (MyAlicePawn.bClockBombCountingDown && MyAlicePawn.MyClonePawn != none)
    {
        MyAlicePawn.ForceAttachWatchAfterDodge();
        if (MyAlicePawn.Weapon != none)
        {
            MyAlicePawn.ClearTimerToHideWeapon();
            MyAlicePawn.FadeOutWeapon();
        }
    }
}

function PostSpecialMove()
{
    setFacingSlideTarget(none);
}

event setFacingSlideTarget(Actor Target)
{
    FacingSlideTarget = Target;
}

event Actor getFacingSlideTarget()
{
    return FacingSlideTarget;
}

function updateFacingTargetRot()
{
}

function bool isJumpPadJumping()
{
    if (IsInState('PlayerJumpPad') && MyAlicePawn.Velocity.Z > float(0))
    {
        return true;
    }
    return false;
}

function string getAliceStateName()
{
    if (IsInState('PlayerWalking'))
    {
        return "PlayerWalking";
    }
    else if (IsInState('PlayerFloat'))
    {
        return "PlayerFloat";
    }
    else if (IsInState('PlayerJumpPad'))
    {
        return "PlayerJumpPad";
    }
    else
    {
        return string(GetStateName());
    }
}

function tryUnlockAbilityTrophy(EAliceAbilityControl Index)
{
    switch (Index)
    {
        case 14:
            ConsoleCommand("trophy unlock=13");
            break;
        case 15:
            ConsoleCommand("trophy unlock=14");
            break;
        case 16:
            ConsoleCommand("trophy unlock=15");
            break;
        case 17:
            ConsoleCommand("trophy unlock=16");
            break;
        default:
    }
}

event SetAbility(EAliceAbilityControl Index)
{
    persistentDataManager.SetAbility(Index);
    tryUnlockAbilityTrophy(Index);
}

event OnBinkPlay(string MovieName)
{
    persistentDataManager.setBinkPlayed(MovieName);
}

function playUniqueSound(SoundCue newSound)
{
    if (uniqueAudio == none)
    {
        uniqueAudio = CreateAudioComponent(newSound);
        uniqueAudio.Play();
    }
    uniqueAudio.Stop();
    uniqueAudio.SoundCue = newSound;
    uniqueAudio.Play();
}

function UI_ClearBinkFileName()
{
    UI_BinkFileName = "";
}

function UI_PlayMemory(string Filename, optional bool bBlock = true, optional bool bSoundOnly = false, optional AliceGFXMovie pGFXMovie = none)
{
    StopBinkFile();
    PlayBinkFile(Filename, bBlock, bSoundOnly);
    UI_AliceGFXMovie = pGFXMovie;
    UI_BinkFileName = Filename;
}

function PlayMemory(int MemoryBinkID)
{
    PlayBinkFile(AliceGameInfo(WorldInfo.Game).MemoriesBinkFileName[MemoryBinkID]);
}

function GetMemoriesList()
{
}

function int GetCurrentChapterChallengeRooms()
{
    local string MapName;
    local int I, pos;
    
    MapName = WorldInfo.GetMapName();
    for (I = 0; I < 6; I++)
    {
        pos = InStr(MapName, "Chapter" @ string(I + 1));
        if (pos != -1)
        {
            return AliceGameInfo(WorldInfo.Game).CurrentChallengeRoomCount[I];
        }
    }
}

function int GetCurrentChapterMemories()
{
    local string MapName;
    local int I, pos;
    
    MapName = WorldInfo.GetMapName();
    for (I = 0; I < 6; I++)
    {
        pos = InStr(MapName, "Chapter" @ string(I + 1));
        if (pos != -1)
        {
            return AliceGameInfo(WorldInfo.Game).CurrentMemoriesNum[I];
        }
    }
}

function int GetCurrentChapterSnouts()
{
    local string MapName;
    local int I, pos;
    
    MapName = WorldInfo.GetMapName();
    for (I = 0; I < 6; I++)
    {
        pos = InStr(MapName, "Chapter" @ string(I + 1));
        if (pos != -1)
        {
            return AliceGameInfo(WorldInfo.Game).CurrentChapterSnoutNum[I];
        }
    }
}

function GetChallengeRooms(out int Current, out int MaxNum)
{
    Current = AliceGameInfo(WorldInfo.Game).TrohpyChallengeRoomCount;
    MaxNum = AliceGameInfo(WorldInfo.Game).MaxChallengeRoomsNum;
}

function GetMemoriesCollected(out int Current, out int MaxNum)
{
    local int I;
    
    Current = 0;
    for (I = 0; I < 6; I++)
    {
        Current += AliceGameInfo(WorldInfo.Game).CurrentMemoriesNum[I];
    }
    MaxNum = AliceGameInfo(WorldInfo.Game).MaxMemoriesNum;
}

function GetSnoutsPeppered(out int Current, out int MaxNum)
{
    local int I;
    
    Current = AliceGameInfo(WorldInfo.Game).CurrentSnoutNum;
    MaxNum = 0;
    for (I = 0; I < 6; I++)
    {
        MaxNum += AliceGameInfo(WorldInfo.Game).ChapterSnoutNum[I];
    }
}

function float GetOverallCompletion()
{
    local float OverallCompletion;
    
    OverallCompletion = 50.0;
    return OverallCompletion;
}

function int GetChapterCompleted()
{
    local int ChapterCompletedNum, I;
    
    for (I = 0; I < 6; I++)
    {
        ChapterCompletedNum += AliceGameInfo(WorldInfo.Game).ChapterComplete[I];
    }
    return ChapterCompletedNum;
}

exec function GetMapName()
{
}

function int UI_GetCurControllerType()
{
    return UI_CurControllerType;
}

function Vector UI_AdjustScreenPos(Vector vPos)
{
    local int ViewSizeX, ViewSizeY;
    local float FixedViewSizeX, FixedViewSizeY, MonitorAspectRatio;
    local Vector NewPos;
    
    UI_GetCurrentAspectRatio(MonitorAspectRatio, ViewSizeX, ViewSizeY);
    FixedViewSizeX = 1280.0;
    FixedViewSizeY = 720.0;
    NewPos = vPos;
    NewPos.X = FixedViewSizeX * vPos.X / float(ViewSizeX);
    NewPos.Y = FixedViewSizeY * vPos.Y / float(ViewSizeY);
    return NewPos;
}

native function UI_GetBenchMarkFPS(out float MaxFPS, out float MinFPS, out float AverageFPS)
{
    MaxFPS;
    MinFPS;
    AverageFPS;
}

native function bool UI_IsGPUVendorNVIDIA()
{
}

native function UI_GetCurrentAspectRatio(out float MonitorAspectRatio, out int ViewSizeX, out int ViewSizeY)
{
    MonitorAspectRatio;
    ViewSizeX;
    ViewSizeY;
}

function UI_UpdateReduceSaveIconDelayTick()
{
    AliceGameInfo(WorldInfo.Game).DelayDisappearUI();
}

function UI_UpdateSetResWaitTick()
{
    if (UI_AliceGFXMovie != none && UI_SetResCount >= 0)
    {
        UI_SetResCount++;
        if (UI_SetResCount > 5)
        {
            UI_SetResCount = -1;
            UI_AliceGFXMovie.GameCallback(20);
        }
    }
}

function UI_UpdateBinkFileTick()
{
    if (UI_AliceGFXMovie != none)
    {
        if (UI_BinkFileName != "" && !IsPlayingBinkFile(UI_BinkFileName))
        {
            UI_AliceGFXMovie.GameCallback(10);
            UI_BinkFileName = "";
        }
    }
}

function UI_EnableUIMode(bool bEnable)
{
    bInUIMode = bEnable;
}

function UI_SetAliceRotation(float fYaw)
{
    bInUIMode = true;
    UI_AliceTargetRotation.Yaw = int(fYaw / 180.0 * 32767.0);
}

function UI_RotateAlice(float RotateSpeed)
{
    bInUIMode = true;
    UI_RotateSpeed = RotateSpeed / 180.0 * 32767.0;
}

function UI_MoveAlice(float OffsetX, float OffsetY, float OffsetZ)
{
    local Vector Aliceloc;
    
    Aliceloc = MyAlicePawn.Location;
    Aliceloc.X += OffsetX;
    Aliceloc.Y += OffsetY;
    Aliceloc.Z += OffsetZ;
    MyAlicePawn.SetLocation(Aliceloc);
}

function UI_GetCameraOffset(out float OffsetX, out float OffsetY, out float OffsetZ)
{
    OffsetX = CommandCameraOffset.X;
    OffsetY = CommandCameraOffset.Y;
    OffsetZ = CommandCameraOffset.Z;
}

function UI_MoveCamera(float OffsetX, float OffsetY, float OffsetZ)
{
    CommandCameraOffset.X = OffsetX;
    CommandCameraOffset.Y = OffsetY;
    CommandCameraOffset.Z = OffsetZ;
}

function UI_MoveCameraSpeed(float OffsetX, float OffsetY, float OffsetZ)
{
    CommandCameraOffsetSpeed.X = OffsetX;
    CommandCameraOffsetSpeed.Y = OffsetY;
    CommandCameraOffsetSpeed.Z = OffsetZ;
}

function UI_CameraOffsetRange(float MinOffsetX, float MinOffsetY, float MinOffsetZ, float MaxOffsetX, float MaxOffsetY, float MaxOffsetZ)
{
    CommandCameraOffsetMin.X = MinOffsetX;
    CommandCameraOffsetMin.Y = MinOffsetY;
    CommandCameraOffsetMin.Z = MinOffsetZ;
    CommandCameraOffsetMax.X = MaxOffsetX;
    CommandCameraOffsetMax.Y = MaxOffsetY;
    CommandCameraOffsetMax.Z = MaxOffsetZ;
}

function UI_UpdateKeySettings(bool bGamepad)
{
    local name KeyName, EnterName;
    
    EnterName = 'Enter';
    if (!UI_bUpdateKeySettings)
    {
        if (GetPressedKey(KeyName))
        {
            SetCurControllerType(bGamepad);
        }
    }
    else if (!bGamepad)
    {
        if (GetPressedKey(KeyName) && UI_CurActiveKeyType >= 0 && UI_CurActiveKeyGroup < 2 && UI_CurActiveKeyGroup >= 0)
        {
            if (KeyName != EnterName)
            {
                if (getAliceGameEngine().GetAliceKeys(UI_CurActiveKeyType, UI_CurActiveKeyGroup) != KeyName)
                {
                    UI_RemovedAliceKeys.Length = 0;
                    getAliceGameEngine().ExecRebindKey(UI_CurActiveKeyType, UI_CurActiveKeyGroup, KeyName, UI_RemovedAliceKeys);
                }
                if (UI_AliceGFXMovie != none)
                {
                    UI_AliceGFXMovie.GameCallback(1);
                }
            }
        }
    }
}

function closeRedeemPurchasePop()
{
    UI_AliceGFXMovie.closeRedeemPurchasePop();
}

function reloadTitleMenu()
{
    UI_AliceGFXMovie.reloadTitleMenu();
}

function SetCurControllerType(bool bGamepad)
{
    local int OldControllerType;
    
    OldControllerType = UI_CurControllerType;
    UI_CurControllerType = (bGamepad ? 1 : 0);
    if (UI_CurControllerType != OldControllerType && UI_AliceGFXMovie != none)
    {
        UI_AliceGFXMovie.GameCallback(2);
    }
}

function UI_SetGFXMovie(AliceGFXMovie pGFXMovie)
{
    UI_AliceGFXMovie = pGFXMovie;
}

function UT_UnlockTrophyDressUps()
{
    if (GetGStoryMode() == false)
    {
        ConsoleCommand("trophy unlock=30");
    }
}

function UT_SetStoryMode(bool bInStoryMode)
{
    SetGStoryMode(bInStoryMode);
}

function bool GetPressedKey(out name KeyName)
{
    if (PlayerInput.PressedKeys.Length > 0)
    {
        KeyName = PlayerInput.PressedKeys[0];
        return true;
    }
    KeyName = 'None';
    return false;
}

function bool isShowPersistentData()
{
    return AliceCheatManager(CheatManager).isShowPersistentData();
}

function bool isShowTrophy()
{
    return AliceCheatManager(CheatManager).isShowTrophy();
}

function SetXPValue(int Value)
{
    MyAlicePawn.SetXPValue(Value);
    AliceGameInfo(WorldInfo.Game).UpdateTeethNumber(Value);
}

function int GetXPValue()
{
    return MyAlicePawn.GetXPValue();
}

function GetSupportedResolutions(int Index, out int iResX, out int iResY)
{
    getAliceGameEngine().GetSupportedResolutions(Index, iResX, iResY);
}

function int GetNumOfSupportedResolutions()
{
    return getAliceGameEngine().GetNumOfSupportedResolutions();
}

function bool DoesSupportMSAA(int MaxMultiSamples)
{
    return getAliceGameEngine().DoesSupportMSAA(MaxMultiSamples);
}

function AliceGameEngine getAliceGameEngine()
{
    return AliceGameInfo(WorldInfo.Game).getAliceGameEngine();
}

native function EnableAllDresses()
{
}

native function AddAvailableDressID(int Index)
{
    Index;
}

native function int GetAvailableDressID(int Index)
{
    Index;
}

native function updatePCPlayerProfileData()
{
}

native function interface_ResetConfigData()
{
}

native function interface_LoadConfigData()
{
}

native function interface_SaveConfigData()
{
}

function bool IsInFixedCamera()
{
    return PreCameraActor != none;
}

function PostUpdateCamera()
{
    local CameraActor CamActor;
    local Vector OldCameraLoc, CamLocation;
    local Rotator CamRotation;
    
    CamActor = CameraActor(PlayerCamera.PendingViewTarget.Target);
    if (CamActor == none)
    {
        CamActor = CameraActor(PlayerCamera.ViewTarget.Target);
    }
    if (CamActor != none)
    {
        SetRotation(PlayerCamera.CameraCache.POV.Rotation);
    }
    if (PreCameraActor != CamActor)
    {
        if (CamActor != none && !bProjectInputToPreCameraSpace)
        {
            PreCameraRot = OldCameraRot;
            bProjectInputToPreCameraSpace = true;
        }
        else if (CamActor == none)
        {
            bProjectInputToPreCameraSpace = false;
        }
    }
    PreCameraActor = CamActor;
    GetPlayerViewPoint(OldCameraLoc, OldCameraRot);
    if (CamActor != none)
    {
        CamLocation = CamActor.Location;
        CamRotation = CamActor.Rotation;
        AlicePlayerCamera(PlayerCamera).PreventCameraPenetration(self, CamLocation, CamRotation, false);
    }
}

function onAliceJump()
{
    if (ventActor != none)
    {
        ventActor.onAliceJump();
    }
}

function bool isShowVentCylinder()
{
    return AliceCheatManager(CheatManager).isShowVentCylinder();
}

event FallingSkipFloat()
{
    CycleFloatManager.indicatorManager.stopEffect();
}

function interface_gotoState(name NewState)
{
    GotoState(NewState);
}

function bool isNewCycleControl()
{
    return MyAlicePawn.isNewCycleControl();
}

function exitInteractState()
{
}

exec function interactInLondonX()
{
}

function OnInteractInLondon(SeqAct_InteractInLondon inAction)
{
    if (!MyAlicePawn.bInLondon)
    {
        return;
    }
    if (inAction.InputLinks[0].bHasImpulse)
    {
        InteractLondonActor = inAction;
        GotoState('PlayerInteractInLondon');
    }
    else if (inAction.InputLinks[1].bHasImpulse)
    {
        GotoState('PlayerWalking');
    }
}

event bool shouldAliceCollide(Actor touchedActor, optional PrimitiveComponent HitComponent)
{
    local StaticMeshCollectionActor collectActor;
    local StaticMeshComponent smComponent;
    
    collectActor = StaticMeshCollectionActor(touchedActor);
    if (collectActor != none)
    {
        smComponent = StaticMeshComponent(HitComponent);
        if (smComponent != none)
        {
            if (smComponent.bOwnerBlockWeapons)
            {
                return false;
            }
            return smComponent.BlockActors;
        }
        else
        {
            return false;
        }
    }
    return touchedActor.CollisionType == 2 || touchedActor.CollisionType == 6;
}

function bool shouldBlockLockOn(Actor touchedActor, optional PrimitiveComponent HitComponent)
{
    local StaticMeshCollectionActor collectActor;
    local StaticMeshComponent smComponent;
    
    collectActor = StaticMeshCollectionActor(touchedActor);
    if (collectActor != none)
    {
        smComponent = StaticMeshComponent(HitComponent);
        if (smComponent != none)
        {
            if (smComponent.bOwnerBlockWeapons)
            {
                return true;
            }
            return smComponent.BlockActors;
        }
        else
        {
            return false;
        }
    }
    return touchedActor.CollisionType == 2 || touchedActor.CollisionType == 6 || touchedActor.CollisionType == 3;
}

exec function RightClickAttack(bool bAttack)
{
    if (getControlLayout() == 2)
    {
        if (bAttack)
        {
            if (WeaponGroup == 1)
            {
                SwitchToEyeStaff();
                bSwitchWeaponOnly = false;
                EyeStaffFirePress();
            }
            else if (WeaponGroup == 2)
            {
                SwitchToTeapotCannon();
                bSwitchWeaponOnly = false;
                TeapotCannonFirePress();
            }
        }
        else
        {
            QuitWeaponAttack();
        }
    }
    else
    {
        ChangeCameraMode(bAttack);
    }
}

exec function SwitchWeaponGroup()
{
    if (getControlLayout() == 1)
    {
        return;
    }
    WeaponGroup = (WeaponGroup == 1 ? 2 : 1);
    if (WeaponGroup == 1)
    {
        SwitchToVorpalBlade();
    }
    else
    {
        SwitchToHobbyHorse();
    }
}

exec function SwitchPCAttackType()
{
    getAliceGameEngine().AttackType = (getAliceGameEngine().AttackType == 0 ? 1 : 0);
    LogInternal("AliceKeySettings : SwitchPCAttackType......." @ string(getAliceGameEngine().AttackType));
    SetPCAttackType(getAliceGameEngine().AttackType);
}

native function SetPCAttackType(int nType)
{
    nType;
}

exec function SwitchToRightLockTarget()
{
    TargetMergeManager.HandleTargetSwitchCommond(100.0, 0.0);
}

exec function SwitchToLeftLockTarget()
{
    TargetMergeManager.HandleTargetSwitchCommond(-100.0, 0.0);
}

function EndMemoryMode()
{
    SoundModeManager.SetMemoryMode(false);
}

function OnSetVentState(SeqAct_SetVentState inAction)
{
    local array<Object> objVars;
    local Object Object;
    local AliceVentActor vent;
    
    objVars.Length = 0;
    inAction.GetObjectVars(objVars, "Vents");
    foreach objVars(Object)
    {
        vent = AliceVentActor(Object);
        if (vent != none)
        {
            if (inAction.InputLinks[0].bHasImpulse)
            {
                vent.setEnable(true);
                continue;
            }
            if (inAction.InputLinks[1].bHasImpulse)
            {
                vent.setEnable(false);
                continue;
            }
            if (inAction.InputLinks[2].bHasImpulse)
            {
                vent.setEnable(vent.isEnable() ? false : true);
            }
        }
    }
}

function OnExitMemorySoundMode(SeqAct_ExitMemorySoundMode inAction)
{
    if (inAction.InputLinks[0].bHasImpulse)
    {
        SoundModeManager.SetMemoryMode(false);
    }
}

function OnSetSoundMode(SeqAct_SetSoundMode Action)
{
    SoundModeManager.OnKismetSet(Action);
}

simulated function OnMakeBlockThin(SeqAct_MakeBlockThin inAction)
{
    if (inAction.InputLinks[0].bHasImpulse)
    {
        if (BlockPuzzleActor != none)
        {
            BlockPuzzleActor.MakeBlockThin();
        }
    }
}

simulated function OnAssembleBlock(SeqAct_AssembleBlock inAction)
{
    if (inAction.InputLinks[0].bHasImpulse)
    {
        if (BlockPuzzleActor != none)
        {
            BlockPuzzleActor.OnAssembleBlock();
        }
    }
}

simulated function OnSkipBlockPuzzle(SeqAct_SkipBlockPuzzle inAction)
{
    if (inAction.InputLinks[0].bHasImpulse)
    {
        if (BlockPuzzleActor != none)
        {
            BlockPuzzleActor.OnSkipBlockPuzzle();
        }
    }
}

function CollectBlockPiece()
{
    if (BlockPuzzleActor != none)
    {
        BlockPuzzleActor.CollectBlockPiece();
    }
}

function ShowBlockCollectUI(int show, optional string sText)
{
    if (AliceGameInfo(WorldInfo.Game).GFxHUDMenu != none)
    {
        AliceGameInfo(WorldInfo.Game).GFxHUDMenu.ShowInteractPressX(float(show), sText);
    }
}

function StopShowPath()
{
}

function ClearAllTargets()
{
    PreTargetingActor = none;
    PreTargetNPCSocket.Pawn = none;
    PreTargetBActorInfo.BActor = none;
}

native function TickSonarOffEffect(Actor TargetActor, float fStartTime, float fDeltaTime)
{
    TargetActor;
    fStartTime;
    fDeltaTime;
}

native function TickSonarOnEffect(Actor TargetActor, float fStartTime, float fDeltaTime)
{
    TargetActor;
    fStartTime;
    fDeltaTime;
}

native function MakeOnSMActorEffect(StaticMeshActor SMActor)
{
    SMActor;
}

native function SetFloatParticleParam(out ParticleSystem FloatPS, float fLifeTime)
{
    FloatPS;
    fLifeTime;
}

function OnSMLaned()
{
    CycleFloatManager.bDisableAfterLanded = true;
}

event bool IsInGrabbedDelay()
{
    return !MyAlicePawn.bCanBeGrabbed;
}

event bool IsJumping()
{
    return MyAlicePawn.Physics == 2;
}

event bool IsDeflecting()
{
    return MyAlicePawn.bInShield;
}

event bool IsDodging()
{
    return MyAlicePawn.IsDoingSpecialMove(37);
}

function bool IsLeftStickDownPressed()
{
    local Vector vInputDir;
    
    vInputDir = AlicePlayerInput(PlayerInput).InputVector;
    if (vInputDir Dot vector(Pawn.Rotation) < float(0))
    {
        return true;
    }
    return false;
}

exec function ViewAsset(optional int Index)
{
}

exec function ShowHUD()
{
    if (AliceGameInfo(WorldInfo.Game).GFxHUDMenu != none)
    {
        AliceGameInfo(WorldInfo.Game).GFxHUDMenu.ShowHUD();
    }
}

exec function hideHUD()
{
    if (AliceGameInfo(WorldInfo.Game).GFxHUDMenu != none)
    {
        AliceGameInfo(WorldInfo.Game).GFxHUDMenu.hideHUD();
    }
}

exec function ChangeDifficultLevel(optional int Level = 0)
{
    if (Level <= 0 || Level > 3)
    {
        Level = 0;
    }
    AliceGameInfo(WorldInfo.Game).setCurrentGameDifficulty(Level);
    LogInternal("game difficult level set to " @ string(AliceGameInfo(WorldInfo.Game).getCurrentGameDifficulty()));
}

function PostSpawnPawn()
{
    CycleFloatManager.Init();
    SonarManager.Init();
}

function ResetExitFloatFlag()
{
    MyAlicePawn.bExitFloatWhenMissWindow = false;
}

function bool AtTimeTick(int iNum)
{
    if (AliceCheatManager(CheatManager) != none)
    {
        if (AliceCheatManager(CheatManager).iTick % iNum == 0)
        {
            return true;
        }
    }
    return false;
}

function ForceUpdateTarget()
{
    if (TargetMergeManager != none)
    {
        TargetMergeManager.Update(0.0);
    }
}

function ChangeTargetFromDeadActor()
{
    local Actor oldTarget;
    
    oldTarget = TargetingActor;
    if (bTargetingModeActive && MyAlicePawn.bEnableTargetOnDestroyedActor)
    {
        if (TargetingActor.IsA('Pawn') && !Pawn(TargetingActor).IsAliveAndWell())
        {
            AliceGameKynapsePawn(TargetingActor).DisableAllLockTargets();
            ForceUpdateTarget();
            if (bTargetingModeActive && !bHoldTiggerToMaintainTargeting && !bHoldToggleLockOnButton && TargetingActor == none || TargetingActor == oldTarget)
            {
                ChangeCameraMode(true);
            }
        }
        else if (TargetingActor.IsA('GameBreakableActor') && GameBreakableActor(TargetingActor).bPendingDestroySelf)
        {
            GameBreakableActor(TargetingActor).HideAndDestroy();
            ForceUpdateTarget();
            if (bTargetingModeActive && !bHoldTiggerToMaintainTargeting && !bHoldToggleLockOnButton && TargetingActor == none || TargetingActor == oldTarget)
            {
                ChangeCameraMode(true);
            }
        }
    }
}

function OnNPCDied(AliceGameKynapsePawn npc, class<DamageType> DamageType, Vector HitLocation)
{
    if (!MyAlicePawn.bEnableTargetOnDestroyedActor && npc == TargetingActor)
    {
        TargetingActor = none;
    }
    else if (MyAlicePawn.bEnableTargetOnDestroyedActor && npc == TargetingActor)
    {
        SetTimer(MyAlicePawn.TargetOnDestroyedActorTimer, false, 'ChangeTargetFromDeadActor');
    }
}

function bool IsLockOnBActor()
{
    return TargetingActor != none && TargetingActor.IsA('GameBreakableActor');
}

function bool IsLockOnDeadNPC()
{
    if (IsLockOnNPC())
    {
        return !TargetNPCSocket.Pawn.IsAliveAndWell();
    }
    return false;
}

function bool IsLockOnNPC()
{
    return TargetNPCSocket.Pawn != none && TargetNPCSocket.Pawn.IsA('AliceGameKynapsePawn');
}

function OnBreakableActorDestroyed(GameBreakableActor BActor)
{
    if (!MyAlicePawn.bEnableTargetOnDestroyedActor && BActor == TargetingActor)
    {
        TargetingActor = none;
        TargetBActorInfo.BActor = none;
    }
    else if (MyAlicePawn.bEnableTargetOnDestroyedActor && BActor == TargetingActor)
    {
        SetTimer(MyAlicePawn.TargetOnDestroyedActorTimer, false, 'ChangeTargetFromDeadActor');
    }
}

function AddSkirtFloatingEffect(float DeltaTime)
{
}

function bool IsMeleeCharging()
{
    return false;
}

native function RestorePreviousRigidBodyVelocity()
{
}

exec function RollTest()
{
    MyAlicePawn.StartRoll();
    GotoState('PlayerRoll');
}

function LeaveChessPuzzleMode()
{
    ChessBoardActor.APC = none;
    ChessBoardActor = none;
    GotoState('PlayerWalking');
}

function OnTriggerAllGameFinish(SeqAct_TriggerAllGameFinish inAction)
{
    if (inAction.InputLinks[0].bHasImpulse)
    {
        if (AliceGameInfo(WorldInfo.Game).getCurrentGameDifficulty() == 2)
        {
            getAliceGameEngine().setFinishGameOnHard(true);
        }
    }
}

simulated function OnTriggerChessDizzy(SeqAct_TriggerChessDizzy inAction)
{
    if (ChessBoardActor == none)
    {
        return;
    }
    if (inAction.InputLinks[0].bHasImpulse)
    {
        ChessBoardActor.DoDizzy();
    }
}

simulated function OnTriggerChessPuzzle(SeqAct_TriggerChessPuzzle inAction)
{
    local int Idx;
    local AliceChessBoard AChessBoard;
    local array<Object> objVars;
    local AliceChessWhitePiece WhitePiece;
    local AliceChessBlackPiece BlackPiece;
    local AliceChessBlock BlockPiece;
    local AliceChessGoal GoalPiece;
    local AliceChessTrap TrapPiece;
    
    if (inAction.InputLinks[0].bHasImpulse)
    {
        if (ChessBoardActor == none)
        {
            objVars.Length = 0;
            inAction.GetObjectVars(objVars, "Chess Board");
            AChessBoard = AliceChessBoard(objVars[0]);
            if (AChessBoard == none)
            {
                return;
            }
            AChessBoard.APC = self;
            ChessBoardActor = AChessBoard;
        }
        ChessBoardActor.Init();
        GotoState('PlayerChessPuzzle');
    }
    else if (inAction.InputLinks[1].bHasImpulse)
    {
        LeaveChessPuzzleMode();
    }
    else if (inAction.InputLinks[2].bHasImpulse)
    {
        inAction.GetObjectVars(objVars, "Chess Board");
        AChessBoard = AliceChessBoard(objVars[0]);
        if (AChessBoard == none)
        {
            return;
        }
        AChessBoard.APC = self;
        ChessBoardActor = AChessBoard;
        objVars.Length = 0;
        inAction.GetObjectVars(objVars, "White Piece");
        WhitePiece = AliceChessWhitePiece(objVars[0]);
        if (WhitePiece != none)
        {
            ChessBoardActor.WhiteMesh = WhitePiece;
        }
        objVars.Length = 0;
        inAction.GetObjectVars(objVars, "Black Piece");
        BlackPiece = AliceChessBlackPiece(objVars[0]);
        if (BlackPiece != none)
        {
            ChessBoardActor.BlackMesh = BlackPiece;
        }
        objVars.Length = 0;
        ChessBoardActor.BlockMeshes.Length = 0;
        inAction.GetObjectVars(objVars, "Block Pieces");
        for (Idx = 0; Idx < objVars.Length; Idx++)
        {
            BlockPiece = AliceChessBlock(objVars[Idx]);
            if (BlockPiece != none)
            {
                ChessBoardActor.BlockMeshes.AddItem(BlockPiece);
            }
        }
        objVars.Length = 0;
        inAction.GetObjectVars(objVars, "White Goal");
        GoalPiece = AliceChessGoal(objVars[0]);
        if (GoalPiece != none)
        {
            ChessBoardActor.WhiteGoalMesh = GoalPiece;
        }
        objVars.Length = 0;
        inAction.GetObjectVars(objVars, "Black Goal");
        GoalPiece = AliceChessGoal(objVars[0]);
        if (GoalPiece != none)
        {
            ChessBoardActor.BlackGoalMesh = GoalPiece;
        }
        objVars.Length = 0;
        ChessBoardActor.TrapMeshes.Length = 0;
        inAction.GetObjectVars(objVars, "Trap Pieces");
        for (Idx = 0; Idx < objVars.Length; Idx++)
        {
            TrapPiece = AliceChessTrap(objVars[Idx]);
            if (TrapPiece != none)
            {
                ChessBoardActor.TrapMeshes.AddItem(TrapPiece);
            }
        }
        ChessBoardActor.Init();
    }
}

function OnChallengeCaveCompleted(SeqAct_ChallengeCaveCompleted inAction)
{
    local int I, iChallengeNum;
    
    if (inAction.InputLinks[0].bHasImpulse)
    {
        persistentDataManager.setChallengeCaveCompleted(inAction.caveIndex);
    }
    iChallengeNum = 0;
    for (I = 0; I < 16; I++)
    {
        iChallengeNum += CaveCompleted[I];
    }
    if (iChallengeNum == 16)
    {
        ConsoleCommand("trophy unlock=" @ string(21));
    }
}

function TryUnlockMemoryTrophy()
{
    local int I, iBigMemoryNum;
    
    iBigMemoryNum = 0;
    for (I = 0; I < 5; I++)
    {
        iBigMemoryNum += MemoryCompleted[I];
    }
    if (iBigMemoryNum + MemoryFragment.Length == 94)
    {
        ConsoleCommand("trophy unlock=" @ string(23));
    }
}

function OnBigMemoryCompleted(SeqAct_BigMemoryCompleted inAction)
{
    if (inAction.InputLinks[0].bHasImpulse)
    {
        persistentDataManager.setBigMemoryCompleted(inAction.Memory);
    }
}

function tryUnlockChapterCompleted(EChapterCompleted chapterIndex)
{
    local int iDifficulty, I, ChapterIdx, LowerstChapterDifficulty;
    
    iDifficulty = AliceGameInfo(WorldInfo.Game).getLowestGameDifficulty();
    ChapterIdx = int(chapterIndex);
    if (ChapterIdx >= 0 && ChapterIdx < 6 && ChapterCompletedHighestDifficulty[ChapterIdx] < iDifficulty)
    {
        ChapterCompletedHighestDifficulty[ChapterIdx] = iDifficulty;
    }
    LowerstChapterDifficulty = 3;
    for (I = 0; I < 6; I++)
    {
        if (ChapterCompletedHighestDifficulty[I] < LowerstChapterDifficulty)
        {
            LowerstChapterDifficulty = ChapterCompletedHighestDifficulty[I];
        }
    }
    if (chapterIndex == 5)
    {
        AliceGameInfo(WorldInfo.Game).CompleteGameOnAnyDifficult = 1;
        switch (LowerstChapterDifficulty)
        {
            case 0:
                ConsoleCommand("trophy unlock=8");
                break;
            case 1:
                ConsoleCommand("trophy unlock=8");
                ConsoleCommand("trophy unlock=9");
                break;
            case 2:
                ConsoleCommand("trophy unlock=8");
                ConsoleCommand("trophy unlock=9");
                ConsoleCommand("trophy unlock=10");
                break;
            case 3:
                ConsoleCommand("trophy unlock=8");
                ConsoleCommand("trophy unlock=9");
                ConsoleCommand("trophy unlock=10");
                ConsoleCommand("trophy unlock=12");
                break;
            default:
        }
    }
    else
    {
        if (chapterIndex == 0 && iDifficulty == 3)
        {
            ConsoleCommand("trophy unlock=11");
        }
        ConsoleCommand("trophy unlock=" @ string(int(chapterIndex) + 3));
    }
}

function OnChapterCompleted(SeqAct_ChapterCompleted inAction)
{
    local bool IsNewGamePlus;
    
    if (inAction.InputLinks[0].bHasImpulse)
    {
        if (ChapterCompleted[5] == 1)
        {
            IsNewGamePlus = true;
        }
        else
        {
            IsNewGamePlus = false;
        }
        persistentDataManager.setChapterCompleted(inAction.ChapterName);
        tryUnlockChapterCompleted(inAction.ChapterName);
        if (inAction.ChapterName == 5 && AliceGameInfo(WorldInfo.Game).UseHysteriaCounter <= 1)
        {
            ConsoleCommand("trophy unlock=36");
        }
        if (inAction.ChapterName == 5)
        {
            AliceGameInfo(WorldInfo.Game).UseHysteriaCounter = 0;
        }
    }
}

function OnUnlockEnemy(SeqAct_UnlockEnemy inAction)
{
    if (inAction.InputLinks[0].bHasImpulse)
    {
        persistentDataManager.setUnlockEnemy(inAction.Enemy);
    }
}

function notifyUIUpgradeHealth()
{
    AliceGameInfo(WorldInfo.Game).GFxHUDMenu.notifyUIUpgradeHealth(float(MyAlicePawn.Health), float(MyAlicePawn.HealthMax));
}

function float calcCompletePercent()
{
    local int I, iMemoryNum, iChallengeNum, totalMemory, totalSnout, totalChallenge, totalSecret;
    local float chapWeight[6];
    
    chapWeight[0] = 0.15;
    chapWeight[1] = 0.1;
    chapWeight[2] = 0.1;
    chapWeight[3] = 0.1;
    chapWeight[4] = 0.1;
    chapWeight[5] = 0.05;
    totalMemory = 94;
    totalSnout = 59;
    totalChallenge = 16;
    totalSecret = 83;
    CompletePercent = 0.0;
    for (I = 0; I < 6; I++)
    {
        CompletePercent += float(ChapterCompleted[I]) * chapWeight[I];
    }
    iMemoryNum = MemoryFragment.Length;
    for (I = 0; I < 5; I++)
    {
        iMemoryNum += MemoryCompleted[I];
    }
    CompletePercent += float(iMemoryNum) / float(totalMemory) * 0.1;
    CompletePercent += float(SountActive.Length) / float(totalSnout) * 0.1;
    iChallengeNum = 0;
    for (I = 0; I < 16; I++)
    {
        iChallengeNum += CaveCompleted[I];
    }
    CompletePercent += float(iChallengeNum) / float(totalChallenge) * 0.1;
    CompletePercent += float(SecretPick.Length) / float(totalSecret) * 0.1;
    CompletePercent = FClamp(CompletePercent, 0.0, 1.0);
    return CompletePercent;
}

function OnUpgradeHealth(SeqAct_UpgradeHealth inAction)
{
    if (inAction.InputLinks[0].bHasImpulse)
    {
        if (UpgradeHealth[int(inAction.Chapter)] == 0)
        {
            persistentDataManager.setUpgradeHealth(inAction.Chapter);
            MyAlicePawn.HealthMax += 8;
        }
        MyAlicePawn.Health = MyAlicePawn.HealthMax;
        notifyUIUpgradeHealth();
    }
}

function bool belongToType(string SourceType, string sType)
{
    if (SourceType == "Family")
    {
        if (sType == "Lizzie")
        {
            return true;
        }
        else if (sType == "Mother")
        {
            return true;
        }
        else if (sType == "Father")
        {
            return true;
        }
    }
    else if (SourceType == "Doctor")
    {
        if (sType == "DrWilson")
        {
            return true;
        }
    }
    else if (SourceType == "Bumby")
    {
        if (sType == "Bumby")
        {
            return true;
        }
    }
    else if (SourceType == "Pris")
    {
        if (sType == "Pris")
        {
            return true;
        }
    }
    else if (SourceType == "Lawyer")
    {
        if (sType == "Lawyer")
        {
            return true;
        }
    }
    else if (SourceType == "Nanny")
    {
        if (sType == "Nanny")
        {
            return true;
        }
    }
    return false;
}

function tryUnlockFamilyMemoryTrophy()
{
    local int I, iAllFamilyMemory, iFamilyMemory;
    local string sType, sName;
    
    iFamilyMemory = 0;
    iAllFamilyMemory = 34;
    if (MemoryFragment.Length < iAllFamilyMemory)
    {
        return;
    }
    for (I = 0; I < MemoryFragment.Length; I++)
    {
        sName = MemoryFragment[I];
        sType = GetRightMost(sName);
        if (belongToType("Family", sType))
        {
            iFamilyMemory++;
        }
    }
    if (iFamilyMemory == iAllFamilyMemory)
    {
        ConsoleCommand("trophy unlock=" @ string(22));
    }
}

function setMemoryFragment(string fragmentName)
{
    persistentDataManager.setMemoryFragment(fragmentName);
    tryUnlockFamilyMemoryTrophy();
}

function setSountActive(name snouttag)
{
    persistentDataManager.setSountActive(string(snouttag));
}

function setSecretPick(string secrettag)
{
    persistentDataManager.setSecretPick(secrettag);
}

function bool CanCollectBlockPiece(AliceBlockPiece Piece)
{
    if (VSize(Pawn.Location - Piece.Location) < Piece.TouchRadius)
    {
        return true;
    }
    return false;
}

function OnTriggerBlockPuzzle(SeqAct_TriggerBlockPuzzle inAction)
{
    local array<Object> objVars;
    local int I;
    local AliceBlockPiece Piece;
    
    if (inAction.InputLinks[0].bHasImpulse)
    {
        if (BlockPuzzleActor != none && BlockPuzzleActor.IsReadyToPlay())
        {
            GotoState('PlayerBlockPuzzle');
        }
        else if (BlockPuzzleActor == none)
        {
            objVars.Length = 0;
            inAction.GetObjectVars(objVars, "Block Board");
            BlockPuzzleActor = AliceBlockPuzzleBoard(objVars[0]);
            if (BlockPuzzleActor == none)
            {
                return;
            }
            if (BlockPuzzleActor.IsReadyToPlay())
            {
                BlockPuzzleActor.APC = self;
                BlockPuzzleActor.InitAssamble(false);
                GotoState('PlayerBlockPuzzle');
            }
        }
    }
    else if (inAction.InputLinks[1].bHasImpulse)
    {
        GotoState('PlayerWalking');
        BlockPuzzleActor.APC = none;
        BlockPuzzleActor = none;
    }
    else if (inAction.InputLinks[2].bHasImpulse)
    {
        if (BlockPuzzleActor == none)
        {
            objVars.Length = 0;
            inAction.GetObjectVars(objVars, "Block Board");
            BlockPuzzleActor = AliceBlockPuzzleBoard(objVars[0]);
            if (BlockPuzzleActor == none)
            {
                return;
            }
            BlockPuzzleActor.APC = self;
        }
        objVars.Length = 0;
        BlockPuzzleActor.Pieces.Length = 0;
        inAction.GetObjectVars(objVars, "Block Pieces");
        if (objVars.Length != BlockPuzzleActor.PieceNum)
        {
            ClientMessage("=== Piece Num Error!!!===");
            return;
        }
        BlockPuzzleActor.Pieces.Length = BlockPuzzleActor.PieceNum + 1;
        for (I = 0; I < objVars.Length; I++)
        {
            Piece = AliceBlockPiece(objVars[I]);
            if (Piece == none || Piece.Id < 1 || Piece.Id > BlockPuzzleActor.PieceNum)
            {
                ClientMessage("=== Piece ID Error!!!===");
                return;
            }
            BlockPuzzleActor.Pieces[Piece.Id] = Piece;
        }
        BlockPuzzleActor.InitAssamble(false);
    }
}

function OnSetSonarActor(SeqAct_SetSonarActor inAction)
{
    local array<Object> objVars;
    local Object Object;
    local Actor sonarActor;
    local int iActive;
    
    objVars.Length = 0;
    inAction.GetObjectVars(objVars, "Sonar Actors");
    if (inAction.InputLinks[0].bHasImpulse)
    {
        foreach objVars(Object)
        {
            sonarActor = Actor(Object);
            if (sonarActor != none)
            {
                SonarManager.setSonarActive(sonarActor, true);
            }
        }
    }
    else if (inAction.InputLinks[1].bHasImpulse)
    {
        foreach objVars(Object)
        {
            sonarActor = Actor(Object);
            if (sonarActor != none)
            {
                SonarManager.setSonarActive(sonarActor, false);
            }
        }
    }
    else if (inAction.InputLinks[2].bHasImpulse)
    {
        foreach objVars(Object)
        {
            sonarActor = Actor(Object);
            if (sonarActor != none)
            {
                if (class'AliceSonarManager'.static.isSonarActor(sonarActor, iActive))
                {
                    SonarManager.setSonarActive(sonarActor, iActive == 1 ? false : true);
                }
            }
        }
    }
}

exec function MoveBlockPieceB()
{
}

exec function MoveBlockPieceA()
{
}

function showChessPuzzleLeftStep(int Left)
{
    if (AliceGameInfo(WorldInfo.Game).GFxHUDMenu != none)
    {
        AliceGameInfo(WorldInfo.Game).GFxHUDMenu.showChessPuzzleLeftStep(Left);
    }
}

function showBlockPuzzleLeftStep(int Left)
{
    if (AliceGameInfo(WorldInfo.Game).GFxHUDMenu != none)
    {
        AliceGameInfo(WorldInfo.Game).GFxHUDMenu.showBlockPuzzleLeftStep(Left);
    }
}

function closeMoveCircle()
{
    if (AliceGameInfo(WorldInfo.Game).GFxHUDMenu != none)
    {
        AliceGameInfo(WorldInfo.Game).GFxHUDMenu.closeMoveCircle();
    }
}

function showMoveCircle()
{
    if (AliceGameInfo(WorldInfo.Game).GFxHUDMenu != none)
    {
        AliceGameInfo(WorldInfo.Game).GFxHUDMenu.showMoveCircle();
    }
}

function showBlockPuzzleUI(bool bShow)
{
    if (AliceGameInfo(WorldInfo.Game).GFxHUDMenu != none)
    {
        AliceGameInfo(WorldInfo.Game).GFxHUDMenu.showBlockPuzzleUI(bShow);
    }
}

exec function TurretMineFire()
{
    local int I;
    
    for (I = 0; I < AliceTurret2DManager.Length; I++)
    {
        if (AliceTurret2DManager[I].Turret2D_Array[0].IsA('Alice2DTurretMine'))
        {
            AliceTurret2DManager[I].Fire();
            return;
        }
    }
}

exec function TurretCannonFire()
{
    local int I;
    
    for (I = 0; I < AliceTurret2DManager.Length; I++)
    {
        if (!AliceTurret2DManager[I].Turret2D_Array[0].IsA('Alice2DTurretMine'))
        {
            AliceTurret2DManager[I].Fire();
            return;
        }
    }
}

function int getControlLayout()
{
    return AlicePlayerInput(PlayerInput).layout.LayoutIndex;
}

exec function setControlLayout(int Index)
{
    AlicePlayerInput(PlayerInput).setControlLayout(Index);
}

function PostMeleeAttack()
{
    SetWeaponEnviormentCollision(false);
}

function SetWeaponEnviormentCollision(bool bEnable)
{
    bEnableWeaponEnviormentCollision = bEnable;
}

function PreMeleeAttack()
{
    SetWeaponEnviormentCollision(true);
}

event float GetOriForward()
{
    return AlicePlayerInput(PlayerInput).OriForward;
}

event float GetOriStrafe()
{
    return AlicePlayerInput(PlayerInput).OriStrafe;
}

function ResetSteamFloat()
{
    bFloatLeaveSteam = false;
}

native function GetVolumeGeometryInfo(Volume Volume, out float MinHeight, out float MaxHeight)
{
    Volume;
    MinHeight;
    MaxHeight;
}

function ResetDelayCameraTime()
{
    bDelayCameraInSteam = false;
}

function bool IsNewHoverControl()
{
    if (AliceCheatManager(CheatManager) != none)
    {
        return AliceCheatManager(CheatManager).bNewHoverControl;
    }
    return false;
}

function bool ShouldCancelSprint()
{
    local bool bResult;
    
    bResult = MyAlicePawn.isInConversationMode() || !IsInState('PlayerWalking') || bCinematicMode;
    return bResult;
}

function ForceEndStateInCinematic()
{
}

function SetCinematicMode(bool bInCinematicMode, bool bHidePlayer, bool bAffectsHUD, bool bAffectsMovement, bool bAffectsTurning, bool bAffectsButtons, bool bHideCurrenWeapon, bool bPauseClockBomb)
{
    local Rotator ResetRoll;
    local EPhysics CinematicPhysic;
    
    bGodMode = bInCinematicMode;
    SetCinematicMode(bInCinematicMode, bHidePlayer, bAffectsHUD, bAffectsMovement, bAffectsTurning, bAffectsButtons, bHideCurrenWeapon, bPauseClockBomb);
    if (bAffectsButtons)
    {
        AlicePlayerInput(PlayerInput).bDisableInputInCinematic = bInCinematicMode;
        if (bInCinematicMode)
        {
            IgnoreMoveInput(bInCinematicMode);
        }
        else
        {
            FroceResetIgnoreMoveInput();
        }
    }
    if (bInCinematicMode && MyAlicePawn.bIsJumping)
    {
        MyAlicePawn.bIsJumping = false;
        MyAlicePawn.bIsDoubleJumping = false;
    }
    if (!IsInState('Dead') && !IsInState('PlayerRoll'))
    {
        bHoldToggleLockOnButton = false;
        CinematicPhysic = MyAlicePawn.Physics;
        RecoverToDefaultStatus(true);
        if (bInCinematicMode)
        {
            MyAlicePawn.SetPhysics(CinematicPhysic);
        }
        else
        {
            MyAlicePawn.SetPhysics(1);
        }
    }
    MyAlicePawn.bAllowFacingTargetInSpeicalMove = false;
    if (bInCinematicMode)
    {
        MyAlicePawn.Landed(vect(0.0, 0.0, 1.0), none);
        OnSMLaned();
    }
    else
    {
        HideSkipUI();
    }
    if (bPauseClockBomb)
    {
        if (MyAlicePawn.bClockBombCountingDown && MyAlicePawn.MyClonePawn != none)
        {
            AliceClonePawn(MyAlicePawn.MyClonePawn).bShouldPause = bInCinematicMode;
            if (!bInCinematicMode && AliceClonePawn(MyAlicePawn.MyClonePawn).CloneState == 0 && AliceClonePawn(MyAlicePawn.MyClonePawn).BombType == 1)
            {
                AliceClonePawn(MyAlicePawn.MyClonePawn).SetupStart();
            }
        }
        else
        {
            bPauseTickForNextClockBomb = bInCinematicMode;
        }
    }
    if (MyAlicePawn.Weapon != none)
    {
        if (WeaponForAliceRange(MyAlicePawn.Weapon) != none)
        {
            WeaponForAliceRange(MyAlicePawn.Weapon).bReleasedFireButton = true;
        }
        MyAlicePawn.FadeOutWeapon();
    }
    MyAlicePawn.ResetAliceCameraProperties();
    ResetRoll = Rotation;
    ResetRoll.Roll = 0;
    SetRotation(ResetRoll);
    MyAlicePawn.EnableForceTranslucency(false, 1.0, 0.0, 1000, false);
    ForceEndStateInCinematic();
}

reliable client simulated function ClientSetCinematicMode(bool bInCinematicMode, bool bAffectsMovement, bool bAffectsTurning, bool bAffectsHUD, bool bHideCurrenWeapon)
{
    local HealthPickup HP;
    local XPPickup XP;
    
    ClientSetCinematicMode(bInCinematicMode, bAffectsMovement, bAffectsTurning, bAffectsHUD, bHideCurrenWeapon);
    if (AliceGameInfo(WorldInfo.Game).GFxHUDMenu != none)
    {
        AliceGameInfo(WorldInfo.Game).GFxHUDMenu.Hide(bInCinematicMode);
        AliceGameInfo(WorldInfo.Game).GFxHUDMenu.SetCinematicMode(bInCinematicMode);
    }
    if (bInCinematicMode)
    {
        foreach DynamicActors(class'HealthPickup', HP)
        {
            HP.bInCinematicMode = true;
            HP.LeftLifeTimeWhenPause = HP.LifeSpan;
        }
        foreach DynamicActors(class'XPPickup', XP)
        {
            XP.LeftLifeTimeWhenPause = XP.LifeSpan;
            XP.bInCinematicMode = true;
        }
    }
    else
    {
        foreach DynamicActors(class'HealthPickup', HP)
        {
            HP.bInCinematicMode = false;
        }
        foreach DynamicActors(class'XPPickup', XP)
        {
            XP.bInCinematicMode = false;
        }
    }
}

function OnForceResetCamera(SeqAct_ForceResetCamera Action)
{
    ForceResetCamera();
}

function OnEmitCameraEffect(SeqAct_EmitCameraEffect Action)
{
    ClientSpawnCameraLensEffect(class<EmitterCameraLensEffectBase>(Action.Emitter));
}

function UpdateRangeWeaponUI()
{
    local Inventory Inv;
    
    if (Pawn != none)
    {
        Inv = Pawn.FindInventoryType(class'TeapotCannon');
        if (TeapotCannon(Inv) != none)
        {
            TeapotCannon(Inv).UpdateAmmoUI();
        }
        Inv = Pawn.FindInventoryType(class'EyeStaff');
        if (WeaponForAlice(Inv) != none)
        {
            EyeStaff(Inv).UpdateAmmoUI();
        }
    }
}

function forceUpdateRangeWeaponUI()
{
    local Inventory Inv;
    
    if (Pawn != none)
    {
        Inv = Pawn.FindInventoryType(class'TeapotCannon');
        if (TeapotCannon(Inv) != none)
        {
            TeapotCannon(Inv).forceUpdateAmmoUI();
        }
        Inv = Pawn.FindInventoryType(class'EyeStaff');
        if (WeaponForAlice(Inv) != none)
        {
            EyeStaff(Inv).forceUpdateAmmoUI();
        }
    }
}

function ResetRangeWeapons()
{
    local Inventory Inv;
    
    if (Pawn != none)
    {
        Inv = Pawn.FindInventoryType(class'TeapotCannon');
        if (TeapotCannon(Inv) != none)
        {
            TeapotCannon(Inv).ResetAliceWeapon();
        }
        Inv = Pawn.FindInventoryType(class'EyeStaff');
        if (EyeStaff(Inv) != none)
        {
            EyeStaff(Inv).ResetAliceWeapon();
        }
    }
}

function PlayDeadEffect()
{
    MyAlicePawn.DeathParticleEmitter = Spawn(class'Engine.EmitterSpawnable', self);
    if (MyAlicePawn.DeathParticleEmitter != none && MyAlicePawn.DeathParticle != none)
    {
        MyAlicePawn.DeathParticleEmitter.SetLocation(MyAlicePawn.Location);
        MyAlicePawn.DeathParticleEmitter.ParticleSystemComponent.__OnSystemFinished__Delegate = OnDeathParticleFinished;
        MyAlicePawn.DeathParticleEmitter.SetTemplate(MyAlicePawn.DeathParticle, true);
    }
    PlaySound(MyAlicePawn.DeathSound);
}

function OnDeathParticleFinished(ParticleSystemComponent PSC)
{
    MyAlicePawn.ResetTimeVaryingMaterials();
    MyAlicePawn.Health = 0;
    ShowDeathConfirmDialog();
}

function RestartAlice()
{
    local int SocketIndex;
    
    PlayerCamera.ClearAllCameraShakes();
    bConfirmToRespawn = false;
    PlayerMovementStates[curIndexOfPlayerMovementState].SetPlayerBasicMovementState(0);
    MyAlicePawn.bIsSprinting = false;
    MyAlicePawn.bIsJumping = false;
    MyAlicePawn.bIsDoubleJumping = false;
    MyAlicePawn.LeaveHysteriaMode();
    MyAlicePawn.SetPhysics(0);
    MyAlicePawn.FadeOutUmbrella();
    for (SocketIndex = 0; SocketIndex < MyAlicePawn.AttachNPCSockets.Length; SocketIndex++)
    {
        MyAlicePawn.AttachNPCSockets[SocketIndex].bOccupied = false;
        MyAlicePawn.AttachNPCSockets[SocketIndex].AttachedNPC = none;
    }
    ResetRangeWeapons();
    StopFire(MyAlicePawn.Weapon.CurrentFireMode);
    bHoldToggleLockOnButton = false;
    MyAlicePawn.ResetClothHair(false, true);
    MyAlicePawn.SetPhysics(0);
    MyAlicePawn.Acceleration = vect(0.0, 0.0, 0.0);
    MyAlicePawn.Velocity = vect(0.0, 0.0, 0.0);
    CrowdAgentsCount = 0;
    if (MyAlicePawn.bInGiantMode)
    {
        MyAlicePawn.MaxWalkingSpeed = MyAlicePawn.default.MaxWalkingSpeed;
        MyAlicePawn.MaxRunningSpeed = MyAlicePawn.default.MaxRunningSpeed;
        MyAlicePawn.Mesh.GlobalAnimRateScale = 1.0;
    }
    ShowLockOnTargetUI(false);
    MyAlicePawn.SetCollision(false, false);
    OnSMLaned();
    if (bShrinkingModeActive)
    {
        UnShrinking();
    }
    if (MyAlicePawn.bClockBombCountingDown)
    {
        AliceClonePawn(MyAlicePawn.MyClonePawn).Detonate();
    }
    MyAlicePawn.SetPawnStance(0);
    MyAlicePawn.SetPhysics(1);
    MyAlicePawn.HideAlicePawn(false);
    bIgnoreMoveInput = 0;
    MyAlicePawn.DoSpecialMove(0);
    CycleFloatManager.Init();
    MyAlicePawn.EnableForceTranslucency(false, 1.0, 0.0, 1000, false);
    MyAlicePawn.SetCollision(true, true);
    if (MyAlicePawn.bInRollingMode)
    {
        AlicePawn(Pawn).StartRoll();
        GotoState('PlayerRoll');
    }
    AliceGameInfo(WorldInfo.Game).ReSetUIAfterLoadCheckPoint();
}

event ShowDeathConfirmDialog()
{
    if (AliceGameInfo(WorldInfo.Game).GFxHUDMenu != none)
    {
        AliceGameInfo(WorldInfo.Game).GFxHUDMenu.showDeath();
    }
}

function OnToggleGlide(SeqAct_ToggleGlide Action)
{
    local int GlideType;
    
    if (Action.InputLinks[0].bHasImpulse)
    {
        GlideType = 1;
    }
    else if (Action.InputLinks[1].bHasImpulse)
    {
        GlideType = 0;
    }
    else if (Action.InputLinks[2].bHasImpulse)
    {
        GlideType = (AlicePawn(Pawn).GlideType == 0 ? 1 : 0);
    }
    AlicePawn(Pawn).SetGlideType(GlideType);
}

simulated function OnTeleport(SeqAct_Teleport Action)
{
    local Vector Loc;
    
    bSetViewTargetImmediately = true;
    OnTeleport(Action);
    if (IsInState('PlayerFloat') || IsDodging())
    {
        MyAlicePawn.Landed(vect(0.0, 0.0, 1.0), none);
        OnSMLaned();
    }
    if (IsInState('AttachedByNPCs'))
    {
        MyAlicePawn.ForceDetachAllNPC();
        GotoState('PlayerWalking');
    }
}

event ClearOnRequestUnloadLevel(LevelStreaming StreamingLevel)
{
    PlayerCamera.ClearCameraShakesWithOuter(StreamingLevel.PackageName);
}

function ShowCancelMatineeHint(bool bShow, string sText)
{
    bCancelMatineeHintExisting = bShow;
    if (bShow && AliceGameInfo(WorldInfo.Game).SkipCinematicCounter >= 15)
    {
        TryToCancelMatinee();
        return;
    }
    if (AliceGameInfo(WorldInfo.Game).GFxHUDMenu != none)
    {
        AliceGameInfo(WorldInfo.Game).GFxHUDMenu.ShowCancelMatineeHint(bShow, sText);
    }
    if (bShow)
    {
        AliceGameInfo(WorldInfo.Game).SkipCinematicCounter++;
    }
}

native function bool ShouldShowSkipUI(out SeqAct_Interp outMatinee)
{
    outMatinee;
}

function HideSkipUI()
{
    ShowCancelMatineeHint(false, "");
    AliceCheatManager(CheatManager).CurrentMatinee = none;
}

exec function TryToCancelMatinee()
{
    local SeqAct_Interp Matinee;
    
    if (ShouldShowSkipUI(Matinee))
    {
        if (bCancelMatineeHintExisting)
        {
            ConsoleCommand("CANCELALICEGAMEMATINEE");
            ShowCancelMatineeHint(false, "");
        }
        else
        {
            ShowCancelMatineeHint(true, Matinee.UIText);
            SetTimer(Matinee.SkipUIDuration, false, 'HideSkipUI');
        }
    }
    else
    {
        ConsoleCommand("CANCELALICEGAMEMATINEE");
    }
}

function notifyInputKey(int ControllerId, name Key, EInputEvent Event, float AmountDepressed, bool bGamepad)
{
    local SeqAct_Interp Matinee;
    
    if (bInRailRideMode || AliceGameInfo(WorldInfo.Game).SkipCinematicCounter >= 15)
    {
        return;
    }
    if (AliceCheatManager(CheatManager).ShouldShowSkipUI())
    {
        if (Key != 'XboxTypeS_Back' && Key != 'XboxTypeS_Start' && !IsPaused())
        {
            if (!bCancelMatineeHintExisting)
            {
                ShowCancelMatineeHint(true, AliceCheatManager(CheatManager).CurrentMatinee.UIText);
                SetTimer(AliceCheatManager(CheatManager).CurrentMatinee.SkipUIDuration, false, 'HideSkipUI');
            }
        }
    }
    else if (ShouldShowSkipUI(Matinee) && Key != 'XboxTypeS_Back' && Key != 'XboxTypeS_Start' && !IsPaused())
    {
        AliceCheatManager(CheatManager).CurrentMatinee = Matinee;
        if (!bCancelMatineeHintExisting)
        {
            ShowCancelMatineeHint(true, Matinee.UIText);
            SetTimer(Matinee.SkipUIDuration, false, 'HideSkipUI');
        }
    }
}

event RespawnAlice()
{
    SetRotation(MyAlicePawn.Rotation);
    bSetViewTargetImmediately = true;
    if (respawn_info.Level == 2)
    {
        if (RespawnParticleEmitter != none)
        {
            RespawnParticleEmitter.Destroy();
            ClientForceGarbageCollection();
        }
        RespawnParticleEmitter = Spawn(class'Engine.EmitterSpawnable', self, , MyAlicePawn.Location);
        if (RespawnParticleEmitter != none && respawn_info.ParticleRespawn != none)
        {
            RespawnParticleEmitter.SetLocation(MyAlicePawn.Location);
            RespawnParticleEmitter.SetTemplate(respawn_info.ParticleRespawn, true);
            if (MyAlicePawn.bInRollingMode)
            {
                OnWonderlandDeathParticleFinished(RespawnParticleEmitter.ParticleSystemComponent);
            }
            else
            {
                ExecWonderlandDeathParticleFinished();
                IgnoreMoveInput(true);
                RespawnParticleEmitter.ParticleSystemComponent.__OnSystemFinished__Delegate = OnWonderlandDeathParticleFinished2;
            }
        }
        else
        {
            respawn_info.Level = 0;
            IgnoreMoveInput(false);
            BeforeUnHideAlice();
            MyAlicePawn.HideAlicePawn(false);
            GotoNextState();
        }
        MyAlicePawn.bHasDodgeInAir = false;
        PlaySound(respawn_info.ParticleRespawnSound);
    }
    else if (respawn_info.Level == 1)
    {
        BeforeUnHideAlice();
        MyAlicePawn.HideAlicePawn(false);
        IgnoreMoveInput(false);
        MyAlicePawn.ResetClothHair();
        respawn_info.Level = 0;
        MyAlicePawn.SetPhysics(1);
        GotoNextState();
        return;
    }
    else
    {
        MyAlicePawn.CurrentCameraAnim = MyAlicePawn.RespawnCamera;
        MyAlicePawn.DeathParticleEmitter = Spawn(class'Engine.EmitterSpawnable', self, , MyAlicePawn.Location);
        if (MyAlicePawn.DeathParticleEmitter != none && MyAlicePawn.RespawnParticle != none)
        {
            MyAlicePawn.DeathParticleEmitter.SetLocation(MyAlicePawn.Location);
            MyAlicePawn.DeathParticleEmitter.SetTemplate(MyAlicePawn.RespawnParticle, true);
            MyAlicePawn.DeathParticleEmitter.ParticleSystemComponent.__OnSystemFinished__Delegate = OnRespawnParticleFinished;
        }
        PlaySound(MyAlicePawn.RespawnSound);
    }
    respawn_info.Level = 0;
}

function ExecWonderlandDeathParticleFinished()
{
    BeforeUnHideAlice();
    GotoNextState();
}

function OnWonderlandDeathParticleFinished2(ParticleSystemComponent PSC)
{
    IgnoreMoveInput(false);
}

function OnWonderlandDeathParticleFinished(ParticleSystemComponent PSC)
{
    IgnoreMoveInput(false);
    BeforeUnHideAlice();
    GotoNextState();
}

function OnRespawnParticleFinished(ParticleSystemComponent PSC)
{
    BeforeUnHideAlice();
    if (!(bCinematicMode && bHidden))
    {
        MyAlicePawn.HideAlicePawn(false);
    }
    GotoNextState();
}

function BeforeUnHideAlice()
{
    if (bShrinkingModeActive)
    {
        bShrinkingModeActive = false;
        AlicePawn(Pawn).bShrinkingModeActive = bShrinkingModeActive;
        LeavingbShrinkingMode();
    }
    MyAlicePawn.CurrentCameraAnim = MyAlicePawn.DefaultCamera.Animation;
    MyAlicePawn.ResetClothHair();
    MyAlicePawn.SkirtComponent.RadialForceMagnitude = 0.0;
    MyAlicePawn.RibbonComponent.RadialForceMagnitude = 0.0;
    MyAlicePawn.BowComponent.RadialForceMagnitude = 0.0;
    MyAlicePawn.SetPawnStance(0);
    if (MyAlicePawn.Weapon != none)
    {
        MyAlicePawn.FadeOutWeapon();
    }
}

function GotoNextState()
{
    if (MyAlicePawn.bInRollingMode)
    {
        GotoState('PlayerRoll');
    }
    else if (BlockPuzzleActor != none && BlockPuzzleActor.IsReadyToPlay())
    {
        GotoState('PlayerBlockPuzzle');
    }
    else
    {
        GotoState('PlayerWalking');
    }
}

function ShowContextActionUIHint(int show, optional string sText)
{
    if (AliceGameInfo(WorldInfo.Game).GFxHUDMenu != none)
    {
        if (sText == "INSPECT_LOOK_GENERIC")
        {
            AliceGameInfo(WorldInfo.Game).GFxHUDMenu.ShowLockOnUIHint(show, sText);
        }
        else
        {
            AliceGameInfo(WorldInfo.Game).GFxHUDMenu.ShowInteractPressX(float(show), sText);
        }
    }
}

function ResetFade()
{
    local Vector2D FadeAlpha;
    
    FadeAlpha.X = 1.0;
    FadeAlpha.Y = 0.0;
    ClientSetCameraFade(true, PlayerCamera.FadeColor, FadeAlpha, 0.1);
}

exec function FadeOutTest(bool bEnable, float X, float Y, float R, float G, float B, float A, float FadeTime)
{
    local Color FadeColor;
    local Vector2D FadeAlpha;
    
    FadeAlpha.X = X;
    FadeAlpha.Y = Y;
    FadeColor.R = byte(R);
    FadeColor.G = byte(G);
    FadeColor.B = byte(B);
    FadeColor.A = byte(A);
    ClientSetCameraFade(bEnable, FadeColor, FadeAlpha, FadeTime);
}

event ShowKismetCustomUI(float Duration, string sText, EKismetToggleUIType Type)
{
    if (AliceGameInfo(WorldInfo.Game).GFxHUDMenu != none)
    {
        AliceGameInfo(WorldInfo.Game).GFxHUDMenu.ShowKismetCustomUI(Duration, sText, Type);
    }
}

event ShowDodgeToEndGrabUI(optional float fTime = 2.0)
{
    local string Str;
    
    Str = Localize("Global", "Dodge_To_Escape", "GFxUI");
    AliceGameInfo(WorldInfo.Game).GFxHUDMenu.ShowInteractPressX(fTime, Str);
}

function TurnOffDodgeToEndGrabUI()
{
    ShowDodgeToEndGrabUI(-1.0);
}

function TurnOnDodgeToEndGrabUI()
{
    ShowDodgeToEndGrabUI(0.0);
}

function ChangeAliceEnvironment(bool bInLondon)
{
    if (AliceGameInfo(WorldInfo.Game).GFxHUDMenu != none)
    {
        AliceGameInfo(WorldInfo.Game).GFxHUDMenu.ChangeAliceEnvironment(bInLondon);
    }
}

function UpdateCrossHairPosition()
{
    if (AliceGameInfo(WorldInfo.Game).GFxHUDMenu != none)
    {
        AliceGameInfo(WorldInfo.Game).GFxHUDMenu.UpdateCrossHairPosition(self);
    }
}

event ShowHealthUI(int curHealth, int maxHealth)
{
    if (AliceGameInfo(WorldInfo.Game).GFxHUDMenu != none)
    {
        AliceGameInfo(WorldInfo.Game).GFxHUDMenu.UpdateAliceHealth(curHealth, maxHealth);
        if (MyAlicePawn.bMatchHysteriaModeCondition)
        {
            AliceGameInfo(WorldInfo.Game).GFxHUDMenu.HysteriaReady();
        }
        else
        {
            AliceGameInfo(WorldInfo.Game).GFxHUDMenu.CancelHysteriaReady();
        }
    }
}

function ShowCrossHair(bool bShow)
{
    if (AliceGameInfo(WorldInfo.Game).GFxHUDMenu != none)
    {
        AliceGameInfo(WorldInfo.Game).GFxHUDMenu.ShowCrossHair(bShow);
    }
}

function ShowLockOnTargetUI(bool bShow)
{
    if (AliceGameInfo(WorldInfo.Game).GFxHUDMenu != none)
    {
        AliceGameInfo(WorldInfo.Game).GFxHUDMenu.ShowLockOnIndicator(bShow);
    }
}

function UpdateLockOnTargetUI()
{
    if (AliceGameInfo(WorldInfo.Game).GFxHUDMenu != none)
    {
        AliceGameInfo(WorldInfo.Game).GFxHUDMenu.UpdateTargetPosition(self);
    }
}

function UpdateAimTargetUI(bool bOnTarget)
{
    bAimOnTarget = bOnTarget;
    AliceGameInfo(WorldInfo.Game).GFxHUDMenu.UpdateAimTargetUI(bOnTarget);
}

function bool GetPOILocation(out Vector Loc)
{
    local AlicePlayerCamera Cam;
    
    Cam = AlicePlayerCamera(PlayerCamera);
    if (Cam != none && GameThirdPersonCamera(Cam.ThirdPersonCam) != none)
    {
        Loc = GameThirdPersonCamera(Cam.ThirdPersonCam).GetActualFocusLocation();
        return true;
    }
    return false;
}

function bool IsInPOIMode()
{
    local AlicePlayerCamera Cam;
    
    Cam = AlicePlayerCamera(PlayerCamera);
    if (Cam != none && GameThirdPersonCamera(Cam.ThirdPersonCam) != none && GameThirdPersonCamera(Cam.ThirdPersonCam).bFocusPointSet)
    {
        return true;
    }
    return false;
}

function ChangeResolution(string Mode)
{
    if (AliceGameInfo(WorldInfo.Game).GFxHUDMenu != none)
    {
        AliceGameInfo(WorldInfo.Game).GFxHUDMenu.ChangeResolution(Mode);
    }
}

function ChangeAimIcon(int Id)
{
    if (AliceGameInfo(WorldInfo.Game).GFxHUDMenu != none)
    {
        AliceGameInfo(WorldInfo.Game).GFxHUDMenu.ChangeAimIcon(Id);
    }
}

function ShowPOIUIHint(float fDuration, optional string sText)
{
    if (AliceGameInfo(WorldInfo.Game).GFxHUDMenu != none)
    {
        AliceGameInfo(WorldInfo.Game).GFxHUDMenu.ShowPOIUIHint(fDuration, sText);
    }
}

exec function CycleFloatInputRB()
{
    if (!isNewCycleControl() || IsInState('PlayerSteamVent') || bCheatFlying)
    {
        return;
    }
    CycleFloatManager.CycleFloatInput();
}

exec function CycleFloatInputA()
{
    if (isNewCycleControl() || IsInState('PlayerSteamVent') || bCheatFlying)
    {
        return;
    }
    CycleFloatManager.CycleFloatInput();
}

event GetFloatAnimInfo(out float UpWeight, out float RightWeight)
{
    UpWeight = 0.0;
    RightWeight = 0.0;
}

function SpecialMoveStarted(ESpecialMove NewMove)
{
}

final function EndSpecialMove()
{
    if (IsDoingASpecialMove())
    {
        if (MyAlicePawn != none)
        {
            MyAlicePawn.LocalEndSpecialMove();
        }
    }
}

final event DoSpecialMove(ESpecialMove NewMove, optional bool bForceMove = false, optional AliceGamePawn InInteractionPawn, optional int InSpecialMoveFlags = 0)
{
    local SMStruct NewMoveStruct;
    
    if (LocalPlayer(Player) == none)
    {
        WarnInternal(string(GetFuncName()) @ "has to be called from local player!");
        ScriptTrace();
        return;
    }
    bForceMove = bForceMove;
    if (bForceMove || CanDoSpecialMove(NewMove))
    {
        NewMoveStruct = MyAlicePawn.FillSMStructFromParams(NewMove, InInteractionPawn, InSpecialMoveFlags);
        MyAlicePawn.DoSpecialMoveFromStruct(NewMoveStruct, bForceMove);
    }
}

native final function bool CanDoSpecialMove(ESpecialMove AMove, optional bool bForceCheck)
{
    AMove;
    bForceCheck;
}

simulated function bool IsDoingSpecialMove(ESpecialMove AMove)
{
    return MyAlicePawn != none && MyAlicePawn.IsDoingSpecialMove(AMove);
}

function bool IsDoingASpecialMove()
{
    return MyAlicePawn != none && MyAlicePawn.IsDoingASpecialMove();
}

exec function Pickup()
{
    local MemoryFragmentNormal pickitem;
    local HealthUpgradePickup HealthUpgradePickupItem;
    local SecretPickup SecretPickUpItem;
    local BigSecretPickup BigSecretPickUpItem;
    
    foreach AllActors(class'MemoryFragmentNormal', pickitem)
    {
        if (!pickitem.bPickUped && VSize(MyAlicePawn.Location - pickitem.Location) < pickitem.PickupRadius)
        {
            if (SecretPickup(pickitem) != none)
            {
                setSecretPick(SecretPickup(pickitem).secrettag);
                continue;
            }
            if (BigSecretPickup(pickitem) != none)
            {
                setSecretPick(BigSecretPickup(pickitem).secrettag);
                continue;
            }
            pickitem.ActivePickup();
            bPickupAction = true;
        }
    }
    foreach AllActors(class'HealthUpgradePickup', HealthUpgradePickupItem)
    {
        if (!HealthUpgradePickupItem.bPickUped && VSize(MyAlicePawn.Location - HealthUpgradePickupItem.Location) < HealthUpgradePickupItem.PickupRadius)
        {
            HealthUpgradePickupItem.ActivePickup();
            bPickupAction = true;
        }
    }
    foreach AllActors(class'SecretPickup', SecretPickUpItem)
    {
        if (!SecretPickUpItem.bPickUped && VSize(MyAlicePawn.Location - SecretPickUpItem.Location) < SecretPickUpItem.PickupRadius)
        {
            SecretPickUpItem.ActivePickup();
            setSecretPick(SecretPickUpItem.secrettag);
            bPickupAction = true;
        }
    }
    foreach AllActors(class'BigSecretPickup', BigSecretPickUpItem)
    {
        if (!BigSecretPickUpItem.bPickUped && VSize(MyAlicePawn.Location - BigSecretPickUpItem.Location) < BigSecretPickUpItem.PickupRadius)
        {
            BigSecretPickUpItem.ActivePickup();
            setSecretPick(BigSecretPickUpItem.secrettag);
            bPickupAction = true;
        }
    }
}

function ContinueToGame()
{
    local Vector2D ViewSize;
    
    bJournalPause = false;
    SetPause(false, CanUnpause);
    SetRenderSubtitles(true);
    AliceGameInfo(WorldInfo.Game).inGameMenu.PlaySoundWhenPause(CloseInGameMenuSound);
    AliceGameInfo(WorldInfo.Game).inGameMenu.APC = none;
    AliceGameInfo(WorldInfo.Game).inGameMenu.SetFocus(false, false);
    AliceGameInfo(WorldInfo.Game).GFxHUDMenu.Hide(false);
    PauseBinkFile(false);
    LogInternal("FocusedMovie: " @ string(FocusedMovie));
    if (FocusedMovie != none && bInRailRideMode)
    {
        FocusedMovie.GetGameViewportClient().GetViewportSize(ViewSize);
        FocusedMovie.SetViewport(0, 0, int(ViewSize.X), int(ViewSize.Y));
    }
    else
    {
        AliceGameInfo(WorldInfo.Game).GFxHUDMenu.SetFocus(false, true);
    }
}

exec function ShowJournalMenu()
{
    if (WorldInfo.GetMapName() != "AliceEntry" && !AliceGameInfo(WorldInfo.Game).IsInSavingLoadingProcess())
    {
        if (FocusedMovie != none && FocusedMovie != AliceGameInfo(WorldInfo.Game).inGameMenu && !bInRailRideMode)
        {
            return;
        }
        if (bInRailRideMode)
        {
            FocusedMovie.SetViewport(0, 0, 1, 1);
        }
        SetRenderSubtitles(false);
        AliceGameInfo(WorldInfo.Game).inGameMenu.SetFocus(true, true);
        AliceGameInfo(WorldInfo.Game).inGameMenu.APC = self;
        AliceGameInfo(WorldInfo.Game).inGameMenu.OpenMenu();
        AliceGameInfo(WorldInfo.Game).GFxHUDMenu.Hide(true);
        bJournalPause = true;
        SetPause(true, CanUnpause);
        HideSkipUI();
        PauseBinkFile(true);
    }
}

delegate bool CanUnpause()
{
    return !bJournalPause;
}

exec function AbortConversation(bool bPressed)
{
    if (AlicePlayerInput(PlayerInput).bDisableInputInCinematic)
    {
        return;
    }
    if (AlicePawn(Pawn).isInConversationMode())
    {
        if (bPressed)
        {
            bPressedBackButton = true;
            fBackButtonHoldTime = 0.0;
        }
    }
}

reliable server final function ServerAbortConversation()
{
    bPendingConversationAbort = true;
}

reliable client final simulated event ClientSetConversationMode(bool bEnabled, optional bool bAbortable)
{
    bHavingAnAbortableConversation = bEnabled && bAbortable;
    bPendingConversationAbort = false;
}

simulated function OnManageObjectives(SeqAct_ManageObjectives Action)
{
    if (ObjectiveMgr != none)
    {
        ObjectiveMgr.OnManageObjectives(Action);
    }
}

function NotifyTakeHit(Controller InstigatedBy, Vector HitLocation, int Damage, class<DamageType> DamageType, Vector Momentum)
{
    KynapseTakeDamager(InstigatedBy, HitLocation, Damage, DamageType, Momentum);
}

native function KynapseTakeDamager(Controller InstigatedBy, Vector HitLocation, int Damage, class<DamageType> DamageType, Vector Momentum)
{
    InstigatedBy;
    HitLocation;
    Damage;
    DamageType;
    Momentum;
}

function RemoveCameraEffect(EmitterCameraLensEffectBase CamEmitter)
{
    if (CameraEffect == CamEmitter)
    {
        CameraEffect = none;
    }
}

function CalcCameraLocInfo()
{
    local Vector POILoc, AliceEyeLoc, cameraLoc;
    local Rotator AliceEyeRot, cameraRot;
    
    if (GetPOILocation(POILoc))
    {
        AlicePawn(Pawn).GetActorEyesViewPoint(AliceEyeLoc, AliceEyeRot);
        AlicePlayerCamera(PlayerCamera).GetCameraViewPoint(cameraLoc, cameraRot);
        bCameraLocOnLeft = ((POILoc - AliceEyeLoc) Cross (cameraLoc - AliceEyeLoc)).Z > float(0);
    }
}

exec function TogglePOI(bool bEnable)
{
    local AliceGameKynapsePawn npc;
    local AlicePointOfInterest POI;
    
    if (AlicePlayerInput(PlayerInput).bDisableInputInCinematic)
    {
        return;
    }
    if (EnabledPointsOfInterest.Length == 0)
    {
        return;
    }
    foreach EnabledPointsOfInterest(POI)
    {
        if (POI.ForceLookType == 1)
        {
            return;
        }
    }
    if (MyAlicePawn.Physics != 1 || bShrinkingModeActive || IsShrinking || IsUnShrinking || TargetingActor != none || IsInState('PlayerLockOnTarget'))
    {
        return;
    }
    foreach DynamicActors(class'AliceGameKynapsePawn', npc)
    {
        if (VSize(npc.Location - MyAlicePawn.Location) < float(2048))
        {
            return;
        }
    }
    if (bIsHoldingPOIButton != bEnable)
    {
        if (bEnable)
        {
            TryPOILookAt();
            CalcCameraLocInfo();
        }
        else
        {
            TryPOILookAway();
            FroceResetIgnoreMoveInput();
        }
        bIsHoldingPOIButton = bEnable;
    }
}

simulated function bool HasLineOfSightToPOI(AlicePointOfInterest POI)
{
    local Actor HitActor;
    local Vector ActualLookatLoc, HitLoc, HitNormal, StartTrace, StartTraceAdj;
    
    if (POI.bForceLookCheckLineOfSight)
    {
        ActualLookatLoc = POI.GetActualLookatLocation();
        StartTrace = Pawn.Location + vect(0.0, 0.0, 1.0) * Pawn.GetCollisionHeight();
        if (AlicePawn(Pawn) != none)
        {
            StartTraceAdj = vect(0.0, 64.0, 0.0);
            StartTrace += StartTraceAdj >> rotator(ActualLookatLoc - StartTrace);
        }
        HitActor = Trace(HitLoc, HitNormal, ActualLookatLoc, StartTrace);
        if (HitActor != none && HitActor != POI.AttachedToActor)
        {
            return false;
        }
    }
    return true;
}

function ClientClearForcedCameraFOV()
{
    local AlicePlayerCamera Cam;
    
    Cam = AlicePlayerCamera(PlayerCamera);
    Cam.bUseForcedCamFOV = false;
    Cam.ResetCustomFOV(AlicePawn(Pawn).AliceCameraFOV);
}

final function StopForceLookAtPointOfInterest(optional bool bUserInstigated)
{
    local AlicePlayerCamera Cam;
    local AlicePointOfInterest POI;
    
    ClearTimer('ForceLookDurationExpired');
    Cam = AlicePlayerCamera(PlayerCamera);
    if (bLookingAtPointOfInterest)
    {
        POI = AlicePointOfInterest(CameraLookAtFocusActor);
        if (POI != none)
        {
            POI.ServerFirePOIActionOutputLink(3);
        }
        bLookingAtPointOfInterest = false;
        bPOIOverrideCamera = false;
        if (Cam != none)
        {
            ClearFocusPoint(false);
            ClientClearForcedCameraFOV();
        }
    }
}

simulated function ClearFocusPoint(bool bFromKismet, optional bool bForceLeaveRotation)
{
    local bool bLeaveRotation;
    
    if (bFromKismet == bCameraLookAtIsFromKismet)
    {
        bLeaveRotation = bForceLeaveRotation || AlicePointOfInterest(CameraLookAtFocusActor) != none && AlicePointOfInterest(CameraLookAtFocusActor).bLeavePlayerFacingPOI;
        CameraLookAtFocusActor = none;
        GameThirdPersonCamera(AlicePlayerCamera(PlayerCamera).ThirdPersonCam).ClearFocusPoint(bLeaveRotation);
    }
}

simulated function SetFocusPoint(bool bFromKismet, Actor FocusActor, Vector2D InterpSpeedRange, Vector2D InFocusFOV, optional float CameraFOV, optional bool bAlwaysFocus, optional bool bAdjustCamera, optional bool bIgnoreTrace, optional name FocusBoneName)
{
    if (!bPOIOverrideCamera)
    {
        GameThirdPersonCamera(AlicePlayerCamera(PlayerCamera).ThirdPersonCam).SetFocusOnActor(FocusActor, FocusBoneName, InterpSpeedRange, InFocusFOV, CameraFOV, bAlwaysFocus, bAdjustCamera, bIgnoreTrace);
    }
    CameraLookAtFocusActor = FocusActor;
    bCameraLookAtIsFromKismet = bFromKismet;
}

final simulated function ForceLookAtPointOfInterest(optional bool bUserInstigated, optional AlicePointOfInterest POIToForce)
{
    local AlicePlayerCamera Cam;
    local float POICamFOV;
    local int IndexInList;
    local bool bDoForceLookTimer;
    
    Cam = AlicePlayerCamera(PlayerCamera);
    if (Cam != none)
    {
        if (POIToForce == none)
        {
            POIToForce = FindBestPOIToLookAt();
        }
        if (CameraLookAtFocusActor == POIToForce)
        {
            return;
        }
        else if (bLookingAtPointOfInterest)
        {
            StopForceLookAtPointOfInterest(false);
        }
        if (POIToForce != none)
        {
            bPOIOverrideCamera = POIToForce.bOverrideCamera;
            POICamFOV = POIToForce.GetDesiredFOV(Cam.Location);
            SetFocusPoint(false, POIToForce, PointOfInterestLookatInterpSpeedRange, vect2d(1.0, 1.0), POICamFOV, true, true, true);
            MyAlicePawn.POICameraOffset = POIToForce.CameraOffset;
            bLookingAtPointOfInterest = true;
            bPressedJump = false;
            if (POIToForce.ForceLookType != 0 && POIToForce.ForceLookDuration > 0.0)
            {
                bDoForceLookTimer = true;
                if (POIToForce.ForceLookType != 0)
                {
                    IndexInList = EnabledPointsOfInterest.Find(POIToForce);
                    if (IndexInList == -1 || POILookedAtList[IndexInList])
                    {
                        bDoForceLookTimer = false;
                    }
                }
                if (bDoForceLookTimer)
                {
                    SetTimer(POIToForce.ForceLookDuration, false, 'ForceLookDurationExpired');
                }
            }
            IndexInList = EnabledPointsOfInterest.Find(POIToForce);
            if (IndexInList != -1)
            {
                POILookedAtList[IndexInList] = true;
            }
            POIToForce.ServerFirePOIActionOutputLink(2);
        }
    }
}

final simulated function AlicePointOfInterest FindBestPOIToLookAt(optional AlicePointOfInterest POIToTest)
{
    local AlicePointOfInterest POI, BestPOI;
    local int POIPriority, CurrPriority;
    local bool bSetBestPOI;
    local Pawn Myself;
    
    BestPOI = POIToTest;
    POIPriority = (BestPOI == none ? -1 : BestPOI.LookAtPriority);
    foreach EnabledPointsOfInterest(POI)
    {
        bSetBestPOI = false;
        Myself = Pawn;
        if (POI.bEnabled && POI.AttachedToActor == none || POI.AttachedToActor != Myself)
        {
            CurrPriority = POI.GetLookAtPriority(self);
            if (CurrPriority >= 0)
            {
                if (BestPOI == none || CurrPriority > POIPriority || CurrPriority == POIPriority && POIToTest == none || BestPOI != POIToTest && VSizeSq(POI.Location - Pawn.Location) < VSizeSq(BestPOI.Location - Pawn.Location))
                {
                    bSetBestPOI = true;
                    if (bSetBestPOI)
                    {
                        BestPOI = POI;
                        POIPriority = CurrPriority;
                    }
                }
            }
        }
    }
    return BestPOI;
}

final function ForceLookDurationExpired()
{
    if (!bLookingAtPointOfInterest || !bIsHoldingPOIButton)
    {
        StopForceLookAtPointOfInterest(false);
    }
}

final function TryPOILookAway()
{
    local AlicePointOfInterest CurrPOI;
    
    if (CameraLookAtFocusActor != none)
    {
        CurrPOI = AlicePointOfInterest(CameraLookAtFocusActor);
        if (CurrPOI != none)
        {
            if (IsTimerActive('ForceLookDurationExpired'))
            {
                return;
            }
        }
    }
    StopForceLookAtPointOfInterest(true);
}

final function TryPOILookAt()
{
    ProcessPOI(none, true);
    ClearPOIIconDurations();
}

simulated function ProcessPOI(optional AlicePointOfInterest POI, optional bool bUserInstigated)
{
    local AlicePointOfInterest BestPOI, CurrPOI;
    
    BestPOI = FindBestPOIToLookAt(POI);
    if (BestPOI == none || POI != none && POI != BestPOI)
    {
        return;
    }
    if (BestPOI.ForceLookType != 0 && BestPOI.bForceLookCheckLineOfSight)
    {
        if (!HasLineOfSightToPOI(BestPOI))
        {
            return;
        }
    }
    if (bLookingAtPointOfInterest && CameraLookAtFocusActor != none)
    {
        CurrPOI = AlicePointOfInterest(CameraLookAtFocusActor);
        if (CurrPOI == BestPOI)
        {
            return;
        }
        if (CurrPOI != none)
        {
            StopForceLookAtPointOfInterest(bUserInstigated);
        }
    }
    ForceLookAtPointOfInterest(bUserInstigated, BestPOI);
}

final function CheckEnabledPointsOfInterest(float DeltaTime)
{
    local int Idx, ActivePOI;
    
    ActivePOI = 0;
    if (EnabledPointsOfInterest.Length > 0)
    {
        for (Idx = 0; Idx < EnabledPointsOfInterest.Length; Idx++)
        {
            if (EnabledPointsOfInterest[Idx] == none)
            {
                EnabledPointsOfInterest.Remove(Idx, 1);
                POILookedAtList.Remove(Idx, 1);
                Idx--;
                continue;
            }
            if (EnabledPointsOfInterest[Idx].bEnabled && EnabledPointsOfInterest[Idx].CurrIconDuration > 0.0)
            {
                EnabledPointsOfInterest[Idx].CurrIconDuration -= DeltaTime;
                if (EnabledPointsOfInterest[Idx].CurrIconDuration > 0.0)
                {
                    ActivePOI++;
                }
                else if (EnabledPointsOfInterest[Idx].CurrIconDuration == 0.0)
                {
                    EnabledPointsOfInterest[Idx].CurrIconDuration = -1.0;
                }
                continue;
            }
            if (EnabledPointsOfInterest[Idx].bEnabled && EnabledPointsOfInterest[Idx].CurrIconDuration == 0.0)
            {
                ActivePOI++;
            }
        }
        if (ActivePOI == 0)
        {
        }
    }
}

function ClearPOIIconDurations()
{
    local AlicePointOfInterest POI;
    
    foreach EnabledPointsOfInterest(POI)
    {
        POI.CurrIconDuration = -1.0;
    }
}

simulated function RemovePointOfInterest(AlicePointOfInterest POI, optional EPOIForceLookType ForceLookType)
{
    local int Idx;
    
    if (POI != none)
    {
        Idx = EnabledPointsOfInterest.Find(POI);
        if (Idx >= 0)
        {
            EnabledPointsOfInterest.Remove(Idx, 1);
            POILookedAtList.Remove(Idx, 1);
            if (CameraLookAtFocusActor == POI)
            {
                StopForceLookAtPointOfInterest();
            }
        }
    }
}

simulated function AddPointOfInterest(AlicePointOfInterest POI)
{
    local int Idx, CurrPriority;
    
    if (POI != none)
    {
        POI.bEnabled = true;
        if (EnabledPointsOfInterest.Find(POI) == -1)
        {
            EnabledPointsOfInterest[EnabledPointsOfInterest.Length] = POI;
            POILookedAtList[POILookedAtList.Length] = false;
        }
        if (POI.bDisableOtherPOIs)
        {
            ClearFocusPoint(false);
            for (Idx = 0; Idx < EnabledPointsOfInterest.Length; Idx++)
            {
                if (EnabledPointsOfInterest[Idx] != POI && EnabledPointsOfInterest[Idx].bEnabled)
                {
                    CurrPriority = EnabledPointsOfInterest[Idx].GetLookAtPriority(self);
                    if (CurrPriority >= class'AlicePointOfInterest'.default.default.POIPriority_ScriptedEvent)
                    {
                        EnabledPointsOfInterest[Idx].bEnabled = false;
                    }
                }
            }
        }
        if (POI.ForceLookType == 1 || bLookingAtPointOfInterest && bIsHoldingPOIButton)
        {
            ProcessPOI(POI, bLookingAtPointOfInterest && bIsHoldingPOIButton);
        }
        else
        {
            ShowPOIUIHint(POI.CurrIconDuration, POI.POIAction.POI_DisplayName);
            CurrLookedAtPOI = EnabledPointsOfInterest[EnabledPointsOfInterest.Length - 1];
        }
    }
}

function PlayCameraAnim(CameraAnim AnimToPlay, optional bool bGamePlayCamera, optional float Scale = 1.0, optional float Rate = 1.0, optional float BlendInTime, optional float BlendOutTime, optional bool bLoop, optional bool bIsDamageShake)
{
}

function ApplyCheckpointRecord(out const CheckpointRecord Record)
{
    local int I;
    local Vector SafeTeleLocation;
    
    LogInternal("load location " @ string(Record.Location.X) @ " " @ string(Record.Location.Y) @ " " @ string(Record.Location.Z));
    SafeTeleLocation = Record.Location;
    setSafeTeleportLoc(SafeTeleLocation);
    Pawn.SetRotation(Record.Rotation);
    Pawn.Health = Record.Health;
    if (Pawn.Health <= 24)
    {
        Pawn.Health = 24;
    }
    ResetAliceStateAfterApplyCheckPoint();
    PostLoadCheckPointChangeArcheType(Record.AliceArcheTypeID);
    if (ObjectiveMgr != none && LocalPlayer(Player) != none)
    {
        ObjectiveMgr.Objectives = Record.Objectives;
        for (I = 0; I < ObjectiveMgr.Objectives.Length; I++)
        {
            ObjectiveMgr.Objectives[I].UpdatedTime = (ObjectiveMgr.Objectives[I].bCompleted ? -100.0 : WorldInfo.TimeSeconds);
        }
    }
    StoryModeSaveDressID = Record.StoryModeSaveDressID;
    if (GetGStoryMode() && Record.AliceArcheTypeID == 1)
    {
        ChangeAliceWonderlandDress(int(Record.StoryModeSaveDressID), true, none);
    }
}

function setSafeTeleportLoc(Vector safeLoc)
{
    AliceCheatManager(CheatManager).SafeTeleportLoc = safeLoc;
}

function Vector getSafeTeleportLoc()
{
    return AliceCheatManager(CheatManager).SafeTeleportLoc;
}

function ResetAliceStateAfterApplyCheckPoint()
{
    AlicePawn(Pawn).LockedZones.Length = 0;
    SetCollision(true, true);
    ResetRangeWeapons();
    AliceGameInfo(WorldInfo.Game).ReSetUIAfterLoadCheckPoint();
    AlicePlayerInput(PlayerInput).bDisableInputInCinematic = false;
    RecoverToDefaultStatus(true, true, true);
    IgnoreMoveInput(false);
    MyAlicePawn.FadeOutWeapon();
    MyAlicePawn.Weapon = none;
    MyAlicePawn.PlayRespawnEffect();
}

function CreateCheckpointRecord(out CheckpointRecord Record)
{
    if (WorldInfo.Game.MyCheckPointManager.bHaveSafeSaveLocation)
    {
        Record.Location = WorldInfo.Game.MyCheckPointManager.SafeSaveLocation;
        Record.Rotation = WorldInfo.Game.MyCheckPointManager.SafeSaveRotation;
    }
    else
    {
        Record.Location = Pawn.Location;
        Record.Rotation = Pawn.Rotation;
    }
    WorldInfo.Game.MyCheckPointManager.bHaveSafeSaveLocation = false;
    Record.Health = Pawn.Health;
    Record.AliceArcheTypeID = AliceGameInfo(WorldInfo.Game).AliceArcheTypeID;
    Record.StoryModeSaveDressID = StoryModeSaveDressID;
    LogInternal("save location " @ string(Record.Location.X) @ " " @ string(Record.Location.Y) @ " " @ string(Record.Location.Z));
    if (ObjectiveMgr != none)
    {
        Record.Objectives = ObjectiveMgr.Objectives;
    }
}

event PostApplyPersistentData()
{
    local string sMapName, sChap;
    local int Idx, iChap;
    
    ResetWeaponCurrentWeaponLevel();
    persistentDataManager.PostApplyPersistentData();
    if (MyAlicePawn != none && MyAlicePawn.ArcheTypeID == 1)
    {
        if (WorldInfo.GetMapName() == "AliceEntry")
        {
            MyAlicePawn.ChangeWonderlandDress(MyAlicePawn.GetUserWonderlandDress(), true);
        }
        MyAlicePawn.SetWonderlandDressDLCMODInfo(MyAlicePawn.GetUserWonderlandDress());
        if (MyAlicePawn.bSonarAlwaysVisible)
        {
            SonarManager.SetActive(true);
        }
    }
    sMapName = WorldInfo.GetMapName();
    Idx = InStr(sMapName, "_");
    if (Idx != -1)
    {
        sChap = Mid(sMapName, Idx - 1, 1);
        iChap = int(sChap);
        if (iChap >= 1 && iChap <= 6 && ChapterCompleted[iChap - 1] == 1)
        {
            MyAlicePawn.Health = MyAlicePawn.HealthMax;
        }
    }
}

function ResetWeaponCurrentWeaponLevel()
{
    if (WeaponLevel[0] > 0)
    {
        AddNewAliceWeapon(class'VorpalBlade', WeaponLevel[0]);
    }
    if (WeaponLevel[1] > 0)
    {
        AddNewAliceWeapon(class'HobbyHorse', WeaponLevel[1]);
    }
    if (WeaponLevel[2] > 0)
    {
        AddNewAliceWeapon(class'TeapotCannon', WeaponLevel[2]);
    }
    if (WeaponLevel[3] > 0)
    {
        AddNewAliceWeapon(class'EyeStaff', WeaponLevel[3]);
    }
}

event PreSavePersistentData()
{
    FlushWeaponLevelRealTime();
    persistentDataManager.PreSavePersistentData();
}

function FlushWeaponLevelRealTime()
{
    local Inventory Inv;
    
    if (Pawn != none)
    {
        Inv = Pawn.FindInventoryType(class'VorpalBlade');
        if (WeaponForAlice(Inv) != none)
        {
            WeaponLevel[0] = WeaponForAlice(Inv).SaveWeaponLevel;
        }
        Inv = Pawn.FindInventoryType(class'HobbyHorse');
        if (WeaponForAlice(Inv) != none)
        {
            WeaponLevel[1] = WeaponForAlice(Inv).SaveWeaponLevel;
        }
        Inv = Pawn.FindInventoryType(class'TeapotCannon');
        if (WeaponForAlice(Inv) != none)
        {
            WeaponLevel[2] = WeaponForAlice(Inv).SaveWeaponLevel;
        }
        Inv = Pawn.FindInventoryType(class'EyeStaff');
        if (WeaponForAlice(Inv) != none)
        {
            WeaponLevel[3] = WeaponForAlice(Inv).SaveWeaponLevel;
        }
    }
}

simulated function OnToggleCameraMagnetEffect(SeqAct_ToggleCameraMagnetEffect Action)
{
    MyAlicePawn.bEnableCameraMagnet = (Action.InputLinks[0].bHasImpulse ? true : false);
}

simulated event OnToggleCameraPreset(SeqAct_ToggleCameraPreset Action)
{
    if (Action.InputLinks[0].bHasImpulse)
    {
        MyAlicePawn.EnableCameraPreset(int(Action.CameraPreset), Action.TransitionParamsOn);
    }
    else
    {
        MyAlicePawn.DisableCameraPreset(int(Action.CameraPreset), Action.TransitionParamsOff);
    }
}

simulated function OnSetAbilityCamera(SeqAct_SetAbilityCamera Action)
{
    if (Action.InputLinks[0].bHasImpulse)
    {
        MyAlicePawn.EnableCameraPreset(-1, Action.TransitionParamsOn, Action.CameraProperties);
    }
    else
    {
        MyAlicePawn.DisableCameraPreset(-1, Action.TransitionParamsOff, Action.CameraProperties);
    }
}

function SwitchToArcheType(EAliceArcheType nAliceArcheType)
{
    local bool bResult;
    local EAliceArcheType nOldAliceArcheType;
    
    if (AliceGameInfo(WorldInfo.Game).AliceArcheTypeID == nAliceArcheType)
    {
        return;
    }
    nOldAliceArcheType = AliceGameInfo(WorldInfo.Game).AliceArcheTypeID;
    AliceGameInfo(WorldInfo.Game).AliceArcheTypeID = nAliceArcheType;
    AlicePawn(Pawn).PrepareForSwitchArchetype();
    bResult = SwitchAliceArcheTypePointer(nAliceArcheType);
    if (bResult)
    {
        if (nAliceArcheType == 0 || nAliceArcheType == 8)
        {
            AlicePawn(Pawn).bInLondon = true;
        }
        else
        {
            AlicePawn(Pawn).bInLondon = false;
        }
        if (nAliceArcheType == 4)
        {
            AlicePawn(Pawn).bInGiantMode = true;
            GiantAliceTakeDamageCount = 0;
        }
        else
        {
            AlicePawn(Pawn).bInGiantMode = false;
        }
        if (nAliceArcheType == 5)
        {
            AlicePawn(Pawn).bInRollingMode = true;
        }
        else
        {
            AlicePawn(Pawn).bInRollingMode = false;
        }
        ChangeAliceEnvironment(AlicePawn(Pawn).bInLondon);
        if (!AlicePawn(Pawn).bCanCombat)
        {
            AlicePawn(Pawn).InvManager.SetCurrentWeapon(none);
        }
        if (nAliceArcheType == 5)
        {
            AlicePawn(Pawn).StartRoll();
            GotoState('PlayerRoll');
            MyAlicePawn.SetPhysics(10);
            BeginRollingMode();
        }
        else if (nOldAliceArcheType == 5)
        {
            GotoState('PlayerWalking');
            MyAlicePawn.SetPhysics(1);
            EndRollingMode();
        }
        MyAlicePawn.ResetDressMorphingData();
        AliceCheatManager(CheatManager).resetDataForLondonSwitchArcheType();
    }
}

native function EndRollingMode()
{
}

native function BeginRollingMode()
{
}

simulated function OnSwitchLand(SeqAct_SwitchLand Action)
{
    local EAliceArcheType nAliceArcheType;
    
    AlicePlayerInput(PlayerInput).bIgnoreMoveForwardInput = false;
    bProjectInputToControllerSpace = false;
    if (Pawn != none && AlicePawn(Pawn) != none)
    {
        RecoverToDefaultStatus();
        if (Action.bSwitchToWonderland)
        {
            nAliceArcheType = 1;
        }
        else if (Action.bSwitchToLondon)
        {
            nAliceArcheType = 0;
        }
        else if (Action.bSwitchToAsylum)
        {
            nAliceArcheType = 8;
        }
        else if (Action.bSwitchToTransition)
        {
            nAliceArcheType = 2;
        }
        else if (Action.bSwitchToShadowMode)
        {
            nAliceArcheType = 3;
            AlicePlayerInput(PlayerInput).bIgnoreMoveForwardInput = true;
            bProjectInputToControllerSpace = true;
            MyAlicePawn.InitShadowMode();
            FroceResetIgnoreMoveInput();
        }
        else if (Action.bSwitchToGiantMode)
        {
            nAliceArcheType = 4;
        }
        else if (Action.bSwitchToRollingMode)
        {
            nAliceArcheType = 5;
        }
        else if (Action.bSwitchToSwimMode)
        {
            nAliceArcheType = 6;
        }
        else if (Action.bSwitchToWaterWalkMode)
        {
            nAliceArcheType = 7;
        }
        else
        {
            return;
        }
        SwitchToArcheType(nAliceArcheType);
    }
}

simulated function PostLoadCheckPointChangeArcheType(EAliceArcheType nAliceArcheType)
{
    AlicePlayerInput(PlayerInput).bIgnoreMoveForwardInput = false;
    bProjectInputToControllerSpace = false;
    if (Pawn != none && AlicePawn(Pawn) != none)
    {
        if (nAliceArcheType == 3)
        {
            AlicePlayerInput(PlayerInput).bIgnoreMoveForwardInput = true;
            bProjectInputToControllerSpace = true;
            MyAlicePawn.InitShadowMode();
        }
        SwitchToArcheType(nAliceArcheType);
    }
}

simulated function OnSwitchAliceTransitionHair(SeqAct_SwitchAliceTransitionHair Action)
{
    if (MyAlicePawn.ArcheTypeID == 2)
    {
        MyAlicePawn.SwitchHairInTransition();
    }
}

simulated event SetCurAliceDressFinished(GFxMovie pGFXMovie)
{
    AliceGFXMovie(pGFXMovie).GameCallback();
}

native function AliceGameUseTextureStreaming(bool bEnable)
{
    bEnable;
}

simulated function SetAliceUserDress(int DressIndex)
{
    MyAlicePawn.SetUserWonderlandDress(byte(DressIndex));
}

simulated function SetCurAliceDressAsUserDress()
{
    MyAlicePawn.SetUserWonderlandDress(MyAlicePawn.CurWonderlandDress);
}

simulated function bool IsLoadingAliceWonderlandDress()
{
    return MyAlicePawn.IsLoadingWonderlandDressPackage(MyAlicePawn.PendingWonderlandDress);
}

simulated function int GetCurAliceWonderlandDress()
{
    return int(MyAlicePawn.CurWonderlandDress);
}

simulated event ChangeAliceWonderlandDressCPP(int DressIndex, bool bShouldBlock, GFxMovie pGFXMovie)
{
    ChangeAliceWonderlandDress(DressIndex, bShouldBlock, pGFXMovie);
}

simulated function int ChangeAliceWonderlandDress(int DressIndex, bool bShouldBlock, GFxMovie pGFXMovie)
{
    return MyAlicePawn.DelayedChangeWonderlandDress(byte(DressIndex), bShouldBlock, pGFXMovie);
}

simulated function OnChangeWonderlandDress(SeqAct_ChangeWonderlandDress Action)
{
    local bool bStoryMode;
    
    bStoryMode = GetGStoryMode();
    if (bStoryMode && MyAlicePawn != none && MyAlicePawn.ArcheTypeID == 1)
    {
        ChangeAliceWonderlandDress(int(Action.AliceDress), Action.bShouldBlock, none);
        StoryModeSaveDressID = Action.AliceDress;
    }
}

native function bool GetGStoryMode()
{
}

native function SetGStoryMode(bool bStoryMode)
{
    bStoryMode;
}

function ModifyRotationSpeed(float DeltaTime, out float aLookUp, out float aTurn)
{
    local float SpeedScale;
    
    if (Abs(aTurn) > float(1) && aTurn * aOldTurn >= float(0))
    {
        aOldTurn = aTurn;
        aTurnElapsedTime += DeltaTime;
        SpeedScale = aTurnElapsedTime / MyAlicePawn.AliceCameraRevolAccelTime;
        SpeedScale = (SpeedScale > 1.0 ? 1.0 : SpeedScale);
        SpeedScale = SpeedScale ** MyAlicePawn.AliceCameraRevolAccelExponent;
        aTurn *= SpeedScale;
    }
    else
    {
        if (aTurn * aOldTurn < float(0))
        {
            aTurn = 0.0;
        }
        aTurnElapsedTime = 0.0;
        aOldTurn = 0.0;
    }
    if (Abs(aLookUp) > float(1) && aLookUp * aOldLookUp >= float(0))
    {
        aOldLookUp = aLookUp;
        aLookUpElapsedTime += DeltaTime;
        SpeedScale = aLookUpElapsedTime / MyAlicePawn.AliceCameraRevolAccelTime;
        SpeedScale = (SpeedScale > 1.0 ? 1.0 : SpeedScale);
        SpeedScale = SpeedScale ** MyAlicePawn.AliceCameraRevolAccelExponent;
        aLookUp *= SpeedScale;
    }
    else
    {
        if (aLookUp * aOldLookUp < float(0))
        {
            aLookUp = 0.0;
        }
        aLookUpElapsedTime = 0.0;
        aOldLookUp = 0.0;
    }
}

function UpdateRotation(float DeltaTime)
{
    local Rotator DeltaRot, ViewRotation;
    local float CamRotSpeed;
    
    ViewRotation = Rotation;
    ModifyRotationSpeed(DeltaTime, AlicePlayerInput(PlayerInput).aLookUp, AlicePlayerInput(PlayerInput).aTurn);
    if (IsInState('PlayerSteamVent') && IsNewHoverControl())
    {
        CamRotSpeed = (MyAlicePawn != none ? MyAlicePawn.CameraRotationSpeed : 1.0);
        DeltaRot.Pitch = int(PlayerInput.aLookUp * CamRotSpeed);
    }
    else if (!bTargetingModeActive)
    {
        CheckAutoResetCameraPitch();
        if (!IsInPOIMode() || bPOIOverrideCamera)
        {
            CamRotSpeed = (MyAlicePawn != none ? MyAlicePawn.CameraRotationSpeed : 1.0);
            DeltaRot.Yaw = int(PlayerInput.aTurn * CamRotSpeed);
            DeltaRot.Pitch = int(PlayerInput.aLookUp * CamRotSpeed);
        }
        else if (PlayerInput.aTurn > 0.5 * 600.0)
        {
            bCameraLocOnLeft = true;
        }
        else if (PlayerInput.aTurn < 0.5 * -600.0)
        {
            bCameraLocOnLeft = false;
        }
    }
    ProcessViewRotation(DeltaTime, ViewRotation, DeltaRot);
    SetRotation(ViewRotation);
    ViewShake(DeltaTime);
}

function CheckAutoResetCameraPitch()
{
    local int CamPitch;
    
    if (PlayerInput.aForward == float(0) && PlayerInput.aStrafe == float(0))
    {
        return;
    }
    CamPitch = int(Abs(float(Rotation.Pitch)));
    if (CamPitch > 32768)
    {
        CamPitch = 65535 - CamPitch;
    }
    if (Pawn.Physics != 1 || Abs(PlayerInput.aTurn) > float(0) || Abs(PlayerInput.aLookUp) > float(0) || Abs(PlayerInput.aStrafe) > float(0) || Abs(PlayerInput.aForward) > float(0) || float(CamPitch) < float(32768) * 0.125)
    {
        if (bAutoResetCamCountingTimer)
        {
            OldPitch = 0;
            bAutoResetCamCountingTimer = false;
            ClearTimer('AutoResetCameraPitch');
        }
        return;
    }
    if (Rotation.Pitch != OldPitch && float(CamPitch) > float(32768) * 0.125)
    {
        OldPitch = Rotation.Pitch;
        ClearTimer('AutoResetCameraPitch');
        SetTimer(fTimeToTriggerAutoResetCamera, false, 'AutoResetCameraPitch');
        bAutoResetCamCountingTimer = true;
    }
}

function AutoResetCameraPitch()
{
    local Rotator NewRot;
    local AlicePlayerCamera Cam;
    
    Cam = AlicePlayerCamera(PlayerCamera);
    if (Cam == none || GameThirdPersonCamera(Cam.ThirdPersonCam).bFocusPointSet)
    {
        return;
    }
    NewRot = Rotation;
    NewRot.Pitch = 0;
    if (IsInState('PlayerWalking') && bAllowAutoResetCamera)
    {
        SetRotation(NewRot);
    }
}

exec function ForceResetCamera()
{
    if (AlicePlayerInput(PlayerInput).bDisableInputInCinematic)
    {
        return;
    }
    if (!IsInState('PlayerWalking') && !IsInState('FirstPersonView'))
    {
        return;
    }
    if (bAllowForceResetCamera)
    {
        MyAlicePawn.bForceResetCamera = true;
        MyAlicePawn.ForceResetCameraElapsedTime = 0.0;
    }
}

exec function ToggleCloseFollowCamera()
{
    if (MyAlicePawn != none)
    {
        MyAlicePawn.ToggleCloseFollowCamera(!MyAlicePawn.bCloseFollowCamera);
    }
}

function Vector GetInputVector()
{
    return AlicePlayerInput(PlayerInput).InputVector;
}

event Pawn getNPCInInputCone(Vector inputDir)
{
    local Pawn resultNPC;
    local AliceGameKynapsePawn npc;
    local float angleThreshold, fAngle, fDist, fMinDist;
    local Vector vDist;
    
    fMinDist = 999999.0;
    resultNPC = none;
    angleThreshold = MyAlicePawn.NonLockOnAutoTargetAngleRange * 0.017453292 * 0.5;
    foreach DynamicActors(class'AliceGameKynapsePawn', npc)
    {
        if (npc.bHidden || !npc.IsAliveAndWell())
        {
            break;
        }
        vDist = npc.Location - Pawn.Location;
        fDist = VSize(vDist);
        if (fDist > MyAlicePawn.NonLockOnAutoTargetDistance)
        {
            break;
        }
        fAngle = CalcAngleBetweenVectors(inputDir, vDist);
        if (Abs(fAngle) > angleThreshold)
        {
            break;
        }
        if (fDist < fMinDist)
        {
            resultNPC = npc;
            fMinDist = fDist;
        }
    }
    if (fMinDist > MyAlicePawn.TargetingSearchRadius)
    {
        resultNPC = none;
    }
    return resultNPC;
}

event Actor getBKActorInInputCone(Vector inputDir)
{
    local Actor resultActor;
    local GameBreakableActor BActor;
    local float angleThreshold, fAngle, fDist, fMinDist;
    local Vector vDist;
    
    fMinDist = 999999.0;
    resultActor = none;
    angleThreshold = MyAlicePawn.NonLockOnAutoTargetAngleRange * 0.017453292 * 0.5;
    foreach DynamicActors(class'GameBreakableActor', BActor)
    {
        if (BActor.bHidden)
        {
            break;
        }
        vDist = BActor.Location - Pawn.Location;
        fDist = VSize(vDist);
        if (fDist > MyAlicePawn.NonLockOnAutoTargetDistance)
        {
            break;
        }
        fAngle = CalcAngleBetweenVectors(inputDir, vDist);
        if (Abs(fAngle) > angleThreshold)
        {
            break;
        }
        if (fDist < fMinDist)
        {
            resultActor = BActor;
            fMinDist = fDist;
        }
    }
    if (fMinDist > MyAlicePawn.TargetingSearchRadius)
    {
        resultActor = none;
    }
    return resultActor;
}

event Vector getInputVectorSlideToTarget()
{
    return AlicePlayerInput(PlayerInput).InputVectorDuringIgnore;
}

function ProjectInputToCameraSpace()
{
    SelectInputSpace();
    if (bProjectInputToControllerSpace)
    {
        AlicePlayerInput(PlayerInput).InputVector = ProjectVectorToControllerSpace(AlicePlayerInput(PlayerInput).InputVector);
        AlicePlayerInput(PlayerInput).InputVectorCombo = ProjectVectorToControllerSpace(AlicePlayerInput(PlayerInput).InputVectorCombo);
        AlicePlayerInput(PlayerInput).InputVectorDuringIgnore = ProjectVectorToControllerSpace(AlicePlayerInput(PlayerInput).InputVectorDuringIgnore);
    }
    else if (bProjectInputToPreCameraSpace)
    {
        AlicePlayerInput(PlayerInput).InputVector = ProjectVectorToSpace(AlicePlayerInput(PlayerInput).InputVector, PreCameraRot);
        AlicePlayerInput(PlayerInput).InputVectorCombo = ProjectVectorToSpace(AlicePlayerInput(PlayerInput).InputVectorCombo, PreCameraRot);
        AlicePlayerInput(PlayerInput).InputVectorDuringIgnore = ProjectVectorToSpace(AlicePlayerInput(PlayerInput).InputVectorDuringIgnore, PreCameraRot);
    }
    else
    {
        AlicePlayerInput(PlayerInput).InputVector = ProjectVectorToCameraSpace(AlicePlayerInput(PlayerInput).InputVector);
        AlicePlayerInput(PlayerInput).InputVectorCombo = ProjectVectorToCameraSpace(AlicePlayerInput(PlayerInput).InputVectorCombo);
        AlicePlayerInput(PlayerInput).InputVectorDuringIgnore = ProjectVectorToCameraSpace(AlicePlayerInput(PlayerInput).InputVectorDuringIgnore);
    }
}

function SelectInputSpace()
{
    local bool bLeftStickFree;
    
    if (bProjectInputToControllerSpace)
    {
        return;
    }
    bLeftStickFree = !(Abs(PlayerInput.aForward) > float(0) || Abs(PlayerInput.aStrafe) > float(0));
    if (bProjectInputToPreCameraSpace && bLeftStickFree)
    {
        bProjectInputToPreCameraSpace = false;
    }
}

function Vector ProjectVectorToControllerSpace(Vector vec)
{
    local Vector X, Y, Z;
    local Rotator ControllerRot;
    
    if (PlayerCamera == none || PlayerInput == none || Pawn == none)
    {
        return vec;
    }
    ControllerRot = Rotation;
    ControllerRot.Pitch = 0;
    ControllerRot.Roll = 0;
    GetAxes(ControllerRot, X, Y, Z);
    vec = vec.X * X + vec.Y * Y;
    return vec;
}

function Vector ProjectVectorToCameraSpace(Vector vec)
{
    local Vector X, Y, Z, CamLoc;
    local Rotator CamRot;
    
    if (PlayerCamera == none || PlayerInput == none || Pawn == none)
    {
        return vec;
    }
    GetPlayerViewPoint(CamLoc, CamRot);
    CamRot.Pitch = 0;
    CamRot.Roll = 0;
    GetAxes(CamRot, X, Y, Z);
    vec = vec.X * X + vec.Y * Y;
    return vec;
}

function Vector ProjectVectorToSpace(Vector vec, Rotator SpaceRot)
{
    local Vector X, Y, Z;
    
    SpaceRot.Pitch = 0;
    SpaceRot.Roll = 0;
    GetAxes(SpaceRot, X, Y, Z);
    vec = vec.X * X + vec.Y * Y;
    return vec;
}

event float CalcAngleBetweenVectors(Vector v1, Vector v2)
{
    local Vector vLeft;
    local float fAngle, fLeftPct;
    
    if (VSize(v2) == float(0) && VSize(v1) == float(0))
    {
        fAngle = 0.0;
    }
    else if (VSize(v2) > float(0) && VSize(v1) > float(0))
    {
        v2 = Normal(v2);
        v1 = Normal(v1);
        fAngle = Acos(v1 Dot v2);
        vLeft = v1 Cross vect(0.0, 0.0, 1.0);
        vLeft = Normal(vLeft);
        fLeftPct = vLeft Dot v2;
        if (fLeftPct > float(0))
        {
            fAngle *= float(-1);
        }
    }
    else
    {
        fAngle = 0.0;
    }
    return fAngle;
}

function PlaySlideParticle()
{
    local Vector FootLoc;
    local Emitter SlideParticleEmitter;
    
    FootLoc = Pawn.Mesh.GetBoneLocation('Bip01-L-Thigh', 0);
    SlideParticleEmitter = Spawn(class'Engine.EmitterSpawnable', self, , FootLoc);
    if (SlideParticleEmitter != none && SlideParticle != none)
    {
        SlideParticleEmitter.SetTemplate(SlideParticle, true);
        SlideParticleEmitter.SetLocation(FootLoc);
    }
}

function UpdateSlideEmitter()
{
    local Vector FootLoc;
    
    if (SlideLoopingEmitter != none)
    {
        FootLoc = Pawn.Mesh.GetBoneLocation('Bip01-L-Thigh', 0);
        SlideLoopingEmitter.SetLocation(FootLoc);
        SlideLoopingEmitter.SetRotation(Pawn.Rotation);
    }
}

function EndSlideParticle()
{
    if (SlideLoopingEmitter != none)
    {
        SlideLoopingEmitter.ParticleSystemComponent.DeactivateSystem();
        SlideLoopingEmitter.bCurrentlyActive = false;
    }
}

function StartSlideParticle()
{
    if (SlideLoopingEmitter == none)
    {
        SlideLoopingEmitter = Spawn(class'Engine.EmitterSpawnable', self);
        if (SlideLoopingEmitter != none && SlideParticle != none)
        {
            SlideLoopingEmitter.SetTemplate(SlideParticle);
            SlideLoopingEmitter.bCurrentlyActive = false;
        }
        else
        {
            return;
        }
    }
    if (SlideLoopingEmitter != none && !SlideLoopingEmitter.bCurrentlyActive)
    {
        SlideLoopingEmitter.ParticleSystemComponent.ActivateSystem();
        SlideLoopingEmitter.bCurrentlyActive = true;
    }
}

exec function TriggerBlockPC(bool bActive)
{
    if (!bLockOnTriggeredByShiftKey && !bTargetingModeActive && bActive || bTargetingModeActive && !bActive)
    {
        bHoldTiggerToMaintainTargeting = false;
        ChangeCameraMode(true);
    }
    TriggerBlock(bActive);
}

exec function TriggerBlock(bool bActive)
{
}

function bool IsInputEnoughToTriggerDodge(Vector vInput)
{
    return VSize(vInput) > AccelThresholdToRun;
}

function OnDeactivateShieldBlocking()
{
    IgnoreMoveInput(false);
    DelayNextDeflect();
    MyAlicePawn.SetCollisionSize(MyAlicePawn.default.CylinderComponent.CollisionRadius, MyAlicePawn.CylinderComponent.CollisionHeight);
}

event UpdateLockonDeltaRot()
{
}

function StopWeaponFire()
{
    if (MyAlicePawn.Weapon.IsA('WeaponForAliceRange'))
    {
        StopRangeFire();
    }
    else if (MyAlicePawn.Weapon.IsA('WeaponForAliceMelee'))
    {
        StopMeleeFire();
    }
}

function StopMeleeFire()
{
    if (MyAlicePawn.Weapon.IsA('WeaponForAliceMelee'))
    {
        MyAlicePawn.Weapon.ForceEndFire();
        MyAlicePawn.Weapon.HandleFinishedFiring();
    }
}

function StopRangeFire()
{
    if (MyAlicePawn.Weapon.IsA('WeaponForAliceRange'))
    {
        MyAlicePawn.Weapon.ForceEndFire();
        MyAlicePawn.Weapon.HandleFinishedFiring();
        if (MyAlicePawn.IsDoingRangeBlendSpecialMove() && !MyAlicePawn.IsDoingSpecialMove(24) && !MyAlicePawn.IsDoingSpecialMove(20))
        {
            StopFire(MyAlicePawn.Weapon.CurrentFireMode);
            MyAlicePawn.DoSpecialMove(0);
            AliceGameWeaponBase(MyAlicePawn.Weapon).StopWeaponSlotAnim(0.1);
            MyAlicePawn.StopAllConfigAnim(0.05);
        }
    }
}

function DodgeVerticallyWhenTargeting(bool bForward)
{
    if (!bForward)
    {
        MyAlicePawn.DodgeDir = 2;
        DoSpecialMove(37, true);
    }
    else
    {
        MyAlicePawn.DodgeDir = 1;
        DoSpecialMove(37, true);
    }
}

function DodgeHorizontallyWhenTargeting(bool bLeft)
{
    MyAlicePawn.DodgeDir = (bLeft ? 3 : 4);
    DoSpecialMove(37, true);
}

function DoDodge(EDodgeDirection Dir)
{
    if (!bCanDoDodge)
    {
        return;
    }
    MyAlicePawn.TriggerContextEventClass(11, 0);
    MyAlicePawn.ClearDelayAttachWeapon();
    StopRangeFire();
    if (Dir != 0)
    {
        if (Dir == 3)
        {
            DodgeHorizontallyWhenTargeting(true);
        }
        else if (Dir == 4)
        {
            DodgeHorizontallyWhenTargeting(false);
        }
        else if (Dir == 2)
        {
            DodgeVerticallyWhenTargeting(false);
        }
        else if (Dir == 1)
        {
            DodgeVerticallyWhenTargeting(true);
        }
    }
    if (MyAlicePawn.bIsJumping || IsDoingSpecialMove(50) || MyAlicePawn.Physics == 2)
    {
        CycleFloatManager.bDisableAfterLanded = true;
        MyAlicePawn.bHasDodgeInAir = true;
    }
}

function Dodge()
{
    local float Angle;
    local Vector vInput;
    local EDodgeDirection DodgeDir;
    
    if (!CanDodge())
    {
        bPressedJump = false;
        return;
    }
    vInput = (IsMoveInputIgnored() ? AlicePlayerInput(PlayerInput).InputVectorDuringIgnore : AlicePlayerInput(PlayerInput).InputVector);
    if (VSize(vInput) > float(0))
    {
        Angle = CalcAngleBetweenVectors(vector(Pawn.Rotation), vInput);
        if (Abs(Angle) < 3.1415927 * 0.25)
        {
            DodgeDir = 1;
        }
        else if (Abs(Angle) > 3.1415927 * 0.75)
        {
            DodgeDir = 2;
        }
        else if (Angle > float(0))
        {
            DodgeDir = 4;
        }
        else
        {
            DodgeDir = 3;
        }
    }
    else
    {
        DodgeDir = 1;
    }
    if (MyAlicePawn.IsDoingSpecialMove(37) || MyAlicePawn.IsDoingComboBlendSpecialMove() || MyAlicePawn.IsDoingSpecialMove(18))
    {
        bPressedJump = false;
        PendingDodge = DodgeDir;
        if (UpdateComboInputState(1))
        {
            if (FlagComboBlendingStart && FlagComboInputAcceptStart)
            {
                DoDodge(PendingDodge);
            }
        }
        return;
    }
    if (TrySlideOnDodge(DodgeDir))
    {
        return;
    }
    DoDodge(DodgeDir);
}

function bool CanDodge()
{
    if (!MyAlicePawn.bCanCombat || !MyAlicePawn.bCanDodge)
    {
        return false;
    }
    if (AlicePlayerInput(PlayerInput).bDisableInputInCinematic || MyAlicePawn.bIsDoingContextAction || MyAlicePawn.CurrentContextActor != none || MyAlicePawn.bInGiantMode || MyAlicePawn.IsInShadowMode() || bLookingAtPointOfInterest || bShrinkingModeActive)
    {
        return false;
    }
    if (MyAlicePawn.bInJumpPad || MyAlicePawn.IsDoingSpecialMove(49) || MyAlicePawn.IsDoingSpecialMove(50) || MyAlicePawn.IsDoingSpecialMove(52) || MyAlicePawn.bIsTurning || AlicePawn(Pawn).isInConversationMode())
    {
        return false;
    }
    if (!IsInState('PlayerWalking') && !IsInState('PlayerLockOnTarget') && !IsInState('FirstPersonView') && !IsInState('Grabbed') && !IsInState('Frozen') && !IsInState('AttachedByNPCs'))
    {
        return false;
    }
    if (IsDoingSpecialMove(39) || IsDoingSpecialMove(40) || IsDoingSpecialMove(43) || IsDoingSpecialMove(36) || IsDoingSpecialMove(47) || IsDoingSpecialMove(24) || IsDoingSpecialMove(25) || MyAlicePawn.bInShield)
    {
        return false;
    }
    if (IsDoingSpecialMove(41) || IsDoingSpecialMove(42) || IsDoingSpecialMove(43))
    {
        return false;
    }
    if ((MyAlicePawn.bIsJumping || IsDoingSpecialMove(50) || MyAlicePawn.Physics == 2) && MyAlicePawn.bHasDodgeInAir)
    {
        return false;
    }
    return true;
}

function bool TrySlideOnDodge(EDodgeDirection DodgeDir)
{
    local WeaponForAlice Weapon;
    local Vector vOffset, DeltaPos, VDir;
    local float fCollisionRadius;
    local ESpecialMove SM_Slide;
    
    if (DodgeDir != 1 && DodgeDir != 2)
    {
        return false;
    }
    Weapon = WeaponForAlice(Pawn.Weapon);
    if (Weapon == none || !Weapon.EnableSlideOnDodge)
    {
        return false;
    }
    if (Weapon.bIsSlideToTarget)
    {
        return true;
    }
    if (Pawn(TargetingActor) != none)
    {
        vOffset = TargetingActor.Location - MyAlicePawn.Location;
        fCollisionRadius = Pawn(TargetingActor).CylinderComponent.CollisionRadius;
    }
    else if (GameBreakableActor(TargetingActor) != none)
    {
        vOffset = TargetBActorInfo.vLocation - MyAlicePawn.Location;
        fCollisionRadius = GameBreakableActor(TargetingActor).StaticMeshComponent.Bounds.SphereRadius;
    }
    else
    {
        return false;
    }
    if (VSize(vOffset) > Weapon.EnableSlideDistance)
    {
        return false;
    }
    vOffset.Z = 0.0;
    VDir = Normal(vOffset);
    if (Weapon.EnableSlideOnDodgeBack && DodgeDir == 2)
    {
        SM_Slide = 54;
        DeltaPos = -VDir * Weapon.SlideBackwardDistance;
        MyAlicePawn.SetRotation(rotator(VDir));
    }
    else if (DodgeDir == 1)
    {
        SM_Slide = 53;
        vOffset -= VDir * (MyAlicePawn.CylinderComponent.CollisionRadius + fCollisionRadius);
        if (VSize(vOffset) < Weapon.SlideMinDistance)
        {
            return true;
        }
        else if (VSize(vOffset) > Weapon.SlideMaxDistance)
        {
            MyAlicePawn.SetRotation(rotator(VDir));
            DeltaPos = VDir * Weapon.SlideMaxDistance;
        }
        else
        {
            MyAlicePawn.SetRotation(rotator(VDir));
            DeltaPos = vOffset;
        }
    }
    else
    {
        return false;
    }
    Weapon.PreSlideToTarget(DeltaPos, SM_Slide);
    return true;
}

exec function CloneButtonReleased()
{
}

function DetonateClockBomb()
{
    if (MyAlicePawn.MyClonePawn == none || AliceClonePawn(MyAlicePawn.MyClonePawn).CloneState < 2 || AliceClonePawn(MyAlicePawn.MyClonePawn).CloneState > 3)
    {
        return;
    }
    MyAlicePawn.TriggerContextEventClass(19, 0);
    if (MyAlicePawn.bHoldingWatch)
    {
        DoSpecialMove(35, true);
    }
    else
    {
        AliceClonePawn(MyAlicePawn.MyClonePawn).Detonate();
    }
}

event DelayNextClockBomb()
{
    MyAlicePawn.bClockBombIsRecharging = true;
    MyAlicePawn.DetachWatch();
    if (MyAlicePawn.Weapon != none && bTargetingModeActive && !MyAlicePawn.bInShield)
    {
        MyAlicePawn.FadeInWeapon();
    }
    SetTimer(MyAlicePawn.RespawnCloneDelay, false, 'RespawnCloneDelayTimer');
}

function StartHoldClockBomb()
{
    MyAlicePawn.bClockBombCountingDown = true;
}

function SetupClockBomb()
{
    if (bLookingAtPointOfInterest || MyAlicePawn.bInJumpPad || MyAlicePawn.Physics == 2 || MyAlicePawn.IsDoingSpecialMove(52) || MyAlicePawn.IsFighting() || AlicePawn(Pawn).isInConversationMode() || MyAlicePawn.bInGiantMode || MyAlicePawn.bIsDoingContextAction || MyAlicePawn.IsDoingSpecialMove(66))
    {
        if (MyAlicePawn.IsRangeFiring() && !IsInState('FirstPersonView') && !bTargetingModeActive)
        {
        }
        else
        {
            return;
        }
    }
    if (MyAlicePawn.MyClonePawn == none)
    {
        MyAlicePawn.DoSpecialMove(34, true);
        if (WeaponForAliceRange(MyAlicePawn.Weapon) != none)
        {
            WeaponForAliceRange(MyAlicePawn.Weapon).GotoState('Inactive');
        }
    }
}

function bool canClockBomb()
{
    if (!MyAlicePawn.bCanClockBomb)
    {
        return false;
    }
    return AliceCheatManager(CheatManager).canClockBomb();
}

exec function CloneButtonPressed()
{
    local EyeStaff wp;
    
    if (AlicePlayerInput(PlayerInput).bDisableInputInCinematic || !MyAlicePawn.bCanClockBomb)
    {
        return;
    }
    wp = EyeStaff(MyAlicePawn.Weapon);
    if (bLookingAtPointOfInterest || MyAlicePawn.bInJumpPad || MyAlicePawn.IsDoingSpecialMove(52) || MyAlicePawn.IsFighting() || AlicePawn(Pawn).isInConversationMode() || MyAlicePawn.bInGiantMode || MyAlicePawn.bIsDoingContextAction || MyAlicePawn.IsDoingSpecialMove(66) || MyAlicePawn.IsInShadowMode() || wp != none && wp.IsInState('NormalFireState'))
    {
        if (MyAlicePawn.IsRangeFiring() && !IsInState('FirstPersonView') && !bTargetingModeActive)
        {
        }
        else
        {
            return;
        }
    }
    if (!MyAlicePawn.bCanCombat && !MyAlicePawn.bShrinkingModeActive)
    {
        return;
    }
    if (MyAlicePawn.bClockBombIsRecharging)
    {
        return;
    }
    if (!IsInState('PlayerWalking') && !IsInState('PlayerLockOnTarget') && !IsInState('FirstPersonView'))
    {
        return;
    }
    if (IsDodging())
    {
        return;
    }
    QuitFPS();
    if (MyAlicePawn.CanDoContextAction(true))
    {
        if (MyAlicePawn.bClockBombCountingDown)
        {
            DetonateClockBomb();
        }
        return;
    }
    if (!canClockBomb())
    {
        return;
    }
    if (MyAlicePawn.bShrinkFlowerEating)
    {
        return;
    }
    if (!MyAlicePawn.bClockBombCountingDown)
    {
        SetTimer(0.05, false, 'SetupClockBomb');
    }
    else
    {
        DetonateClockBomb();
    }
}

function RespawnCloneDelayTimer()
{
    MyAlicePawn.bClockBombIsRecharging = false;
}

function HoldActionDone()
{
    CurButtonStatus.bInDoingHoldFinishEvent = false;
    CurButtonStatus.HoldFinshedEventDone = true;
    CurButtonStatus.BtnType = 0;
}

function StopTap2HoldEvent()
{
    MyAlicePawn.DoSpecialMove(0, true);
    CurButtonStatus.bInDoingTap2HoldEvent = false;
    CurButtonStatus.HoldFinshedEventDone = false;
    ClearTimer('TapCheckTimer');
    ClearTimer('HoldCheckTimer');
    CurButtonStatus.Button_In_Pressed = false;
    CurButtonStatus.BtnType = 0;
}

function DoTap2HoldAction()
{
    CurButtonStatus.bInDoingTap2HoldEvent = true;
    if (CurButtonStatus.BtnType == 1)
    {
        MyAlicePawn.DoSpecialMove(39, true);
    }
}

function HoldCheckTimer()
{
    CurButtonStatus.bInDoingHoldFinishEvent = true;
    if (CurButtonStatus.BtnType == 1)
    {
        MyAlicePawn.DoSpecialMove(40, true);
    }
}

function TapCheckTimer()
{
    if (!IsTimerActive('HoldCheckTimer'))
    {
        SetTimer(CurButtonStatus.HoldTime, false, 'HoldCheckTimer');
    }
    DoTap2HoldAction();
}

function SetTapTimeCheck()
{
    if (!IsTimerActive('TapCheckTimer'))
    {
        CurButtonStatus.HoldFinshedEventDone = false;
        SetTimer(CurButtonStatus.TapTime, false, 'TapCheckTimer');
    }
}

function ReleaseInputButton()
{
    if (CurButtonStatus.bInDoingTap2HoldEvent)
    {
        StopTap2HoldEvent();
        return;
    }
    if (CurButtonStatus.bInDoingHoldFinishEvent || CurButtonStatus.HoldFinshedEventDone)
    {
        CurButtonStatus.Button_In_Pressed = false;
        CurButtonStatus.HoldFinshedEventDone = false;
        return;
    }
    if (CurButtonStatus.Button_In_Pressed)
    {
        if (CurButtonStatus.BtnType == 1)
        {
            Dodge();
        }
    }
    CurButtonStatus.HoldFinshedEventDone = false;
    ClearTimer('TapCheckTimer');
    ClearTimer('HoldCheckTimer');
    CurButtonStatus.Button_In_Pressed = false;
    CurButtonStatus.BtnType = 0;
}

function PressInputButton(ButtonInputStatus inBtn)
{
    if (inBtn.BtnType == 0)
    {
        return;
    }
    if (CurButtonStatus.BtnType != 0)
    {
        return;
    }
    CurButtonStatus = inBtn;
    CurButtonStatus.Button_In_Pressed = true;
    SetTapTimeCheck();
}

function ResetAliceCanBeGrabbed()
{
    MyAlicePawn.bCanBeGrabbed = true;
}

function SwimBounceOff()
{
    ClearTimer('OnBoostSwimCoolDownFinished');
    ClearTimer('OnBoostSwimStop');
    MyAlicePawn.LastSwimSpeed = Normal(MyAlicePawn.LastSwimSpeed) * MyAlicePawn.default.SlowSwimSpeed;
    MyAlicePawn.bBoostingSwim = false;
    MyAlicePawn.bBoostCoolDownFinished = true;
}

function bool IsAliceUnderWater()
{
    return Pawn.Location.Z < AlicePawn(Pawn).waterSurfaceHeight - float(20) ? true : false;
}

function SetWalkingCameraMode()
{
    AlicePlayerCamera(PlayerCamera).CamMod_BackOfPlayer.AddCameraModifier(PlayerCamera);
}

function ClearPlayerPawnMovementFlags()
{
    local AlicePawn P;
    
    P = AlicePawn(Pawn);
    if (P != none)
    {
        P.bIsBraking = false;
        P.bIsTurning = false;
        P.bTurningWhileRunning = false;
    }
}

function ResetSlideParameters()
{
    bCanControlWhenSlide = false;
    bCanJumpWhenSlide = false;
}

function GetSlideParameters(PhysicalMaterial PM)
{
    local AlicePhysicalMaterialProperty Property;
    
    if (PM != none && PM.PhysicalMaterialProperty != none && AlicePhysicalMaterialProperty(PM.PhysicalMaterialProperty) != none)
    {
        Property = AlicePhysicalMaterialProperty(PM.PhysicalMaterialProperty);
        bCanControlWhenSlide = Property.SlideInfo.bCanControlWhenSlide;
        bCanJumpWhenSlide = Property.SlideInfo.bCanJumpWhenSlide;
        SlideParticle = Property.SlideInfo.SlidePS;
    }
}

function bool IsOnSlidePlatform()
{
    local Actor TraceActor;
    local TraceHitInfo HitInfo;
    local float CurrHeight;
    local PhysicalMaterial PM;
    local Vector Loc, out_HitLocation, out_HitNormal, TraceDest, TraceStart, TraceExtent, PawnLoc;
    
    if (Pawn.Physics != 1 && Pawn.Physics != 15)
    {
        return false;
    }
    PawnLoc = Pawn.Location;
    CurrHeight = Pawn.GetCollisionHeight();
    TraceStart = PawnLoc;
    TraceDest = PawnLoc - vect(0.0, 0.0, 1.0) * CurrHeight - vect(0.0, 0.0, 50.0);
    TraceExtent = Pawn.GetCollisionExtent();
    TraceActor = Trace(out_HitLocation, out_HitNormal, TraceDest, TraceStart, true, TraceExtent, HitInfo);
    if (TraceActor != none && AlicePawn(Pawn) != none)
    {
        PM = AlicePawn(Pawn).GetPhysicalMaterial(TraceActor, HitInfo, Loc);
        if (PM != none && PM.bSlide == true)
        {
            AliceGamePawn(Pawn).SlideFriction = PM.Friction;
            GetSlideParameters(PM);
            return true;
        }
    }
    ResetSlideParameters();
    return false;
}

simulated function RecoverToDefaultStatus(optional bool bResetControllerState = false, optional bool bStopFiring = true, optional bool bQuitShrinking = true)
{
    if (MyAlicePawn.IsDoingASpecialMove())
    {
        MyAlicePawn.DoSpecialMove(0, true);
    }
    if (bTargetingModeActive)
    {
        LockOnModeDeactivated();
        TMode_CombatLockOn.PostLockOff();
        TMode_BreakableActor.PostLockOff();
        TMode_SkeletalMeshActor.PostLockOff();
    }
    if (bFirstPersonViewActive)
    {
        QuitFPS();
    }
    MyAlicePawn.SetPawnStance(0);
    if (MyAlicePawn.Weapon != none)
    {
        if (MyAlicePawn.Weapon.IsA('WeaponForAliceMelee') && WeaponForAliceMelee(MyAlicePawn.Weapon).CurrentComboState != 0)
        {
            WeaponForAliceMelee(MyAlicePawn.Weapon).CurrentComboState = 0;
        }
        WeaponForAlice(MyAlicePawn.Weapon).ReSetAllFlag();
        WeaponForAlice(MyAlicePawn.Weapon).HandleFinishedFiring();
        WeaponForAlice(MyAlicePawn.Weapon).ClearAllPendingFire();
        MyAlicePawn.Weapon.ForceEndFire();
    }
    if (bStopFiring)
    {
        StopFire(MyAlicePawn.Weapon.CurrentFireMode);
        MyAlicePawn.StopAllConfigAnim(0.05);
    }
    MyAlicePawn.SetPawnStance(0);
    MyAlicePawn.bHasDodgeInAir = false;
    if (bQuitShrinking && bShrinkingModeActive)
    {
        UnShrinking();
    }
    if (bResetControllerState)
    {
        GotoState('PlayerWalking');
    }
}

function UpdatePawnStance(Vector newAccel)
{
}

event NotifyPhysicsVolumeChange(PhysicsVolume NewVolume)
{
    if (AliceWaterVolume(NewVolume) != none && AlicePawn(Pawn).bInWaterWalk && !AlicePawn(Pawn).bNeedSwimToTarget)
    {
        BackToSwimPos = AliceWaterVolume(NewVolume).SwimTargetPoint.Location;
        if (VSize(BackToSwimPos) > float(100))
        {
            AlicePawn(Pawn).bNeedSwimToTarget = true;
            IgnoreMoveInput(true);
        }
        else
        {
            AlicePawn(Pawn).bNeedSwimToTarget = false;
        }
    }
    if (NewVolume.bWaterVolume && Pawn.bCollideWorld)
    {
        GotoState('PlayerSwimming');
    }
}

function Rotator GetAdjustedAimFor(Weapon W, Vector StartFireLoc)
{
    local Rotator FireRot;
    local Vector TargetLocation;
    
    if (bTargetingModeActive && TargetNPCSocket.Pawn != none)
    {
        TargetLocation = TargetNPCSocket.Pawn.LockOnInfo.TargetSockets[TargetNPCSocket.SocketIndex].CollisionLocation;
        TargetLocation = TargetLocation - StartFireLoc;
        return rotator(TargetLocation);
    }
    else
    {
        FireRot = Pawn.Rotation;
    }
    return FireRot;
}

function HandleTargetSwitchCommond(float aTurn, float aLookUp)
{
    if (bTargetSwitched || TargetMergeManager == none)
    {
        return;
    }
    TargetMergeManager.HandleTargetSwitchCommond(aTurn, aLookUp);
}

function bool HoldEnoughToTriggerNewSwitch()
{
    if (bTargetSwitched && IsRSTriggered() && WorldInfo.TimeSeconds - LastSwitchTargetTime > MyAlicePawn.RSHoldSwitchDuration)
    {
        return true;
    }
    return false;
}

function bool NewTapToTriggerNewSwitch()
{
    if (bTargetSwitched && !IsLastTickRSTriggered() && IsRSTriggered())
    {
        return true;
    }
    return false;
}

function bool IsRSTriggered()
{
    return GetRSValue() > MyAlicePawn.RTTapThreshold;
}

function bool IsLastTickRSTriggered()
{
    return LastTickRSValue > MyAlicePawn.RTTapThreshold;
}

function float GetRSValue()
{
    return Sqrt(Square(PlayerInput.RawJoyLookUp) + Square(PlayerInput.RawJoyLookRight));
}

function UpdateCameraTargetingMode(float DeltaTime)
{
    if (bTargetingModeActive)
    {
        if (NewTapToTriggerNewSwitch() || HoldEnoughToTriggerNewSwitch())
        {
            bTargetSwitched = false;
        }
        HandleTargetSwitchCommond(PlayerInput.RawJoyLookRight, -PlayerInput.RawJoyLookUp);
        UpdateAimOffset(DeltaTime);
    }
    LastTickRSValue = GetRSValue();
    if (!IsLastTickRSTriggered())
    {
        LastSwitchTargetTime = 100000000.0;
    }
    UpdateLockOnTargetUI();
}

simulated function UpdateAimOffset(float DeltaTime)
{
    local Vector vPawn, vAim, vWeaponPos, vTarget, vUp;
    local float fAngle, fAngleLimit, fUpPct;
    
    if (bTargetingModeActive)
    {
        if (TargetNPCSocket.Pawn == none && TargetBActorInfo.BActor == none)
        {
            MyAlicePawn.AimOffsetPct.X = 0.0;
            MyAlicePawn.AimOffsetPct.Y = 0.0;
            return;
        }
        if (TargetNPCSocket.Pawn == TargetingActor)
        {
            vTarget = TargetNPCSocket.CollisionSocketLocation;
        }
        else
        {
            vTarget = TargetBActorInfo.vLocation;
        }
        vWeaponPos = MyAlicePawn.Location + vect(0.0, 0.0, 40.0);
        vAim = vTarget - vWeaponPos;
        vAim = Normal(vAim);
        vTarget.Z = vWeaponPos.Z;
        vPawn = vTarget - vWeaponPos;
        vPawn = Normal(vPawn);
        fAngle = Acos(vPawn Dot vAim);
        vUp = vect(0.0, 0.0, -1.0);
        fUpPct = vUp Dot vAim;
        if (fUpPct > float(0))
        {
            fAngle *= float(-1);
        }
    }
    else if (bFirstPersonViewActive)
    {
        if (Rotation.Pitch < 32768)
        {
            fAngle = 3.1415927 * float(Rotation.Pitch) / float(32768);
        }
        else
        {
            fAngle = 3.1415927 * float(Rotation.Pitch - 65535) / float(32768);
        }
    }
    else
    {
        MyAlicePawn.AimOffsetPct.X = 0.0;
        MyAlicePawn.AimOffsetPct.Y = 0.0;
        return;
    }
    MyAlicePawn.AimOffsetPct.X = 0.0;
    fAngleLimit = 3.1415927 * 0.25;
    if (fAngle < float(0))
    {
        MyAlicePawn.AimOffsetPct.Y = FClamp(fAngle / fAngleLimit, -1.0, 0.0);
    }
    else
    {
        MyAlicePawn.AimOffsetPct.Y = FClamp(fAngle / fAngleLimit, 0.0, 1.0);
    }
}

function Vector CalculateJumpInitVelocity(float fDist2D, float fDistZ, Vector Dir)
{
    local Vector InitVelocity;
    local float JumpHeight, GravZ, RealVelocityZ, TimeInAir, SpeedSize2D;
    
    GravZ = MyAlicePawn.GetGravityZ();
    JumpHeight = MyAlicePawn.CylinderComponent.CollisionHeight + fDistZ;
    TimeInAir = Sqrt(Abs(JumpHeight / GravZ));
    if (TimeInAir > float(0))
    {
        RealVelocityZ = MyAlicePawn.CombatJumpZ + fDistZ / TimeInAir;
        TimeInAir *= 2.0;
        SpeedSize2D = fDist2D / TimeInAir;
        InitVelocity = Dir * SpeedSize2D;
        InitVelocity.Z = RealVelocityZ;
    }
    return InitVelocity;
}

native function bool IsWalkingOnOrientalRock(out Actor TracedBaseActor)
{
    TracedBaseActor;
}

function LeavingbShrinkingMode()
{
    local AlicePawn Alice2Pawn;
    local Vector NewLocation, CheckSize;
    local Actor BaseActor;
    
    Alice2Pawn = AlicePawn(Pawn);
    if (Alice2Pawn == none)
    {
        return;
    }
    Alice2Pawn.SetDrawScale(1.0);
    Alice2Pawn.ResetCollisionSize();
    if (!MyAlicePawn.UnshrinkOnBase && VSize2D(MyAlicePawn.Velocity) == float(0))
    {
        if (!IsZero(MyAlicePawn.LastSafeVerifyUnShrinkPoint))
        {
            NewLocation = MyAlicePawn.LastSafeVerifyUnShrinkPoint;
            ClientMessage("===== LastSafeVerifyUnShrinkPoint =====");
            NewLocation.Z -= float(40);
            MyAlicePawn.FarMoveSetLocation(NewLocation, true);
            CheckSize.X = CylinderComponent(MyAlicePawn.default.CollisionComponent).CollisionRadius;
            CheckSize.Y = CylinderComponent(MyAlicePawn.default.CollisionComponent).CollisionRadius;
            CheckSize.Z = CylinderComponent(MyAlicePawn.default.CollisionComponent).CollisionHeight;
            MyAlicePawn.FindSpot(CheckSize, NewLocation);
            MyAlicePawn.FarMoveSetLocation(NewLocation, true);
        }
    }
    if (IsWalkingOnOrientalRock(BaseActor) && VSize2D(MyAlicePawn.Velocity) > float(0))
    {
        NewLocation = MyAlicePawn.Location;
        NewLocation.Z += float(20);
        MyAlicePawn.FarMoveSetLocation(NewLocation, true);
    }
    Alice2Pawn.JumpZ = Alice2Pawn.default.JumpZ;
    Alice2Pawn.MaxWalkingSpeed = Alice2Pawn.default.MaxWalkingSpeed;
    Alice2Pawn.MaxRunningSpeed = Alice2Pawn.default.MaxRunningSpeed;
    MyAlicePawn.BlendShrinkCameraDistance(0.0, false, true);
    IsShrinking = false;
    IsUnShrinking = false;
    bTryUnShrinkNow = false;
    bShrinkingModeActive = false;
    MyAlicePawn.bShrinkingModeActive = false;
    bPressedJump = false;
    ClearTimer('OnPlayShrinkParticle');
    MyAlicePawn.MeshHeightOffset = -(MyAlicePawn.CylinderComponent.CollisionHeight + MyAlicePawn.MeshTranslationNudgeOffset);
    MyAlicePawn.EnableTranslateIK(true);
}

function EnteringShrinkingMode()
{
    local AlicePawn Alice2Pawn;
    
    Alice2Pawn = AlicePawn(Pawn);
    if (Alice2Pawn == none)
    {
        return;
    }
    Alice2Pawn.ResetUpperBodyComponent();
    Alice2Pawn.JumpZ = Alice2Pawn.ShrinkJumpHeight;
    Alice2Pawn.MaxWalkingSpeed = Alice2Pawn.ShrinkMaxWalkingSpeed;
    Alice2Pawn.MaxRunningSpeed = Alice2Pawn.ShrinkMaxRunningSpeed;
    MyAlicePawn.BlendShrinkCameraDistance(0.0, true, true);
    IsShrinking = false;
    IsUnShrinking = false;
}

function OnShrinkingCoolDown()
{
    ShrinkingCoolDown = false;
}

function OnPlayShrinkParticle()
{
    MyAlicePawn.PlayParticle(MyAlicePawn.Location, MyAlicePawn.Rotation, MyAlicePawn.StartShrink, true);
    PlaySound(MyAlicePawn.ShrinkBubbleSound);
}

exec function UnShrinking()
{
    if (MyAlicePawn.IsPawnInAStance(1))
    {
        if (bPendingShrinkRequest)
        {
            bPendingShrinkRequest = false;
        }
        return;
    }
    if (IsPaused())
    {
        return;
    }
    if (MyAlicePawn.isInConversationMode() || !MyAlicePawn.bCanShrink || ShrinkingCoolDown)
    {
        return;
    }
    if (IsShrinking)
    {
        bTryUnShrinkNow = true;
        return;
    }
    if (Pawn != none && AlicePawn(Pawn) != none)
    {
        if (bShrinkingModeActive && AlicePawn(Pawn).CannotUnShrink())
        {
            bTryUnShrinkNow = true;
            return;
        }
        if (bShrinkingModeActive && bCanNotGrowBig == true)
        {
            PlaySound(AlicePawn(Pawn).SoundCueToPlay);
            return;
        }
        if (bShrinkingModeActive)
        {
            bTryUnShrinkNow = false;
            bShrinkingModeActive = false;
            AlicePawn(Pawn).bShrinkingModeActive = false;
            IsUnShrinking = true;
            PlaySound(AlicePawn(Pawn).UnShrinkingSound);
            MyAlicePawn.ShrinkEmitter = Spawn(class'Engine.EmitterSpawnable', self, , MyAlicePawn.Location);
            if (MyAlicePawn.ShrinkEmitter != none && MyAlicePawn.EndShrink != none)
            {
                MyAlicePawn.ShrinkEmitter.SetLocation(MyAlicePawn.Location);
                MyAlicePawn.ShrinkEmitter.SetTemplate(MyAlicePawn.EndShrink, true);
            }
            ClearTimer('OnPlayShrinkParticle');
            SetTimer(0.01, false, 'OnShrinkingCoolDown');
            MyAlicePawn.DoSpecialMove(52, true);
            ShrinkingCoolDown = true;
            MyAlicePawn.EnableTranslateIK(false);
            if (!MyAlicePawn.bSonarAlwaysVisible)
            {
                SonarManager.SetActive(false);
            }
            MyAlicePawn.TriggerContextEventClass(10, 1);
            SoundModeManager.SetShrinkMode(false);
            ClearTimer('OnActivateSonar');
            if (MyAlicePawn.Physics == 2)
            {
                MyAlicePawn.DoSpecialMove(3, false);
            }
            if (MyAlicePawn.CurrentContextActor != none)
            {
                ShowContextActionUIHint(0, MyAlicePawn.CurrentContextActor.UITextToDisplay);
            }
            if (IsInState('PlayerSlide'))
            {
                AlicePawn(Pawn).PlaySlideCameraAnim();
            }
        }
        else if (bPendingShrinkRequest)
        {
            bPendingShrinkRequest = false;
        }
    }
}

exec function ChangeShrinkingMode()
{
    bTryUnShrinkNow = false;
    if (MyAlicePawn.bInLondon)
    {
        return;
    }
    if (AlicePlayerInput(PlayerInput).bDisableInputInCinematic || IsPaused() || MyAlicePawn.bInJumpPad || bShrinkingModeActive || bIsHoldingPOIButton || MyAlicePawn.bInHysteriaMode)
    {
        return;
    }
    if (MyAlicePawn.isInConversationMode() || !MyAlicePawn.bCanShrink || bCinematicMode || IsShrinking || IsUnShrinking || ShrinkingCoolDown || bTryUnShrinkNow || MyAlicePawn.bIsDoingContextAction)
    {
        return;
    }
    if (IsInState('PlayerSlide') || MyAlicePawn.IsDoingSpecialMove(55))
    {
        return;
    }
    if (IsMeleeCharging() || MyAlicePawn.IsFighting() || IsDodging())
    {
        if (MyAlicePawn.IsDoingAttackSpecialMove())
        {
            if (MyAlicePawn.IsRangeFiring() && !IsInState('FirstPersonView') && !bTargetingModeActive)
            {
            }
            else
            {
                if (!bShrinkingModeActive)
                {
                    bPendingShrinkRequest = true;
                }
                return;
            }
        }
    }
    if ((IsInState('PlayerWalking') || IsInState('AttachedByNPCs') || IsInState('FirstPersonView') || IsInState('PlayerLockOnTarget')) && MyAlicePawn.Physics == 1)
    {
        if (bShrinkingModeActive && bCanNotGrowBig == true)
        {
            PlaySound(AlicePawn(Pawn).SoundCueToPlay);
            return;
        }
        if (IsInState('PlayerLockOnTarget') || IsInState('FirstPersonView'))
        {
            RecoverToDefaultStatus(false, false, false);
            GotoState('PlayerWalking');
        }
        bPendingShrinkRequest = false;
        if (!bShrinkingModeActive)
        {
            bShrinkingModeActive = true;
            AlicePawn(Pawn).bShrinkingModeActive = true;
            PlaySound(AlicePawn(Pawn).ShrinkingSound);
            IsShrinking = true;
            MyAlicePawn.PlayParticle(MyAlicePawn.Location, MyAlicePawn.Rotation, MyAlicePawn.StartShrink, true);
            PlaySound(MyAlicePawn.ShrinkBubbleSound);
            MyAlicePawn.Velocity = vect(0.0, 0.0, 0.0);
            MyAlicePawn.ClearDelayAttachWeapon();
            SetTimer(MyAlicePawn.ShrinkParticleIntermittentTime, true, 'OnPlayShrinkParticle');
            SetTimer(0.01, false, 'OnShrinkingCoolDown');
            MyAlicePawn.DoSpecialMove(52, true);
            ShrinkingCoolDown = true;
            if (IsInState('AttachedByNPCs'))
            {
                MyAlicePawn.ForceDetachAllNPC();
            }
            MyAlicePawn.TriggerContextEventClass(10, 0);
            SoundModeManager.SetShrinkMode(true);
            SetTimer(0.1, false, 'OnActivateSonar');
            SonarManager.checkLeftActors();
        }
    }
}

function OnActivateSonar()
{
    if (!bShrinkingModeActive || !MyAlicePawn.bCanEnableSonar)
    {
        return;
    }
    if (!MyAlicePawn.bSonarAlwaysVisible)
    {
        SonarManager.SetActive(true);
    }
}

function StopLockOnCamera()
{
    if (MyAlicePawn.IsCurAbilityCamera(MyAlicePawn.StrafeCamera))
    {
        MyAlicePawn.SetAliceAbilityCamera(MyAlicePawn.StrafeCamera, true);
    }
    else if (MyAlicePawn.IsCurAbilityCamera(MyAlicePawn.CombatCamera))
    {
        MyAlicePawn.SetAliceAbilityCamera(MyAlicePawn.CombatCamera, true, false);
        MyAlicePawn.AliceForceStopCameraAnim(MyAlicePawn.CombatCamera.Animation);
        MyAlicePawn.SwitchLockOnCamera(false);
    }
    MyAlicePawn.ResetAliceCameraDelays();
}

function ResetCameraPamameters()
{
    if (bUseLockOnCameraParameters)
    {
        return;
    }
    MyAlicePawn.ResetAliceCameraProperties();
    MyAlicePawn.bAliceStartCombatCam = false;
    MyAlicePawn.bAliceCombatCamReady = false;
}

function ResetMaterialsForNPCs()
{
    if (TargetNPCSocket.Pawn != none)
    {
        TargetNPCSocket.Pawn.OnNotLockedOn();
    }
}

function TargetingActorSwitched()
{
    bTargetSwitched = true;
    MyAlicePawn.PlaySound(Snd_TargetLockSwitch);
    LastSwitchTargetTime = WorldInfo.TimeSeconds;
    if (MyAlicePawn.bEnableTargetOnDestroyedActor)
    {
        ClearTimer('ChangeTargetFromDeadActor');
    }
    MyAlicePawn.TriggerContextEventClass(4, 0);
}

function CheckIfEnterFPSAfterQuitLockOn()
{
    if (WeaponForAliceRange(MyAlicePawn.Weapon) != none && MyAlicePawn.Weapon.IsInState('AliceWeaponRangeFire') || MyAlicePawn.Weapon.IsInState('NormalFireState'))
    {
        EnterFPS();
    }
}

function LockOnModeDeactivated()
{
    if (!bTargetingModeActive)
    {
        return;
    }
    Pawn.PlaySound(Snd_TargetLockOff);
    ClearTargetInfo();
    AlicePlayerCamera(PlayerCamera).CamMod_Targeting.RemoveCameraModifier(PlayerCamera);
    AlicePlayerCamera(PlayerCamera).CamMod_BackOfPlayer.AddCameraModifier(PlayerCamera);
    if (bUseLockOnCameraParameters)
    {
        bUseLockOnCameraParameters = false;
        StopLockOnCamera();
    }
    if (LockOnEffect != none)
    {
        LockOnEffect.bShowInGame = false;
    }
    ShowLockOnTargetUI(false);
    if (MyAlicePawn.bShrinkingModeActive)
    {
        MyAlicePawn.MaxWalkingSpeed = MyAlicePawn.ShrinkMaxWalkingSpeed;
        MyAlicePawn.MaxRunningSpeed = MyAlicePawn.ShrinkMaxRunningSpeed;
    }
    else
    {
        MyAlicePawn.MaxWalkingSpeed = MyAlicePawn.default.MaxWalkingSpeed;
        MyAlicePawn.MaxRunningSpeed = MyAlicePawn.default.MaxRunningSpeed;
    }
    MyAlicePawn.bInLockOnMode = false;
    bTargetingModeActive = false;
    MyAlicePawn.bStopAtLedges--;
    if (MyAlicePawn.IsAliveAndWell())
    {
        if (WeaponForAliceRange(MyAlicePawn.Weapon) != none && MyAlicePawn.Weapon.IsInState('AliceWeaponRangeFire') || MyAlicePawn.Weapon.IsInState('NormalFireState'))
        {
            if (TeapotCannon(MyAlicePawn.Weapon) == none || !TeapotCannon(MyAlicePawn.Weapon).IsCharging())
            {
                SetTimer(MyAlicePawn.DelayToActivateAimingModeWhenQuitLockOn, false, 'CheckIfEnterFPSAfterQuitLockOn');
            }
        }
        MyAlicePawn.SetPawnStance(0);
        MyAlicePawn.SetTimerToHideWeapon();
        if (BlockPuzzleActor != none && BlockPuzzleActor.IsReadyToPlay())
        {
            GotoState('PlayerBlockPuzzle');
        }
        else
        {
            GotoState('PlayerWalking');
        }
    }
}

function ClearPreTargetInfo()
{
    PreTargetingActor = none;
    PreTargetNPCSocket.Pawn = none;
    PreTargetNPCSocket.SocketIndex = -1;
    PreTargetBActorInfo.BActor = none;
    PreTargetSMAInfo.Actor = none;
}

function ClearTargetInfo()
{
    TargetingActor = none;
    TargetNPCSocket.Pawn = none;
    TargetNPCSocket.SocketIndex = -1;
    TargetBActorInfo.BActor = none;
    TargetSMAInfo.Actor = none;
}

function LockOnModeActivated()
{
    if (bTargetingModeActive)
    {
        return;
    }
    AlicePlayerCamera(PlayerCamera).CamMod_BackOfPlayer.RemoveCameraModifier(PlayerCamera);
    AlicePlayerCamera(PlayerCamera).CamMod_Targeting.AddCameraModifier(PlayerCamera);
    Pawn.PlaySound(Snd_TargetLockOn);
    if (!bUseLockOnCameraParameters)
    {
        bUseLockOnCameraParameters = true;
        MyAlicePawn.SetLockOnCameraParameters();
    }
    if (LockOnEffect != none)
    {
        LockOnEffect.bShowInGame = true;
    }
    MyAlicePawn.bInLockOnMode = true;
    bTargetingModeActive = true;
    MyAlicePawn.bStopAtLedges++;
    ShowLockOnTargetUI(true);
    ClearPreTargetInfo();
    ClearTimer('EnterFPS');
    ShowHealthUI(MyAlicePawn.Health, MyAlicePawn.HealthMax);
    if (AliceGameInfo(WorldInfo.Game).GFxHUDMenu != none)
    {
        AliceGameInfo(WorldInfo.Game).GFxHUDMenu.ShowLockOnUI();
    }
    forceUpdateRangeWeaponUI();
}

exec function ChangeCameraMode(bool bToggleTargeting)
{
    local bool bTurnOn;
    
    if (MyAlicePawn.bInGiantMode || MyAlicePawn.IsInShadowMode() || MyAlicePawn.bIsDoingContextAction)
    {
        return;
    }
    else if (bShrinkingModeActive || MyAlicePawn.bInLondon)
    {
        if (bToggleTargeting && !bIsHoldingPOIButton)
        {
            ForceResetCamera();
        }
        return;
    }
    if (!MyAlicePawn.bCanCombat || !MyAlicePawn.bCanLockon)
    {
        return;
    }
    if (!IsAnyAvailableWeapon())
    {
        return;
    }
    if (Pawn.Physics == 17)
    {
        MyAlicePawn.SetCameraStickToAlice(!MyAlicePawn.bCameraForcedStickTo);
    }
    if (bHoldTiggerToMaintainTargeting)
    {
        bTurnOn = bToggleTargeting;
    }
    else if (bToggleTargeting)
    {
        bTurnOn = !bTargetingModeActive;
    }
    else if (bTargetingModeActive && TargetingActor == none)
    {
        bTurnOn = false;
    }
    else
    {
        bHoldToggleLockOnButton = false;
        return;
    }
    if (AlicePlayerInput(PlayerInput).bDisableInputInCinematic)
    {
        return;
    }
    if (MyAlicePawn == none || !IsInState('PlayerWalking') && !IsInState('PlayerFloat') && !IsInState('PlayerLockOnTarget') && !IsInState('FirstPersonView'))
    {
        return;
    }
    if (bTurnOn && bPOITriggered)
    {
        return;
    }
    bTargetSwitched = true;
    if (MyAlicePawn.bEnableTargetOnDestroyedActor)
    {
        ClearTimer('ChangeTargetFromDeadActor');
    }
    if (bTurnOn)
    {
        bHoldToggleLockOnButton = true;
    }
    else
    {
        bHoldToggleLockOnButton = false;
    }
    if (!MyAlicePawn.isInConversationMode() && MyAlicePawn.Physics == 1 || MyAlicePawn.Physics == 2)
    {
        if (TMode_CombatLockOn != none && MyAlicePawn.bCanCombat)
        {
            if (!bTurnOn)
            {
                TMode_CombatLockOn.PostLockOff();
            }
        }
        if (TMode_BreakableActor != none && MyAlicePawn.bCanCombat)
        {
            TMode_BreakableActor.Toggle(bTurnOn);
            if (!bTurnOn)
            {
                TMode_BreakableActor.PostLockOff();
            }
        }
        if (TMode_SkeletalMeshActor != none && MyAlicePawn.bCanCombat)
        {
            TMode_SkeletalMeshActor.Toggle(bTurnOn);
            if (!bTurnOn)
            {
                TMode_SkeletalMeshActor.PostLockOff();
            }
        }
        if (bTurnOn && MyAlicePawn.Physics == 1)
        {
            LockOnModeActivated();
        }
        else if (!bTurnOn)
        {
            LockOnModeDeactivated();
        }
        if (TargetMergeManager != none && bTurnOn && MyAlicePawn.Physics == 1)
        {
            TargetMergeManager.DetermineFirstTarget();
        }
        if (TMode_POI != none)
        {
            TMode_POI.Toggle(bToggleTargeting);
        }
        if (bTurnOn && MyAlicePawn.Physics == 1 && !IsInState('PlayerLockOnTarget'))
        {
            GotoState('PlayerLockOnTarget');
        }
    }
    MyAlicePawn.TriggerContextEventClass(13, bToggleTargeting ? 0 : 1);
}

exec function ChangeCameraModePC()
{
    if (MyAlicePawn.bInShield)
    {
        return;
    }
    bHoldTiggerToMaintainTargeting = false;
    if (!bTargetingModeActive)
    {
        bLockOnTriggeredByShiftKey = true;
    }
    else
    {
        bLockOnTriggeredByShiftKey = false;
    }
    ChangeCameraMode(true);
}

function UpdatePreTargetingModes(float DeltaTime)
{
    if (TMode_CombatLockOn != none)
    {
        TMode_CombatLockOn.Update(DeltaTime);
    }
    if (TMode_BreakableActor != none)
    {
        TMode_BreakableActor.Update(DeltaTime);
    }
    if (TMode_SkeletalMeshActor != none)
    {
        TMode_SkeletalMeshActor.Update(DeltaTime);
    }
    if (PreTargetMergeManager != none)
    {
        PreTargetMergeManager.Update(DeltaTime);
    }
}

function UpdateTargetingModes(float DeltaTime)
{
    if (TMode_CombatLockOn != none)
    {
        TMode_CombatLockOn.Update(DeltaTime);
        TMode_CombatLockOn.PostUpdate();
    }
    if (TMode_BreakableActor != none)
    {
        TMode_BreakableActor.Update(DeltaTime);
        TMode_BreakableActor.PostUpdate();
    }
    if (TMode_SkeletalMeshActor != none)
    {
        TMode_SkeletalMeshActor.Update(DeltaTime);
        TMode_SkeletalMeshActor.PostUpdate();
    }
    if (TargetMergeManager != none)
    {
        TargetMergeManager.Update(DeltaTime);
    }
    if (TMode_POI != none)
    {
        TMode_POI.Update(DeltaTime);
        TMode_POI.PostUpdate();
    }
}

function InitTargetingModes()
{
    bCanDoDodge = true;
    if (TMode_CombatLockOn == none)
    {
        TMode_CombatLockOn = Spawn(class'TargetingMode_CombatLockon', self);
        if (TMode_CombatLockOn != none)
        {
            TMode_CombatLockOn.Initialize(self);
        }
    }
    if (TMode_POI == none)
    {
        TMode_POI = Spawn(class'TargetingMode_PointOfInterest', self);
        if (TMode_POI != none)
        {
            TMode_POI.Initialize(self);
        }
    }
    if (TMode_BreakableActor == none)
    {
        TMode_BreakableActor = Spawn(class'TargetingMode_BreakableActor', self);
        if (TMode_BreakableActor != none)
        {
            TMode_BreakableActor.Initialize(self);
        }
    }
    if (TMode_SkeletalMeshActor == none)
    {
        TMode_SkeletalMeshActor = Spawn(class'TargetingMode_SkeletalMeshActor', self);
        if (TMode_SkeletalMeshActor != none)
        {
            TMode_SkeletalMeshActor.Initialize(self);
        }
    }
    if (TargetMergeManager == none)
    {
        TargetMergeManager = new(self) class'TargetingMode_MergeManager';
        TargetMergeManager.Initialize(self);
    }
    if (PreTargetMergeManager == none)
    {
        PreTargetMergeManager = new(self) class'PreTargetingMode_MergeManager';
        PreTargetMergeManager.Initialize(self);
    }
}

function DelayNextDeflect()
{
    SetTimer(MyAlicePawn.DelayTimeForNextDodge, false, 'ResetIfCanDoDeflect');
}

function ResetIfCanDoDeflect()
{
    bCanDoDeflect = true;
}

function DelayNextDodge()
{
    SetTimer(MyAlicePawn.DelayTimeForNextDodge, false, 'ResetIfCanDoDodge');
}

function ResetIfCanDoDodge()
{
    bCanDoDodge = true;
}

native function SetTargetingModeOption(bool bHold)
{
    bHold;
}

function StopWeaponFiring()
{
    MyAlicePawn.Weapon.ForceEndFire();
    MyAlicePawn.Weapon.HandleFinishedFiring();
    MyAlicePawn.SetPawnStance(0);
}

exec function ToggleAutoTargetOnLivePawn()
{
    MyAlicePawn.bEnableTargetOnDestroyedActor = !MyAlicePawn.bEnableTargetOnDestroyedActor;
}

exec function FireToLockOn()
{
    bFireToActivateLockOnMode = !bFireToActivateLockOnMode;
}

exec function StartFire(optional byte FireModeNum)
{
    if (WorldInfo.Pauser == PlayerReplicationInfo)
    {
        return;
    }
    if (!CanFire())
    {
        return;
    }
    if (MyAlicePawn.bCanCombat && !MyAlicePawn.IsDoingSpecialMove(41) && !MyAlicePawn.IsDoingSpecialMove(42))
    {
        if (!MyAlicePawn.bInGiantMode)
        {
            MyAlicePawn.SetPawnStance(1);
        }
        StartFire(FireModeNum);
        if (bFireToActivateLockOnMode && !bTargetingModeActive && !bHoldTiggerToMaintainTargeting && !MyAlicePawn.bInGiantMode)
        {
            LockOnModeActivated();
        }
    }
}

exec function QuitWeaponAttack()
{
    if (MyAlicePawn.bInGiantMode)
    {
        return;
    }
    if (MyAlicePawn.Weapon.IsA('VorpalBlade'))
    {
        VorpalBladeFireRelease();
    }
    else if (MyAlicePawn.Weapon.IsA('HobbyHorse'))
    {
        HobbyHorseFireRelease();
    }
    else if (MyAlicePawn.Weapon.IsA('EyeStaff'))
    {
        EyeStaffFireRelease();
    }
    else if (MyAlicePawn.Weapon.IsA('TeapotCannon'))
    {
        TeapotCannonFireRelease();
    }
}

exec function WeaponAttack()
{
    if (MyAlicePawn.bInGiantMode)
    {
        return;
    }
    if (AlicePlayerInput(PlayerInput).layout.LayoutIndex == 1)
    {
        if (MyAlicePawn.Weapon.IsA('VorpalBlade'))
        {
            VorpalBladeFirePress();
        }
        else if (MyAlicePawn.Weapon.IsA('HobbyHorse'))
        {
            HobbyHorseFirePress();
        }
        else if (MyAlicePawn.Weapon.IsA('EyeStaff') || MyAlicePawn.Weapon.IsA('TeapotCannon'))
        {
            RangeWeaponFirePress();
        }
        else if (MyAlicePawn.Weapon == none)
        {
            SwitchToVorpalBlade();
            VorpalBladeFirePress();
        }
    }
    else if (AlicePlayerInput(PlayerInput).layout.LayoutIndex == 2)
    {
        if (bFirstPersonViewActive)
        {
            SwitchToEyeStaff();
            EyeStaffFirePress();
        }
        else if (WeaponGroup == 1)
        {
            SwitchToVorpalBlade();
            bSwitchWeaponOnly = false;
            VorpalBladeFirePress();
        }
        else if (WeaponGroup == 2)
        {
            SwitchToHobbyHorse();
            bSwitchWeaponOnly = false;
            HobbyHorseFirePress();
        }
    }
}

exec function MeleeAttack()
{
    if (MyAlicePawn.bInGiantMode)
    {
        return;
    }
    if (AlicePlayerInput(PlayerInput).layout.LayoutIndex == 1)
    {
        if (MyAlicePawn.Weapon.IsA('VorpalBlade'))
        {
            VorpalBladeFirePress();
        }
        else if (MyAlicePawn.Weapon.IsA('HobbyHorse'))
        {
            HobbyHorseFirePress();
        }
        else if (!MyAlicePawn.Weapon.IsA('VorpalBlade') && !MyAlicePawn.Weapon.IsA('HobbyHorse'))
        {
            if (nLastMeleeWeapon == 0)
            {
                SwitchToVorpalBlade();
                VorpalBladeFirePress();
            }
            else
            {
                SwitchToHobbyHorse();
                HobbyHorseFirePress();
            }
        }
    }
    else if (AlicePlayerInput(PlayerInput).layout.LayoutIndex == 2)
    {
        if (WeaponGroup == 1)
        {
            SwitchToVorpalBlade();
            bSwitchWeaponOnly = false;
            VorpalBladeFirePress();
        }
        else if (WeaponGroup == 2)
        {
            SwitchToHobbyHorse();
            bSwitchWeaponOnly = false;
            HobbyHorseFirePress();
        }
    }
}

function MeleeFire()
{
    if (!CanFire())
    {
        return;
    }
    MyAlicePawn.FadeInWeapon();
    if (!bTargetingModeActive && MyAlicePawn.bEnableNonLockOnAutoTargeting)
    {
        BackUpNonLockOnTarget = FindNonLockOnPossibleTarget();
    }
    WeaponForAlice(MyAlicePawn.Weapon).PressFireButton();
}

function Actor FindNonLockOnPossibleTarget()
{
    local AliceGameKynapsePawn A;
    local Vector vCenterOfSearch, vPlayerFacing, vTarget;
    local float curDist, MinDist, fRadius, fAngle, angleThreshold;
    local array<Actor> NPCSocketsToBeTargeted;
    local Actor TA, TAWithMinDist;
    local GameBreakableActor B;
    
    vCenterOfSearch = MyAlicePawn.Location;
    fRadius = MyAlicePawn.TargetingSearchRadius;
    MinDist = fRadius;
    angleThreshold = MyAlicePawn.NonLockOnAutoTargetAngleRange * 0.017453292 * 0.5;
    foreach DynamicActors(class'AliceGameKynapsePawn', A)
    {
        if (!A.bHidden && A.IsAliveAndWell())
        {
            vTarget = A.Location - vCenterOfSearch;
            fAngle = CalcAngleBetweenVectors(vPlayerFacing, vTarget);
            if (Abs(fAngle) > angleThreshold)
            {
                break;
            }
            curDist = VSize2D(vCenterOfSearch - A.Location);
            if (curDist < float(50))
            {
                break;
            }
            if (curDist < fRadius)
            {
                TA = A;
                NPCSocketsToBeTargeted.AddItem(TA);
                if (MinDist > curDist)
                {
                    TAWithMinDist = TA;
                    MinDist = curDist;
                }
            }
        }
    }
    foreach DynamicActors(class'GameBreakableActor', B)
    {
        if (!B.bHidden)
        {
            vTarget = B.Location - vCenterOfSearch;
            fAngle = CalcAngleBetweenVectors(vPlayerFacing, vTarget);
            if (Abs(fAngle) > angleThreshold)
            {
                break;
            }
            curDist = VSize2D(vCenterOfSearch - B.Location);
            if (curDist < float(50))
            {
                break;
            }
            if (curDist < fRadius)
            {
                TA = B;
                NPCSocketsToBeTargeted.AddItem(TA);
                if (MinDist > curDist)
                {
                    TAWithMinDist = TA;
                    MinDist = curDist;
                }
            }
        }
    }
    if (NPCSocketsToBeTargeted.Length == 0)
    {
        return none;
    }
    return TAWithMinDist;
}

function RangeFire()
{
    if (!MyAlicePawn.IsTimerActive('FadeInWeapon'))
    {
        MyAlicePawn.FadeInWeapon();
    }
    WeaponForAlice(MyAlicePawn.Weapon).PressFireButton();
}

exec function GiantStomp()
{
    if (!MyAlicePawn.bInGiantMode || !CanFire())
    {
        return;
    }
    if (MyAlicePawn.CurrentContextActor != none && MyAlicePawn.CurrentContextActor.bUseGiantStompActionButton)
    {
        bPressedJump = false;
        ShowContextActionUIHint(-1, MyAlicePawn.CurrentContextActor.UITextToDisplay);
        if (MyAlicePawn.Weapon != none)
        {
            MyAlicePawn.FadeOutWeapon();
        }
        MyAlicePawn.CurrentContextActor.StartContextAction();
    }
    else if (!MyAlicePawn.IsDoingComboBlendSpecialMove())
    {
        MyAlicePawn.DoSpecialMove(18, false);
    }
}

exec function GiantStompOnButtonB()
{
    if (!MyAlicePawn.bInGiantMode || !CanFire())
    {
        return;
    }
    if (!MyAlicePawn.IsDoingComboBlendSpecialMove())
    {
        MyAlicePawn.DoSpecialMove(18, false);
    }
}

exec function FireGiantWeapon()
{
    if (MyAlicePawn.CurrentContextActor != none)
    {
        return;
    }
    if (MyAlicePawn.bInGiantMode && CanFire() && !MyAlicePawn.IsDoingSpecialMove(18))
    {
        if (GiantAliceWeapon(MyAlicePawn.Weapon) == none)
        {
            ClientSetWeapon(class'GiantAliceWeapon');
        }
        else
        {
            WeaponForAlice(MyAlicePawn.Weapon).StartFire(1);
        }
    }
}

exec function ShowWeapon()
{
    MyAlicePawn.WeaponSetHidden(false);
}

exec function HideWeapon()
{
    MyAlicePawn.WeaponSetHidden(true);
}

function bool IsFirstPersonViewActivated()
{
    return IsInState('FirstPersonView');
}

function bool CanFirstPersonView()
{
    if (!MyAlicePawn.bCanCombat || !MyAlicePawn.bCanAiming)
    {
        return false;
    }
    if (AlicePlayerInput(PlayerInput).bDisableInputInCinematic)
    {
        return false;
    }
    if (MyAlicePawn.isInConversationMode() || MyAlicePawn.bInJumpPad || MyAlicePawn.IsDoingSpecialMove(52) || MyAlicePawn.IsDoingSpecialMove(41) || MyAlicePawn.IsDoingSpecialMove(66) || MyAlicePawn.bIsTurning)
    {
        return false;
    }
    if (!IsInState('PlayerWalking') || MyAlicePawn.Physics != 1 || bTargetingModeActive)
    {
        return false;
    }
    if (AlicePlayerCamera(PlayerCamera).bNonGamePlayCamera)
    {
        return false;
    }
    return true;
}

function DeactivateFirstPersonView()
{
    if (!MyAlicePawn.bInLondon)
    {
        if (!IsInState('FirstPersonView') && !bFirstPersonViewActive)
        {
            return;
        }
        if (MyAlicePawn.IsAliveAndWell())
        {
            if (IsInState('FirstPersonView'))
            {
                GotoState('PlayerWalking');
            }
        }
    }
    else
    {
        if (IsInState('FirstPersonView'))
        {
            GotoState('PlayerWalking');
        }
        if (!AlicePlayerCamera(PlayerCamera).bAliceHidden)
        {
            MyAlicePawn.EnableForceTranslucency(false, 1.0, 0.5, 1000, false);
        }
    }
}

exec function QuitFPS()
{
    if (WeaponForAliceRange(MyAlicePawn.Weapon) != none && WeaponForAliceRange(MyAlicePawn.Weapon).IsInState('NormalFireState') || WeaponForAliceRange(MyAlicePawn.Weapon).IsInState('AliceWeaponRangeFire'))
    {
        return;
    }
    if (MyAlicePawn.IsDoingSpecialMove(20) || MyAlicePawn.IsDoingSpecialMove(26))
    {
        bPendingQuitAimingMode = true;
        return;
    }
    DeactivateFirstPersonView();
}

exec function EnterFPS()
{
    if (!MyAlicePawn.bInLondon)
    {
        if (!IsAnyAvailableRangeWeapon())
        {
            return;
        }
        if (MyAlicePawn.IsInShadowMode())
        {
            MyAlicePawn.SwitchCameraZoom();
            return;
        }
        if (!CanFire() || MyAlicePawn.bInGiantMode)
        {
            return;
        }
    }
    if (!bFirstPersonViewActive)
    {
        ActivateFirstPersonView();
    }
    else
    {
        bEnterFPSByRSPress = false;
        QuitFPS();
    }
}

exec function EnterFPSByRS()
{
    if (bCinematicMode)
    {
        return;
    }
    LockOnModeDeactivated();
    bEnterFPSByRSPress = true;
    EnterFPS();
}

function ActivateFirstPersonView()
{
    if (!MyAlicePawn.bInLondon)
    {
        if (!CanFirstPersonView())
        {
            return;
        }
        MyAlicePawn.ClearTimerToHideWeapon();
        bFirstPersonViewActive = true;
        SetAliceFPSCamera();
        MyAlicePawn.ViewPitchMax = MyAlicePawn.ViewPictchMaxWhenAiming;
        MyAlicePawn.ViewPitchMin = MyAlicePawn.ViewPictchMinWhenAiming;
        GotoState('FirstPersonView');
        bShowFPS_Reticule = true;
        UpdateCrossHair();
        bShowFPS_Reticule = false;
        ClearPreTargetInfo();
        TargetNPCSocketLocation2D = CrossHairLocation2D;
        UpdateLockOnTargetUI();
        ShowCrossHair(true);
        MyAlicePawn.bStopAtLedges++;
        MyAlicePawn.TriggerContextEventClass(5, 0);
    }
    else
    {
        bFirstPersonViewActive = true;
        SetAliceFPSCamera();
        GotoState('FirstPersonView');
        MyAlicePawn.EnableForceTranslucency(true, 0.0, 0.5, 1000, false);
    }
}

function SetAliceFPSCamera()
{
    local float OldCameraDistance, OldCameraMaxDistance, OldCameraMinDistance;
    local Vector OldCameraOffset;
    
    OldCameraDistance = MyAlicePawn.AliceCameraDistance;
    OldCameraMaxDistance = MyAlicePawn.AliceCameraMaxDistance;
    OldCameraMinDistance = MyAlicePawn.AliceCameraMinDistance;
    OldCameraOffset = MyAlicePawn.AliceCameraOffset;
    MyAlicePawn.SetAliceAbilityCamera(MyAlicePawn.FPSCamera);
    MyAlicePawn.bStopSettingAbilityCamera = true;
    MyAlicePawn.AliceCameraDistance = OldCameraDistance;
    MyAlicePawn.AliceCameraMaxDistance = OldCameraMaxDistance;
    MyAlicePawn.AliceCameraMinDistance = OldCameraMinDistance;
    MyAlicePawn.AliceCameraOffset = OldCameraOffset;
    MyAlicePawn.AimingZoomDelayElapsed = 0.0;
    MyAlicePawn.AimingFOVBlendTimeElapsed = 0.0;
    MyAlicePawn.AimingFOVOffBlendTimeElapsed = MyAlicePawn.AimingFOVOffBlendTime;
}

exec function RangeWeaponFireRelease()
{
    if (AlicePlayerInput(PlayerInput).bDisableInputInCinematic)
    {
        return;
    }
    if (TeapotCannon(Pawn.Weapon) != none)
    {
        TeapotCannon(Pawn.Weapon).ReleaseFireButton();
    }
    else if (EyeStaff(Pawn.Weapon) != none)
    {
        EyeStaff(Pawn.Weapon).ReleaseFireButton();
    }
}

exec function RangeWeaponFirePress()
{
    local int CurWeaponType;
    local bool bChangeWeaponSucceeded;
    local WeaponForAliceMelee MeleeWeapon;
    
    if (MyAlicePawn.bInLondon || bLookingAtPointOfInterest)
    {
        return;
    }
    if (AlicePlayerInput(PlayerInput).bDisableInputInCinematic || MyAlicePawn.bIsDoingContextAction || MyAlicePawn.CurrentContextActor != none && PressurePad(MyAlicePawn.Base) == none)
    {
        return;
    }
    if (MyAlicePawn.bInJumpPad || MyAlicePawn.Physics == 2 || MyAlicePawn.IsDoingSpecialMove(3) || MyAlicePawn.IsDoingSpecialMove(4) || MyAlicePawn.IsDoingSpecialMove(49) || MyAlicePawn.IsDoingSpecialMove(50) || MyAlicePawn.IsDoingSpecialMove(52) || MyAlicePawn.bIsTurning || AlicePawn(Pawn).isInConversationMode())
    {
        return;
    }
    if (!IsInState('PlayerWalking') && !IsInState('PlayerLockOnTarget') && !IsInState('FirstPersonView'))
    {
        return;
    }
    if (IsDoingSpecialMove(39) || IsDoingSpecialMove(40) || IsDoingSpecialMove(43) || IsDoingSpecialMove(44) || IsDoingSpecialMove(36) || MyAlicePawn.IsShieldBlocking() || IsDoingSpecialMove(47) || IsDoingSpecialMove(34) || IsDoingSpecialMove(41) || IsDoingSpecialMove(42) || IsDoingSpecialMove(43) || IsDoingSpecialMove(34) || MyAlicePawn.bInShield)
    {
        return;
    }
    MeleeWeapon = WeaponForAliceMelee(MyAlicePawn.Weapon);
    if (MeleeWeapon != none)
    {
        if (MeleeWeapon.IsInState('AliceWeaponMeleeFire'))
        {
            return;
        }
    }
    MyAlicePawn.DiscardWatch();
    CurWeaponType = MyAlicePawn.GetCurrentWeaponType(false);
    bSwitchWeaponOnly = false;
    if (CurWeaponType != 3 && CurWeaponType != 4 || PendingRangeWeaponType != 0)
    {
        if (PendingRangeWeaponType != 0)
        {
            if (PendingRangeWeaponType == 3)
            {
                bChangeWeaponSucceeded = ChangeWeaponToEyeStaff();
            }
            else if (PendingRangeWeaponType == 4)
            {
                bChangeWeaponSucceeded = ChangeWeaponToTeapotCannon();
            }
            PendingRangeWeaponType = 0;
        }
        else if (LatestRangeWeaponType == 3)
        {
            bChangeWeaponSucceeded = ChangeWeaponToEyeStaff();
        }
        else if (LatestRangeWeaponType == 4)
        {
            bChangeWeaponSucceeded = ChangeWeaponToTeapotCannon();
        }
        if (bChangeWeaponSucceeded && !bTargetingModeActive && !bFirstPersonViewActive)
        {
            EnterFPS();
        }
    }
    else if (CanFire() && CurWeaponType == 3 || CurWeaponType == 4)
    {
        if (!bTargetingModeActive && !bFirstPersonViewActive)
        {
            EnterFPS();
        }
        RangeFire();
    }
}

function bool IsPepperGrinderAvailable()
{
    local array<AliceGameWeapon> WeaponList;
    local int I;
    
    AliceInventoryManager(Pawn.InvManager).GetWeaponList(WeaponList);
    if (WeaponList.Length == 0)
    {
        return false;
    }
    for (I = 0; I < WeaponList.Length; I++)
    {
        if (WeaponList[I].IsA('EyeStaff'))
        {
            return true;
        }
    }
    return false;
}

function bool IsTeapotCannonAvailable()
{
    local array<AliceGameWeapon> WeaponList;
    local int I;
    
    AliceInventoryManager(Pawn.InvManager).GetWeaponList(WeaponList);
    if (WeaponList.Length == 0)
    {
        return false;
    }
    for (I = 0; I < WeaponList.Length; I++)
    {
        if (WeaponList[I].IsA('TeapotCannon'))
        {
            return true;
        }
    }
    return false;
}

function bool IsAnyAvailableRangeWeapon()
{
    local array<AliceGameWeapon> WeaponList;
    local int I;
    
    AliceInventoryManager(Pawn.InvManager).GetWeaponList(WeaponList);
    if (WeaponList.Length == 0)
    {
        return false;
    }
    for (I = 0; I < WeaponList.Length; I++)
    {
        if (WeaponList[I].IsA('WeaponForAliceRange'))
        {
            return true;
        }
    }
    return false;
}

function bool IsAnyAvailableWeapon()
{
    local array<AliceGameWeapon> WeaponList;
    
    AliceInventoryManager(Pawn.InvManager).GetWeaponList(WeaponList);
    if (WeaponList.Length > 0)
    {
        return true;
    }
    return false;
}

exec function SetPendingWeaponToTeapotCannon()
{
    local int CurWeaponType;
    
    CurWeaponType = MyAlicePawn.GetCurrentWeaponType();
    LatestRangeWeaponType = 4;
    if (CurWeaponType != 4)
    {
        if (CurWeaponType == 3)
        {
            StopRangeFire();
        }
        if (CanSwitchRangeWeapon())
        {
            bSwitchWeaponOnly = true;
            if (ChangeWeaponToTeapotCannon())
            {
                if (!bTargetingModeActive && !bFirstPersonViewActive)
                {
                    MyAlicePawn.SetTimerToHideWeapon();
                }
            }
        }
    }
}

exec function SetPendingWeaponToPiperGrinder()
{
    local int CurWeaponType;
    
    CurWeaponType = MyAlicePawn.GetCurrentWeaponType();
    LatestRangeWeaponType = 3;
    if (CurWeaponType != 3)
    {
        if (CurWeaponType == 4)
        {
            StopRangeFire();
        }
        if (CanSwitchRangeWeapon())
        {
            bSwitchWeaponOnly = true;
            if (ChangeWeaponToEyeStaff())
            {
                if (!bTargetingModeActive && !bFirstPersonViewActive)
                {
                    MyAlicePawn.SetTimerToHideWeapon();
                }
            }
        }
    }
}

exec function TryToSwitchRangeWeapon(bool bLeft)
{
    local int CurWeaponType;
    
    if (!IsTeapotCannonAvailable() || !IsPepperGrinderAvailable())
    {
        return;
    }
    CurWeaponType = MyAlicePawn.GetCurrentWeaponType();
    if (MyAlicePawn.IsTimerActive('FadeInWeapon'))
    {
        return;
    }
    MyAlicePawn.DiscardWatch();
    if (CurWeaponType != 3 && CurWeaponType != 4)
    {
        if (LatestRangeWeaponType == 4)
        {
            SetPendingWeaponToPiperGrinder();
        }
        else if (LatestRangeWeaponType == 3)
        {
            SetPendingWeaponToTeapotCannon();
        }
        else if (bLeft)
        {
            SetPendingWeaponToPiperGrinder();
        }
        else
        {
            SetPendingWeaponToTeapotCannon();
        }
    }
    else if (CurWeaponType == 3)
    {
        SetPendingWeaponToTeapotCannon();
        PlaySound(Sound_PGTOTC);
    }
    else
    {
        SetPendingWeaponToPiperGrinder();
        PlaySound(Sound_TCTOPG);
    }
}

exec function SwitchToTC()
{
    if (!IsTeapotCannonAvailable() || !IsPepperGrinderAvailable())
    {
        return;
    }
    if (MyAlicePawn.IsTimerActive('FadeInWeapon'))
    {
        return;
    }
    SetPendingWeaponToTeapotCannon();
}

exec function SwitchToPG()
{
    if (!IsTeapotCannonAvailable() || !IsPepperGrinderAvailable())
    {
        return;
    }
    if (MyAlicePawn.IsTimerActive('FadeInWeapon'))
    {
        return;
    }
    SetPendingWeaponToPiperGrinder();
}

exec function TeapotCannonFireRelease()
{
    if (IsMeleeCharging())
    {
        return;
    }
    if (!CanFire())
    {
        return;
    }
    if (AlicePlayerInput(PlayerInput).bDisableInputInCinematic)
    {
        return;
    }
    if (TeapotCannon(Pawn.Weapon) != none)
    {
        TeapotCannon(Pawn.Weapon).ReleaseFireButton();
    }
}

exec function TeapotCannonFirePress()
{
    if (!CanFire())
    {
        if (bTargetingModeActive)
        {
            if (TeapotCannon(MyAlicePawn.Weapon) == none)
            {
                ChangeWeaponToTeapotCannon();
            }
        }
        return;
    }
    if (TeapotCannon(MyAlicePawn.Weapon) == none)
    {
        if (ChangeWeaponToTeapotCannon() && !bTargetingModeActive && !bFirstPersonViewActive)
        {
            EnterFPS();
            return;
        }
    }
    else
    {
        if (!bTargetingModeActive && !bFirstPersonViewActive)
        {
            EnterFPS();
            return;
        }
        RangeFire();
    }
}

function bool ChangeWeaponToTeapotCannon()
{
    if (CanChangeWeapon(MyAlicePawn.Weapon))
    {
        if (EyeStaff(MyAlicePawn.Weapon) != none)
        {
            EyeStaff(MyAlicePawn.Weapon).bReleasedFireButton = true;
        }
        return ClientSetWeapon(class'TeapotCannon');
    }
    return false;
}

exec function EyeStaffFireRelease()
{
    if (IsMeleeCharging())
    {
        return;
    }
    if (!CanFire())
    {
        return;
    }
    if (AlicePlayerInput(PlayerInput).bDisableInputInCinematic)
    {
        return;
    }
    if (EyeStaff(Pawn.Weapon) != none)
    {
        EyeStaff(Pawn.Weapon).ReleaseFireButton();
    }
}

exec function EyeStaffFirePress()
{
    if (IsMeleeCharging() || !CanFire())
    {
        if (bTargetingModeActive)
        {
            if (EyeStaff(MyAlicePawn.Weapon) == none)
            {
                ChangeWeaponToEyeStaff();
            }
        }
        return;
    }
    if (EyeStaff(MyAlicePawn.Weapon) == none)
    {
        if (ChangeWeaponToEyeStaff() && !bTargetingModeActive && !bFirstPersonViewActive)
        {
            EnterFPS();
            return;
        }
    }
    else
    {
        if (!bTargetingModeActive && !bFirstPersonViewActive)
        {
            EnterFPS();
            return;
        }
        RangeFire();
    }
}

function bool ChangeWeaponToEyeStaff()
{
    if (CanChangeWeapon(MyAlicePawn.Weapon))
    {
        return ClientSetWeapon(class'EyeStaff');
    }
    return false;
}

exec function HobbyHorseFireRelease()
{
    if (IsMeleeCharging())
    {
        return;
    }
    if (!CanFire())
    {
        return;
    }
    if (AlicePlayerInput(PlayerInput).bDisableInputInCinematic)
    {
        return;
    }
    if (HobbyHorse(Pawn.Weapon) != none)
    {
        HobbyHorse(Pawn.Weapon).ReleaseFireButton();
    }
}

exec function HobbyHorseFirePress()
{
    local bool bIsTherePendingFire;
    
    if (IsMeleeCharging() || bLookingAtPointOfInterest)
    {
        return;
    }
    MyAlicePawn.DiscardWatch();
    if (!CanFire())
    {
        bIsTherePendingFire = WeaponForAlice(MyAlicePawn.Weapon).FlagHasComboInputBeforeBlendingStart;
        if (HobbyHorse(MyAlicePawn.Weapon) == none)
        {
            ChangeWeaponToHobbyHorse();
        }
        if (bIsTherePendingFire)
        {
            if (WeaponForAliceMelee(MyAlicePawn.Weapon) != none)
            {
                WeaponForAlice(MyAlicePawn.Weapon).FlagHasComboInputBeforeBlendingStart = bIsTherePendingFire;
            }
            else if (WeaponForAliceMelee(MyAlicePawn.InvManager.PendingWeapon) != none)
            {
                WeaponForAlice(MyAlicePawn.InvManager.PendingWeapon).FlagHasComboInputBeforeBlendingStart = bIsTherePendingFire;
            }
        }
        WeaponForAliceMelee(MyAlicePawn.Weapon).UpdateMeleeComboInputState();
        return;
    }
    if (HobbyHorse(MyAlicePawn.Weapon) == none)
    {
        ChangeWeaponToHobbyHorse();
    }
    else
    {
        MeleeFire();
    }
}

function ChangeWeaponToHobbyHorse()
{
    if (CanChangeWeapon(MyAlicePawn.Weapon))
    {
        ClientSetWeapon(class'HobbyHorse');
    }
}

exec function VorpalBladeFireRelease()
{
    if (EyeStaff(MyAlicePawn.Weapon) != none && !EyeStaff(MyAlicePawn.Weapon).bReleasedFireButton)
    {
        return;
    }
    if (!CanFire())
    {
        return;
    }
    if (AlicePlayerInput(PlayerInput).bDisableInputInCinematic)
    {
        return;
    }
    if (VorpalBlade(Pawn.Weapon) != none)
    {
        VorpalBlade(Pawn.Weapon).ReleaseFireButton();
    }
}

exec function SwitchToEyeStaff()
{
    bSwitchWeaponOnly = true;
    ChangeWeaponToEyeStaff();
    MyAlicePawn.FadeInWeapon();
}

exec function SwitchToTeapotCannon()
{
    local int CurWeaponType;
    
    if (!IsTeapotCannonAvailable())
    {
        return;
    }
    CurWeaponType = MyAlicePawn.GetCurrentWeaponType();
    if (MyAlicePawn.IsTimerActive('FadeInWeapon'))
    {
        return;
    }
    MyAlicePawn.DiscardWatch();
    if (CurWeaponType != 3 && CurWeaponType != 4)
    {
        SetPendingWeaponToTeapotCannon();
    }
    else
    {
        SetPendingWeaponToTeapotCannon();
        PlaySound(Sound_PGTOTC);
    }
}

exec function SwitchToHobbyHorse()
{
    bSwitchWeaponOnly = true;
    nLastMeleeWeapon = 1;
    ClientSetWeapon(class'HobbyHorse');
    MyAlicePawn.FadeInWeapon();
}

exec function SwitchToVorpalBlade()
{
    bSwitchWeaponOnly = true;
    nLastMeleeWeapon = 0;
    ClientSetWeapon(class'VorpalBlade');
    MyAlicePawn.FadeInWeapon();
}

exec function SwitchMeleeWeapon()
{
    if (WeaponForAliceMelee(MyAlicePawn.Weapon) == none)
    {
        return;
    }
    if (bCanSwitchMelee)
    {
        if (VorpalBlade(MyAlicePawn.Weapon) != none)
        {
            SwitchToHobbyHorse();
        }
        else
        {
            SwitchToVorpalBlade();
        }
        SetTimer(1.0, false, 'SetCanSwitchMelee');
        bCanSwitchMelee = false;
    }
}

function SetCanSwitchMelee()
{
    bCanSwitchMelee = true;
}

exec function VorpalBladeFirePress()
{
    local bool bIsTherePendingFire;
    
    if (bLookingAtPointOfInterest)
    {
        return;
    }
    if (bPickupAction)
    {
        bPickupAction = false;
        return;
    }
    if (MyAlicePawn.IsReadyToCollectBlockPiece())
    {
        return;
    }
    MyAlicePawn.DiscardWatch();
    if (!CanFire())
    {
        bIsTherePendingFire = WeaponForAlice(MyAlicePawn.Weapon).FlagHasComboInputBeforeBlendingStart;
        if (VorpalBlade(MyAlicePawn.Weapon) == none)
        {
            ChangeWeaponToVorpalBlade();
        }
        if (bIsTherePendingFire)
        {
            if (WeaponForAliceMelee(MyAlicePawn.Weapon) != none)
            {
                WeaponForAlice(MyAlicePawn.Weapon).FlagHasComboInputBeforeBlendingStart = bIsTherePendingFire;
            }
            else if (WeaponForAliceMelee(MyAlicePawn.InvManager.PendingWeapon) != none)
            {
                WeaponForAlice(MyAlicePawn.InvManager.PendingWeapon).FlagHasComboInputBeforeBlendingStart = bIsTherePendingFire;
            }
        }
        WeaponForAliceMelee(MyAlicePawn.Weapon).UpdateMeleeComboInputState();
        return;
    }
    if (VorpalBlade(MyAlicePawn.Weapon) == none)
    {
        ChangeWeaponToVorpalBlade();
    }
    else
    {
        MeleeFire();
    }
}

function ChangeWeaponToVorpalBlade()
{
    if (CanChangeWeapon(MyAlicePawn.Weapon))
    {
        ClientSetWeapon(class'VorpalBlade');
    }
}

function bool CanChangeWeapon(Weapon CurrentWeapon)
{
    if (bShrinkingModeActive || bTargetingModeActive && MyAlicePawn.CurrentContextActor != none)
    {
        return false;
    }
    if (IsDoingSpecialMove(43) || MyAlicePawn.IsShieldBlocking() || IsDoingSpecialMove(47) || IsDoingSpecialMove(34) || MyAlicePawn.IsDoingSpecialMove(52))
    {
        return false;
    }
    if (CurrentWeapon == none)
    {
        return true;
    }
    return WeaponForAlice(CurrentWeapon).AllowSwitchOtherWeapon();
}

simulated function ResetInputFlags()
{
    FlagComboInputAcceptStart = false;
    FlagComboInputAcceptFinish = false;
    FlagHasComboInputBeforeBlendingStart = false;
    FlagComboBlendingStart = false;
    CombatInputBeforeBlendingStart = 0;
}

function bool UpdateComboInputState(EAliceCombatAbilityInput curInput)
{
    if (FlagComboInputAcceptStart == false || FlagComboInputAcceptFinish == true)
    {
        return false;
    }
    if (FlagComboBlendingStart == false)
    {
        FlagHasComboInputBeforeBlendingStart = true;
        CombatInputBeforeBlendingStart = curInput;
        return false;
    }
    return true;
}

simulated function ComboInputAcceptFinish()
{
    FlagComboInputAcceptFinish = true;
    FlagComboInputAcceptStart = false;
}

simulated function ComboInputAcceptStart()
{
    FlagComboInputAcceptStart = true;
    FlagComboInputAcceptFinish = false;
}

simulated function NotifyComboBlendingStart()
{
    local WeaponForAliceMelee Wpn;
    
    Wpn = WeaponForAliceMelee(MyAlicePawn.Weapon);
    FlagComboBlendingStart = true;
    if (FlagHasComboInputBeforeBlendingStart)
    {
        if (Wpn != none && CombatInputBeforeBlendingStart > 4 && CombatInputBeforeBlendingStart < 9)
        {
            StartFire(Wpn.CurrentFireMode);
            Wpn.ReSetAllFlag();
        }
        else if (CombatInputBeforeBlendingStart == 1)
        {
            DoDodge(PendingDodge);
        }
        ResetInputFlags();
    }
}

function RemoveAliceWeapon(class<WeaponForAlice> WeaponClass)
{
    local Inventory OldWeapon;
    
    OldWeapon = AliceInventoryManager(MyAlicePawn.InvManager).HasInventoryOfClass(WeaponClass);
    if (WeaponForAlice(OldWeapon) != none)
    {
        MyAlicePawn.InvManager.RemoveFromInventory(OldWeapon);
    }
}

function AddNewAliceWeapon(class<WeaponForAlice> WeaponClass, int LevelID)
{
    local Weapon NewWeapon;
    local WeaponPara tempweaponpara;
    local Inventory OldWeapon;
    local AliceGameWeaponBase tempWeaponBase;
    
    OldWeapon = AliceInventoryManager(MyAlicePawn.InvManager).HasInventoryOfClass(WeaponClass);
    if (WeaponForAlice(OldWeapon) != none)
    {
        WeaponForAlice(OldWeapon).ChangeLevel(LevelID);
        return;
    }
    foreach MyAlicePawn.WeaponParas(tempweaponpara)
    {
        if (tempweaponpara.WeaponClass == WeaponClass)
        {
            NewWeapon = Spawn(tempweaponpara.WeaponClass, self, , , , tempweaponpara.WeaponArcheType);
            tempweaponpara.bAvailable = true;
            MyAlicePawn.InvManager.AddInventory(NewWeapon, true);
            tempWeaponBase = AliceGameWeaponBase(NewWeapon);
            if (tempWeaponBase != none)
            {
                MyAlicePawn.SetWeaponParaInfo(tempWeaponBase, tempweaponpara);
                tempWeaponBase.CacheAnimNodes();
            }
            tempWeaponBase.WeaponMeleeRange = tempweaponpara.WeaponMeleeRange;
            MyAlicePawn.PickedUpNewWeapon(WeaponClass);
            WeaponForAlice(NewWeapon).ChangeLevel(LevelID);
        }
    }
}

exec function AW(optional int WeaponID = 0, optional int LevelID = 1)
{
    local class<WeaponForAlice> WClass;
    
    if (LevelID < 1 || LevelID > 10)
    {
        LevelID = 1;
        return;
    }
    AliceCheatManager(CheatManager).bEnableAllWeaponsSelect = true;
    switch (WeaponID)
    {
        case 1:
            WClass = class'VorpalBlade';
            break;
        case 2:
            WClass = class'TeapotCannon';
            break;
        case 3:
            WClass = class'EyeStaff';
            break;
        case 4:
            WClass = class'HobbyHorse';
            break;
        case 5:
            break;
        default:
            return;
    }
    if (WeaponID == 5)
    {
        AddNewAliceWeapon(class'VorpalBlade', LevelID);
        AddNewAliceWeapon(class'TeapotCannon', LevelID);
        AddNewAliceWeapon(class'EyeStaff', LevelID);
        AddNewAliceWeapon(class'HobbyHorse', LevelID);
    }
    else
    {
        AddNewAliceWeapon(WClass, LevelID);
        ChangeWeaponTo(WClass);
    }
    FlushWeaponLevelRealTime();
    if (MyAlicePawn.Weapon != none)
    {
        MyAlicePawn.Weapon.ChangeLevel(WeaponForAlice(MyAlicePawn.Weapon).WeaponLevel);
    }
}

function bool CanPressRestartGame()
{
    if (!AliceGameInfo(WorldInfo.Game).HaveLastCheckpointFile())
    {
        return false;
    }
    if (AlicePlayerInput(PlayerInput).bDisableInputInCinematic)
    {
        return false;
    }
    return true;
}

function int GetEyeStaffLevel()
{
    return WeaponLevel[3];
}

function bool IsEyeStaffFinded()
{
    return WeaponLevel[3] > 0;
}

function int GetTeaPotLevel()
{
    return WeaponLevel[2];
}

function bool IsTeaPotFinded()
{
    return WeaponLevel[2] > 0;
}

function int GetHobbyHorseLevel()
{
    return WeaponLevel[1];
}

function bool IsHobbyHorseFinded()
{
    return WeaponLevel[1] > 0;
}

function int GetVorpalBladeLevel()
{
    return WeaponLevel[0];
}

function bool IsVorpalBladeFinded()
{
    return WeaponLevel[0] > 0;
}

function int GetCurrentWeaponLevel()
{
    local WeaponForAlice Wpn;
    
    Wpn = WeaponForAlice(MyAlicePawn.Weapon);
    if (Wpn != none)
    {
        return Wpn.SaveWeaponLevel;
    }
    return -1;
}

function ChangeWeaponTo(class<WeaponForAlice> WeaponClass)
{
    switch (WeaponClass)
    {
        case class'VorpalBlade':
            ChangeWeaponToVorpalBlade();
            break;
        case class'TeapotCannon':
            ChangeWeaponToTeapotCannon();
            break;
        case class'HobbyHorse':
            ChangeWeaponToHobbyHorse();
            break;
        case class'EyeStaff':
            ChangeWeaponToEyeStaff();
            break;
        default:
    }
}

function UpgradeWeapon(class<WeaponForAlice> WeaponClass, int newLevel)
{
    local Inventory TargetWeapon;
    
    TargetWeapon = AliceInventoryManager(MyAlicePawn.InvManager).HasInventoryOfClass(WeaponClass);
    if (WeaponForAlice(TargetWeapon) != none)
    {
        WeaponForAlice(TargetWeapon).ChangeLevel(newLevel);
        FlushWeaponLevelRealTime();
        if (WorldInfo.GetMapName() != "AliceEntry")
        {
            ConsoleCommand("trophy unlock=" @ string(17));
            if (newLevel == 4)
            {
                ConsoleCommand("trophy unlock=" @ string(18));
            }
            if (WeaponLevel[0] == 4 && WeaponLevel[1] == 4 && WeaponLevel[2] == 4 && WeaponLevel[3] == 4)
            {
                ConsoleCommand("trophy unlock=" @ string(19));
            }
        }
        return;
    }
}

exec function DisableAllDLCWeapons()
{
    AliceGameInfo(WorldInfo.Game).SetIsDLC_VB_UnLock(false);
    AliceGameInfo(WorldInfo.Game).SetIsDLC_HH_UnLock(false);
    AliceGameInfo(WorldInfo.Game).SetIsDLC_TC_UnLock(false);
    AliceGameInfo(WorldInfo.Game).SetIsDLC_ES_UnLock(false);
    AliceGameInfo(WorldInfo.Game).SetIsDLC_VB_Enable(false);
    AliceGameInfo(WorldInfo.Game).SetIsDLC_HH_Enable(false);
    AliceGameInfo(WorldInfo.Game).SetIsDLC_TC_Enable(false);
    AliceGameInfo(WorldInfo.Game).SetIsDLC_ES_Enable(false);
    UpgradeWeapon(class'VorpalBlade', GetVorpalBladeLevel());
    UpgradeWeapon(class'TeapotCannon', GetTeaPotLevel());
    UpgradeWeapon(class'EyeStaff', GetEyeStaffLevel());
    UpgradeWeapon(class'HobbyHorse', GetHobbyHorseLevel());
}

exec function EnableAllDLCWeapons()
{
    AliceGameInfo(WorldInfo.Game).SetIsDLC_VB_UnLock(true);
    AliceGameInfo(WorldInfo.Game).SetIsDLC_HH_UnLock(true);
    AliceGameInfo(WorldInfo.Game).SetIsDLC_TC_UnLock(true);
    AliceGameInfo(WorldInfo.Game).SetIsDLC_ES_UnLock(true);
    AliceGameInfo(WorldInfo.Game).SetIsDLC_VB_Enable(true);
    AliceGameInfo(WorldInfo.Game).SetIsDLC_HH_Enable(true);
    AliceGameInfo(WorldInfo.Game).SetIsDLC_TC_Enable(true);
    AliceGameInfo(WorldInfo.Game).SetIsDLC_ES_Enable(true);
    UpgradeWeapon(class'VorpalBlade', GetVorpalBladeLevel());
    UpgradeWeapon(class'TeapotCannon', GetTeaPotLevel());
    UpgradeWeapon(class'EyeStaff', GetEyeStaffLevel());
    UpgradeWeapon(class'HobbyHorse', GetHobbyHorseLevel());
}

function bool CanSwitchRangeWeapon()
{
    if (!AlicePawn(Pawn).bCanCombat)
    {
        return false;
    }
    if (AlicePlayerInput(PlayerInput).bDisableInputInCinematic || MyAlicePawn.bIsDoingContextAction || MyAlicePawn.CurrentContextActor != none && PressurePad(MyAlicePawn.Base) == none || bShrinkingModeActive)
    {
        return false;
    }
    if (MyAlicePawn.bInJumpPad || MyAlicePawn.Physics == 2 || MyAlicePawn.IsDoingSpecialMove(3) || MyAlicePawn.IsDoingSpecialMove(4) || MyAlicePawn.IsDoingSpecialMove(49) || MyAlicePawn.IsDoingSpecialMove(50) || MyAlicePawn.IsDoingSpecialMove(52) || MyAlicePawn.bIsTurning || AlicePawn(Pawn).isInConversationMode())
    {
        return false;
    }
    if (!IsInState('PlayerWalking') && !IsInState('PlayerLockOnTarget') && !IsInState('FirstPersonView'))
    {
        return false;
    }
    if (IsDoingSpecialMove(39) || IsDoingSpecialMove(40) || IsDoingSpecialMove(43) || IsDoingSpecialMove(44) || IsDoingSpecialMove(36) || MyAlicePawn.IsShieldBlocking() || IsDoingSpecialMove(47) || IsDoingSpecialMove(34) || MyAlicePawn.bInShield)
    {
        return false;
    }
    if (IsDodging() || IsDoingSpecialMove(41) || IsDoingSpecialMove(42) || IsDoingSpecialMove(43) || MyAlicePawn.IsDoingNonLockMeleeAttackSpecialMove())
    {
        return false;
    }
    return true;
}

simulated function bool CanFire()
{
    local WeaponForAlice Wpn;
    
    Wpn = WeaponForAlice(MyAlicePawn.Weapon);
    if (!AlicePawn(Pawn).bCanCombat)
    {
        return false;
    }
    if (AlicePlayerInput(PlayerInput).bDisableInputInCinematic || MyAlicePawn.bIsDoingContextAction || bShrinkingModeActive || MyAlicePawn.CurrentContextActor != none && MyAlicePawn.CurrentContextActor.MaxTriggerTimers != 0 && PressurePad(MyAlicePawn.Base) == none && !MyAlicePawn.bInGiantMode)
    {
        return false;
    }
    if (MyAlicePawn.bInJumpPad || MyAlicePawn.Physics == 2 || MyAlicePawn.IsDoingSpecialMove(3) || MyAlicePawn.IsDoingSpecialMove(4) || MyAlicePawn.IsDoingSpecialMove(49) || MyAlicePawn.IsDoingSpecialMove(50) || MyAlicePawn.IsDoingSpecialMove(52) || MyAlicePawn.bIsTurning || AlicePawn(Pawn).isInConversationMode())
    {
        return false;
    }
    if (!IsInState('PlayerWalking') && !IsInState('PlayerLockOnTarget') && !IsInState('FirstPersonView'))
    {
        return false;
    }
    if (IsDoingSpecialMove(39) || IsDoingSpecialMove(40) || IsDoingSpecialMove(43) || IsDoingSpecialMove(44) || IsDoingSpecialMove(36) || MyAlicePawn.IsShieldBlocking() || IsDoingSpecialMove(47) || IsDoingSpecialMove(34) || MyAlicePawn.bInShield)
    {
        return false;
    }
    if (IsDodging() || IsDoingSpecialMove(41) || IsDoingSpecialMove(42) || IsDoingSpecialMove(43) || MyAlicePawn.IsDoingNonLockMeleeAttackSpecialMove())
    {
        if (Wpn != none && Wpn.CanPerformNextAction())
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    return true;
}

function bool isContextActorPressurePad()
{
    if (MyAlicePawn.CurrentContextActor != none && PressurePad(MyAlicePawn.Base) != none)
    {
        return true;
    }
    return false;
}

function bool IsAllowChangeWeapon()
{
    if (!AlicePawn(Pawn).bCanCombat || AlicePawn(Pawn).bMorphing || AlicePawn(Pawn).bInJumpPad || MyAlicePawn.bInGiantMode || bShrinkingModeActive)
    {
        return false;
    }
    if (AlicePlayerInput(PlayerInput).bDisableInputInCinematic)
    {
        return false;
    }
    if (IsInState('PlayerWalking') && !AlicePawn(Pawn).isInConversationMode() && Pawn.Physics == 1)
    {
        return true;
    }
    else
    {
        return false;
    }
}

function NotifyChangedWeapon(Weapon PreviousWeapon, Weapon NewWeapon)
{
    AliceGameInfo(WorldInfo.Game).NotifyChangedWeapon(PreviousWeapon, NewWeapon);
    if (TeapotCannon(MyAlicePawn.Weapon) != none)
    {
        TeapotCannon(MyAlicePawn.Weapon).PlayChangeWeaponSound();
    }
}

event AlicePlayer_MovementStateBase GetCurrentMovementState()
{
    if (PlayerMovementStates.Length > 0)
    {
        return PlayerMovementStates[curIndexOfPlayerMovementState];
    }
    else
    {
        return none;
    }
}

function StopCurrentMovementState()
{
    if (PlayerMovementStates.Length == 0 || curIndexOfPlayerMovementState >= PlayerMovementStates.Length)
    {
        return;
    }
    PlayerMovementStates[curIndexOfPlayerMovementState].GotoState('None');
}

function SwitchToMovementState(int NewState)
{
    if (PlayerMovementStates.Length == 0 || NewState >= PlayerMovementStates.Length)
    {
        return;
    }
    PlayerMovementStates[curIndexOfPlayerMovementState].GotoState('None');
    curIndexOfPlayerMovementState = NewState;
    PlayerMovementStates[curIndexOfPlayerMovementState].GotoState('Idle');
    PlayerMovementStates[curIndexOfPlayerMovementState].SetPlayerBasicMovementState(0);
}

function InitPlayerMovementStates()
{
    local int Index;
    local AlicePlayer_MovementStateBase mState;
    
    if (PlayerMovementStates.Length == 0)
    {
        for (Index = 0; Index < PlayerMovementStatesClasses.Length; Index++)
        {
            assert(PlayerMovementStatesClasses[Index] != none);
            mState = AlicePlayer_MovementStateBase(new(self) PlayerMovementStatesClasses[Index]);
            if (mState != none)
            {
                mState.Controller = self;
                mState.Input = AlicePlayerInput(PlayerInput);
                mState.Pawn = AlicePawn(Pawn);
                PlayerMovementStates.AddItem(mState);
                continue;
            }
        }
    }
}

function traceTest()
{
    local Vector Start, End, HitLocation, HitNormal;
    local Actor Wall;
    
    Start = MyAlicePawn.Location;
    End = Start + Normal(vector(MyAlicePawn.Rotation)) * float(200);
    foreach TraceActors(class'Engine.Actor', Wall, HitLocation, HitNormal, End, Start)
    {
        if (Wall != none && shouldAliceCollide(Wall))
        {
            Wall = Wall;
        }
    }
}

event PlayerTick(float DeltaTime)
{
    local LocalPlayer LP;
    local AliceGameCrowdAgent CrowdAgent;
    local int CrowdNum;
    local float factor;
    
    PlayerTick(DeltaTime);
    UpdatePresence();
    CalcAliceIdleDuration(DeltaTime);
    MyAlicePawn.CheckHysteriaMode(DeltaTime);
    if (SecondPlayerInput != none)
    {
        SecondPlayerInput.PlayerInput(DeltaTime);
        GameFreeCamera(AlicePlayerCamera(PlayerCamera).FreeCam).ControllerIndex = (bSupportSecondController == true ? 1 : 0);
    }
    if (bPressedBackButton)
    {
        fBackButtonHoldTime += DeltaTime;
        if (fBackButtonHoldTime > 1.0)
        {
            bPressedBackButton = false;
            fBackButtonHoldTime = 0.0;
            ServerAbortConversation();
        }
    }
    CombatInputManager.Update();
    if (!MyAlicePawn.bEnableTargetOnDestroyedActor)
    {
        if (TargetNPCSocket.Pawn != none && TargetNPCSocket.Pawn.Health <= 0 || !TargetNPCSocket.Pawn.AnyLockableSocketaEnable())
        {
            TargetNPCSocket.Pawn = none;
        }
    }
    if (bLookingAtPointOfInterest && CameraLookAtFocusActor == none)
    {
        StopForceLookAtPointOfInterest(false);
    }
    if (WorldInfo.Game != none && AliceGameInfo(WorldInfo.Game).GameplayEventsWriter != none && AliceGameInfo(WorldInfo.Game).GameplayEventsWriter.CurrentSessionInfo.bGameplaySessionInProgress)
    {
        AliceGameplayEventsWriter(AliceGameInfo(WorldInfo.Game).GameplayEventsWriter).LogPlayerSpawnEvent(102, self, MyAlicePawn.Class, 0);
    }
    CheckEnabledPointsOfInterest(DeltaTime);
    LP = LocalPlayer(Player);
    if (LP != none && LockOnEffect == none && MyAlicePawn.PostProcessEffectCombatTargeting != 'None')
    {
        LockOnEffect = LP.PlayerPostProcess.FindPostProcessEffect(MyAlicePawn.PostProcessEffectCombatTargeting);
        if (LockOnEffect != none)
        {
            LockOnEffect.bShowInGame = false;
        }
    }
    UpdateCrossHair();
    if (bTryUnShrinkNow && !IsDoingSpecialMove(52))
    {
        UnShrinking();
    }
    DetectCameraMagnets(DeltaTime);
    if (MyAlicePawn != none && MyAlicePawn.bCanCombat && bTargetingModeActive)
    {
        if (!TMode_CombatLockOn.IsActivated())
        {
            TMode_CombatLockOn.Toggle(true);
        }
        if (!TMode_BreakableActor.IsActivated())
        {
            TMode_BreakableActor.Toggle(true);
        }
        if (!TMode_SkeletalMeshActor.IsActivated())
        {
            TMode_SkeletalMeshActor.Toggle(true);
        }
        if (bTargetingModeActive)
        {
            UpdateTargetingModes(DeltaTime);
        }
    }
    if (!bTargetingModeActive && !bFirstPersonViewActive)
    {
        TMode_CombatLockOn.Activated();
        TMode_BreakableActor.Activated();
        TMode_SkeletalMeshActor.Activated();
        UpdatePreTargetingModes(DeltaTime);
    }
    if (MyAlicePawn.bInGiantMode)
    {
        CrowdNum = 0;
        foreach VisibleActors(class'AliceGameCrowdAgent', CrowdAgent, 150.0, MyAlicePawn.Location)
        {
            if (CrowdAgent.Health > 0 && CrowdAgent.bAttacking)
            {
                CrowdNum++;
            }
        }
        GiantAliceTakeDamageCount += CrowdNum;
        if (GiantAliceTakeDamageCount > 1000)
        {
            GiantAliceTakeDamageCount = 0;
            MyAlicePawn.TakeDamage(AgentDamage, self, MyAlicePawn.Location, vector(MyAlicePawn.Rotation), class'Engine.DamageType');
        }
        if (MyAlicePawn.IsDoingSpecialMove(18) || MyAlicePawn.IsDoingSpecialMove(13))
        {
            MyAlicePawn.AnimSlowFactor = 1.0;
            MyAlicePawn.Mesh.GlobalAnimRateScale = 1.0;
        }
        else
        {
            factor = 1.0 - FClamp(float(CrowdNum) * 0.03 * float(SlowFactor), 0.0, 0.7);
            MyAlicePawn.AnimSlowFactor = FClamp(factor, 0.75, 1.0);
        }
        if (VSize(AlicePlayerInput(PlayerInput).InputVector) > float(0))
        {
            MyAlicePawn.Velocity = Normal(MyAlicePawn.Velocity) * MyAlicePawn.GroundSpeed * factor;
        }
    }
    if (AliceCheatManager(CheatManager) != none)
    {
        AliceCheatManager(CheatManager).Update();
    }
    if (AlicePawn(Pawn).bWantToLeaveSwim)
    {
        AlicePawn(Pawn).LeaveSwimStateTime += DeltaTime;
        if (AlicePawn(Pawn).LeaveSwimStateTime > 1.0)
        {
            AlicePawn(Pawn).bWantToLeaveSwim = false;
        }
    }
    if (bPendingShrinkRequest && !MyAlicePawn.IsDoingASpecialMove())
    {
        ChangeShrinkingMode();
    }
    if (bPendingQuitLockOnMode && !MyAlicePawn.bDoingTeapotCannonFireSpecialMove)
    {
        bPendingQuitLockOnMode = false;
        ChangeCameraMode(false);
    }
    if (bPendingQuitAimingMode && !MyAlicePawn.IsDoingSpecialMove(26) && !MyAlicePawn.bDoingTeapotCannonFireSpecialMove)
    {
        bPendingQuitAimingMode = false;
        QuitFPS();
    }
    if (SoundModeManager != none)
    {
        SoundModeManager.Update();
    }
    GeneratingBinkVideos(DeltaTime);
    if (MyAlicePawn.Physics == 0 && MyAlicePawn.Base.IsA('InterpActor'))
    {
        MyAlicePawn.SetBase(none);
    }
}

event UpdateCrossHair()
{
    local Vector ViewLocation, cameraLoc;
    local Rotator ViewRotation, cameraRot;
    local Vector TraceCrossHairLocation;
    
    if (Pawn != none && bFirstPersonViewActive && !MyAlicePawn.bInLondon)
    {
        AlicePlayerCamera(PlayerCamera).GetCameraViewPoint(cameraLoc, cameraRot);
        ViewLocation = cameraLoc;
        ViewRotation = cameraRot;
        TraceCrossHairLocation = ViewLocation + vector(ViewRotation) * MyAlicePawn.Weapon.GetTraceRange();
        DoCrossHairLineCheck(ViewLocation, TraceCrossHairLocation);
        UpdateCrossHairPosition();
    }
}

function TriggerIdleEffects()
{
    if (IsOnAliceQuitIdle())
    {
        MyAlicePawn.AliceForceStopCameraAnim(MyAlicePawn.IdleCameraTimeOutAnim);
    }
    else if (IsOnAliceIdleTimeOut(MyAlicePawn.IdleCameraTimeOutDuration))
    {
        MyAlicePawn.AliceForcePlayCameraAnim(MyAlicePawn.IdleCameraTimeOutAnim, true);
    }
}

function bool IsOnAliceQuitIdle()
{
    return fOldAliceIdleDuration > fAliceIdleDuration;
}

function bool IsOnAliceIdleTimeOut(float fDuration)
{
    return fAliceIdleDuration >= fDuration && fOldAliceIdleDuration < fDuration;
}

function CalcAliceIdleDuration(float DeltaTime)
{
    local AlicePlayerInput APlayerInput;
    
    APlayerInput = AlicePlayerInput(PlayerInput);
    if (APlayerInput.IsInputFree() && !IsDoingASpecialMove())
    {
        fAliceIdleDuration += DeltaTime;
    }
    else
    {
        fAliceIdleDuration = 0.0;
    }
    TriggerIdleEffects();
    fOldAliceIdleDuration = fAliceIdleDuration;
}

function UpdatePresence()
{
    local array<LocalizedStringSetting> StringSettingList;
    local array<SettingsProperty> PropertyList;
    local int PresenceNeeded, ControllerId;
    local bool IsXenon;
    
    if (true)
    {
        IsXenon = WorldInfo.IsConsoleBuild(1);
        OnlineSub = class'Engine.GameEngine'.static.GetOnlineSubsystem();
        if (!IsXenon || OnlineSub != none)
        {
            for (ControllerId = 0; ControllerId < 4; ControllerId++)
            {
                if (!IsXenon || OnlineSub.PlayerInterface.GetLoginStatus(byte(ControllerId)) != 0)
                {
                    PresenceNeeded = GetPresenceID_Idle();
                    if (getAliceGameEngine().CurrentUserID == ControllerId)
                    {
                        if (WorldInfo.GetMapName() == "AliceEntry" || WorldInfo.GetMapName() == "AliceEntryExtra" || WorldInfo.GetMapName() == "AliceEntryManual")
                        {
                            PresenceNeeded = GetPresenceID_Menu();
                        }
                        else
                        {
                            PresenceNeeded = GetPresenceID_Playing();
                        }
                    }
                    if (PresenceNeeded != LastPresenceSet[ControllerId])
                    {
                        if (IsXenon)
                        {
                            OnlineSub.PlayerInterface.SetOnlineStatus(byte(ControllerId), PresenceNeeded, StringSettingList, PropertyList);
                        }
                        LogInternal("Player " $ string(ControllerId) $ " presence set to " $ string(PresenceNeeded));
                        LastPresenceSet[ControllerId] = PresenceNeeded;
                    }
                    continue;
                }
                LastPresenceSet[ControllerId] = -1;
            }
        }
    }
}

native function int GetPresenceID_Playing()
{
}

native function int GetPresenceID_Menu()
{
}

native function int GetPresenceID_Idle()
{
}

function bool SetPause(bool bPause, optional delegate<CanUnpause> CanUnpauseDelegate = CanUnpause)
{
    local bool bReturn;
    
    bReturn = SetPause(bPause, CanUnpauseDelegate);
    UpdatePresence();
    return bReturn;
}

exec function BugItForGameController(optional string ScreenShotDescription)
{
    if (AlicePlayerInput(PlayerInput).IsKeyPressed('XboxTypeS_LeftTrigger'))
    {
        if (ScreenShotDescription != "")
        {
            BugIt(ScreenShotDescription);
        }
        else
        {
            BugIt();
        }
    }
}

event CloneAlice(name SockectName, float InitSpeed)
{
    local Vector SpawnLocation;
    local Rotator SpawnRotator;
    local Vector AliceDir, HitLocation, HitNormal, Start, End, extend;
    
    if (MyAlicePawn.MyClonePawn != none)
    {
        return;
    }
    MyAlicePawn.Mesh.GetSocketWorldLocationAndRotation(SockectName, SpawnLocation, SpawnRotator);
    AliceDir = vector(MyAlicePawn.Rotation);
    AliceDir.Z = 0.0;
    Start = SpawnLocation - AliceDir * float(50);
    End = SpawnLocation + AliceDir * float(50);
    extend = vect(1.0, 1.0, 1.0);
    if (MyAlicePawn.Trace(HitLocation, HitNormal, End, Start, false, extend) != none)
    {
        SpawnLocation = HitLocation + HitNormal * float(40);
    }
    if (MyAlicePawn != none)
    {
        if (MyAlicePawn.MyClonePawn != none)
        {
            AliceClonePawn(MyAlicePawn.MyClonePawn).AnnounceDie();
        }
        MyAlicePawn.MyClonePawn = Spawn(class'AliceClonePawn', self, , SpawnLocation, MyAlicePawn.Rotation, MyAlicePawn.CloneArcheType, true);
        if (MyAlicePawn.MyClonePawn != none)
        {
            StartHoldClockBomb();
        }
        if (MyAlicePawn.CurrentContextActor.IsA('ClockBombContextActor'))
        {
            AliceClonePawn(MyAlicePawn.MyClonePawn).BombType = 1;
            AliceClonePawn(MyAlicePawn.MyClonePawn).SetupStart();
        }
        AliceClonePawn(MyAlicePawn.MyClonePawn).InitSocketRotator = SpawnRotator;
        AliceClonePawn(MyAlicePawn.MyClonePawn).InitSpeed = InitSpeed;
        if (bPauseTickForNextClockBomb)
        {
            bPauseTickForNextClockBomb = false;
            AliceClonePawn(MyAlicePawn.MyClonePawn).bShouldPause = true;
        }
        MyAlicePawn.TriggerContextEventClass(18, 0);
    }
}

exec function LowerSalary(optional int subvalue = 10000)
{
    MyAlicePawn.XPValue -= subvalue;
}

exec function RaiseSalary(optional int addvalue = 10000)
{
    MyAlicePawn.XPValue += addvalue;
}

exec function StatUnitAndStatFPS()
{
    ConsoleCommand("Stat Unit");
    ConsoleCommand("Stat FPS");
}

function bool IsCheshireCatCanAppear()
{
    if (MyAlicePawn.bInLondon)
    {
        return false;
    }
    if (MyAlicePawn.IsPawnInAStance(1))
    {
        return false;
    }
    if (AlicePlayerInput(PlayerInput).bDisableInputInCinematic)
    {
        return false;
    }
    if (MyAlicePawn.Physics != 1)
    {
        return false;
    }
    if (TargetingActor != none || PreTargetingActor != none)
    {
        return false;
    }
    return true;
}

function DetectCameraMagnets(float DeltaTime)
{
    local int I, J;
    local bool bPassed;
    local Plane MagnetScreenPos;
    local Vector Magnet2D;
    local float fDistance;
    local AliceCameraMagnet Candidate, Magnet;
    
    if (MyAlicePawn == none)
    {
        return;
    }
    if (WorldInfo.bOnLevelsProperlyLoaded)
    {
        GetCameraMagnets();
    }
    Candidate = none;
    for (I = 0; I < CameraMagnets.Length; I++)
    {
        Magnet = CameraMagnets[I];
        if (Magnet == none)
        {
            CameraMagnets.Remove(I, 1);
            I--;
            continue;
        }
        if (!Magnet.bEnabled)
        {
            continue;
        }
        if (Magnet.MaxTriggerCount < 0)
        {
            continue;
        }
        fDistance = VSize(MyAlicePawn.Location - Magnet.Location);
        if (!(fDistance < Magnet.AttractionRange && fDistance > Magnet.DisableRange))
        {
            continue;
        }
        if (Magnet.bEnableOnSight)
        {
            if (!AlicePlayerCamera(PlayerCamera).CanSeeEx(Magnet.Location, 1.0, true))
            {
                continue;
            }
        }
        if (Magnet.bUseDeadZone)
        {
            MagnetScreenPos = AlicePlayerCamera(PlayerCamera).Project(Magnet.Location);
            if (MagnetScreenPos.W > 0.0)
            {
                Magnet2D.X = MagnetScreenPos.X;
                Magnet2D.Y = MagnetScreenPos.Y;
                if (VSize2D(Magnet2D) < Magnet.DeadZoneRadius)
                {
                    continue;
                }
            }
        }
        bPassed = false;
        if (Magnet.ActivationContext.Length > 0)
        {
            for (J = 0; J < Magnet.ActivationContext.Length; J++)
            {
                if (Magnet.ActivationContext[J] == MyAlicePawn.Physics)
                {
                    bPassed = true;
                    break;
                }
            }
            if (!bPassed)
            {
                continue;
            }
        }
        if (Candidate == none)
        {
            Candidate = Magnet;
            continue;
        }
        if (Candidate.Priority < Magnet.Priority)
        {
            Candidate = Magnet;
        }
    }
    if (Candidate != none)
    {
        MyAlicePawn.SetCameraMagnet(Candidate);
    }
    MyAlicePawn.UpdateCameraMagnet(DeltaTime);
}

function GetCameraMagnets(optional bool bJustPostBeginPlay = false)
{
    local AliceCameraMagnet ACM;
    local bool bPawnCurMagnetExist;
    
    bPawnCurMagnetExist = false;
    CameraMagnets.Length = 0;
    foreach AllActors(class'AliceCameraMagnet', ACM)
    {
        if (ACM != none)
        {
            CameraMagnets.AddItem(ACM);
            if (!bPawnCurMagnetExist && MyAlicePawn != none)
            {
                bPawnCurMagnetExist = MyAlicePawn.IsCurCameraMagnet(ACM);
            }
        }
    }
    if (CheshireCatMagnet == none)
    {
        CheshireCatMagnet = Spawn(class'AliceCameraMagnet', self);
        CheshireCatMagnet.bEnabled = false;
        CheshireCatMagnet.bDisableOnLookAway = true;
        CheshireCatMagnet.AttractionRange = 10000.0;
        CheshireCatMagnet.MaxTriggerCount = 0;
        CheshireCatMagnet.Priority = 100;
        CameraMagnets.AddItem(CheshireCatMagnet);
    }
    else if (bJustPostBeginPlay)
    {
        CheshireCatMagnet.bEnabled = false;
        CameraMagnets.AddItem(CheshireCatMagnet);
    }
    if (!bPawnCurMagnetExist && MyAlicePawn != none)
    {
        bPawnCurMagnetExist = MyAlicePawn.IsCurCameraMagnet(CheshireCatMagnet);
    }
    if (ShowPathMagnet == none)
    {
        ShowPathMagnet = Spawn(class'AliceCameraMagnet', self);
        ShowPathMagnet.bEnabled = false;
        ShowPathMagnet.AttractionRange = 1000000.0;
        ShowPathMagnet.MaxTriggerCount = 0;
        ShowPathMagnet.Priority = 101;
        ShowPathMagnet.InterpolateSpeed = 180;
        ShowPathMagnet.EaseIn = 1.0;
        ShowPathMagnet.EaseOut = 1.0;
        ShowPathMagnet.TargetRadius = 0.0;
        CameraMagnets.AddItem(ShowPathMagnet);
    }
    else if (bJustPostBeginPlay)
    {
        ShowPathMagnet.bEnabled = false;
        CameraMagnets.AddItem(ShowPathMagnet);
    }
    if (!bPawnCurMagnetExist && MyAlicePawn != none)
    {
        bPawnCurMagnetExist = MyAlicePawn.IsCurCameraMagnet(ShowPathMagnet);
    }
    if (!bPawnCurMagnetExist && MyAlicePawn != none)
    {
        MyAlicePawn.SetCameraMagnet(none);
    }
}

function SetShowPathMagnet(Vector vLocation)
{
    if (ShowPathMagnet != none)
    {
        ShowPathMagnet.SetLocation(vLocation);
    }
}

function DisableShowPathMagnet()
{
    if (ShowPathMagnet != none)
    {
        ShowPathMagnet.bEnabled = false;
    }
}

function DisableCheshireCatMagnet()
{
    if (CheshireCatMagnet != none)
    {
        CheshireCatMagnet.bEnabled = false;
    }
}

exec function CheshireCatAppear()
{
    local CheshireCatSpawnPoint Cat, TheNearestCat;
    local float TheNearestDistance, CatToAliceDis;
    
    if (!MyAlicePawn.bCanShowCat || !bToggleCheshireCatOn)
    {
        return;
    }
    if (IsCheshireCatCanAppear())
    {
        foreach WorldInfo.AllActors(class'CheshireCatSpawnPoint', Cat)
        {
            CatToAliceDis = VSize(Cat.Location - Pawn.Location);
            if (TheNearestDistance > CatToAliceDis || TheNearestCat == none)
            {
                if (!Cat.bPlayHintsOver)
                {
                    TheNearestDistance = CatToAliceDis;
                    TheNearestCat = Cat;
                }
            }
        }
        if (TheNearestCat != none && !TheNearestCat.bUsed)
        {
            foreach WorldInfo.AllActors(class'CheshireCatSpawnPoint', Cat)
            {
                if (Cat != TheNearestCat)
                {
                    Cat.Disappear();
                }
            }
            TheNearestCat.OnPressHintButton();
            if (CheshireCatMagnet != none && TheNearestCat.bFocusCamera)
            {
                CheshireCatMagnet.SetLocation(TheNearestCat.Location + TheNearestCat.MagnetOffset);
                CheshireCatMagnet.InterpolateSpeed = TheNearestCat.InterpolateSpeed;
                CheshireCatMagnet.EaseIn = TheNearestCat.EaseIn;
                CheshireCatMagnet.EaseOut = TheNearestCat.EaseOut;
                CheshireCatMagnet.TargetRadius = TheNearestCat.TargetRadius;
                CheshireCatMagnet.bEnabled = true;
                CheshireCatMagnet.MaxTriggerCount = 0;
            }
        }
    }
}

function showCat(bool bShow)
{
    if (AliceGameInfo(WorldInfo.Game).GFxHUDMenu != none)
    {
        if (bShow)
        {
            AliceGameInfo(WorldInfo.Game).GFxHUDMenu.showCat(0.0, AliceGameInfo(WorldInfo.Game).GetLocalizeString("CAT_LOOK_GENERIC"));
        }
        else
        {
            AliceGameInfo(WorldInfo.Game).GFxHUDMenu.showCat(-1.0, AliceGameInfo(WorldInfo.Game).GetLocalizeString("CAT_LOOK_GENERIC"));
        }
    }
}

simulated event OnToggleCheshireCat(SeqAct_ToggleCheshireCat Action)
{
    local CheshireCatSpawnPoint Cat, TheNearestCat;
    local float TheNearestDistance, CatToAliceDis;
    
    if (Action.InputLinks[0].bHasImpulse)
    {
        bToggleCheshireCatOn = true;
    }
    else if (Action.InputLinks[1].bHasImpulse)
    {
        bToggleCheshireCatOn = false;
    }
    else if (Action.InputLinks[2].bHasImpulse)
    {
        bToggleCheshireCatOn = !bToggleCheshireCatOn;
    }
    if (bToggleCheshireCatOn)
    {
        foreach WorldInfo.AllActors(class'CheshireCatSpawnPoint', Cat)
        {
            CatToAliceDis = VSize(Cat.Location - Pawn.Location);
            if (TheNearestDistance > CatToAliceDis || TheNearestCat == none)
            {
                if (!Cat.bPlayHintsOver)
                {
                    TheNearestDistance = CatToAliceDis;
                    TheNearestCat = Cat;
                }
            }
        }
        if (TheNearestCat != none && !TheNearestCat.bUsed)
        {
            showCat(true);
        }
    }
    else
    {
        showCat(false);
    }
}

event InitInputSystem()
{
    InitInputSystem();
    AlicePlayerInput(PlayerInput).InitControlLayout();
    if (DoesAliceGameSupportSecondController())
    {
        if (SecondPlayerInput == none)
        {
            SecondPlayerInput = new(self) InputClass;
            if (AlicePlayerInput(SecondPlayerInput) != none)
            {
                AlicePlayerInput(SecondPlayerInput).bSecondController = true;
            }
        }
        if (Interactions.Find(SecondPlayerInput) == -1)
        {
            Interactions[Interactions.Length] = SecondPlayerInput;
        }
    }
}

event Possess(Pawn inPawn, bool bVehicleTransition)
{
    local OnlinePlayerInterface PlayerInterface;
    
    Possess(inPawn, bVehicleTransition);
    if (!WorldInfo.IsConsoleBuild(1) || AliceGameInfo(WorldInfo.Game).getAliceGameEngine().CurrentUserID != -1)
    {
        AliceGameInfo(WorldInfo.Game).InitLoadPersistentSaveData();
        if (WorldInfo.IsConsoleBuild(1))
        {
            OnlineSub = class'Engine.GameEngine'.static.GetOnlineSubsystem();
            if (OnlineSub != none)
            {
                PlayerInterface = OnlineSub.PlayerInterface;
                PlayerInterface.ClearLoginChangeDelegate(OnLoginChange);
                PlayerInterface.ClearDLCContentInstalledDelegate(OnDLCContentInstalled);
            }
            PlayerInterface.ClearLoginChangeDelegate(OnLoginChange);
            PlayerInterface.ClearDLCContentInstalledDelegate(OnDLCContentInstalled);
            PlayerInterface.AddLoginChangeDelegate(OnLoginChange);
            PlayerInterface.AddDLCContentInstalledDelegate(OnDLCContentInstalled);
        }
    }
}

function EnableARM()
{
    AliceCheatManager(CheatManager).arm();
}

function SetInMainMenu(bool DesiredInMainMenu)
{
    bInMainMenu = DesiredInMainMenu;
}

simulated event PostBeginPlay()
{
    PostBeginPlay();
    bTargetUIPrevCritical = false;
    if (ObjectiveMgr == none)
    {
        ObjectiveMgr = new(self) class'AliceObjectiveManager';
        ObjectiveMgr.Controller = self;
    }
    if (AliceGameInfo(WorldInfo.Game).GFxHUDMenu != none)
    {
        AliceGameInfo(WorldInfo.Game).GFxHUDMenu.Start();
        AliceGameInfo(WorldInfo.Game).GFxHUDMenu.SetFocus(false);
    }
    if (AliceGameInfo(WorldInfo.Game).inGameMenu != none)
    {
        AliceGameInfo(WorldInfo.Game).inGameMenu.Start();
        AliceGameInfo(WorldInfo.Game).inGameMenu.SetFocus(false);
    }
    if (CombatInputManager == none)
    {
        CombatInputManager = new(self) class'AliceCombatInputManager';
        if (CombatInputManager != none)
        {
            CombatInputManager.Controller = self;
            CombatInputManager.Input = AlicePlayerInput(PlayerInput);
            CombatInputManager.Pawn = AlicePawn(Pawn);
        }
    }
    if (CycleFloatManager == none)
    {
        CycleFloatManager = new(self) class'AliceCycleFloatManager';
        if (CycleFloatManager != none)
        {
            CycleFloatManager.PostBeginPlay();
        }
    }
    if (SonarManager == none)
    {
        SonarManager = new(self) class'AliceSonarManager';
    }
    if (configDataManager == none)
    {
        configDataManager = new(self) class'AliceConfigDataManager';
    }
    if (persistentDataManager == none)
    {
        persistentDataManager = new(self) class'AlicePersistentDataManager';
    }
    if (SoundModeManager == none)
    {
        SoundModeManager = new(self) class'AliceSoundModeManager';
    }
    if (stuckManager == none)
    {
        stuckManager = new(self) class'AliceStuckManager';
    }
    InitPlayerMovementStates();
    InitTargetingModes();
    GetCameraMagnets(true);
    if (bEnableARM)
    {
        SetTimer(1.0, false, 'EnableARM');
    }
    SetInMainMenu(false);
}

native function GeneratingBinkVideos(float fDeltaTime)
{
    fDeltaTime;
}

native function LoadAllLevels()
{
}

reliable client simulated function ClientRestart(Pawn NewPawn)
{
    ClientRestart(NewPawn);
    MyAlicePawn = AlicePawn(NewPawn);
    if (MyAlicePawn.bSonarAlwaysVisible)
    {
        SonarManager.SetActive(true);
    }
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
    local Vector Start, End;
    
    DisplayDebug(HUD, out_YL, out_YPos);
    if (bTargetingModeActive)
    {
        Start = Pawn.Location;
        Start.Z -= float(100);
        End = Pawn.Location;
        End.Z += float(100);
        DrawDebugCylinder(Start, End, 300.0, 32, 255, 0, 0);
    }
    if (AlicePawn(Pawn).bFloatDown)
    {
        Start = Pawn.Location;
        Start.Z -= float(100);
        End = Pawn.Location;
        End.Z += float(100);
        DrawDebugCylinder(Start, End, 300.0, 32, 255, 0, 0);
    }
}

simulated function bool IsMaintainingMovement()
{
    return bMaintainMovement;
}

simulated function StopMaintainMovement()
{
    bMaintainMovement = false;
    OriginalInputVector = vect(0.0, 0.0, 0.0);
    fTimeThresholdToMaintainMove = 0.0;
    fTimeLeftToMaintainMove = 0.0;
}

simulated function StartMaintainMovement(float fTime)
{
    bMaintainMovement = true;
    OriginalInputVector = AlicePlayerInput(PlayerInput).InputVector;
    fTimeThresholdToMaintainMove = fTime;
    fTimeLeftToMaintainMove = 0.0;
}

simulated event EnableCameraInterp(bool bEnable, Actor FocusActor)
{
    bCameraInterpEnabled = bEnable;
    CameraInterpFocusPoint = FocusActor.Location;
    CameraInterpFocusActor = FocusActor;
}

event AliceControllerTick(float DeltaTime)
{
    if (!bPOITriggered && CurrLookedAtPOI != none)
    {
        CurrLookedAtPOI.DisablePOI();
        CurrLookedAtPOI = none;
        bIsHoldingPOIButton = false;
    }
}

function UpdateNextCriticalUI(Actor TargetActor, optional int SocketID = 0)
{
    local bool bNextCritical;
    
    if (AliceGameKynapsePawn(TargetActor) != none && AliceGameKynapsePawn(TargetActor).IsTargetSocketCritical(SocketID))
    {
        bNextCritical = true;
    }
    else
    {
        bNextCritical = false;
    }
    if (bTargetUIPrevCritical != bNextCritical)
    {
        AliceGameInfo(WorldInfo.Game).ToggleCritical(bNextCritical);
        bTargetUIPrevCritical = bNextCritical;
    }
}

native function bool IsFrechKeyboard()
{
}

native function bool GetJPNSKU()
{
}

native function int GetCalloutPlatform()
{
}

native function bool PS3UseCircleToAccept()
{
}

native function PauseBinkFile(bool bPaused)
{
    bPaused;
}

native function bool IsPlayingBinkFile(string Filename)
{
    Filename;
}

native function StopBinkFile()
{
}

native function PlayBinkFile(string Filename, optional bool bBlock = true, optional bool bSoundOnly = false)
{
    Filename;
    bBlock;
    bSoundOnly;
}

native function bool DoesAliceGameSupportSecondController()
{
}

native function bool SwitchAliceArcheTypePointer(EAliceArcheType nAliceArcheType)
{
    nAliceArcheType;
}

native function SetAliceArcheType(AlicePawn pPawn, AlicePawn pAliceArcheType, float percentage)
{
    pPawn;
    pAliceArcheType;
    percentage;
}

native function SwitchAliceArcheType(AlicePawn pPawn, EAliceArcheType nAliceArcheType)
{
    pPawn;
    nAliceArcheType;
}

native function DoCrossHairLineCheck(Vector vStart, Vector vEnd)
{
    vStart;
    vEnd;
}

native function LoadCheckpoint()
{
}

state PlayerInteractInLondon extends PlayerWalking
{
    event EndState(name NextStateName)
    {
        EndState(NextStateName);
        InteractLondonActor = none;
        showPressX(-1.0);
    }
    
    event BeginState(name PreviousStateName)
    {
        BeginState(PreviousStateName);
        showPressX(0.0);
    }
    
    function exitInteractState()
    {
        GotoState('PlayerWalking');
    }
    
    function showDescrible(bool bShow)
    {
        if (AliceGameInfo(WorldInfo.Game).GFxHUDMenu != none)
        {
            AliceGameInfo(WorldInfo.Game).GFxHUDMenu.ShowInteractDescrible(bShow, InteractLondonActor.Describle_Icon);
        }
    }
    
    function showPressX(float Duration)
    {
        if (AliceGameInfo(WorldInfo.Game).GFxHUDMenu != none)
        {
            AliceGameInfo(WorldInfo.Game).GFxHUDMenu.ShowInteractPressX(Duration, InteractLondonActor.PressX_Icon);
        }
    }
    
    function giveupFocus()
    {
        if (AliceGameInfo(WorldInfo.Game).GFxHUDMenu != none)
        {
            AliceGameInfo(WorldInfo.Game).GFxHUDMenu.SetFocus(true);
        }
    }
    
    function gfxCallBack()
    {
        if (AliceGameInfo(WorldInfo.Game).GFxHUDMenu != none)
        {
            AliceGameInfo(WorldInfo.Game).GFxHUDMenu.exitInteractState();
        }
    }
    
    function delayBackHere()
    {
        SetTimer(2.0, false, 'gfxCallBack');
    }
    
    exec function interactInLondonX()
    {
        if (!MyAlicePawn.bInLondon)
        {
            return;
        }
        showPressX(-1.0);
        showDescrible(true);
        giveupFocus();
    }
    
    Stop;
}

state ShowSpline
{
    function StopShowPath()
    {
        GotoState('PlayerWalking');
    }
    
    function PlayerMove(float DeltaTime)
    {
        local Rotator Rot;
        local ShowPathSplineActor SA;
        local float Distance, NearestDistance, Speed;
        local Vector Dir;
        local SeqAct_HeadLookAt LookAtAct;
        
        Speed = 25.0;
        UpdateRotation(DeltaTime);
        if (Abs(PlayerInput.aTurn) > float(0) || Abs(PlayerInput.aLookUp) > float(0) || Abs(PlayerInput.aForward) > float(0) || Abs(PlayerInput.aStrafe) > float(0))
        {
            GotoState('PlayerWalking');
        }
        if (MyAlicePawn.NearestSplineActor == none)
        {
            NearestDistance = 10000.0;
            foreach DynamicActors(class'ShowPathSplineActor', SA)
            {
                Distance = VSize(SA.Location - MyAlicePawn.Location);
                if (Distance < NearestDistance && !SA.bDisableDestination)
                {
                    MyAlicePawn.NearestSplineActor = SA;
                    NearestDistance = Distance;
                    LookAtAct = new class'SeqAct_HeadLookAt';
                    LookAtAct.TargetActors.AddItem(SA);
                    LookAtAct.LookAtDuration = MyAlicePawn.ShowPathLifeTime + float(3);
                    MyAlicePawn.OnHeadLookAt(LookAtAct);
                }
            }
            if (MyAlicePawn.NearestSplineActor != none)
            {
                MyAlicePawn.ShowPathParticleLocation = MyAlicePawn.Location;
            }
            else
            {
                StopShowPath();
            }
        }
        else
        {
            if (!MyAlicePawn.ShowPathTriggerParticleFinished)
            {
                Dir = Normal(MyAlicePawn.NearestSplineActor.Location - MyAlicePawn.ShowPathParticleLocation);
                Distance = VSize(MyAlicePawn.NearestSplineActor.Location - MyAlicePawn.ShowPathParticleLocation);
                Speed = Speed * DeltaTime / 0.0166;
                if (Distance <= Speed)
                {
                    MyAlicePawn.ShowPathParticleLocation = MyAlicePawn.NearestSplineActor.Location;
                    MyAlicePawn.ShowPathTriggerParticleFinished = true;
                    SetTimer(MyAlicePawn.ShowPathLifeTime, false, 'StopShowPath');
                }
                else
                {
                    MyAlicePawn.ShowPathParticleLocation += Dir * Speed;
                }
                MyAlicePawn.PlayParticle(MyAlicePawn.ShowPathParticleLocation, Rotation, MyAlicePawn.ShowPathTriggerParticle, true);
            }
            else
            {
                if (MyAlicePawn.NearestSplineActor.Connections.Length > 0)
                {
                    SA = ShowPathSplineActor(MyAlicePawn.NearestSplineActor.Connections[0].ConnectTo);
                    if (!SA.bDisableDestination)
                    {
                        Dir = Normal(SA.Location - MyAlicePawn.ShowPathParticleLocation);
                        Distance = VSize(SA.Location - MyAlicePawn.ShowPathParticleLocation);
                        Speed = Speed * DeltaTime / 0.0166;
                        if (Distance <= Speed)
                        {
                            MyAlicePawn.ShowPathParticleLocation = SA.Location;
                            MyAlicePawn.NearestSplineActor = SA;
                        }
                        else
                        {
                            MyAlicePawn.ShowPathParticleLocation += Dir * Speed;
                        }
                    }
                    else
                    {
                        MyAlicePawn.NearestSplineActor = SA;
                    }
                }
                MyAlicePawn.PlayParticle(MyAlicePawn.ShowPathParticleLocation, Rotation, MyAlicePawn.ShowPathTrailParticle, true);
            }
            SetShowPathMagnet(MyAlicePawn.ShowPathParticleLocation);
            Rot = Rotation;
            Rot.Pitch = MyAlicePawn.Rotation.Pitch;
            MyAlicePawn.SetRotation(Rot);
        }
    }
    
    event EndState(name NextStateName)
    {
        DisableShowPathMagnet();
        MyAlicePawn.SetHeadTrackActor(none, 'HeadLook');
    }
    
    event BeginState(name PreviousStateName)
    {
        MyAlicePawn.NearestSplineActor = none;
        MyAlicePawn.ShowPathTriggerParticleFinished = false;
        ShowPathMagnet.bEnabled = true;
    }
    
    Stop;
}

state PlayerRoll
{
    exec function BoostRoll(bool Boost)
    {
        bBoostRoll = Boost;
    }
    
    simulated function OnTeleport(SeqAct_Teleport inAction)
    {
        local array<Object> objVars;
        local int Idx;
        local Actor destActor;
        
        inAction.GetObjectVars(objVars, "Destination");
        for (Idx = 0; Idx < objVars.Length && destActor == none; Idx++)
        {
            destActor = Actor(objVars[Idx]);
        }
        if (destActor != none)
        {
            Pawn.Mesh.SetRBPosition(destActor.Location);
            Pawn.Mesh.SetRBRotation(destActor.Rotation);
            PlayTeleportEffect(false, true);
        }
    }
    
    function Bump(Actor Other, PrimitiveComponent OtherComp, Vector HitNormal)
    {
        if (GameBreakableActor(Other) != none)
        {
            Other.TakeDamage(int(MyAlicePawn.RollBumpDamage), self, MyAlicePawn.Location, vector(MyAlicePawn.Rotation), class'DmgType_RollBumpDamage');
            RestorePreviousRigidBodyVelocity();
        }
    }
    
    function EndState(name NextStateName)
    {
        MyAlicePawn.StopRoll();
        EndState(NextStateName);
    }
    
    event BeginState(name PreviousStateName)
    {
        RecoverToDefaultStatus();
    }
    
    function float getVolume2ByVelocity()
    {
        local float fVolume;
        local Vector curHeadVelocity;
        
        curHeadVelocity = MyAlicePawn.Mesh.GetRootBodyInstance().Velocity;
        fVolume = VSize(curHeadVelocity) / AliceCheatManager(CheatManager).getMaxHeadSpeed();
        if (fVolume < 0.7)
        {
            fVolume = fVolume / 1.73;
        }
        else
        {
            fVolume = 0.7 / 1.73 + (fVolume - 0.7) * 2.0;
        }
        fVolume = FClamp(fVolume, 0.0, 1.0);
        return fVolume;
    }
    
    function float getVolume1ByVelocity()
    {
        local float fVolume;
        local Vector curHeadVelocity;
        
        curHeadVelocity = MyAlicePawn.Mesh.GetRootBodyInstance().Velocity;
        if (AliceCheatManager(CheatManager).bShowHeadSpeed)
        {
            LogInternal("=== CurHeadSpeed: " $ string(VSize(curHeadVelocity)) $ " ===");
        }
        fVolume = VSize(curHeadVelocity) / AliceCheatManager(CheatManager).getMaxHeadSpeed();
        fVolume *= 1.73;
        fVolume = FClamp(fVolume, 0.0, 1.0);
        return fVolume;
    }
    
    function updatePinballSound(bool bonGround)
    {
        local float volume1, volume2;
        
        if (pinballSoundComp1 == none)
        {
            pinballSoundComp1 = CreateAudioComponent(pinballSound1);
        }
        if (pinballSoundComp2 == none)
        {
            pinballSoundComp2 = CreateAudioComponent(pinballSound2);
        }
        if (bonGround)
        {
            if (!bLastTickOnGround)
            {
                pinballSoundComp1.FadeIn(0.1, 0.5);
                pinballSoundComp2.FadeIn(0.1, 0.5);
            }
            else
            {
                volume1 = getVolume1ByVelocity();
                volume2 = getVolume2ByVelocity();
                pinballSoundComp1.AdjustVolume(0.0, volume1);
                pinballSoundComp2.AdjustVolume(0.0, volume2);
            }
        }
        else if (bLastTickOnGround)
        {
            pinballSoundComp1.FadeOut(0.1, 0.0);
            pinballSoundComp2.FadeOut(0.1, 0.0);
        }
        bLastTickOnGround = bonGround;
    }
    
    function PlayerMove(float DeltaTime)
    {
        local Vector Dir, BoostForce, Target, Orientation, rotateDir;
        local bool onGround;
        
        if (MyAlicePawn.bAttractedByCannon)
        {
            MyAlicePawn.Mesh.SetRBLinearVelocity(vect(0.0, 0.0, 0.0), false);
            MyAlicePawn.Mesh.SetRBAngularVelocity(vect(0.0, 0.0, 0.0), false);
            if (VSize(AlicePlayerInput(PlayerInput).InputVector) > float(0))
            {
                MyAlicePawn.Pinball_Cannon.ChangeRotation(DeltaTime, AlicePlayerInput(PlayerInput));
            }
            if (MyAlicePawn.Pinball_Cannon.ShootPower >= 0.0)
            {
                MyAlicePawn.Pinball_Cannon.ShootPower += DeltaTime;
                if (MyAlicePawn.Pinball_Cannon.ShootPower > float(1))
                {
                    if (MyAlicePawn.Pinball_Cannon.FullyChargedSound != none)
                    {
                        PlaySound(MyAlicePawn.Pinball_Cannon.FullyChargedSound);
                    }
                    MyAlicePawn.Pinball_Cannon.ShootPower = 1.0;
                }
                MyAlicePawn.Pinball_Cannon.setChargeMat(MyAlicePawn.Pinball_Cannon.ShootPower);
            }
            UpdateRotation(DeltaTime);
            return;
        }
        if (MyAlicePawn.HeadSwitch != none)
        {
            if (MyAlicePawn.HeadSwitchStep == 1)
            {
                Target = (MyAlicePawn.HeadSwitch.AttractionLocation >> MyAlicePawn.HeadSwitch.Rotation) + MyAlicePawn.HeadSwitch.Location;
                Dir = Target - MyAlicePawn.Mesh.GetPosition();
                Orientation = QuatRotateVector(MyAlicePawn.Mesh.GetBoneQuaternion('Root', 0), vect(0.0, 0.0, 1.0));
                rotateDir = Orientation Cross vect(0.0, 0.0, 1.0);
                if (VSize(Dir) > float(100))
                {
                    MyAlicePawn.Mesh.AddImpulse(Normal(Dir) * MyAlicePawn.HeadSwitch.AttractionForce);
                }
                else if (Orientation Dot vect(0.0, 0.0, 1.0) < 0.9 && MyAlicePawn.HeadSwitchStep2TickTime > float(0))
                {
                    MyAlicePawn.HeadSwitchStep2TickTime -= DeltaTime;
                    MyAlicePawn.Mesh.SetRBLinearVelocity(vect(0.0, 0.0, 0.0), false);
                    MyAlicePawn.Mesh.SetRBPosition(Target);
                    MyAlicePawn.Mesh.AddTorque(rotateDir * MyAlicePawn.HeadSwitch.AttractionTorque);
                }
                else
                {
                    MyAlicePawn.Mesh.SetRBLinearVelocity(vect(0.0, 0.0, 0.0), false);
                    MyAlicePawn.Mesh.SetRBAngularVelocity(vect(0.0, 0.0, 0.0), false);
                    MyAlicePawn.Mesh.SetRBPosition(Target + MyAlicePawn.HeadSwitch.SnapOffset);
                    MyAlicePawn.Mesh.SetRBRotation(rotator(vect(0.0, 1.0, 0.0)));
                    MyAlicePawn.HeadSwitch.HeadSwitchActivated();
                    MyAlicePawn.HeadSwitchStep++;
                    MyAlicePawn.HeadSwitchTime = 0.0;
                }
                UpdateRotation(DeltaTime);
                return;
            }
            else if (MyAlicePawn.HeadSwitchStep == 2)
            {
                Target = (MyAlicePawn.HeadSwitch.AttractionLocation >> MyAlicePawn.HeadSwitch.Rotation) + MyAlicePawn.HeadSwitch.Location;
                MyAlicePawn.Mesh.SetRBLinearVelocity(vect(0.0, 0.0, 0.0), false);
                MyAlicePawn.Mesh.SetRBPosition(Target + MyAlicePawn.HeadSwitch.SnapOffset);
                if (MyAlicePawn.HeadSwitch.RevMode)
                {
                    if (bBoostRoll)
                    {
                        MyAlicePawn.HeadSwitch.RevSpeed += MyAlicePawn.HeadSwitch.RevAcceleration * DeltaTime;
                        if (MyAlicePawn.HeadSwitch.RevSpeed > MyAlicePawn.HeadSwitch.RevMaxSpeed)
                        {
                            MyAlicePawn.HeadSwitch.RevSpeed = MyAlicePawn.HeadSwitch.RevMaxSpeed;
                        }
                    }
                    else
                    {
                        MyAlicePawn.HeadSwitch.RevSpeed -= MyAlicePawn.HeadSwitch.RevDecceleration * DeltaTime;
                        if (MyAlicePawn.HeadSwitch.RevSpeed < float(0))
                        {
                            MyAlicePawn.HeadSwitch.RevSpeed = 0.0;
                        }
                    }
                    ClientMessage("RevOutput=" @ string(MyAlicePawn.HeadSwitch.RevOutput));
                    MyAlicePawn.Mesh.AddTorque(vect(0.0, 0.0, 1.0) * MyAlicePawn.HeadSwitch.RevSpeed);
                    MyAlicePawn.Mesh.AddTorque(MyAlicePawn.Mesh.FindBodyInstanceNamed('Root').GetUnrealWorldAngularVelocity() * -MyAlicePawn.HeadSwitch.RevDamping);
                    MyAlicePawn.HeadSwitch.RevOutput = MyAlicePawn.HeadSwitch.RevSpeed / MyAlicePawn.HeadSwitch.RevMaxSpeed;
                }
                else
                {
                    MyAlicePawn.Mesh.SetRBAngularVelocity(vect(0.0, 0.0, 0.0), false);
                    MyAlicePawn.HeadSwitchTime += DeltaTime;
                    if (MyAlicePawn.HeadSwitchTime > MyAlicePawn.HeadSwitch.DelayBeforeEjection)
                    {
                        MyAlicePawn.Mesh.AddForce((MyAlicePawn.HeadSwitch.EjectionDirection >> MyAlicePawn.HeadSwitch.Rotation) * MyAlicePawn.HeadSwitch.EjectionForce);
                        MyAlicePawn.HeadSwitch.HeadSwitchEjected();
                        MyAlicePawn.HeadSwitchStep = 3;
                    }
                }
                UpdateRotation(DeltaTime);
                return;
            }
        }
        MyAlicePawn.AliceCameraOrientation = rotator(MyAlicePawn.Mesh.PhysicsAssetInstance.Bodies[0].Velocity) - MyAlicePawn.Rotation;
        UpdateRotation(DeltaTime);
        ProjectInputToCameraSpace();
        Dir = MyAlicePawn.Mesh.GetRootBodyInstance().Velocity;
        Dir.Z = 0.0;
        MyAlicePawn.Mesh.AddForce(Dir * -MyAlicePawn.RollHorizontalDamping);
        Dir = MyAlicePawn.Mesh.GetRootBodyInstance().Velocity;
        Dir.X = 0.0;
        Dir.Y = 0.0;
        MyAlicePawn.Mesh.AddForce(Dir * -MyAlicePawn.RollVerticalDamping);
        MyAlicePawn.Mesh.AddForce(vect(0.0, 0.0, -1.0) * MyAlicePawn.RollExtraGravity);
        Dir = AlicePlayerInput(PlayerInput).InputVector;
        Dir.Z = 0.0;
        if (!bBoostVolumeActive)
        {
            MyAlicePawn.Mesh.AddForce(Dir * MyAlicePawn.RollMoveImpulse);
        }
        if (bBoostVolumeActive)
        {
            if (bBoostVolumeFalloff)
            {
                BoostForce = (BoostVolumeDuration - BoostVolumeTime) / BoostVolumeDuration * BoostVolumeForce;
            }
            else
            {
                BoostForce = BoostVolumeForce;
            }
            MyAlicePawn.Mesh.AddForce(BoostForce);
            BoostVolumeTime += DeltaTime;
            if (BoostVolumeTime > BoostVolumeDuration)
            {
                bBoostVolumeActive = false;
            }
        }
        onGround = IsOnGround();
        if (bPressedJump && onGround)
        {
            MyAlicePawn.Mesh.AddImpulse(vect(0.0, 0.0, 1.0) * MyAlicePawn.RollJumpImpulse);
        }
        bPressedJump = false;
        updatePinballSound(onGround);
    }
    
    exec function ChargePinballCannon()
    {
        MyAlicePawn.Pinball_Cannon.ShootPower = 0.0;
    }
    
    function bool IsOnGround()
    {
        local Vector HitLocation, HitNormal, Start, End;
        local Rotator R;
        
        Pawn.Mesh.TransformFromBoneSpace(name("root"), vect(0.0, 0.0, 1.0) * MyAlicePawn.RollJumpTraceHeight, R, Start, R);
        End = Start + vect(0.0, 0.0, -1.0) * MyAlicePawn.RollJumpTraceDistance;
        if (Pawn.Trace(HitLocation, HitNormal, End, Pawn.Location, false) != none)
        {
            return true;
        }
        return false;
    }
    
    exec function HeadSwitchEject()
    {
        if (MyAlicePawn.HeadSwitchStep == 2)
        {
            MyAlicePawn.Mesh.AddForce((MyAlicePawn.HeadSwitch.EjectionDirection >> MyAlicePawn.HeadSwitch.Rotation) * MyAlicePawn.HeadSwitch.EjectionForce);
            MyAlicePawn.HeadSwitch.HeadSwitchEjected();
            MyAlicePawn.HeadSwitchStep = 3;
            MyAlicePawn.HeadSwitchTime = 0.0;
            MyAlicePawn.HeadSwitch.RevSpeed = 0.0;
        }
    }
    
    exec function ShootPinball()
    {
        if (MyAlicePawn.bAttractedByCannon)
        {
            MyAlicePawn.Pinball_Cannon.ShootOut();
            MyAlicePawn.Pinball_Cannon.turnoffChargeMat();
        }
    }
    
    Stop;
}

state PlayerChessPuzzle
{
    event EndState(name NextStateName)
    {
        ChessBoardActor.EndGame();
    }
    
    event BeginState(name PreviousStateName)
    {
        RecoverToDefaultStatus();
        ChessBoardActor.StartGame();
    }
    
    function HandleCommand(float DeltaTime)
    {
        local EChessMoveCommand Command;
        local float fJoyUp, fJoyRight;
        
        fJoyUp = FClamp(AlicePlayerInput(PlayerInput).GetRawJoyUp(), -1.0, 1.0);
        fJoyRight = FClamp(AlicePlayerInput(PlayerInput).GetRawJoyRight(), -1.0, 1.0);
        if (ChessBoardActor != none && fJoyRight != 0.0 || fJoyUp != 0.0)
        {
            if (Abs(fJoyRight) > Abs(fJoyUp))
            {
                Command = (fJoyRight > 0.0 ? 1 : 0);
            }
            else
            {
                Command = (fJoyUp > 0.0 ? 2 : 3);
            }
            ChessBoardActor.HandleCommand(Command, DeltaTime);
        }
    }
    
    function PlayerMove(float DeltaTime)
    {
        Pawn.Acceleration = vect(0.0, 0.0, 0.0);
        Pawn.Velocity = vect(0.0, 0.0, 0.0);
        HandleCommand(DeltaTime);
    }
    
    Stop;
}

state PlayerBlockPuzzle
{
    exec function MoveBlockPieceB()
    {
        if (BlockPuzzleActor == none || !PS3UseCircleToAccept())
        {
            return;
        }
        BlockPuzzleActor.MoveBlockPiece();
    }
    
    exec function MoveBlockPieceA()
    {
        if (BlockPuzzleActor == none || PS3UseCircleToAccept())
        {
            return;
        }
        BlockPuzzleActor.MoveBlockPiece();
    }
    
    event EndState(name NextStateName)
    {
        BlockPuzzleActor.EndGame();
    }
    
    event BeginState(name PreviousStateName)
    {
        RecoverToDefaultStatus();
        BlockPuzzleActor.StartGame();
    }
    
    function HandleCommand(float DeltaTime)
    {
        local EChessMoveCommand Command;
        local float fJoyUp, fJoyRight;
        
        fJoyUp = FClamp(AlicePlayerInput(PlayerInput).GetRawJoyUp(), -1.0, 1.0);
        fJoyRight = FClamp(AlicePlayerInput(PlayerInput).GetRawJoyRight(), -1.0, 1.0);
        if (BlockPuzzleActor != none && fJoyRight != 0.0 || fJoyUp != 0.0)
        {
            if (Abs(fJoyRight) > Abs(fJoyUp))
            {
                Command = (fJoyRight > 0.0 ? 1 : 0);
            }
            else
            {
                Command = (fJoyUp > 0.0 ? 2 : 3);
            }
            BlockPuzzleActor.HandleCommand(Command, DeltaTime);
        }
    }
    
    function PlayerMove(float DeltaTime)
    {
        Pawn.Acceleration = vect(0.0, 0.0, 0.0);
        Pawn.Velocity = vect(0.0, 0.0, 0.0);
        HandleCommand(DeltaTime);
    }
    
    Stop;
}

state PlayerSteamVent
{
    event EndState(name NextStateName)
    {
        MyAlicePawn.SetAliceAbilityCamera(MyAlicePawn.SteamVentCamera, true);
        MyAlicePawn.TriggerContextEventClass(7, 1);
        if (!MyAlicePawn.IsDoingSpecialMove(64) && !MyAlicePawn.IsDoingSpecialMove(4))
        {
            MyAlicePawn.DoSpecialMove(3, true);
        }
        if (ventActor != none)
        {
            ventActor.playIdleParticle(false);
        }
    }
    
    event BeginState(name PreviousStateName)
    {
        RecoverToDefaultStatus(false, false, true);
        MyAlicePawn.DoSpecialMove(58, true);
        curSteamAnim = 58;
        MyAlicePawn.SetAliceAbilityCamera(MyAlicePawn.SteamVentCamera);
        MyAlicePawn.TriggerContextEventClass(7, 0);
    }
    
    function tryUnlockVentTrophy(float DeltaTime)
    {
        local float NewDuration;
        
        NewDuration = getAliceGameEngine().totalVentDuration + DeltaTime;
        if (getAliceGameEngine().totalVentDuration < float(420) && NewDuration >= float(420))
        {
            ConsoleCommand("trophy unlock=35");
            if (isShowTrophy())
            {
                ClientMessage("==== Vent Trophy Unlock ====");
            }
        }
        getAliceGameEngine().totalVentDuration = NewDuration;
    }
    
    function PlayerMove(float DeltaTime)
    {
        local Vector newAccel;
        local Rotator DeltaRot;
        
        if (Pawn == none)
        {
            GotoState('Dead');
        }
        else
        {
            ProjectInputToCameraSpace();
            if (Physics == 0)
            {
                MyAlicePawn.SetPhysics(20);
            }
            updateHover(DeltaTime);
            tryUnlockVentTrophy(DeltaTime);
            UpdateAccel(DeltaTime, newAccel);
            UpdateDeltaRotation(DeltaTime, newAccel, DeltaRot);
            ProcessMove(DeltaTime, newAccel, 0, DeltaRot);
            if (bPressedJump)
            {
                GotoState('PlayerWalking');
                MyAlicePawn.SetPhysics(2);
                bPressedJump = false;
            }
            bPressedJump = false;
            UpdateRotation(DeltaTime);
            AddSkirtFloatingEffect(DeltaTime);
        }
    }
    
    function AddSkirtFloatingEffect(float DeltaTime)
    {
        MyAlicePawn.SkirtComponent.RadialForcePosition = MyAlicePawn.SkirtFloatRadialForceDisplacement;
        MyAlicePawn.SkirtComponent.RadialForceMagnitude = MyAlicePawn.SkirtFloatRadialForceMagnitude;
        MyAlicePawn.RibbonComponent.RadialForcePosition = MyAlicePawn.SkirtFloatRadialForceDisplacement;
        MyAlicePawn.RibbonComponent.RadialForceMagnitude = MyAlicePawn.RibbonFloatRadialForceMagnitude;
        MyAlicePawn.BowComponent.RadialForcePosition = MyAlicePawn.SkirtFloatRadialForceDisplacement;
        MyAlicePawn.BowComponent.RadialForceMagnitude = MyAlicePawn.RibbonFloatRadialForceMagnitude;
    }
    
    function ProcessMove(float DeltaTime, Vector newAccel, EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
    {
        if (Pawn == none)
        {
            return;
        }
        Pawn.Acceleration = newAccel;
        CheckJumpOrDuck();
    }
    
    function UpdateDeltaRotation(float DeltaTime, Vector vAccel, out Rotator Rot)
    {
        local Rotator NewRotation;
        local float RawJoyRight, DeltaYaw;
        
        if (Pawn == none || AlicePawn(Pawn) == none || allSteamVentNone())
        {
            return;
        }
        if (MyAlicePawn.ArcheTypeID == 3)
        {
            if (VSize(GetInputVector()) <= float(0))
            {
                DeltaYaw = 0.0;
                return;
            }
            else
            {
                DeltaYaw = 1.0;
            }
            NewRotation = RInterpTo(MyAlicePawn.Rotation, rotator(GetInputVector()), DeltaTime, 800.0);
        }
        else if (IsNewHoverControl())
        {
            NewRotation = MyAlicePawn.Rotation;
            if (PlayerInput.aMouseX != float(0))
            {
                DeltaYaw = PlayerInput.aMouseX / 800.0 * getSteamVentRotationSpeed();
            }
            else
            {
                DeltaYaw = PlayerInput.RawJoyLookRight * getSteamVentRotationSpeed();
            }
            NewRotation.Yaw += int(DeltaYaw);
        }
        else
        {
            RawJoyRight = AlicePlayerInput(PlayerInput).GetRawJoyRight();
            NewRotation = Pawn.Rotation;
            DeltaYaw = RawJoyRight * getSteamVentRotationSpeed();
            NewRotation.Yaw += int(DeltaYaw);
        }
        if (bVentLastTickRotate && DeltaYaw == 0.0)
        {
            MyAlicePawn.TriggerContextEventClass(17, 1);
        }
        else if (!bVentLastTickRotate && DeltaYaw != 0.0)
        {
            MyAlicePawn.TriggerContextEventClass(17, 0);
        }
        bVentLastTickRotate = DeltaYaw != 0.0;
        Pawn.SetRotation(NewRotation);
    }
    
    function UpdateAccel(float DeltaTime, out Vector vAccel)
    {
        local Vector vForwardDir, cameraLoc, vCameraUp, vCameraRight;
        local Rotator cameraRot;
        local float RawJoyRight, DirFlag, RawJoyUp;
        
        if (bSteamVentRotating || MyAlicePawn == none || PlayerCamera == none || allSteamVentNone())
        {
            return;
        }
        vForwardDir = Normal(vector(Pawn.Rotation));
        if (MyAlicePawn.ArcheTypeID == 3)
        {
            DirFlag = GetInputVector() Dot vForwardDir;
            DirFlag = float(DirFlag < float(0) ? -1 : DirFlag > float(0) ? 1 : 0);
            RawJoyRight = AlicePlayerInput(PlayerInput).GetRawJoyRight();
            vAccel = vForwardDir * Abs(RawJoyRight) * DirFlag * getSteamVentForwardSpeed();
        }
        else if (IsNewHoverControl())
        {
            RawJoyUp = AlicePlayerInput(PlayerInput).GetRawJoyUp();
            RawJoyRight = AlicePlayerInput(PlayerInput).GetRawJoyRight();
            AlicePlayerCamera(PlayerCamera).GetCameraViewPoint(cameraLoc, cameraRot);
            cameraRot.Roll = 0;
            cameraRot.Pitch = 0;
            vCameraUp = Normal(vector(cameraRot));
            vCameraRight = Normal(vect(0.0, 0.0, 1.0) Cross vCameraUp);
            vAccel = vCameraUp * RawJoyUp * getSteamVentForwardSpeed();
            vAccel += vCameraRight * RawJoyRight * getSteamVentStrafeSpeed();
        }
        else
        {
            RawJoyUp = AlicePlayerInput(PlayerInput).GetRawJoyUp();
            vAccel = vForwardDir * RawJoyUp * getSteamVentForwardSpeed();
        }
        if (bVentLastTickMove && VSize(vAccel) == float(0))
        {
            MyAlicePawn.TriggerContextEventClass(16, 1);
        }
        else if (!bVentLastTickMove && VSize(vAccel) > float(0))
        {
            MyAlicePawn.TriggerContextEventClass(16, 0);
        }
        if (VSize(vAccel) == float(0))
        {
            MyAlicePawn.Velocity.X = 0.0;
            MyAlicePawn.Velocity.Y = 0.0;
            bVentLastTickMove = false;
        }
        else
        {
            bVentLastTickMove = true;
        }
        changeAnim();
    }
    
    function updateHover(float DeltaTime)
    {
        if (SteamVentVolume != none)
        {
            SteamVentVolume.Update(DeltaTime, self);
        }
        else if (ventActor != none)
        {
            ventActor.Update(DeltaTime, self);
        }
    }
    
    function float getSteamVentRotationSpeed()
    {
        if (SteamVentVolume != none)
        {
            return SteamVentVolume.SteamVentRotationSpeed;
        }
        else if (ventActor != none)
        {
            return ventActor.hoverRotationSpeed;
        }
    }
    
    function float getSteamVentStrafeSpeed()
    {
        if (SteamVentVolume != none)
        {
            return SteamVentVolume.SteamVentStrafeSpeed;
        }
        else if (ventActor != none)
        {
            return ventActor.hoverStrafeSpeed;
        }
    }
    
    function float getSteamVentForwardSpeed()
    {
        if (SteamVentVolume != none)
        {
            return SteamVentVolume.SteamVentForwardSpeed;
        }
        else if (ventActor != none)
        {
            return ventActor.hoverForwardSpeed;
        }
    }
    
    function bool allSteamVentNone()
    {
        return SteamVentVolume == none && ventActor == none;
    }
    
    function changeAnim()
    {
        local float RawJoyRight, RawJoyUp;
        local ESpecialMove newAnim;
        
        RawJoyUp = AlicePlayerInput(PlayerInput).GetRawJoyUp();
        RawJoyRight = AlicePlayerInput(PlayerInput).GetRawJoyRight();
        if (Abs(RawJoyUp) < 0.1 && Abs(RawJoyRight) < 0.1)
        {
            newAnim = 58;
        }
        else if (Abs(RawJoyUp) > Abs(RawJoyRight))
        {
            newAnim = (RawJoyUp > float(0) ? 60 : 59);
        }
        else
        {
            newAnim = (RawJoyRight > float(0) ? 62 : 61);
        }
        if (curSteamAnim != newAnim)
        {
            curSteamAnim = newAnim;
            MyAlicePawn.DoSpecialMove(curSteamAnim, true);
        }
    }
    
    Stop;
}

state AliceRespawn
{
    event EndState(name NextStateName)
    {
        MyAlicePawn.SetPawnStance(0);
        MyAlicePawn.SetPhysics(1);
        MyAlicePawn.HideAlicePawn(false);
        bIgnoreMoveInput = 0;
        MyAlicePawn.DoSpecialMove(0);
        CycleFloatManager.Init();
        MyAlicePawn.EnableForceTranslucency(false, 1.0, 0.0, 1000, false);
        MyAlicePawn.SetCollision(true, true);
        if (MyAlicePawn.bInRollingMode)
        {
            AlicePawn(Pawn).StartRoll();
            GotoState('PlayerRoll');
        }
    }
    
    event BeginState(name PreviousStateName)
    {
        MyAlicePawn.HideAlicePawn(false);
        AliceGamePawn(Pawn).DoSpecialMove(68, true);
    }
    
    Stop;
}

state Dead
{
    function PlayerMove(float DeltaTime)
    {
        MyAlicePawn.HideAlicePawn(MyAlicePawn.bShouldBeHide);
        MyAlicePawn.SetPhysics(0);
        MyAlicePawn.Acceleration = vect(0.0, 0.0, 0.0);
        MyAlicePawn.Velocity = vect(0.0, 0.0, 0.0);
        ShowLockOnTargetUI(false);
    }
    
    event EndState(name NextStateName)
    {
        MyAlicePawn.SetPawnStance(0);
        MyAlicePawn.SetPhysics(1);
        MyAlicePawn.HideAlicePawn(false);
        bIgnoreMoveInput = 0;
        MyAlicePawn.DoSpecialMove(0);
        CycleFloatManager.Init();
        MyAlicePawn.EnableForceTranslucency(false, 1.0, 0.0, 1000, false);
        MyAlicePawn.SetCollision(true, true);
        if (MyAlicePawn.bInRollingMode)
        {
            AlicePawn(Pawn).StartRoll();
            GotoState('PlayerRoll');
        }
        StopForceLookAtPointOfInterest(true);
    }
    
    event BeginState(name PreviousStateName)
    {
        local int SocketIndex;
        local AliceGameEngine Age;
        
        PlayerCamera.ClearAllCameraShakes();
        bConfirmToRespawn = false;
        PlayerMovementStates[curIndexOfPlayerMovementState].SetPlayerBasicMovementState(0);
        MyAlicePawn.bIsSprinting = false;
        MyAlicePawn.bIsJumping = false;
        MyAlicePawn.bIsDoubleJumping = false;
        MyAlicePawn.LeaveHysteriaMode();
        MyAlicePawn.SetPhysics(0);
        MyAlicePawn.FadeOutUmbrella();
        for (SocketIndex = 0; SocketIndex < MyAlicePawn.AttachNPCSockets.Length; SocketIndex++)
        {
            MyAlicePawn.AttachNPCSockets[SocketIndex].bOccupied = false;
            MyAlicePawn.AttachNPCSockets[SocketIndex].AttachedNPC = none;
        }
        ResetRangeWeapons();
        StopFire(MyAlicePawn.Weapon.CurrentFireMode);
        bHoldToggleLockOnButton = false;
        MyAlicePawn.ResetClothHair(false, true);
        MyAlicePawn.SetPhysics(0);
        MyAlicePawn.Acceleration = vect(0.0, 0.0, 0.0);
        MyAlicePawn.Velocity = vect(0.0, 0.0, 0.0);
        CrowdAgentsCount = 0;
        if (MyAlicePawn.bInGiantMode)
        {
            MyAlicePawn.MaxWalkingSpeed = MyAlicePawn.default.MaxWalkingSpeed;
            MyAlicePawn.MaxRunningSpeed = MyAlicePawn.default.MaxRunningSpeed;
            MyAlicePawn.Mesh.GlobalAnimRateScale = 1.0;
        }
        ShowLockOnTargetUI(false);
        MyAlicePawn.SetCollision(false, false);
        OnSMLaned();
        if (bShrinkingModeActive)
        {
            UnShrinking();
        }
        if (MyAlicePawn.bClockBombCountingDown)
        {
            AliceClonePawn(MyAlicePawn.MyClonePawn).Detonate();
        }
        MyAlicePawn.PlayDeathEffect();
        AliceGameInfo(WorldInfo.Game).ReSetUIAfterLoadCheckPoint();
        Age = getAliceGameEngine();
        if (MyAlicePawn.Health <= 0)
        {
            MyAlicePawn.DoSpecialMove(67, true);
            Age.StartStateName = 'AliceRespawn';
            SetTimer(0.5715, false, 'PlayDeadEffect');
        }
        else
        {
            Age.StartStateName = 'PlayerWalking';
            MyAlicePawn.HideAlicePawn(true);
            if (respawn_info.Level == 2)
            {
            }
            else if (respawn_info.Level == 1)
            {
            }
            else
            {
                MyAlicePawn.CurrentCameraAnim = MyAlicePawn.DeathCamera;
                MyAlicePawn.DeathParticleEmitter = Spawn(class'Engine.EmitterSpawnable', self);
                if (MyAlicePawn.DeathParticleEmitter != none && MyAlicePawn.DeathParticle != none)
                {
                    MyAlicePawn.DeathParticleEmitter.SetLocation(MyAlicePawn.Location);
                    MyAlicePawn.DeathParticleEmitter.ParticleSystemComponent.__OnSystemFinished__Delegate = OnDeathParticleFinished;
                    MyAlicePawn.DeathParticleEmitter.SetTemplate(MyAlicePawn.DeathParticle, true);
                }
                PlaySound(MyAlicePawn.DeathSound);
            }
        }
    }
    
    exec function HobbyHorseFireRelease()
    {
    }
    
    exec function VorpalBladeFireRelease()
    {
    }
    
    exec function EyeStaffFireRelease()
    {
    }
    
    exec function StartFire(optional byte FireModeNum)
    {
    }
    
    exec function ChangeShrinkingMode()
    {
    }
    
    exec function Use()
    {
    }
    
    Stop;
}

state PlayerJumpPad
{
    event EndState(name NextStateName)
    {
        MyAlicePawn.AirControl = MyAlicePawn.OldAirControl;
        AlicePawn(Pawn).bInJumpPad = false;
        AlicePawn(Pawn).JumpPad.Enable('Attach');
        AlicePawn(Pawn).JumpPad.Enable('Detach');
        AlicePawn(Pawn).JumpPad.TurnOnCollision();
        JumpPadPhysics(AlicePawn(Pawn).JumpPad).P = none;
        EndState(NextStateName);
        MyAlicePawn.TriggerContextEventClass(9, 1);
    }
    
    function PlayerMove(float DeltaTime)
    {
        local Vector Accel, Loc;
        local Rotator DeltaRot;
        
        PlayerMove(DeltaTime);
        Loc = MyAlicePawn.Location;
        if (MyAlicePawn.Location.X != AliceShadowModePos_X)
        {
            Loc.X = AliceShadowModePos_X;
            MyAlicePawn.FarMoveSetLocation(Loc, true);
        }
        if (bPressedJump && Pawn.CannotJumpNow())
        {
            bPressedJump = false;
        }
        if (JumpPadPhysics(AlicePawn(Pawn).JumpPad) != none)
        {
            UpdateAccel(DeltaTime, Accel);
            Pawn.Acceleration = Accel;
            UpdateDeltaRotation(DeltaTime, Accel, DeltaRot);
        }
        UpdateRotation(DeltaTime);
        InputaUp = PlayerInput.aUp;
        if (!MyAlicePawn.bFloatDown)
        {
            MyAlicePawn.SetPhysics(2);
            CycleFloatManager.indicatorManager.stopEffect();
        }
        else if (MyAlicePawn.Velocity.Z < float(0))
        {
            GotoState('PlayerFloat');
        }
    }
    
    function UpdateRotation(float DeltaTime)
    {
        local Rotator DeltaRot, ViewRotation;
        
        ViewRotation = Rotation;
        ModifyRotationSpeed(DeltaTime, AlicePlayerInput(PlayerInput).aLookUp, AlicePlayerInput(PlayerInput).aTurn);
        DeltaRot.Yaw = int(PlayerInput.aTurn);
        DeltaRot.Pitch = int(PlayerInput.aLookUp);
        ProcessViewRotation(DeltaTime, ViewRotation, DeltaRot);
        SetRotation(ViewRotation);
    }
    
    function UpdateDeltaRotation(float DeltaTime, Vector vAccel, out Rotator Rot)
    {
        local float RawJoyRight, YawSpeed;
        local Rotator NewRotation, AliceViewPointRot;
        local bool bPawnFaceToCamera;
        local Vector AliceEyeLoc;
        
        if (Pawn == none || AlicePawn(Pawn) == none)
        {
            return;
        }
        if (VSize(GetInputVector()) <= float(0))
        {
            return;
        }
        if (MyAlicePawn.ArcheTypeID == 3)
        {
            NewRotation = RInterpTo(MyAlicePawn.Rotation, rotator(GetInputVector()), DeltaTime, 25.0);
        }
        else
        {
            YawSpeed = JumpPadPhysics(AlicePawn(Pawn).JumpPad).RotationSpeed;
            RawJoyRight = AlicePlayerInput(PlayerInput).GetRawJoyRight();
            NewRotation = Pawn.Rotation;
            NewRotation.Yaw += int(RawJoyRight * YawSpeed);
            AlicePawn(Pawn).GetActorEyesViewPoint(AliceEyeLoc, AliceViewPointRot);
            bPawnFaceToCamera = vector(AliceViewPointRot) Dot vector(Pawn.Rotation) < float(0);
            if (bPawnFaceToCamera)
            {
                YawSpeed *= float(-1);
            }
        }
        Pawn.SetRotation(NewRotation);
    }
    
    function UpdateRightAccel(out Vector InRightAccel)
    {
        local Vector vRightDir, AliceEyeLoc;
        local Rotator AliceViewPointRot;
        local float RawJoyRight;
        
        AlicePawn(Pawn).GetActorEyesViewPoint(AliceEyeLoc, AliceViewPointRot);
        vRightDir = vect(0.0, 0.0, 1.0) Cross vector(AliceViewPointRot);
        vRightDir.Z = 0.0;
        vRightDir = Normal(vRightDir);
        RawJoyRight = AlicePlayerInput(PlayerInput).GetRawJoyRight();
        InRightAccel = vRightDir * RawJoyRight * float(300);
    }
    
    function UpdateForwardAccel(out Vector InForwardAccel)
    {
        local Vector vForwardDir, AliceEyeLoc;
        local Rotator AliceViewPointRot;
        local float RawJoyUp, RawJoyRight, DirFlag;
        
        vForwardDir = Normal(vector(Pawn.Rotation));
        if (MyAlicePawn.ArcheTypeID == 3)
        {
            DirFlag = GetInputVector() Dot vForwardDir;
            DirFlag = float(DirFlag < float(0) ? -1 : DirFlag > float(0) ? 1 : 0);
            RawJoyRight = AlicePlayerInput(PlayerInput).GetRawJoyRight();
            InForwardAccel = vForwardDir * Abs(RawJoyRight) * DirFlag * float(300);
        }
        else
        {
            AlicePawn(Pawn).GetActorEyesViewPoint(AliceEyeLoc, AliceViewPointRot);
            vForwardDir = vector(AliceViewPointRot);
            vForwardDir.Z = 0.0;
            vForwardDir = Normal(vForwardDir);
            RawJoyUp = AlicePlayerInput(PlayerInput).GetRawJoyUp();
            InForwardAccel = vForwardDir * RawJoyUp * float(300);
        }
    }
    
    function UpdateAccel(float DeltaTime, out Vector vAccel)
    {
        local Vector ForwardAccel, RightAccel;
        
        if (Pawn == none || AlicePawn(Pawn) == none || PlayerCamera == none)
        {
            return;
        }
        UpdateForwardAccel(ForwardAccel);
        UpdateRightAccel(RightAccel);
        vAccel = ForwardAccel + RightAccel;
    }
    
    event BeginState(name PreviousStateName)
    {
        BeginState(PreviousStateName);
        RecoverToDefaultStatus();
        AlicePawn(Pawn).bInJumpPad = true;
        Pawn.Velocity = vect(0.0, 0.0, 0.0);
        Pawn.Acceleration = vect(0.0, 0.0, 0.0);
        MyAlicePawn.HoldJumpTime = 0.0;
        MyAlicePawn.HoldFloatTime = 0.0;
        MyAlicePawn.bFloatDown = false;
        MyAlicePawn.bIsJumping = false;
        MyAlicePawn.bIsDoubleJumping = false;
        CycleFloatManager.Init();
        StopWeaponFiring();
        MyAlicePawn.SetPawnStance(6);
        MyAlicePawn.OldAirControl = MyAlicePawn.AirControl;
        MyAlicePawn.AirControl = AlicePawn(Pawn).JumpPad.JumpAirControl;
        MyAlicePawn.TriggerContextEventClass(9, 0);
        MyAlicePawn.FadeOutWeapon();
    }
    
    exec function LaunchFromJumpPad()
    {
        if (AlicePawn(Pawn).JumpPad != none && AlicePawn(Pawn).bInJumpPad)
        {
            AlicePawn(Pawn).JumpPad.Launch();
        }
    }
    
    Stop;
}

state PlayerFloat
{
    function ForceEndStateInCinematic()
    {
        EndState('PlayerWalking');
    }
    
    event EndState(name NextStateName)
    {
        local AliceCameraProperties ACP;
        
        EndState(NextStateName);
        MyAlicePawn.SetAliceAbilityCamera(MyAlicePawn.FloatCamera, true);
        MyAlicePawn.RestorePreviousAbilityCamera();
        if (MyAlicePawn.GetCurAbilityCamera(ACP))
        {
            MyAlicePawn.SetAliceAbilityCamera(ACP, true);
        }
        Pawn.SetPhysics(2);
        if (!MyAlicePawn.IsDoingSpecialMove(63) && !MyAlicePawn.IsDoingSpecialMove(4))
        {
            MyAlicePawn.DoSpecialMove(3, true);
        }
        MyAlicePawn.SetPawnStance(0);
        MyAlicePawn.SkirtComponent.RadialForceMagnitude = 0.0;
        MyAlicePawn.TriggerDressPhysic(false, 0.0);
        MyAlicePawn.EndGlideLoopingEffect();
        CycleFloatManager.OnEndFloat();
    }
    
    event BeginState(name PreviousStateName)
    {
        local Vector NewVelocity;
        
        BeginState(PreviousStateName);
        Pawn.SetPhysics(17);
        MyAlicePawn.SetPawnStance(6);
        MyAlicePawn.EndSpecialMove();
        AlicePawn(Pawn).TriggerDressPhysic(true, 1.0);
        if (!bShrinkingModeActive)
        {
            MyAlicePawn.SavePreviousAbilityCamera();
            MyAlicePawn.SetAliceAbilityCamera(MyAlicePawn.FloatCamera);
        }
        NewVelocity = Pawn.Velocity;
        NewVelocity *= 0.5;
        NewVelocity.Z = Pawn.Velocity.Z;
        Pawn.Velocity = NewVelocity;
        AlicePawn(Pawn).PlayGlideBeginParticle();
        MyAlicePawn.ResetGlideCameraInertiaFlags();
        MyAlicePawn.StartGlideLoopingEffect();
        if (!isNewCycleControl())
        {
            CycleFloatManager.bHasInputInWindow = true;
        }
        CycleFloatManager.StartNewCycle();
        ShowLockOnTargetUI(false);
    }
    
    function PlayerMove(float DeltaTime)
    {
        local Vector newAccel;
        local Rotator DeltaRot;
        
        if (Pawn == none)
        {
            GotoState('Dead');
        }
        else if (!AlicePawn(Pawn).bFloatDown && !bInFloatVolume && !bFloatLeaveSteam)
        {
            GotoState('PlayerWalking');
        }
        else
        {
            ShowLockOnTargetUI(false);
            ProjectInputToCameraSpace();
            CycleFloatManager.Update(DeltaTime);
            InputaUp = PlayerInput.aUp;
            UpdateDeltaRotation(DeltaTime, newAccel, DeltaRot);
            UpdateAccel(DeltaTime, newAccel);
            ProcessMove(DeltaTime, newAccel, 0, DeltaRot);
            UpdateRotation(DeltaTime);
            AddSkirtFloatingEffect(DeltaTime);
            if (bShrinkingModeActive && SonarManager.bActive)
            {
            }
            else
            {
                SonarManager.PostUpdate(DeltaTime);
            }
        }
    }
    
    function AddSkirtFloatingEffect(float DeltaTime)
    {
        local float Scale;
        local Vector SkirtDisplacementOffset;
        
        if (MyAlicePawn.HoldFloatTime < MyAlicePawn.SkirtFloatInitialDuration)
        {
            Scale = MyAlicePawn.SkirtFloatInitialScale;
            SkirtDisplacementOffset = MyAlicePawn.SkirtFloatInitialDisplacement;
        }
        else if (MyAlicePawn.MaxFloatDuration == float(0))
        {
            Scale = 1.0;
        }
        else
        {
            Scale = 1.0 - MyAlicePawn.HoldFloatTime / MyAlicePawn.MaxFloatDuration;
        }
        MyAlicePawn.SkirtComponent.RadialForcePosition = MyAlicePawn.SkirtFloatRadialForceDisplacement + SkirtDisplacementOffset;
        MyAlicePawn.SkirtComponent.RadialForceMagnitude = MyAlicePawn.SkirtFloatRadialForceMagnitude * Scale;
        MyAlicePawn.RibbonComponent.RadialForcePosition = MyAlicePawn.SkirtFloatRadialForceDisplacement;
        MyAlicePawn.RibbonComponent.RadialForceMagnitude = MyAlicePawn.RibbonFloatRadialForceMagnitude * Scale;
        MyAlicePawn.BowComponent.RadialForcePosition = MyAlicePawn.SkirtFloatRadialForceDisplacement;
        MyAlicePawn.BowComponent.RadialForceMagnitude = MyAlicePawn.RibbonFloatRadialForceMagnitude * Scale;
    }
    
    function ProcessMove(float DeltaTime, Vector newAccel, EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
    {
        if (Pawn == none)
        {
            return;
        }
        Pawn.Acceleration = newAccel;
    }
    
    function UpdateRotation(float DeltaTime)
    {
        local Rotator DeltaRot, ViewRotation;
        
        ViewRotation = Rotation;
        ModifyRotationSpeed(DeltaTime, AlicePlayerInput(PlayerInput).aLookUp, AlicePlayerInput(PlayerInput).aTurn);
        DeltaRot.Yaw = int(PlayerInput.aTurn);
        DeltaRot.Pitch = int(PlayerInput.aLookUp);
        ProcessViewRotation(DeltaTime, ViewRotation, DeltaRot);
        SetRotation(ViewRotation);
    }
    
    function UpdateDeltaRotation(float DeltaTime, Vector vAccel, out Rotator Rot)
    {
        local float YawSpeed;
        local Rotator NewRotation;
        
        if (MyAlicePawn == none || VSize(GetInputVector()) <= float(0))
        {
            return;
        }
        if (MyAlicePawn.ArcheTypeID != 3 && Abs(Normal(vector(MyAlicePawn.Rotation)) Dot Normal(GetInputVector())) > 0.8)
        {
            return;
        }
        if (MyAlicePawn.ArcheTypeID == 3)
        {
            YawSpeed = 800.0;
        }
        else
        {
            YawSpeed = 0.8;
        }
        NewRotation = RInterpTo(MyAlicePawn.Rotation, rotator(GetInputVector()), DeltaTime, YawSpeed);
        Pawn.SetRotation(NewRotation);
    }
    
    function UpdateRightAccel(out Vector InRightAccel)
    {
        local Vector vRightDir, AliceEyeLoc;
        local Rotator AliceViewPointRot;
        local float RawJoyRight;
        
        AlicePawn(Pawn).GetActorEyesViewPoint(AliceEyeLoc, AliceViewPointRot);
        vRightDir = Normal(vect(0.0, 0.0, 1.0) Cross vector(AliceViewPointRot));
        RawJoyRight = AlicePlayerInput(PlayerInput).GetRawJoyRight();
        if (MyAlicePawn.ArcheTypeID == 3)
        {
            InRightAccel = vRightDir * RawJoyRight * float(18000);
            if (Abs(RawJoyRight) < 0.3)
            {
                Pawn.Velocity *= 0.95;
            }
        }
        else
        {
            InRightAccel = vRightDir * RawJoyRight * float(180);
            if (Abs(RawJoyRight) < 0.001)
            {
                MyAlicePawn.AliceCameraOrientation.Roll = 0;
            }
            else
            {
                MyAlicePawn.AliceCameraOrientation.Roll = (RawJoyRight > 0.0 ? MyAlicePawn.FloatCamera.Orientation.Roll : -MyAlicePawn.FloatCamera.Orientation.Roll);
            }
        }
    }
    
    function UpdateForwardAccel(out Vector InForwardAccel)
    {
        local Vector vForwardDir, AliceEyeLoc;
        local Rotator AliceViewPointRot;
        local float RawJoyUp;
        
        AlicePawn(Pawn).GetActorEyesViewPoint(AliceEyeLoc, AliceViewPointRot);
        vForwardDir = Normal(vector(AliceViewPointRot));
        RawJoyUp = AlicePlayerInput(PlayerInput).GetRawJoyUp();
        if (MyAlicePawn.ArcheTypeID == 3)
        {
            InForwardAccel = vect(0.0, 0.0, 0.0);
        }
        else
        {
            InForwardAccel = vForwardDir * RawJoyUp * float(180);
        }
    }
    
    function UpdateAccel(float DeltaTime, out Vector vAccel)
    {
        local Vector ForwardAccel, RightAccel;
        
        if (Pawn == none || AlicePawn(Pawn) == none || PlayerCamera == none)
        {
            return;
        }
        UpdateForwardAccel(ForwardAccel);
        UpdateRightAccel(RightAccel);
        vAccel = ForwardAccel + RightAccel;
        if (VSize(vAccel) < float(1))
        {
            MyAlicePawn.Velocity *= 1.0 - DeltaTime;
            if (VSize(MyAlicePawn.Velocity) < Abs(MyAlicePawn.FloatDownGravityZ))
            {
                MyAlicePawn.Velocity.Z = MyAlicePawn.FloatDownGravityZ;
            }
        }
    }
    
    event GetFloatAnimInfo(out float UpWeight, out float RightWeight)
    {
        local Vector AliceEyeLoc;
        local Rotator AliceViewPointRot;
        local bool bPawnFaceToCamera;
        
        UpWeight = AlicePlayerInput(PlayerInput).GetRawJoyUp();
        RightWeight = AlicePlayerInput(PlayerInput).GetRawJoyRight();
        AlicePawn(Pawn).GetActorEyesViewPoint(AliceEyeLoc, AliceViewPointRot);
        bPawnFaceToCamera = vector(AliceViewPointRot) Dot vector(Pawn.Rotation) < float(0);
        if (bPawnFaceToCamera)
        {
            UpWeight *= float(-1);
            RightWeight *= float(-1);
        }
        if (MyAlicePawn.ArcheTypeID == 3)
        {
            UpWeight = Abs(UpWeight);
            RightWeight = 0.0;
        }
    }
    
    Stop;
}

state PlayerSlide
{
    function Bump(Actor Other, PrimitiveComponent OtherComp, Vector HitNormal)
    {
        if (GameBreakableActor(Other) != none)
        {
            Other.TakeDamage(int(MyAlicePawn.SlideBumpDamage), self, MyAlicePawn.Location, vector(MyAlicePawn.Rotation), class'DmgType_SlideBumpDamage');
        }
    }
    
    function ProcessMove(float DeltaTime, Vector newAccel, EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
    {
        if (Pawn == none)
        {
            return;
        }
        if (Role == 3)
        {
            Pawn.SetRemoteViewPitch(Rotation.Pitch);
        }
        Pawn.Acceleration = newAccel;
        UpdateSlideEmitter();
        if (!bCanJumpWhenSlide || !bPressedJump && Pawn != none)
        {
            if (VSize(Pawn.Velocity) > 0.0)
            {
                StartSlideParticle();
            }
            else
            {
                EndSlideParticle();
            }
        }
        if (bCanJumpWhenSlide)
        {
        }
    }
    
    function Vector GetInputStrength(out Vector NewSlope, out Vector HitNormal)
    {
        local Actor HitActor;
        local TraceHitInfo HitInfo;
        local Vector HitLocation, vRight, vUp, vFront, vSlope, SlopeStrength, TurnStrength, BoostStrength, BrakeStrength;
        local float RawJoyRight, RawJoyUp, JoyRight;
        
        GetAxes(Pawn.Rotation, vFront, vRight, vUp);
        HitActor = Trace(HitLocation, HitNormal, Pawn.Location + vUp * float(-200), Pawn.Location, true, Pawn.GetCollisionExtent(), HitInfo, 8);
        if (HitActor != none)
        {
            vSlope = vect(0.0, 0.0, -1.0) + HitNormal;
            NewSlope = vSlope;
            RawJoyRight = AlicePlayerInput(PlayerInput).GetRawJoyRight();
            RawJoyUp = AlicePlayerInput(PlayerInput).GetRawJoyUp();
            AlicePawn(Pawn).InputJoyRight = RawJoyRight;
            AlicePawn(Pawn).InputJoyUp = RawJoyUp;
            Pawn.GroundSpeed = AlicePawn(Pawn).SlideSpeed;
            SlopeStrength = vSlope * float(1000);
            BrakeStrength = FMin(0.0, RawJoyUp) * AlicePawn(Pawn).SlideBrakeSpeed * Pawn.Velocity;
            BoostStrength = FMax(0.0, RawJoyUp) * AlicePawn(Pawn).SlideBoostSpeed * vSlope;
            JoyRight = RawJoyRight * 0.2;
            TurnStrength = vRight * JoyRight * AlicePawn(Pawn).SlideTurnSpeed;
            TurnStrength = TurnStrength - FMin(TurnStrength Dot Normal(SlopeStrength), 0.0) * Normal(SlopeStrength);
            return SlopeStrength + TurnStrength + BrakeStrength + BoostStrength;
        }
        else
        {
            GotoState('PlayerWalking');
            return vect(0.0, 0.0, 0.0);
        }
    }
    
    function UpdateAccel(float DeltaTime, out Vector vAccel, out Vector NewSlope, out Vector HitNormal)
    {
        if (bCanControlWhenSlide)
        {
            vAccel = GetInputStrength(NewSlope, HitNormal);
        }
    }
    
    function PlayerMove(float DeltaTime)
    {
        local Vector newAccel, NewSlope, NewHitNormal, X, Y, Z;
        local EDoubleClickDir DoubleClickMove;
        local Rotator DeltaRot, TargetRot;
        
        if (Pawn == none)
        {
            GotoState('Dead');
        }
        else
        {
            if (!IsOnSlidePlatform())
            {
                GotoState('PlayerWalking');
            }
            if (bShrinkingModeActive)
            {
                UnShrinking();
            }
            UpdateAccel(DeltaTime, newAccel, NewSlope, NewHitNormal);
            Pawn.Velocity = Pawn.Velocity - FMin(Pawn.Velocity Dot NewHitNormal, 0.0) * NewHitNormal;
            DoubleClickMove = PlayerInput.CheckForDoubleClickMove(DeltaTime / WorldInfo.TimeDilation);
            bDoubleJump = false;
            if (VSize(Pawn.Velocity) > MyAlicePawn.SlideMinSpeedToRotate)
            {
                TargetRot = rotator(Normal(Pawn.Velocity));
                GetAxes(TargetRot, X, Y, Z);
                TargetRot.Roll = int(Atan2(NewHitNormal Dot Y, NewHitNormal Dot Z) / 3.1415927 * float(32768));
                Pawn.SetDesiredRotation(TargetRot, false, false, MyAlicePawn.SlideTurnCorrectionTime);
            }
            if (slideLoopAudio != none && AlicePawn(Pawn) != none)
            {
                slideLoopAudio.AdjustVolume(0.0, VSize(Pawn.Velocity) / AlicePawn(Pawn).SlideBoostSpeed);
            }
            UpdateRotation(DeltaTime);
            if (Role < 3)
            {
                ReplicateMove(DeltaTime, newAccel, DoubleClickMove, DeltaRot);
            }
            else
            {
                ProcessMove(DeltaTime, newAccel, DoubleClickMove, DeltaRot);
            }
        }
    }
    
    event EndState(name NextStateName)
    {
        AlicePawn(Pawn).StopSlideCameraAnim();
        MyAlicePawn.bForceDesiredRotation = false;
        MyAlicePawn.bRollToDesired = false;
        EndSlideParticle();
        MyAlicePawn.TriggerContextEventClass(8, 1);
        slideLoopAudio.FadeOut(0.1, 0.0);
    }
    
    event BeginState(name PreviousStateName)
    {
        RecoverToDefaultStatus();
        Pawn.SetPhysics(15);
        MyAlicePawn.SetPawnStance(5);
        AlicePawn(Pawn).PlaySlideCameraAnim();
        MyAlicePawn.SlideState = 0;
        MyAlicePawn.bForceDesiredRotation = true;
        MyAlicePawn.bRollToDesired = true;
        MyAlicePawn.TriggerContextEventClass(8, 0);
        if (slideLoopAudio == none)
        {
            slideLoopAudio = CreateAudioComponent(slideLoopSoundCue);
        }
        slideLoopAudio.Play();
        slideLoopAudio.AdjustVolume(0.0, 0.0);
    }
    
    exec function ChangeShrinkingMode()
    {
    }
    
    exec function ChangeCameraMode(bool bToggleTargeting)
    {
    }
    
    exec function StartFire(optional byte FireModeNum)
    {
    }
    
    function MeleeFire()
    {
    }
    
    Stop;
}

state PlayerLockOnTarget extends PlayerWalking
{
    event EndState(name NextStateName)
    {
        GroundPitch = 0;
        if (Pawn != none)
        {
            Pawn.SetRemoteViewPitch(0);
        }
        if (MyAlicePawn.IsShieldBlocking() && !(MyAlicePawn.IsDoingSpecialMove(47) && MyAlicePawn.CurrentDmgStrength > 2) || MyAlicePawn.IsDoingSpecialMove(46))
        {
            LogInternal("&&& turn block OFF");
            OnDeactivateShieldBlocking();
            if (ASM_DeflectTransition(MyAlicePawn.SpecialMoves[46]).bStart)
            {
                MyAlicePawn.DoSpecialMove(46, true);
            }
        }
        LockOnModeDeactivated();
        TMode_CombatLockOn.PostLockOff();
        TMode_BreakableActor.PostLockOff();
        TMode_SkeletalMeshActor.PostLockOff();
        LockonModeDeltaYaw = 0;
    }
    
    event BeginState(name PreviousStateName)
    {
        local WeaponForAlice AliceWeapon;
        
        DoubleClickDir = 0;
        bPressedJump = false;
        GroundPitch = 0;
        if (Pawn != none)
        {
            if (Pawn.Physics != 2 && Pawn.Physics != 17 && Pawn.Physics != 10 && Pawn.Physics != 14)
            {
                Pawn.SetPhysics(1);
            }
        }
        MyAlicePawn.TriggerDressPhysic(false, 0.0);
        MyAlicePawn.ResetRotation();
        SwitchToMovementState(1);
        MyAlicePawn.SetPawnStance(1);
        AliceWeapon = WeaponForAlice(MyAlicePawn.Weapon);
        if (AliceWeapon == none)
        {
            SwitchToBestWeapon();
        }
        if (!MyAlicePawn.IsDoingSpecialMove(34))
        {
            MyAlicePawn.FadeInWeapon();
        }
        if (AliceWeapon != none)
        {
            AliceWeapon.bInUse = true;
            MyAlicePawn.ClearTimerToHideWeapon();
        }
        bLockOnStateFirstFrame = true;
        MyAlicePawn.bCombatToStrafeCamWait = false;
        bCanDoDeflect = true;
    }
    
    function PlayerMove(float DeltaTime)
    {
        local Vector newAccel;
        local EDoubleClickDir DoubleClickMove;
        local Rotator DeltaRot;
        local bool bSaveJump;
        
        if (Pawn == none)
        {
            GotoState('Dead');
        }
        else if (AlicePawn(Pawn).bFloatDown)
        {
            GotoState('PlayerFloat');
        }
        else
        {
            if (TargetBActorInfo.BActor != none)
            {
                TargetBActorInfo.vLocation = TargetBActorInfo.BActor.StaticMeshComponent.Bounds.Origin;
            }
            if (IsOnSlidePlatform() && !MyAlicePawn.IsMeleeFiring())
            {
                MyAlicePawn.StopWeaponFire();
                MyAlicePawn.FadeOutWeapon();
                GotoState('PlayerSlide');
                return;
            }
            ProjectInputToCameraSpace();
            UpdateCameraTargetingMode(DeltaTime);
            if (MyAlicePawn.IsShieldBlocking())
            {
                if (!MyAlicePawn.IsDoingSpecialMove(46) && !MyAlicePawn.IsDoingSpecialMove(47))
                {
                    if (MyAlicePawn.bCanDeflect && !MyAlicePawn.bIsDeflectSpinning && MyAlicePawn.DeflectTime < MyAlicePawn.MaxDeflectSpinningTime)
                    {
                        MyAlicePawn.DoSpecialMove(48, true);
                    }
                    MyAlicePawn.DeflectTime += DeltaTime;
                }
                if (MyAlicePawn.DeflectTime > MyAlicePawn.MaxDeflectTime && MyAlicePawn.MaxDeflectTime > float(0) || MyAlicePawn.bTryToEndDeflectBeforeMinTime && MyAlicePawn.DeflectTime > MyAlicePawn.MinDeflectTime)
                {
                    TriggerBlock(false);
                    return;
                }
            }
            UpdateAccel(DeltaTime, newAccel);
            Pawn.GroundSpeed = AlicePawn(Pawn).MaxRunningSpeed;
            DoubleClickMove = PlayerInput.CheckForDoubleClickMove(DeltaTime / WorldInfo.TimeDilation);
            bDoubleJump = false;
            if (bPressedJump && Pawn.CannotJumpNow() || bTargetingModeActive)
            {
                bSaveJump = true;
                bPressedJump = false;
            }
            else
            {
                if (bPressedJump && Pawn.GroundSpeed > AlicePawn(Pawn).MaxWalkingSpeed)
                {
                    AlicePawn(Pawn).bIsRunningJump = true;
                }
                bSaveJump = false;
            }
            if (IsLockOnBActor() || IsLockOnNPC())
            {
                if (!MyAlicePawn.IsCurAbilityCamera(MyAlicePawn.CombatCamera))
                {
                    MyAlicePawn.SaveCurCameraDistFOVInfo();
                    if (MyAlicePawn.IsCurAbilityCamera(MyAlicePawn.StrafeCamera))
                    {
                        MyAlicePawn.SetAliceAbilityCamera(MyAlicePawn.StrafeCamera, true);
                    }
                    MyAlicePawn.SetAliceAbilityCamera(MyAlicePawn.CombatCamera, false, false);
                    MyAlicePawn.AliceForcePlayCameraAnim(MyAlicePawn.CombatCamera.Animation, true);
                    MyAlicePawn.SwitchLockOnCamera(true);
                    MyAlicePawn.bCombatToStrafeCamWait = false;
                    bLockOnStateFirstFrame = true;
                }
            }
            else if (!MyAlicePawn.IsCurAbilityCamera(MyAlicePawn.StrafeCamera))
            {
                if (!MyAlicePawn.bCombatToStrafeCamWait && MyAlicePawn.IsCurAbilityCamera(MyAlicePawn.CombatCamera))
                {
                    MyAlicePawn.StartCombatToStrafeCamBlendDelay();
                }
                if (MyAlicePawn.EnableSwitchLockOnCamera(DeltaTime) || !MyAlicePawn.IsCurAbilityCamera(MyAlicePawn.CombatCamera))
                {
                    MyAlicePawn.SaveCurCameraDistFOVInfo();
                    if (MyAlicePawn.IsCurAbilityCamera(MyAlicePawn.CombatCamera))
                    {
                        MyAlicePawn.SetAliceAbilityCamera(MyAlicePawn.CombatCamera, true, false);
                        MyAlicePawn.AliceForceStopCameraAnim(MyAlicePawn.CombatCamera.Animation);
                        MyAlicePawn.SwitchLockOnCamera(false);
                        MyAlicePawn.bCombatToStrafeCamBlend = true;
                    }
                    else
                    {
                        MyAlicePawn.bCombatToStrafeCamBlend = false;
                    }
                    MyAlicePawn.SetAliceAbilityCamera(MyAlicePawn.StrafeCamera);
                    MyAlicePawn.SaveTargetCameraDistFOVInfo();
                    MyAlicePawn.LoadCurCameraDistFOVInfo();
                    MyAlicePawn.bCombatToStrafeCamWait = false;
                }
            }
            if (MyAlicePawn.bAllowFacingTargetInSpeicalMove || !MyAlicePawn.IsDoingASpecialMove())
            {
                UpdateDeltaRotation(DeltaTime, newAccel, DeltaRot);
            }
            if (Role < 3)
            {
                ReplicateMove(DeltaTime, newAccel, DoubleClickMove, DeltaRot);
            }
            else
            {
                ProcessMove(DeltaTime, newAccel, DoubleClickMove, DeltaRot);
            }
            UpdateRotation(DeltaTime);
            bPressedJump = bSaveJump;
            if (bShrinkingModeActive && SonarManager.bActive)
            {
            }
            else
            {
                SonarManager.PostUpdate(DeltaTime);
            }
        }
    }
    
    function ProcessMove(float DeltaTime, Vector newAccel, EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
    {
        if (Pawn == none)
        {
            return;
        }
        if (bIsHoldingPOIButton)
        {
            Pawn.Acceleration = vect(0.0, 0.0, 0.0);
            Pawn.Velocity = vect(0.0, 0.0, 0.0);
            return;
        }
        if (Role == 3)
        {
            Pawn.SetRemoteViewPitch(Rotation.Pitch);
        }
        Pawn.Acceleration = newAccel;
        CheckJumpOrDuck();
    }
    
    event UpdateLockonDeltaRot()
    {
        local Vector NewDir;
        local Rotator NewRot;
        
        if (MyAlicePawn.bAllowFacingTargetInSpeicalMove && IsPlayerPawnFarEnoughFromTarget() || !MyAlicePawn.IsDoingASpecialMove())
        {
            if (TargetingActor != none && TargetingActor == TargetNPCSocket.Pawn)
            {
                NewDir = TargetingActor.Location - Pawn.Location;
                NewDir.Z = 0.0;
                NewDir = Normal(NewDir);
                NewRot = rotator(NewDir);
                LockonModeDeltaYaw = NewRot.Yaw - Pawn.Rotation.Yaw;
            }
            else if (TargetingActor != none && TargetingActor == TargetBActorInfo.BActor)
            {
                NewDir = TargetBActorInfo.vLocation - Pawn.Location;
                NewDir.Z = 0.0;
                NewDir = Normal(NewDir);
                NewRot = rotator(NewDir);
                LockonModeDeltaYaw = NewRot.Yaw - Pawn.Rotation.Yaw;
            }
            else if (TargetingActor != none && TargetingActor == TargetSMAInfo.Actor)
            {
                NewDir = TargetSMAInfo.CollisionLockOnLoc - Pawn.Location;
                NewDir.Z = 0.0;
                NewDir = Normal(NewDir);
                NewRot = rotator(NewDir);
                LockonModeDeltaYaw = NewRot.Yaw - Pawn.Rotation.Yaw;
            }
            else if (TargetingActor == none)
            {
                LockonModeDeltaYaw = 0;
            }
        }
        else
        {
            LockonModeDeltaYaw = 0;
        }
    }
    
    function bool IsPlayerPawnFarEnoughFromTarget()
    {
        local float fDist, fDistThreshold;
        local Pawn TargetPawn;
        
        TargetPawn = Pawn(TargetingActor);
        if (TargetPawn != none && Pawn != none)
        {
            fDistThreshold = TargetPawn.CylinderComponent.CollisionRadius + Pawn.CylinderComponent.CollisionRadius + MyAlicePawn.AdditionalOffsetForAutoRotateDistanceCheck;
            fDist = VSize2D(TargetPawn.Location - Pawn.Location);
            if (fDist > fDistThreshold)
            {
                return true;
            }
            else
            {
                return false;
            }
        }
        return true;
    }
    
    exec function ShieldBeakButtonReleasedWhenLockOn()
    {
        ReleaseInputButton();
    }
    
    exec function ShieldBeakButtonPressedWhenLockOn()
    {
        local ButtonInputStatus ABtnStatus;
        
        ABtnStatus.BtnType = 1;
        ABtnStatus.ButtonName = 'ShieldBreak button';
        ABtnStatus.TapTime = 0.2;
        ABtnStatus.HoldTime = 1.5;
        PressInputButton(ABtnStatus);
    }
    
    function OnDeactivateShieldBlocking()
    {
        IgnoreMoveInput(false);
        DelayNextDeflect();
        MyAlicePawn.SetCollisionSize(MyAlicePawn.default.CylinderComponent.CollisionRadius, MyAlicePawn.CylinderComponent.CollisionHeight);
    }
    
    function OnActivateShieldBlocking()
    {
        StopRangeFire();
        IgnoreMoveInput(true);
        MyAlicePawn.FadeOutWeapon();
        MyAlicePawn.Acceleration = vect(0.0, 0.0, 0.0);
        MyAlicePawn.DeflectTime = 0.0;
        MyAlicePawn.bTryToEndDeflectBeforeMinTime = false;
        bCanDoDeflect = false;
        MyAlicePawn.TriggerContextEventClass(12, 0);
        MyAlicePawn.ClearDelayAttachWeapon();
        MyAlicePawn.SetCollisionSize(MyAlicePawn.CylinderRadiusWhileDeflect, MyAlicePawn.CylinderComponent.CollisionHeight);
        MyAlicePawn.SetLocation(MyAlicePawn.Location + 0.1 * vector(MyAlicePawn.Rotation));
    }
    
    exec function DodgePC(bool bActive)
    {
        if (bActive && !MyAlicePawn.bInShield)
        {
            if (AlicePlayerInput(PlayerInput).IsKeyPressed('A'))
            {
                DoDodge(3);
            }
            else if (AlicePlayerInput(PlayerInput).IsKeyPressed('D'))
            {
                DoDodge(4);
            }
            else if (AlicePlayerInput(PlayerInput).IsKeyPressed('W'))
            {
                DoDodge(1);
            }
            else if (AlicePlayerInput(PlayerInput).IsKeyPressed('S'))
            {
                DoDodge(2);
            }
            else
            {
                LogInternal("&&& turn block ON");
                OnActivateShieldBlocking();
                MyAlicePawn.DoSpecialMove(46, true);
            }
        }
        else
        {
            TriggerDodge(false);
        }
    }
    
    exec function TriggerBlock(bool bActive)
    {
        if (!canBlock())
        {
            return;
        }
        if (MyAlicePawn.IsDoingSpecialMove(46))
        {
            if (MyAlicePawn.IsDoingSpecialMove(46) && !bActive)
            {
                MyAlicePawn.bTryToEndDeflectBeforeMinTime = true;
            }
            return;
        }
        if (bActive && !MyAlicePawn.bInShield)
        {
            if (!MyAlicePawn.IsDoingSpecialMove(37) && bCanDoDeflect)
            {
                LogInternal("&&& turn block ON");
                OnActivateShieldBlocking();
                MyAlicePawn.DoSpecialMove(46, true);
            }
        }
        else if (!bActive && MyAlicePawn.bInShield)
        {
            if (MyAlicePawn.DeflectTime < MyAlicePawn.MinDeflectTime)
            {
                MyAlicePawn.bTryToEndDeflectBeforeMinTime = true;
                return;
            }
            LogInternal("&&& turn block OFF");
            OnDeactivateShieldBlocking();
            MyAlicePawn.DoSpecialMove(46, true);
        }
    }
    
    function bool canBlock()
    {
        if (!AliceCheatManager(CheatManager).canBlock() || !MyAlicePawn.bCanBlock)
        {
            return false;
        }
        if (AlicePlayerInput(PlayerInput).bDisableInputInCinematic || MyAlicePawn.bIsDoingContextAction || MyAlicePawn.CurrentContextActor != none || MyAlicePawn.bInGiantMode || MyAlicePawn.IsInShadowMode() || bLookingAtPointOfInterest)
        {
            return false;
        }
        if (MyAlicePawn.bInJumpPad || MyAlicePawn.IsDoingSpecialMove(49) || MyAlicePawn.IsDoingSpecialMove(50) || MyAlicePawn.IsDoingSpecialMove(52) || MyAlicePawn.bIsTurning || AlicePawn(Pawn).isInConversationMode())
        {
            return false;
        }
        if (IsDoingSpecialMove(39) || IsDoingSpecialMove(40) || IsDoingSpecialMove(43) || IsDoingSpecialMove(36) || IsDoingSpecialMove(34) || IsDoingSpecialMove(24) || IsDoingSpecialMove(25))
        {
            return false;
        }
        if (IsDoingSpecialMove(41) || IsDoingSpecialMove(42) || IsDoingSpecialMove(43))
        {
            return false;
        }
        if ((MyAlicePawn.bIsJumping || IsDoingSpecialMove(50) || MyAlicePawn.Physics == 2) && MyAlicePawn.bHasDodgeInAir)
        {
            return false;
        }
        return true;
    }
    
    exec function TriggerDodge(bool bActive)
    {
        if (bActive)
        {
            if (MyAlicePawn.bInShield)
            {
                MyAlicePawn.bTryToEndDeflectBeforeMinTime = false;
                MyAlicePawn.ActivateShieldBlocking(false);
                MyAlicePawn.FadeOutUmbrella();
                Dodge();
                OnDeactivateShieldBlocking();
            }
            else
            {
                Dodge();
            }
        }
    }
    
    Stop;
}

state Frozen
{
    event EndState(name NextStateName)
    {
        MyAlicePawn.bIsFrozen = false;
        MyAlicePawn.SetPawnStance(0);
        MyAlicePawn.PlaySound(MyAlicePawn.EndFrozenSound);
        MyAlicePawn.PlayFrozenBreakParticle();
        ClearTimer('TurnOnDodgeToEndGrabUI');
        TurnOffDodgeToEndGrabUI();
    }
    
    event BeginState(name PreviousStateName)
    {
        MyAlicePawn.SetPawnStance(7);
        MyAlicePawn.bIsFrozen = true;
        MyAlicePawn.CurFrozenTime = 0.0;
        MyAlicePawn.FadeOutWeapon();
        SetTimer(MyAlicePawn.DelayTimeToShowDodgeToEscapeUI, false, 'TurnOnDodgeToEndGrabUI');
        MyAlicePawn.PlaySound(MyAlicePawn.StartFrozenSound);
        MyAlicePawn.PlayFrozenParticle();
    }
    
    function PlayerMove(float DeltaTime)
    {
        local Vector newAccel;
        local EDoubleClickDir DoubleClickMove;
        local Rotator DeltaRot;
        
        if (Pawn == none)
        {
            GotoState('Dead');
        }
        else
        {
            ProjectInputToCameraSpace();
            MyAlicePawn.Acceleration = vect(0.0, 0.0, 0.0);
            MyAlicePawn.CurFrozenTime += DeltaTime;
            if (MyAlicePawn.CurFrozenTime > MyAlicePawn.MaxFrozenTime)
            {
                MyAlicePawn.EndFrozen();
                return;
            }
            DoubleClickMove = PlayerInput.CheckForDoubleClickMove(DeltaTime / WorldInfo.TimeDilation);
            if (Role < 3)
            {
                ReplicateMove(DeltaTime, newAccel, DoubleClickMove, DeltaRot);
            }
            else
            {
                ProcessMove(DeltaTime, newAccel, DoubleClickMove, DeltaRot);
            }
            UpdateRotation(DeltaTime);
        }
    }
    
    function ProcessMove(float DeltaTime, Vector newAccel, EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
    {
        if (Role == 3)
        {
            Pawn.SetRemoteViewPitch(Rotation.Pitch);
        }
        Pawn.Acceleration = newAccel;
        Pawn.SetRotation(Pawn.Rotation + DeltaRot);
    }
    
    exec function TriggerDodge(bool bActive)
    {
        if (bActive)
        {
            Dodge();
            MyAlicePawn.EndFrozen();
        }
    }
    
    exec function EyeStaffFireRelease()
    {
    }
    
    exec function EyeStaffFirePress()
    {
    }
    
    exec function HobbyHorseFireRelease()
    {
    }
    
    exec function HobbyHorseFirePress()
    {
    }
    
    exec function TeapotCannonFireRelease()
    {
    }
    
    exec function TeapotCannonFirePress()
    {
    }
    
    exec function VorpalBladeFireRelease()
    {
    }
    
    exec function VorpalBladeFirePress()
    {
    }
    
    exec function ChangeCameraMode(bool bToggleTargeting)
    {
    }
    
    Stop;
}

state AttachedByNPCs
{
    event EndState(name NextStateName)
    {
        MyAlicePawn.AttachedNPCScareAliceSoundComp.Stop();
        ClearTimer('PlayAliceScareSound');
        MyAlicePawn.SetPawnStance(0);
        MyAlicePawn.bStopAtLedges--;
        ClearTimer('TakeDurationDamage');
        ClearTimer('TurnOnDodgeToEndGrabUI');
        TurnOffDodgeToEndGrabUI();
    }
    
    event BeginState(name PreviousStateName)
    {
        local AlicePlayer_MovementStateBase PlayerState;
        
        PlayerState = GetCurrentMovementState();
        PlayerState.RevertToIdle(0.0);
        MyAlicePawn.SetPawnStance(2);
        MyAlicePawn.bStopAtLedges++;
        MyAlicePawn.FadeOutWeapon();
        MyAlicePawn.DoSpecialMove(45, true);
        PlayAliceScareSound();
        SetTimer(MyAlicePawn.TimeDelayToCauseDamageWhenNPCAttached, false, 'TakeDurationDamage');
        SetTimer(MyAlicePawn.DelayTimeToShowDodgeToEscapeUI, false, 'TurnOnDodgeToEndGrabUI');
        MyAlicePawn.ClearDelayAttachWeapon();
    }
    
    function UpdateAttachedNPC(float DeltaTime)
    {
        local int I;
        local Vector DestLoc, CurLoc;
        local Rotator DestRot, curRot;
        local float factor;
        
        for (I = 0; I < MyAlicePawn.AttachNPCSockets.Length; I++)
        {
            if (MyAlicePawn.AttachNPCSockets[I].AttachedNPC != none && MyAlicePawn.AttachNPCSockets[I].bOccupied)
            {
                MyAlicePawn.Mesh.GetSocketWorldLocationAndRotation(MyAlicePawn.AttachNPCSockets[I].SocketName, DestLoc, DestRot);
                if (MyAlicePawn.AttachNPCSockets[I].AttachedNPC.bInterpolatingAttchedPosition)
                {
                    factor = MyAlicePawn.AttachNPCSockets[I].AttachedNPC.fTimeInterpolatingAttachedPosition / MyAlicePawn.AttachNPCSockets[I].AttachedNPC.InterpolationTimeWhenStartAttaching;
                    if (factor >= 1.0)
                    {
                        MyAlicePawn.AttachNPCSockets[I].AttachedNPC.bInterpolatingAttchedPosition = false;
                        MyAlicePawn.AttachNPCSockets[I].AttachedNPC.SetLocation(DestLoc);
                        MyAlicePawn.AttachNPCSockets[I].AttachedNPC.SetRotation(DestRot);
                    }
                    else
                    {
                        CurLoc = VLerp(MyAlicePawn.AttachNPCSockets[I].AttachedNPC.StartLocationInterpolatingAttachToAlice, DestLoc, factor);
                        MyAlicePawn.AttachNPCSockets[I].AttachedNPC.SetLocation(CurLoc);
                        curRot = RLerp(MyAlicePawn.AttachNPCSockets[I].AttachedNPC.StartRotationInterpolatingAttachToAlice, DestRot, factor);
                        MyAlicePawn.AttachNPCSockets[I].AttachedNPC.SetRotation(curRot);
                        MyAlicePawn.AttachNPCSockets[I].AttachedNPC.fTimeInterpolatingAttachedPosition += DeltaTime;
                    }
                    continue;
                }
                MyAlicePawn.AttachNPCSockets[I].AttachedNPC.SetLocation(DestLoc);
                MyAlicePawn.AttachNPCSockets[I].AttachedNPC.SetRotation(DestRot);
            }
        }
    }
    
    function PlayerMove(float DeltaTime)
    {
        local Vector newAccel;
        local EDoubleClickDir DoubleClickMove;
        local Rotator DeltaRot;
        local Vector PawnFacing;
        
        if (Pawn == none)
        {
            GotoState('Dead');
        }
        else
        {
            ProjectInputToCameraSpace();
            if (MyAlicePawn.bIsTurning)
            {
                UpdateRotation(DeltaTime);
                return;
            }
            UpdateCameraTargetingMode(DeltaTime);
            PawnFacing = vector(Pawn.Rotation);
            AngleBetweenInputAndPlayer = CalcAngleBetweenVectors(PawnFacing, AlicePlayerInput(PlayerInput).InputVector);
            PawnDirWhenRotateStarts = PawnFacing;
            UpdateAccel(DeltaTime, newAccel);
            if (VSize(newAccel) < AccelThresholdToRun)
            {
                MyAlicePawn.GroundSpeed = MyAlicePawn.MaxWalkingSpeed;
            }
            else
            {
                MyAlicePawn.GroundSpeed = MyAlicePawn.MaxRunningSpeed;
            }
            MyAlicePawn.GroundSpeed /= float(1 + MyAlicePawn.NbOfAttachedNPC);
            DoubleClickMove = PlayerInput.CheckForDoubleClickMove(DeltaTime / WorldInfo.TimeDilation);
            if (!MyAlicePawn.bIsTurning)
            {
                UpdateDeltaRotation(DeltaTime, newAccel, DeltaRot);
            }
            if (Role < 3)
            {
                ReplicateMove(DeltaTime, newAccel, DoubleClickMove, DeltaRot);
            }
            else
            {
                ProcessMove(DeltaTime, newAccel, DoubleClickMove, DeltaRot);
            }
            UpdateRotation(DeltaTime);
            UpdateAttachedNPC(DeltaTime);
        }
    }
    
    function ProcessMove(float DeltaTime, Vector newAccel, EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
    {
        if (Role == 3)
        {
            Pawn.SetRemoteViewPitch(Rotation.Pitch);
        }
        Pawn.Acceleration = newAccel;
        Pawn.SetRotation(Pawn.Rotation + DeltaRot);
    }
    
    function UpdateDeltaRotation(float DeltaTime, Vector vAccel, out Rotator Rot)
    {
        local float fSign, RotSpeedFactor, DeltaYaw, Temp;
        
        Rot.Pitch = 0;
        Rot.Roll = 0;
        Rot.Yaw = 0;
        Temp = AlicePawn(Pawn).AngleToRotate;
        if (VSize(vAccel) > float(0))
        {
            if (Abs(AngleBetweenInputAndPlayer) < 0.017453292)
            {
                return;
            }
            fSign = AngleBetweenInputAndPlayer / Abs(AngleBetweenInputAndPlayer);
            if (AlicePawn(Pawn).bTurningWhileRunning)
            {
                DeltaYaw = AlicePawn(Pawn).RotSpeedFactor * 4.0 * fSign * DeltaTime / float(1 + MyAlicePawn.NbOfAttachedNPC);
            }
            else if (Abs(AngleBetweenInputAndPlayer) < AngleThresholdToCancelAccel)
            {
                RotSpeedFactor = VSize(Pawn.Velocity) / AlicePawn(Pawn).MaxWalkingSpeed;
                DeltaYaw = AlicePawn(Pawn).RotSpeedFactor * RotSpeedFactor * fSign * DeltaTime / float(1 + MyAlicePawn.NbOfAttachedNPC);
            }
            if (Abs(DeltaYaw) > Abs(AngleBetweenInputAndPlayer))
            {
                DeltaYaw = AngleBetweenInputAndPlayer;
            }
            Rot.Yaw = int(DeltaYaw * float(10430));
        }
        else if (Abs(Temp) > float(0))
        {
            Rot.Yaw = 0;
        }
    }
    
    function UpdateAccel(float DeltaTime, out Vector vAccel)
    {
        local bool bCannotMove, bShouldDoInstantTurning;
        
        MyAlicePawn.MaxRunningSpeed = MyAlicePawn.default.MaxRunningSpeed;
        if (Abs(AngleBetweenInputAndPlayer) > MyAlicePawn.AngleToFastTurn && VSize2D(Pawn.Velocity) == float(0))
        {
            bShouldDoInstantTurning = true;
        }
        bCannotMove = MyAlicePawn.bIsTurning || Abs(AngleBetweenInputAndPlayer) > AngleThresholdToCancelAccel || AlicePawn(Pawn).bIsBraking || bShouldDoInstantTurning;
        if (bCannotMove && !MyAlicePawn.bTurningWhileRunning)
        {
            vAccel = vect(0.0, 0.0, 0.0);
        }
        else
        {
            vAccel = AlicePlayerInput(PlayerInput).InputVector;
        }
        if (MyAlicePawn.bForceMaxAccel)
        {
            vAccel = MyAlicePawn.AccelRate * Normal(vAccel);
        }
        InputaUp = PlayerInput.aUp;
    }
    
    function PlayAliceScareSound()
    {
        MyAlicePawn.AttachedNPCScareAliceSoundComp.Play();
    }
    
    function TakeDurationDamage()
    {
        local float dmg;
        local int I, J;
        local Emitter DamageEmitter;
        
        if (!MyAlicePawn.bInHysteriaMode)
        {
            for (I = 0; I < MyAlicePawn.AttachNPCSockets.Length; I++)
            {
                if (MyAlicePawn.AttachNPCSockets[I].AttachedNPC != none && MyAlicePawn.AttachNPCSockets[I].bOccupied)
                {
                    dmg += MyAlicePawn.AttachNPCSockets[I].AttachedNPC.DamagePerTimeUnitWhenAttached;
                    J = I;
                }
            }
            if (dmg > float(0))
            {
                MyAlicePawn.StopHealthDamageEffect(false, MyAlicePawn.HealthLevels[3].HealthSound, MyAlicePawn.HealthLevels[3].HealthCameraAnim);
                MyAlicePawn.PlayHealthDamageEffect(false, MyAlicePawn.HealthLevels[3].HealthSound, MyAlicePawn.HealthLevels[3].HealthCameraAnim, true);
                MyAlicePawn.CurrentDmgStrength = 1;
                MyAlicePawn.TakeDamage(int(dmg), MyAlicePawn.AttachNPCSockets[J].AttachedNPC.Controller, MyAlicePawn.Location, vector(MyAlicePawn.Rotation), class'Engine.DmgType_Fell');
            }
            for (I = 0; I < MyAlicePawn.AttachNPCSockets.Length; I++)
            {
                if (MyAlicePawn.AttachNPCSockets[I].AttachedNPC != none && MyAlicePawn.AttachNPCSockets[I].AttachedNPC.DamageParticleWhenAttached != none)
                {
                    DamageEmitter = Spawn(class'Engine.EmitterSpawnable', self, , MyAlicePawn.AttachNPCSockets[I].AttachedNPC.Location, MyAlicePawn.AttachNPCSockets[I].AttachedNPC.Rotation);
                    if (DamageEmitter != none)
                    {
                        DamageEmitter.SetLocation(MyAlicePawn.AttachNPCSockets[I].AttachedNPC.Location);
                        DamageEmitter.SetRotation(MyAlicePawn.AttachNPCSockets[I].AttachedNPC.Rotation);
                        DamageEmitter.SetTemplate(MyAlicePawn.AttachNPCSockets[I].AttachedNPC.DamageParticleWhenAttached, true);
                    }
                }
            }
        }
        MyAlicePawn.AttachedNPCScareAliceSoundComp.Stop();
        SetTimer(MyAlicePawn.AttachedNPCScareAliceSoundRepeatDelay, false, 'PlayAliceScareSound');
        MyAlicePawn.PlaySound(MyAlicePawn.AttachedNPCBiteAliceSoundCue);
        MyAlicePawn.PlaySound(MyAlicePawn.AttachedNPCAliceDamagedSoundCue);
        ClearTimer('TakeDurationDamage');
        SetTimer(MyAlicePawn.TimeIntervalToCauseDamageWhenNPCAttached, false, 'TakeDurationDamage');
    }
    
    exec function TriggerDodge(bool bActive)
    {
        if (bActive)
        {
            Dodge();
            MyAlicePawn.ForceDetachAllNPC();
        }
    }
    
    exec function EyeStaffFireRelease()
    {
    }
    
    exec function EyeStaffFirePress()
    {
    }
    
    exec function HobbyHorseFireRelease()
    {
    }
    
    exec function HobbyHorseFirePress()
    {
    }
    
    exec function TeapotCannonFireRelease()
    {
    }
    
    exec function TeapotCannonFirePress()
    {
    }
    
    exec function VorpalBladeFireRelease()
    {
    }
    
    exec function VorpalBladeFirePress()
    {
    }
    
    exec function ChangeCameraMode(bool bToggleTargeting)
    {
    }
    
    Stop;
}

state Grabbed
{
    event EndState(name NextStateName)
    {
        ClearTimer('TurnOnDodgeToEndGrabUI');
        TurnOffDodgeToEndGrabUI();
        MyAlicePawn.bCanDodgeToEndGrabbed = false;
        SetTimer(MyAlicePawn.TimeDelayToNextBeGrabbed, false, 'ResetAliceCanBeGrabbed');
    }
    
    function InterpolateAlignBoxPosition(float DeltaTime)
    {
        local Vector CurLoc, curFacing;
        local float factor;
        
        if (MyAlicePawn.bGrabAlignBoxPositionReached)
        {
            factor = MyAlicePawn.fTimeInterpolationGrabAlignBoxPosition / MyAlicePawn.fMaxTimeInterpolationGrabAlignBoxPosition;
            MyAlicePawn.GrabAlignLocation = MyAlicePawn.GrabberPawn.GetAlignBoxBonePosition();
            MyAlicePawn.GrabAlignLocation.Z = MyAlicePawn.Location.Z;
            if (factor >= 1.0)
            {
                MyAlicePawn.bGrabAlignBoxPositionReached = false;
                MyAlicePawn.SetLocation(MyAlicePawn.GrabAlignLocation);
                curFacing = vector(MyAlicePawn.GrabberPawn.Rotation) * float(-1);
                MyAlicePawn.SetRotation(rotator(curFacing));
            }
            else
            {
                CurLoc = VLerp(MyAlicePawn.StartGrabLocation, MyAlicePawn.GrabAlignLocation, factor);
                MyAlicePawn.SetLocation(CurLoc);
                MyAlicePawn.fTimeInterpolationGrabAlignBoxPosition += DeltaTime;
            }
        }
    }
    
    function PlayerMove(float DeltaTime)
    {
        if (Pawn == none || !Pawn.IsAliveAndWell())
        {
            GotoState('Dead');
        }
        else
        {
            ProjectInputToCameraSpace();
            InterpolateAlignBoxPosition(DeltaTime);
        }
    }
    
    event BeginState(name PreviousStateName)
    {
        local AlicePlayer_MovementStateBase PlayerState;
        
        PlayerState = GetCurrentMovementState();
        PlayerState.RevertToIdle(0.0);
        if (MyAlicePawn.Weapon != none && MyAlicePawn.Weapon.IsA('WeaponForAliceMelee'))
        {
            WeaponForAliceMelee(MyAlicePawn.Weapon).ResetWeaponInput();
        }
        MyAlicePawn.FadeOutWeapon();
        RecoverToDefaultStatus();
        AngleBetweenInputAndPlayer = 0.0;
        MyAlicePawn.bCanBeGrabbed = false;
    }
    
    exec function TriggerDodge(bool bActive)
    {
        if (!MyAlicePawn.bCanDodgeToEndGrabbed)
        {
            return;
        }
        if (bActive)
        {
            if (MyAlicePawn.GrabberPawn != none)
            {
                AliceGameKynapseAIController(MyAlicePawn.GrabberPawn.Controller).RegisterSphinxEvent(15);
            }
            MyAlicePawn.EndGrabbed();
            Dodge();
            GotoState('PlayerWalking');
        }
    }
    
    exec function EyeStaffFireRelease()
    {
    }
    
    exec function EyeStaffFirePress()
    {
    }
    
    exec function HobbyHorseFireRelease()
    {
    }
    
    exec function HobbyHorseFirePress()
    {
    }
    
    exec function TeapotCannonFireRelease()
    {
    }
    
    exec function TeapotCannonFirePress()
    {
    }
    
    exec function VorpalBladeFireRelease()
    {
    }
    
    exec function VorpalBladeFirePress()
    {
    }
    
    exec function ChangeCameraMode(bool bToggleTargeting)
    {
    }
    
    exec function ChangeShrinkingMode()
    {
    }
    
    Stop;
}

state FirstPersonView
{
    event EndState(name NextStateName)
    {
        bEnterFPSByRSPress = false;
        if (!MyAlicePawn.bInLondon)
        {
            MyAlicePawn.SetPawnStance(0);
            if (NextStateName != 'PlayerSlide')
            {
                MyAlicePawn.SetTimerToHideWeapon();
            }
            MyAlicePawn.bStopSettingAbilityCamera = false;
            MyAlicePawn.SetAliceAbilityCamera(MyAlicePawn.FPSCamera, true);
            bShowFPS_Reticule = false;
            ShowCrossHair(false);
            bFirstPersonViewActive = false;
            MyAlicePawn.bStopAtLedges--;
            MyAlicePawn.ViewPitchMax = MyAlicePawn.default.ViewPitchMax;
            MyAlicePawn.ViewPitchMin = MyAlicePawn.default.ViewPitchMin;
            CheckJumpOrDuck();
            MyAlicePawn.TriggerContextEventClass(5, 1);
        }
        else
        {
            bFirstPersonViewActive = false;
            MyAlicePawn.bStopSettingAbilityCamera = false;
            MyAlicePawn.SetAliceAbilityCamera(MyAlicePawn.FPSCamera, true);
        }
    }
    
    event BeginState(name PreviousStateName)
    {
        SwitchToMovementState(1);
        if (!MyAlicePawn.bInLondon)
        {
            if (EyeStaff(MyAlicePawn.Weapon) == none && TeapotCannon(MyAlicePawn.Weapon) == none)
            {
                if (EyeStaff(MyAlicePawn.InvManager.PendingWeapon) == none && TeapotCannon(MyAlicePawn.InvManager.PendingWeapon) == none)
                {
                    ChangeWeaponToEyeStaff();
                }
            }
            MyAlicePawn.FadeInWeapon();
            bPressedJump = false;
            MyAlicePawn.ClearTimerToHideWeapon();
            MyAlicePawn.WeaponSetHidden(false);
            MyAlicePawn.SetPawnStance(1);
        }
    }
    
    function UpdateRotation(float DeltaTime)
    {
        local Rotator DeltaRot, PawnDeltaRot, ViewRotation;
        
        ViewRotation = Rotation;
        ModifyRotationSpeed(DeltaTime, AlicePlayerInput(PlayerInput).aLookUpInFPS, AlicePlayerInput(PlayerInput).aTurnInFPS);
        DeltaRot.Yaw = int(AlicePlayerInput(PlayerInput).aTurnInFPS);
        DeltaRot.Pitch = int(AlicePlayerInput(PlayerInput).aLookUpInFPS);
        PawnDeltaRot = DeltaRot;
        PawnDeltaRot.Pitch = 0;
        Pawn.SetRotation(Pawn.Rotation + PawnDeltaRot);
        ProcessViewRotation(DeltaTime, ViewRotation, DeltaRot);
        SetRotation(ViewRotation);
    }
    
    function PlayerMove(float DeltaTime)
    {
        local Vector vAccel;
        local float maxStrafeSpeed;
        
        if (!MyAlicePawn.bInLondon)
        {
            if (IsOnSlidePlatform())
            {
                MyAlicePawn.StopWeaponFire();
                MyAlicePawn.FadeOutWeapon();
                GotoState('PlayerSlide');
                return;
            }
        }
        ProjectInputToCameraSpace();
        maxStrafeSpeed = MyAlicePawn.GetMaxStrafeSpeed();
        if (maxStrafeSpeed > float(0))
        {
            MyAlicePawn.MaxRunningSpeed = MyAlicePawn.GetMaxStrafeSpeed();
        }
        vAccel = AlicePlayerInput(PlayerInput).InputVector;
        if (MyAlicePawn.bForceMaxAccel)
        {
            vAccel = MyAlicePawn.AccelRate * Normal(vAccel);
        }
        MyAlicePawn.Acceleration = vAccel;
        MyAlicePawn.GroundSpeed = MyAlicePawn.MaxRunningSpeed;
        UpdateRotation(DeltaTime);
        if (!MyAlicePawn.bInLondon)
        {
            UpdateAimOffset(DeltaTime);
            CheckJumpOrDuck();
        }
        if (bShrinkingModeActive && SonarManager.bActive)
        {
        }
        else
        {
            SonarManager.PostUpdate(DeltaTime);
        }
    }
    
    exec function TriggerDodge(bool bActive)
    {
        if (bActive)
        {
            Dodge();
            QuitFPS();
        }
    }
    
    Stop;
}

state PlayerSwimming
{
    exec function SwimAttack()
    {
        local FishNodeActor fish;
        local SpikeFish Spike_fish;
        
        if (MyAlicePawn.SwimState == 10)
        {
            return;
        }
        MyAlicePawn.PlayParticle(MyAlicePawn.Location, MyAlicePawn.Rotation, MyAlicePawn.SwimAttackParticle, true, MyAlicePawn);
        foreach VisibleActors(class'FishNodeActor', fish, MyAlicePawn.AttackRadius, MyAlicePawn.Location)
        {
            fish.TakeDamage(1, self, Location, vector(Rotation), class'DmgType_Electricity');
        }
        foreach VisibleActors(class'SpikeFish', Spike_fish, MyAlicePawn.AttackRadius, MyAlicePawn.Location)
        {
            Spike_fish.TakeDamage(1, self, Location, vector(Rotation), class'DmgType_Electricity');
        }
        if (MyAlicePawn.SwimAttackSoundCue != none)
        {
            PlaySound(MyAlicePawn.SwimAttackSoundCue);
        }
    }
    
    function Bump(Actor Other, PrimitiveComponent OtherComp, Vector HitNormal)
    {
        if (MyAlicePawn.bBoostingSwim == true)
        {
        }
        if (GameBreakableActor(Other) != none)
        {
            if (MyAlicePawn.bBoostingSwim == true)
            {
                Other.TakeDamage(int(MyAlicePawn.SwimBoostDamage), self, MyAlicePawn.Location, vector(MyAlicePawn.Rotation), class'DmgType_SwimBoost');
            }
        }
    }
    
    function OnBoostSwimCoolDownFinished()
    {
        MyAlicePawn.bBoostCoolDownFinished = true;
        MyAlicePawn.AliceCameraDistance = MyAlicePawn.SwimCamera.Distance;
        MyAlicePawn.AliceCameraMaxDistance = MyAlicePawn.SwimCamera.MaxDistance;
    }
    
    function OnBoostSwimStop()
    {
        MyAlicePawn.LastSwimSpeed = Normal(MyAlicePawn.LastSwimSpeed) * MyAlicePawn.default.SlowSwimSpeed;
        MyAlicePawn.bBoostingSwim = false;
    }
    
    exec function BoostSwim()
    {
        if (MyAlicePawn.bBoostCoolDownFinished && MyAlicePawn.SwimState != 10 && MyAlicePawn.SwimState != 0 && MyAlicePawn.SwimState != 14)
        {
            MyAlicePawn.bBoostingSwim = true;
            MyAlicePawn.bBoostCoolDownFinished = false;
            SetTimer(MyAlicePawn.BoostCoolDownTime, false, 'OnBoostSwimCoolDownFinished');
            SetTimer(MyAlicePawn.BootSwimTime, false, 'OnBoostSwimStop');
        }
    }
    
    function OnIdleToSwimFinished()
    {
        MyAlicePawn.bIdleToSwimEnd = true;
    }
    
    function OnTurnBack180Finished()
    {
        MyAlicePawn.curSwimSpeed *= 0.5;
        MyAlicePawn.SwimState = 2;
        MyAlicePawn.SetRotation(rotator(MyAlicePawn.DirAfterTurn180));
    }
    
    exec function SwimTurnBack180()
    {
        if (MyAlicePawn.SwimState == 2 && MyAlicePawn.SwimState != 10)
        {
            MyAlicePawn.SwimState = 10;
            SetTimer(1.1, false, 'OnTurnBack180Finished');
            bFastSwimTurning = true;
            MyAlicePawn.DirAfterTurn180 = vector(MyAlicePawn.Rotation) * float(-1);
            MyAlicePawn.AliceForcePlayCameraAnim(MyAlicePawn.Turn180DegreeCamAnim, false);
        }
    }
    
    function OnSwimTurnFinished()
    {
        local AnimNodeSequence anim_node;
        
        anim_node = AnimNodeSequence(MyAlicePawn.SwimSkeletalMeshComponent.FindAnimNode('TurnLeft'));
        if (anim_node != none)
        {
            anim_node.Rate = 1.0;
        }
        MyAlicePawn.SwimState = 2;
    }
    
    function PlayerMove(float DeltaTime)
    {
        local Rotator OldRotation, desiredRot;
        local Vector X, Y, Z, newAccel, SwimDir;
        local bool TurnAroundFinished;
        local float SwimSpeed, coefficient, Temp, AnalogSpeed, PlaybackTime;
        local AnimNodeSequence anim_node;
        
        if (MyAlicePawn.bEndSwimState == true)
        {
            return;
        }
        ProcessSwimMove(DeltaTime);
        if (MyAlicePawn.ArcheTypeID != 6)
        {
            return;
        }
        if (AlicePlayerInput(PlayerInput).IsKeyPressed('XboxTypeS_LeftTrigger') || MyAlicePawn.bBoostingSwim)
        {
            if (!MyAlicePawn.IsCurAbilityCamera(MyAlicePawn.FastSwimCamera))
            {
                if (MyAlicePawn.IsCurAbilityCamera(MyAlicePawn.SwimCamera))
                {
                    MyAlicePawn.SetAliceAbilityCamera(MyAlicePawn.SwimCamera, true);
                }
                MyAlicePawn.SetAliceAbilityCamera(MyAlicePawn.FastSwimCamera);
                MyAlicePawn.AliceCameraOffset.Y = 0.0;
                bCameraReset = false;
            }
        }
        else if (!MyAlicePawn.IsCurAbilityCamera(MyAlicePawn.SwimCamera))
        {
            if (MyAlicePawn.IsCurAbilityCamera(MyAlicePawn.FastSwimCamera))
            {
                MyAlicePawn.SetAliceAbilityCamera(MyAlicePawn.FastSwimCamera, true);
            }
            MyAlicePawn.SetAliceAbilityCamera(MyAlicePawn.SwimCamera);
        }
        return;
        if (AlicePawn(Pawn).EntrySwimStateTime <= float(1))
        {
            AlicePawn(Pawn).EntrySwimStateTime += 0.05;
        }
        OldRotation = Rotation;
        coefficient = DeltaTime / 0.0166;
        GetAxes(Rotation, X, Y, Z);
        if (MyAlicePawn.bBoostingSwim)
        {
            SwimDir = Normal(X * PlayerInput.aForward + Y * PlayerInput.aStrafe + Z * PlayerInput.aLookUp);
            MyAlicePawn.BoostSwimTurnSpeed = float(Clamp(int(MyAlicePawn.BoostSwimTurnSpeed), 1, 20));
            SwimDir = vector(Rotation) + SwimDir * DeltaTime / 0.0166 * MyAlicePawn.BoostSwimTurnSpeed * 0.001;
            if (!IsAliceUnderWater() && SwimDir.Z > float(0))
            {
                SwimDir.Z = 0.0;
            }
            TurnAround(MyAlicePawn.Rotation, Rotation, DeltaTime);
            newAccel = SwimDir * MyAlicePawn.BoostSwimSpeed * coefficient;
            MyAlicePawn.SwimState = 2;
        }
        else if (MyAlicePawn.SwimState == 10 || MyAlicePawn.SwimState == 11)
        {
        }
        else if (MyAlicePawn.SwimState == 8 || MyAlicePawn.SwimState == 7)
        {
            if (MyAlicePawn.SwimState == 7)
            {
                anim_node = AnimNodeSequence(MyAlicePawn.SwimSkeletalMeshComponent.FindAnimNode('TurnLeft'));
            }
            else
            {
                anim_node = AnimNodeSequence(MyAlicePawn.SwimSkeletalMeshComponent.FindAnimNode('TurnRight'));
            }
            if (Abs(PlayerInput.aLookUp) > float(0) || Abs(PlayerInput.aTurn) > float(0))
            {
                SwimDir = Normal(vector(Rotation));
            }
            else if (anim_node != none)
            {
                PlaybackTime = anim_node.GetAnimPlaybackLength() * anim_node.AnimSeq.RateScale;
                if (anim_node.CurrentTime <= PlaybackTime / 2.0)
                {
                    anim_node.Rate = -1.0;
                }
            }
            if (anim_node != none)
            {
                PlaybackTime = anim_node.GetAnimPlaybackLength() * anim_node.AnimSeq.RateScale;
                if (anim_node.CurrentTime >= PlaybackTime && anim_node.Rate == 1.0 || anim_node.CurrentTime <= float(0) && anim_node.Rate == -1.0)
                {
                    anim_node.Rate = 1.0;
                    MyAlicePawn.SwimState = 2;
                }
            }
            SwimSpeed = AlicePawn(Pawn).SwimSpeed;
            newAccel = vector(AlicePawn(Pawn).Rotation) * SwimSpeed;
            desiredRot = rotator(SwimDir);
            TurnAroundFinished = TurnAround(Pawn.Rotation, desiredRot, DeltaTime);
            if (!TurnAroundFinished)
            {
                if (IsZero(Pawn.Acceleration))
                {
                    newAccel = vect(0.0, 0.0, 0.0);
                }
            }
        }
        else if (AlicePlayerInput(PlayerInput).IsKeyPressed('XboxTypeS_LeftTrigger') && MyAlicePawn.SwimState == 0 || MyAlicePawn.SwimState == 9 || MyAlicePawn.SwimState == 2 || MyAlicePawn.SwimState == 8 || MyAlicePawn.SwimState == 7 || MyAlicePawn.SwimState == 5 || MyAlicePawn.SwimState == 6 || MyAlicePawn.SwimState == 1)
        {
            if (!MyAlicePawn.bIdleToSwimEnd && MyAlicePawn.SwimState != 5 && MyAlicePawn.SwimState != 6)
            {
                if (MyAlicePawn.SwimState == 0 || MyAlicePawn.SwimState == 1)
                {
                    MyAlicePawn.SwimState = 9;
                    SetTimer(0.8, false, 'OnIdleToSwimFinished');
                }
                SwimDir = VLerp(MyAlicePawn.LastSwimSpeed, vector(MyAlicePawn.Rotation), 0.2 * coefficient);
                SwimDir = Normal(SwimDir);
            }
            else
            {
                MyAlicePawn.SwimState = 2;
                MyAlicePawn.bIdleToSwimEnd = true;
                if (Abs(PlayerInput.aLookUp) > float(0) || Abs(PlayerInput.aTurn) > float(0))
                {
                    SwimDir = Normal(vector(Rotation));
                    Temp = SwimDir Dot vector(MyAlicePawn.Rotation);
                    if (Temp < float(0) && Abs(PlayerInput.aTurn) < Abs(PlayerInput.aLookUp))
                    {
                        if (!bFastSwimTurning)
                        {
                            MyAlicePawn.SwimState = 10;
                            SetTimer(1.1, false, 'OnTurnBack180Finished');
                            bFastSwimTurning = true;
                        }
                    }
                    else
                    {
                        bFastSwimTurning = false;
                        if (Abs(PlayerInput.aLookUp) < Abs(PlayerInput.aTurn) || Temp < 0.3 && Temp > float(0) && !(AlicePlayerInput(PlayerInput).IsKeyPressed('XboxTypeS_A') || AlicePlayerInput(PlayerInput).IsKeyPressed('XboxTypeS_B')))
                        {
                            if (Abs(PlayerInput.aTurn) > Abs(PlayerInput.aLookUp) && bCanSwimTurnLeftOrRight)
                            {
                                if (PlayerInput.aTurn > float(0))
                                {
                                    MyAlicePawn.SwimState = 8;
                                }
                                else
                                {
                                    MyAlicePawn.SwimState = 7;
                                }
                                bCanSwimTurnLeftOrRight = false;
                            }
                        }
                    }
                    if (bFastSwimTurning)
                    {
                        SwimDir = VLerp(MyAlicePawn.LastSwimSpeed, vector(MyAlicePawn.Rotation), 0.2 * coefficient);
                        SwimDir = Normal(SwimDir);
                    }
                    bCameraReset = false;
                }
                else
                {
                    bFastSwimTurning = false;
                    if (Abs(float(NormalizeRotAxis(Rotation.Yaw - MyAlicePawn.Rotation.Yaw))) <= float(10) && Abs(float(NormalizeRotAxis(Rotation.Pitch - MyAlicePawn.Rotation.Pitch))) <= float(10) && bCameraReset == false)
                    {
                        bCameraReset = true;
                    }
                    if (bCameraReset == false)
                    {
                        SwimDir = VLerp(MyAlicePawn.LastSwimSpeed, vector(MyAlicePawn.Rotation), 0.2 * coefficient);
                        SwimDir = Normal(SwimDir);
                    }
                    else
                    {
                        SwimDir = vector(Rotation);
                    }
                }
            }
            SwimSpeed = AlicePawn(Pawn).SwimSpeed;
            newAccel = vector(AlicePawn(Pawn).Rotation) * SwimSpeed;
            SwimDir = Normal(SwimDir);
            if (AlicePlayerInput(PlayerInput).IsKeyPressed('XboxTypeS_A') && IsAliceUnderWater())
            {
                if (SwimPitch + SwimDir.Z < 0.99)
                {
                    SwimPitch += 0.03 * coefficient;
                }
                SwimDir.Z += SwimPitch;
                SwimDir.Z = FClamp(SwimDir.Z, -0.99, 0.99);
            }
            else if (AlicePlayerInput(PlayerInput).IsKeyPressed('XboxTypeS_B'))
            {
                if (SwimPitch + SwimDir.Z > -0.99)
                {
                    SwimPitch -= 0.03 * coefficient;
                }
                SwimDir.Z += SwimPitch;
                SwimDir.Z = FClamp(SwimDir.Z, -0.99, 0.99);
            }
            else
            {
                SwimPitch = 0.0;
            }
            desiredRot = rotator(SwimDir);
            TurnAroundFinished = TurnAround(Pawn.Rotation, desiredRot, DeltaTime);
            if (!TurnAroundFinished)
            {
                if (IsZero(Pawn.Acceleration))
                {
                    newAccel = vect(0.0, 0.0, 0.0);
                }
            }
        }
        else if ((Abs(PlayerInput.aForward) > float(0) || Abs(PlayerInput.aStrafe) > float(0)) && !(MyAlicePawn.SwimState == 5 || MyAlicePawn.SwimState == 6))
        {
            SwimDir = Normal(X * PlayerInput.aForward + Y * PlayerInput.aStrafe + Z * PlayerInput.aLookUp);
            SwimSpeed = MyAlicePawn.SlowSwimSpeed * coefficient;
            newAccel = vector(AlicePawn(Pawn).Rotation) * SwimSpeed;
            SwimDir = Normal(SwimDir);
            desiredRot = rotator(SwimDir);
            TurnAroundFinished = TurnAround(Pawn.Rotation, desiredRot, DeltaTime);
            if (!TurnAroundFinished)
            {
                if (IsZero(Pawn.Acceleration))
                {
                    newAccel = vect(0.0, 0.0, 0.0);
                }
                if (Abs(PlayerInput.aStrafe) > Abs(PlayerInput.aForward))
                {
                    if (PlayerInput.aStrafe > float(0))
                    {
                        MyAlicePawn.SwimState = 4;
                    }
                    else
                    {
                        MyAlicePawn.SwimState = 3;
                    }
                }
                else
                {
                    MyAlicePawn.SwimState = 4;
                }
            }
            else
            {
                MyAlicePawn.SwimState = 1;
                if (AlicePlayerInput(PlayerInput).IsKeyPressed('XboxTypeS_A') && IsAliceUnderWater())
                {
                    newAccel.Z += SwimSpeed;
                }
                else if (AlicePlayerInput(PlayerInput).IsKeyPressed('XboxTypeS_B'))
                {
                    newAccel.Z -= SwimSpeed;
                }
                AnalogSpeed = (Abs(PlayerInput.aStrafe) + Abs(PlayerInput.aForward)) / 9600.0;
                newAccel = Normal(newAccel) * SwimSpeed * AnalogSpeed * coefficient;
            }
        }
        else if (AlicePlayerInput(PlayerInput).IsKeyPressed('XboxTypeS_A') && IsAliceUnderWater() && MyAlicePawn.SwimState != 12)
        {
            desiredRot = MyAlicePawn.Rotation;
            desiredRot.Pitch = int(Lerp(float(desiredRot.Pitch), 0.0, 0.1));
            MyAlicePawn.SetRotation(desiredRot);
            if (AlicePlayerInput(PlayerInput).IsKeyPressed('XboxTypeS_LeftTrigger'))
            {
                newAccel.Z = MyAlicePawn.LastSwimSpeed.Z + AlicePawn(Pawn).SwimSpeed * coefficient * 0.5;
                newAccel.Z = FClamp(newAccel.Z, -AlicePawn(Pawn).SwimSpeed * coefficient, AlicePawn(Pawn).SwimSpeed * coefficient);
                if (!MyAlicePawn.bIdleToSwimEnd && MyAlicePawn.SwimState != 5 && MyAlicePawn.SwimState != 0)
                {
                    if (MyAlicePawn.SwimState != 13)
                    {
                        MyAlicePawn.SwimState = 13;
                        SetTimer(0.8, false, 'OnIdleToSwimFinished');
                    }
                }
                else
                {
                    MyAlicePawn.SwimState = 5;
                    MyAlicePawn.bIdleToSwimEnd = false;
                }
            }
            else
            {
                newAccel.Z = MyAlicePawn.LastSwimSpeed.Z + AlicePawn(Pawn).SlowSwimSpeed * coefficient * 0.5;
                newAccel.Z = FClamp(newAccel.Z, -AlicePawn(Pawn).SlowSwimSpeed * coefficient, AlicePawn(Pawn).SlowSwimSpeed * coefficient);
                MyAlicePawn.SwimState = 5;
            }
        }
        else if (AlicePlayerInput(PlayerInput).IsKeyPressed('XboxTypeS_B') && !IsShrinking && !IsUnShrinking && MyAlicePawn.SwimState != 13)
        {
            desiredRot = MyAlicePawn.Rotation;
            desiredRot.Pitch = int(Lerp(float(desiredRot.Pitch), 0.0, 0.1));
            MyAlicePawn.SetRotation(desiredRot);
            if (AlicePlayerInput(PlayerInput).IsKeyPressed('XboxTypeS_LeftTrigger'))
            {
                newAccel.Z = MyAlicePawn.LastSwimSpeed.Z - AlicePawn(Pawn).SwimSpeed * coefficient * 0.5;
                newAccel.Z = FClamp(newAccel.Z, -AlicePawn(Pawn).SwimSpeed * coefficient, 2.0);
                if (!MyAlicePawn.bIdleToSwimEnd)
                {
                    if (MyAlicePawn.SwimState != 12 && MyAlicePawn.SwimState != 6)
                    {
                        MyAlicePawn.SwimState = 12;
                        SetTimer(0.8, false, 'OnIdleToSwimFinished');
                    }
                }
                else
                {
                    MyAlicePawn.SwimState = 6;
                    MyAlicePawn.bIdleToSwimEnd = false;
                }
            }
            else
            {
                newAccel.Z = MyAlicePawn.LastSwimSpeed.Z - AlicePawn(Pawn).SlowSwimSpeed * coefficient * 0.5;
                newAccel.Z = FClamp(newAccel.Z, -AlicePawn(Pawn).SlowSwimSpeed * coefficient, AlicePawn(Pawn).SlowSwimSpeed * coefficient);
                MyAlicePawn.SwimState = 6;
            }
        }
        else if (VSize(MyAlicePawn.LastSwimSpeed) < 0.5)
        {
            RestorePitch();
            if (MyAlicePawn.SwimState == 2 || MyAlicePawn.SwimState == 7 || MyAlicePawn.SwimState == 8)
            {
                MyAlicePawn.SwimState = 14;
                SetTimer(1.0, false, 'TurnToIdle');
            }
            else if (MyAlicePawn.SwimState != 0 && MyAlicePawn.SwimState != 14)
            {
                TurnToIdle();
            }
        }
        if (!bCanSwimTurnLeftOrRight)
        {
            if (Abs(PlayerInput.aForward) >= Abs(PlayerInput.aStrafe))
            {
                bCanSwimTurnLeftOrRight = true;
            }
        }
        if (MyAlicePawn.bBoostingSwim)
        {
            MyAlicePawn.curSwimSpeed = Lerp(MyAlicePawn.curSwimSpeed, VSize(newAccel), 1.0);
            newAccel = Normal(newAccel) * MyAlicePawn.curSwimSpeed;
        }
        else if (VSize(newAccel) > float(0))
        {
            MyAlicePawn.curSwimSpeed = Lerp(MyAlicePawn.curSwimSpeed, VSize(newAccel), 1.0 / MyAlicePawn.SwimSpeedInertia);
            newAccel = Normal(newAccel) * MyAlicePawn.curSwimSpeed;
        }
        else
        {
            MyAlicePawn.curSwimSpeed = Lerp(MyAlicePawn.curSwimSpeed, VSize(newAccel), 3.0 / MyAlicePawn.SwimSpeedInertia);
            if (MyAlicePawn.curSwimSpeed < float(5))
            {
                MyAlicePawn.curSwimSpeed = 0.0;
            }
            newAccel = Normal(MyAlicePawn.LastSwimSpeed) * MyAlicePawn.curSwimSpeed;
        }
        if (!IsAliceUnderWater())
        {
            AlicePawn(Pawn).bBubbleEffectActive = false;
            AlicePawn(Pawn).SetBubbleEffect();
            if (newAccel.Z > 0.0)
            {
                newAccel.Z = 0.0;
            }
        }
        else if (!AlicePawn(Pawn).bWantToLeaveSwim && !AlicePawn(Pawn).bBubbleEffectActive)
        {
            AlicePawn(Pawn).bBubbleEffectActive = true;
            AlicePawn(Pawn).SetBubbleEffect();
        }
        if (MyAlicePawn.SwimState == 1 || MyAlicePawn.SwimState == 3 || MyAlicePawn.SwimState == 4)
        {
            if (MyAlicePawn.curSwimSpeed > MyAlicePawn.default.SlowSwimSpeed)
            {
                MyAlicePawn.curSwimSpeed = MyAlicePawn.default.SlowSwimSpeed;
                newAccel = Normal(newAccel) * MyAlicePawn.curSwimSpeed;
            }
        }
        if (AlicePlayerInput(PlayerInput).IsKeyPressed('XboxTypeS_LeftTrigger') || MyAlicePawn.bBoostingSwim)
        {
            if (!MyAlicePawn.IsCurAbilityCamera(MyAlicePawn.FastSwimCamera))
            {
                if (MyAlicePawn.IsCurAbilityCamera(MyAlicePawn.SwimCamera))
                {
                    MyAlicePawn.SetAliceAbilityCamera(MyAlicePawn.SwimCamera, true);
                }
                MyAlicePawn.SetAliceAbilityCamera(MyAlicePawn.FastSwimCamera);
                MyAlicePawn.AliceCameraOffset.Y = 0.0;
                bCameraReset = false;
            }
        }
        else if (!MyAlicePawn.IsCurAbilityCamera(MyAlicePawn.SwimCamera))
        {
            if (MyAlicePawn.IsCurAbilityCamera(MyAlicePawn.FastSwimCamera))
            {
                MyAlicePawn.SetAliceAbilityCamera(MyAlicePawn.FastSwimCamera, true);
            }
            MyAlicePawn.SetAliceAbilityCamera(MyAlicePawn.SwimCamera);
        }
        MyAlicePawn.PlayGlideParticle(MyAlicePawn.bBoostingSwim);
        UpdateRotation(DeltaTime);
        ProcessMove(DeltaTime, newAccel, 0, OldRotation - Rotation);
        bPressedJump = false;
        if (MyAlicePawn.Weapon != none)
        {
            WeaponForAliceMelee(MyAlicePawn.Weapon).FlushParticleComponent.SetActive(false);
        }
    }
    
    function UpdateRotation(float DeltaTime)
    {
        local Rotator DeltaRot, ViewRotation;
        
        ViewRotation = Rotation;
        if (Pawn != none)
        {
            Pawn.SetDesiredRotation(ViewRotation);
        }
        if (MyAlicePawn.SwimState == 2 && Abs(PlayerInput.aForward) > float(0) || Abs(PlayerInput.aStrafe) > float(0))
        {
            DeltaRot.Yaw = int(PlayerInput.aStrafe / 17.0);
            DeltaRot.Pitch = int(PlayerInput.aLookUp);
        }
        else
        {
            DeltaRot.Yaw = int(PlayerInput.aTurn);
            DeltaRot.Pitch = int(PlayerInput.aLookUp);
        }
        ProcessViewRotation(DeltaTime, ViewRotation, DeltaRot);
        SetRotation(ViewRotation);
        ViewShake(DeltaTime);
    }
    
    function ProcessSwimMove(float DeltaTime)
    {
        local Vector X, Y, Z, newAccel, SwimDir;
        local Rotator OldRotation, desiredRot;
        local float SwimSpeed, coefficient, AnalogSpeed, PlaybackTime;
        local AnimNodeSequence anim_node;
        local Vector Start, End, HitLoc, HitNormal;
        local Rotator Rot;
        
        if (AlicePawn(Pawn).EntrySwimStateTime <= float(1))
        {
            AlicePawn(Pawn).EntrySwimStateTime += 0.05;
        }
        if (AlicePawn(Pawn).bEndSwimState)
        {
            return;
        }
        UpdateLockOnTargetUI();
        coefficient = 1.0;
        GetAxes(Rotation, X, Y, Z);
        if (MyAlicePawn.bSwimKnockBack)
        {
        }
        else if (MyAlicePawn.bBoostingSwim)
        {
            SwimDir = Normal(X * PlayerInput.aForward + Y * PlayerInput.aStrafe + Z * PlayerInput.aLookUp);
            MyAlicePawn.BoostSwimTurnSpeed = float(Clamp(int(MyAlicePawn.BoostSwimTurnSpeed), 1, 20));
            SwimDir = vector(Rotation) + SwimDir * DeltaTime / 0.0166 * MyAlicePawn.BoostSwimTurnSpeed * 0.01;
            if (!IsAliceUnderWater() && SwimDir.Z > float(0))
            {
                SwimDir.Z = 0.0;
            }
            MyAlicePawn.SetRotation(rotator(SwimDir));
            newAccel = SwimDir * MyAlicePawn.BoostSwimSpeed * coefficient;
            MyAlicePawn.SwimState = 2;
        }
        else if (MyAlicePawn.SwimState == 10 || MyAlicePawn.SwimState == 11)
        {
            return;
        }
        else if (MyAlicePawn.SwimState == 8 || MyAlicePawn.SwimState == 7)
        {
            if (MyAlicePawn.SwimState == 7)
            {
                anim_node = AnimNodeSequence(MyAlicePawn.Mesh.FindAnimNode('TurnLeft'));
            }
            else
            {
                anim_node = AnimNodeSequence(MyAlicePawn.Mesh.FindAnimNode('TurnRight'));
            }
            if (anim_node != none)
            {
                PlaybackTime = anim_node.GetAnimPlaybackLength() * anim_node.AnimSeq.RateScale;
                if (anim_node.CurrentTime >= PlaybackTime)
                {
                    MyAlicePawn.SwimState = 2;
                }
            }
            SwimSpeed = AlicePawn(Pawn).SwimSpeed;
            newAccel = Normal(vector(MyAlicePawn.Rotation)) * SwimSpeed;
            SwimDir = Normal(vector(Rotation));
            desiredRot = rotator(SwimDir);
            TurnAround(Pawn.Rotation, desiredRot, DeltaTime);
        }
        else if (AlicePlayerInput(PlayerInput).IsKeyPressed('XboxTypeS_LeftTrigger'))
        {
            if (!MyAlicePawn.bIdleToSwimEnd && MyAlicePawn.SwimState != 5 && MyAlicePawn.SwimState != 6)
            {
                if (MyAlicePawn.SwimState == 0 || MyAlicePawn.SwimState == 1 || MyAlicePawn.SwimState == 4 || MyAlicePawn.SwimState == 3)
                {
                    MyAlicePawn.SwimState = 9;
                    SetTimer(0.8, false, 'OnIdleToSwimFinished');
                }
            }
            else
            {
                MyAlicePawn.SwimState = 2;
            }
            SwimSpeed = AlicePawn(Pawn).SwimSpeed;
            newAccel = Normal(vector(MyAlicePawn.Rotation)) * SwimSpeed * coefficient;
            if (Abs(PlayerInput.aTurn) > float(0) || Abs(PlayerInput.aLookUp) > float(0) || Abs(PlayerInput.aForward) > float(0) || Abs(PlayerInput.aStrafe) > float(0))
            {
                SwimDir = Normal(vector(Rotation));
            }
            else
            {
                SwimDir = Normal(vector(MyAlicePawn.Rotation));
            }
            if ((Abs(PlayerInput.aTurn) > Abs(PlayerInput.aLookUp) || Abs(PlayerInput.aStrafe) > Abs(PlayerInput.aForward)) && bCanSwimTurnLeftOrRight)
            {
                if (Abs(PlayerInput.aTurn) > float(560) || Abs(PlayerInput.aStrafe) > float(9500))
                {
                    MyAlicePawn.curBarrelRollDelayTime += DeltaTime;
                    if (MyAlicePawn.curBarrelRollDelayTime >= MyAlicePawn.BarrelRollDelayTime)
                    {
                        if (PlayerInput.aTurn > float(0) || PlayerInput.aStrafe > float(0))
                        {
                            MyAlicePawn.SwimState = 8;
                        }
                        else
                        {
                            MyAlicePawn.SwimState = 7;
                        }
                        bCanSwimTurnLeftOrRight = false;
                        MyAlicePawn.curBarrelRollDelayTime = 0.0;
                    }
                }
                else
                {
                    MyAlicePawn.curBarrelRollDelayTime = 0.0;
                }
            }
            else
            {
                MyAlicePawn.curBarrelRollDelayTime = 0.0;
            }
            if (AlicePlayerInput(PlayerInput).IsKeyPressed('XboxTypeS_A') && IsAliceUnderWater())
            {
                if (SwimPitch + SwimDir.Z < 0.99)
                {
                    SwimPitch += 0.03 * coefficient;
                }
                SwimDir.Z += SwimPitch;
                SwimDir.Z = FClamp(SwimDir.Z, -0.99, 0.99);
            }
            else if (AlicePlayerInput(PlayerInput).IsKeyPressed('XboxTypeS_B'))
            {
                if (SwimPitch + SwimDir.Z > -0.99)
                {
                    SwimPitch -= 0.03 * coefficient;
                }
                SwimDir.Z += SwimPitch;
                SwimDir.Z = FClamp(SwimDir.Z, -0.99, 0.99);
            }
            else
            {
                SwimPitch = 0.0;
            }
            desiredRot = rotator(SwimDir);
            if (Abs(PlayerInput.aTurn) > float(0) || Abs(PlayerInput.aLookUp) > float(0) || Abs(PlayerInput.aForward) > float(0) || Abs(PlayerInput.aStrafe) > float(0))
            {
                if (!TurnAround(MyAlicePawn.Rotation, desiredRot, DeltaTime))
                {
                    if (IsZero(Pawn.Acceleration))
                    {
                        newAccel = vect(0.0, 0.0, 0.0);
                    }
                }
            }
            if (MyAlicePawn.SwimState == 2)
            {
                desiredRot = MyAlicePawn.Rotation;
                if (Abs(PlayerInput.aTurn) > Abs(PlayerInput.aLookUp) || Abs(PlayerInput.aStrafe) > Abs(PlayerInput.aForward))
                {
                    if (PlayerInput.aTurn > float(0))
                    {
                        SwimRoll += float(100);
                        SwimRoll = FClamp(SwimRoll, 0.0, 4000.0);
                    }
                    else
                    {
                        SwimRoll -= float(100);
                        SwimRoll = FClamp(SwimRoll, -4000.0, 0.0);
                    }
                }
                else if (SwimRoll > float(0))
                {
                    SwimRoll -= float(100);
                    SwimRoll = FClamp(SwimRoll, 0.0, SwimRoll);
                }
                else if (SwimRoll < float(0))
                {
                    SwimRoll += float(100);
                    SwimRoll = FClamp(SwimRoll, SwimRoll, 0.0);
                }
                desiredRot.Roll = int(SwimRoll);
                MyAlicePawn.SetRotation(desiredRot);
                MyAlicePawn.AliceCameraOrientation.Roll = int(float(desiredRot.Roll) / 4000.0 * float(MyAlicePawn.FastSwimCamera.Orientation.Roll));
                MyAlicePawn.AliceCameraOffset.Y = float(desiredRot.Roll) / 4000.0 * MyAlicePawn.FastSwimCamera.Offset.Y;
            }
            if (!AlicePlayerInput(PlayerInput).IsKeyPressed('XboxTypeS_A') && SwimDir.Z < 0.0)
            {
                Start = MyAlicePawn.Location;
                End = Start;
                End.Z -= float(100);
                if (MyAlicePawn.Trace(HitLoc, HitNormal, End, Start, false) != none)
                {
                    if (HitNormal.Z > 0.7)
                    {
                        Rot = MyAlicePawn.Rotation;
                        Rot.Pitch = 0;
                        MyAlicePawn.SetRotation(Rot);
                        newAccel.Z = 0.0;
                    }
                }
            }
        }
        else if ((Abs(PlayerInput.aForward) > float(0) || Abs(PlayerInput.aStrafe) > float(0)) && MyAlicePawn.SwimState == 1 || MyAlicePawn.SwimState == 4 || MyAlicePawn.SwimState == 3 || MyAlicePawn.SwimState == 0)
        {
            SwimDir = Normal(X * PlayerInput.aForward + Y * PlayerInput.aStrafe + Z * PlayerInput.aLookUp);
            SwimSpeed = MyAlicePawn.SlowSwimSpeed * coefficient;
            newAccel = vector(AlicePawn(Pawn).Rotation) * SwimSpeed;
            if (Abs(PlayerInput.aLookUp) <= 0.001 && Abs(PlayerInput.aTurn) < 0.001)
            {
                SwimDir.Z = 0.0;
            }
            SwimDir = Normal(SwimDir);
            if (!TurnAround(Pawn.Rotation, rotator(SwimDir), DeltaTime))
            {
                if (IsZero(Pawn.Acceleration))
                {
                    newAccel = vect(0.0, 0.0, 0.0);
                }
                if (Abs(PlayerInput.aStrafe) > Abs(PlayerInput.aForward))
                {
                    if (PlayerInput.aStrafe > float(0))
                    {
                        MyAlicePawn.SwimState = 4;
                    }
                    else
                    {
                        MyAlicePawn.SwimState = 3;
                    }
                }
                else
                {
                    MyAlicePawn.SwimState = 4;
                }
            }
            else
            {
                MyAlicePawn.SwimState = 1;
            }
            if (AlicePlayerInput(PlayerInput).IsKeyPressed('XboxTypeS_A') && IsAliceUnderWater())
            {
                newAccel.Z += SwimSpeed;
            }
            else if (AlicePlayerInput(PlayerInput).IsKeyPressed('XboxTypeS_B'))
            {
                newAccel.Z -= SwimSpeed;
            }
            AnalogSpeed = (Abs(PlayerInput.aStrafe) + Abs(PlayerInput.aForward)) / 9600.0;
            newAccel = Normal(newAccel) * SwimSpeed * AnalogSpeed * 0.5;
        }
        else if (AlicePlayerInput(PlayerInput).IsKeyPressed('XboxTypeS_A') && IsAliceUnderWater() && MyAlicePawn.SwimState == 5 || MyAlicePawn.SwimState == 0 || SwimUpDownDelay > float(0))
        {
            desiredRot = MyAlicePawn.Rotation;
            desiredRot.Pitch = int(Lerp(float(desiredRot.Pitch), 0.0, 0.1));
            MyAlicePawn.SetRotation(desiredRot);
            if (MyAlicePawn.LastSwimSpeed.Z > float(0))
            {
                newAccel.Z = MyAlicePawn.LastSwimSpeed.Z + AlicePawn(Pawn).SlowSwimSpeed * coefficient * 0.1;
            }
            else
            {
                newAccel.Z = MyAlicePawn.LastSwimSpeed.Z + AlicePawn(Pawn).SlowSwimSpeed * coefficient * 0.3;
            }
            newAccel.Z = FClamp(newAccel.Z, -AlicePawn(Pawn).SlowSwimSpeed, AlicePawn(Pawn).SlowSwimSpeed);
            MyAlicePawn.SwimState = 5;
            SwimUpDownDelay = 0.5;
        }
        else if (AlicePlayerInput(PlayerInput).IsKeyPressed('XboxTypeS_B') && !IsShrinking && !IsUnShrinking && MyAlicePawn.SwimState == 6 || MyAlicePawn.SwimState == 0 || SwimUpDownDelay > float(0))
        {
            desiredRot = MyAlicePawn.Rotation;
            desiredRot.Pitch = int(Lerp(float(desiredRot.Pitch), 0.0, 0.1));
            MyAlicePawn.SetRotation(desiredRot);
            if (MyAlicePawn.LastSwimSpeed.Z < float(0))
            {
                newAccel.Z = MyAlicePawn.LastSwimSpeed.Z - AlicePawn(Pawn).SlowSwimSpeed * coefficient * 0.1;
            }
            else
            {
                newAccel.Z = MyAlicePawn.LastSwimSpeed.Z - AlicePawn(Pawn).SlowSwimSpeed * coefficient * 0.3;
            }
            newAccel.Z = FClamp(newAccel.Z, -AlicePawn(Pawn).SlowSwimSpeed, AlicePawn(Pawn).SlowSwimSpeed);
            MyAlicePawn.SwimState = 6;
            SwimUpDownDelay = 0.5;
        }
        else if (SwimUpDownDelay > float(0))
        {
            SwimUpDownDelay -= DeltaTime;
            desiredRot = MyAlicePawn.Rotation;
            desiredRot.Pitch = int(Lerp(float(desiredRot.Pitch), 0.0, 0.1));
            MyAlicePawn.SetRotation(desiredRot);
            if (MyAlicePawn.SwimState == 6)
            {
                newAccel.Z = MyAlicePawn.LastSwimSpeed.Z + coefficient * 0.5;
                newAccel.Z = FClamp(newAccel.Z, -AlicePawn(Pawn).SlowSwimSpeed, 0.0);
            }
            else
            {
                newAccel.Z = MyAlicePawn.LastSwimSpeed.Z - coefficient * 0.5;
                newAccel.Z = FClamp(newAccel.Z, 0.0, AlicePawn(Pawn).SlowSwimSpeed);
            }
            MyAlicePawn.LastSwimSpeed.Z = newAccel.Z;
        }
        else
        {
            if (VSize(MyAlicePawn.LastSwimSpeed) < 0.5 || Abs(PlayerInput.aForward) > float(0) || Abs(PlayerInput.aStrafe) > float(0))
            {
                RestorePitch();
                if (MyAlicePawn.SwimState == 2 || MyAlicePawn.SwimState == 7 || MyAlicePawn.SwimState == 8)
                {
                    MyAlicePawn.SwimState = 14;
                    SetTimer(1.0, false, 'TurnToIdle');
                }
                else if (MyAlicePawn.SwimState != 0 && MyAlicePawn.SwimState != 14)
                {
                    TurnToIdle();
                }
            }
            if (Abs(PlayerInput.aTurn) > float(0) || Abs(PlayerInput.aLookUp) > float(0))
            {
                desiredRot = RLerp(MyAlicePawn.Rotation, Rotation, 0.1, true);
                MyAlicePawn.SetRotation(desiredRot);
                SwimDir = Normal(vector(Rotation));
                MyAlicePawn.LastSwimSpeed = SwimDir * VSize(MyAlicePawn.LastSwimSpeed) * coefficient;
            }
            if (Abs(SwimRoll) > float(0))
            {
                if (SwimRoll > float(0))
                {
                    SwimRoll -= float(100);
                    SwimRoll = FClamp(SwimRoll, 0.0, SwimRoll);
                }
                else if (SwimRoll < float(0))
                {
                    SwimRoll += float(100);
                    SwimRoll = FClamp(SwimRoll, SwimRoll, 0.0);
                }
                desiredRot = MyAlicePawn.Rotation;
                desiredRot.Roll = int(SwimRoll);
                MyAlicePawn.SetRotation(desiredRot);
                MyAlicePawn.AliceCameraOrientation.Roll = int(float(desiredRot.Roll) / 4000.0 * float(MyAlicePawn.FastSwimCamera.Orientation.Roll));
                MyAlicePawn.AliceCameraOffset.Y = float(desiredRot.Roll) / 4000.0 * MyAlicePawn.FastSwimCamera.Offset.Y;
            }
        }
        if (!bCanSwimTurnLeftOrRight)
        {
            if (Abs(PlayerInput.aLookUp) >= Abs(PlayerInput.aTurn))
            {
                bCanSwimTurnLeftOrRight = true;
            }
        }
        if (MyAlicePawn.bBoostingSwim)
        {
            MyAlicePawn.curSwimSpeed = Lerp(MyAlicePawn.curSwimSpeed, VSize(newAccel), 1.0) * DeltaTime / 0.0166;
            newAccel = Normal(newAccel) * MyAlicePawn.curSwimSpeed;
        }
        else if (MyAlicePawn.bSwimKnockBack)
        {
            newAccel = MyAlicePawn.SwimKnockBackDir * float(10);
        }
        else if (VSize(newAccel) > float(0))
        {
            if (MyAlicePawn.SwimState == 1)
            {
                MyAlicePawn.curSwimSpeed = Lerp(MyAlicePawn.curSwimSpeed, VSize(newAccel), 0.5 * (DeltaTime / 0.0166) / MyAlicePawn.SlowSwimSpeedInertia);
            }
            else
            {
                MyAlicePawn.curSwimSpeed = Lerp(MyAlicePawn.curSwimSpeed, VSize(newAccel), 0.5 * (DeltaTime / 0.0166) / MyAlicePawn.SwimSpeedInertia);
            }
            newAccel = Normal(newAccel) * MyAlicePawn.curSwimSpeed;
        }
        else
        {
            MyAlicePawn.curSwimSpeed = Lerp(MyAlicePawn.curSwimSpeed, VSize(newAccel), 2.5 * (DeltaTime / 0.0166) / MyAlicePawn.SwimSpeedInertia);
            if (MyAlicePawn.curSwimSpeed < float(5))
            {
                MyAlicePawn.curSwimSpeed = 0.0;
            }
            newAccel = Normal(MyAlicePawn.LastSwimSpeed) * MyAlicePawn.curSwimSpeed;
        }
        ProcessMove(DeltaTime, newAccel, 0, OldRotation - Rotation);
        bPressedJump = false;
        OldRotation = Rotation;
        UpdateRotation(DeltaTime);
    }
    
    function bool TurnAround(Rotator Rot, Rotator desiredRot, float DeltaTime)
    {
        local Rotator NewRot;
        local float turnSpeed, AnalogSpeed, factor;
        local Vector NewDir, DesiredDir;
        
        if (MyAlicePawn.bSwimKnockBack)
        {
            return true;
        }
        factor = DeltaTime / 0.0166;
        if ((Abs(PlayerInput.aForward) > float(0) || Abs(PlayerInput.aStrafe) > float(0)) && MyAlicePawn.SwimState == 2 || MyAlicePawn.SwimState == 7 || MyAlicePawn.SwimState == 8)
        {
            PlayerInput.aTurn = PlayerInput.aStrafe / 17.0;
        }
        if (MyAlicePawn.SwimState == 2 || MyAlicePawn.SwimState == 7 || MyAlicePawn.SwimState == 8)
        {
            turnSpeed = MyAlicePawn.SwimTurnSpeed * 0.1;
            if (Abs(PlayerInput.aTurn) > Abs(PlayerInput.aLookUp))
            {
                AnalogSpeed = Abs(PlayerInput.aTurn) / 305.0;
            }
            else
            {
                AnalogSpeed = Abs(PlayerInput.aLookUp) / 305.0;
            }
        }
        else
        {
            AnalogSpeed = (Abs(PlayerInput.aStrafe) + Abs(PlayerInput.aForward)) / 9600.0;
            turnSpeed = MyAlicePawn.SwimTurnSpeed * 0.01;
        }
        AnalogSpeed = FClamp(AnalogSpeed, 0.0, 1.0);
        turnSpeed *= AnalogSpeed;
        turnSpeed *= factor;
        turnSpeed = FClamp(turnSpeed, 0.0001, 0.9999);
        if (MyAlicePawn.SwimState == 2 && Abs(PlayerInput.aTurn) > Abs(PlayerInput.aLookUp) || MyAlicePawn.SwimState == 7 || MyAlicePawn.SwimState == 8)
        {
            MyAlicePawn.curSwimTurnSpeed += 0.0075 * factor;
            MyAlicePawn.curSwimTurnSpeed = FClamp(MyAlicePawn.curSwimTurnSpeed, 0.0001, turnSpeed);
        }
        else if (MyAlicePawn.SwimState == 0)
        {
            MyAlicePawn.curSwimTurnSpeed = Lerp(MyAlicePawn.curSwimTurnSpeed, turnSpeed, 1.0);
        }
        else
        {
            MyAlicePawn.curSwimTurnSpeed = Lerp(MyAlicePawn.curSwimTurnSpeed, turnSpeed, 0.05);
        }
        NewRot = RLerp(Rot, desiredRot, MyAlicePawn.curSwimTurnSpeed, true);
        Pawn.SetRotation(NewRot);
        NewDir = vector(NewRot);
        DesiredDir = vector(desiredRot);
        if (NewDir Dot DesiredDir > 0.6)
        {
            return true;
        }
        return false;
    }
    
    function GetBankInfo(out Vector HitNormal, out Vector HitLocation)
    {
        local Vector TraceEnd, TraceStart;
        
        TraceStart = Pawn.Location + vect(0.0, 0.0, 75.0);
        TraceEnd = TraceStart + vector(Pawn.Rotation) * float(150);
        Pawn.Trace(HitLocation, HitNormal, TraceEnd, TraceStart, false);
    }
    
    function bool IsAliceUnderWater()
    {
        return Pawn.Location.Z < AlicePawn(Pawn).waterSurfaceHeight - float(20) ? true : false;
    }
    
    function TurnToIdle()
    {
        MyAlicePawn.bIdleToSwimEnd = false;
        MyAlicePawn.curSwimTurnSpeed = 0.0;
        MyAlicePawn.SwimState = 0;
    }
    
    function RestorePitch()
    {
        local Rotator myRotation;
        
        myRotation = Pawn.Rotation;
        if (Abs(float(myRotation.Pitch)) > float(100))
        {
            if (myRotation.Pitch > 32767)
            {
                myRotation.Pitch *= 1.05;
                if (myRotation.Pitch > 65535)
                {
                    myRotation.Pitch = 0;
                }
            }
            else
            {
                myRotation.Pitch *= 0.95;
            }
        }
        else
        {
            myRotation.Pitch = 0;
        }
        Pawn.SetRotation(myRotation);
        Pawn.SetDesiredRotation(myRotation);
    }
    
    function bool TurnToDesiredRotationSlowly(Rotator Rot, Rotator desiredRot, float DeltaTime)
    {
        local float diff_Yaw, diff_Pitch;
        local Rotator NewRot;
        local float turnSpeed;
        
        if (IsZero(Pawn.Acceleration))
        {
            turnSpeed = 4000.0 * DeltaTime / 0.0166;
        }
        else
        {
            if (Abs(PlayerInput.aTurn) > float(200) && Abs(PlayerInput.aForward) > float(0))
            {
                Pawn.SetRotation(desiredRot);
                return true;
            }
            turnSpeed = MyAlicePawn.SwimTurnSpeed * DeltaTime / 0.0166;
        }
        NewRot = Rot;
        diff_Yaw = float(desiredRot.Yaw - NewRot.Yaw);
        diff_Pitch = float(desiredRot.Pitch - NewRot.Pitch);
        if (Abs(diff_Yaw) < turnSpeed)
        {
            NewRot.Yaw = desiredRot.Yaw;
            NewRot.Pitch = desiredRot.Pitch;
        }
        else if (Abs(diff_Yaw) > 32762.5)
        {
            if (NewRot.Yaw >= 0)
            {
                NewRot.Yaw += int(turnSpeed);
                if (float(NewRot.Yaw) > 32762.5)
                {
                    NewRot.Yaw -= 65525;
                }
            }
            else
            {
                NewRot.Yaw -= int(turnSpeed);
                if (float(NewRot.Yaw) < -32762.5)
                {
                    NewRot.Yaw += 65525;
                }
            }
        }
        else if (diff_Yaw > float(0))
        {
            NewRot.Yaw += int(turnSpeed);
        }
        else
        {
            NewRot.Yaw -= int(turnSpeed);
        }
        Pawn.SetRotation(NewRot);
        if (Abs(diff_Yaw) < turnSpeed && Abs(diff_Pitch) < turnSpeed)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    
    function ProcessMove(float DeltaTime, Vector newAccel, EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
    {
        local Vector dis;
        local float Speed;
        
        if (AlicePawn(Pawn).bNeedSwimToTarget)
        {
            dis = BackToSwimPos - Pawn.Location;
            if (VSize(dis) < float(100))
            {
                IgnoreMoveInput(false);
                AlicePawn(Pawn).bNeedSwimToTarget = false;
                MyAlicePawn.SwimState = 0;
            }
            else
            {
                TurnToDesiredRotationSlowly(Pawn.Rotation, rotator(Normal(dis)), DeltaTime);
                Pawn.Acceleration = Normal(dis) * float(6);
                MyAlicePawn.SwimState = 2;
            }
        }
        else
        {
            Pawn.Acceleration = newAccel;
        }
        Speed = VSize(Pawn.Acceleration);
        if (MyAlicePawn.bBoostingSwim)
        {
            if (Speed > AlicePawn(Pawn).BoostSwimSpeed)
            {
                Pawn.Acceleration = Normal(Pawn.Acceleration);
                Pawn.Acceleration *= AlicePawn(Pawn).BoostSwimSpeed;
            }
        }
        else if (AlicePawn(Pawn).SwimState == 1 && Speed > AlicePawn(Pawn).SlowSwimSpeed)
        {
            Pawn.Acceleration = Normal(Pawn.Acceleration);
            Pawn.Acceleration *= AlicePawn(Pawn).SlowSwimSpeed;
        }
        else if (Speed > AlicePawn(Pawn).SwimSpeed)
        {
            Pawn.Acceleration = Normal(Pawn.Acceleration);
            Pawn.Acceleration *= AlicePawn(Pawn).SwimSpeed;
        }
        MyAlicePawn.LastSwimSpeed = Pawn.Acceleration;
        Pawn.Acceleration *= DeltaTime / 0.0166;
        AlicePawn(Pawn).MoveMe(Pawn.Acceleration);
        Pawn.Velocity = Pawn.Acceleration;
    }
    
    event NotifyPhysicsVolumeChange(PhysicsVolume NewVolume)
    {
        if (AliceWaterVolume(NewVolume) != none || bCinematicMode)
        {
            return;
        }
        AlicePawn(Pawn).bWantToLeaveSwim = true;
        AlicePawn(Pawn).bEndSwimState = true;
        Pawn.SetPhysics(2);
        if (WalkInWaterVolume(NewVolume) != none)
        {
            if (WalkInWaterVolume(NewVolume).LandTargetPoint != none)
            {
                WaterWalkLandPos = WalkInWaterVolume(NewVolume).LandTargetPoint.Location;
            }
            if (!AlicePawn(Pawn).bInWaterWalk)
            {
                IgnoreMoveInput(true);
                AlicePawn(Pawn).bInWaterWalk = true;
                if (WalkInWaterVolume(NewVolume).LandTargetPoint != none)
                {
                    Pawn.SetRotation(rotator(WaterWalkLandPos - Pawn.Location));
                }
            }
            AlicePawn(Pawn).SetWaterWalkParameters();
            if (WalkInWaterVolume(NewVolume).LandTargetPoint != none && VSize(WaterWalkLandPos - Pawn.Location) > float(100))
            {
                AlicePawn(Pawn).bWaterWalkInited = false;
                Pawn.Velocity = WaterWalkLandPos - Pawn.Location;
                Pawn.Velocity.Z -= Pawn.GetGravityZ();
                Pawn.Acceleration = vect(0.0, 0.0, 0.0);
            }
            else
            {
                AlicePawn(Pawn).bWaterWalkInited = true;
            }
        }
        else
        {
            AlicePawn(Pawn).bInWaterWalk = false;
            AlicePawn(Pawn).bBubbleEffectActive = false;
            AlicePawn(Pawn).SetBubbleEffect();
        }
        DoSpecialMove(3, false);
        if (!bCheatFlying)
        {
            GotoState('PlayerWalking');
        }
    }
    
    event EndState(name NextStateName)
    {
        local Rotator myRot;
        local bool bWaterWalk;
        
        MyAlicePawn.bEndSwimState = true;
        if (MyAlicePawn.IsCurAbilityCamera(MyAlicePawn.SwimCamera))
        {
            MyAlicePawn.SetAliceAbilityCamera(MyAlicePawn.SwimCamera, true);
        }
        else if (MyAlicePawn.IsCurAbilityCamera(MyAlicePawn.FastSwimCamera))
        {
            MyAlicePawn.SetAliceAbilityCamera(MyAlicePawn.FastSwimCamera, true);
        }
        myRot = Pawn.Rotation;
        myRot.Pitch = 0;
        myRot.Roll = 0;
        Pawn.SetRotation(myRot);
        AlicePawn(Pawn).EntrySwimStateTime = 0.0;
        AlicePawn(Pawn).LeaveSwimStateTime = 0.0;
        PlayerMovementStates[curIndexOfPlayerMovementState].SetPlayerBasicMovementState(1);
        MyAlicePawn.Mesh.GlobalAnimRateScale = 1.0;
        if (MyAlicePawn.bBoostingSwim == true)
        {
            OnBoostSwimStop();
            SetTimer(0.0, false, 'OnBoostSwimStop');
        }
        if (NextStateName != 'Dead')
        {
            MyAlicePawn.LeaveSwimMode();
        }
        MyAlicePawn.ResetAliceCameraProperties();
        MyAlicePawn.bSwitchToSwim = false;
        MyAlicePawn.bRollToDesired = false;
        if (MyAlicePawn.SwimAmbientAudio != none)
        {
            MyAlicePawn.SwimAmbientAudio.FadeOut(2.0, 0.0);
        }
        bWaterWalk = MyAlicePawn.bInWaterWalk;
        SwitchToArcheType(1);
        if (bWaterWalk)
        {
            MyAlicePawn.ChangeWonderlandDress(2);
        }
        myRot = MyAlicePawn.Rotation;
        myRot.Pitch = 0;
        myRot.Roll = 0;
        MyAlicePawn.SetRotation(myRot);
        MyAlicePawn.TriggerEventClass(class'SeqEvent_AliceSwimMode', MyAlicePawn, 1);
        MyAlicePawn.DoSpecialMove(3, true);
    }
    
    event BeginState(name PreviousStateName)
    {
        if (MyAlicePawn == none)
        {
            MyAlicePawn = AlicePawn(Pawn);
        }
        MyAlicePawn.TriggerEventClass(class'SeqEvent_AliceSwimMode', MyAlicePawn, 0);
        RecoverToDefaultStatus();
        UpdateLockOnTargetUI();
        MyAlicePawn.ResetAliceCameraProperties();
        if (IsUnShrinking)
        {
            MyAlicePawn.EndSpecialMove();
            MyAlicePawn.SetAliceAbilityCamera(MyAlicePawn.ShrinkCamera, true);
            SetDrawScale(1.0);
            LeavingbShrinkingMode();
            MyAlicePawn.bStopAtLedges--;
        }
        if (MyAlicePawn.bSwitchToSwim == false)
        {
            MyAlicePawn.bSwitchToSwim = true;
            SwitchToArcheType(6);
            MyAlicePawn.SetDrawScale(1.0);
        }
        MyAlicePawn.bIsJumping = false;
        MyAlicePawn.SetPhysics(3);
        MyAlicePawn.Velocity = vect(0.0, 0.0, 0.0);
        MyAlicePawn.Acceleration = vect(0.0, 0.0, 0.0);
        MyAlicePawn.curSwimSpeed = 0.0;
        MyAlicePawn.curSwimTurnSpeed = 0.0;
        SwimPitch = 0.0;
        bCanSwimTurnLeftOrRight = true;
        MyAlicePawn.bBoostCoolDownFinished = true;
        AlicePawn(Pawn).bBubbleEffectActive = true;
        AlicePawn(Pawn).SetBubbleEffect();
        MyAlicePawn.EntrySwimStateTime = 0.01;
        MyAlicePawn.SetPawnStance(4);
        MyAlicePawn.SetSwimParameters();
        MyAlicePawn.SwimmingDressTest();
        if (MyAlicePawn.Weapon != none)
        {
            WeaponForAliceMelee(MyAlicePawn.Weapon).FlushParticleComponent.SetActive(false);
        }
        MyAlicePawn.bEndSwimState = false;
        MyAlicePawn.bRollToDesired = true;
        if (MyAlicePawn.SwimAmbientAudio == none)
        {
            MyAlicePawn.SwimAmbientAudio = MyAlicePawn.CreateAudioComponent(MyAlicePawn.SwimAmbientSoundCue);
        }
        if (MyAlicePawn.SwimAmbientAudio != none)
        {
            MyAlicePawn.SwimAmbientAudio.FadeIn(1.0, 1.0);
        }
        MyAlicePawn.ResetRotation();
    }
    
    exec function NextWeapon()
    {
    }
    
    exec function PrevWeapon()
    {
    }
    
    exec function ChangeShrinkingMode()
    {
    }
    
    exec function ChangeCameraMode(bool bToggleTargeting)
    {
    }
    
    exec function StartFire(optional byte FireModeNum)
    {
    }
    
    function MeleeFire()
    {
    }
    
    Stop;
}

state PlayerClimbing
{
    event EndState(name NextStateName)
    {
        if (Pawn != none)
        {
            Pawn.SetRemoteViewPitch(0);
        }
        StopCurrentMovementState();
    }
    
    event BeginState(name PreviousStateName)
    {
        RecoverToDefaultStatus();
        if (Pawn != none)
        {
            if (MyAlicePawn != none)
            {
                MyAlicePawn.bReadyToJumpToVerticleLedge = false;
                MyAlicePawn.bReadyToJumpToHorizentalLedge = false;
                MyAlicePawn.bReadyToDropFromLedge = false;
                MyAlicePawn.bReadyToClimbUpLedge = false;
                MyAlicePawn.bReadyToSwitchDirection = false;
            }
        }
        bPressedJump = false;
        ClimbingTime = 0.0;
        bInputAForwardChangedSinceClimbing = false;
        SwitchToMovementState(2);
        MyAlicePawn.SetPawnStance(3);
    }
    
    function PlayerMove(float DeltaTime)
    {
        local Vector X, Y, Z, newAccel;
        local Rotator OldRotation, ViewRotation;
        local bool bSaveJump;
        local Vector MoveDirOnVolume;
        local float Angle, sign;
        
        GetAxes(Rotation, X, Y, Z);
        InputaUp = PlayerInput.aUp;
        ClimbingTime += DeltaTime;
        if (Pawn.OnLadder != none)
        {
            newAccel = PlayerInput.aForward * Pawn.OnLadder.ClimbDir;
            if (Pawn.OnLadder.bAllowLadderStrafing)
            {
                newAccel += PlayerInput.aStrafe * Y;
            }
        }
        else if (MyAlicePawn.OnLedge != none && !IsZero(AlicePlayerInput(PlayerInput).InputVector))
        {
            ProjectInputToCameraSpace();
            if (MyAlicePawn.OnLedge.VolumeType == 1)
            {
                if (MyAlicePawn.bStandOnBalanceBeam && VSize(AlicePlayerInput(PlayerInput).InputVector) > float(0))
                {
                    MoveDirOnVolume = vector(Pawn.Rotation);
                    Angle = CalcAngleBetweenVectors(MoveDirOnVolume, AlicePlayerInput(PlayerInput).InputVector);
                    sign = float(Abs(Angle) < 3.1415927 * 0.55 ? 1 : -1);
                    newAccel = MoveDirOnVolume * sign;
                    DetermineBalancing(Angle);
                }
                else
                {
                    newAccel = PlayerInput.aStrafe * AlicePawn(Pawn).OnLedge.ClimbDir;
                    if (!AlicePawn(Pawn).bClimbOnLeftSideOfBalanceBeam)
                    {
                        newAccel *= float(-1);
                    }
                }
            }
            else if (AlicePawn(Pawn).OnLedge.VolumeType == 3)
            {
                MoveDirOnVolume = MyAlicePawn.OnLedge.ClimbDir;
                Angle = CalcAngleBetweenVectors(MoveDirOnVolume, AlicePlayerInput(PlayerInput).InputVector);
                sign = float(Abs(Angle) < 3.1415927 * 0.55 ? 1 : -1);
                newAccel = MyAlicePawn.OnLedge.ClimbDir * sign;
            }
            else if (AlicePawn(Pawn).OnLedge.VolumeType == 2)
            {
                newAccel = PlayerInput.aForward * MyAlicePawn.OnLedge.UpDir + PlayerInput.aStrafe * AlicePawn(Pawn).OnLedge.ClimbDir;
            }
            else
            {
                newAccel = PlayerInput.aStrafe * MyAlicePawn.OnLedge.ClimbDir;
            }
        }
        newAccel = Pawn.AccelRate * Normal(newAccel);
        if (bPressedJump && Pawn.CannotJumpNow())
        {
            bSaveJump = true;
            bPressedJump = false;
        }
        else
        {
            bSaveJump = false;
        }
        ViewRotation = Rotation;
        SetRotation(ViewRotation);
        OldRotation = Rotation;
        UpdateRotation(DeltaTime);
        if (Role < 3)
        {
            ReplicateMove(DeltaTime, newAccel, 0, OldRotation - Rotation);
        }
        else
        {
            ProcessMove(DeltaTime, newAccel, 0, OldRotation - Rotation);
        }
        bPressedJump = bSaveJump;
    }
    
    function DetermineBalancing(float AngleBtwInputAndDesiredMoveDir)
    {
        if (Abs(AngleBtwInputAndDesiredMoveDir) < 0.001)
        {
            MyAlicePawn.LeaningFactor = 0.0;
        }
        else
        {
            MyAlicePawn.LeaningFactor = -AngleBtwInputAndDesiredMoveDir / Abs(AngleBtwInputAndDesiredMoveDir) * Abs(Sin(Abs(AngleBtwInputAndDesiredMoveDir)));
        }
        if (MyAlicePawn.LeaningFactor > float(0))
        {
            MyAlicePawn.LedgeBalancingDirection = 1;
        }
        else if (MyAlicePawn.LeaningFactor < float(0))
        {
            MyAlicePawn.LedgeBalancingDirection = 2;
        }
        else
        {
            MyAlicePawn.LedgeBalancingDirection = 0;
        }
        if (Abs(MyAlicePawn.LeaningFactor) > MyAlicePawn.LeaningFactorThresholdToFallFromBalanceBeam && ClimbingTime > AlicePawn(Pawn).TimeWithoutFallFromBalanceBeamCheck)
        {
            DoSpecialMove(51, true);
        }
    }
    
    function ProcessMove(float DeltaTime, Vector newAccel, EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
    {
        if (Pawn == none)
        {
            return;
        }
        if (Role == 3)
        {
            Pawn.SetRemoteViewPitch(Rotation.Pitch);
        }
        Pawn.Acceleration = newAccel;
        if (MyAlicePawn != none && MyAlicePawn.OnLedge != none)
        {
            if (MyAlicePawn.bReadyToDropFromLedge)
            {
                MyAlicePawn.EnableAirControl(false);
                MyAlicePawn.ResetCollisionSize();
                Pawn.DoJump(bUpdating);
                MyAlicePawn.bReadyToDropFromLedge = false;
                if (Pawn.Physics == 2)
                {
                    GotoState(Pawn.LandMovementState);
                }
            }
        }
        else if (bPressedJump)
        {
            Pawn.DoJump(bUpdating);
            if (Pawn.Physics == 2)
            {
                GotoState(Pawn.LandMovementState);
            }
        }
    }
    
    event NotifyPhysicsVolumeChange(PhysicsVolume NewVolume)
    {
        if (!AlicePawn(Pawn).bSwitchToAnotherLedge)
        {
            if (NewVolume.bWaterVolume)
            {
                GotoState(Pawn.WaterMovementState);
            }
            else
            {
                GotoState(Pawn.LandMovementState);
            }
        }
    }
    
    exec function ChangeShrinkingMode()
    {
    }
    
    exec function ChangeCameraMode(bool bToggleTargeting)
    {
    }
    
    exec function StartFire(optional byte FireModeNum)
    {
    }
    
    function MeleeFire()
    {
    }
    
    Stop;
}

state PlayerWalking
{
    exec function TriggerDodge(bool bActive)
    {
        if (bActive)
        {
            Dodge();
        }
    }
    
    event EndState(name NextStateName)
    {
        EndState(NextStateName);
        StopCurrentMovementState();
    }
    
    event BeginState(name PreviousStateName)
    {
        BeginState(PreviousStateName);
        ClearPlayerPawnMovementFlags();
        SwitchToMovementState(0);
        setFacingSlideTarget(none);
        MyAlicePawn.bAllowFacingTargetInSpeicalMove = false;
        if (!MyAlicePawn.IsPawnInAStance(1))
        {
            MyAlicePawn.SetPawnStance(0);
        }
        AlicePawn(Pawn).TriggerDressPhysic(false, 0.0);
        AlicePawn(Pawn).ResetRotation();
        CycleFloatManager.OnEndFloat();
    }
    
    function UpdatePawnStance(Vector newAccel)
    {
        if (MyAlicePawn.IsPawnInAStance(0))
        {
            return;
        }
        if (MyAlicePawn.IsDoingAttackSpecialMove())
        {
            return;
        }
        if (VSize2D(newAccel) > 0.001 || bPressedJump)
        {
            if (MyAlicePawn.IsPawnInAStance(1))
            {
                if (MyAlicePawn.Weapon != none)
                {
                    if (bPressedJump && MyAlicePawn.Weapon.IsFiring())
                    {
                        WeaponForAlice(MyAlicePawn.Weapon).NotifyFireSpecialMoveFinished(MyAlicePawn.SpecialMove);
                    }
                    MyAlicePawn.FadeOutWeapon();
                }
                if (bUseLockOnCameraParameters)
                {
                    bUseLockOnCameraParameters = false;
                    SetTimer(MyAlicePawn.TimeDelayToCancelLockOnCameraParameters, false, 'ResetCameraPamameters');
                }
                SetWeaponEnviormentCollision(false);
            }
            MyAlicePawn.SetPawnStance(0);
        }
    }
    
    exec function ToggleSonar()
    {
        return;
        if (!bShrinkingModeActive)
        {
            return;
        }
        if (MyAlicePawn.bSonarAlwaysVisible)
        {
            SonarManager.SetActive(true);
        }
    }
    
    function Update2DDeltaRotation(float DeltaTime, Vector vAccel, out Rotator Rot)
    {
        local Rotator TargetRot;
        local float RawJoyRight;
        
        TargetRot = Pawn.Rotation;
        RawJoyRight = AlicePlayerInput(PlayerInput).GetRawJoyRight();
        if (Abs(RawJoyRight) > 0.3)
        {
            TargetRot.Yaw = (RawJoyRight > float(0) ? 16384 : -16384);
            Pawn.SetRotation(TargetRot);
        }
        else
        {
            TargetRot.Yaw = 16384;
            if (vector(Pawn.Rotation) Dot vector(TargetRot) > float(0))
            {
                Pawn.SetRotation(TargetRot);
            }
            else
            {
                TargetRot.Yaw = -16384;
                Pawn.SetRotation(TargetRot);
            }
        }
    }
    
    function updateFacingTargetRot()
    {
        local Vector vInput, VDir;
        local Rotator rNewRot;
        local Pawn npc;
        local Actor BKActor;
        
        if (!MyAlicePawn.bAllowFacingTargetInSpeicalMove)
        {
            return;
        }
        if (MyAlicePawn.IsDoingSpecialMove(37))
        {
            return;
        }
        if (getFacingSlideTarget() == none)
        {
            vInput = getInputVectorSlideToTarget();
            if (VSize(vInput) == 0.0)
            {
                VDir = Normal(vector(MyAlicePawn.Rotation));
            }
            else
            {
                VDir = Normal(vInput);
            }
            npc = getNPCInInputCone(VDir);
            if (npc == none)
            {
                BKActor = getBKActorInInputCone(VDir);
                if (BKActor == none)
                {
                    return;
                }
                else
                {
                    setFacingSlideTarget(BKActor);
                }
            }
            else
            {
                setFacingSlideTarget(npc);
            }
        }
        VDir = getFacingSlideTarget().Location - MyAlicePawn.Location;
        VDir.Z = 0.0;
        rNewRot = rotator(Normal(VDir));
        MyAlicePawn.SetRotation(rNewRot);
    }
    
    function PlayerMove(float DeltaTime)
    {
        local Vector newAccel;
        local EDoubleClickDir DoubleClickMove;
        local Rotator DeltaRot;
        local bool bSaveJump;
        local Vector PawnFacing, inputDir;
        local float ratio;
        
        if (PlayerCamera != none && PlayerCamera.CameraStyle == name("FreeCam"))
        {
            UpdateRotation(DeltaTime);
            if (!bSupportSecondController || !DoesAliceGameSupportSecondController())
            {
                return;
            }
        }
        if (Pawn == none)
        {
            GotoState('Dead');
        }
        else if (AlicePawn(Pawn).bFloatDown && !bCinematicMode)
        {
            GotoState('PlayerFloat');
        }
        else
        {
            if (Pawn.Physics == 2 && Pawn.Velocity.Z < float(0) && !bCinematicMode)
            {
                AlicePawn(Pawn).TriggerDressPhysic(true, 1.0);
            }
            if (IsOnSlidePlatform() && !MyAlicePawn.IsMeleeFiring())
            {
                MyAlicePawn.StopWeaponFire();
                MyAlicePawn.FadeOutWeapon();
                GotoState('PlayerSlide');
                return;
            }
            ProjectInputToCameraSpace();
            if (IsMaintainingMovement())
            {
                if (VSize(AlicePlayerInput(PlayerInput).InputVector) > float(0))
                {
                    inputDir = Normal(AlicePlayerInput(PlayerInput).InputVector);
                    AlicePlayerInput(PlayerInput).InputVector = inputDir * VSize(OriginalInputVector);
                    OriginalInputVector = AlicePlayerInput(PlayerInput).InputVector;
                }
                else
                {
                    ratio = 1.0 - fTimeLeftToMaintainMove / fTimeThresholdToMaintainMove;
                    if (ratio < float(0))
                    {
                        ratio = 0.0;
                        StopMaintainMovement();
                    }
                    fTimeLeftToMaintainMove += DeltaTime;
                    AlicePlayerInput(PlayerInput).InputVector = OriginalInputVector * ratio;
                }
            }
            if ((bShrinkingModeActive || MyAlicePawn.bSonarAlwaysVisible) && SonarManager.bActive)
            {
                SonarManager.Update(DeltaTime);
            }
            else
            {
                SonarManager.PostUpdate(DeltaTime);
            }
            if (MyAlicePawn.bIsDoingContextAction || MyAlicePawn.bIsTurning || bIsHoldingPOIButton)
            {
                UpdateRotation(DeltaTime);
                if (bIsHoldingPOIButton)
                {
                    Pawn.Acceleration = vect(0.0, 0.0, 0.0);
                    Pawn.Velocity = vect(0.0, 0.0, 0.0);
                    bPressedJump = false;
                }
                return;
            }
            UpdateCameraTargetingMode(DeltaTime);
            if (!bTargetingModeActive)
            {
                PawnFacing = vector(Pawn.Rotation);
                AngleBetweenInputAndPlayer = CalcAngleBetweenVectors(PawnFacing, AlicePlayerInput(PlayerInput).InputVector);
                PawnDirWhenRotateStarts = PawnFacing;
            }
            UpdateAccel(DeltaTime, newAccel);
            if (CheckInputForAutoClimb(newAccel))
            {
                return;
            }
            UpdatePawnStance(newAccel);
            if (AlicePawn(Pawn).bIsSprinting)
            {
                MyAlicePawn.GroundSpeed = MyAlicePawn.SprintSpeed;
            }
            else if (VSize(newAccel) < AccelThresholdToRun || AlicePawn(Pawn).EnduanceUsedUp() || AlicePawn(Pawn).isInConversationMode())
            {
                Pawn.GroundSpeed = AlicePawn(Pawn).MaxWalkingSpeed;
            }
            else if (!bShrinkingModeActive)
            {
                AlicePawn(Pawn).GroundSpeed = AlicePawn(Pawn).MaxRunningSpeed;
            }
            else
            {
                AlicePawn(Pawn).GroundSpeed = AlicePawn(Pawn).ShrinkMaxRunningSpeed;
            }
            DoubleClickMove = PlayerInput.CheckForDoubleClickMove(DeltaTime / WorldInfo.TimeDilation);
            bDoubleJump = false;
            if (bPressedJump && Pawn.CannotJumpNow() || bTargetingModeActive)
            {
                bSaveJump = true;
                bPressedJump = false;
            }
            else
            {
                if (bPressedJump && Pawn.GroundSpeed > AlicePawn(Pawn).MaxWalkingSpeed)
                {
                    AlicePawn(Pawn).bIsRunningJump = true;
                }
                bSaveJump = false;
            }
            if (MyAlicePawn.ArcheTypeID == 3)
            {
                Update2DDeltaRotation(DeltaTime, newAccel, DeltaRot);
            }
            else if (!MyAlicePawn.bAutoSnappingToLedge && !MyAlicePawn.bIsTurning)
            {
                UpdateDeltaRotation(DeltaTime, newAccel, DeltaRot);
            }
            if (Role < 3)
            {
                ReplicateMove(DeltaTime, newAccel, DoubleClickMove, DeltaRot);
            }
            else
            {
                ProcessMove(DeltaTime, newAccel, DoubleClickMove, DeltaRot);
            }
            UpdateRotation(DeltaTime);
            bPressedJump = bSaveJump;
        }
        updateFacingTargetRot();
    }
    
    function ProcessMove(float DeltaTime, Vector newAccel, EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
    {
        if (Pawn == none)
        {
            return;
        }
        if (bIsHoldingPOIButton)
        {
            Pawn.Acceleration = vect(0.0, 0.0, 0.0);
            Pawn.Velocity = vect(0.0, 0.0, 0.0);
            bPressedJump = false;
            return;
        }
        if (Role == 3)
        {
            Pawn.SetRemoteViewPitch(Rotation.Pitch);
        }
        Pawn.Acceleration = newAccel;
        Pawn.SetRotation(Pawn.Rotation + DeltaRot);
        CheckJumpOrDuck();
    }
    
    function UpdateDeltaRotation(float DeltaTime, Vector vAccel, out Rotator Rot)
    {
        local float fSign, RotSpeedFactor, DeltaYaw, Temp;
        local Vector NewDir;
        local Rotator NewRot;
        
        Rot.Pitch = 0;
        Rot.Roll = 0;
        Rot.Yaw = 0;
        if (bIsHoldingPOIButton)
        {
            return;
        }
        if (!bTargetingModeActive)
        {
            Temp = MyAlicePawn.AngleToRotate;
            if (VSize(vAccel) > float(0))
            {
                if (Abs(AngleBetweenInputAndPlayer) < 0.017453292)
                {
                    return;
                }
                fSign = AngleBetweenInputAndPlayer / Abs(AngleBetweenInputAndPlayer);
                if (Abs(AngleBetweenInputAndPlayer) > float(0) && Pawn.Physics == 2)
                {
                    DeltaYaw = MyAlicePawn.RotSpeedFactorInAir * 4.0 * fSign * DeltaTime;
                }
                else if (MyAlicePawn.bTurningWhileRunning)
                {
                    DeltaYaw = MyAlicePawn.RotSpeedFactor * 4.0 * fSign * DeltaTime;
                }
                else if (Abs(AngleBetweenInputAndPlayer) < AngleThresholdToCancelAccel)
                {
                    RotSpeedFactor = VSize(Pawn.Velocity) / MyAlicePawn.MaxWalkingSpeed;
                    DeltaYaw = AlicePawn(Pawn).RotSpeedFactor * RotSpeedFactor * fSign * DeltaTime;
                }
                if (Abs(DeltaYaw) > Abs(AngleBetweenInputAndPlayer))
                {
                    DeltaYaw = AngleBetweenInputAndPlayer;
                }
                Rot.Yaw = int(DeltaYaw * float(10430));
            }
            else if (MyAlicePawn.bInGiantMode)
            {
                fSign = AngleBetweenInputAndPlayer / Abs(AngleBetweenInputAndPlayer);
                DeltaYaw = AngleBetweenInputAndPlayer * fSign;
                Rot.Yaw = int(DeltaYaw * float(10430));
            }
            else if (Abs(Temp) > float(0))
            {
                Rot.Yaw = 0;
            }
        }
        else if (TargetingActor != none && TargetingActor == TargetNPCSocket.Pawn)
        {
            NewDir = TargetingActor.Location - Pawn.Location;
            NewDir.Z = 0.0;
            NewDir = Normal(NewDir);
            NewRot = rotator(NewDir);
            Rot.Yaw = NewRot.Yaw - Pawn.Rotation.Yaw;
        }
        else if (TargetingActor != none && TargetingActor == TargetBActorInfo.BActor)
        {
            NewDir = TargetBActorInfo.vLocation - Pawn.Location;
            NewDir.Z = 0.0;
            NewDir = Normal(NewDir);
            NewRot = rotator(NewDir);
            Rot.Yaw = NewRot.Yaw - Pawn.Rotation.Yaw;
        }
        else if (TargetingActor != none && TargetingActor == TargetSMAInfo.Actor)
        {
            NewDir = TargetSMAInfo.CollisionLockOnLoc - Pawn.Location;
            NewDir.Z = 0.0;
            NewDir = Normal(NewDir);
            NewRot = rotator(NewDir);
            Rot.Yaw = NewRot.Yaw - Pawn.Rotation.Yaw;
        }
    }
    
    function bool CheckInputForAutoClimb(Vector vAccel)
    {
        local float Angle;
        local Vector NewPos;
        local AlicePawn ap;
        
        if (VSize(vAccel) < 0.1)
        {
            return false;
        }
        ap = AlicePawn(Pawn);
        Angle = CalcAngleBetweenVectors(vector(Pawn.Rotation), AlicePlayerInput(PlayerInput).InputVector);
        if (ap.bReadyToAutoClimb && Abs(Angle) < 3.1415927 * 0.25)
        {
            if (bPressedJump)
            {
                bPressedJump = false;
                ap.bReadyToAutoClimb = false;
                NewPos = Pawn.Location;
                NewPos.Z += ap.AutoClimbTeleportHeight;
                Pawn.SetLocation(NewPos);
                NewPos = Pawn.Location + Normal(vAccel) * Pawn.CylinderComponent.CollisionRadius * 2.5;
                Pawn.SetLocation(NewPos);
                ap.AutoClimbTeleportHeight = 0.0;
                return true;
            }
        }
        return false;
    }
    
    function UpdateAccel(float DeltaTime, out Vector vAccel)
    {
        local bool bCannotMove, bIsFalling, bShouldDoInstantTurning;
        
        if (Pawn == none || PlayerCamera == none)
        {
            return;
        }
        if (MyAlicePawn.Physics == 1)
        {
            MyAlicePawn.bJumpToAnotherLedge = false;
        }
        else if (MyAlicePawn.bJumpToAnotherLedge && MyAlicePawn.Physics == 14 || MyAlicePawn.Physics == 2)
        {
            vAccel = vect(0.0, 0.0, 0.0);
            return;
        }
        if (!bTargetingModeActive)
        {
            if (!bShrinkingModeActive)
            {
                MyAlicePawn.MaxRunningSpeed = MyAlicePawn.default.MaxRunningSpeed;
            }
            else
            {
                MyAlicePawn.MaxRunningSpeed = MyAlicePawn.ShrinkMaxRunningSpeed;
            }
            if (Abs(AngleBetweenInputAndPlayer) > MyAlicePawn.AngleToFastTurn && VSize2D(Pawn.Velocity) == float(0) || MyAlicePawn.bInGiantMode)
            {
                bShouldDoInstantTurning = true;
            }
            bCannotMove = MyAlicePawn.bIsTurning || Abs(AngleBetweenInputAndPlayer) > AngleThresholdToCancelAccel || AlicePawn(Pawn).bIsBraking || bShouldDoInstantTurning;
            bIsFalling = MyAlicePawn.Physics == 2;
            if (bCannotMove && !bIsFalling && !MyAlicePawn.bTurningWhileRunning)
            {
                vAccel = vect(0.0, 0.0, 0.0);
            }
            else
            {
                vAccel = AlicePlayerInput(PlayerInput).InputVector;
                if (MyAlicePawn.bAutoSnappingToLedge)
                {
                    vAccel = VSize(vAccel) * vector(Pawn.Rotation);
                }
            }
            if (MyAlicePawn.bForceMaxAccel)
            {
                vAccel = MyAlicePawn.AccelRate * Normal(vAccel);
            }
        }
        else
        {
            MyAlicePawn.MaxRunningSpeed = MyAlicePawn.GetMaxStrafeSpeed();
            vAccel = AlicePlayerInput(PlayerInput).InputVector;
            if (MyAlicePawn.bForceMaxAccel)
            {
                vAccel = MyAlicePawn.AccelRate * Normal(vAccel);
            }
        }
        InputaUp = PlayerInput.aUp;
    }
    
    event NotifyPhysicsVolumeChange(PhysicsVolume NewVolume)
    {
        if (AliceWaterVolume(NewVolume) != none && AlicePawn(Pawn).bInWaterWalk && !AlicePawn(Pawn).bNeedSwimToTarget)
        {
            BackToSwimPos = AliceWaterVolume(NewVolume).SwimTargetPoint.Location;
            if (VSize(BackToSwimPos) > float(100))
            {
                AlicePawn(Pawn).bNeedSwimToTarget = true;
                IgnoreMoveInput(true);
            }
            else
            {
                AlicePawn(Pawn).bNeedSwimToTarget = false;
            }
        }
        if (AliceWaterVolume(NewVolume) != none && MyAlicePawn.bCollideWorld)
        {
            MyAlicePawn.bSwitchToSwim = true;
            SwitchToArcheType(6);
        }
        NotifyPhysicsVolumeChange(NewVolume);
    }
    
    exec function StartClockBombContextAction()
    {
        if (AlicePlayerInput(PlayerInput).bDisableInputInCinematic || !MyAlicePawn.bCanClockBomb)
        {
            return;
        }
        if (!MyAlicePawn.CanDoContextAction(true) || MyAlicePawn.bClockBombCountingDown || MyAlicePawn.MyClonePawn != none)
        {
            return;
        }
        if (MyAlicePawn.CurrentContextActor == none)
        {
            return;
        }
        if (ClockBombContextActor(MyAlicePawn.CurrentContextActor) == none)
        {
            return;
        }
        QuitFPS();
        bPressedJump = false;
        ShowContextActionUIHint(-1, MyAlicePawn.CurrentContextActor.UITextToDisplay);
        if (MyAlicePawn.Weapon != none)
        {
            MyAlicePawn.FadeOutWeapon();
        }
        MyAlicePawn.CurrentContextActor.StartContextAction();
    }
    
    exec function StartContextAction()
    {
        if (AlicePlayerInput(PlayerInput).bDisableInputInCinematic)
        {
            return;
        }
        if (!MyAlicePawn.CanDoContextAction(false))
        {
            return;
        }
        if (MyAlicePawn.CurrentContextActor == none)
        {
            return;
        }
        if (MyAlicePawn.bInGiantMode && MyAlicePawn.CurrentContextActor.bUseGiantStompActionButton)
        {
            return;
        }
        if (ClockBombContextActor(MyAlicePawn.CurrentContextActor) != none)
        {
            return;
        }
        MyAlicePawn.DiscardWatch();
        bPressedJump = false;
        ShowContextActionUIHint(-1, MyAlicePawn.CurrentContextActor.UITextToDisplay);
        if (MyAlicePawn.Weapon != none)
        {
            MyAlicePawn.FadeOutWeapon();
        }
        MyAlicePawn.CurrentContextActor.StartContextAction();
    }
    
    function CheckIsHoldingSprintButton()
    {
        if (!MyAlicePawn.bInLondon)
        {
            return;
        }
        MyAlicePawn.bSprintRTHold = AlicePlayerInput(PlayerInput).IsKeyPressed('XboxTypeS_LeftShoulder');
    }
    
    exec function TiggerSprint(bool bEnable)
    {
    }
    
    exec function ShowSpline()
    {
        if (AlicePlayerInput(PlayerInput).bDisableInputInCinematic || bShrinkingModeActive || !MyAlicePawn.bCanShowPath)
        {
            return;
        }
        GotoState('ShowSpline');
    }
    
    Stop;
}

auto state PlayerWaiting
{
    Begin:
    PlayerReplicationInfo.bOnlySpectator = false;
    WorldInfo.Game.bRestartLevel = false;
    WorldInfo.Game.RestartPlayer(self);
    WorldInfo.Game.bRestartLevel = true;
    Stop;
}

defaultproperties
{
    bSupportSecondController=True
    bCanSwitchMelee=True
    bCanFloatJump=True
    bAllowForceResetCamera=True
    bAllowAutoResetCamera=True
    bEnableCameraInertia=True
    bKeepAliceInFocus=True
    bCameraRightStickFree=True
    CommandFOVScale=1.0
    CommandCameraOffsetMax=(X=100000.0,Y=100000.0,Z=100000.0)
    CommandCameraOffsetMin=(X=-100000.0,Y=-100000.0,Z=-100000.0)
    AccelThresholdToRun=7000.0
    AngleThresholdToCancelAccel=2.6179938
    PlayerMovementStatesClasses(0)="AlicePlayer_StandMovementState"
    PlayerMovementStatesClasses(1)="AlicePlayer_CombatMovementState"
    PlayerMovementStatesClasses(2)="AlicePlayer_HangMovementState"
    Snd_TargetLockOn="SFX_Combat.Target_LockOn_Cue"
    Snd_TargetLockOff="SFX_Combat.Target_LockOff_Cue"
    Snd_TargetLockSwitch="SFX_Combat.Target_Switch_Cue"
    CloseInGameMenuSound="SFX_Menu.sfx_ui_ingame_return_to_game_Cue"
    fTimeToTriggerAutoResetCamera=4.0
    LatestRangeWeaponType=3
    LastPresenceSet=-1
    LastPresenceSet[1]=-1
    LastPresenceSet[2]=-1
    LastPresenceSet[3]=-1
    Sound_PGTOTC="SFX_Alice_Actions.sfx_alice_weaponswitch_teapot_Cue"
    Sound_TCTOPG="SFX_Alice_Actions.sfx_alice_weaponswitch_peppergrinder_Cue"
    PointOfInterestLookatInterpSpeedRange=(X=4.0,Y=4.0)
    GlideYawThreshold=75.0
    WeaponGroup=1
    LastSwitchTargetTime=100000000.0
    slideLoopSoundCue="SFX_Alice_Actions.sfx_alice_slide_loop_Cue"
    pinballSound1="SFX_C5_OWHH.sfx_owhh_roll_layer01_Cue"
    pinballSound2="SFX_C5_OWHH.sfx_owhh_roll_layer02_Cue"
    MeleeSlomoSoundCue="SFX_Combat.sfx_slowmo_warning_Cue"
    WeaponUpgradeToLevel2XPCost=150
    WeaponUpgradeToLevel2XPCost[1]=475
    WeaponUpgradeToLevel2XPCost[2]=500
    WeaponUpgradeToLevel2XPCost[3]=525
    WeaponUpgradeToLevel3XPCost=675
    WeaponUpgradeToLevel3XPCost[1]=575
    WeaponUpgradeToLevel3XPCost[2]=625
    WeaponUpgradeToLevel3XPCost[3]=600
    WeaponUpgradeToLevel4XPCost=800
    WeaponUpgradeToLevel4XPCost[1]=700
    WeaponUpgradeToLevel4XPCost[2]=775
    WeaponUpgradeToLevel4XPCost[3]=725
    UI_SetResCount=-1
    CameraClass="AlicePlayerCamera"
    CheatClass="AliceCheatManager"
    InputClass="AlicePlayerInput"
    CylinderComponent="Default__AlicePlayerController.CollisionCylinder"
    ForceFeedbackManagerClassName="WinDrv.XnaForceFeedbackManager"
    Components(0)="Default__AlicePlayerController.CollisionCylinder"
    CollisionComponent="Default__AlicePlayerController.CollisionCylinder"
}

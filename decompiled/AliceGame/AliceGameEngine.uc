class AliceGameEngine extends GameEngine
    native
    notplaceable
    transient
    config(Engine);

const XENONFILE_NOUSER_NOSAVING = -2;
const MAX_DATASIZE_FOR_ALL_CHECKPOINTS = 10000000;

enum AliceKeyType
{
    AliceKey_MoveForward,
    AliceKey_MoveBackward,
    AliceKey_MoveRight,
    AliceKey_MoveLeft,
    AliceKey_AimingMode,
    AliceKey_Shrink,
    AliceKey_LockOn,
    AliceKey_SwitchLockedTargetLeft,
    AliceKey_Dodge,
    AliceKey_Clockbomb,
    AliceKey_Jump,
    AliceKey_MeleeAttack,
    AliceKey_RangeAttack,
    AliceKey_ToggleMelee,
    AliceKey_SwitchPepperGrinder,
    AliceKey_SwitchTeapot,
    AliceKey_Block,
    AliceKey_CallCat,
    AliceKey_Menu,
    AliceKey_SwitchLockedTargetRight,
    AliceKey_PCAttackType,
    AliceKey_LockOn1,
    AliceKey_ChangeWeaponGroup,
    AliceKey_VorpalBladeAttack,
    AliceKey_PepperGrinderAttack,
    AliceKey_HobbyHorseAttack,
    AliceKey_ArmTeapotCannonAttack,
    AliceKey_LockOn2,
    AliceKey_Attack,
    AliceKey_ArmVorpalBlade,
    AliceKey_ArmPepperGrinder,
    AliceKey_ArmHobbyHorse,
    AliceKey_ArmTeapotCannon,
};

var Vector PendingCheckpointLocation;
var ECheckpointAction PendingCheckpointAction;
var ECheckpointActionFlag PendingCheckpointActionFlag;
var AliceCheckpoint CurrentCheckpoint;
var int CurrentUserID;
var int CurrentDeviceID;
var bool bDataCorrupted;
var bool bResetConfigData;
var bool bSaveDataCorrupted;
var bool bShouldWriteCheckpointToDisk;
var const transient bool bHasSelectedValidStorageDevice;
var bool bShowStartScreen;
var bool bShowAutoSaveWarning;
var bool bDefaultInvertControls;
var bool InvertY;
var bool Subtitles;
var bool AntiAlias;
var bool Stereo3D;
var bool MotionBlur;
var bool bPostprocess;
var bool bDynamicShadows;
var bool bFirstExecConfigData;
var bool bFinishGameOnHard;
var config bool GIsSpecialPCEdition;
var config int FailureMemoryHackThreshold;
var name StartStateName;
var int CurrentGameDifficulty;
var int LowestGameDifficulty;
var float Brightness;
var float SoundEffectVolume;
var float MusicVolume;
var float VoiceVolume;
var int ScreenPositionX;
var int ScreenPositionY;
var float Gamma;
var int GraphicsQuality;
var int ResolutionX;
var int ResolutionY;
var int GamepadType;
var int ControlLayout;
var name AliceKeys[66];
var name DefaultAliceKeys[66];
var int AttackType;
var float MouseSpeed;
var int LockOnType;
var config string Alice1Path;
var int UIMemory[100];
var int UIEnemy[100];
var int UIGallary[100];
var int UIVideo[50];
var int TheVeryLastCheckPointGot;
var float totalVentDuration;

function setFinishGameOnHard(bool bFinish)
{
    bFinishGameOnHard = bFinish;
}

function bool isFinishGameOnHard()
{
    return bFinishGameOnHard;
}

native function LaunchAlice1()
{
}

native function ExecResetKeyBindings()
{
}

event ExecMouseSpeed(float fSpeed)
{
    MouseSpeed = fSpeed;
    if (MouseSpeed != GamePlayers[0].Actor.PlayerInput.MouseSensitivity)
    {
        GameViewport.ConsoleCommand("SetSensitivity " $ string(fSpeed));
    }
    GamePlayers[0].Actor.PlayerInput.MouseSensitivity = fSpeed;
}

event ExecAttackType(int nAttackType)
{
    LogInternal("AliceKeySettings : SwitchPCAttackType......." @ string(nAttackType));
    AlicePlayerController(GamePlayers[0].Actor).SetPCAttackType(nAttackType);
}

native function int GetCompatCompositeIndex()
{
}

native function bool GetAliceKeyIndex(int Index, out byte nKeyType, out byte nKeyGroup)
{
    Index;
    nKeyType;
    nKeyGroup;
}

native function SetAliceKeys(byte nKeyType, byte nKeyGroup, name KeyName)
{
    nKeyType;
    nKeyGroup;
    KeyName;
}

native function name GetAliceKeys(byte nKeyType, byte nKeyGroup)
{
    nKeyType;
    nKeyGroup;
}

native function ExecRebindKey(byte nAliceKeyType, byte nAliceKeyGroup, name KeyName, out array<int> RemovedAliceKeys)
{
    nAliceKeyType;
    nAliceKeyGroup;
    KeyName;
    RemovedAliceKeys;
}

event ExecControlLayout(int nControlLayout)
{
    GameViewport.ConsoleCommand("SetControlLayout " $ string(nControlLayout));
}

event ExecGamepadType(int iGamepadType)
{
}

event ExecDynamicShadows(bool bEnableDynamicShadow)
{
    local string Str;
    
    Str = (bEnableDynamicShadow ? "true" : "false");
    GameViewport.ConsoleCommand("scale set DynamicShadows " $ Str);
}

event ExecPostprocess(bool bEnablePostProcess)
{
    if (GetShowPostprocess() != bEnablePostProcess)
    {
        GameViewport.ConsoleCommand("SHOW POSTPROCESS");
    }
}

event ExecMotionBlur(bool bMotionBlur)
{
    local string Str;
    
    Str = (bMotionBlur ? "true" : "false");
    GameViewport.ConsoleCommand("scale set MotionBlur " $ Str);
}

event ExecPhysXLevel(int iPhysX)
{
    local int MaxDestructionChunk;
    
    PhysXLevel = iPhysX;
    MaxDestructionChunk = GetDestructionMaxChunkCount(PhysXLevel);
    GameViewport.ConsoleCommand("ApexDestructibleMaxChunk " $ string(MaxDestructionChunk));
}

event ExecStereo3D(bool bStereo3D)
{
    EnableStereo3D(bStereo3D);
}

event ExecAntiAlias(bool bAntiAlias)
{
    local string Str;
    
    Str = (bAntiAlias ? "4" : "1");
    GameViewport.ConsoleCommand("scale set MaxMultiSamples " $ Str);
}

event ExecScreenResolution(int iResX, int iResY)
{
    GameViewport.ConsoleCommand("setres " $ string(iResX) $ "x" $ string(iResY));
}

event ExecGraphicsQuality(int iQuality)
{
    local string Str;
    
    switch (iQuality)
    {
        case 0:
            Str = "highend";
            break;
        case 1:
            Str = "lowend";
            break;
        default:
            Str = "highend";
            break;
    }
    GameViewport.ConsoleCommand("scale " $ Str);
}

event ExecGammaConfig(float fGamma)
{
    GameViewport.ConsoleCommand("gamma " $ string(fGamma));
}

event ExecSubtitles(bool bEnable)
{
    bSubtitlesEnabled = bEnable;
}

event ExecVoiceVolume(float fVolume)
{
    SetSoundVolume(2, fVolume);
}

event ExecMusicVolume(float fVolume)
{
    SetSoundVolume(1, fVolume);
}

event ExecSoundEffectVolume(float fVolume)
{
    SetSoundVolume(0, fVolume);
}

event ExecInvertY(bool bInvertY)
{
    if (bInvertY != GamePlayers[0].Actor.PlayerInput.bInvertMouse)
    {
        GamePlayers[0].Actor.PlayerInput.InvertMouse();
    }
}

event ExecLowestDifficulty(int iDifficulty)
{
}

event ExecDifficulty(int iDifficulty)
{
}

native function int GetDestructionMaxChunkCount(int nPhysLevel)
{
    nPhysLevel;
}

native function bool GetShowPostprocess()
{
}

native function SetNvPhysXLevel(int nPhysLevel)
{
    nPhysLevel;
}

native function EnableStereo3D(bool bEnabled)
{
    bEnabled;
}

native function GetSupportedResolutions(int Index, out int iResX, out int iResY)
{
    Index;
    iResX;
    iResY;
}

native function int GetNumOfSupportedResolutions()
{
}

native function bool DoesSupportMSAA(int MaxMultiSamples)
{
    MaxMultiSamples;
}

native function SetSoundVolume(int SoundType, float fVol)
{
    SoundType;
    fVol;
}

native function ExecConfigData()
{
}

function bool shouldDefaultInvertControls()
{
    local int Settings;
    
    Settings = AlicePlayerController(GamePlayers[0].Actor).GetUserProfileSettings(CurrentUserID, "XPROFILE_GAMER_YAXIS_INVERSION");
    LogInternal("[shouldDefaultInvertControls] " @ string(Settings));
    return Settings == 1;
}

function bool shouldShowAutoSaveWarning()
{
    return bShowAutoSaveWarning;
}

function ShowAutoSaveWarning()
{
    bShowAutoSaveWarning = true;
}

function donotShowAutoSaveWarning()
{
    bShowAutoSaveWarning = false;
}

function bool shouldShowStartScreen()
{
    return bShowStartScreen;
}

function ShowStartScreen()
{
    bShowStartScreen = true;
}

function donotShowStartScreen()
{
    bShowStartScreen = false;
}

event bool AreStorageWritesAllowed(optional bool bIgnoreDeviceStatus, optional int RequiredSize = 10000000)
{
    return bShouldWriteCheckpointToDisk && bIgnoreDeviceStatus || IsCurrentDeviceValid(RequiredSize);
}

event bool IsCurrentDeviceValid(optional int SizeNeeded)
{
    local OnlineSubsystem OnlineSub;
    local bool bResult;
    
    OnlineSub = GetOnlineSubsystem();
    if (OnlineSub != none && NotEqual_InterfaceInterface(OnlineSub.PlayerInterfaceEx, OnlinePlayerInterfaceEx(none)))
    {
        bResult = OnlineSub.PlayerInterfaceEx.IsDeviceValid(CurrentDeviceID, SizeNeeded);
    }
    return bResult;
}

native protected final function bool DeleteCheckpoints(optional out int ResultCode)
{
    ResultCode;
}

native protected final function LoadCheckpoint()
{
}

native protected final function SaveCheckpoint(Vector CheckpointLocation)
{
    CheckpointLocation;
}

native final function bool FindCheckpointData(int SlotIndex)
{
    SlotIndex;
}

native final function bool HasStorageDeviceBeenRemoved()
{
}

native final function int GetCurrentDeviceID()
{
}

native final function SetCurrentDeviceID(int NewDeviceID, optional bool bProfileSignedOut)
{
    NewDeviceID;
    bProfileSignedOut;
}

defaultproperties
{
    CurrentUserID=-1
    CurrentDeviceID=-1
    bShouldWriteCheckpointToDisk=True
    bShowStartScreen=True
    bShowAutoSaveWarning=True
    Subtitles=True
    bFirstExecConfigData=True
    StartStateName="PlayerWalking"
    CurrentGameDifficulty=1
    LowestGameDifficulty=1
    SoundEffectVolume=1.0
    MusicVolume=1.0
    VoiceVolume=1.0
    Gamma=2.2
    MouseSpeed=60.0
    Alice1Path="..\\..\\..\\Alice1\\bin"
}

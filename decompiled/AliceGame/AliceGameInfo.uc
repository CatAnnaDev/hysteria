class AliceGameInfo extends GameInfo
    native
    notplaceable
    config(Game)
    hidecategories(Navigation,Movement,Collision);

enum EAliceArcheType
{
    AType_London,
    AType_Wonderland,
    AType_Transition,
    AType_ShadowMode,
    AType_GiantMode,
    AType_RollingMode,
    AType_SwimMode,
    AType_WaterWalkMode,
    AType_Asylum,
};

struct native AliceDLCDesc
{
    var globalconfig string DLCName;
    var globalconfig string PS3UnlockFile;
};

var AlicePawn AliceArcheType;
var AlicePawn AliceCachedArcheType[9];
var AliceSpeechManager SpeechManager;
var RemoteSpeaker_Generic GenericRemoteSpeaker;
var AliceGFxMovie_HUD GFxHUDMenu;
var AliceGfxMovie_inGameMenu inGameMenu;
var config string GameplayEventsWriterClassName;
var transient GameplayEventsWriter GameplayEventsWriter;
var config bool bLogGameplayEvents;
var config bool DemoMode;
var config bool PlayTestMode;
var transient bool bTickDelaySaveLoad;
var config int ChapterSnoutNum[6];
var config int MaxMemoriesNum;
var config int MaxAliceFamilyMemories;
var config int MaxChallengeRoomsNum;
var config array<string> MemoriesBinkFileName;
var int ChapterComplete[6];
var int OverallCompletion;
var int CurrentSnoutNum;
var int CurrentAliceFamilyMemories;
var int TrohpyChallengeRoomCount;
var int TrophyInteractiveObjectCount;
var int HealthUpgradePickupCount;
var int UseGoldenPathCount;
var array<string> MemoriesCollected;
var int CurrentChapterSnoutNum[6];
var int CurrentMemoriesNum[6];
var int CurrentChallengeRoomCount[6];
var int CompleteGameOnAnyDifficult;
var int SkipCinematicCounter;
var int UseHysteriaCounter;
var int IsNewGamePlus;
var config float DamageMultiplierArray[4];
var config float AliceWeaponDamageMultiplier[4];
var config array<AliceDLCDesc> DLCContent;
var int DLC_VB_UnLock;
var int DLC_VB_Enable;
var int DLC_TC_UnLock;
var int DLC_TC_Enable;
var int DLC_HH_UnLock;
var int DLC_HH_Enable;
var int DLC_ES_UnLock;
var int DLC_ES_Enable;
var int DressAbilityActive_Oriental;
var int DressAbilityActive_Water;
var int DressAbilityActive_Hatter;
var int DressAbilityActive_Default;
var int DressAbilityActive_Queen;
var int DressAbilityActive_Doll;
var int DressAbilityActive_QFlesh;
var int DressAbilityActive_MatHatter;
var int DressAbilityActive_Chess;
var int DressAbilityActive_WRabbit;
var int DressAbilityActive_Cheshire;
var int DressAbilityActive_Caterpillar;
var float totalVentDuration;
var EAliceArcheType AliceArcheTypeID;
var int Achievement29;
var int Achievement41;
var int CurrentGameDifficulty;
var int LowestGameDifficulty;
var transient AliceGFXMovie SaveUI_GFXMoive;
var transient int SaveLoadCounter;
var transient float SaveLoadStartTime;
var transient string DelaySaveLoadString;

event NotifyDialogueStart(Actor Speaker, Actor Addressee, SoundCue Audio, ESpeechPriority PRI)
{
    SpeechManager.NotifyDialogueStart(Speaker, Addressee, Audio, PRI);
}

event NotifyDialogueFinish(Actor Speaker, SoundCue Sound)
{
    SpeechManager.NotifyDialogueFinish(Speaker, Sound);
}

function setLowestGameDifficulty(int I)
{
    if (class'Engine.Engine'.static.IsEditor() == true)
    {
        LowestGameDifficulty = I;
    }
    else
    {
        getAliceGameEngine().LowestGameDifficulty = I;
    }
}

event int getLowestGameDifficulty()
{
    if (class'Engine.Engine'.static.IsEditor() == true)
    {
        return LowestGameDifficulty;
    }
    else
    {
        return getAliceGameEngine().LowestGameDifficulty;
    }
}

function setCurrentGameDifficulty(int I)
{
    if (class'Engine.Engine'.static.IsEditor() == true)
    {
        CurrentGameDifficulty = I;
    }
    else
    {
        getAliceGameEngine().CurrentGameDifficulty = I;
    }
}

event int getCurrentGameDifficulty()
{
    if (class'Engine.Engine'.static.IsEditor() == true)
    {
        return CurrentGameDifficulty;
    }
    else
    {
        return getAliceGameEngine().CurrentGameDifficulty;
    }
}

event PostApplyPersistentData()
{
}

event PreSavePersistentData()
{
}

function GenericPlayerInitialization(Controller C)
{
    local PlayerController PC;
    
    PC = PlayerController(C);
    if (PC != none)
    {
        PC.ClientSetHUD(HUDType, ScoreBoardType);
        ReplicateStreamingStatus(PC);
        if (CoverReplicatorBase != none)
        {
            PC.SpawnCoverReplicator();
        }
        PC.ClientSetOnlineStatus();
    }
    if (BaseMutator != none)
    {
        BaseMutator.NotifyLogin(C);
    }
}

event CheckpointLoadComplete()
{
    local AlicePlayerController PC;
    
    foreach WorldInfo.AllControllers(class'AlicePlayerController', PC)
    {
        PC.RespawnAlice();
    }
}

function Pawn SpawnDefaultPawnFor(Controller NewPlayer, NavigationPoint StartSpot)
{
    local class<Pawn> DefaultPlayerClass;
    local Pawn ResultPawn;
    local Rotator StartRotation;
    
    DefaultPlayerClass = GetDefaultPlayerClass(NewPlayer);
    StartRotation.Yaw = StartSpot.Rotation.Yaw;
    AliceArcheTypeID = 1;
    ResultPawn = Spawn(DefaultPlayerClass, , , StartSpot.Location, StartRotation, AliceCachedArcheType[int(AliceArcheTypeID)]);
    if (ResultPawn == none)
    {
    }
    else
    {
        NewPlayer.Pawn = ResultPawn;
        PlayerController(NewPlayer).PlayerCamera.InitializeFor(PlayerController(NewPlayer));
        if (AlicePlayerController(NewPlayer) != none)
        {
            AlicePlayerController(NewPlayer).PostSpawnPawn();
        }
    }
    return ResultPawn;
}

function EndLogging(string Reason)
{
    if (GameplayEventsWriter != none)
    {
        GameplayEventsWriter.EndLogging();
    }
    EndLogging(Reason);
}

function NotifyChangedWeapon(Weapon PreviousWeapon, Weapon NewWeapon)
{
    if (NewWeapon != none)
    {
        if (WorldInfo.GetMapName() != "AliceEntry")
        {
            GFxHUDMenu.NotifyChangedWeapon(GetWeaponIDByClass(NewWeapon.Class));
        }
        if (WeaponForAliceRange(NewWeapon) != none)
        {
            WeaponForAliceRange(NewWeapon).UpdateAmmoUI();
        }
    }
}

function ShowPickupNewWeaponTip(class<Weapon> WeaponClass)
{
    if (WorldInfo.GetMapName() != "AliceEntry")
    {
        GFxHUDMenu.ShowWeaponFoundUI(GetWeaponIDByClass(WeaponClass));
    }
}

function ShowWeaponUpgradeTip(int oldLevel, int newLevel, class<Weapon> WeaponClass)
{
    if (WorldInfo.GetMapName() != "AliceEntry")
    {
        GFxHUDMenu.ShowWeaponUpgradeUI(GetWeaponIDByClass(WeaponClass));
    }
}

function ShowPickupMemoryFragmentTip(int TotalCount, int PickUpType)
{
    if (WorldInfo.GetMapName() != "AliceEntry")
    {
        GFxHUDMenu.ShowPickupTip(GetLocalizeString("PickedTip"), PickUpType);
    }
    if (WorldInfo.GetMapName() != "AliceEntry")
    {
        GFxHUDMenu.SetMFTotalCount(TotalCount);
    }
}

function ShowPickTips(bool bShow)
{
    if (bShow)
    {
        if (WorldInfo.GetMapName() != "AliceEntry")
        {
            GFxHUDMenu.ShowInteractPressX(0.0, GetLocalizeString("PickupTip"));
        }
    }
    else if (WorldInfo.GetMapName() != "AliceEntry")
    {
        GFxHUDMenu.ShowInteractPressX(-1.0, GetLocalizeString("PickupTip"));
    }
}

function string GetLocalizeString(string strTag)
{
    return Localize("Global", strTag, "GFxUI");
}

function UpdateTeethNumber(int XPValue)
{
    if (WorldInfo.GetMapName() != "AliceEntry")
    {
        GFxHUDMenu.UpdateTeethNumber(XPValue, false);
    }
}

function UpdateAliceHealth(int curHealth, int maxHealth)
{
    if (WorldInfo.GetMapName() != "AliceEntry")
    {
        GFxHUDMenu.UpdateAliceHealth(curHealth, maxHealth);
    }
}

function forceUpdateTeapotCannonAmmo()
{
    if (WorldInfo.GetMapName() != "AliceEntry")
    {
        GFxHUDMenu.forceSetTeapotCannonAmmo();
    }
}

function UpdateTeapotCannonAmmo(float newAmmoCount, float maxCount)
{
    if (WorldInfo.GetMapName() != "AliceEntry")
    {
        GFxHUDMenu.SetTeapotCannonAmmo(newAmmoCount, maxCount);
    }
}

function forceUpdateEyestaffAmmo()
{
    if (WorldInfo.GetMapName() != "AliceEntry")
    {
        GFxHUDMenu.forceSetEyestaffAmmo();
    }
}

function UpdateEyestaffAmmo(float newAmmoCount, float maxCount)
{
    if (WorldInfo.GetMapName() != "AliceEntry")
    {
        GFxHUDMenu.SetEyestaffAmmo(newAmmoCount, maxCount);
    }
}

function ReSetUIAfterLoadCheckPoint()
{
    if (WorldInfo.GetMapName() != "AliceEntry")
    {
        GFxHUDMenu.ReSetUIAfterLoadCheckPoint();
    }
}

function int GetWeaponIDByClass(class<Weapon> WeaponClass)
{
    local int Id;
    
    Id = 0;
    switch (WeaponClass)
    {
        case class'VorpalBlade':
            Id = 1;
            break;
        case class'TeapotCannon':
            Id = 4;
            break;
        case class'HobbyHorse':
            Id = 2;
            break;
        case class'EyeStaff':
            Id = 3;
            break;
        default:
    }
    return Id;
}

event PostBeginPlay()
{
    local class<GameplayEventsWriter> GameplayEventsWriterClass;
    
    GenericRemoteSpeaker = Spawn(class'RemoteSpeaker_Generic');
    SpeechManager = Spawn(class'AliceSpeechManager');
    PostBeginPlay();
    if (bLogGameplayEvents && GameplayEventsWriterClassName != "")
    {
        GameplayEventsWriterClass = class<AliceGameplayEventsWriter>(FindObject(GameplayEventsWriterClassName, class'Core.Class'));
        if (GameplayEventsWriterClass != none)
        {
            LogInternal("Recording game events with" @ string(GameplayEventsWriterClass));
            GameplayEventsWriter = new(self) GameplayEventsWriterClass;
            GameplayEventsWriter.StartLogging(0.5);
        }
        else
        {
            LogInternal("Unable to record game events with" @ GameplayEventsWriterClassName);
        }
    }
    else
    {
        LogInternal("Gameplay events will not be recorded.");
    }
}

event ToggleCritical(bool Actived)
{
    if (WorldInfo.GetMapName() != "AliceEntry")
    {
        GFxHUDMenu.ToggleCritical(Actived);
    }
}

event HideSaveHintImmediately()
{
    LogInternal("HideSaveHintImmediately ");
    SaveUI_GFXMoive.ShowSaveOrLoadHint("save", false);
    SaveLoadCounter = 0;
}

event HideExistingSaveHint()
{
    LogInternal("HideExistingSaveHint ");
    SaveUI_GFXMoive.ShowSaveOrLoadHint("save", false);
}

event ShowSaveOrLoadHint(string SaveOrLoad, bool ShowOrHide)
{
    local float Seconds;
    
    Seconds = GetAppSeconds();
    LogInternal("ShowSaveOrLoadHint " @ SaveOrLoad @ " " @ string(ShowOrHide) @ " " @ string(Seconds));
    if (ShowOrHide)
    {
        SaveLoadCounter = 1;
        SaveLoadStartTime = Seconds;
        SaveUI_GFXMoive.ShowSaveOrLoadHint(SaveOrLoad, ShowOrHide);
    }
    else
    {
        SaveLoadCounter = 0;
        DelaySaveLoadString = SaveOrLoad;
        bTickDelaySaveLoad = true;
        DelayDisappearUI();
        LogInternal("try DelayDisappearUI " @ string(Seconds) @ " retry at " @ string(3.01 - (Seconds - SaveLoadStartTime)));
        SetTimer(3.01 - (Seconds - SaveLoadStartTime), false, 'DelayDisappearUI');
    }
}

event ShowStreamHint(bool ShowOrHide)
{
    LogInternal("ShowStreamHint" @ string(ShowOrHide));
    SaveUI_GFXMoive.ShowStreamHint(ShowOrHide);
}

function DelayDisappearUI()
{
    local float Seconds;
    
    Seconds = GetAppSeconds();
    if (bTickDelaySaveLoad)
    {
        if (Seconds - SaveLoadStartTime > 3.0)
        {
            LogInternal("DelayDisappearUI");
            SaveUI_GFXMoive.ShowSaveOrLoadHint(DelaySaveLoadString, false);
            bTickDelaySaveLoad = false;
        }
        else
        {
            SetTimer(3.01 - (Seconds - SaveLoadStartTime), false, 'DelayDisappearUI');
        }
    }
}

event PreBeginPlay()
{
    PreBeginPlay();
    if (WorldInfo.GetMapName() != "AliceEntry")
    {
        GFxHUDMenu = AliceGFxMovie_HUD'AliceGameUI.HUD.HUD_1';
        inGameMenu = AliceGfxMovie_inGameMenu'AliceGameUI.inGameMenu.inGameMenu_1';
    }
}

event InitGame(string Options, out string ErrorMessage)
{
    InitGame(Options, ErrorMessage);
}

exec function UnLockAllChapter()
{
    MyCheckPointManager.UnLockAllChapter();
}

exec function CDLevel(optional int Level = 1)
{
    setCurrentGameDifficulty(Level);
}

exec function Restart()
{
    RestartGame();
}

function SetDressAbilityActive_Caterpillar(bool Set)
{
    DressAbilityActive_Caterpillar = int(Set);
}

function bool GetDressAbilityActive_Caterpillar()
{
    return DressAbilityActive_Caterpillar > 0;
}

function SetDressAbilityActive_Cheshire(bool Set)
{
    DressAbilityActive_Cheshire = int(Set);
}

function bool GetDressAbilityActive_Cheshire()
{
    return DressAbilityActive_Cheshire > 0;
}

function SetDressAbilityActive_WRabbit(bool Set)
{
    DressAbilityActive_WRabbit = int(Set);
}

function bool GetDressAbilityActive_WRabbit()
{
    return DressAbilityActive_WRabbit > 0;
}

function SetDressAbilityActive_Chess(bool Set)
{
    DressAbilityActive_Chess = int(Set);
}

function bool GetDressAbilityActive_Chess()
{
    return DressAbilityActive_Chess > 0;
}

function SetDressAbilityActive_MatHatter(bool Set)
{
    DressAbilityActive_MatHatter = int(Set);
}

function bool GetDressAbilityActive_MatHatter()
{
    return DressAbilityActive_MatHatter > 0;
}

function SetDressAbilityActive_QFlesh(bool Set)
{
    DressAbilityActive_QFlesh = int(Set);
}

function bool GetDressAbilityActive_QFlesh()
{
    return DressAbilityActive_QFlesh > 0;
}

function SetDressAbilityActive_Doll(bool Set)
{
    DressAbilityActive_Doll = int(Set);
}

function bool GetDressAbilityActive_Doll()
{
    return DressAbilityActive_Doll > 0;
}

function SetDressAbilityActive_Queen(bool Set)
{
    DressAbilityActive_Queen = int(Set);
}

function bool GetDressAbilityActive_Queen()
{
    return DressAbilityActive_Queen > 0;
}

function SetDressAbilityActive_Default(bool Set)
{
    DressAbilityActive_Default = int(Set);
}

function bool GetDressAbilityActive_Default()
{
    return DressAbilityActive_Default > 0;
}

function SetDressAbilityActive_Hatter(bool Set)
{
    DressAbilityActive_Hatter = int(Set);
}

function bool GetDressAbilityActive_Hatter()
{
    return DressAbilityActive_Hatter > 0;
}

function SetDressAbilityActive_Water(bool Set)
{
    DressAbilityActive_Water = int(Set);
}

function bool GetDressAbilityActive_Water()
{
    return DressAbilityActive_Water > 0;
}

function SetDressAbilityActive_Oriental(bool Set)
{
    DressAbilityActive_Oriental = int(Set);
}

function bool GetDressAbilityActive_Oriental()
{
    return DressAbilityActive_Oriental > 0;
}

function ChangeWeaponNormal_ES(AlicePlayerController APC)
{
    SetIsDLC_ES_Enable(false);
    APC.UpgradeWeapon(class'EyeStaff', APC.GetEyeStaffLevel());
}

function ChangeWeaponDLC_ES(AlicePlayerController APC)
{
    SetIsDLC_ES_UnLock(true);
    SetIsDLC_ES_Enable(true);
    APC.UpgradeWeapon(class'EyeStaff', APC.GetEyeStaffLevel());
}

function SetIsDLC_ES_Enable(bool Set)
{
    DLC_ES_Enable = int(Set);
}

function bool GetIsDLC_ES_Enable()
{
    return DLC_ES_Enable > 0;
}

function SetIsDLC_ES_UnLock(bool Set)
{
    DLC_ES_UnLock = int(Set);
}

function bool GetIsDLC_ES_UnLock()
{
    return DLC_ES_UnLock > 0;
}

function ChangeWeaponNormal_HH(AlicePlayerController APC)
{
    SetIsDLC_HH_Enable(false);
    APC.UpgradeWeapon(class'HobbyHorse', APC.GetHobbyHorseLevel());
}

function ChangeWeaponDLC_HH(AlicePlayerController APC)
{
    SetIsDLC_HH_UnLock(true);
    SetIsDLC_HH_Enable(true);
    APC.UpgradeWeapon(class'HobbyHorse', APC.GetHobbyHorseLevel());
}

function SetIsDLC_HH_Enable(bool Set)
{
    DLC_HH_Enable = int(Set);
}

function bool GetIsDLC_HH_Enable()
{
    return DLC_HH_Enable > 0;
}

function SetIsDLC_HH_UnLock(bool Set)
{
    DLC_HH_UnLock = int(Set);
}

function bool GetIsDLC_HH_UnLock()
{
    return DLC_HH_UnLock > 0;
}

function ChangeWeaponNormal_TC(AlicePlayerController APC)
{
    SetIsDLC_TC_Enable(false);
    APC.UpgradeWeapon(class'TeapotCannon', APC.GetTeaPotLevel());
}

function ChangeWeaponDLC_TC(AlicePlayerController APC)
{
    SetIsDLC_TC_UnLock(true);
    SetIsDLC_TC_Enable(true);
    APC.UpgradeWeapon(class'TeapotCannon', APC.GetTeaPotLevel());
}

function SetIsDLC_TC_Enable(bool Set)
{
    DLC_TC_Enable = int(Set);
}

function bool GetIsDLC_TC_Enable()
{
    return DLC_TC_Enable > 0;
}

function SetIsDLC_TC_UnLock(bool Set)
{
    DLC_TC_UnLock = int(Set);
}

function bool GetIsDLC_TC_UnLock()
{
    return DLC_TC_UnLock > 0;
}

function ChangeWeaponNormal_VB(AlicePlayerController APC)
{
    SetIsDLC_VB_Enable(false);
    APC.UpgradeWeapon(class'VorpalBlade', APC.GetVorpalBladeLevel());
}

function ChangeWeaponDLC_VB(AlicePlayerController APC)
{
    SetIsDLC_VB_UnLock(true);
    SetIsDLC_VB_Enable(true);
    APC.UpgradeWeapon(class'VorpalBlade', APC.GetVorpalBladeLevel());
}

function SetIsDLC_VB_Enable(bool Set)
{
    DLC_VB_Enable = int(Set);
}

function bool GetIsDLC_VB_Enable()
{
    return DLC_VB_Enable > 0;
}

function SetIsDLC_VB_UnLock(bool Set)
{
    DLC_VB_UnLock = int(Set);
}

function bool GetIsDLC_VB_UnLock()
{
    return DLC_VB_UnLock > 0;
}

exec function MakeFullSaveCM()
{
    MakeFullSave();
}

native function MakeFullSave()
{
}

native function bool IsInSavingLoadingProcess()
{
}

native function AliceGameEngine getAliceGameEngine()
{
}

native function ResumeAllNpcTick()
{
}

native function PauseAllNpcTick(array<Object> ExceptNpcs)
{
    ExceptNpcs;
}

native function bool HaveLastCheckpointFile()
{
}

native function LoadLastCheckpointFromTitleMenu()
{
}

native function DeleteGameData(AliceGFXMovie GFxMovie)
{
    GFxMovie;
}

native function SavePersistentSaveDataAndConfigData(AliceGFXMovie GFxMovie)
{
    GFxMovie;
}

native function SaveConfigSaveData(AliceGFXMovie GFxMovie)
{
    GFxMovie;
}

native function SavePersistentSaveDataAndCheckPoint(AliceGFXMovie GFxMovie)
{
    GFxMovie;
}

native function SavePersistentSaveData(AliceGFXMovie GFxMovie)
{
    GFxMovie;
}

native function InitLoadPersistentSaveData()
{
}

native function float GetAppSeconds()
{
}

auto state PendingMatch
{
    Begin:
    StartMatch();
    Stop;
}

defaultproperties
{
    AliceCachedArcheType="CHAR_ArcheTypes.ArcheType_AliceLondon"
    AliceCachedArcheType[1]="CHAR_ArcheTypes.ArcheType_AliceWonderland"
    AliceCachedArcheType[2]="CHAR_ArcheTypes.ArcheType_AliceTransition"
    AliceCachedArcheType[3]="CHAR_ArcheTypes.ArcheType_AliceShadowMode"
    AliceCachedArcheType[4]="CHAR_ArcheTypes.ArcheType_AliceGiantMode"
    AliceCachedArcheType[5]="CHAR_ArcheTypes.ArcheType_AliceRollingMode"
    AliceCachedArcheType[7]="CHAR_ArcheTypes.ArcheType_AliceWaterWalkMode"
    AliceCachedArcheType[8]="CHAR_ArcheTypes.ArcheType_AliceAsylum"
    GameplayEventsWriterClassName="Engine.AliceGameplayEventsWriter"
    ChapterSnoutNum=14
    ChapterSnoutNum[1]=15
    ChapterSnoutNum[2]=11
    ChapterSnoutNum[3]=11
    ChapterSnoutNum[4]=8
    MaxMemoriesNum=100
    MaxAliceFamilyMemories=20
    MaxChallengeRoomsNum=100
    MemoriesBinkFileName(0)="BinkTest"
    DamageMultiplierArray=0.75
    DamageMultiplierArray[1]=1.0
    DamageMultiplierArray[2]=1.5
    DamageMultiplierArray[3]=3.0
    AliceWeaponDamageMultiplier=1.5
    AliceWeaponDamageMultiplier[1]=1.0
    AliceWeaponDamageMultiplier[2]=1.0
    AliceWeaponDamageMultiplier[3]=0.75
    DLCContent(0)=(DLCName="Alice 1",PS3UnlockFile="ALICE1_UNLOCK.EDAT")
    DressAbilityActive_QFlesh=1
    DressAbilityActive_MatHatter=1
    DressAbilityActive_Chess=1
    DressAbilityActive_WRabbit=1
    DressAbilityActive_Cheshire=1
    DressAbilityActive_Caterpillar=1
    CurrentGameDifficulty=1
    DelaySaveLoadString="save"
    bDelayedStart=False
    DefaultPawnClass="AlicePawn"
    HUDType="AliceHud"
    CheckPointManagerClass="AliceCheckPointManager"
    PlayerControllerClass="AlicePlayerController"
}

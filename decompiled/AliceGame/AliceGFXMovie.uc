class AliceGFXMovie extends GFxMovie
    notplaceable;

var transient AlicePlayerController APC;
var bool bIsOpen;
var int tempKeyX;
var int tempKeyY;
var() SoundCue WeaponPickupSound;
var() SoundCue SelectSound;
var() SoundCue SelectBackSound;
var() SoundCue OptionHighLightSound;
var() SoundCue UpgradeWeaponSuccessSound;

function bool IsFrechKeyboard()
{
    return GetAlicePlayerController().IsFrechKeyboard();
}

function Restart()
{
    APC.SetPause(false);
    AliceGameInfo(APC.WorldInfo.Game).GFxHUDMenu.Hide(false);
    SetFocus(false, false);
    AliceGameInfo(APC.WorldInfo.Game).LoadLastCheckpointFromTitleMenu();
    APC.RestartAlice();
    APC.ResetFade();
}

function PlaySound(string Index)
{
    switch (Index)
    {
        case "SelectSound":
            APC.PlaySound(SelectSound);
            break;
        case "SelectBackSound":
            APC.PlaySound(SelectBackSound);
            break;
        default:
    }
}

function SetSelfGFXMovie()
{
    GetAlicePlayerController().UI_SetGFXMovie(self);
}

function StartNewGame()
{
    if (!AliceGameInfo(GetAlicePlayerController().WorldInfo.Game).IsInSavingLoadingProcess())
    {
        ActionScriptVoid("_root.page_0.card_2.newGame");
    }
}

function closeRedeemPurchasePop()
{
    ActionScriptVoid("_root.playerMenu.closeRedeemPurchasePop");
}

function reloadTitleMenu()
{
    ActionScriptVoid("_root.playerMenu.CreateMainMenu");
}

function bool getLastCheckPoint()
{
    return getConfigDataManager().getTheVeryLastCheckPointGot() == 1;
}

function setLastCheckPoint(bool bFlag)
{
    getConfigDataManager().setTheVeryLastCheckPointGot(bFlag ? 1 : 0);
}

function bool GetDressAbilityActive(int iDressId)
{
    switch (iDressId)
    {
        case 1:
            return AliceGameInfo(GetAlicePlayerController().WorldInfo.Game).GetDressAbilityActive_Default();
            break;
        case 2:
            return AliceGameInfo(GetAlicePlayerController().WorldInfo.Game).GetDressAbilityActive_Hatter();
            break;
        case 3:
            return AliceGameInfo(GetAlicePlayerController().WorldInfo.Game).GetDressAbilityActive_Water();
            break;
        case 4:
            return AliceGameInfo(GetAlicePlayerController().WorldInfo.Game).GetDressAbilityActive_Oriental();
            break;
        case 5:
            return AliceGameInfo(GetAlicePlayerController().WorldInfo.Game).GetDressAbilityActive_Queen();
            break;
        case 6:
            return AliceGameInfo(GetAlicePlayerController().WorldInfo.Game).GetDressAbilityActive_Doll();
            break;
        default:
    }
}

function bool IsPlayingBinkFile()
{
    return GetAlicePlayerController().IsPlayingBinkFile("");
}

function SetRenderSubtitles(bool show)
{
    GetAlicePlayerController().SetRenderSubtitles(show);
}

function bool canShowResetMenu()
{
    local AlicePlayerController alicePlayerCon;
    
    alicePlayerCon = GetAlicePlayerController();
    if (alicePlayerCon != none && alicePlayerCon.ChessBoardActor != none)
    {
        return alicePlayerCon.ChessBoardActor.canShowResetMenu();
    }
    return false;
}

function string GetLanguage()
{
    return GetAlicePlayerController().GetLanguage();
}

function bool PS3UseCircleToAccept()
{
    return GetAlicePlayerController().PS3UseCircleToAccept();
}

function ShowSaveOrLoadHint(string SaveOrLoad, bool ShowOrHide)
{
    ActionScriptVoid("_root.ShowSaveOrLoadHint");
}

function ShowStreamHint(bool ShowOrHide)
{
    ActionScriptVoid("_root.ShowStreamHint");
}

function bool canUpgradeWeapon()
{
    return GetAlicePlayerController().MyAlicePawn.WeaponParas.Length >= 4;
}

function DeleteGameData()
{
    AliceGameInfo(GetAlicePlayerController().WorldInfo.Game).DeleteGameData(self);
}

function int GetCurAliceWonderlandDress()
{
    return GetAlicePlayerController().GetCurAliceWonderlandDress();
}

function bool GetGStoryMode()
{
    return GetAlicePlayerController().GetGStoryMode();
}

function SetInMainMenu(bool bInMainMenu)
{
    GetAlicePlayerController().SetInMainMenu(bInMainMenu);
}

function changeDlcWeapon(int weapon_id, int openDlc)
{
    switch (weapon_id)
    {
        case 1:
            if (openDlc == 0)
            {
                ChangeWeaponNormal_VB();
            }
            else
            {
                ChangeWeaponDLC_VB();
            }
            break;
        case 2:
            if (openDlc == 0)
            {
                ChangeWeaponNormal_ES();
            }
            else
            {
                ChangeWeaponDLC_ES();
            }
            break;
        case 3:
            if (openDlc == 0)
            {
                ChangeWeaponNormal_HH();
            }
            else
            {
                ChangeWeaponDLC_HH();
            }
            break;
        case 4:
            if (openDlc == 0)
            {
                ChangeWeaponNormal_TC();
            }
            else
            {
                ChangeWeaponDLC_TC();
            }
            break;
        default:
    }
}

function ChangeWeaponNormal_TC()
{
    AliceGameInfo(GetAlicePlayerController().WorldInfo.Game).ChangeWeaponNormal_TC(GetAlicePlayerController());
    AliceGameInfo(GetAlicePlayerController().WorldInfo.Game).SetIsDLC_TC_Enable(false);
}

function ChangeWeaponNormal_ES()
{
    AliceGameInfo(GetAlicePlayerController().WorldInfo.Game).ChangeWeaponNormal_ES(GetAlicePlayerController());
    AliceGameInfo(GetAlicePlayerController().WorldInfo.Game).SetIsDLC_ES_Enable(false);
}

function ChangeWeaponNormal_HH()
{
    AliceGameInfo(GetAlicePlayerController().WorldInfo.Game).ChangeWeaponNormal_HH(GetAlicePlayerController());
    AliceGameInfo(GetAlicePlayerController().WorldInfo.Game).SetIsDLC_HH_Enable(false);
}

function ChangeWeaponNormal_VB()
{
    AliceGameInfo(GetAlicePlayerController().WorldInfo.Game).ChangeWeaponNormal_VB(GetAlicePlayerController());
    AliceGameInfo(GetAlicePlayerController().WorldInfo.Game).SetIsDLC_VB_Enable(false);
}

function ChangeWeaponDLC_TC()
{
    AliceGameInfo(GetAlicePlayerController().WorldInfo.Game).ChangeWeaponDLC_TC(GetAlicePlayerController());
    AliceGameInfo(GetAlicePlayerController().WorldInfo.Game).SetIsDLC_TC_Enable(true);
}

function ChangeWeaponDLC_ES()
{
    AliceGameInfo(GetAlicePlayerController().WorldInfo.Game).ChangeWeaponDLC_ES(GetAlicePlayerController());
    AliceGameInfo(GetAlicePlayerController().WorldInfo.Game).SetIsDLC_ES_Enable(true);
}

function ChangeWeaponDLC_HH()
{
    AliceGameInfo(GetAlicePlayerController().WorldInfo.Game).ChangeWeaponDLC_HH(GetAlicePlayerController());
    AliceGameInfo(GetAlicePlayerController().WorldInfo.Game).SetIsDLC_HH_Enable(true);
}

function ChangeWeaponDLC_VB()
{
    AliceGameInfo(GetAlicePlayerController().WorldInfo.Game).ChangeWeaponDLC_VB(GetAlicePlayerController());
    AliceGameInfo(GetAlicePlayerController().WorldInfo.Game).SetIsDLC_VB_Enable(true);
}

function bool GetIsDLC_TC_Enable()
{
    return AliceGameInfo(GetAlicePlayerController().WorldInfo.Game).GetIsDLC_TC_Enable();
}

function bool GetIsDLC_ES_Enable()
{
    return AliceGameInfo(GetAlicePlayerController().WorldInfo.Game).GetIsDLC_ES_Enable();
}

function bool GetIsDLC_HH_Enable()
{
    return AliceGameInfo(GetAlicePlayerController().WorldInfo.Game).GetIsDLC_HH_Enable();
}

function bool GetIsDLC_VB_Enable()
{
    return AliceGameInfo(GetAlicePlayerController().WorldInfo.Game).GetIsDLC_VB_Enable();
}

function int getWeaponUpgradeXp(int weapon_id, int level_id)
{
    switch (level_id)
    {
        case 2:
            return GetAlicePlayerController().WeaponUpgradeToLevel2XPCost[weapon_id];
            break;
        case 3:
            return GetAlicePlayerController().WeaponUpgradeToLevel3XPCost[weapon_id];
            break;
        case 4:
            return GetAlicePlayerController().WeaponUpgradeToLevel4XPCost[weapon_id];
            break;
        default:
    }
}

function DLCExitToStore()
{
    GetAlicePlayerController().DLCExitToStore();
}

function DLCPurchase(int Item)
{
    GetAlicePlayerController().DLCPurchase(Item);
}

function DLCRedeemCode()
{
    GetAlicePlayerController().DLCRedeemCode();
}

function int DLCGetStatus(int Item)
{
    return GetAlicePlayerController().DLCGetStatus(Item);
}

function DLCStopCheckThread()
{
    GetAlicePlayerController().DLCStopCheckThread();
}

function DLCStartCheckThread()
{
    GetAlicePlayerController().DLCStartCheckThread();
}

function bool IsPepperGrinderAvailable()
{
    return GetAlicePlayerController().IsPepperGrinderAvailable();
}

function bool IsTeapotCannonAvailable()
{
    return GetAlicePlayerController().IsTeapotCannonAvailable();
}

function setUIVideo(int Idx)
{
    if (Idx < 0 || Idx > 49)
    {
        return;
    }
    getConfigDataManager().setUIVideo(Idx);
}

function array<int> getUIVideo()
{
    return getConfigDataManager().getUIVideo();
}

function setUIGallary(int Idx)
{
    if (Idx < 0 || Idx > 99)
    {
        return;
    }
    getConfigDataManager().setUIGallary(Idx);
}

function array<int> getUIGallary()
{
    return getConfigDataManager().getUIGallary();
}

function setUIEnemy(int Idx)
{
    if (Idx < 0 || Idx > 99)
    {
        return;
    }
    getConfigDataManager().setUIEnemy(Idx);
}

function array<int> getUIEnemy()
{
    return getConfigDataManager().getUIEnemy();
}

function setUIMemory(int Idx)
{
    if (Idx < 0 || Idx > 99)
    {
        return;
    }
    getConfigDataManager().setUIMemory(Idx);
}

function array<int> getUIMemory()
{
    return getConfigDataManager().getUIMemory();
}

function StopMemory()
{
    GetAlicePlayerController().StopBinkFile();
}

function PlayMemory(string Filename, optional bool bBlock = true, optional bool bSoundOnly = false)
{
    GetAlicePlayerController().UI_PlayMemory(Filename, bBlock, bSoundOnly, self);
}

function float getCompletePercent()
{
    return GetAlicePlayerController().calcCompletePercent();
}

function bool canWeaponUpgrade()
{
    local int iResult;
    
    iResult = GetAlicePlayerController().iFirstTimeWeaponUpgrade;
    return iResult == 0;
}

function finishFirstWeaponUpgrade()
{
    SetFocus(false, false);
    GetAlicePlayerController().iFirstTimeWeaponUpgrade = 1;
}

function setTeethNumber(int teeth)
{
    GetAlicePlayerController().SetXPValue(teeth);
}

function int getTeethNumber()
{
    return GetAlicePlayerController().WorldInfo.GetLocalPlayerPawn().XPValue;
}

function int GetEyeStaffLevel()
{
    return GetAlicePlayerController().GetEyeStaffLevel();
}

function int GetTeaPotLevel()
{
    return GetAlicePlayerController().GetTeaPotLevel();
}

function int GetHobbyHorseLevel()
{
    return GetAlicePlayerController().GetHobbyHorseLevel();
}

function int GetVorpalBladeLevel()
{
    return GetAlicePlayerController().GetVorpalBladeLevel();
}

function exitGame()
{
    GetGameViewportClient().ConsoleCommand("exit");
}

function int getHealthUpgradePickupCount()
{
    return AliceGameInfo(GetAlicePlayerController().WorldInfo.Game).HealthUpgradePickupCount % 4;
}

function string GetMapName()
{
    return GetAlicePlayerController().WorldInfo.GetMapName();
}

function string getSecretPickByChap(bool bGetBig)
{
    local int I, Idx;
    local string itemFlag, chapFlag, sName, sChap, sType, sResult, sChap1s, sChap2s, sChap3s, sChap4s, sChap5s, sChap6s;
    
    chapFlag = "||";
    itemFlag = "|";
    sChap1s = "None";
    sChap2s = "None";
    sChap3s = "None";
    sChap4s = "None";
    sChap5s = "None";
    sChap6s = "None";
    for (I = 0; I < GetAlicePlayerController().SecretPick.Length; I++)
    {
        sName = GetAlicePlayerController().SecretPick[I];
        Idx = InStr(sName, "_");
        sType = Mid(sName, Idx + 1, 3);
        if (bGetBig && sType == "CHR" || !bGetBig && sType == "MIN")
        {
            sChap = Mid(sName, Idx - 1, 1);
            if (sChap == "1")
            {
                if (sChap1s == "None")
                {
                    sChap1s = sName;
                }
                else
                {
                    sChap1s @= itemFlag @ sName;
                }
            }
            else if (sChap == "2")
            {
                if (sChap2s == "None")
                {
                    sChap2s = sName;
                }
                else
                {
                    sChap2s @= itemFlag @ sName;
                }
            }
            else if (sChap == "3")
            {
                if (sChap3s == "None")
                {
                    sChap3s = sName;
                }
                else
                {
                    sChap3s @= itemFlag @ sName;
                }
            }
            else if (sChap == "4")
            {
                if (sChap4s == "None")
                {
                    sChap4s = sName;
                }
                else
                {
                    sChap4s @= itemFlag @ sName;
                }
            }
            else if (sChap == "5")
            {
                if (sChap5s == "None")
                {
                    sChap5s = sName;
                }
                else
                {
                    sChap5s @= itemFlag @ sName;
                }
            }
            else if (sChap == "6")
            {
                if (sChap6s == "None")
                {
                    sChap6s = sName;
                }
                else
                {
                    sChap6s @= itemFlag @ sName;
                }
            }
            continue;
        }
        continue;
    }
    sResult = sChap1s @ chapFlag @ sChap2s @ chapFlag @ sChap3s @ chapFlag @ sChap4s @ chapFlag @ sChap5s @ chapFlag @ sChap6s;
    return sResult;
}

function array<string> getSecretPick()
{
    return GetAlicePlayerController().SecretPick;
}

function string getSnoutByChap()
{
    local int I, Idx;
    local string itemFlag, chapFlag, sName, sChap, sResult, sChap1s, sChap2s, sChap3s, sChap4s, sChap5s, sChap6s;
    
    chapFlag = "||";
    itemFlag = "|";
    sChap1s = "None";
    sChap2s = "None";
    sChap3s = "None";
    sChap4s = "None";
    sChap5s = "None";
    sChap6s = "None";
    for (I = 0; I < GetAlicePlayerController().SountActive.Length; I++)
    {
        sName = GetAlicePlayerController().SountActive[I];
        Idx = InStr(sName, "_");
        sChap = Mid(sName, Idx - 1, 1);
        if (sChap == "1")
        {
            if (sChap1s == "None")
            {
                sChap1s = sName;
            }
            else
            {
                sChap1s @= itemFlag @ sName;
            }
            continue;
        }
        if (sChap == "2")
        {
            if (sChap2s == "None")
            {
                sChap2s = sName;
            }
            else
            {
                sChap2s @= itemFlag @ sName;
            }
            continue;
        }
        if (sChap == "3")
        {
            if (sChap3s == "None")
            {
                sChap3s = sName;
            }
            else
            {
                sChap3s @= itemFlag @ sName;
            }
            continue;
        }
        if (sChap == "4")
        {
            if (sChap4s == "None")
            {
                sChap4s = sName;
            }
            else
            {
                sChap4s @= itemFlag @ sName;
            }
            continue;
        }
        if (sChap == "5")
        {
            if (sChap5s == "None")
            {
                sChap5s = sName;
            }
            else
            {
                sChap5s @= itemFlag @ sName;
            }
            continue;
        }
        if (sChap == "6")
        {
            if (sChap6s == "None")
            {
                sChap6s = sName;
                continue;
            }
            sChap6s @= itemFlag @ sName;
        }
    }
    sResult = sChap1s @ chapFlag @ sChap2s @ chapFlag @ sChap3s @ chapFlag @ sChap4s @ chapFlag @ sChap5s @ chapFlag @ sChap6s;
    return sResult;
}

function array<string> getSnoutActive()
{
    return GetAlicePlayerController().SountActive;
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

function string getMemoryFragmentByType(string sInType)
{
    local int I;
    local string itemFlag, typeFlag, sName, sChap, sType, sResult, sChap1s, sChap2s, sChap3s, sChap4s, sChap5s, sChap6s;
    
    typeFlag = "||";
    itemFlag = "|";
    sChap1s = "None";
    sChap2s = "None";
    sChap3s = "None";
    sChap4s = "None";
    sChap5s = "None";
    sChap6s = "None";
    for (I = 0; I < GetAlicePlayerController().MemoryFragment.Length; I++)
    {
        sName = GetAlicePlayerController().MemoryFragment[I];
        sType = GetRightMost(sName);
        if (belongToType(sInType, sType))
        {
            sChap = Left(sName, 1);
            if (sChap == "1")
            {
                if (sChap1s == "None")
                {
                    sChap1s = sName;
                }
                else
                {
                    sChap1s @= itemFlag @ sName;
                }
            }
            else if (sChap == "2")
            {
                if (sChap2s == "None")
                {
                    sChap2s = sName;
                }
                else
                {
                    sChap2s @= itemFlag @ sName;
                }
            }
            else if (sChap == "3")
            {
                if (sChap3s == "None")
                {
                    sChap3s = sName;
                }
                else
                {
                    sChap3s @= itemFlag @ sName;
                }
            }
            else if (sChap == "4")
            {
                if (sChap4s == "None")
                {
                    sChap4s = sName;
                }
                else
                {
                    sChap4s @= itemFlag @ sName;
                }
            }
            else if (sChap == "5")
            {
                if (sChap5s == "None")
                {
                    sChap5s = sName;
                }
                else
                {
                    sChap5s @= itemFlag @ sName;
                }
            }
            else if (sChap == "6")
            {
                if (sChap6s == "None")
                {
                    sChap6s = sName;
                }
                else
                {
                    sChap6s @= itemFlag @ sName;
                }
            }
            continue;
        }
        continue;
    }
    sResult = sChap1s @ typeFlag @ sChap2s @ typeFlag @ sChap3s @ typeFlag @ sChap4s @ typeFlag @ sChap5s @ typeFlag @ sChap6s;
    return sResult;
}

function int getAllMemoryByChapter(int iChap)
{
    local int I, iResult;
    local string sName, sChap;
    local AlicePlayerController paraAlice;
    
    iResult = 0;
    paraAlice = GetAlicePlayerController();
    for (I = 0; I < paraAlice.MemoryFragment.Length; I++)
    {
        sName = paraAlice.MemoryFragment[I];
        sChap = Left(sName, 1);
        if (sChap == string(iChap))
        {
            iResult++;
        }
    }
    if (iChap >= 1 && iChap <= 5 && paraAlice.MemoryCompleted[iChap - 1] == 1)
    {
        iResult++;
    }
    return iResult;
}

function array<string> getMemoryFragment()
{
    return GetAlicePlayerController().MemoryFragment;
}

function bool CanPressRestartGame()
{
    return GetAlicePlayerController().CanPressRestartGame();
}

function showUpgradeHealth()
{
}

function array<int> getUpgradeHealth()
{
    local int I;
    local array<int> upgrades;
    local AlicePlayerController alicePlayerCon;
    
    upgrades.Length = 6;
    alicePlayerCon = GetAlicePlayerController();
    for (I = 0; I < 6; I++)
    {
        upgrades[I] = alicePlayerCon.UpgradeHealth[I];
    }
    return upgrades;
}

function array<string> getAbilityGot()
{
    return GetAlicePlayerController().AbilityGot;
}

function array<string> getBinkPlayed()
{
    return GetAlicePlayerController().BinkPlayed;
}

function array<int> getUnlockEnemy()
{
    local int I;
    local array<int> enemies;
    local AlicePlayerController alicePlayerCon;
    
    enemies.Length = 20;
    alicePlayerCon = GetAlicePlayerController();
    for (I = 0; I < 20; I++)
    {
        enemies[I] = alicePlayerCon.UnlockEnemy[I];
    }
    return enemies;
}

function array<int> GetChapterCompleted()
{
    local int I;
    local array<int> chapters;
    local AlicePlayerController alicePlayerCon;
    
    chapters.Length = 6;
    alicePlayerCon = GetAlicePlayerController();
    for (I = 0; I < 6; I++)
    {
        chapters[I] = alicePlayerCon.ChapterCompleted[I];
    }
    return chapters;
}

function array<int> getMemoryCompleted()
{
    local int I;
    local array<int> bigMemory;
    local AlicePlayerController alicePlayerCon;
    
    bigMemory.Length = 5;
    alicePlayerCon = GetAlicePlayerController();
    for (I = 0; I < 5; I++)
    {
        bigMemory[I] = alicePlayerCon.MemoryCompleted[I];
    }
    return bigMemory;
}

function int getCaveCompletedInChapter(int iChap)
{
    local int iStart, iEnd, iLen, I, iResult;
    local AlicePlayerController alicePlayerCon;
    
    if (iChap < 2 || iChap > 5)
    {
        return 0;
    }
    alicePlayerCon = GetAlicePlayerController();
    iResult = 0;
    iLen = 4;
    iStart = (iChap - 2) * iLen;
    iEnd = iStart + iLen;
    for (I = iStart; I < iEnd; I++)
    {
        if (alicePlayerCon.CaveCompleted[I] == 1)
        {
            iResult++;
        }
    }
    return iResult;
}

function array<int> getCaveCompleted()
{
    local int I;
    local array<int> caves;
    local AlicePlayerController alicePlayerCon;
    
    caves.Length = 16;
    alicePlayerCon = GetAlicePlayerController();
    for (I = 0; I < 16; I++)
    {
        caves[I] = alicePlayerCon.CaveCompleted[I];
    }
    return caves;
}

function SavePersistentSaveData()
{
    AliceGameInfo(GetAlicePlayerController().WorldInfo.Game).SavePersistentSaveData(self);
}

function interface_ResetConfigData()
{
    GetAlicePlayerController().interface_ResetConfigData();
}

function interface_LoadConfigData()
{
    GetAlicePlayerController().interface_LoadConfigData();
}

function interface_SaveConfigData()
{
    AliceGameInfo(GetAlicePlayerController().WorldInfo.Game).SaveConfigSaveData(self);
}

function string getAliceKeyBind(byte nKeyType, byte nKeyGroup)
{
    return string(getConfigDataManager().getAliceKeyBind(nKeyType, 0));
}

function backAliceKey(string KeyName, int X, int Y)
{
    SetFocus(true, true);
    ActionScriptVoid("_root.backAliceKey");
}

function setInGameVideoDefault()
{
    getConfigDataManager().setInGameVideoDefault();
}

function setVideoDefault()
{
    getConfigDataManager().setVideoDefault();
}

function setAudioDefault()
{
    getConfigDataManager().setAudioDefault();
}

function setKeysDefault()
{
    getConfigDataManager().setKeysDefault();
}

function setAliceKeyBind(byte nKeyType, byte nKeyGroup)
{
    SetFocus(false, false);
    tempKeyX = int(nKeyType);
    tempKeyY = int(nKeyGroup);
    getConfigDataManager().setAliceKeyBind(nKeyType, nKeyGroup);
}

function setControlLayout(int nControlLayout)
{
    getConfigDataManager().setControlLayout(nControlLayout);
}

function int getControlLayout()
{
    return getConfigDataManager().getControlLayout();
}

function setGamepadType(int iGamepadType)
{
    getConfigDataManager().setGamepadType(iGamepadType);
}

function int getGamepadType()
{
    return getConfigDataManager().getGamepadType();
}

function setDynamicShadows(bool bDynamicShadows)
{
    getConfigDataManager().setDynamicShadow(bDynamicShadows);
}

function bool getDynamicShadows()
{
    return getConfigDataManager().getDynamicShadow();
}

function setPostprocess(bool bPostprocess)
{
    getConfigDataManager().setPostprocess(bPostprocess);
}

function bool getPostprocess()
{
    return getConfigDataManager().getPostprocess();
}

function setMotionBlur(bool bMotionBlur)
{
    getConfigDataManager().setMotionBlur(bMotionBlur);
}

function bool getMotionBlur()
{
    return getConfigDataManager().getMotionBlur();
}

function setPhysXLevel(int iPhysX)
{
    getConfigDataManager().setPhysXLevel(iPhysX);
}

function int GetPhysXLevel()
{
    return getConfigDataManager().GetPhysXLevel();
}

function setStereo3D(bool bStereo3D)
{
    getConfigDataManager().setStereo3D(bStereo3D);
}

function bool getStereo3D()
{
    return getConfigDataManager().getStereo3D();
}

function setAntiAlias(bool bAntiAlias)
{
    getConfigDataManager().setAntiAlias(bAntiAlias);
}

function bool getAntiAlias()
{
    return getConfigDataManager().getAntiAlias();
}

function setScreenResolution(int iResX, int iResY, bool bCall)
{
    getConfigDataManager().setScreenResolution(iResX, iResY, bCall, self);
}

function int getResolutionY()
{
    return getConfigDataManager().getResolutionY();
}

function int getResolutionX()
{
    return getConfigDataManager().getResolutionX();
}

function string GetSupportedResolutions(int Index)
{
    local int iResX, iResY;
    
    GetAlicePlayerController().GetSupportedResolutions(Index, iResX, iResY);
    return string(iResX) @ "x" @ string(iResY);
}

function int GetNumOfSupportedResolutions()
{
    return GetAlicePlayerController().GetNumOfSupportedResolutions();
}

function setGraphicsQuality(int iQuality)
{
    getConfigDataManager().setGraphicsQuality(iQuality);
}

function int getGraphicsQuality()
{
    return getConfigDataManager().getGraphicsQuality();
}

function setGammaConfig(float fGamma)
{
    getConfigDataManager().setGammaConfig(fGamma);
}

function float getGammaConfig()
{
    return getConfigDataManager().getGammaConfig();
}

function setScreenPositionY(int iY)
{
    getConfigDataManager().setScreenPositionY(iY);
}

function int getScreenPositionY()
{
    return getConfigDataManager().getScreenPositionY();
}

function setScreenPositionX(int iX)
{
    getConfigDataManager().setScreenPositionX(iX);
}

function int getScreenPositionX()
{
    return getConfigDataManager().getScreenPositionX();
}

function setSubtitles(bool bEnable)
{
    getConfigDataManager().setSubtitles(bEnable);
}

function bool getSubtitles()
{
    return getConfigDataManager().getSubtitles();
}

function setVoiceVolume(float fVolume)
{
    getConfigDataManager().setVoiceVolume(fVolume);
}

function float getVoiceVolume()
{
    return getConfigDataManager().getVoiceVolume();
}

function setMusicVolume(float fVolume)
{
    getConfigDataManager().setMusicVolume(fVolume);
}

function float getMusicVolume()
{
    return getConfigDataManager().getMusicVolume();
}

function setSoundEffectVolume(float fVolume)
{
    getConfigDataManager().setSoundEffectVolume(fVolume);
}

function float getSoundEffectVolume()
{
    return getConfigDataManager().getSoundEffectVolume();
}

function PlayChangeAnim(name poseName)
{
    local AlicePawn ap;
    local AnimationParaConfig AnimConfig;
    
    ap = AlicePawn(GetAlicePlayerController().Pawn);
    AnimConfig.AnimationNames[0] = poseName;
    AnimConfig.BlendOutTime = -1.0;
    AnimConfig.bLoop = true;
    if (ap != none)
    {
        ap.PlayConfigAnim(AnimConfig);
    }
}

function ChangeWeaponTo(int weapon_id)
{
    switch (weapon_id)
    {
        case 1:
            GetAlicePlayerController().ClientSetWeapon(class'VorpalBlade');
            GetAlicePlayerController().bSwitchWeaponOnly = true;
            PlayChangeAnim('Alice_W1_Pose');
            break;
        case 2:
            GetAlicePlayerController().ClientSetWeapon(class'EyeStaff');
            GetAlicePlayerController().bSwitchWeaponOnly = true;
            PlayChangeAnim('Alice_W3_Pose');
            break;
        case 3:
            GetAlicePlayerController().ClientSetWeapon(class'HobbyHorse');
            GetAlicePlayerController().bSwitchWeaponOnly = true;
            PlayChangeAnim('Alice_W2_Pose');
            break;
        case 4:
            GetAlicePlayerController().ClientSetWeapon(class'TeapotCannon');
            GetAlicePlayerController().bSwitchWeaponOnly = true;
            PlayChangeAnim('Alice_W4_Pose');
            break;
        default:
    }
}

function UpgradeWeapon(int weapon_id, int level_id)
{
    switch (weapon_id)
    {
        case 0:
            if (level_id == 5)
            {
                AliceGameInfo(GetAlicePlayerController().WorldInfo.Game).SetIsDLC_VB_UnLock(true);
                AliceGameInfo(GetAlicePlayerController().WorldInfo.Game).SetIsDLC_VB_Enable(true);
                GetAlicePlayerController().UpgradeWeapon(class'VorpalBlade', 4);
            }
            else
            {
                if (GetAlicePlayerController().WorldInfo.GetMapName() == "AliceEntry")
                {
                    AliceGameInfo(GetAlicePlayerController().WorldInfo.Game).SetIsDLC_VB_Enable(false);
                }
                GetAlicePlayerController().UpgradeWeapon(class'VorpalBlade', level_id);
            }
            break;
        case 1:
            if (level_id == 5)
            {
                AliceGameInfo(GetAlicePlayerController().WorldInfo.Game).SetIsDLC_ES_UnLock(true);
                AliceGameInfo(GetAlicePlayerController().WorldInfo.Game).SetIsDLC_ES_Enable(true);
                GetAlicePlayerController().UpgradeWeapon(class'EyeStaff', 4);
            }
            else
            {
                if (GetAlicePlayerController().WorldInfo.GetMapName() == "AliceEntry")
                {
                    AliceGameInfo(GetAlicePlayerController().WorldInfo.Game).SetIsDLC_ES_Enable(false);
                }
                GetAlicePlayerController().UpgradeWeapon(class'EyeStaff', level_id);
            }
            break;
        case 2:
            if (level_id == 5)
            {
                AliceGameInfo(GetAlicePlayerController().WorldInfo.Game).SetIsDLC_HH_UnLock(true);
                AliceGameInfo(GetAlicePlayerController().WorldInfo.Game).SetIsDLC_HH_Enable(true);
                GetAlicePlayerController().UpgradeWeapon(class'HobbyHorse', 4);
            }
            else
            {
                if (GetAlicePlayerController().WorldInfo.GetMapName() == "AliceEntry")
                {
                    AliceGameInfo(GetAlicePlayerController().WorldInfo.Game).SetIsDLC_HH_Enable(false);
                }
                GetAlicePlayerController().UpgradeWeapon(class'HobbyHorse', level_id);
            }
            break;
        case 3:
            if (level_id == 5)
            {
                AliceGameInfo(GetAlicePlayerController().WorldInfo.Game).SetIsDLC_TC_UnLock(true);
                AliceGameInfo(GetAlicePlayerController().WorldInfo.Game).SetIsDLC_TC_Enable(true);
                GetAlicePlayerController().UpgradeWeapon(class'TeapotCannon', 4);
            }
            else
            {
                if (GetAlicePlayerController().WorldInfo.GetMapName() == "AliceEntry")
                {
                    AliceGameInfo(GetAlicePlayerController().WorldInfo.Game).SetIsDLC_TC_Enable(false);
                }
                GetAlicePlayerController().UpgradeWeapon(class'TeapotCannon', level_id);
            }
            break;
        default:
    }
}

function setInvertY(bool bInvertY)
{
    getConfigDataManager().setInvertY(bInvertY);
}

function bool getInvertY()
{
    return getConfigDataManager().getInvertY();
}

function setLockOnType(bool bLockOnType)
{
    getConfigDataManager().setLockOnType(bLockOnType);
}

function bool getLockOnType()
{
    return getConfigDataManager().getLockOnType();
}

function setMouseSpeed(float fMouseSpeed)
{
    if (fMouseSpeed < float(60))
    {
        fMouseSpeed = (fMouseSpeed - float(30)) * (5.0 / 3.0) + float(10);
    }
    getConfigDataManager().setMouseSpeed(fMouseSpeed);
}

function float getMouseSpeed()
{
    local float fMouseSpeed;
    
    fMouseSpeed = getConfigDataManager().getMouseSpeed();
    if (fMouseSpeed < float(60))
    {
        fMouseSpeed = (fMouseSpeed - float(10)) * (3.0 / 5.0) + float(30);
    }
    return fMouseSpeed;
}

function changeDifficulty(int iDifficulty)
{
    getConfigDataManager().changeDifficulty(iDifficulty);
}

function setDifficulty(int iDifficulty)
{
    getConfigDataManager().setDifficulty(iDifficulty);
}

function int getDifficulty()
{
    return getConfigDataManager().getDifficulty();
}

function AliceConfigDataManager getConfigDataManager()
{
    return GetAlicePlayerController().configDataManager;
}

function AlicePlayerController GetAlicePlayerController()
{
    local AlicePlayerController PC;
    
    foreach class'Engine.UIScene'.static.GetWorldInfo().LocalPlayerControllers(class'AlicePlayerController', PC)
    {
        if (PC != none)
        {
            return PC;
        }
    }
}

event UserTick()
{
    APC.UI_UpdateBinkFileTick();
    APC.UI_UpdateSetResWaitTick();
    APC.UI_UpdateReduceSaveIconDelayTick();
}

event GameCallback(optional int CallbackType = 0)
{
    local byte X, Y;
    local int Index;
    
    if (CallbackType == 1)
    {
        for (Index = 0; getConfigDataManager().getRemovedAliceKeyBind(Index, X, Y); Index++)
        {
            backAliceKey(getAliceKeyBind(byte(tempKeyX), byte(tempKeyY)), int(X), int(Y));
        }
        if (Index == 0)
        {
            backAliceKey(getAliceKeyBind(byte(tempKeyX), byte(tempKeyY)), -1, -1);
        }
    }
    else if (CallbackType == 10)
    {
        ActionScriptVoid("_root.memories.doCallBack");
        ActionScriptVoid("_root.pages_1.doCallBack");
        ActionScriptVoid("_root.main.Theatricals.doCallBack");
    }
    else if (CallbackType == 20)
    {
        ActionScriptVoid("_root.config.config.config.videoSettings.videoSettings_pc.ShowResolutionConfirm");
    }
}

function setGamma(float NewGamma)
{
    getConfigDataManager().setGammaConfig(NewGamma);
}

function float getGamma()
{
    if (getConfigDataManager().getGammaConfig() == float(0))
    {
        return 2.2;
    }
    else
    {
        return getConfigDataManager().getGammaConfig();
    }
}

function int GetCalloutPlatform()
{
    return GetAlicePlayerController().GetCalloutPlatform();
}

function int GetPlatform()
{
    local int platform;
    
    if (class'Engine.WorldInfo'.static.IsConsoleBuild() == false)
    {
        platform = 1;
    }
    else if (class'Engine.WorldInfo'.static.IsConsoleBuild(1) == true)
    {
        platform = 2;
    }
    else if (class'Engine.WorldInfo'.static.IsConsoleBuild(2) == true)
    {
        platform = 3;
    }
    return platform;
}

function bool HaveLastChapter()
{
    return AliceGameInfo(GetAlicePlayerController().WorldInfo.Game).HaveLastCheckpointFile();
}

function bool HaveLastCheckpointFile()
{
    return AliceGameInfo(GetAlicePlayerController().WorldInfo.Game).HaveLastCheckpointFile();
}

function array<string> getMemoryList()
{
    return AliceGameInfo(GetAlicePlayerController().WorldInfo.Game).MemoriesCollected;
}

function PauseGame(bool isPause)
{
    GetAlicePlayerController().SetPause(isPause);
}

event OnClose()
{
    if (APC != none)
    {
        if (APC.IsPaused())
        {
            APC.SetPause(false);
        }
        if (APC.FocusedMovie == self)
        {
            APC.FocusedMovie = none;
        }
    }
    bIsOpen = false;
    APC = none;
}

function bool Start(optional bool StartPaused = false)
{
    APC = GetAlicePlayerController();
    Start(StartPaused);
    Advance(0.0);
    bIsOpen = true;
    if (APC != none)
    {
        APC.FocusedMovie = self;
    }
    return true;
}

function bool shouldShowStartScreen()
{
    return GetAlicePlayerController().getAliceGameEngine().shouldShowStartScreen();
}

function ShowStartScreen()
{
    GetAlicePlayerController().getAliceGameEngine().ShowStartScreen();
}

function donotShowStartScreen()
{
    GetAlicePlayerController().getAliceGameEngine().donotShowStartScreen();
}

function bool shouldUnlockAllSecret()
{
    return AliceCheatManager(GetAlicePlayerController().CheatManager).bUnlockAllSecret;
}

function bool shouldUnlockAllSnout()
{
    return AliceCheatManager(GetAlicePlayerController().CheatManager).bUnlockAllSnout;
}

function bool shouldUnlockAllMemory()
{
    return AliceCheatManager(GetAlicePlayerController().CheatManager).bUnlockAllMemory;
}

function PlayWeaponPickupSound()
{
    PlaySoundWhenPause(WeaponPickupSound);
}

function PlaySoundWhenPause(SoundCue Sound)
{
    local AudioComponent AC;
    
    AC = APC.GetPooledAudioComponent(Sound, APC, false, true, APC.Location);
    if (AC == none)
    {
        return;
    }
    AC.bIsUISound = true;
    AC.bUseOwnerLocation = false;
    AC.Location = APC.Location;
    AC.Play();
}

function bool shouldUnlockAllBink()
{
    return AliceCheatManager(GetAlicePlayerController().CheatManager).bUnlockAllBink;
}

function openExtra()
{
    donotShowStartScreen();
    GetGameViewportClient().ConsoleCommand("open AliceEntryExtra");
}

function backMainMenu()
{
    donotShowStartScreen();
    GetGameViewportClient().ConsoleCommand("open AliceEntry");
}

defaultproperties
{
    TimingMode="TM_Real"
}

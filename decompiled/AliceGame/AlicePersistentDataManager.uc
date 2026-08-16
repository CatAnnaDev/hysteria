class AlicePersistentDataManager extends Object
    notplaceable
    within AlicePlayerController;

function LogOutAllPickup()
{
    local int I, numInOneLine, curNum;
    local string sSep;
    local array<string> smallSecrets, bigSecrets;
    
    sSep = "  ";
    LogInternal("***************");
    LogInternal("***************");
    LogInternal("=== BigMemory Completed ===");
    LogInternal("C1: " $ string(getBigMemoryCompleted(0)) $ sSep $ "C2: " $ string(getBigMemoryCompleted(1)) $ sSep $ "C3: " $ string(getBigMemoryCompleted(2)) $ sSep $ "C4: " $ string(getBigMemoryCompleted(3)) $ sSep $ "C5: " $ string(getBigMemoryCompleted(4)));
    LogInternal("  ");
    numInOneLine = 15;
    curNum = 0;
    LogInternal("=== MemoryFragment Got " $ string(Outer.MemoryFragment.Length) $ " ===");
    for (I = 0; I < Outer.MemoryFragment.Length; I++)
    {
        if (curNum >= numInOneLine)
        {
            LogInternal(" ");
            curNum = 0;
        }
        LogInternal(getMemoryFragment(I) $ sSep);
        curNum++;
    }
    LogInternal(" ");
    numInOneLine = 15;
    curNum = 0;
    LogInternal("=== SountActive Got " $ string(Outer.SountActive.Length) $ " ===");
    for (I = 0; I < Outer.SountActive.Length; I++)
    {
        if (curNum >= numInOneLine)
        {
            LogInternal("  ");
            curNum = 0;
        }
        LogInternal(getSountActive(I) $ sSep);
        curNum++;
    }
    LogInternal("  ");
    for (I = 0; I < Outer.SecretPick.Length; I++)
    {
        if (isSmallSecret(Outer.SecretPick[I]))
        {
            smallSecrets.AddItem(Outer.SecretPick[I]);
            continue;
        }
        bigSecrets.AddItem(Outer.SecretPick[I]);
    }
    numInOneLine = 15;
    curNum = 0;
    LogInternal("=== Small Secret Got " $ string(smallSecrets.Length) $ " ===");
    for (I = 0; I < smallSecrets.Length; I++)
    {
        if (curNum >= numInOneLine)
        {
            LogInternal("  ");
            curNum = 0;
        }
        LogInternal(smallSecrets[I] $ sSep);
        curNum++;
    }
    LogInternal("  ");
    numInOneLine = 15;
    curNum = 0;
    LogInternal("=== Big Secret Got " $ string(bigSecrets.Length) $ " ===");
    for (I = 0; I < bigSecrets.Length; I++)
    {
        if (curNum >= numInOneLine)
        {
            LogInternal("  ");
            curNum = 0;
        }
        LogInternal(bigSecrets[I] $ sSep);
        curNum++;
    }
    LogInternal("***************");
    LogInternal("***************");
}

function bool isSmallSecret(string sTag)
{
    local int Idx;
    local string sType;
    
    Idx = InStr(sTag, "_");
    sType = Mid(sTag, Idx + 1, 3);
    if (sType == "CHR")
    {
        return false;
    }
    else
    {
        return true;
    }
}

function string showDebugInfo()
{
    local int I, numInOneLine, curNum;
    local string Info, sSep;
    local array<string> smallSecrets, bigSecrets;
    
    sSep = "  ";
    if (true)
    {
        Info = Info $ "=== BigMemory Completed ===" $ "\n" $ "C1: " $ string(getBigMemoryCompleted(0)) $ sSep $ "C2: " $ string(getBigMemoryCompleted(1)) $ sSep $ "C3: " $ string(getBigMemoryCompleted(2)) $ sSep $ "C4: " $ string(getBigMemoryCompleted(3)) $ sSep $ "C5: " $ string(getBigMemoryCompleted(4)) $ "\n\n";
        numInOneLine = 15;
        curNum = 0;
        Info = Info $ "=== MemoryFragment Got " $ string(Outer.MemoryFragment.Length) $ " ===" $ "\n";
        for (I = 0; I < Outer.MemoryFragment.Length; I++)
        {
            if (curNum >= numInOneLine)
            {
                Info = Info $ "\n";
                curNum = 0;
            }
            Info = Info $ getMemoryFragment(I) $ sSep;
            curNum++;
        }
        Info = Info $ "\n";
        numInOneLine = 15;
        curNum = 0;
        Info = Info $ "=== SountActive Got " $ string(Outer.SountActive.Length) $ " ===" $ "\n";
        for (I = 0; I < Outer.SountActive.Length; I++)
        {
            if (curNum >= numInOneLine)
            {
                Info = Info $ "\n";
                curNum = 0;
            }
            Info = Info $ getSountActive(I) $ sSep;
            curNum++;
        }
        Info = Info $ "\n";
        for (I = 0; I < Outer.SecretPick.Length; I++)
        {
            if (isSmallSecret(Outer.SecretPick[I]))
            {
                smallSecrets.AddItem(Outer.SecretPick[I]);
                continue;
            }
            bigSecrets.AddItem(Outer.SecretPick[I]);
        }
        numInOneLine = 15;
        curNum = 0;
        Info = Info $ "=== Small Secret Got " $ string(smallSecrets.Length) $ " ===" $ "\n";
        for (I = 0; I < smallSecrets.Length; I++)
        {
            if (curNum >= numInOneLine)
            {
                Info = Info $ "\n";
                curNum = 0;
            }
            Info = Info $ smallSecrets[I] $ sSep;
            curNum++;
        }
        Info = Info $ "\n";
        numInOneLine = 15;
        curNum = 0;
        Info = Info $ "=== Big Secret Got " $ string(bigSecrets.Length) $ " ===" $ "\n";
        for (I = 0; I < bigSecrets.Length; I++)
        {
            if (curNum >= numInOneLine)
            {
                Info = Info $ "\n";
                curNum = 0;
            }
            Info = Info $ bigSecrets[I] $ sSep;
            curNum++;
        }
        Info = Info $ "\n";
    }
    return Info;
}

function string getSecretPick(int Index)
{
    return Outer.SecretPick[Index];
}

function setSecretPick(string secrettag)
{
    if (-1 == Outer.SecretPick.Find(secrettag))
    {
        Outer.SecretPick.AddItem(secrettag);
    }
}

function string getSountActive(int Index)
{
    return Outer.SountActive[Index];
}

function setSountActive(string snouttag)
{
    if (-1 == Outer.SountActive.Find(snouttag))
    {
        Outer.SountActive.AddItem(snouttag);
    }
}

function string getMemoryFragment(int Index)
{
    return Outer.MemoryFragment[Index];
}

function setMemoryFragment(string fragmentName)
{
    if (-1 == Outer.MemoryFragment.Find(fragmentName))
    {
        Outer.MemoryFragment.AddItem(fragmentName);
        Outer.TryUnlockMemoryTrophy();
    }
}

function bool getUpgradeHealth(int Index)
{
    if (Index > 5 || Index < 0)
    {
        return false;
    }
    return Outer.UpgradeHealth[Index] == 1;
}

function setUpgradeHealth(EUpgradeHealth Index)
{
    Outer.UpgradeHealth[int(Index)] = 1;
}

function string getAbilityName(EAliceAbilityControl Index)
{
    local string abilityName;
    
    switch (Index)
    {
        case 0:
            abilityName = "Combat";
            break;
        case 1:
            abilityName = "DoubleJump";
            break;
        case 2:
            abilityName = "Float";
            break;
        case 3:
            abilityName = "Shrink";
            break;
        case 4:
            abilityName = "ClockBomb";
            break;
        case 5:
            abilityName = "Hysteria";
            break;
        case 6:
            abilityName = "Umbrella";
            break;
        case 7:
            abilityName = "Deflect";
            break;
        case 8:
            abilityName = "Dodge";
            break;
        case 9:
            abilityName = "Sonar";
            break;
        case 10:
            abilityName = "Aiming";
            break;
        case 11:
            abilityName = "Lockon";
            break;
        case 12:
            abilityName = "Cat";
            break;
        case 13:
            abilityName = "ShowPath";
            break;
        case 14:
            abilityName = "VorpalBlade";
            break;
        case 15:
            abilityName = "PepperGrinder";
            break;
        case 16:
            abilityName = "HobbyHorse";
            break;
        case 17:
            abilityName = "TeapotCannon";
            break;
        default:
            abilityName = "Unknow";
            break;
    }
    return abilityName;
}

function string getAbilityGot(int Index)
{
    return Outer.AbilityGot[Index];
}

function SetAbility(EAliceAbilityControl Index)
{
    local string abilityName;
    
    abilityName = getAbilityName(Index);
    if (-1 == Outer.AbilityGot.Find(abilityName))
    {
        Outer.AbilityGot.AddItem(abilityName);
    }
}

function string getBinkPlayed(int Index)
{
    return Outer.BinkPlayed[Index];
}

function setBinkPlayed(string MovieName)
{
    if (-1 == Outer.BinkPlayed.Find(MovieName))
    {
        Outer.BinkPlayed.AddItem(MovieName);
    }
}

function bool getUnlockEnemy(int Index)
{
    if (Index > 19 || Index < 0)
    {
        return false;
    }
    return Outer.UnlockEnemy[Index] == 1;
}

function setUnlockEnemy(EUnlockEnemy enemyIndex)
{
    Outer.UnlockEnemy[int(enemyIndex)] = 1;
}

function bool GetChapterCompleted(int Index)
{
    if (Index > 5 || Index < 0)
    {
        return false;
    }
    return Outer.ChapterCompleted[Index] == 1;
}

function setChapterCompleted(EChapterCompleted chapterIndex)
{
    Outer.ChapterCompleted[int(chapterIndex)] = 1;
    Outer.ChapterCompletedHighestDifficulty[int(chapterIndex)] = 0;
    if (Outer.ChapterCompleted[5] > 0)
    {
        AliceGameInfo(Outer.WorldInfo.Game).SetDressAbilityActive_Oriental(true);
        AliceGameInfo(Outer.WorldInfo.Game).SetDressAbilityActive_Water(true);
        AliceGameInfo(Outer.WorldInfo.Game).SetDressAbilityActive_Hatter(true);
        AliceGameInfo(Outer.WorldInfo.Game).SetDressAbilityActive_Default(true);
        AliceGameInfo(Outer.WorldInfo.Game).SetDressAbilityActive_Queen(true);
        AliceGameInfo(Outer.WorldInfo.Game).SetDressAbilityActive_Doll(true);
        Outer.TheVeryLastCheckPointGot = 1;
        if (Outer.configDataManager != none)
        {
            Outer.configDataManager.setTheVeryLastCheckPointGot(1);
        }
    }
}

function bool getBigMemoryCompleted(int Index)
{
    if (Index > 4 || Index < 0)
    {
        return false;
    }
    return Outer.MemoryCompleted[Index] == 1;
}

function setBigMemoryCompleted(EBigMemoryCompleted memoryIndex)
{
    Outer.MemoryCompleted[int(memoryIndex)] = 1;
    Outer.TryUnlockMemoryTrophy();
}

function bool getChallengeCaveCompleted(int Index)
{
    if (Index > 15 || Index < 0)
    {
        return false;
    }
    return Outer.CaveCompleted[Index] == 1;
}

function setChallengeCaveCompleted(EChallengeCaveCompleted caveIndex)
{
    Outer.CaveCompleted[int(caveIndex)] = 1;
}

function PostApplyPersistentData()
{
}

function PreSavePersistentData()
{
    Outer.calcCompletePercent();
}

defaultproperties
{
}

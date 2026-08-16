class AliceConfigDataManager extends Object
    notplaceable
    within AlicePlayerController;

function setAllConfigDefault()
{
    setVideoDefault();
    setAudioDefault();
    setKeysDefault();
}

function setCameraDefault()
{
    if (Outer.WorldInfo != none && Outer.WorldInfo.IsConsoleBuild())
    {
        return;
    }
    setInvertY(false);
    setLockOnType(true);
    setMouseSpeed(60.0);
}

function setKeysDefault()
{
    if (Outer.WorldInfo != none && Outer.WorldInfo.IsConsoleBuild())
    {
        return;
    }
    Outer.getAliceGameEngine().ExecResetKeyBindings();
    Outer.getAliceGameEngine().ExecAttackType(0);
    Outer.getAliceGameEngine().ExecMouseSpeed(60.0);
    setInvertY(false);
    setLockOnType(true);
    setMouseSpeed(60.0);
}

function setAudioDefault()
{
    setSoundEffectVolume(1.0);
    setMusicVolume(1.0);
    setVoiceVolume(1.0);
    setSubtitles(true);
}

function setInGameVideoDefault()
{
    setGammaConfig(2.2);
    if (Outer.WorldInfo != none && Outer.WorldInfo.IsConsoleBuild())
    {
        return;
    }
    setGraphicsQuality(0);
    setScreenResolution(1280, 720, false);
    setAntiAlias(false);
    setStereo3D(false);
    setMotionBlur(false);
    setPostprocess(false);
    setDynamicShadow(false);
}

function setVideoDefault()
{
    setGammaConfig(2.2);
    if (Outer.WorldInfo != none && Outer.WorldInfo.IsConsoleBuild())
    {
        return;
    }
    setGraphicsQuality(0);
    setScreenResolution(1280, 720, false);
    setAntiAlias(false);
    setStereo3D(false);
    setPhysXLevel(0);
    setMotionBlur(false);
    setPostprocess(false);
    setDynamicShadow(false);
}

function setUIVideo(int Idx)
{
    Outer.getAliceGameEngine().UIVideo[Idx] = 1;
}

function array<int> getUIVideo()
{
    local int I;
    local AliceGameEngine AliceEngine;
    local array<int> Results;
    
    Results.Length = 50;
    AliceEngine = Outer.getAliceGameEngine();
    for (I = 0; I < 50; I++)
    {
        Results[I] = AliceEngine.UIVideo[I];
    }
    return Results;
}

function setUIGallary(int Idx)
{
    Outer.getAliceGameEngine().UIGallary[Idx] = 1;
}

function array<int> getUIGallary()
{
    local int I;
    local AliceGameEngine AliceEngine;
    local array<int> Results;
    
    Results.Length = 100;
    AliceEngine = Outer.getAliceGameEngine();
    for (I = 0; I < 100; I++)
    {
        Results[I] = AliceEngine.UIGallary[I];
    }
    return Results;
}

function setUIEnemy(int Idx)
{
    Outer.getAliceGameEngine().UIEnemy[Idx] = 1;
}

function array<int> getUIEnemy()
{
    local int I;
    local AliceGameEngine AliceEngine;
    local array<int> Results;
    
    Results.Length = 100;
    AliceEngine = Outer.getAliceGameEngine();
    for (I = 0; I < 100; I++)
    {
        Results[I] = AliceEngine.UIEnemy[I];
    }
    return Results;
}

function setTheVeryLastCheckPointGot(int I)
{
    Outer.getAliceGameEngine().TheVeryLastCheckPointGot = I;
}

function int getTheVeryLastCheckPointGot()
{
    return Outer.getAliceGameEngine().TheVeryLastCheckPointGot;
}

function setUIMemory(int Idx)
{
    Outer.getAliceGameEngine().UIMemory[Idx] = 1;
}

function array<int> getUIMemory()
{
    local int I;
    local AliceGameEngine AliceEngine;
    local array<int> Results;
    
    Results.Length = 100;
    AliceEngine = Outer.getAliceGameEngine();
    for (I = 0; I < 100; I++)
    {
        Results[I] = AliceEngine.UIMemory[I];
    }
    return Results;
}

function setLockOnType(bool bLockOnHold)
{
    Outer.getAliceGameEngine().LockOnType = (bLockOnHold ? 0 : 1);
    Outer.SetTargetingModeOption(bLockOnHold);
}

function bool getLockOnType()
{
    return Outer.getAliceGameEngine().LockOnType == 0;
}

function setMouseSpeed(float fMouseSpeed)
{
    Outer.getAliceGameEngine().ExecMouseSpeed(fMouseSpeed);
    Outer.getAliceGameEngine().MouseSpeed = fMouseSpeed;
}

function float getMouseSpeed()
{
    return Outer.getAliceGameEngine().MouseSpeed;
}

function setAttackType(int nAttackType)
{
    Outer.getAliceGameEngine().AttackType = nAttackType;
    Outer.getAliceGameEngine().ExecAttackType(nAttackType);
}

function int getAttackType()
{
    return Outer.getAliceGameEngine().AttackType;
}

function setAliceKeyBind(byte nKeyType, byte nKeyGroup)
{
    Outer.UI_CurActiveKeyType = nKeyType;
    Outer.UI_CurActiveKeyGroup = nKeyGroup;
}

function bool getRemovedAliceKeyBind(int Index, out byte nKeyType, out byte nKeyGroup)
{
    local bool bHasData;
    
    bHasData = Index < Outer.UI_RemovedAliceKeys.Length;
    if (bHasData)
    {
        bHasData = Outer.getAliceGameEngine().GetAliceKeyIndex(Outer.UI_RemovedAliceKeys[Index], nKeyType, nKeyGroup);
    }
    return bHasData;
}

function name getAliceKeyBind(byte nKeyType, byte nKeyGroup)
{
    return Outer.getAliceGameEngine().GetAliceKeys(nKeyType, nKeyGroup);
}

function setControlLayout(int nControlLayout)
{
    Outer.getAliceGameEngine().ControlLayout = nControlLayout;
    Outer.getAliceGameEngine().ExecControlLayout(nControlLayout);
}

function int getControlLayout()
{
    return Outer.getAliceGameEngine().ControlLayout;
}

function setGamepadType(int iGamepadType)
{
    Outer.getAliceGameEngine().GamepadType = iGamepadType;
}

function int getGamepadType()
{
    return Outer.getAliceGameEngine().GamepadType;
}

function setMotionBlur(bool bMotionBlur)
{
    Outer.getAliceGameEngine().MotionBlur = bMotionBlur;
    Outer.getAliceGameEngine().ExecMotionBlur(bMotionBlur);
}

function bool getMotionBlur()
{
    return Outer.getAliceGameEngine().MotionBlur;
}

function setPhysXLevel(int iPhysX)
{
    Outer.getAliceGameEngine().PhysXLevel = iPhysX;
    Outer.getAliceGameEngine().ExecPhysXLevel(iPhysX);
}

function int GetPhysXLevel()
{
    return Outer.getAliceGameEngine().PhysXLevel;
}

function setStereo3D(bool bStereo3D)
{
    Outer.getAliceGameEngine().Stereo3D = bStereo3D;
    Outer.getAliceGameEngine().ExecStereo3D(bStereo3D);
}

function bool getStereo3D()
{
    return Outer.getAliceGameEngine().Stereo3D;
}

function setDynamicShadow(bool bDynamicShadows)
{
    Outer.getAliceGameEngine().bDynamicShadows = bDynamicShadows;
    Outer.getAliceGameEngine().ExecDynamicShadows(bDynamicShadows);
}

function bool getDynamicShadow()
{
    return Outer.getAliceGameEngine().bDynamicShadows;
}

function setPostprocess(bool bPostprocess)
{
    Outer.getAliceGameEngine().ExecPostprocess(bPostprocess);
    Outer.getAliceGameEngine().bPostprocess = Outer.getAliceGameEngine().GetShowPostprocess();
}

function bool getPostprocess()
{
    return Outer.getAliceGameEngine().GetShowPostprocess();
}

function setAntiAlias(bool bAntiAlias)
{
    Outer.getAliceGameEngine().AntiAlias = bAntiAlias;
    Outer.getAliceGameEngine().ExecAntiAlias(bAntiAlias);
}

function bool getAntiAlias()
{
    return Outer.getAliceGameEngine().AntiAlias;
}

function setScreenResolution(int iResX, int iResY, bool bCall, optional AliceGFXMovie pGFXMovie = none)
{
    Outer.getAliceGameEngine().ResolutionX = iResX;
    Outer.getAliceGameEngine().ResolutionY = iResY;
    Outer.getAliceGameEngine().ExecScreenResolution(iResX, iResY);
    if (bCall)
    {
        Outer.UI_SetResCount = 0;
        Outer.UI_AliceGFXMovie = pGFXMovie;
    }
}

function int getResolutionY()
{
    return Outer.getAliceGameEngine().ResolutionY;
}

function int getResolutionX()
{
    return Outer.getAliceGameEngine().ResolutionX;
}

function setGraphicsQuality(int iQuality)
{
    Outer.getAliceGameEngine().GraphicsQuality = iQuality;
    Outer.getAliceGameEngine().ExecGraphicsQuality(iQuality);
}

function int getGraphicsQuality()
{
    return Outer.getAliceGameEngine().GraphicsQuality;
}

function setGammaConfig(float fGamma)
{
    Outer.getAliceGameEngine().Gamma = fGamma;
    Outer.getAliceGameEngine().ExecGammaConfig(fGamma);
}

function float getGammaConfig()
{
    return Outer.getAliceGameEngine().Gamma;
}

function setScreenPositionY(int iY)
{
    Outer.getAliceGameEngine().ScreenPositionY = iY;
}

function int getScreenPositionY()
{
    return Outer.getAliceGameEngine().ScreenPositionY;
}

function setScreenPositionX(int iX)
{
    Outer.getAliceGameEngine().ScreenPositionX = iX;
}

function int getScreenPositionX()
{
    return Outer.getAliceGameEngine().ScreenPositionX;
}

function setSubtitles(bool bEnable)
{
    Outer.getAliceGameEngine().Subtitles = bEnable;
    Outer.getAliceGameEngine().ExecSubtitles(bEnable);
}

function bool getSubtitles()
{
    return Outer.getAliceGameEngine().Subtitles;
}

function setVoiceVolume(float fVolume)
{
    Outer.getAliceGameEngine().VoiceVolume = fVolume;
    Outer.getAliceGameEngine().ExecVoiceVolume(fVolume);
}

function float getVoiceVolume()
{
    return Outer.getAliceGameEngine().VoiceVolume;
}

function setMusicVolume(float fVolume)
{
    Outer.getAliceGameEngine().MusicVolume = fVolume;
    Outer.getAliceGameEngine().ExecMusicVolume(fVolume);
}

function float getMusicVolume()
{
    return Outer.getAliceGameEngine().MusicVolume;
}

function setSoundEffectVolume(float fVolume)
{
    Outer.getAliceGameEngine().SoundEffectVolume = fVolume;
    Outer.getAliceGameEngine().ExecSoundEffectVolume(fVolume);
}

function float getSoundEffectVolume()
{
    return Outer.getAliceGameEngine().SoundEffectVolume;
}

function setInvertY(bool bInvertY)
{
    if (bInvertY != Outer.PlayerInput.bInvertMouse)
    {
        Outer.getAliceGameEngine().ExecInvertY(bInvertY);
        Outer.getAliceGameEngine().InvertY = Outer.PlayerInput.bInvertMouse;
    }
}

function bool getInvertY()
{
    return Outer.PlayerInput.bInvertMouse;
}

function changeDifficulty(int iDifficulty)
{
    if (iDifficulty < AliceGameInfo(Outer.WorldInfo.Game).getLowestGameDifficulty())
    {
        AliceGameInfo(Outer.WorldInfo.Game).setLowestGameDifficulty(iDifficulty);
    }
    AliceGameInfo(Outer.WorldInfo.Game).setCurrentGameDifficulty(iDifficulty);
}

function setDifficulty(int iDifficulty)
{
    local int I;
    
    AliceGameInfo(Outer.WorldInfo.Game).setCurrentGameDifficulty(iDifficulty);
    AliceGameInfo(Outer.WorldInfo.Game).setLowestGameDifficulty(iDifficulty);
}

function int getDifficulty()
{
    return AliceGameInfo(Outer.WorldInfo.Game).getCurrentGameDifficulty();
}

defaultproperties
{
}

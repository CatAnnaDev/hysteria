class GameViewportClient extends Object
    native
    notplaceable
    transient
    within Engine;

enum ESafeZoneType
{
    eSZ_TOP,
    eSZ_BOTTOM,
    eSZ_LEFT,
    eSZ_RIGHT,
};

enum ESplitScreenType
{
    eSST_NONE,
    eSST_2P_HORIZONTAL,
    eSST_2P_VERTICAL,
    eSST_3P_FAVOR_TOP,
    eSST_3P_FAVOR_BOTTOM,
    eSST_4P,
};

struct native DebugDisplayProperty
{
    var Object Obj;
    var name PropertyName;
    var bool bSpecialProperty;
};

struct native SplitscreenData
{
    var array<PerPlayerSplitscreenData> PlayerData;
};

struct native PerPlayerSplitscreenData
{
    var float SizeX;
    var float SizeY;
    var float OriginX;
    var float OriginY;
};

struct native TitleSafeZoneArea
{
    var float MaxPercentX;
    var float MaxPercentY;
    var float RecommendedPercentX;
    var float RecommendedPercentY;
};

var const native noexport Pointer VfTable_FViewportClient;
var const native noexport Pointer VfTable_FExec;
var const Pointer Viewport;
var const Pointer ViewportFrame;
var array<Interaction> GlobalInteractions;
var class<UIInteraction> UIControllerClass;
var UIInteraction UIController;
var Console ViewportConsole;
var const QWord ShowFlags;
var const localized string LoadingMessage;
var const localized string SavingMessage;
var const localized string ConnectingMessage;
var const localized string PausedMessage;
var const localized string PrecachingMessage;
var bool bShowTitleSafeZone;
var transient bool bDisplayingUIMouseCursor;
var transient bool bUIMouseCaptureOverride;
var bool bDisableWorldRendering;
var TitleSafeZoneArea TitleSafeZone;
var array<SplitscreenData> SplitscreenInfo;
var ESplitScreenType DesiredSplitscreenType;
var ESplitScreenType ActiveSplitscreenType;
var const ESplitScreenType Default2PSplitType;
var const ESplitScreenType Default3PSplitType;
var string ProgressMessage[2];
var float ProgressTimeOut;
var float ProgressFadeTime;
var array<DebugDisplayProperty> DebugProperties;
var delegate<HandleInputKey> __HandleInputKey__Delegate;
var delegate<HandleInputAxis> __HandleInputAxis__Delegate;
var delegate<HandleInputChar> __HandleInputChar__Delegate;

exec function ClearProgressMessages()
{
    local int I;
    
    for (I = 0; I < 2; I++)
    {
        ProgressMessage[I] = "";
    }
}

exec event SetProgressTime(float T)
{
    ProgressTimeOut = T + class'Engine'.static.GetCurrentWorldInfo().TimeSeconds;
}

function NotifyConnectionError(optional string Message = Localize("Errors", "ConnectionFailed", "Engine"), optional string Title = Localize("Errors", "ConnectionFailed_Title", "Engine"))
{
    local WorldInfo WI;
    
    WI = class'Engine'.static.GetCurrentWorldInfo();
    LogInternal("(" $ string(Name) $ ") GameViewportClient::" $ string(GetStateName()) $ ":" $ string(GetFuncName()) @ "Title:'" $ Title $ "'" @ "Message:'" $ Message $ "'" @ "NetMode:'" $ string(GetEnum(Enum'WorldInfo.ENetMode', int(WI.NetMode))) $ "'" @ "Map:'" $ WI.GetURLMap() $ "'", 'DevNet');
    if (WI.NetMode != 0)
    {
        if (WI.Game != none)
        {
            WI.Game.bHasNetworkError = true;
        }
        ConsoleCommand("start ?failed");
    }
}

event SetProgressMessage(EProgressMessageType MessageType, string Message, optional string Title, optional bool bIgnoreFutureNetworkMessages)
{
    if (MessageType == 0)
    {
        ClearProgressMessages();
    }
    else if (MessageType == 4)
    {
        NotifyConnectionError(Message, Title);
    }
    else if (MessageType != 5)
    {
        if (Title != "")
        {
            ProgressMessage[0] = Title;
            ProgressMessage[1] = Message;
        }
        else
        {
            ProgressMessage[1] = "";
            ProgressMessage[0] = Message;
        }
    }
    else if (MessageType == 5)
    {
        if (!Outer.GamePlayers[0].Actor.bIgnoreNetworkMessages)
        {
            NotifyConnectionError(Message, Title);
        }
    }
    if (!Outer.GamePlayers[0].Actor.bIgnoreNetworkMessages)
    {
        Outer.GamePlayers[0].Actor.bIgnoreNetworkMessages = bIgnoreFutureNetworkMessages;
    }
}

private final function int RemoveLocalPlayer(LocalPlayer ExistingPlayer)
{
    local int Index;
    
    Index = Outer.GamePlayers.Find(ExistingPlayer);
    if (Index != -1)
    {
        Outer.GamePlayers.Remove(Index, 1);
    }
    return Index;
}

private final function int AddLocalPlayer(LocalPlayer NewPlayer)
{
    local int InsertIndex;
    
    InsertIndex = -1;
    if (NewPlayer != none)
    {
        InsertIndex = Outer.GamePlayers.Length;
        Outer.GamePlayers[InsertIndex] = NewPlayer;
    }
    return InsertIndex;
}

final function NotifyPlayerRemoved(int PlayerIndex, LocalPlayer RemovedPlayer)
{
    local int InteractionIndex;
    
    LayoutPlayers();
    for (InteractionIndex = GlobalInteractions.Length - 1; InteractionIndex >= 0; InteractionIndex--)
    {
        if (GlobalInteractions[InteractionIndex] != none)
        {
            GlobalInteractions[InteractionIndex].NotifyPlayerRemoved(PlayerIndex, RemovedPlayer);
        }
    }
}

final function NotifyPlayerAdded(int PlayerIndex, LocalPlayer AddedPlayer)
{
    local int InteractionIndex;
    
    LayoutPlayers();
    for (InteractionIndex = 0; InteractionIndex < GlobalInteractions.Length; InteractionIndex++)
    {
        if (GlobalInteractions[InteractionIndex] != none)
        {
            GlobalInteractions[InteractionIndex].NotifyPlayerAdded(PlayerIndex, AddedPlayer);
        }
    }
}

function DrawTransitionMessage(Canvas Canvas, string Message)
{
    local float XL, YL;
    
    Canvas.Font = class'Engine'.static.GetLargeFont();
    Canvas.bCenter = false;
    Canvas.StrLen(Message, XL, YL);
    Canvas.SetPos(0.5 * (Canvas.ClipX - XL) + float(1), 0.66 * Canvas.ClipY - YL * 0.5 + float(1));
    Canvas.SetDrawColor(0, 0, 0);
    Canvas.DrawText(Message, false);
    Canvas.SetPos(0.5 * (Canvas.ClipX - XL), 0.66 * Canvas.ClipY - YL * 0.5);
    Canvas.SetDrawColor(0, 0, 255);
    Canvas.DrawText(Message, false);
}

function DrawTransition(Canvas Canvas)
{
    switch (Outer.TransitionType)
    {
        case 2:
            DrawTransitionMessage(Canvas, LoadingMessage);
            break;
        case 3:
            DrawTransitionMessage(Canvas, SavingMessage);
            break;
        case 4:
            DrawTransitionMessage(Canvas, ConnectingMessage);
            break;
        case 5:
            DrawTransitionMessage(Canvas, PrecachingMessage);
            break;
        case 1:
            break;
        default:
    }
}

function DisplayProgressMessage(Canvas Canvas)
{
    local int I, LineCount;
    local float FontDX, FontDY, X, Y;
    local byte Alpha;
    local float TimeLeft;
    
    TimeLeft = ProgressTimeOut - class'Engine'.static.GetCurrentWorldInfo().TimeSeconds;
    Alpha = (TimeLeft >= ProgressFadeTime ? 255 : byte(float(255) * TimeLeft / ProgressFadeTime));
    LineCount = 0;
    for (I = 0; I < 2; I++)
    {
        if (ProgressMessage[I] != "")
        {
            LineCount++;
        }
    }
    Canvas.Font = class'Engine'.static.GetMediumFont();
    Canvas.TextSize("A", FontDX, FontDY);
    X = 0.5 * float(Canvas.SizeX);
    Y = 0.5 * float(Canvas.SizeY);
    Y -= FontDY * (float(LineCount) / 2.0);
    Canvas.DrawColor.R = 255;
    Canvas.DrawColor.G = 255;
    Canvas.DrawColor.B = 255;
    for (I = 0; I < 2; I++)
    {
        if (ProgressMessage[I] != "")
        {
            Canvas.DrawColor.A = Alpha;
            Canvas.TextSize(ProgressMessage[I], FontDX, FontDY);
            Canvas.SetPos(X - FontDX / 2.0, Y);
            Canvas.DrawText(ProgressMessage[I]);
            Y += FontDY;
        }
    }
}

event PostRender(Canvas Canvas)
{
    if (bShowTitleSafeZone)
    {
        DrawTitleSafeArea(Canvas);
    }
    ViewportConsole.PostRender_Console(Canvas);
    if (ProgressTimeOut > class'Engine'.static.GetCurrentWorldInfo().TimeSeconds)
    {
        DisplayProgressMessage(Canvas);
    }
}

function DrawTitleSafeArea(Canvas Canvas)
{
    Canvas.SetDrawColor(255, 0, 0, 255);
    Canvas.SetPos(Canvas.ClipX * (float(1) - TitleSafeZone.MaxPercentX) / 2.0, Canvas.ClipY * (float(1) - TitleSafeZone.MaxPercentY) / 2.0);
    Canvas.DrawBox(Canvas.ClipX * TitleSafeZone.MaxPercentX, Canvas.ClipY * TitleSafeZone.MaxPercentY);
    Canvas.SetDrawColor(255, 255, 0, 255);
    Canvas.SetPos(Canvas.ClipX * (float(1) - TitleSafeZone.RecommendedPercentX) / 2.0, Canvas.ClipY * (float(1) - TitleSafeZone.RecommendedPercentY) / 2.0);
    Canvas.DrawBox(Canvas.ClipX * TitleSafeZone.RecommendedPercentX, Canvas.ClipY * TitleSafeZone.RecommendedPercentY);
}

event Tick(float DeltaTime)
{
}

final function CalculatePixelCenter(out float out_CenterX, out float out_CenterY, LocalPlayer LPlayer, Canvas Canvas, optional bool bUseMaxPercent)
{
    local int LocalPlayerIndex;
    local float HorizSafeZoneValue, VertSafeZoneValue;
    
    out_CenterX = Canvas.ClipX / 2.0;
    out_CenterY = Canvas.ClipY / 2.0;
    if (LPlayer != none)
    {
        LocalPlayerIndex = ConvertLocalPlayerToGamePlayerIndex(LPlayer);
        if (LocalPlayerIndex != -1)
        {
            CalculateSafeZoneValues(HorizSafeZoneValue, VertSafeZoneValue, Canvas, LocalPlayerIndex, bUseMaxPercent);
            switch (GetSplitscreenConfiguration())
            {
                case 0:
                    return;
                case 1:
                    if (LocalPlayerIndex == 0)
                    {
                        out_CenterY += VertSafeZoneValue / float(2);
                    }
                    else
                    {
                        out_CenterY -= VertSafeZoneValue / float(2);
                    }
                    return;
                case 2:
                    if (LocalPlayerIndex == 0)
                    {
                        out_CenterX += HorizSafeZoneValue / float(2);
                    }
                    else
                    {
                        out_CenterX -= HorizSafeZoneValue / float(2);
                    }
                    return;
                case 3:
                    if (LocalPlayerIndex == 0)
                    {
                        out_CenterY += VertSafeZoneValue / float(2);
                    }
                    else
                    {
                        out_CenterY -= VertSafeZoneValue / float(2);
                        if (LocalPlayerIndex == 1)
                        {
                            out_CenterX += HorizSafeZoneValue / float(2);
                        }
                        else
                        {
                            out_CenterX -= HorizSafeZoneValue / float(2);
                        }
                    }
                    return;
                case 4:
                    if (LocalPlayerIndex == 2)
                    {
                        out_CenterY -= VertSafeZoneValue / float(2);
                    }
                    else
                    {
                        out_CenterY += VertSafeZoneValue / float(2);
                        if (LocalPlayerIndex == 0)
                        {
                            out_CenterX += HorizSafeZoneValue / float(2);
                        }
                        else
                        {
                            out_CenterX -= HorizSafeZoneValue / float(2);
                        }
                    }
                    return;
                case 5:
                    if (LocalPlayerIndex < 2)
                    {
                        out_CenterY += VertSafeZoneValue / float(2);
                    }
                    else
                    {
                        out_CenterY -= VertSafeZoneValue / float(2);
                    }
                    if (LocalPlayerIndex == 0 || LocalPlayerIndex == 2)
                    {
                        out_CenterX += HorizSafeZoneValue / float(2);
                    }
                    else
                    {
                        out_CenterX -= HorizSafeZoneValue / float(2);
                    }
                    return;
                default:
            }
        }
    }
}

final function bool CalculateDeadZoneForAllSides(LocalPlayer LPlayer, Canvas Canvas, out float fTopSafeZone, out float fBottomSafeZone, out float fLeftSafeZone, out float fRightSafeZone, optional bool bUseMaxPercent)
{
    local bool bHasTopSafeZone, bHasBottomSafeZone, bHasRightSafeZone, bHasLeftSafeZone;
    local int LocalPlayerIndex;
    local float HorizSafeZoneValue, VertSafeZoneValue;
    
    if (LPlayer != none)
    {
        LocalPlayerIndex = ConvertLocalPlayerToGamePlayerIndex(LPlayer);
        if (LocalPlayerIndex != -1)
        {
            bHasTopSafeZone = HasTopSafeZone(LocalPlayerIndex);
            bHasBottomSafeZone = HasBottomSafeZone(LocalPlayerIndex);
            bHasLeftSafeZone = HasLeftSafeZone(LocalPlayerIndex);
            bHasRightSafeZone = HasRightSafeZone(LocalPlayerIndex);
            if (bHasTopSafeZone || bHasBottomSafeZone || bHasLeftSafeZone || bHasRightSafeZone)
            {
                CalculateSafeZoneValues(HorizSafeZoneValue, VertSafeZoneValue, Canvas, LocalPlayerIndex, bUseMaxPercent);
                if (bHasTopSafeZone)
                {
                    fTopSafeZone = VertSafeZoneValue;
                }
                else
                {
                    fTopSafeZone = 0.0;
                }
                if (bHasBottomSafeZone)
                {
                    fBottomSafeZone = VertSafeZoneValue;
                }
                else
                {
                    fBottomSafeZone = 0.0;
                }
                if (bHasLeftSafeZone)
                {
                    fLeftSafeZone = HorizSafeZoneValue;
                }
                else
                {
                    fLeftSafeZone = 0.0;
                }
                if (bHasRightSafeZone)
                {
                    fRightSafeZone = HorizSafeZoneValue;
                }
                else
                {
                    fRightSafeZone = 0.0;
                }
                return true;
            }
        }
    }
    return false;
}

final function float CalculateDeadZone(LocalPlayer LPlayer, ESafeZoneType SZType, Canvas Canvas, optional bool bUseMaxPercent)
{
    local bool bHasSafeZone;
    local int LocalPlayerIndex;
    local float HorizSafeZoneValue, VertSafeZoneValue;
    
    if (LPlayer != none)
    {
        LocalPlayerIndex = ConvertLocalPlayerToGamePlayerIndex(LPlayer);
        if (LocalPlayerIndex != -1)
        {
            switch (SZType)
            {
                case 0:
                    bHasSafeZone = HasTopSafeZone(LocalPlayerIndex);
                    break;
                case 1:
                    bHasSafeZone = HasBottomSafeZone(LocalPlayerIndex);
                    break;
                case 2:
                    bHasSafeZone = HasLeftSafeZone(LocalPlayerIndex);
                    break;
                case 3:
                    bHasSafeZone = HasRightSafeZone(LocalPlayerIndex);
                    break;
                default:
            }
            if (bHasSafeZone)
            {
                CalculateSafeZoneValues(HorizSafeZoneValue, VertSafeZoneValue, Canvas, LocalPlayerIndex, bUseMaxPercent);
                if (SZType == 0 || SZType == 1)
                {
                    return VertSafeZoneValue;
                }
                else
                {
                    return HorizSafeZoneValue;
                }
            }
        }
    }
    return 0.0;
}

final function CalculateSafeZoneValues(out float out_Horizontal, out float out_Vertical, Canvas Canvas, int LocalPlayerIndex, bool bUseMaxPercent)
{
    local float ScreenWidth, ScreenHeight, XSafeZoneToUse, YSafeZoneToUse;
    
    XSafeZoneToUse = (bUseMaxPercent ? TitleSafeZone.MaxPercentX : TitleSafeZone.RecommendedPercentX);
    YSafeZoneToUse = (bUseMaxPercent ? TitleSafeZone.MaxPercentY : TitleSafeZone.RecommendedPercentY);
    GetPixelSizeOfScreen(ScreenWidth, ScreenHeight, Canvas, LocalPlayerIndex);
    out_Horizontal = ScreenWidth * (float(1) - XSafeZoneToUse) / 2.0;
    out_Vertical = ScreenHeight * (float(1) - YSafeZoneToUse) / 2.0;
}

final function GetPixelSizeOfScreen(out float out_Width, out float out_Height, Canvas Canvas, int LocalPlayerIndex)
{
    switch (GetSplitscreenConfiguration())
    {
        case 0:
            out_Width = Canvas.ClipX;
            out_Height = Canvas.ClipY;
            return;
        case 1:
            out_Width = Canvas.ClipX;
            out_Height = Canvas.ClipY * float(2);
            return;
        case 2:
            out_Width = Canvas.ClipX * float(2);
            out_Height = Canvas.ClipY;
            return;
        case 3:
            if (LocalPlayerIndex == 0)
            {
                out_Width = Canvas.ClipX;
            }
            else
            {
                out_Width = Canvas.ClipX * float(2);
            }
            out_Height = Canvas.ClipY * float(2);
            return;
        case 4:
            if (LocalPlayerIndex == 2)
            {
                out_Width = Canvas.ClipX;
            }
            else
            {
                out_Width = Canvas.ClipX * float(2);
            }
            out_Height = Canvas.ClipY * float(2);
            return;
        case 5:
            out_Width = Canvas.ClipX * float(2);
            out_Height = Canvas.ClipY * float(2);
            return;
        default:
    }
}

final function bool HasRightSafeZone(int LocalPlayerIndex)
{
    switch (GetSplitscreenConfiguration())
    {
        case 0:
        case 1:
            return true;
        case 2:
        case 4:
            return LocalPlayerIndex > 0 ? true : false;
        case 3:
            return LocalPlayerIndex == 1 ? false : true;
        case 5:
            return LocalPlayerIndex == 0 || LocalPlayerIndex == 2 ? false : true;
        default:
            return false;
    }
}

final function bool HasLeftSafeZone(int LocalPlayerIndex)
{
    switch (GetSplitscreenConfiguration())
    {
        case 0:
        case 1:
            return true;
        case 2:
            return LocalPlayerIndex == 0 ? true : false;
        case 3:
            return LocalPlayerIndex < 2 ? true : false;
        case 4:
        case 5:
            return LocalPlayerIndex == 0 || LocalPlayerIndex == 2 ? true : false;
        default:
            return false;
    }
}

final function bool HasBottomSafeZone(int LocalPlayerIndex)
{
    switch (GetSplitscreenConfiguration())
    {
        case 0:
        case 2:
            return true;
        case 1:
        case 3:
            return LocalPlayerIndex == 0 ? false : true;
        case 4:
        case 5:
            return LocalPlayerIndex > 1 ? true : false;
        default:
            return false;
    }
}

final function bool HasTopSafeZone(int LocalPlayerIndex)
{
    switch (GetSplitscreenConfiguration())
    {
        case 0:
        case 2:
            return true;
        case 1:
        case 3:
            return LocalPlayerIndex == 0 ? true : false;
        case 4:
        case 5:
            return LocalPlayerIndex < 2 ? true : false;
        default:
            return false;
    }
}

final function int ConvertLocalPlayerToGamePlayerIndex(LocalPlayer LPlayer)
{
    return Outer.GamePlayers.Find(LPlayer);
}

event GetSubtitleRegion(out Vector2D MinPos, out Vector2D MaxPos)
{
    MaxPos.X = 1.0;
    MaxPos.Y = (Outer.GamePlayers.Length == 1 ? 0.9 : 0.5);
}

event LayoutPlayers()
{
    local int Idx;
    local ESplitScreenType SplitType;
    
    UpdateActiveSplitscreenType();
    SplitType = GetSplitscreenConfiguration();
    for (Idx = 0; Idx < Outer.GamePlayers.Length; Idx++)
    {
        if (int(SplitType) < SplitscreenInfo.Length && Idx < SplitscreenInfo[int(SplitType)].PlayerData.Length)
        {
            Outer.GamePlayers[Idx].Size.X = SplitscreenInfo[int(SplitType)].PlayerData[Idx].SizeX;
            Outer.GamePlayers[Idx].Size.Y = SplitscreenInfo[int(SplitType)].PlayerData[Idx].SizeY;
            Outer.GamePlayers[Idx].Origin.X = SplitscreenInfo[int(SplitType)].PlayerData[Idx].OriginX;
            Outer.GamePlayers[Idx].Origin.Y = SplitscreenInfo[int(SplitType)].PlayerData[Idx].OriginY;
            continue;
        }
        Outer.GamePlayers[Idx].Size.X = 0.0;
        Outer.GamePlayers[Idx].Size.Y = 0.0;
        Outer.GamePlayers[Idx].Origin.X = 0.0;
        Outer.GamePlayers[Idx].Origin.Y = 0.0;
    }
}

function UpdateActiveSplitscreenType()
{
    local ESplitScreenType SplitType;
    
    SplitType = DesiredSplitscreenType;
    switch (Outer.GamePlayers.Length)
    {
        case 0:
        case 1:
            SplitType = 0;
            break;
        case 2:
            if (SplitType != 1 && SplitType != 2)
            {
                SplitType = Default2PSplitType;
            }
            break;
        case 3:
            if (SplitType != 3 && SplitType != 4)
            {
                SplitType = Default3PSplitType;
            }
            break;
        default:
            SplitType = 5;
            break;
    }
    ActiveSplitscreenType = SplitType;
}

function ESplitScreenType GetSplitscreenConfiguration()
{
    return ActiveSplitscreenType;
}

function SetSplitscreenConfiguration(ESplitScreenType SplitType)
{
    DesiredSplitscreenType = SplitType;
}

event GameSessionEnded()
{
    local int I;
    
    for (I = 0; I < GlobalInteractions.Length; I++)
    {
        GlobalInteractions[I].NotifyGameSessionEnded();
    }
}

event int InsertInteraction(Interaction NewInteraction, optional int InIndex = -1)
{
    local int Result;
    
    Result = -1;
    if (NewInteraction != none)
    {
        if (InIndex == -1)
        {
            InIndex = GlobalInteractions.Length;
        }
        if (InIndex >= 0)
        {
            Result = Clamp(InIndex, 0, GlobalInteractions.Length);
            GlobalInteractions.Insert(Result, 1);
            GlobalInteractions[Result] = NewInteraction;
            NewInteraction.Init();
            NewInteraction.OnInitialize();
        }
        else
        {
            WarnInternal("Invalid insertion index specified:" @ string(InIndex));
        }
    }
    return Result;
}

function bool CreateInitialPlayer(out string OutError)
{
    local int ControllerId;
    local bool bFoundInitialGamepad, bResult;
    
    for (ControllerId = 0; ControllerId < 4; ControllerId++)
    {
        if (UIController.IsLoggedIn(ControllerId))
        {
            bFoundInitialGamepad = true;
            bResult = CreatePlayer(ControllerId, OutError, false) != none;
            break;
        }
    }
    if (!bFoundInitialGamepad || !bResult)
    {
        for (ControllerId = 0; ControllerId < 4; ControllerId++)
        {
            if (UIController.IsGamepadConnected(ControllerId))
            {
                bFoundInitialGamepad = true;
                bResult = CreatePlayer(ControllerId, OutError, false) != none;
                break;
            }
        }
    }
    if (!bFoundInitialGamepad || !bResult)
    {
        bResult = CreatePlayer(0, OutError, false) != none;
    }
    return bResult;
}

event bool Init(out string OutError)
{
    local PlayerManagerInteraction PlayerInteraction;
    
    assert(Outer.ConsoleClass != none);
    ActiveSplitscreenType = DesiredSplitscreenType;
    ViewportConsole = new(self) Outer.ConsoleClass;
    if (InsertInteraction(ViewportConsole) == -1)
    {
        OutError = "Failed to add interaction to GlobalInteractions array:" @ string(ViewportConsole);
        return false;
    }
    assert(UIControllerClass != none);
    UIController = new(self) UIControllerClass;
    if (InsertInteraction(UIController) == -1)
    {
        OutError = "Failed to add interaction to GlobalInteractions array:" @ string(UIController);
        return false;
    }
    PlayerInteraction = new(self) class'PlayerManagerInteraction';
    if (InsertInteraction(PlayerInteraction) == -1)
    {
        OutError = "Failed to add interaction to GlobalInteractions array:" @ string(PlayerInteraction);
        return false;
    }
    return CreateInitialPlayer(OutError);
}

exec function SetConsoleTarget(int PlayerIndex)
{
    if (PlayerIndex >= 0 && PlayerIndex < Outer.GamePlayers.Length)
    {
        ViewportConsole.ConsoleTargetPlayer = Outer.GamePlayers[PlayerIndex];
    }
    else
    {
        ViewportConsole.ConsoleTargetPlayer = none;
    }
}

exec function ShowTitleSafeArea()
{
    bShowTitleSafeZone = !bShowTitleSafeZone;
}

exec function SetSplit(int Mode)
{
    SetSplitscreenConfiguration(byte(Mode));
}

exec function DebugRemovePlayer(int ControllerId)
{
    local LocalPlayer ExPlayer;
    
    ExPlayer = FindPlayerByControllerId(ControllerId);
    if (ExPlayer != none)
    {
        RemovePlayer(ExPlayer);
    }
}

exec function SSSwapControllers()
{
    local int Idx, TmpControllerID;
    
    TmpControllerID = Outer.GamePlayers[0].ControllerId;
    for (Idx = 0; Idx < Outer.GamePlayers.Length - 1; ++Idx)
    {
        Outer.GamePlayers[Idx].ControllerId = Outer.GamePlayers[Idx + 1].ControllerId;
    }
    Outer.GamePlayers[Outer.GamePlayers.Length - 1].ControllerId = TmpControllerID;
}

exec function DebugCreatePlayer(int ControllerId)
{
    local string Error;
    
    CreatePlayer(ControllerId, Error, true);
}

final event LocalPlayer FindPlayerByControllerId(int ControllerId)
{
    local int PlayerIndex;
    
    for (PlayerIndex = 0; PlayerIndex < Outer.GamePlayers.Length; PlayerIndex++)
    {
        if (Outer.GamePlayers[PlayerIndex].ControllerId == ControllerId)
        {
            return Outer.GamePlayers[PlayerIndex];
        }
    }
    return none;
}

event bool RemovePlayer(LocalPlayer ExPlayer)
{
    local int OldIndex;
    
    if (ExPlayer.Actor.Role == 3)
    {
        LogInternal("Removing player" @ string(ExPlayer) @ " with ControllerId" @ string(ExPlayer.ControllerId) @ "at index" @ string(Outer.GamePlayers.Find(ExPlayer)) @ "(" $ string(Outer.GamePlayers.Length) @ "existing players)", 'PlayerManagement');
        ExPlayer.ViewportClient = none;
        if (ExPlayer.Actor != none)
        {
            ExPlayer.Actor.Destroy();
        }
        OldIndex = RemoveLocalPlayer(ExPlayer);
        if (OldIndex != -1)
        {
            NotifyPlayerRemoved(OldIndex, ExPlayer);
        }
        LogInternal("Finished removing player " @ string(ExPlayer) @ " with ControllerId" @ string(ExPlayer.ControllerId) @ "at index" @ string(OldIndex) @ "(" $ string(Outer.GamePlayers.Length) @ "remaining players)", 'PlayerManagement');
        return true;
    }
    else
    {
        LogInternal("Not removing player" @ string(ExPlayer) @ " with ControllerId" @ string(ExPlayer.ControllerId) @ "because player does not have appropriate role (" $ string(GetEnum(Enum'Actor.ENetRole', int(ExPlayer.Actor.Role))) $ ")", 'PlayerManagement');
        return false;
    }
}

event LocalPlayer CreatePlayer(int ControllerId, out string OutError, bool bSpawnActor)
{
    local LocalPlayer NewPlayer;
    local int InsertIndex;
    
    LogInternal("Creating new player with ControllerId" @ string(ControllerId) @ "(" $ string(Outer.GamePlayers.Length) @ "existing players)", 'PlayerManagement');
    assert(Outer.LocalPlayerClass != none);
    NewPlayer = new(Outer) Outer.LocalPlayerClass;
    NewPlayer.ViewportClient = self;
    NewPlayer.ControllerId = ControllerId;
    InsertIndex = AddLocalPlayer(NewPlayer);
    if (bSpawnActor && InsertIndex != -1)
    {
        if (Outer.GetCurrentWorldInfo().NetMode != 3)
        {
            if (!NewPlayer.SpawnPlayActor("", OutError))
            {
                RemoveLocalPlayer(NewPlayer);
                NewPlayer = none;
            }
        }
        else
        {
            NewPlayer.SendSplitJoin();
        }
    }
    if (OutError != "")
    {
        LogInternal("Player creation failed with error:" @ OutError);
    }
    else
    {
        LogInternal("Successfully created new player with ControllerId" @ string(ControllerId) $ ":" @ string(NewPlayer) @ "- inserted into GamePlayers array at index" @ string(InsertIndex) @ "(" $ string(Outer.GamePlayers.Length) @ "existing players)", 'PlayerManagement');
        if (NewPlayer != none && InsertIndex != -1)
        {
            NotifyPlayerAdded(InsertIndex, NewPlayer);
        }
    }
    return NewPlayer;
}

native final function bool ShouldForceFullscreenViewport()
{
}

native final function bool IsFullScreenViewport()
{
}

native final function GetViewportSize(out Vector2D out_ViewportSize)
{
    out_ViewportSize;
}

native function string ConsoleCommand(string Command)
{
    Command;
}

delegate bool HandleInputChar(int ControllerId, string Unicode)
{
}

delegate bool HandleInputAxis(int ControllerId, name Key, float Delta, float DeltaTime, bool bGamepad)
{
}

delegate bool HandleInputKey(int ControllerId, name Key, EInputEvent EventType, float AmountDepressed, optional bool bGamepad)
{
}

defaultproperties
{
    UIControllerClass="UIInteraction"
    ShowFlags=()
    LoadingMessage="LOADING"
    SavingMessage="SAVING"
    ConnectingMessage="CONNECTING"
    PausedMessage="PAUSED"
    PrecachingMessage="PRECACHING"
    TitleSafeZone=(MaxPercentX=0.9,MaxPercentY=0.9,RecommendedPercentX=0.8,RecommendedPercentY=0.8)
    SplitscreenInfo(0)=(PlayerData=((SizeX=1.0,SizeY=1.0,OriginX=0.0,OriginY=0.0)))
    SplitscreenInfo(1)=(PlayerData=((SizeX=1.0,SizeY=0.5,OriginX=0.0,OriginY=0.0),(SizeX=1.0,SizeY=0.5,OriginX=0.0,OriginY=0.5)))
    SplitscreenInfo(2)=(PlayerData=((SizeX=0.5,SizeY=1.0,OriginX=0.0,OriginY=0.0),(SizeX=0.5,SizeY=1.0,OriginX=0.5,OriginY=0.0)))
    SplitscreenInfo(3)=(PlayerData=((SizeX=1.0,SizeY=0.5,OriginX=0.0,OriginY=0.0),(SizeX=0.5,SizeY=0.5,OriginX=0.0,OriginY=0.5),(SizeX=0.5,SizeY=0.5,OriginX=0.5,OriginY=0.5)))
    SplitscreenInfo(4)=(PlayerData=((SizeX=0.5,SizeY=0.5,OriginX=0.0,OriginY=0.0),(SizeX=0.5,SizeY=0.5,OriginX=0.5,OriginY=0.0),(SizeX=1.0,SizeY=0.5,OriginX=0.0,OriginY=0.5)))
    SplitscreenInfo(5)=(PlayerData=((SizeX=0.5,SizeY=0.5,OriginX=0.0,OriginY=0.0),(SizeX=0.5,SizeY=0.5,OriginX=0.5,OriginY=0.0),(SizeX=0.5,SizeY=0.5,OriginX=0.0,OriginY=0.5),(SizeX=0.5,SizeY=0.5,OriginX=0.5,OriginY=0.5)))
    Default2PSplitType="eSST_2P_HORIZONTAL"
    Default3PSplitType="eSST_3P_FAVOR_TOP"
    ProgressTimeOut=8.0
    ProgressFadeTime=1.0
}

class HUD extends Actor
    native
    notplaceable
    transient
    config(Game)
    hidecategories(Navigation);

struct native KismetDrawTextInfo
{
    var() string MessageText;
    var() Font MessageFont;
    var() Vector2D MessageFontScale;
    var() Vector2D MessageOffset;
    var() Color MessageColor;
    var float MessageEndTime;
};

struct native HudLocalizedMessage
{
    var class<LocalMessage> Message;
    var string StringMessage;
    var int Switch;
    var float EndOfLife;
    var float Lifetime;
    var float PosY;
    var Color DrawColor;
    var int FontSize;
    var Font StringFont;
    var float DX;
    var float DY;
    var bool Drawn;
    var int Count;
    var Object OptionalObject;
};

struct native ConsoleMessage
{
    var string Text;
    var Color TextColor;
    var float MessageLife;
    var PlayerReplicationInfo PRI;
};

var const Color WhiteColor;
var const Color GreenColor;
var const Color RedColor;
var PlayerController PlayerOwner;
var ScoreBoard ScoreBoard;
var transient bool bLostFocusPaused;
var config bool bShowHUD;
var bool bShowScores;
var bool bShowDebugInfo;
var bool bShowGameDebug;
var bool bShowDebugText;
var bool bShowSafeFrame;
var() bool bShowBadConnectionAlert;
var bool bShowScreenLog;
var globalconfig bool bMessageBeep;
var bool bShowOverlays;
var globalconfig float HudCanvasScale;
var array<Actor> PostRenderedActors;
var array<ConsoleMessage> ConsoleMessages;
var const Color ConsoleColor;
var globalconfig int ConsoleMessageCount;
var globalconfig int ConsoleFontSize;
var globalconfig int MessageFontOffset;
var int MaxHUDAreaMessageCount;
var() transient HudLocalizedMessage LocalMessages[8];
var() float ConsoleMessagePosX;
var() float ConsoleMessagePosY;
var Canvas Canvas;
var transient float LastHUDRenderTime;
var transient float RenderDelta;
var transient float SizeX;
var transient float SizeY;
var transient float CenterX;
var transient float CenterY;
var transient float RatioX;
var transient float RatioY;
var globalconfig array<name> DebugDisplay;
var array<KismetDrawTextInfo> KismetTextInfo;

event OnLostFocusPause(bool bEnable)
{
    if (bLostFocusPaused == bEnable)
    {
        return;
    }
    if (WorldInfo.NetMode != 3)
    {
        bLostFocusPaused = bEnable;
        PlayerOwner.SetPause(bEnable);
    }
}

function PlayerOwnerDied()
{
}

static function Color GetRYGColorRamp(float Pct)
{
    local Color GYRColor;
    
    GYRColor.A = 255;
    if (Pct < 0.34)
    {
        GYRColor.R = byte(float(128) + float(127) * FClamp(3.0 * Pct, 0.0, 1.0));
        GYRColor.G = 0;
        GYRColor.B = 0;
    }
    else if (Pct < 0.67)
    {
        GYRColor.R = 255;
        GYRColor.G = byte(float(255) * FClamp(3.0 * (Pct - 0.33), 0.0, 1.0));
        GYRColor.B = 0;
    }
    else
    {
        GYRColor.R = byte(float(255) * FClamp(3.0 * (1.0 - Pct), 0.0, 1.0));
        GYRColor.G = 255;
        GYRColor.B = 0;
    }
    return GYRColor;
}

static function Font GetFontSizeIndex(int FontSize)
{
    if (FontSize == 0)
    {
        return class'Engine'.static.GetTinyFont();
    }
    else if (FontSize == 1)
    {
        return class'Engine'.static.GetSmallFont();
    }
    else if (FontSize == 2)
    {
        return class'Engine'.static.GetMediumFont();
    }
    else if (FontSize == 3)
    {
        return class'Engine'.static.GetLargeFont();
    }
    else
    {
        return class'Engine'.static.GetLargeFont();
    }
}

function DrawText(string Text, Vector2D Position, Font TextFont, Vector2D FontScale, Color TextColor)
{
    local float XL, YL;
    
    Canvas.Font = TextFont;
    Canvas.TextSize(Text, XL, YL);
    Canvas.SetPos(Canvas.ClipX / float(2) - XL / float(2) + Position.X, Canvas.ClipY / float(3) - YL / float(2) + Position.Y);
    Canvas.SetDrawColor(TextColor.R, TextColor.G, TextColor.B, TextColor.A);
    Canvas.DrawText(Text, false, FontScale.X, FontScale.Y);
}

function DisplayKismetMessages()
{
    local int KismetTextIdx;
    
    KismetTextIdx = 0;
    while (KismetTextIdx < KismetTextInfo.Length)
    {
        if (KismetTextInfo[KismetTextIdx].MessageEndTime > float(0) && KismetTextInfo[KismetTextIdx].MessageEndTime <= WorldInfo.TimeSeconds)
        {
            KismetTextInfo.Remove(KismetTextIdx, 1);
            continue;
        }
        DrawText(KismetTextInfo[KismetTextIdx].MessageText, KismetTextInfo[KismetTextIdx].MessageOffset, KismetTextInfo[KismetTextIdx].MessageFont, KismetTextInfo[KismetTextIdx].MessageFontScale, KismetTextInfo[KismetTextIdx].MessageColor);
        ++KismetTextIdx;
    }
}

function DisplayLocalMessages()
{
    local float PosY, DY, DX;
    local int I, J, LocalMessagesArrayCount, AreaMessageCount;
    local float FadeValue;
    local int FontSize;
    
    if (LocalMessages[0].Message == none)
    {
        return;
    }
    Canvas.Reset(true);
    LocalMessagesArrayCount = 8;
    for (I = 0; I < LocalMessagesArrayCount; I++)
    {
        if (LocalMessages[I].Message == none)
        {
            break;
        }
        LocalMessages[I].Drawn = false;
        if (LocalMessages[I].StringFont == none)
        {
            FontSize = LocalMessages[I].FontSize + MessageFontOffset;
            LocalMessages[I].StringFont = GetFontSizeIndex(FontSize);
            Canvas.Font = LocalMessages[I].StringFont;
            Canvas.TextSize(LocalMessages[I].StringMessage, DX, DY);
            LocalMessages[I].DX = DX;
            LocalMessages[I].DY = DY;
            if (LocalMessages[I].StringFont == none)
            {
                WarnInternal("LayoutMessage(" $ string(LocalMessages[I].Message) $ ") failed!");
                for (J = I; J < LocalMessagesArrayCount - 1; J++)
                {
                    LocalMessages[J] = LocalMessages[J + 1];
                }
                ClearMessage(LocalMessages[J]);
                I--;
                continue;
            }
        }
        FadeValue = LocalMessages[I].EndOfLife - WorldInfo.TimeSeconds;
        if (FadeValue <= 0.0)
        {
            for (J = I; J < LocalMessagesArrayCount - 1; J++)
            {
                LocalMessages[J] = LocalMessages[J + 1];
            }
            ClearMessage(LocalMessages[J]);
            I--;
            continue;
        }
    }
    for (I = 0; I < LocalMessagesArrayCount; I++)
    {
        if (LocalMessages[I].Message == none)
        {
            break;
        }
        if (LocalMessages[I].Drawn)
        {
            continue;
        }
        PosY = LocalMessages[I].PosY;
        AreaMessageCount = 0;
        for (J = I; J < LocalMessagesArrayCount; J++)
        {
            if (LocalMessages[J].Drawn || LocalMessages[I].PosY != LocalMessages[J].PosY)
            {
                continue;
            }
            DrawMessage(J, PosY, DX, DY);
            PosY += DY;
            AreaMessageCount++;
        }
        if (AreaMessageCount > MaxHUDAreaMessageCount)
        {
            LocalMessages[I].EndOfLife = WorldInfo.TimeSeconds;
        }
    }
}

function DrawMessageText(HudLocalizedMessage LocalMessage, float ScreenX, float ScreenY)
{
    local FontRenderInfo FontInfo;
    
    Canvas.SetPos(ScreenX, ScreenY);
    FontInfo.bClipText = true;
    Canvas.DrawText(LocalMessage.StringMessage, false, , , FontInfo);
}

function DrawMessage(int I, float PosY, out float DX, out float DY)
{
    local float FadeValue, ScreenX, ScreenY;
    
    FadeValue = FMin(1.0, LocalMessages[I].EndOfLife - WorldInfo.TimeSeconds);
    Canvas.DrawColor = LocalMessages[I].DrawColor;
    Canvas.DrawColor.A = byte(FadeValue * float(Canvas.DrawColor.A));
    Canvas.Font = LocalMessages[I].StringFont;
    GetScreenCoords(PosY, ScreenX, ScreenY, LocalMessages[I]);
    DX = LocalMessages[I].DX / Canvas.ClipX;
    DY = LocalMessages[I].DY / Canvas.ClipY;
    DrawMessageText(LocalMessages[I], ScreenX, ScreenY);
    LocalMessages[I].Drawn = true;
}

function GetScreenCoords(float PosY, out float ScreenX, out float ScreenY, out HudLocalizedMessage InMessage)
{
    ScreenX = 0.5 * Canvas.ClipX;
    ScreenY = PosY * HudCanvasScale * Canvas.ClipY + (1.0 - HudCanvasScale) * 0.5 * Canvas.ClipY;
    ScreenX -= InMessage.DX * 0.5;
    ScreenY -= InMessage.DY * 0.5;
}

function AddLocalizedMessage(int Index, class<LocalMessage> InMessageClass, string CriticalString, int Switch, float Position, float Lifetime, int FontSize, Color DrawColor, optional int MessageCount, optional Object OptionalObject)
{
    LocalMessages[Index].Message = InMessageClass;
    LocalMessages[Index].Switch = Switch;
    LocalMessages[Index].EndOfLife = Lifetime + WorldInfo.TimeSeconds;
    LocalMessages[Index].StringMessage = CriticalString;
    LocalMessages[Index].Lifetime = Lifetime;
    LocalMessages[Index].PosY = Position;
    LocalMessages[Index].DrawColor = DrawColor;
    LocalMessages[Index].FontSize = FontSize;
    LocalMessages[Index].Count = MessageCount;
    LocalMessages[Index].OptionalObject = OptionalObject;
}

function LocalizedMessage(class<LocalMessage> InMessageClass, PlayerReplicationInfo RelatedPRI_1, string CriticalString, int Switch, float Position, float Lifetime, int FontSize, Color DrawColor, optional Object OptionalObject)
{
    local int I, LocalMessagesArrayCount, MessageCount;
    
    if (InMessageClass == none || CriticalString == "")
    {
        return;
    }
    if (bMessageBeep && InMessageClass.default.default.bBeep)
    {
        PlayerOwner.PlayBeepSound();
    }
    if (!InMessageClass.default.default.bIsSpecial)
    {
        AddConsoleMessage(CriticalString, InMessageClass, RelatedPRI_1);
        return;
    }
    LocalMessagesArrayCount = 8;
    I = LocalMessagesArrayCount;
    if (InMessageClass.default.default.bIsUnique)
    {
        for (I = 0; I < LocalMessagesArrayCount; I++)
        {
            if (LocalMessages[I].Message == InMessageClass)
            {
                if (InMessageClass.default.default.bCountInstances && LocalMessages[I].StringMessage ~= CriticalString)
                {
                    MessageCount = (LocalMessages[I].Count == 0 ? 2 : LocalMessages[I].Count + 1);
                }
                break;
            }
        }
    }
    else if (InMessageClass.default.default.bIsPartiallyUnique)
    {
        for (I = 0; I < LocalMessagesArrayCount; I++)
        {
            if (LocalMessages[I].Message == InMessageClass && InMessageClass.static.PartiallyDuplicates(Switch, LocalMessages[I].Switch, OptionalObject, LocalMessages[I].OptionalObject))
            {
                break;
            }
        }
    }
    if (I == LocalMessagesArrayCount)
    {
        for (I = 0; I < LocalMessagesArrayCount; I++)
        {
            if (LocalMessages[I].Message == none)
            {
                break;
            }
        }
    }
    if (I == LocalMessagesArrayCount)
    {
        for (I = 0; I < LocalMessagesArrayCount - 1; I++)
        {
            LocalMessages[I] = LocalMessages[I + 1];
        }
    }
    ClearMessage(LocalMessages[I]);
    AddLocalizedMessage(I, InMessageClass, CriticalString, Switch, Position, Lifetime, FontSize, DrawColor, MessageCount, OptionalObject);
}

function AddConsoleMessage(string M, class<LocalMessage> InMessageClass, PlayerReplicationInfo PRI, optional float Lifetime)
{
    local int Idx, MsgIdx;
    
    if (!bShowScreenLog)
    {
        return;
    }
    MsgIdx = -1;
    if (bMessageBeep && InMessageClass.default.default.bBeep)
    {
        PlayerOwner.PlayBeepSound();
    }
    if (ConsoleMessages.Length < ConsoleMessageCount)
    {
        MsgIdx = ConsoleMessages.Length;
    }
    else
    {
        for (Idx = 0; Idx < ConsoleMessages.Length && MsgIdx == -1; Idx++)
        {
            if (ConsoleMessages[Idx].Text == "")
            {
                MsgIdx = Idx;
            }
        }
    }
    if (MsgIdx == ConsoleMessageCount || MsgIdx == -1)
    {
        for (Idx = 0; Idx < ConsoleMessageCount - 1; Idx++)
        {
            ConsoleMessages[Idx] = ConsoleMessages[Idx + 1];
        }
        MsgIdx = ConsoleMessageCount - 1;
    }
    if (MsgIdx >= ConsoleMessages.Length)
    {
        ConsoleMessages.Length = MsgIdx + 1;
    }
    ConsoleMessages[MsgIdx].Text = M;
    if (Lifetime != 0.0)
    {
        ConsoleMessages[MsgIdx].MessageLife = WorldInfo.TimeSeconds + Lifetime;
    }
    else
    {
        ConsoleMessages[MsgIdx].MessageLife = WorldInfo.TimeSeconds + InMessageClass.default.default.Lifetime;
    }
    ConsoleMessages[MsgIdx].TextColor = InMessageClass.static.GetConsoleColor(PRI);
    ConsoleMessages[MsgIdx].PRI = PRI;
}

function DisplayConsoleMessages()
{
    local int Idx, XPos, YPos;
    local float XL, YL;
    
    if (ConsoleMessages.Length == 0)
    {
        return;
    }
    for (Idx = 0; Idx < ConsoleMessages.Length; Idx++)
    {
        if (ConsoleMessages[Idx].Text == "" || ConsoleMessages[Idx].MessageLife < WorldInfo.TimeSeconds)
        {
            ConsoleMessages.Remove(Idx--, 1);
        }
    }
    XPos = int(ConsoleMessagePosX * HudCanvasScale * float(Canvas.SizeX) + (1.0 - HudCanvasScale) / 2.0 * float(Canvas.SizeX));
    YPos = int(ConsoleMessagePosY * HudCanvasScale * float(Canvas.SizeY) + (1.0 - HudCanvasScale) / 2.0 * float(Canvas.SizeY));
    Canvas.Font = class'Engine'.static.GetSmallFont();
    Canvas.DrawColor = ConsoleColor;
    Canvas.TextSize("A", XL, YL);
    YPos -= int(YL * float(ConsoleMessages.Length));
    YPos -= int(YL);
    for (Idx = 0; Idx < ConsoleMessages.Length; Idx++)
    {
        if (ConsoleMessages[Idx].Text == "")
        {
            continue;
        }
        Canvas.StrLen(ConsoleMessages[Idx].Text, XL, YL);
        Canvas.SetPos(float(XPos), float(YPos));
        Canvas.DrawColor = ConsoleMessages[Idx].TextColor;
        Canvas.DrawText(ConsoleMessages[Idx].Text, false);
        YPos += int(YL);
    }
}

event FlushClientMessages()
{
    if (ConsoleMessages.Length > 0)
    {
        ConsoleMessages.Length = 0;
    }
}

function Message(PlayerReplicationInfo PRI, coerce string msg, name MsgType, optional float Lifetime)
{
    if (bMessageBeep)
    {
        PlayerOwner.PlayBeepSound();
    }
    if (MsgType == 'Say' || MsgType == 'TeamSay')
    {
        msg = PRI.PlayerName $ ": " $ msg;
    }
    AddConsoleMessage(msg, class'LocalMessage', PRI, Lifetime);
}

function ClearMessage(out HudLocalizedMessage M)
{
    M.Message = none;
    M.StringFont = none;
}

function DisplayBadConnectionAlert()
{
}

function DrawHUD()
{
    local Vector ViewPoint;
    local Rotator ViewRotation;
    
    if (bShowOverlays && PlayerOwner != none)
    {
        Canvas.Font = GetFontSizeIndex(0);
        PlayerOwner.GetPlayerViewPoint(ViewPoint, ViewRotation);
        DrawActorOverlays(ViewPoint, ViewRotation);
    }
    PlayerOwner.DrawHUD(self);
}

event PostRender()
{
    local float XL, YL, YPos;
    local AIController AC;
    
    RenderDelta = WorldInfo.TimeSeconds - LastHUDRenderTime;
    if (SizeX != float(Canvas.SizeX) || SizeY != float(Canvas.SizeY))
    {
        PreCalcValues();
    }
    if (PlayerOwner != none)
    {
        if (bShowDebugText)
        {
            PlayerOwner.DrawDebugTextList(Canvas, RenderDelta);
        }
    }
    if (bShowGameDebug)
    {
        Canvas.Font = class'Engine'.static.GetTinyFont();
        Canvas.DrawColor = ConsoleColor;
        Canvas.StrLen("X", XL, YL);
        YPos = 0.0;
        WorldInfo.Game.DisplayDebug(self, YL, YPos);
    }
    else if (bShowDebugInfo)
    {
        Canvas.Font = class'Engine'.static.GetTinyFont();
        Canvas.DrawColor = ConsoleColor;
        Canvas.StrLen("X", XL, YL);
        YPos = 0.0;
        PlayerOwner.ViewTarget.DisplayDebug(self, YL, YPos);
        foreach DynamicActors(class'AIController', AC)
        {
            AC.DisplayDebug(self, YL, YPos);
        }
        if (ShouldDisplayDebug('AI') && Pawn(PlayerOwner.ViewTarget) != none)
        {
            DrawRoute(Pawn(PlayerOwner.ViewTarget));
        }
    }
    else if (bShowHUD)
    {
        if (bShowScores)
        {
            if (ScoreBoard != none)
            {
                ScoreBoard.Canvas = Canvas;
                ScoreBoard.DrawHUD();
                if (ScoreBoard.bDisplayMessages)
                {
                    DisplayConsoleMessages();
                }
            }
        }
        else
        {
            DrawHUD();
            DisplayConsoleMessages();
            DisplayLocalMessages();
            DisplayKismetMessages();
        }
    }
    if (bShowSafeFrame)
    {
        DrawSafeFrame(0.85, 0.85, float(Canvas.SizeX), float(Canvas.SizeY), MakeColor(255, 255, 0, 255));
    }
    if (bShowBadConnectionAlert)
    {
        DisplayBadConnectionAlert();
    }
    LastHUDRenderTime = WorldInfo.TimeSeconds;
}

exec function ShowDebugText(bool bShow)
{
    bShowDebugText = bShow;
}

function PreCalcValues()
{
    SizeX = float(Canvas.SizeX);
    SizeY = float(Canvas.SizeY);
    CenterX = SizeX * 0.5;
    CenterY = SizeY * 0.5;
    RatioX = SizeX / 1024.0;
    RatioY = SizeY / 768.0;
}

function DrawRoute(Pawn Target)
{
    local int I;
    local Controller C;
    local Vector Start, RealStart, Dest;
    local bool bPath;
    local Actor FirstRouteCache;
    
    C = Target.Controller;
    if (C == none)
    {
        return;
    }
    if (C.CurrentPath != none)
    {
        Start = C.CurrentPath.Start.Location;
    }
    else
    {
        Start = Target.Location;
    }
    RealStart = Start;
    if (C.bAdjusting)
    {
        Draw3DLine(C.Pawn.Location, C.GetAdjustLocation(), MakeColor(255, 0, 255, 255));
        Start = C.GetAdjustLocation();
    }
    if (C.RouteCache.Length > 0)
    {
        FirstRouteCache = C.RouteCache[0];
    }
    Dest = C.GetDestinationPosition();
    if (C == PlayerOwner || C.MoveTarget == FirstRouteCache && C.MoveTarget != none)
    {
        if (C == PlayerOwner && Dest != vect(0.0, 0.0, 0.0))
        {
            if (C.PointReachable(Dest))
            {
                Draw3DLine(C.Pawn.Location, Dest, MakeColor(255, 255, 255, 255));
                return;
            }
            C.FindPathTo(Dest);
        }
        if (C.RouteCache.Length > 0)
        {
            for (I = 0; I < C.RouteCache.Length; I++)
            {
                if (C.RouteCache[I] == none)
                {
                    break;
                }
                bPath = true;
                Draw3DLine(Start, C.RouteCache[I].Location, MakeColor(0, 255, 0, 255));
                Start = C.RouteCache[I].Location;
            }
            if (bPath)
            {
                Draw3DLine(RealStart, Dest, MakeColor(255, 255, 255, 255));
            }
        }
    }
    else if (Target.Velocity != vect(0.0, 0.0, 0.0))
    {
        Draw3DLine(RealStart, Dest, MakeColor(255, 255, 255, 255));
    }
    if (C == PlayerOwner)
    {
        return;
    }
    Draw3DLine(Target.Location + Target.BaseEyeHeight * vect(0.0, 0.0, 1.0), C.GetFocalPoint(), MakeColor(255, 0, 0, 255));
}

function bool ShouldDisplayDebug(name DebugType)
{
    local int I;
    
    for (I = 0; I < DebugDisplay.Length; I++)
    {
        if (DebugDisplay[I] == DebugType)
        {
            return true;
        }
    }
    return false;
}

exec function ShowDebug(optional name DebugType)
{
    local int I;
    local bool bFound;
    
    if (DebugType == 'None')
    {
        bShowDebugInfo = !bShowDebugInfo;
    }
    else
    {
        bShowDebugInfo = true;
        for (I = 0; I < DebugDisplay.Length && !bFound; I++)
        {
            if (DebugDisplay[I] == DebugType)
            {
                DebugDisplay.Remove(I, 1);
                bFound = true;
            }
        }
        if (!bFound)
        {
            DebugDisplay[DebugDisplay.Length] = DebugType;
        }
        SaveConfig();
    }
}

exec function ShowGameDebug()
{
    bShowGameDebug = !bShowGameDebug;
}

exec function SetShowScores(bool bNewValue)
{
    bShowScores = bNewValue;
    if (ScoreBoard != none)
    {
        ScoreBoard.ChangeState(bShowScores);
    }
}

exec function ShowScores()
{
    SetShowScores(!bShowScores);
}

exec function ShowHUD()
{
    ToggleHUD();
}

exec function ToggleHUD()
{
    bShowHUD = !bShowHUD;
}

function AddPostRenderedActor(Actor A)
{
    local int I;
    
    for (I = 0; I < PostRenderedActors.Length; I++)
    {
        if (PostRenderedActors[I] == A)
        {
            return;
        }
    }
    for (I = 0; I < PostRenderedActors.Length; I++)
    {
        if (PostRenderedActors[I] == none)
        {
            PostRenderedActors[I] = A;
            return;
        }
    }
    PostRenderedActors[PostRenderedActors.Length] = A;
}

function RemovePostRenderedActor(Actor A)
{
    local int I;
    
    for (I = 0; I < PostRenderedActors.Length; I++)
    {
        if (PostRenderedActors[I] == A)
        {
            PostRenderedActors[I] = none;
            return;
        }
    }
}

native function DrawActorOverlays(Vector ViewPoint, Rotator ViewRotation)
{
    ViewPoint;
    ViewRotation;
}

event Destroyed()
{
    if (ScoreBoard != none)
    {
        ScoreBoard.Destroy();
        ScoreBoard = none;
    }
    Destroyed();
}

function SpawnScoreBoard(class<ScoreBoard> ScoringType)
{
    if (ScoringType != none)
    {
        ScoreBoard = Spawn(ScoringType, PlayerOwner);
    }
}

event PostBeginPlay()
{
    PostBeginPlay();
    PlayerOwner = PlayerController(Owner);
    GetConfigSettings();
}

native final function GetConfigSettings()
{
}

native final function DrawSafeFrame(float WidthFactor, float HeightFactor, float Width, float Height, Color BorderColor)
{
    WidthFactor;
    HeightFactor;
    Width;
    Height;
    BorderColor;
}

native final function Draw2DLine(int X1, int Y1, int X2, int Y2, Color LineColor)
{
    X1;
    Y1;
    X2;
    Y2;
    LineColor;
}

native final function Draw3DLine(Vector Start, Vector End, Color LineColor)
{
    Start;
    End;
    LineColor;
}

defaultproperties
{
    WhiteColor=(B=255,G=255,R=255,A=255)
    GreenColor=(B=0,G=255,R=0,A=255)
    RedColor=(B=0,G=0,R=255,A=255)
    bShowHUD=True
    bMessageBeep=True
    HudCanvasScale=0.95
    ConsoleColor=(B=253,G=216,R=153,A=255)
    ConsoleMessageCount=4
    ConsoleFontSize=5
    MaxHUDAreaMessageCount=3
    ConsoleMessagePosY=0.8
    DebugDisplay(0)="AI"
    bHidden=True
    CollisionType="COLLIDE_CustomDefault"
    TickGroup="TG_DuringAsyncWork"
}

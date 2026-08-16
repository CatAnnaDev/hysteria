class Console extends Interaction
    native
    notplaceable
    transient
    config(Input)
    within GameViewportClient
    hidecategories(Object,UIRoot);

const MaxHistory = 16;

struct native AutoCompleteNode
{
    var int IndexChar;
    var array<int> AutoCompleteListIndices;
    var array<Pointer> ChildNodes;
};

struct native AutoCompleteCommand
{
    var string Command;
    var string Desc;
};

var LocalPlayer ConsoleTargetPlayer;
var UIScene LargeConsoleScene;
var UIScene MiniConsoleScene;
var UILabel ConsoleBufferText;
var ConsoleEntry MiniConsoleInput;
var ConsoleEntry LargeConsoleInput;
var Texture2D DefaultTexture_Black;
var Texture2D DefaultTexture_White;
var globalconfig name ConsoleKey;
var globalconfig name TypeKey;
var globalconfig int MaxScrollbackSize;
var array<string> Scrollback;
var int SBHead;
var int SBPos;
var config int HistoryTop;
var config int HistoryBot;
var config int HistoryCur;
var config string History[16];
var transient bool bNavigatingHistory;
var transient bool bCaptureKeyInput;
var bool bCtrl;
var config bool bEnableUI;
var transient bool bAutoCompleteLocked;
var config bool bRequireCtrlToNavigateAutoComplete;
var transient bool bIsRuntimeAutoCompleteUpToDate;
var string TypedStr;
var int TypedStrPos;
var config array<AutoCompleteCommand> ManualAutoCompleteList;
var transient array<AutoCompleteCommand> AutoCompleteList;
var transient int AutoCompleteIndex;
var native transient AutoCompleteNode AutoCompleteTree;
var transient array<int> AutoCompleteIndices;

native function UpdateCompleteIndices()
{
}

native final function BuildRuntimeAutoCompleteList(optional bool bForce)
{
    bForce;
}

function AppendInputText(string Text)
{
    local int Character;
    
    while (Len(Text) > 0)
    {
        Character = Asc(Left(Text, 1));
        Text = Mid(Text, 1);
        if (Character >= 32 && Character < 256)
        {
            SetInputText(Left(TypedStr, TypedStrPos) $ Chr(Character) $ Right(TypedStr, Len(TypedStr) - TypedStrPos));
            SetCursorPos(TypedStrPos + 1);
        }
    }
    UpdateCompleteIndices();
}

function bool ProcessControlKey(name Key, EInputEvent Event)
{
    if (Key == 'LeftControl' || Key == 'RightControl')
    {
        if (Event == 1)
        {
            bCtrl = false;
        }
        else if (Event == 0)
        {
            bCtrl = true;
        }
        return true;
    }
    else if (bCtrl && Event == 0 && Outer.Outer.GamePlayers.Length > 0 && Outer.Outer.GamePlayers[0].Actor != none)
    {
        if (Key == 'V')
        {
            AppendInputText(Outer.Outer.GamePlayers[0].Actor.PasteFromClipboard());
            return true;
        }
        else if (Key == 'C')
        {
            Outer.Outer.GamePlayers[0].Actor.CopyToClipboard(TypedStr);
            return true;
        }
        else if (Key == 'X')
        {
            if (TypedStr != "")
            {
                Outer.Outer.GamePlayers[0].Actor.CopyToClipboard(TypedStr);
                SetInputText("");
                SetCursorPos(0);
            }
            return true;
        }
    }
    return false;
}

function FlushPlayerInput()
{
    local PlayerController PC;
    
    if (ConsoleTargetPlayer != none)
    {
        PC = ConsoleTargetPlayer.Actor;
    }
    else if (Outer.Outer.GamePlayers.Length > 0 && Outer.Outer.GamePlayers[0].Actor != none)
    {
        PC = Outer.Outer.GamePlayers[0].Actor;
    }
    if (PC != none && PC.PlayerInput != none)
    {
        PC.PlayerInput.ResetInput();
    }
}

function bool IsUIMiniConsoleOpen()
{
    return bEnableUI && Outer.UIController.SceneClient.FindSceneIndex(MiniConsoleScene) != -1;
}

function bool IsUIConsoleOpen()
{
    return bEnableUI && Outer.UIController.SceneClient.FindSceneIndex(LargeConsoleScene) != -1;
}

function bool InputChar(int ControllerId, string Unicode)
{
    return bCaptureKeyInput;
}

function bool InputKey(int ControllerId, name Key, EInputEvent Event, optional float AmountDepressed = 1.0, optional bool bGamepad = false)
{
    if (Event == 0)
    {
        bCaptureKeyInput = false;
        if (Key == ConsoleKey)
        {
            GotoState('Open');
            bCaptureKeyInput = true;
            return true;
        }
        else if (Key == TypeKey)
        {
            GotoState('Typing');
            bCaptureKeyInput = true;
            return true;
        }
    }
    return bCaptureKeyInput;
}

function PostRender_Console(Canvas Canvas)
{
}

function StartTyping(coerce string Text)
{
    GotoState('Typing');
    SetInputText(Text);
    SetCursorPos(Len(Text));
}

event OutputText(coerce string Text)
{
    local string RemainingText;
    local int StringLength, LineLength;
    
    RemainingText = Text;
    StringLength = Len(Text);
    while (StringLength > 0)
    {
        LineLength = InStr(RemainingText, "\n");
        if (LineLength == -1)
        {
            LineLength = StringLength;
        }
        OutputTextLine(Left(RemainingText, LineLength));
        RemainingText = Mid(RemainingText, LineLength + 1);
        StringLength -= LineLength + 1;
    }
}

function OutputTextLine(coerce string Text)
{
    if (Scrollback.Length > MaxScrollbackSize)
    {
        Scrollback.Remove(0, 1);
        SBHead = MaxScrollbackSize - 1;
    }
    else
    {
        SBHead++;
    }
    Scrollback.Length = Scrollback.Length + 1;
    Scrollback[SBHead] = Text;
    if (bEnableUI && ConsoleBufferText != none)
    {
        ConsoleBufferText.SetArrayValue(Scrollback);
    }
}

function ClearOutput()
{
    SBHead = 0;
    Scrollback.Remove(0, Scrollback.Length);
    if (bEnableUI)
    {
        ConsoleBufferText.SetValue("");
    }
}

function ConsoleCommand(string Command)
{
    if (HistoryTop == 0 ? !(History[16 - 1] ~= Command) : !(History[HistoryTop - 1] ~= Command))
    {
        PurgeCommandFromHistory(Command);
        History[HistoryTop] = Command;
        HistoryTop = (HistoryTop + 1) % 16;
        if (HistoryBot == -1 || HistoryBot == HistoryTop)
        {
            HistoryBot = (HistoryBot + 1) % 16;
        }
    }
    HistoryCur = HistoryTop;
    SaveConfig();
    if (bEnableUI)
    {
        OutputText("\n\\>\\>\\>" @ Command @ "\\<\\<\\<");
    }
    else
    {
        OutputText("\n>>>" @ Command @ "<<<");
    }
    if (ConsoleTargetPlayer != none)
    {
        ConsoleTargetPlayer.Actor.ConsoleCommand(Command);
    }
    else if (Outer.Outer.GamePlayers.Length > 0 && Outer.Outer.GamePlayers[0].Actor != none)
    {
        Outer.Outer.GamePlayers[0].Actor.ConsoleCommand(Command);
    }
    else
    {
        Outer.ConsoleCommand(Command);
    }
}

function PurgeCommandFromHistory(string Command)
{
    local int HistoryIdx, Idx, NextIdx;
    
    if (HistoryTop >= 0 && HistoryTop < 16)
    {
        for (HistoryIdx = 0; HistoryIdx < 16; ++HistoryIdx)
        {
            if (History[HistoryIdx] ~= Command)
            {
                Idx = HistoryIdx;
                NextIdx = (HistoryIdx + 1) % 16;
                while (Idx != HistoryTop)
                {
                    History[Idx] = History[NextIdx];
                    Idx = NextIdx;
                    NextIdx = (NextIdx + 1) % 16;
                }
                HistoryTop = (HistoryTop == 0 ? 16 - 1 : HistoryTop - 1);
            }
        }
    }
}

function SetCursorPos(int Position)
{
    TypedStrPos = Position;
    if (bEnableUI)
    {
        MiniConsoleInput.CursorPosition = Position;
        LargeConsoleInput.CursorPosition = Position;
    }
}

function SetInputText(string Text)
{
    TypedStr = Text;
    if (bEnableUI)
    {
        MiniConsoleInput.SetValue(Text);
        LargeConsoleInput.SetValue(Text);
    }
}

function Initialized()
{
    Initialized();
    if (bEnableUI)
    {
        LargeConsoleScene = UIScene(DynamicLoadObject("EngineScenes.ConsoleScene", class'UIScene'));
        MiniConsoleScene = UIScene(DynamicLoadObject("EngineScenes.MiniConsole", class'UIScene'));
        Outer.UIController.SceneClient.InitializeScene(LargeConsoleScene, none, LargeConsoleScene);
        Outer.UIController.SceneClient.InitializeScene(MiniConsoleScene, none, MiniConsoleScene);
        LargeConsoleInput = ConsoleEntry(LargeConsoleScene.FindChild('CommandRegion'));
        MiniConsoleInput = ConsoleEntry(MiniConsoleScene.FindChild('CommandRegion'));
        ConsoleBufferText = UILabel(LargeConsoleScene.FindChild('BufferText'));
    }
}

state Open
{
    event EndState(name NextStateName)
    {
        if (LargeConsoleScene != none)
        {
            LargeConsoleScene.CloseScene();
        }
    }
    
    event BeginState(name PreviousStateName)
    {
        bCaptureKeyInput = true;
        HistoryCur = HistoryTop;
        SBPos = 0;
        bCtrl = false;
        if (bEnableUI && LargeConsoleScene != none)
        {
            LargeConsoleScene.OpenScene(LargeConsoleScene, Outer.Outer.GamePlayers[0]);
        }
        else if (PreviousStateName == 'None')
        {
            FlushPlayerInput();
        }
    }
    
    event PostRender_Console(Canvas Canvas)
    {
        local float Height, XL, YL, Y, ScrollLineXL, ScrollLineYL, info_xl, info_yl;
        local string OutStr;
        local int Idx, MatchIdx;
        
        if (!IsUIConsoleOpen())
        {
            Canvas.Font = class'Engine'.static.GetSmallFont();
            Height = Canvas.ClipY * 0.75;
            Canvas.SetDrawColor(255, 255, 255, 255);
            Canvas.SetPos(0.0, 0.0);
            Canvas.DrawTile(DefaultTexture_Black, Canvas.ClipX, Height, 0.0, 0.0, 32.0, 32.0);
            OutStr = "(>" @ TypedStr;
            Canvas.StrLen(OutStr, XL, YL);
            Canvas.SetPos(0.0, Height - float(12) - YL);
            Canvas.SetDrawColor(0, 255, 0);
            Canvas.DrawTile(DefaultTexture_White, Canvas.ClipX, 2.0, 0.0, 0.0, 32.0, 32.0);
            Canvas.SetPos(0.0, Height);
            Canvas.DrawTile(DefaultTexture_White, Canvas.ClipX, 2.0, 0.0, 0.0, 32.0, 32.0);
            Canvas.SetPos(0.0, Height - float(5) - YL);
            Canvas.bCenter = false;
            Canvas.DrawText(OutStr, false);
            if (AutoCompleteIndices.Length > 0)
            {
                Idx = AutoCompleteIndices[0];
                Canvas.SetPos(0.0 + XL, Height - float(5) - YL);
                Canvas.SetDrawColor(87, 148, 87);
                Canvas.DrawText(Right(AutoCompleteList[Idx].Command, Len(AutoCompleteList[Idx].Command) - Len(TypedStr)), false);
                Canvas.StrLen("(>", XL, YL);
                Y = Height + float(5);
                for (MatchIdx = 0; MatchIdx < AutoCompleteIndices.Length && MatchIdx < 10; MatchIdx++)
                {
                    Idx = AutoCompleteIndices[MatchIdx];
                    Canvas.SetPos(0.0 + XL, Y);
                    Canvas.StrLen(AutoCompleteList[Idx].Desc, info_xl, info_yl);
                    Canvas.SetDrawColor(0, 0, 0);
                    Canvas.DrawTile(DefaultTexture_White, info_xl, info_yl, 0.0, 0.0, 32.0, 32.0);
                    Canvas.SetPos(0.0 + XL, Y);
                    Canvas.SetDrawColor(0, 255, 0);
                    Canvas.DrawText(AutoCompleteList[Idx].Desc, false);
                    Y += info_yl;
                }
            }
            OutStr = "(>" @ Left(TypedStr, TypedStrPos);
            Canvas.StrLen(OutStr, XL, YL);
            Canvas.SetPos(XL, Height - float(3) - YL);
            Canvas.DrawText("_");
            Idx = SBHead - SBPos;
            Y = Height - float(16) - YL * float(2);
            if (Scrollback.Length == 0)
            {
                return;
            }
            Canvas.SetDrawColor(255, 255, 255, 255);
            while (Y > YL && Idx >= 0)
            {
                Canvas.SetPos(0.0, Y);
                Canvas.StrLen(Scrollback[Idx], ScrollLineXL, ScrollLineYL);
                if (ScrollLineYL > YL)
                {
                    Y -= ScrollLineYL - YL;
                    Canvas.CurY = Y;
                }
                Canvas.DrawText(Scrollback[Idx], false);
                Idx--;
                Y -= YL;
            }
        }
    }
    
    function bool InputKey(int ControllerId, name Key, EInputEvent Event, optional float AmountDepressed = 1.0, optional bool bGamepad = false)
    {
        local string Temp;
        
        if (Event == 0)
        {
            bCaptureKeyInput = false;
        }
        if (ProcessControlKey(Key, Event))
        {
            return true;
        }
        else if (bGamepad)
        {
            return false;
        }
        else if (Key == 'Escape' && Event == 1)
        {
            if (TypedStr != "")
            {
                SetInputText("");
                SetCursorPos(0);
                HistoryCur = HistoryTop;
                return true;
            }
            else
            {
                GotoState('None');
            }
        }
        else if (Key == ConsoleKey && Event == 0)
        {
            GotoState('None');
            bCaptureKeyInput = true;
            return true;
        }
        else if (Key == TypeKey && Event == 0)
        {
            if (AutoCompleteIndices.Length > 0 && !bAutoCompleteLocked)
            {
                TypedStr = AutoCompleteList[AutoCompleteIndices[0]].Command;
                SetCursorPos(Len(TypedStr));
                bAutoCompleteLocked = true;
            }
            else
            {
                GotoState('None');
                bCaptureKeyInput = true;
            }
            return true;
        }
        else if (Key == 'Enter' && Event == 1)
        {
            if (TypedStr != "")
            {
                Temp = TypedStr;
                SetInputText("");
                SetCursorPos(0);
                if (Temp ~= "cls")
                {
                    ClearOutput();
                }
                else
                {
                    ConsoleCommand(Temp);
                }
                UpdateCompleteIndices();
            }
            return true;
        }
        else if (Global.InputKey(ControllerId, Key, Event, AmountDepressed, bGamepad))
        {
            return true;
        }
        else if (Event != 0 && Event != 2)
        {
            if (!bGamepad)
            {
                return Key != 'LeftMouseButton' && Key != 'MiddleMouseButton' && Key != 'RightMouseButton';
            }
            return false;
        }
        else if (Key == 'Up')
        {
            if (!bCtrl)
            {
                if (HistoryBot >= 0)
                {
                    if (HistoryCur == HistoryBot)
                    {
                        HistoryCur = HistoryTop;
                    }
                    else
                    {
                        HistoryCur--;
                        if (HistoryCur < 0)
                        {
                            HistoryCur = 16 - 1;
                        }
                    }
                    SetInputText(History[HistoryCur]);
                    SetCursorPos(Len(History[HistoryCur]));
                }
            }
            else if (SBPos < Scrollback.Length - 1)
            {
                SBPos++;
                if (SBPos >= Scrollback.Length)
                {
                    SBPos = Scrollback.Length - 1;
                }
            }
            return true;
        }
        else if (Key == 'Down')
        {
            if (!bCtrl)
            {
                if (HistoryBot >= 0)
                {
                    if (HistoryCur == HistoryTop)
                    {
                        HistoryCur = HistoryBot;
                    }
                    else
                    {
                        HistoryCur = (HistoryCur + 1) % 16;
                    }
                    SetInputText(History[HistoryCur]);
                    SetCursorPos(Len(History[HistoryCur]));
                }
            }
            else if (SBPos > 0)
            {
                SBPos--;
                if (SBPos < 0)
                {
                    SBPos = 0;
                }
            }
            return true;
        }
        else if (Key == 'BackSpace')
        {
            if (TypedStrPos > 0)
            {
                SetInputText(Left(TypedStr, TypedStrPos - 1) $ Right(TypedStr, Len(TypedStr) - TypedStrPos));
                SetCursorPos(TypedStrPos - 1);
                bAutoCompleteLocked = false;
            }
            return true;
        }
        else if (Key == 'Delete')
        {
            if (TypedStrPos < Len(TypedStr))
            {
                SetInputText(Left(TypedStr, TypedStrPos) $ Right(TypedStr, Len(TypedStr) - TypedStrPos - 1));
            }
            return true;
        }
        else if (Key == 'Left')
        {
            SetCursorPos(Max(0, TypedStrPos - 1));
            return true;
        }
        else if (Key == 'Right')
        {
            SetCursorPos(Min(Len(TypedStr), TypedStrPos + 1));
            return true;
        }
        else if (bCtrl && Key == 'Home')
        {
            SBPos = 0;
        }
        else if (Key == 'Home')
        {
            SetCursorPos(0);
            return true;
        }
        else if (bCtrl && Key == 'End')
        {
            SBPos = Scrollback.Length - 1;
        }
        else if (Key == 'End')
        {
            SetCursorPos(Len(TypedStr));
            return true;
        }
        else if (Key == 'PageUp' || Key == 'MouseScrollUp')
        {
            if (SBPos < Scrollback.Length - 1)
            {
                if (bCtrl)
                {
                    SBPos += 5;
                }
                else
                {
                    SBPos++;
                }
                if (SBPos >= Scrollback.Length)
                {
                    SBPos = Scrollback.Length - 1;
                }
            }
            return true;
        }
        else if (Key == 'PageDown' || Key == 'MouseScrollDown')
        {
            if (SBPos > 0)
            {
                if (bCtrl)
                {
                    SBPos -= 5;
                }
                else
                {
                    SBPos--;
                }
                if (SBPos < 0)
                {
                    SBPos = 0;
                }
            }
            return true;
        }
        return true;
    }
    
    function bool InputChar(int ControllerId, string Unicode)
    {
        if (bCaptureKeyInput)
        {
            return true;
        }
        AppendInputText(Unicode);
        return true;
    }
    
    Stop;
}

state Typing
{
    event EndState(name NextStateName)
    {
        if (MiniConsoleScene != none)
        {
            MiniConsoleScene.CloseScene();
        }
        bAutoCompleteLocked = false;
    }
    
    event BeginState(name PreviousStateName)
    {
        if (bEnableUI && MiniConsoleScene != none)
        {
            MiniConsoleScene.OpenScene(MiniConsoleScene, Outer.Outer.GameViewport.Outer.GamePlayers[0]);
        }
        else if (PreviousStateName == 'None')
        {
            FlushPlayerInput();
        }
        bCaptureKeyInput = true;
        HistoryCur = HistoryTop;
    }
    
    event PostRender_Console(Canvas Canvas)
    {
        local float Y, XL, YL, info_xl, info_yl, ClipX, ClipY, LeftPos;
        local string OutStr;
        local int MatchIdx, Idx, StartIdx;
        
        if (!IsUIMiniConsoleOpen())
        {
            Global.PostRender_Console(Canvas);
            Canvas.Font = class'Engine'.static.GetSmallFont();
            OutStr = "(>" @ TypedStr;
            Canvas.StrLen(OutStr, XL, YL);
            ClipX = Canvas.ClipX;
            ClipY = Canvas.ClipY;
            LeftPos = 0.0;
            if (class'WorldInfo'.static.IsConsoleBuild())
            {
                ClipX -= float(32);
                ClipY -= float(32);
                LeftPos = 32.0;
            }
            Canvas.SetPos(LeftPos, ClipY - float(6) - YL);
            Canvas.DrawTile(DefaultTexture_Black, ClipX, YL + float(6), 0.0, 0.0, 32.0, 32.0);
            Canvas.SetPos(LeftPos, ClipY - float(6) - YL);
            Canvas.SetDrawColor(0, 255, 0);
            Canvas.DrawTile(DefaultTexture_White, ClipX, 2.0, 0.0, 0.0, 32.0, 32.0);
            Canvas.SetPos(LeftPos, ClipY - float(3) - YL);
            Canvas.bCenter = false;
            Canvas.DrawText(OutStr, false);
            if (AutoCompleteIndices.Length > 0)
            {
                Idx = AutoCompleteIndices[AutoCompleteIndex];
                Canvas.SetPos(LeftPos + XL, ClipY - float(3) - YL);
                Canvas.SetDrawColor(87, 148, 87);
                Canvas.DrawText(Right(AutoCompleteList[Idx].Command, Len(AutoCompleteList[Idx].Command) - Len(TypedStr)), false);
                Canvas.StrLen("(>", XL, YL);
                StartIdx = AutoCompleteIndex - 5;
                if (StartIdx < 0)
                {
                    StartIdx = Max(0, AutoCompleteIndices.Length + StartIdx);
                }
                Idx = StartIdx;
                Y = ClipY - float(6) - YL * float(2);
                for (MatchIdx = 0; MatchIdx < 10; MatchIdx++)
                {
                    OutStr = AutoCompleteList[AutoCompleteIndices[Idx]].Desc;
                    Canvas.StrLen(OutStr, info_xl, info_yl);
                    Y -= info_yl - YL;
                    Canvas.SetPos(LeftPos + XL, Y);
                    Canvas.SetDrawColor(0, 0, 0);
                    Canvas.DrawTile(DefaultTexture_White, info_xl, info_yl, 0.0, 0.0, 32.0, 32.0);
                    Canvas.SetPos(LeftPos + XL, Y);
                    if (Idx == AutoCompleteIndex)
                    {
                        Canvas.SetDrawColor(0, 255, 0);
                    }
                    else
                    {
                        Canvas.SetDrawColor(0, 150, 0);
                    }
                    Canvas.DrawText(OutStr, false);
                    if (++Idx >= AutoCompleteIndices.Length)
                    {
                        Idx = 0;
                    }
                    Y -= YL;
                    if (Idx == StartIdx)
                    {
                        break;
                    }
                }
                if (AutoCompleteIndices.Length >= 10)
                {
                    OutStr = "[" $ string(AutoCompleteIndices.Length - 10 + 1) @ "more matches]";
                    Canvas.StrLen(OutStr, info_xl, info_yl);
                    Canvas.SetPos(LeftPos + XL, Y);
                    Canvas.SetDrawColor(0, 0, 0);
                    Canvas.DrawTile(DefaultTexture_White, info_xl, info_yl, 0.0, 0.0, 32.0, 32.0);
                    Canvas.SetPos(LeftPos + XL, Y);
                    Canvas.SetDrawColor(0, 255, 0);
                    Canvas.DrawText(OutStr, false);
                }
            }
            OutStr = "(>" @ Left(TypedStr, TypedStrPos);
            Canvas.StrLen(OutStr, XL, YL);
            Canvas.SetPos(LeftPos + XL, ClipY - float(1) - YL);
            Canvas.DrawText("_");
        }
    }
    
    function bool InputKey(int ControllerId, name Key, EInputEvent Event, optional float AmountDepressed = 1.0, optional bool bGamepad = false)
    {
        local string Temp;
        local int NewPos, SpacePos, PeriodPos;
        
        if (Event == 0)
        {
            bCaptureKeyInput = false;
        }
        if (ProcessControlKey(Key, Event))
        {
            return true;
        }
        else if (bGamepad)
        {
            return false;
        }
        else if (Key == 'Escape' && Event == 1)
        {
            if (TypedStr != "")
            {
                SetInputText("");
                SetCursorPos(0);
                HistoryCur = HistoryTop;
                return true;
            }
            else
            {
                GotoState('None');
            }
            return true;
        }
        else if (Key == ConsoleKey && Event == 0)
        {
            GotoState('Open');
            bCaptureKeyInput = true;
            return true;
        }
        else if (Key == TypeKey && Event == 0)
        {
            if (AutoCompleteIndices.Length > 0 && !bAutoCompleteLocked)
            {
                TypedStr = AutoCompleteList[AutoCompleteIndices[AutoCompleteIndex]].Command;
                SetCursorPos(Len(TypedStr));
                bAutoCompleteLocked = true;
            }
            else
            {
                GotoState('None');
                bCaptureKeyInput = true;
            }
            return true;
        }
        else if (Key == 'Enter' && Event == 1)
        {
            if (TypedStr != "")
            {
                Temp = TypedStr;
                SetInputText("");
                SetCursorPos(0);
                ConsoleCommand(Temp);
                OutputText("");
                GotoState('None');
                UpdateCompleteIndices();
            }
            else
            {
                GotoState('None');
            }
            return true;
        }
        else if (Global.InputKey(ControllerId, Key, Event, AmountDepressed, bGamepad))
        {
            return true;
        }
        else if (Event != 0 && Event != 2)
        {
            if (!bGamepad)
            {
                return Key != 'LeftMouseButton' && Key != 'MiddleMouseButton' && Key != 'RightMouseButton';
            }
            return false;
        }
        else if (Key == 'Up')
        {
            if (!bNavigatingHistory && bRequireCtrlToNavigateAutoComplete && bCtrl || !bRequireCtrlToNavigateAutoComplete && !bCtrl && AutoCompleteIndices.Length > 1)
            {
                if (++AutoCompleteIndex == AutoCompleteIndices.Length)
                {
                    AutoCompleteIndex = 0;
                }
            }
            else if (HistoryBot >= 0)
            {
                if (HistoryCur == HistoryBot)
                {
                    HistoryCur = HistoryTop;
                }
                else
                {
                    HistoryCur--;
                    if (HistoryCur < 0)
                    {
                        HistoryCur = 16 - 1;
                    }
                }
                SetInputText(History[HistoryCur]);
                SetCursorPos(Len(History[HistoryCur]));
                UpdateCompleteIndices();
                bNavigatingHistory = true;
            }
            return true;
        }
        else if (Key == 'Down')
        {
            if (!bNavigatingHistory && bRequireCtrlToNavigateAutoComplete && bCtrl || !bRequireCtrlToNavigateAutoComplete && !bCtrl && AutoCompleteIndices.Length > 1)
            {
                if (--AutoCompleteIndex < 0)
                {
                    AutoCompleteIndex = AutoCompleteIndices.Length - 1;
                }
                bAutoCompleteLocked = false;
            }
            else if (HistoryBot >= 0)
            {
                if (HistoryCur == HistoryTop)
                {
                    HistoryCur = HistoryBot;
                }
                else
                {
                    HistoryCur = (HistoryCur + 1) % 16;
                }
                SetInputText(History[HistoryCur]);
                SetCursorPos(Len(History[HistoryCur]));
                UpdateCompleteIndices();
                bNavigatingHistory = true;
            }
        }
        else if (Key == 'BackSpace')
        {
            if (TypedStrPos > 0)
            {
                SetInputText(Left(TypedStr, TypedStrPos - 1) $ Right(TypedStr, Len(TypedStr) - TypedStrPos));
                SetCursorPos(TypedStrPos - 1);
                bAutoCompleteLocked = false;
            }
            return true;
        }
        else if (Key == 'Delete')
        {
            if (TypedStrPos < Len(TypedStr))
            {
                SetInputText(Left(TypedStr, TypedStrPos) $ Right(TypedStr, Len(TypedStr) - TypedStrPos - 1));
            }
            return true;
        }
        else if (Key == 'Left')
        {
            if (bCtrl)
            {
                NewPos = Max(InStr(TypedStr, ".", true, false, TypedStrPos), InStr(TypedStr, " ", true, false, TypedStrPos));
                SetCursorPos(Max(0, NewPos));
            }
            else
            {
                SetCursorPos(Max(0, TypedStrPos - 1));
            }
            return true;
        }
        else if (Key == 'Right')
        {
            if (bCtrl)
            {
                SpacePos = InStr(TypedStr, " ", false, false, TypedStrPos + 1);
                PeriodPos = InStr(TypedStr, ".", false, false, TypedStrPos + 1);
                NewPos = (SpacePos < 0 ? PeriodPos : PeriodPos < 0 ? SpacePos : Min(SpacePos, PeriodPos));
                if (NewPos == -1)
                {
                    NewPos = Len(TypedStr);
                }
                SetCursorPos(Min(Len(TypedStr), Max(TypedStrPos, NewPos)));
            }
            else
            {
                SetCursorPos(Min(Len(TypedStr), TypedStrPos + 1));
            }
            return true;
        }
        else if (Key == 'Home')
        {
            SetCursorPos(0);
            return true;
        }
        else if (Key == 'End')
        {
            SetCursorPos(Len(TypedStr));
            return true;
        }
        return true;
    }
    
    function bool InputChar(int ControllerId, string Unicode)
    {
        if (IsUIMiniConsoleOpen())
        {
            return false;
        }
        if (bCaptureKeyInput)
        {
            return true;
        }
        AppendInputText(Unicode);
        return true;
    }
    
    Stop;
}

defaultproperties
{
    DefaultTexture_Black="EngineResources.Black"
    DefaultTexture_White="EngineResources.WhiteSquareTexture"
    ConsoleKey="Tilde"
    TypeKey="Tab"
    MaxScrollbackSize=1024
    HistoryBot=-1
    ManualAutoCompleteList(0)=(Command="Exit",Desc="Exit (Exits the game)")
    ManualAutoCompleteList(1)=(Command="Open",Desc="Open <MapName> (Opens the specified map)")
    ManualAutoCompleteList(2)=(Command="DisplayAll",Desc="DisplayAll <ClassName> <PropertyName> (Display property values for instances of classname)")
    ManualAutoCompleteList(3)=(Command="DisplayAllState",Desc="DisplayAllState <ClassName> (Display state names for all instances of classname)")
    ManualAutoCompleteList(4)=(Command="DisplayClear",Desc="DisplayClear (Clears previous DisplayAll entries)")
    ManualAutoCompleteList(5)=(Command="FlushPersistentDebugLines",Desc="FlushPersistentDebugLines (Clears persistent debug line cache)")
    ManualAutoCompleteList(6)=(Command="GetAll ",Desc="GetAll <ClassName> <PropertyName> <Name=ObjectInstanceName> <OUTER=ObjectInstanceName> <SHOWDEFAULTS> <SHOWPENDINGKILLS> <DETAILED> (Log property values of all instances of classname)")
    ManualAutoCompleteList(7)=(Command="GetAllState",Desc="GetAllState <ClassName> (Log state names for all instances of classname)")
    ManualAutoCompleteList(8)=(Command="Obj List ",Desc="Obj List <Class=ClassName> <Type=MetaClass> <Outer=OuterObject> <Package=InsidePackage> <Inside=InsideObject>")
    ManualAutoCompleteList(9)=(Command="Obj ListContentRefs",Desc="Obj ListContentRefs <Class=ClassName> <ListClass=ClassName>")
    ManualAutoCompleteList(10)=(Command="Obj Classes",Desc="Obj Classes (Shows all classes)")
    ManualAutoCompleteList(11)=(Command="Obj Refs",Desc="Name=<ObjectName> Class=<OptionalObjectClass> Lists referencers of the specified object")
    ManualAutoCompleteList(12)=(Command="EditActor",Desc="EditActor <Class=ClassName> or <Name=ObjectName> or TRACE")
    ManualAutoCompleteList(13)=(Command="EditDefault",Desc="EditDefault <Class=ClassName>")
    ManualAutoCompleteList(14)=(Command="EditObject",Desc="EditObject <Class=ClassName> or <Name=ObjectName> or <ObjectName>")
    ManualAutoCompleteList(15)=(Command="ReloadCfg ",Desc="ReloadCfg <Class/ObjectName> (Reloads config variables for the specified object/class)")
    ManualAutoCompleteList(16)=(Command="ReloadLoc ",Desc="ReloadLoc <Class/ObjectName> (Reloads localized variables for the specified object/class)")
    ManualAutoCompleteList(17)=(Command="Set ",Desc="Set <ClassName> <PropertyName> <Value> (Sets property to value on objectname)")
    ManualAutoCompleteList(18)=(Command="Show BOUNDS",Desc="Show BOUNDS (Displays bounding boxes for all visible objects)")
    ManualAutoCompleteList(19)=(Command="Show BSP",Desc="Show BSP (Toggles BSP rendering)")
    ManualAutoCompleteList(20)=(Command="Show COLLISION",Desc="Show COLLISION (Toggles collision rendering)")
    ManualAutoCompleteList(21)=(Command="Show COVER",Desc="Show COVER (Toggles cover rendering)")
    ManualAutoCompleteList(22)=(Command="Show DECALS",Desc="Show DECALS (Toggles decal rendering)")
    ManualAutoCompleteList(23)=(Command="Show FOG",Desc="Show FOG (Toggles fog rendering)")
    ManualAutoCompleteList(24)=(Command="Show LEVELCOLORATION",Desc="Show LEVELCOLORATION (Toggles per-level coloration)")
    ManualAutoCompleteList(25)=(Command="Show PATHS",Desc="Show PATHS (Toggles path rendering)")
    ManualAutoCompleteList(26)=(Command="Show POSTPROCESS",Desc="Show POSTPROCESS (Toggles post process rendering)")
    ManualAutoCompleteList(27)=(Command="Show SKELMESHES",Desc="Show SKELMESHES (Toggles skeletal mesh rendering)")
    ManualAutoCompleteList(28)=(Command="Show TERRAIN",Desc="Show TERRAIN (Toggles terrain rendering)")
    ManualAutoCompleteList(29)=(Command="Show VOLUMES",Desc="Show VOLUMES (Toggles volume rendering)")
    ManualAutoCompleteList(30)=(Command="Show SPLINES",Desc="Show SPLINES (Toggles spline rendering)")
    ManualAutoCompleteList(31)=(Command="Stat FPS",Desc="Stat FPS (Shows FPS counter)")
    ManualAutoCompleteList(32)=(Command="Stat UNIT",Desc="Stat UNIT (Shows hardware unit framerate)")
    ManualAutoCompleteList(33)=(Command="Stat LEVELS",Desc="Stat LEVELS (Displays level streaming info)")
    ManualAutoCompleteList(34)=(Command="Stat GAME",Desc="Stat GAME (Displays game performance stats)")
    ManualAutoCompleteList(35)=(Command="Stat MEMORY",Desc="Stat MEMORY (Displays memory stats)")
    ManualAutoCompleteList(36)=(Command="Stat XBOXMEMORY",Desc="Stat XBOXMEMORY (Displays Xbox memory stats while playing on PC)")
    ManualAutoCompleteList(37)=(Command="Stat PHYSICS",Desc="Stat PHYSICS (Displays physics performance stats)")
    ManualAutoCompleteList(38)=(Command="Stat STREAMING",Desc="Stat STREAMING")
    ManualAutoCompleteList(39)=(Command="Stat COLLISION",Desc="Stat COLLISION")
    ManualAutoCompleteList(40)=(Command="Stat PARTICLES",Desc="Stat PARTICLES")
    ManualAutoCompleteList(41)=(Command="Stat SCRIPT",Desc="Stat SCRIPT")
    ManualAutoCompleteList(42)=(Command="Stat AUDIO",Desc="Stat AUDIO")
    ManualAutoCompleteList(43)=(Command="Stat ANIM",Desc="Stat ANIM")
    ManualAutoCompleteList(44)=(Command="Stat NET",Desc="Stat NET")
    ManualAutoCompleteList(45)=(Command="Stat LIST",Desc="Stat LIST Groups/Sets/Group (List groups of stats, saved sets, or specific stats within a specified group)")
    ManualAutoCompleteList(46)=(Command="ListTextures",Desc="ListTextures (Lists all loaded textures and their current memory footprint)")
    ManualAutoCompleteList(47)=(Command="RestartLevel",Desc="RestartLevel (restarts the level)")
    ManualAutoCompleteList(48)=(Command="LogPhysMatInfo",Desc="LogPhysMatInfo (Log PhysMat Info)")
    ManualAutoCompleteList(49)=(Command="ListSounds",Desc="ListSounds (Lists all the loaded sounds and their memory footprint)")
    ManualAutoCompleteList(50)=(Command="ListWaves",Desc="ListWaves (List the WaveInstances and whether they have a source)")
    ManualAutoCompleteList(51)=(Command="ListSoundClasses",Desc="ListSoundClasses (Lists a summary of loaded sound collated by class)")
    ManualAutoCompleteList(52)=(Command="ListSoundModes",Desc="ListSoundModes (Lists loaded sound modes)")
    ManualAutoCompleteList(53)=(Command="ListAudioComponents",Desc="ListAudioComponents (Dumps a detailed list of all AudioComponent objects)")
    ManualAutoCompleteList(54)=(Command="ListSoundDurations",Desc="ListSoundDurations")
    ManualAutoCompleteList(55)=(Command="PlaySoundCue",Desc="PlaySoundCue (Lists a summary of loaded sound collated by class)")
    ManualAutoCompleteList(56)=(Command="PlaySoundWave",Desc="PlaySoundWave")
    ManualAutoCompleteList(57)=(Command="SetSoundMode",Desc="SetSoundMode <ModeName>")
    ManualAutoCompleteList(58)=(Command="DisableLowPassFilter",Desc="DisableLowPassFilter")
    ManualAutoCompleteList(59)=(Command="DisableEQFilter",Desc="DisableEQFilter")
    ManualAutoCompleteList(60)=(Command="IsolateDryAudio",Desc="IsolateDryAudio")
    ManualAutoCompleteList(61)=(Command="IsolateReverb",Desc="IsolateReverb")
    ManualAutoCompleteList(62)=(Command="ResetSoundState",Desc="ResetSoundState (Resets volumes to default and removes test filters)")
    ManualAutoCompleteList(63)=(Command="ModifySoundClass",Desc="ModifySoundClass <SoundClassName> Vol=<new volume>")
    ManualAutoCompleteList(64)=(Command="DisableAllScreenMessages",Desc="Disables all on-screen warnings/messages")
    ManualAutoCompleteList(65)=(Command="EnableAllScreenMessages",Desc="Enables all on-screen warnings/messages")
    ManualAutoCompleteList(66)=(Command="ToggleAllScreenMessages",Desc="Toggles display state of all on-screen warnings/messages")
    ManualAutoCompleteList(67)=(Command="CaptureMode",Desc="Toggles display state of all on-screen warnings/messages")
    ManualAutoCompleteList(68)=(Command="KyDrawDebug NAME",Desc="Displays Kynapse entities name")
    ManualAutoCompleteList(69)=(Command="KyDrawDebug AGENT",Desc="Displays Kynapse entities current agent name")
    ManualAutoCompleteList(70)=(Command="KyDrawDebug NONE",Desc="Turns off Kynapse debug information display")
    ManualAutoCompleteList(71)=(Command="KyDrawPathData",Desc="Toggles Kynapse PathData rendering")
    ManualAutoCompleteList(72)=(Command="KyDrawEntity",Desc="Toggles Kynapse Entity rendering")
    ManualAutoCompleteList(73)=(Command="KyDrawPath",Desc="Toggles Kynapse Path rendering")
    ManualAutoCompleteList(74)=(Command="KyDrawTargetPoint",Desc="Toggles Kynapse pathfinder current Target Point rendering")
    ManualAutoCompleteList(75)=(Command="KyDrawDA",Desc="Toggles Kynapse Dynamic Avoidance rendering")
    ManualAutoCompleteList(76)=(Command="KyDrawLayers",Desc="Toggles Kynapse AiMesh layer rendering")
    ManualAutoCompleteList(77)=(Command="KyDrawDebug PRIORITY",Desc="Displays Kynapse entity priority")
    ManualAutoCompleteList(78)=(Command="KyDrawDebug PFSTATUS",Desc="Displays Kynapse entities pathfinder status")
    __OnReceivedNativeInputKey__Delegate="None"
    __OnReceivedNativeInputChar__Delegate="None"
}

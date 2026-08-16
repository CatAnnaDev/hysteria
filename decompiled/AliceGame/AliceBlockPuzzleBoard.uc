class AliceBlockPuzzleBoard extends InterpActor
    placeable
    hidecategories(Navigation);

enum ECorner
{
    EC_LB,
    EC_LT,
    EC_RB,
    EC_RT,
};

struct native PieceLoc
{
    var() int I;
    var() int J;
};

var int PieceNum;
var int GridNum;
var array<AliceBlockPiece> Pieces;
var() int InitLayOut[10];
var() int TargetLayOut[10];
var() int MaxStep;
var int UsedStep;
var AliceBlockPiece CurLayOut[10];
var MaterialInstanceConstant MatINT;
var MaterialInstanceConstant MatDEU;
var MaterialInstanceConstant MatFRA;
var MaterialInstanceConstant MatESN;
var MaterialInstanceConstant MatITA;
var MaterialInstanceConstant MatJPN;
var MaterialInstanceConstant BaseMatINT;
var MaterialInstanceConstant BaseMatDEU;
var MaterialInstanceConstant BaseMatFRA;
var MaterialInstanceConstant BaseMatESN;
var MaterialInstanceConstant BaseMatITA;
var MaterialInstanceConstant BaseMatJPN;
var() StaticMeshActor realBaseMeshActor;
var AlicePlayerController APC;
var bool bGameStarted;
var bool bIsBlockMoving;
var bool bShouldShowCollectUI;
var bool bCollectUIShowed;
var() bool bNeedLocalize;
var int SelectedCursor;
var float CommandDelay;
var float LastCommandTime;
var float PieceMoveSpeed;
var int CollectedNum;
var AliceBlockPiece CollectPiece;
var() float ZDrawScale;
var Emitter selectedEmitter;
var ParticleSystem selectedPS;
var SoundCue pickpuSoundCue;
var SoundCue slideSoundCue;
var SoundCue completeSoundCue;

function MaterialInstanceConstant getPieceLocMat()
{
    local MaterialInstanceConstant locMat;
    local string sLang;
    
    sLang = GetLanguage();
    if (sLang == "INT")
    {
        locMat = MatINT;
    }
    else if (sLang == "DEU")
    {
        locMat = MatDEU;
    }
    else if (sLang == "FRA")
    {
        locMat = MatFRA;
    }
    else if (sLang == "ESN")
    {
        locMat = MatESN;
    }
    else if (sLang == "ITA")
    {
        locMat = MatITA;
    }
    else if (sLang == "JPN")
    {
        locMat = MatJPN;
    }
    return locMat;
}

function setBaseLocMat()
{
    local MaterialInstanceConstant locMat;
    local string sLang;
    
    if (realBaseMeshActor == none || !bNeedLocalize)
    {
        return;
    }
    sLang = GetLanguage();
    if (sLang == "INT")
    {
        locMat = BaseMatINT;
    }
    else if (sLang == "DEU")
    {
        locMat = BaseMatDEU;
    }
    else if (sLang == "FRA")
    {
        locMat = BaseMatFRA;
    }
    else if (sLang == "ESN")
    {
        locMat = BaseMatESN;
    }
    else if (sLang == "ITA")
    {
        locMat = BaseMatITA;
    }
    else if (sLang == "JPN")
    {
        locMat = BaseMatJPN;
    }
    realBaseMeshActor.StaticMeshComponent.SetMaterial(1, locMat);
}

function MakeBlockThin()
{
    local int I;
    local Vector NewScale;
    
    NewScale = DrawScale3D;
    NewScale.Z = ZDrawScale;
    for (I = 1; I < Pieces.Length; I++)
    {
        Pieces[I].SetDrawScale3D(NewScale);
    }
    for (I = 1; I < Pieces.Length; I++)
    {
        if (I == 1)
        {
            Pieces[I].SetLocation(GetGridLoc(Pieces[I].CurLoc));
        }
        Pieces[I].SetLocation(GetGridLoc(Pieces[I].CurLoc));
    }
}

function BlockPuzzleFail()
{
    TriggerEventClass(class'SeqEvent_BlockPuzzleFail', self);
}

function BlockPuzzleComplete()
{
    PlaySound(completeSoundCue);
    TriggerEventClass(class'SeqEvent_BlockPuzzleComplete', self);
    EndGame();
}

function bool CheckPuzzleComplete()
{
    local int I;
    
    for (I = 1; I <= 9; I++)
    {
        if (CurLayOut[I].Id != TargetLayOut[I])
        {
            return false;
        }
    }
    return true;
}

function Vector GetCornerRawLoc(ECorner corner)
{
    local Vector vResult;
    local float fLength;
    
    fLength = GetLength();
    vResult = GetCenterLoc();
    RotateYaw(vResult, float(-Rotation.Yaw), Location);
    switch (corner)
    {
        case 0:
            vResult.X += -0.5 * fLength;
            vResult.Y += -0.5 * fLength;
            break;
        case 1:
            vResult.X += -0.5 * fLength;
            vResult.Y += 0.5 * fLength;
            break;
        case 2:
            vResult.X += 0.5 * fLength;
            vResult.Y += -0.5 * fLength;
            break;
        case 3:
            vResult.X += 0.5 * fLength;
            vResult.Y += 0.5 * fLength;
            break;
        default:
    }
    return vResult;
}

function RotateYaw(out Vector vResult, float fYaw, Vector vCenter)
{
    local Vector vSaved;
    local float Angle;
    
    vSaved = vResult;
    Angle = fYaw / 32768.0 * 3.1415927;
    vResult.X = (vSaved.X - vCenter.X) * Cos(Angle) - (vSaved.Y - vCenter.Y) * Sin(Angle) + vCenter.X;
    vResult.Y = (vSaved.Y - vCenter.Y) * Cos(Angle) + (vSaved.X - vCenter.X) * Sin(Angle) + vCenter.Y;
}

function Vector GetGridLoc(int Index)
{
    local Vector vResult;
    local float XStart, YStart, fGridLength;
    local int I, J;
    
    J = GridNum - 1 - (Index - 1) % GridNum;
    I = GridNum - 1 - (Index - 1) / GridNum;
    fGridLength = GetLength() / float(GridNum);
    XStart = GetCornerRawLoc(0).X + 0.5 * fGridLength;
    YStart = GetCornerRawLoc(0).Y + 0.5 * fGridLength;
    vResult.X = XStart + float(J) * fGridLength;
    vResult.Y = YStart + float(I) * fGridLength;
    vResult.Z = GetCenterLoc().Z + GetBlockZOffset();
    RotateYaw(vResult, float(Rotation.Yaw), Location);
    return vResult;
}

function float GetBlockZOffset()
{
    if (Pieces[1] != none)
    {
        return Pieces[1].StaticMeshComponent.Bounds.BoxExtent.Z;
    }
    return 0.0;
}

function Vector GetCenterLoc()
{
    local Vector vCenter;
    
    vCenter = StaticMeshComponent.Bounds.Origin;
    vCenter.Z += StaticMeshComponent.Bounds.BoxExtent.Z;
    return vCenter;
}

function float GetLength()
{
    return 1.414 * VSize2D(GetCenterLoc() - Location);
}

function EndGame()
{
    bGameStarted = false;
    if (selectedEmitter != none)
    {
        selectedEmitter.SetHidden(true);
        selectedEmitter.ParticleSystemComponent.DeactivateSystem();
    }
    APC.showBlockPuzzleUI(false);
}

function StartGame()
{
    bGameStarted = true;
    SetDefaultCursor();
    if (selectedEmitter != none)
    {
        selectedEmitter.SetHidden(false);
        selectedEmitter.ParticleSystemComponent.ActivateSystem();
    }
    APC.showBlockPuzzleUI(true);
    APC.showBlockPuzzleLeftStep(MaxStep);
}

function bool CanMove()
{
    local int EmptyLoc;
    
    EmptyLoc = GetEmptyBlockLoc();
    if (SelectedCursor + 1 == EmptyLoc && SelectedCursor % 3 != 0 || SelectedCursor - 1 == EmptyLoc && SelectedCursor % 3 != 1 || SelectedCursor + 3 == EmptyLoc || SelectedCursor - 3 == EmptyLoc)
    {
        return true;
    }
    return false;
}

function MoveBlockPiece()
{
    if (!CanMove())
    {
        return;
    }
    CurLayOut[SelectedCursor].TriggerMovingEffect();
    CurLayOut[SelectedCursor].PlaySound(slideSoundCue);
    bIsBlockMoving = true;
}

function PostMove()
{
    bIsBlockMoving = false;
    UsedStep++;
    APC.showBlockPuzzleLeftStep(MaxStep - UsedStep);
    CurLayOut[SelectedCursor].StopMovingEffect();
    if (UsedStep <= MaxStep)
    {
        if (CheckPuzzleComplete())
        {
            BlockPuzzleComplete();
        }
        else if (UsedStep == MaxStep)
        {
            BlockPuzzleFail();
        }
    }
    else
    {
        BlockPuzzleFail();
    }
}

function TickMoving(float DeltaTime)
{
    local int TargetLoc;
    local Vector vEndLoc, vStartLoc, vCurWorldLoc, VDir;
    
    TargetLoc = GetEmptyBlockLoc();
    vEndLoc = GetGridLoc(TargetLoc);
    vStartLoc = GetGridLoc(SelectedCursor);
    VDir = Normal(vEndLoc - vStartLoc);
    vCurWorldLoc = CurLayOut[SelectedCursor].Location;
    vCurWorldLoc += VDir * PieceMoveSpeed * DeltaTime;
    if ((vEndLoc - vCurWorldLoc) Dot VDir < float(0))
    {
        CurLayOut[TargetLoc] = CurLayOut[SelectedCursor];
        CurLayOut[SelectedCursor] = none;
        SelectedCursor = TargetLoc;
        CurLayOut[SelectedCursor].CurLoc = SelectedCursor;
        CurLayOut[SelectedCursor].SetLocation(vEndLoc);
        PostMove();
    }
    else
    {
        CurLayOut[SelectedCursor].SetLocation(vCurWorldLoc);
    }
}

function bool IsMoving()
{
    return bIsBlockMoving;
}

function HandleCommand(EChessMoveCommand Command, float DeltaTime)
{
    if (IsMoving() || IsInDelay())
    {
        return;
    }
    LastCommandTime = WorldInfo.TimeSeconds;
    switch (Command)
    {
        case 0:
            SelectedCursor += -1;
            if (SelectedCursor % 3 == 0)
            {
                SelectedCursor += 3;
            }
            if (CurLayOut[SelectedCursor] == none)
            {
                SelectedCursor += -1;
                if (SelectedCursor % 3 == 0)
                {
                    SelectedCursor += 3;
                }
            }
            break;
        case 1:
            SelectedCursor += 1;
            if (SelectedCursor % 3 == 1)
            {
                SelectedCursor += -3;
            }
            if (CurLayOut[SelectedCursor] == none)
            {
                SelectedCursor += 1;
                if (SelectedCursor % 3 == 1)
                {
                    SelectedCursor += -3;
                }
            }
            break;
        case 2:
            SelectedCursor += -3;
            if (SelectedCursor <= 0)
            {
                SelectedCursor += 9;
            }
            if (CurLayOut[SelectedCursor] == none)
            {
                SelectedCursor += -3;
                if (SelectedCursor <= 0)
                {
                    SelectedCursor += 9;
                }
            }
            break;
        case 3:
            SelectedCursor += 3;
            if (SelectedCursor >= 10)
            {
                SelectedCursor += -9;
            }
            if (CurLayOut[SelectedCursor] == none)
            {
                SelectedCursor += 3;
                if (SelectedCursor >= 10)
                {
                    SelectedCursor += -9;
                }
            }
            break;
        default:
    }
}

function bool IsInDelay()
{
    if (WorldInfo.TimeSeconds - LastCommandTime > CommandDelay)
    {
        return false;
    }
    return true;
}

function ShowGrid()
{
    local int I;
    
    DrawDebugLine(Location, Location + vect(0.0, 0.0, 1000.0), 255, 0, 0);
    for (I = 1; I <= GridNum * GridNum; I++)
    {
        DrawDebugLine(GetGridLoc(I), GetGridLoc(I) + float(I * 60 + 100) * vect(0.0, 0.0, 1.0), 0, 255, 0);
    }
    DrawDebugBox(GetCenterLoc(), StaticMeshComponent.Bounds.BoxExtent, 0, 0, 255);
}

function AssemblePiece(AliceBlockPiece Piece)
{
    local int J;
    
    for (J = 1; J < GridNum * GridNum + 1; J++)
    {
        if (InitLayOut[J] == Piece.Id)
        {
            Piece.SetLocation(GetGridLoc(J));
            Piece.SetRotation(Rotation);
            Piece.SetBase(self);
            Piece.CurLoc = J;
            CurLayOut[J] = Piece;
            CollectedNum++;
            Piece.bIsLocated = true;
            Piece.OnCanBeCollect(false);
            Piece.ResetFade();
            break;
        }
    }
}

function OnAssembleBlock()
{
    if (IsReadyToPlay())
    {
        TriggerEventClass(class'SeqEvent_AllBlockFound', self);
        APC.ShowBlockCollectUI(-1, AliceGameInfo(WorldInfo.Game).GetLocalizeString("Pickup_BlockPiece"));
        bCollectUIShowed = false;
    }
}

function OnSkipBlockPuzzle()
{
    local int I, J;
    
    for (J = 1; J < GridNum * GridNum + 1; J++)
    {
        for (I = 1; I < Pieces.Length; I++)
        {
            if (TargetLayOut[J] == Pieces[I].Id)
            {
                Pieces[I].SetLocation(GetGridLoc(J));
                Pieces[I].SetRotation(Rotation);
                break;
            }
        }
    }
    EndGame();
}

function CollectBlockPiece()
{
    if (CollectPiece != none)
    {
        CollectPiece.startFadeOut();
        CollectPiece.bAfterPress = true;
        CollectPiece.PlaySound(pickpuSoundCue);
    }
}

function CollectAllPieces()
{
    local int I;
    
    for (I = 1; I < Pieces.Length; I++)
    {
        if (!Pieces[I].bIsReady)
        {
            AssemblePiece(Pieces[I]);
        }
    }
    OnAssembleBlock();
}

function TickCollect()
{
    local int I;
    
    if (APC == none)
    {
        return;
    }
    bShouldShowCollectUI = false;
    CollectPiece = none;
    for (I = 1; I < Pieces.Length; I++)
    {
        Pieces[I].OnCanBeCollect(false);
        if (!Pieces[I].bIsReady)
        {
            if (APC.CanCollectBlockPiece(Pieces[I]))
            {
                CollectPiece = Pieces[I];
                CollectPiece.OnCanBeCollect(true);
                if (Pieces[I].CanShowUI())
                {
                    bShouldShowCollectUI = true;
                }
            }
        }
    }
    if (bShouldShowCollectUI && !bCollectUIShowed)
    {
        APC.ShowBlockCollectUI(0, AliceGameInfo(WorldInfo.Game).GetLocalizeString("Pickup_BlockPiece"));
        bCollectUIShowed = true;
    }
    else if (!bShouldShowCollectUI && bCollectUIShowed)
    {
        APC.ShowBlockCollectUI(-1, AliceGameInfo(WorldInfo.Game).GetLocalizeString("Pickup_BlockPiece"));
        bCollectUIShowed = false;
    }
}

simulated function Tick(float DeltaTime)
{
    if (!bGameStarted)
    {
        TickCollect();
        return;
    }
    if (IsMoving())
    {
        TickMoving(DeltaTime);
    }
    ShowSelectedCursor();
}

function InitAssamble(bool bAll)
{
    local int I, J;
    
    CollectedNum = 0;
    for (J = 1; J < 10; J++)
    {
        CurLayOut[J] = none;
    }
    for (I = 1; I < Pieces.Length; I++)
    {
        Pieces[I].CurLoc = -1;
        if (Pieces[I].bNeedCollect && !Pieces[I].bIsReady)
        {
            Pieces[I].bIsReady = false;
            Pieces[I].bIsLocated = false;
        }
        else
        {
            Pieces[I].bIsReady = true;
            Pieces[I].bIsLocated = false;
        }
        Pieces[I].Init(self);
    }
    for (J = 1; J < GridNum * GridNum + 1; J++)
    {
        for (I = 1; I < Pieces.Length; I++)
        {
            if (InitLayOut[J] == Pieces[I].Id)
            {
                if (Pieces[I].bIsReady && !Pieces[I].bIsLocated || bAll)
                {
                    Pieces[I].startFadeOut();
                    Pieces[I].PlaySound(pickpuSoundCue);
                    break;
                }
            }
        }
    }
    UsedStep = 0;
    if (selectedEmitter == none)
    {
        selectedEmitter = Spawn(class'Engine.EmitterSpawnable', self, , Location);
        if (selectedEmitter != none && selectedPS != none)
        {
            selectedEmitter.SetTemplate(selectedPS, false);
            selectedEmitter.ParticleSystemComponent.DeactivateSystem();
            selectedEmitter.SetHidden(true);
        }
    }
    APC.showBlockPuzzleLeftStep(MaxStep);
    bIsBlockMoving = false;
    SetDefaultCursor();
}

function int GetEmptyBlockLoc()
{
    local int I;
    
    for (I = 1; I < 10; I++)
    {
        if (CurLayOut[I] == none)
        {
            return I;
        }
    }
    return -1;
}

function ShowBoxCursor()
{
    local Vector vExtent, CursorLoc;
    
    vExtent.X = GetLength() / float(GridNum) / 3.0;
    vExtent.Y = vExtent.X;
    vExtent.Z = vExtent.X * 3.0;
    CursorLoc = CurLayOut[SelectedCursor].Location;
    DrawDebugBox(CursorLoc, vExtent, 0, 255, 0);
}

function ShowSelectedCursor()
{
    local Vector CursorLoc;
    
    if (selectedEmitter != none)
    {
        CursorLoc = CurLayOut[SelectedCursor].StaticMeshComponent.Bounds.Origin;
        CursorLoc.Z += CurLayOut[SelectedCursor].StaticMeshComponent.Bounds.BoxExtent.Z;
        selectedEmitter.SetLocation(CursorLoc);
    }
}

function SetDefaultCursor()
{
    local int EmptyLoc;
    
    EmptyLoc = GetEmptyBlockLoc();
    if (EmptyLoc < 0)
    {
        LogInternal("===GetEmptyBlockLoc Error===");
        return;
    }
    if (EmptyLoc <= 3)
    {
        SelectedCursor = EmptyLoc + 3;
    }
    else
    {
        SelectedCursor = EmptyLoc - 3;
    }
}

function bool IsReadyToPlay()
{
    return CollectedNum == 8;
}

simulated event PostBeginPlay()
{
    setBaseLocMat();
}

defaultproperties
{
    PieceNum=8
    GridNum=3
    InitLayOut=-1
    InitLayOut[1]=1
    InitLayOut[2]=2
    InitLayOut[3]=3
    InitLayOut[4]=4
    InitLayOut[5]=5
    InitLayOut[6]=6
    InitLayOut[7]=7
    InitLayOut[8]=8
    TargetLayOut=-1
    TargetLayOut[1]=1
    TargetLayOut[2]=2
    TargetLayOut[3]=3
    TargetLayOut[4]=4
    TargetLayOut[5]=5
    TargetLayOut[6]=6
    TargetLayOut[7]=7
    TargetLayOut[8]=8
    MaxStep=99
    MatINT="EmoWater.Localization2.EmoWaterBlocks_LocINT_XEX_Mat_INST"
    MatDEU="EmoWater.Localization2.EmoWaterBlocks_LocDEU_XEX_Mat_INST"
    MatFRA="EmoWater.Localization2.EmoWaterBlocks_LocFRA_XEX_Mat_INST"
    MatESN="EmoWater.Localization2.EmoWaterBlocks_LocESN_XEX_Mat_INST"
    MatITA="EmoWater.Localization2.EmoWaterBlocks_LocITA_XEX_Mat_INST"
    MatJPN="EmoWater.Localization2.EmoWaterBlocks_LocJPN_XEX_Mat_INST"
    BaseMatINT="EmoWater.Localization2.EmoWaterBase_LocINT_XXX_Mat_INST"
    BaseMatDEU="EmoWater.Localization2.EmoWaterBase_LocDEU_XXX_Mat_INST"
    BaseMatFRA="EmoWater.Localization2.EmoWaterBase_LocFRA_XXX_Mat_INST"
    BaseMatESN="EmoWater.Localization2.EmoWaterBase_LocESN_XXX_Mat_INST"
    BaseMatITA="EmoWater.Localization2.EmoWaterBase_LocITA_XXX_Mat_INST"
    BaseMatJPN="EmoWater.Localization2.EmoWaterBase_LocJPN_XXX_Mat_INST"
    CommandDelay=0.3
    PieceMoveSpeed=500.0
    ZDrawScale=0.3
    selectedPS="EmoWater.InhabitSelected_P"
    pickpuSoundCue="SFX_Puzzle.sfx_puzzle_block_pickup_Cue"
    slideSoundCue="SFX_Puzzle.sfx_puzzle_slide01_Cue"
    completeSoundCue="SFX_Puzzle.sfx_puzzle_complete_Cue"
    StaticMeshComponent="Default__AliceBlockPuzzleBoard.StaticMeshComponent0"
    LightEnvironment="Default__AliceBlockPuzzleBoard.MyLightEnvironment"
    Components(0)="Default__AliceBlockPuzzleBoard.MyLightEnvironment"
    Components(1)="Default__AliceBlockPuzzleBoard.StaticMeshComponent0"
    CollisionComponent="Default__AliceBlockPuzzleBoard.StaticMeshComponent0"
    SupportedEvents(0)="Engine.SeqEvent_Touch"
    SupportedEvents(1)="Engine.SeqEvent_Destroyed"
    SupportedEvents(2)="Engine.SeqEvent_TakeDamage"
    SupportedEvents(3)="Engine.SeqEvent_HitWall"
    SupportedEvents(4)="Engine.SeqEvent_Mover"
    SupportedEvents(5)="SeqEvent_BlockPuzzleComplete"
    SupportedEvents(6)="SeqEvent_BlockPuzzleFail"
    SupportedEvents(7)="SeqEvent_AllBlockFound"
}

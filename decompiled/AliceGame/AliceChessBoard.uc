class AliceChessBoard extends InterpActor
    placeable
    hidecategories(Navigation);

enum ECorner
{
    EC_LB,
    EC_LT,
    EC_RB,
    EC_RT,
};

enum EBoardType
{
    ETYPE_4X4,
    ETYPE_6X6,
};

var() EBoardType BoardType;
var EChessMoveAction WhiteAction;
var EChessMoveAction BlackAction;
var PieceLoc WhitePiece;
var PieceLoc BlackPiece;
var PieceLoc WhiteGoal;
var PieceLoc BlackGoal;
var array<PieceLoc> BlockLocs;
var array<PieceLoc> TrapLocs;
var() float PieceMoveSpeed;
var() float MirrorMoveDelay;
var() int MaxStep;
var int GridNum;
var int UsedStep;
var array<Vector> GridLocArray;
var PieceLoc CurLoc;
var PieceLoc TargetLoc;
var Vector vCurWorldLoc;
var PieceLoc MirrorCurLoc;
var PieceLoc MirrorTargetLoc;
var Vector vMirrorCurWorldLoc;
var bool bMirrorInDelay;
var bool bGameStarted;
var bool bIsDizzy;
var bool bFirstTimePlay;
var AlicePlayerController APC;
var AliceChessWhitePiece WhiteMesh;
var AliceChessBlackPiece BlackMesh;
var array<AliceChessBlock> BlockMeshes;
var array<AliceChessTrap> TrapMeshes;
var AliceChessGoal WhiteGoalMesh;
var AliceChessGoal BlackGoalMesh;
var SoundCue pieceSlideCue;

function UpdateDizzyState()
{
    if (WhiteMesh == none || BlackMesh == none)
    {
        return;
    }
    if (bIsDizzy && !WhiteMesh.bIsDizzy && !WhiteMesh.bIsDizzy)
    {
        bIsDizzy = false;
    }
}

function DoDizzy()
{
    if (WhiteMesh == none || BlackMesh == none)
    {
        return;
    }
    bIsDizzy = true;
    WhiteMesh.bIsDizzy = true;
    BlackMesh.bIsDizzy = true;
    WhiteMesh.MoveAction = 15;
    BlackMesh.MoveAction = 15;
}

function EndGame()
{
    bGameStarted = false;
}

function StartGame()
{
    bGameStarted = true;
    APC.showChessPuzzleLeftStep(MaxStep);
}

function missTrophy()
{
    bFirstTimePlay = false;
}

function tryUnlockChessTrophy()
{
    if (bFirstTimePlay)
    {
        bFirstTimePlay = false;
        ConsoleCommand("trophy unlock=28");
        if (APC.isShowTrophy())
        {
            APC.ClientMessage("==== Chess Puzzle Trophy Unlock ====");
        }
    }
}

function ChessPuzzleFail(bool bByTrap)
{
    if (bByTrap)
    {
        if (WhiteMesh != none)
        {
            WhiteMesh.playBreakPS();
            WhiteMesh.SetHidden(true);
        }
        if (BlackMesh != none)
        {
            BlackMesh.playBreakPS();
            BlackMesh.SetHidden(true);
        }
    }
    else
    {
        WhiteAction = 6;
        BlackAction = 6;
        UpdatePieceAction();
    }
    TriggerEventClass(class'SeqEvent_ChessPuzzleFail', self);
    missTrophy();
}

function ChessPuzzleComplete()
{
    WhiteAction = 5;
    BlackAction = 5;
    UpdatePieceAction();
    TriggerEventClass(class'SeqEvent_ChessPuzzleComplete', self);
    tryUnlockChessTrophy();
}

function ResetMirrorDelay()
{
    bMirrorInDelay = false;
    BlackMesh.PlaySound(pieceSlideCue);
}

function bool IsMirrorInDelay()
{
    return bMirrorInDelay;
}

function bool CheckTrap()
{
    local int K;
    
    for (K = 0; K < TrapLocs.Length; K++)
    {
        if (CurLoc.I == TrapLocs[K].I && CurLoc.J == TrapLocs[K].J || MirrorCurLoc.I == TrapLocs[K].I && MirrorCurLoc.J == TrapLocs[K].J)
        {
            TrapMeshes[K].TrapAction = 1;
            return true;
        }
    }
    return false;
}

function bool CheckStep()
{
    UsedStep++;
    if (UsedStep >= MaxStep)
    {
        ChessPuzzleFail(false);
        return true;
    }
    return false;
}

function bool CheckGoal()
{
    if (CurLoc.I == WhiteGoal.I && CurLoc.J == WhiteGoal.J && MirrorCurLoc.I == BlackGoal.I && MirrorCurLoc.J == BlackGoal.J)
    {
        ChessPuzzleComplete();
        return true;
    }
    return false;
}

function StartMoveTrap()
{
    local int I;
    
    for (I = 0; I < TrapMeshes.Length; I++)
    {
        TrapMeshes[I].SetNextPath();
    }
}

function PostStep(bool bIsWhite)
{
    if (!CheckGoal())
    {
        if (!CheckStep())
        {
            if (!bIsWhite)
            {
                StartMoveTrap();
            }
        }
    }
}

function MirrorMovePiece(PieceLoc StartLoc, PieceLoc EndLoc, float DeltaTime)
{
    local Vector VDir, vEndLoc, vStartLoc;
    
    vEndLoc = GridLocArray[EndLoc.I * GridNum + EndLoc.J];
    vStartLoc = GridLocArray[StartLoc.I * GridNum + StartLoc.J];
    VDir = Normal(vEndLoc - vStartLoc);
    vMirrorCurWorldLoc += VDir * PieceMoveSpeed * DeltaTime;
    if ((vEndLoc - vMirrorCurWorldLoc) Dot VDir < float(0))
    {
        MirrorCurLoc = EndLoc;
        vMirrorCurWorldLoc = GridLocArray[EndLoc.I * GridNum + EndLoc.J];
        PostStep(false);
    }
}

function MovePiece(PieceLoc StartLoc, PieceLoc EndLoc, float DeltaTime)
{
    local Vector VDir, vEndLoc, vStartLoc;
    
    vEndLoc = GridLocArray[EndLoc.I * GridNum + EndLoc.J];
    vStartLoc = GridLocArray[StartLoc.I * GridNum + StartLoc.J];
    VDir = Normal(vEndLoc - vStartLoc);
    vCurWorldLoc += VDir * PieceMoveSpeed * DeltaTime;
    if ((vEndLoc - vCurWorldLoc) Dot VDir < float(0))
    {
        CurLoc = EndLoc;
        vCurWorldLoc = GridLocArray[EndLoc.I * GridNum + EndLoc.J];
        if (!IsMirrorMoving())
        {
            PostStep(true);
        }
    }
}

function bool IsMirrorMoving()
{
    return MirrorCurLoc != MirrorTargetLoc;
}

function bool IsMoving()
{
    return CurLoc != TargetLoc;
}

function bool IsBlockEachOther(optional out EChessMoveAction outAction1, optional out EChessMoveAction outAction2)
{
    if (TargetLoc.I == MirrorCurLoc.I && TargetLoc.J == MirrorCurLoc.J || TargetLoc.I == MirrorTargetLoc.I && TargetLoc.J == MirrorTargetLoc.J)
    {
        DetermineBlockAction(outAction1);
        DetermineBlockAction(outAction2);
        return true;
    }
    return false;
}

function bool IsBlocked(PieceLoc Loc, optional out EChessMoveAction outAction)
{
    local int I;
    
    if (!IsLocValid(Loc))
    {
        DetermineEdgeAction(outAction);
        return true;
    }
    for (I = 0; I < BlockLocs.Length; I++)
    {
        if (IsLocValid(BlockLocs[I]))
        {
            if (Loc.I == BlockLocs[I].I && Loc.J == BlockLocs[I].J)
            {
                DetermineBlockAction(outAction);
                return true;
            }
        }
    }
    for (I = 0; I < TrapMeshes.Length; I++)
    {
        if (IsLocValid(TrapMeshes[I].GetLoc()))
        {
            if (Loc.I == TrapMeshes[I].GetLoc().I && Loc.J == TrapMeshes[I].GetLoc().J)
            {
                DetermineBlockAction(outAction);
                return true;
            }
        }
    }
    return false;
}

function DetermineBlockAction(optional out EChessMoveAction outAction)
{
    switch (outAction)
    {
        case 3:
            outAction = 7;
            break;
        case 4:
            outAction = 8;
            break;
        case 1:
            outAction = 9;
            break;
        case 2:
            outAction = 10;
            break;
        default:
    }
}

function DetermineEdgeAction(optional out EChessMoveAction outAction)
{
    switch (outAction)
    {
        case 3:
            outAction = 11;
            break;
        case 4:
            outAction = 12;
            break;
        case 1:
            outAction = 13;
            break;
        case 2:
            outAction = 14;
            break;
        default:
    }
}

function bool canShowResetMenu()
{
    local int I;
    
    if (TargetLoc.I == WhiteGoal.I && TargetLoc.J == WhiteGoal.J && MirrorTargetLoc.I == BlackGoal.I && MirrorTargetLoc.J == BlackGoal.J)
    {
        return false;
    }
    if (IsMoving() || IsMirrorMoving())
    {
        return false;
    }
    for (I = 0; I < TrapMeshes.Length; I++)
    {
        if (TrapMeshes[I].IsMoving())
        {
            return false;
        }
    }
    return true;
}

function HandleCommand(EChessMoveCommand Command, float DeltaTime)
{
    if (IsMoving() || IsMirrorMoving() || IsAnyTrapMoving())
    {
        return;
    }
    switch (Command)
    {
        case 0:
            TargetLoc.J += 1;
            MirrorTargetLoc.J += -1;
            WhiteAction = 1;
            BlackAction = 2;
            break;
        case 1:
            TargetLoc.J += -1;
            MirrorTargetLoc.J += 1;
            WhiteAction = 2;
            BlackAction = 1;
            break;
        case 2:
            TargetLoc.I += 1;
            MirrorTargetLoc.I += -1;
            WhiteAction = 3;
            BlackAction = 4;
            break;
        case 3:
            TargetLoc.I += -1;
            MirrorTargetLoc.I += 1;
            WhiteAction = 4;
            BlackAction = 3;
            break;
        default:
    }
    if (!IsBlocked(TargetLoc, WhiteAction) && !IsBlockEachOther(WhiteAction, BlackAction))
    {
        APC.showChessPuzzleLeftStep(MaxStep - UsedStep - 1);
        if (!IsBlocked(MirrorTargetLoc, BlackAction))
        {
            bMirrorInDelay = true;
            SetTimer(MirrorMoveDelay, false, 'ResetMirrorDelay');
        }
        else
        {
            MirrorTargetLoc = MirrorCurLoc;
            bMirrorInDelay = false;
            StartMoveTrap();
        }
        WhiteMesh.PlaySound(pieceSlideCue);
    }
    else
    {
        TargetLoc = CurLoc;
        MirrorTargetLoc = MirrorCurLoc;
        BlackAction = 0;
    }
    UpdatePieceAction();
}

function bool IsAnyTrapMoving()
{
    local int I;
    
    for (I = 0; I < TrapMeshes.Length; I++)
    {
        if (TrapMeshes[I].IsMoving())
        {
            return true;
        }
    }
    return false;
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

function Vector GetGridLoc(int I, int J)
{
    local Vector vResult;
    local float XStart, YStart, fGridLength;
    
    fGridLength = GetLength() / float(GridNum);
    XStart = GetCornerRawLoc(0).X + 0.5 * fGridLength;
    YStart = GetCornerRawLoc(0).Y + 0.5 * fGridLength;
    vResult.X = XStart + float(J) * fGridLength;
    vResult.Y = YStart + float(I) * fGridLength;
    vResult.Z = GetCenterLoc().Z;
    RotateYaw(vResult, float(Rotation.Yaw), Location);
    return vResult;
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

function bool IsLocValid(PieceLoc Loc)
{
    return Loc.I >= 0 && Loc.I < GridNum && Loc.J >= 0 && Loc.J < GridNum;
}

function ShowGoal()
{
    local float fRadius;
    
    fRadius = GetLength() / float(GridNum) / 2.2;
    if (IsLocValid(WhiteGoal))
    {
        DrawDebugSphere(GridLocArray[WhiteGoal.I * GridNum + WhiteGoal.J], fRadius, 16, 255, 255, 255);
    }
    if (IsLocValid(BlackGoal))
    {
        DrawDebugSphere(GridLocArray[BlackGoal.I * GridNum + BlackGoal.J], fRadius, 16, 0, 0, 0);
    }
}

function ShowBlock()
{
    local int I;
    local Vector vExtent;
    
    vExtent.X = GetLength() / float(GridNum) / 2.2;
    vExtent.Y = vExtent.X;
    vExtent.Z = vExtent.X * 1.5;
    for (I = 0; I < BlockLocs.Length; I++)
    {
        if (IsLocValid(BlockLocs[I]))
        {
            DrawDebugBox(GridLocArray[BlockLocs[I].I * GridNum + BlockLocs[I].J], vExtent, 255, 0, 0);
        }
    }
}

function ShowGrid()
{
    local int I, J;
    local Vector vExtent;
    
    vExtent.X = GetLength() / float(GridNum) / 2.0;
    vExtent.Y = vExtent.X;
    vExtent.Z = 20.0;
    DrawDebugLine(Location, Location + vect(0.0, 0.0, 100.0), 0, 0, 255);
    for (I = 0; I < GridNum; I++)
    {
        for (J = 0; J < GridNum; J++)
        {
            DrawDebugLine(GridLocArray[I * GridNum + J], GridLocArray[I * GridNum + J] + float((I * GridNum + J) * 30 + 50) * vect(0.0, 0.0, 1.0), 0, 255, 0);
            DrawDebugBox(GridLocArray[I * GridNum + J], vExtent, 255, 255, 0);
        }
    }
}

function ShowCurPieceLoc()
{
    local Vector vExtent;
    
    vExtent.X = GetLength() / float(GridNum) / 3.0;
    vExtent.Y = vExtent.X;
    vExtent.Z = vExtent.X * 3.0;
    DrawDebugBox(vCurWorldLoc, vExtent, 255, 255, 255);
    DrawDebugBox(vMirrorCurWorldLoc, vExtent, 0, 0, 0);
}

function UpdatePieceAction()
{
    if (bIsDizzy)
    {
        return;
    }
    if (WhiteMesh != none)
    {
        WhiteMesh.MoveAction = WhiteAction;
    }
    if (BlackMesh != none)
    {
        BlackMesh.MoveAction = BlackAction;
    }
    if (APC != none)
    {
        APC.ClientMessage("======= White Chess Action: " $ string(WhiteAction) $ "=======");
        APC.ClientMessage("======= Black Chess Action: " $ string(BlackAction) $ "=======");
    }
}

function UpdatePiecePawn()
{
    if (WhiteMesh != none)
    {
        WhiteMesh.SetLocation(vCurWorldLoc);
    }
    if (BlackMesh != none)
    {
        BlackMesh.SetLocation(vMirrorCurWorldLoc);
    }
}

simulated function Tick(float DeltaTime)
{
    local int I;
    
    if (GridNum <= 0)
    {
        return;
    }
    if (APC != none && AliceCheatManager(APC.CheatManager).bShowChess)
    {
        ShowGrid();
        ShowBlock();
        ShowGoal();
    }
    if (!bGameStarted)
    {
        return;
    }
    if (IsMoving())
    {
        MovePiece(CurLoc, TargetLoc, DeltaTime);
    }
    if (!IsMirrorInDelay() && IsMirrorMoving())
    {
        MirrorMovePiece(MirrorCurLoc, MirrorTargetLoc, DeltaTime);
    }
    if (!IsMoving() && !IsMirrorInDelay() && !IsMirrorMoving())
    {
        for (I = 0; I < TrapMeshes.Length; I++)
        {
            if (TrapMeshes[I].IsMoving())
            {
                TrapMeshes[I].MoveTrap(DeltaTime, GridLocArray, CurLoc, MirrorCurLoc, GridNum, self);
            }
        }
    }
    UpdatePiecePawn();
    UpdateDizzyState();
}

function Init()
{
    local int I, J;
    local PieceLoc iLoc;
    
    GridNum = (BoardType == 0 ? 4 : 6);
    if (MaxStep < 0)
    {
        MaxStep = (BoardType == 0 ? 6 : 12);
    }
    UsedStep = 0;
    for (I = 0; I < GridNum; I++)
    {
        for (J = 0; J < GridNum; J++)
        {
            GridLocArray[I * GridNum + J] = GetGridLoc(I, J);
        }
    }
    if (WhiteMesh != none)
    {
        iLoc.I = WhiteMesh.I;
        iLoc.J = WhiteMesh.J;
        if (IsLocValid(iLoc))
        {
            WhitePiece = iLoc;
            CurLoc = WhitePiece;
            TargetLoc = CurLoc;
            vCurWorldLoc = GridLocArray[CurLoc.I * GridNum + CurLoc.J];
            WhiteMesh.SetLocation(vCurWorldLoc);
            WhiteMesh.SetBase(self);
            WhiteMesh.SetHidden(false);
        }
    }
    if (BlackMesh != none)
    {
        iLoc.I = BlackMesh.I;
        iLoc.J = BlackMesh.J;
        if (IsLocValid(iLoc))
        {
            BlackPiece = iLoc;
            MirrorCurLoc = BlackPiece;
            MirrorTargetLoc = MirrorCurLoc;
            vMirrorCurWorldLoc = GridLocArray[iLoc.I * GridNum + iLoc.J];
            BlackMesh.SetLocation(vMirrorCurWorldLoc);
            BlackMesh.SetBase(self);
            BlackMesh.SetHidden(false);
        }
    }
    BlockLocs.Length = 0;
    for (I = 0; I < BlockMeshes.Length; I++)
    {
        iLoc.I = BlockMeshes[I].I;
        iLoc.J = BlockMeshes[I].J;
        if (IsLocValid(iLoc))
        {
            BlockLocs.AddItem(iLoc);
            BlockMeshes[I].SetLocation(GridLocArray[iLoc.I * GridNum + iLoc.J]);
            BlockMeshes[I].SetBase(self);
        }
    }
    if (WhiteGoalMesh != none)
    {
        iLoc.I = WhiteGoalMesh.I;
        iLoc.J = WhiteGoalMesh.J;
        if (IsLocValid(iLoc))
        {
            WhiteGoal = iLoc;
            WhiteGoalMesh.SetLocation(GridLocArray[iLoc.I * GridNum + iLoc.J]);
            WhiteGoalMesh.SetBase(self);
        }
    }
    if (BlackGoalMesh != none)
    {
        iLoc.I = BlackGoalMesh.I;
        iLoc.J = BlackGoalMesh.J;
        if (IsLocValid(iLoc))
        {
            BlackGoal = iLoc;
            BlackGoalMesh.SetLocation(GridLocArray[iLoc.I * GridNum + iLoc.J]);
            BlackGoalMesh.SetBase(self);
        }
    }
    TrapLocs.Length = 0;
    for (I = 0; I < TrapMeshes.Length; I++)
    {
        iLoc.I = TrapMeshes[I].I;
        iLoc.J = TrapMeshes[I].J;
        if (IsLocValid(iLoc))
        {
            TrapLocs.AddItem(iLoc);
            TrapMeshes[I].SetLocation(GridLocArray[iLoc.I * GridNum + iLoc.J]);
            TrapMeshes[I].SetBase(self);
            TrapMeshes[I].Init(self);
            TrapMeshes[I].setMovingRotation();
            continue;
        }
        TrapMeshes.RemoveItem(TrapMeshes[I]);
    }
    WhiteAction = 0;
    BlackAction = 0;
    UpdatePieceAction();
}

defaultproperties
{
    BlackPiece=(I=-1,J=-1)
    WhiteGoal=(I=-1,J=-1)
    BlackGoal=(I=-1,J=-1)
    PieceMoveSpeed=500.0
    MirrorMoveDelay=0.3
    MaxStep=-1
    bMirrorInDelay=True
    bFirstTimePlay=True
    pieceSlideCue="SFX_Puzzle.sfx_puzzle_slide01_Cue"
    StaticMeshComponent="Default__AliceChessBoard.StaticMeshComponent0"
    LightEnvironment="Default__AliceChessBoard.MyLightEnvironment"
    Components(0)="Default__AliceChessBoard.MyLightEnvironment"
    Components(1)="Default__AliceChessBoard.StaticMeshComponent0"
    CollisionComponent="Default__AliceChessBoard.StaticMeshComponent0"
    SupportedEvents(0)="Engine.SeqEvent_Touch"
    SupportedEvents(1)="Engine.SeqEvent_Destroyed"
    SupportedEvents(2)="Engine.SeqEvent_TakeDamage"
    SupportedEvents(3)="Engine.SeqEvent_HitWall"
    SupportedEvents(4)="Engine.SeqEvent_Mover"
    SupportedEvents(5)="SeqEvent_ChessPuzzleComplete"
    SupportedEvents(6)="SeqEvent_ChessPuzzleFail"
}

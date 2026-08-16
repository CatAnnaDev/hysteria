class AliceChessTrap extends SkeletalMeshActor
    native
    placeable
    hidecategories(Navigation);

var() int I;
var() int J;
var() array<PieceLoc> MovingPath;
var() float PieceMoveSpeed;
var int PathID;
var int TargetPathID;
var bool bForward;
var bool bLastTickIsMoving;
var EChessTrapAction TrapAction;
var AliceChessBoard ChessBoard;
var Vector vCurWorldLoc;

event ChessTrapAttackHit()
{
    if (ChessBoard != none)
    {
        ChessBoard.ChessPuzzleFail(true);
    }
}

event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
}

function CheckTrap(AliceChessBoard board)
{
    if (GetLoc().I == board.CurLoc.I && GetLoc().J == board.CurLoc.J || GetLoc().I == board.MirrorCurLoc.I && GetLoc().J == board.MirrorCurLoc.J)
    {
        TrapAction = 1;
    }
}

function PostStep(AliceChessBoard board)
{
    setMovingRotation();
    bLastTickIsMoving = false;
}

function MoveTrap(float DeltaTime, out array<Vector> GridLocArray, PieceLoc WhitePieceLoc, PieceLoc BlackPieceLoc, int GridNum, AliceChessBoard board)
{
    local PieceLoc StartLoc, EndLoc;
    local Vector VDir, vEndLoc, vStartLoc;
    
    if (!bLastTickIsMoving)
    {
        onStartMove();
    }
    bLastTickIsMoving = true;
    StartLoc = GetLoc();
    EndLoc = GetNextLoc();
    vEndLoc = GridLocArray[EndLoc.I * GridNum + EndLoc.J];
    vStartLoc = GridLocArray[StartLoc.I * GridNum + StartLoc.J];
    VDir = Normal(vEndLoc - vStartLoc);
    vCurWorldLoc += VDir * PieceMoveSpeed * DeltaTime;
    if ((vEndLoc - vCurWorldLoc) Dot VDir < float(0))
    {
        PathID = GetNextPathID();
        vCurWorldLoc = GridLocArray[EndLoc.I * GridNum + EndLoc.J];
        PostStep(board);
    }
    SetLocation(vCurWorldLoc);
}

function bool IsMoving()
{
    return PathID != TargetPathID;
}

function setMovingRotation()
{
    local EChessMoveCommand movingRotation;
    local PieceLoc CurLoc, nextLoc;
    
    CurLoc = GetLoc();
    nextLoc = MovingPath[GetNextPathID()];
    if (CurLoc.I < nextLoc.I)
    {
        movingRotation = 2;
    }
    else if (CurLoc.I > nextLoc.I)
    {
        movingRotation = 3;
    }
    else if (CurLoc.J < nextLoc.J)
    {
        movingRotation = 0;
    }
    else if (CurLoc.J > nextLoc.J)
    {
        movingRotation = 1;
    }
    switch (movingRotation)
    {
        case 2:
            SetRotation(MakeRotator(0, ChessBoard.Rotation.Yaw + 16384, 0));
            break;
        case 3:
            SetRotation(MakeRotator(0, ChessBoard.Rotation.Yaw - 16384, 0));
            break;
        case 0:
            SetRotation(MakeRotator(0, ChessBoard.Rotation.Yaw + 0, 0));
            break;
        case 1:
            SetRotation(MakeRotator(0, ChessBoard.Rotation.Yaw + 32768, 0));
            break;
        default:
    }
}

function doKillAction()
{
    TrapAction = 1;
}

function checkKillAction()
{
    local PieceLoc nextLoc;
    
    nextLoc = GetNextLoc();
    if (nextLoc.I == ChessBoard.CurLoc.I && nextLoc.J == ChessBoard.CurLoc.J || nextLoc.I == ChessBoard.MirrorCurLoc.I && nextLoc.J == ChessBoard.MirrorCurLoc.J)
    {
        doKillAction();
    }
}

function onStartMove()
{
    checkKillAction();
}

function SetNextPath()
{
    TargetPathID = GetNextPathID();
}

function PieceLoc GetNextLoc()
{
    return MovingPath[TargetPathID];
}

function PieceLoc GetLoc()
{
    return MovingPath[PathID];
}

function int GetNextPathID()
{
    local int NextID;
    
    if (bForward)
    {
        if (PathID == MovingPath.Length - 1)
        {
            NextID = PathID - 1;
            bForward = false;
        }
        else
        {
            NextID = PathID + 1;
        }
    }
    else if (PathID == 0)
    {
        NextID = PathID + 1;
        bForward = true;
    }
    else
    {
        NextID = PathID - 1;
    }
    return NextID;
}

function int GetCurPathID()
{
    return PathID;
}

function Init(AliceChessBoard board)
{
    PathID = 0;
    TargetPathID = 0;
    bForward = true;
    ChessBoard = board;
    vCurWorldLoc = board.GridLocArray[I * board.GridNum + J];
    TrapAction = 0;
}

defaultproperties
{
    I=2
    J=2
    PieceMoveSpeed=500.0
    bForward=True
    SkeletalMeshComponent="Default__AliceChessTrap.SkeletalMeshComponent1"
    LightEnvironment="Default__AliceChessTrap.MyLightEnvironment"
    FacialAudioComp="Default__AliceChessTrap.FaceAudioComponent"
    bNoDelete=False
    Components(0)="Default__AliceChessTrap.MyLightEnvironment"
    Components(1)="Default__AliceChessTrap.FaceAudioComponent"
    Components(2)="Default__AliceChessTrap.SkeletalMeshComponent1"
    CollisionComponent="Default__AliceChessTrap.SkeletalMeshComponent1"
}

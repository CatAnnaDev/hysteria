class AliceGFxMovie_BlockChess extends AliceGFXMovie
    notplaceable;

function showMaxStepChess()
{
    GetAlicePlayerController().showChessPuzzleLeftStep(GetAlicePlayerController().ChessBoardActor.MaxStep);
}

function closeMoveCircle()
{
    GetAlicePlayerController().closeMoveCircle();
}

function showMoveCircle()
{
    GetAlicePlayerController().showMoveCircle();
}

defaultproperties
{
}

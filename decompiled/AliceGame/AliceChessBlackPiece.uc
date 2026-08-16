class AliceChessBlackPiece extends AliceChessPiece
    placeable
    hidecategories(Navigation);

var() int I;
var() int J;
var ParticleSystem breakPS;
var bool bIsDizzy;

function playBreakPS()
{
    local Emitter breakEmitter;
    
    breakEmitter = Spawn(class'Engine.EmitterSpawnable', self, , Location);
    if (breakEmitter != none && breakPS != none)
    {
        breakEmitter.SetTemplate(breakPS, true);
    }
}

event CancelDizzy()
{
    bIsDizzy = false;
}

event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
    OnAnimEnd(SeqNode, PlayedTime, ExcessTime);
    bIsDizzy = false;
}

defaultproperties
{
    J=3
    breakPS="GFX_WonderlandDebris.Chess.ChessPieceRedBreak_P"
    SkeletalMeshComponent="Default__AliceChessBlackPiece.SkeletalMeshComponent1"
    LightEnvironment="Default__AliceChessBlackPiece.MyLightEnvironment"
    FacialAudioComp="Default__AliceChessBlackPiece.FaceAudioComponent"
    bNoDelete=False
    Components(0)="Default__AliceChessBlackPiece.MyLightEnvironment"
    Components(1)="Default__AliceChessBlackPiece.FaceAudioComponent"
    Components(2)="Default__AliceChessBlackPiece.SkeletalMeshComponent1"
    CollisionComponent="Default__AliceChessBlackPiece.SkeletalMeshComponent1"
}

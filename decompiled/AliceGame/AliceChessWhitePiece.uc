class AliceChessWhitePiece extends AliceChessPiece
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
    breakPS="GFX_WonderlandDebris.Chess.ChessPieceWhiteBreak_P"
    SkeletalMeshComponent="Default__AliceChessWhitePiece.SkeletalMeshComponent1"
    LightEnvironment="Default__AliceChessWhitePiece.MyLightEnvironment"
    FacialAudioComp="Default__AliceChessWhitePiece.FaceAudioComponent"
    bNoDelete=False
    Components(0)="Default__AliceChessWhitePiece.MyLightEnvironment"
    Components(1)="Default__AliceChessWhitePiece.FaceAudioComponent"
    Components(2)="Default__AliceChessWhitePiece.SkeletalMeshComponent1"
    CollisionComponent="Default__AliceChessWhitePiece.SkeletalMeshComponent1"
}

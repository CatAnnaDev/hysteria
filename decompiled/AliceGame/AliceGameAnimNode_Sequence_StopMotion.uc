class AliceGameAnimNode_Sequence_StopMotion extends AnimNodeSequence
    native
    notplaceable
    hidecategories(Object,Object,Object,Object);

var() float RotationNoise;
var() float TranslationNoise;
var() float LimitedFPS;
var float DiffTime;

defaultproperties
{
    RotationNoise=0.015
    LimitedFPS=24.0
}

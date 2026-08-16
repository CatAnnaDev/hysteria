class AnimationCompressionAlgorithm extends Object
    abstract
    native
    notplaceable
    hidecategories(Object);

var string Description;
var bool bNeedsSkeleton;
var AnimationCompressionFormat TranslationCompressionFormat;
var() AnimationCompressionFormat RotationCompressionFormat;

defaultproperties
{
    Description="None"
    RotationCompressionFormat="ACF_Float96NoW"
}

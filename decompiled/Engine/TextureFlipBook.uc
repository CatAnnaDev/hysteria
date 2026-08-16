class TextureFlipBook extends Texture2D
    native
    notplaceable
    hidecategories(Object,Object);

enum TextureFlipBookMethod
{
    TFBM_UL_ROW,
    TFBM_UL_COL,
    TFBM_UR_ROW,
    TFBM_UR_COL,
    TFBM_LL_ROW,
    TFBM_LL_COL,
    TFBM_LR_ROW,
    TFBM_LR_COL,
    TFBM_RANDOM,
};

var const native noexport Pointer VfTable_FTickableObject;
var const transient float TimeIntoMovie;
var const transient float TimeSinceLastFrame;
var const transient float HorizontalScale;
var const transient float VerticalScale;
var const bool bPaused;
var const bool bStopped;
var(FlipBook) bool bLooping;
var(FlipBook) bool bAutoPlay;
var(FlipBook) int HorizontalImages;
var(FlipBook) int VerticalImages;
var(FlipBook) TextureFlipBookMethod FBMethod;
var(FlipBook) float FrameRate;
var float FrameTime;
var const transient int CurrentRow;
var const transient int CurrentColumn;
var const transient float RenderOffsetU;
var const transient float RenderOffsetV;
var const native Pointer ReleaseResourcesFence;

native function SetCurrentFrame(int Row, int Col)
{
    Row;
    Col;
}

native function Stop()
{
}

native function Pause()
{
}

native function Play()
{
}

defaultproperties
{
    bLooping=True
    bAutoPlay=True
    HorizontalImages=1
    VerticalImages=1
    FrameRate=4.0
    FrameTime=0.25
    AddressX="TA_Clamp"
    AddressY="TA_Clamp"
}

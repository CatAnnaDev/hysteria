class AliceBoostVolume extends Volume
    placeable
    hidecategories(Navigation,Object,Movement,Display);

var(Boost) Vector BoostDir;
var(Boost) float BoostForce;
var(Boost) float BoostDuration;
var(Boost) bool bBoostFalloff;
var(Boost) SoundCue BoostSound;

event UnTouch(Actor Other)
{
}

event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    local AlicePlayerController APC;
    local Pawn P;
    
    P = Pawn(Other);
    if (P != none)
    {
        APC = AlicePlayerController(P.Controller);
        if (APC != none)
        {
            APC.bBoostVolumeActive = true;
            APC.BoostVolumeTime = 0.0;
            APC.BoostVolumeForce = Normal(BoostDir) * BoostForce;
            APC.BoostVolumeDuration = BoostDuration;
            APC.bBoostVolumeFalloff = bBoostFalloff;
            if (BoostSound != none)
            {
                PlaySound(BoostSound);
            }
        }
    }
}

defaultproperties
{
    BoostDir=(X=1.0,Y=0.0,Z=0.0)
    BoostForce=1000.0
    BoostDuration=1.0
    bBoostFalloff=True
    BoostSound="SFX_C5_OWHH.sfx_owhh_com_booster_Cue"
    BrushComponent="Default__AliceBoostVolume.BrushComponent0"
    bStatic=False
    bAlwaysRelevant=True
    bOnlyDirtyReplication=True
    Components(0)="Default__AliceBoostVolume.BrushComponent0"
    CollisionComponent="Default__AliceBoostVolume.BrushComponent0"
}

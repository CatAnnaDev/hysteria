class GameDamageType extends DamageType
    abstract
    native
    notplaceable
    config(Weapon);

var const MaterialInterface MI_DamageOverlay;
var const SoundCue ExtraSoundToPlayWhenDamaged;
var const bool bEnvironmentalDamage;
var const config bool bHighKickDeathAnimation;
var const bool bForceRagdollDeath;
var const bool bSuppressImpactFX;
var const bool bSuppressBloodDecals;
var const bool bSuppressPlayExplosiveRadialDamageEffects;
var const config bool bAllowHeadShotGib;
var const config float DistFromHitLocToGib;
var const CanvasIcon KilledByIcon;
var const CanvasIcon HeadshotIcon;
var const float IconScale;

static function HandleDamageFX(GamePawn DamagedPawn, out const TakeHitInfo HitInfo)
{
}

static function bool ShouldHeadShotGib(Pawn TestPawn, Pawn Instigator)
{
    local GamePawn GP;
    
    if (default.bAllowHeadShotGib)
    {
        GP = GamePawn(TestPawn);
        if (GP != none && GP.bLastHitWasHeadShot)
        {
            return true;
        }
    }
    return false;
}

static function PlayExtraDamageSound(Pawn VictimPawn)
{
    if (default.ExtraSoundToPlayWhenDamaged != none)
    {
        VictimPawn.PlaySound(default.ExtraSoundToPlayWhenDamaged);
    }
}

static function bool IsScriptedDamageType()
{
    return false;
}

static function bool ShouldPlayForceFeedback(Pawn DamagedPawn)
{
    return true;
}

static function HandleDeadPlayer(GamePlayerController Player)
{
}

static function HandleKilledPawn(Pawn KilledPawn, Pawn Instigator)
{
}

static function HandleDamagedPawn(Pawn DamagedPawn, Pawn Instigator, int DamageAmt, Vector Momentum)
{
}

static function ModifyDamage(Pawn Victim, Controller InstigatedBy, out int out_Damage, out Vector out_Momentum, Vector HitLocation, TraceHitInfo HitInfo)
{
}

static function bool ShouldGib(Pawn TestPawn, Pawn Instigator)
{
    return false;
}

defaultproperties
{
    bCausesFracture=True
}

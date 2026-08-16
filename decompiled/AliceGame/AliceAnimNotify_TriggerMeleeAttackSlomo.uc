class AliceAnimNotify_TriggerMeleeAttackSlomo extends AnimNotify
    native
    notplaceable
    editinlinenew
    collapsecategories
    hidecategories(Object);

enum ESlomoCondition
{
    ESlomoCondition_EveryTime,
    ESlomoCondition_PawnAreaPreCheck,
    ESlomoCondition_PawnDeathPreCheck,
};

var() class<AliceGameWeapon> WeaponClass;
var() ESlomoCondition SlomoTriggerCondition;
var() EGameEffectSpeedControlPriority Priority;
var() float MinScale;
var() float DecTime;
var() float FrzTime;
var() float IncTime;
var() bool EnableSlomoSound;

event SetSlomoSoundMode()
{
    getAPC().SoundModeManager.setMeleeAttackSlomoMode(true);
}

function AlicePlayerController getAPC()
{
    local AlicePlayerController PC;
    
    foreach class'Engine.UIScene'.static.GetWorldInfo().LocalPlayerControllers(class'AlicePlayerController', PC)
    {
        if (PC != none)
        {
            return PC;
        }
    }
}

defaultproperties
{
}

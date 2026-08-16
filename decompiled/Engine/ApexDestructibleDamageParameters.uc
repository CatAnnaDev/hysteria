class ApexDestructibleDamageParameters extends Object
    native
    notplaceable
    hidecategories(Object);

enum EDamageParameterOverrideMode
{
    DPOM_Absolute,
    DPOM_Multiplier,
};

struct native DamagePair
{
    var() class<DamageType> DamageTypeClass;
    var() DamageParameters Params;
};

struct native DamageParameters
{
    var() EDamageParameterOverrideMode OverrideMode;
    var() float BaseDamage;
    var() float Radius;
    var() float Momentum;
};

var() array<DamagePair> DamageMap;

defaultproperties
{
}

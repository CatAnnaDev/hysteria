class AliceAnimNotify_TakeDamage extends AnimNotify
    native
    notplaceable
    editinlinenew
    collapsecategories
    hidecategories(Object);

var() float DmgAmount;
var() EDamageStrengthType DmgStrength;
var() class<DamageType> dmgType;

defaultproperties
{
    DmgAmount=10.0
    dmgType="Engine.DmgType_Fell"
}

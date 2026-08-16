class KynapseFpdModifierGoto_Repulsor extends KynapseFpdModifierGoto
    native
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object)
    autoexpandcategories(KynapseFpdModifierGoto_Repulsor);

struct native FpdGoto_Repulsor_AdvancedSettings
{
    var() const float DynDelayTime;
    var() const float DynRatioAttrRep;
    var() const float TimeMinTrigger;
    var() const float TimeMaxTrigger;
    var() const float SlowSpeedFactor;
    var() const float VerySlowSpeedFactor;
};

var() const FpdGoto_Repulsor_AdvancedSettings Advanced;

defaultproperties
{
    Advanced=(DynDelayTime=0.4,DynRatioAttrRep=0.5,TimeMinTrigger=-1.0,TimeMaxTrigger=10.0,SlowSpeedFactor=0.5,VerySlowSpeedFactor=0.25)
    ClassName="Fpd::CGoto_RepulsorDynamicAvoidance"
}

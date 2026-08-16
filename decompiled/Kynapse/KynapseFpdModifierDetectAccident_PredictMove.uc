class KynapseFpdModifierDetectAccident_PredictMove extends KynapseFpdModifierDetectAccident
    native
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object)
    autoexpandcategories(KynapseFpdModifierDetectAccident_PredictMove);

var() const float AccidentRatio;

defaultproperties
{
    AccidentRatio=0.3
    ClassName="Fpd::CDetectAccident_PredictMove"
}

class KynapsePathdataGenerationModifier_Jumps extends KynapsePathdataGenerationModifier
    native
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object);

var() const KynapseEntityDefinitionStaticPathObject jumpEntityDef;

defaultproperties
{
    jumpEntityDef="KynapseAlice2Definitions.PathObjectDef.JumpPadPathObjectDef"
}

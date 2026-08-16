class KynapseFpdBrainUnreal extends KynapseBrain
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object)
    autoexpandcategories(KynapseBrain);

defaultproperties
{
    brainName="UnrealScriptBrain"
    ClassName="AliceGameSphinxNPCBrain"
    servicesList="Default__KynapseFpdBrainUnreal.Pathfinder"
    agentsList="Default__KynapseFpdBrainUnreal.GotoAgent"
}

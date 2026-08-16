class KynapseTeamCreationData extends Object
    native
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object);

var() const string TeamName;
var() ESphinxTeamContainerType TeamType;
var() const int TeamSize;
var() const KynapseTeamDefinition TeamDefinition;
var const Pointer KynapseTeam;

native function PostInitializeTeam()
{
}

native function CreateKynapseTeam()
{
}

defaultproperties
{
    TeamName="NoName"
    TeamSize=15
}

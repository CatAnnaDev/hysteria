class KynapseBrain extends Object
    native
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object)
    autoexpandcategories(KynapseBrain);

const nbAgents = 15;
const nbBrainServices = 5;

var() const string brainName;
var() const string ClassName;
var() const export editinline KynapseBrainService servicesList[5];
var() const export editinline KynapseAgent agentsList[15];

defaultproperties
{
}

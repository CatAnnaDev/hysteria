class KynapseWorld extends Actor
    native
    placeable
    hidecategories(Navigation,Movement,Collision,Advanced,Attachment,Display,Object,Physics,Debug)
    autoexpandcategories(KynapseWorld);

const nbTeams = 10;
const nbWorldServices = 10;

var() const string World_Name;
var() const float World_OneMeter;
var() const int World_nbEntities;
var() const int World_nbTeams;
var() const export editinline KynapseTeamCreationData TeamCreationDataSet[10];
var() const float World_TimePerFrame;
var() const export editinline KynapseWorldService servicesList[10];
var() const export editinline array<KynapseWorldService> servicesList_Win32Only;
var() const export editinline array<KynapseWorldService> servicesList_XBox360Only;
var() const export editinline array<KynapseWorldService> servicesList_PS3Only;
var() const array<KynapseEntityDefinition> EntityDefinitionList;
var() const export editinline array<FpdBuilder> FpdBuildersList;

defaultproperties
{
    World_Name="World"
    World_OneMeter=100.0
    World_nbEntities=200
    World_nbTeams=10
    World_TimePerFrame=4.0
    servicesList[1]="Default__KynapseWorld.EntityInfoManager"
    servicesList[2]="Default__KynapseWorld.GapManager"
    servicesList[3]="Default__KynapseWorld.OutlineManager"
    servicesList[4]="Default__KynapseWorld.FpdGraphToolboxManager"
    servicesList[5]="Default__KynapseWorld.AIMeshLayerManager"
    servicesList[6]="Default__KynapseWorld.AIMeshLpfManager"
    servicesList[7]="Default__KynapseWorld.AIPointLockManager"
    EntityDefinitionList(0)="KynapseDefaultDefinitions.ObstacleLpfDef"
    EntityDefinitionList(1)="KynapseAlice2Definitions.PathObjectDef.JumpPadPathObjectDef"
    FpdBuildersList(0)="Default__KynapseWorld.DefaultFPD"
    Components(0)="Default__KynapseWorld.Sprite"
    Components(1)="Default__KynapseWorld.LinkedPathdataRenderer"
    CollisionType="COLLIDE_CustomDefault"
}

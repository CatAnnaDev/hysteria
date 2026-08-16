class KynapseWorldServiceFlyBuilder extends KynapseStandardPathdataGenerationService
    native
    placeable
    hidecategories(Navigation,Movement,Collision,Advanced,Attachment,Display,Object,Physics,Debug,Movement,Collision,Advanced,Attachment,Display,Object)
    autoexpandcategories(KynapseStandardPathdataGenerationService);

struct native KynapseWorldServiceFlyBuilderAdvancedParameters
{
    var() const int MaxCollisionTestsPerFrame;
    var() const float OverConnectionRatio;
    var() const int ComponentSizeMin;
    var() const float SimplificationAccuracy;
    var() const export editinline array<FlyBuilderLocalZoneDefinition> LocalZones;
};

struct native FlyBuilderLocalZoneDefinition
{
    var() const editinline Volume ZoneVolume;
    var() const float LocalPitch;
};

var() const float Pitch;
var() const float BoxSize;
var() const float VerticalBoxSize;
var() const KynapseWorldServiceFlyBuilderAdvancedParameters AdvancedParams;

defaultproperties
{
    Pitch=0.5
    BoxSize=150.0
    VerticalBoxSize=300.0
    AdvancedParams=(MaxCollisionTestsPerFrame=500,OverConnectionRatio=1.4,ComponentSizeMin=1,SimplificationAccuracy=0.0,LocalZones=())
    DistEdgeMax=15.0
    EntityRadius=0.5
    Modifiers(0)="Default__KynapseWorldServiceFlyBuilder.ModJumps"
    Modifiers(1)="Default__KynapseWorldServiceFlyBuilder.ModLadders"
    Components(0)="Default__KynapseWorldServiceFlyBuilder.Sprite"
    Components(1)="Default__KynapseWorldServiceFlyBuilder.PathdataRenderer"
}

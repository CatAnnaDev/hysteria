class KynapseBrainServiceFpdPathfinder extends KynapseBrainService
    native
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object)
    autoexpandcategories(KynapseBrainServiceFpdPathfinder);

struct native LocalPathFinding_Fpd
{
    var() const string context;
    var() const float Radius;
    var() const int pathMaxLength;
    var() const float smoothingPeriod;
    var() const float smoothingDistance;
    var() const int smoothingMaxNodeSkip;
    var() const int tabooEdgeMaxCount;
};

struct native FpdModifiers
{
    var() const export editinline KynapseFpdModifierRefineGoal RefineGoal;
    var() const export editinline KynapseFpdModifierDetectGoalReached DetectGoalReached;
    var() const export editinline KynapseFpdModifierDetectAccident DetectAccident;
    var() const export editinline KynapseFpdModifierFindNodesFromPositions FindNodesFromPositions;
    var() const export editinline KynapseFpdModifierCanGo CanGo;
    var() const export editinline KynapseFpdModifierDetectGoalChanged DetectGoalChanged;
    var() const export editinline KynapseFpdModifierDetectPathNodeReached DetectPathNodeReached;
    var() const export editinline KynapseFpdModifierSelectPathNodeCandidate SelectPathNodeCandidate;
    var() const export editinline KynapseFpdModifierComputeTargetPoint ComputeTargetPoint;
    var() const export editinline KynapseFpdModifierGoto Goto;
    var() const export editinline KynapseFpdModifierSteering Steering;
    var() const export editinline KynapseFpdModifierLpfShortcut LpfShortcut;
};

var() const KynapseFpdDatabase database;
var() const FpdModifiers Modifiers;
var() const bool AvoidCpuPeaks;
var() const float CpuPrudence;
var() const float MaxPathSize;
var() const int PathObjectMemory;
var() const LocalPathFinding_Fpd lpfConfig;

defaultproperties
{
    Modifiers=(RefineGoal="None",DetectGoalReached="Default__KynapseBrainServiceFpdPathfinder.DefaultDGR",DetectAccident="Default__KynapseBrainServiceFpdPathfinder.DefaultDA_PM",FindNodesFromPositions="Default__KynapseBrainServiceFpdPathfinder.DefaultFNFP_NR",CanGo="Default__KynapseBrainServiceFpdPathfinder.DefaultCG_AIM",DetectGoalChanged="None",DetectPathNodeReached="None",SelectPathNodeCandidate="None",ComputeTargetPoint="Default__KynapseBrainServiceFpdPathfinder.DefaultCTP_SC",Goto="Default__KynapseBrainServiceFpdPathfinder.DefaultGT_GDA",Steering="None",LpfShortcut="None")
    CpuPrudence=1.0
    MaxPathSize=20.0
    PathObjectMemory=16
    lpfConfig=(context="",Radius=25.0,pathMaxLength=512,smoothingPeriod=0.1,smoothingDistance=2.0,smoothingMaxNodeSkip=10,tabooEdgeMaxCount=5)
    time_aperiodicTasksList(0)=(taskName="Fpd::CPathFinder::ComputePath",Priority=1.0,tpf=4.0,maxCall=10)
    time_aperiodicTasksList(1)=(taskName="Fpd::CPathFinder::FollowPath",Priority=1.0,tpf=10000.0,maxCall=10000)
    serviceName="FpdPathfinder"
    ClassName="Fpd::CPathFinder"
}

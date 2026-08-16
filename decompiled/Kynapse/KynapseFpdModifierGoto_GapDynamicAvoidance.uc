class KynapseFpdModifierGoto_GapDynamicAvoidance extends KynapseFpdModifierGoto
    native
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object)
    autoexpandcategories(KynapseFpdModifierGoto_GapDynamicAvoidance);

struct native FpdGoto_GapDynamicAvoidance_MainSettings
{
    var() const float Courtesy;
    var() const bool ContinuousSpeed;
    var() float DiagramHalfWidth;
    var() float DiagramMaxLength;
    var() int MaxCollisionTestsPerFrame;
    var() float CandidateSpacing;
    var() float DiagramRefreshPeriod;
    var() float EntityDistMax;
    var() float QueueingDelay;
    var() float PushingDelay;
    var() float StuckDelay;
    var() float MaxAngularSpeed;
    var() float MinSpeed;
    var() float ExtraGap;
};

struct native FpdGoto_GapDynamicAvoidance_SecondarySettings
{
    var() float QueueingDelay;
    var() float PushingDelay;
    var() float StuckDelay;
    var() float MaxAngularSpeed;
    var() float MinSpeed;
    var() float ExtraGap;
    var() FpdGoto_GapDynamicAvoidance_TechnicalSettings technicalSettings;
};

struct native FpdGoto_GapDynamicAvoidance_TechnicalSettings
{
    var() int MaxCollisionTestsPerFrame;
    var() float CandidateSpacing;
    var() float DiagramRefreshPeriod;
    var() float EntityDistMax;
};

var() const FpdGoto_GapDynamicAvoidance_MainSettings mainSettings;

defaultproperties
{
    mainSettings=(Courtesy=0.8,ContinuousSpeed=True,DiagramHalfWidth=5.0,DiagramMaxLength=3.0,MaxCollisionTestsPerFrame=100,CandidateSpacing=0.1,DiagramRefreshPeriod=0.1,EntityDistMax=20.0,QueueingDelay=0.5,PushingDelay=1.0,StuckDelay=0.5,MaxAngularSpeed=360.0,MinSpeed=1.0,ExtraGap=0.1)
    ClassName="Fpd::CGoto_GapDynamicAvoidance"
}

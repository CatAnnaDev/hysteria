class AnimNotify_Trails extends AnimNotify
    native
    notplaceable
    editinlinenew
    collapsecategories
    hidecategories(Object);

struct native TrailSample
{
    var float RelativeTime;
    var Vector FirstEdgeSample;
    var Vector SecondEdgeSample;
    var Vector ControlPointSample;
};

struct native TrailSamplePoint
{
    var float RelativeTime;
    var TrailSocketSamplePoint FirstEdgeSample;
    var TrailSocketSamplePoint SecondEdgeSample;
    var TrailSocketSamplePoint ControlPointSample;
};

struct native TrailSocketSamplePoint
{
    var Vector Position;
    var Vector Velocity;
};

var(Trails) bool UseAliceLevelDataParticle;
var(Trails) bool bIsExtremeContent;
var() editoronly bool bPreview;
var() bool bSkipIfOwnerIsHidden;
var bool bResampleRequired;
var(Trails) ParticleSystem PSTemplate;
var(Trails) name FirstEdgeSocketName;
var(Trails) name SecondEdgeSocketName;
var(Trails) name ControlPointSocketName;
var float LastStartTime;
var float EndTime;
var deprecated float SampleTimeStep;
var deprecated array<TrailSamplePoint> TrailSampleData;
var(Trails) float SamplesPerSecond;
var array<TrailSample> TrailSampledData;
var transient float CurrentTime;
var transient float TimeStep;
var transient AnimNodeSequence AnimNodeSeq;
var() const ERootBoneAxis TrailSavingRootBoneOption[3];
var() const ERootRotationOption TrailSavingRootRotationOption[3];

native function int GetNumSteps(int InLastTrailIndex)
{
    InLastTrailIndex;
}

defaultproperties
{
    bSkipIfOwnerIsHidden=True
    FirstEdgeSocketName="EndControl"
    SecondEdgeSocketName="StartControl"
    ControlPointSocketName="MidControl"
    SamplesPerSecond=60.0
    TrailSavingRootBoneOption="RBA_Discard"
    TrailSavingRootBoneOption[1]="RBA_Discard"
    TrailSavingRootBoneOption[2]="RBA_Discard"
    TrailSavingRootRotationOption="RRO_Discard"
    TrailSavingRootRotationOption[1]="RRO_Discard"
    TrailSavingRootRotationOption[2]="RRO_Discard"
}

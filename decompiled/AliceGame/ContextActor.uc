class ContextActor extends Trigger
    native
    placeable
    hidecategories(Navigation);

var() bool bUseGiantStompActionButton;
var() bool bDoRootTranslationForAlice;
var() bool bDoRootRotationForAlice;
var() bool bBlendPosition;
var() bool bBlendRotation;
var() bool bUseAlignBoneAsSnapPoint;
var() bool bApplyContextActorRotationToParticleOffset;
var transient bool bIsBlendingPosition;
var transient bool bBlendingPositionFinished;
var transient bool bIsBlendingRotation;
var transient bool bBlendingRotationFinished;
var transient bool bDoAliceAnim;
var transient bool bDoActorAnim;
var transient bool bResetingFromShrunk;
var transient bool bContextActionStarted;
var transient bool bOldJumpCapable;
var transient bool bInTriggerArea;
var transient bool bAdditionalBlendPosition;
var() name AnimNameForAlice;
var() name AnimNameForContextActor;
var() name AnimNameForContextActor_Inactive;
var() name AnimNameForContextActor_Activated;
var() Vector SnapPointOffset;
var() float BlendRotationTime;
var() string UITextToDisplay;
var() float PositionBlendPrecision;
var() int MaxTriggerTimers;
var() export editinline SkeletalMeshComponent SkeletalMeshComponent;
var() const export editconst editinline LightEnvironmentComponent LightEnvironment;
var() ParticleSystem Particle_Inactive;
var() ParticleSystem Particle_Activating;
var() ParticleSystem Particle_Activated;
var() Vector LocationOffsetToPlayParticle;
var Emitter ParticleEmitter;
var() SoundCue Sound_Inactive;
var() SoundCue Sound_Activating;
var() SoundCue Sound_Activated;
var export editinline AudioComponent AmbientSoundComponent;
var transient Rotator BlendRotationDest;
var transient Vector BlendPositionDest;
var transient float BlendPositionDuration;
var transient AlicePawn Alice;
var transient AlicePlayerController APC;
var transient float AdditionalBlendPositionTime;
var float MaxAdditionalBlendPositionTime;
var transient Vector AdditionalBlendPositionStartLoc;
var transient array<InterpGroup> InterpGroupList;

event AdditionalPositionBlending(float DeltaTime)
{
    local Vector CurLoc;
    local float factor;
    
    factor = AdditionalBlendPositionTime / MaxAdditionalBlendPositionTime;
    CurLoc = VLerp(AdditionalBlendPositionStartLoc, BlendPositionDest, factor);
    Alice.SetLocation(CurLoc);
    AdditionalBlendPositionTime += DeltaTime;
}

simulated event SetAnimPosition(name SlotName, int ChannelIndex, name InAnimSeqName, float InPosition, bool bFireNotifies, bool bLooping, int RootMotionLevel)
{
    local AnimNodeSequence SeqNode;
    
    SeqNode = AnimNodeSequence(SkeletalMeshComponent.Animations);
    if (SeqNode != none)
    {
        if (SeqNode.AnimSeqName != InAnimSeqName)
        {
            SeqNode.SetAnim(InAnimSeqName);
        }
        SeqNode.bLooping = bLooping;
        SeqNode.SetPosition(InPosition, bFireNotifies);
    }
}

simulated function OnToggle(SeqAct_Toggle Action)
{
    local AnimNodeSequence SeqNode;
    
    SeqNode = AnimNodeSequence(SkeletalMeshComponent.Animations);
    if (Action.InputLinks[0].bHasImpulse)
    {
        if (!SeqNode.bPlaying)
        {
            SeqNode.PlayAnim(SeqNode.bLooping, SeqNode.Rate, 0.0);
        }
    }
    else if (Action.InputLinks[1].bHasImpulse)
    {
        if (SeqNode.bPlaying)
        {
            SeqNode.StopAnim();
        }
    }
    else if (Action.InputLinks[2].bHasImpulse)
    {
        if (SeqNode.bPlaying)
        {
            SeqNode.StopAnim();
        }
        else
        {
            SeqNode.PlayAnim(SeqNode.bLooping, SeqNode.Rate, 0.0);
        }
    }
}

simulated function OnToggleContextActor(SeqAct_ToggleContextActor Action)
{
    local bool bOldEnable, bOldCanShow;
    
    bOldEnable = bEnabled;
    bOldCanShow = CanStartContext();
    if (Action.InputLinks[0].bHasImpulse)
    {
        bEnabled = true;
        if (!bOldEnable)
        {
            TriggerInteractiveUI();
        }
    }
    else if (Action.InputLinks[1].bHasImpulse)
    {
        bEnabled = false;
        if (bOldCanShow)
        {
            APC.ShowContextActionUIHint(-1, UITextToDisplay);
            Alice.bJumpCapable = bOldJumpCapable;
            Alice.CurrentContextActor = none;
        }
    }
    AliceCheckPointManager(WorldInfo.Game.MyCheckPointManager).UpdateRegisterWhenChange(self, initMostOutName, initActorFName);
}

event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
    if (SeqNode.AnimSeqName == AnimNameForContextActor)
    {
        PlayActivatedEffects();
    }
}

event StartPlayAnimation()
{
    local AnimNodeSequence SeqNode;
    
    if (AnimNameForAlice != 'None' && Alice != none)
    {
        ClearBlendingFlags();
        APC.IgnoreMoveInput(false);
        Alice.DoRootTranslationForContext = bDoRootTranslationForAlice;
        Alice.DoRootRotationForContext = bDoRootRotationForAlice;
        Alice.AnimSeqForContext = AnimNameForAlice;
        Alice.DoSpecialMove(55, true);
        bDoAliceAnim = true;
    }
    if (SkeletalMeshComponent != none)
    {
        SeqNode = AnimNodeSequence(SkeletalMeshComponent.Animations);
        SeqNode.SetAnim(AnimNameForContextActor);
        SeqNode.bCauseActorAnimEnd = true;
        SeqNode.PlayAnim(false, SeqNode.Rate, 0.0);
        bDoActorAnim = true;
    }
    PlayParticle(Particle_Activating, false);
    PlayAmbientSound(Sound_Activating);
    if (Alice != none)
    {
        Alice.Velocity = vect(0.0, 0.0, 0.0);
    }
    if (!bDoAliceAnim && !bDoActorAnim)
    {
        EndContextAction();
    }
}

function bool StartBlendingRotation()
{
    if (bIsBlendingRotation && !bBlendingRotationFinished)
    {
        return false;
    }
    bIsBlendingRotation = true;
    bBlendingRotationFinished = false;
    GetBlendRotationDest();
    Alice.SetDesiredRotation(BlendRotationDest, false, false, BlendRotationTime);
    if (bBlendPosition)
    {
        SetTimer(BlendRotationTime, false, 'StartBlendingPosition');
    }
    else
    {
        SetTimer(BlendRotationTime, false, 'StartPlayAnimation');
    }
    return true;
}

function bool StartBlendingPosition()
{
    if (bIsBlendingPosition && !bBlendingPositionFinished)
    {
        return false;
    }
    bIsBlendingPosition = true;
    BlendPositionDuration = 0.0;
    bBlendingPositionFinished = false;
    GetBlendPositionDest();
    Alice.DestinationOffset = PositionBlendPrecision;
    return true;
}

function EndContextAction()
{
    if (!bContextActionStarted)
    {
        return;
    }
    ClearBlendingFlags();
    bDoAliceAnim = false;
    bDoActorAnim = false;
    Alice.bIsDoingContextAction = false;
    bContextActionStarted = false;
    APC.IgnoreMoveInput(false);
    TriggerEventClass(class'SeqEvent_ContextActionActivated', Alice, -1);
    if (ExceedingMaxTriggerTimes())
    {
        bInTriggerArea = false;
    }
    if (!bInTriggerArea)
    {
        Alice.CurrentContextActor = none;
        Alice.bJumpCapable = bOldJumpCapable;
    }
}

function ClearBlendingFlags()
{
    bIsBlendingPosition = false;
    bIsBlendingRotation = false;
    bBlendingPositionFinished = false;
    bBlendingRotationFinished = false;
}

function bool IsAliceDoingContextAction()
{
    return Alice != none && Alice.bIsDoingContextAction;
}

event ExecuteContextAction()
{
    TriggerTimes++;
    if (bBlendRotation && StartBlendingRotation())
    {
        APC.IgnoreMoveInput(true);
        Alice.Velocity = vect(0.0, 0.0, 0.0);
        Alice.Acceleration = vect(0.0, 0.0, 0.0);
        APC.AngleBetweenInputAndPlayer = 0.0;
    }
    else if (bBlendPosition && StartBlendingPosition())
    {
        APC.IgnoreMoveInput(true);
        Alice.Velocity = vect(0.0, 0.0, 0.0);
        Alice.Acceleration = vect(0.0, 0.0, 0.0);
        APC.AngleBetweenInputAndPlayer = 0.0;
    }
    else
    {
        EndContextAction();
    }
    AliceCheckPointManager(WorldInfo.Game.MyCheckPointManager).UpdateRegisterWhenChange(self, initMostOutName, initActorFName);
}

function StartContextAction()
{
    if (Alice == none)
    {
        return;
    }
    if (ExceedingMaxTriggerTimes())
    {
        return;
    }
    if (!bEnabled || Alice.Physics != 1 || Alice.bShrinkingModeActive)
    {
        return;
    }
    Alice.bIsDoingContextAction = true;
    bContextActionStarted = true;
    if (Alice.bShrinkingModeActive)
    {
        AlicePlayerController(Alice.Controller).ChangeShrinkingMode();
        bResetingFromShrunk = true;
    }
    else
    {
        ExecuteContextAction();
    }
}

function bool ExceedingMaxTriggerTimes()
{
    if (MaxTriggerTimers >= 0 && TriggerTimes >= MaxTriggerTimers)
    {
        return true;
    }
    else
    {
        return false;
    }
}

function GetBlendRotationDest()
{
    BlendRotationDest = Rotation;
}

function GetBlendPositionDest()
{
    local Vector SnapPointBonePos;
    
    if (bUseAlignBoneAsSnapPoint && SkeletalMeshComponent != none && SkeletalMeshComponent.SkeletalMesh != none)
    {
        SnapPointBonePos = SkeletalMeshComponent.GetBoneLocation('Refbox_Align');
        BlendPositionDest = SnapPointBonePos;
    }
    else
    {
        BlendPositionDest = Location + SnapPointOffset;
    }
}

event UnTouch(Actor Other)
{
    local bool bOldCanStartContext;
    
    bOldCanStartContext = CanStartContext();
    UnTouch(Other);
    if (AlicePawn(Other) != none && Other == Alice)
    {
        bInTriggerArea = false;
    }
    if (AlicePawn(Other) != none && Alice != none && APC != none && Alice.CurrentContextActor == self && bEnabled && !Alice.bIsDoingContextAction)
    {
        APC.ShowContextActionUIHint(-1, UITextToDisplay);
        Alice.CurrentContextActor = none;
        Alice.bJumpCapable = bOldJumpCapable;
        EndContextAction();
    }
}

event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    Touch(Other, OtherComp, HitLocation, HitNormal);
    if (!bContextActionStarted)
    {
        if (AlicePawn(Other) != none && !ExceedingMaxTriggerTimes())
        {
            bInTriggerArea = true;
            TriggerInteractiveUI();
        }
    }
}

function TriggerInteractiveUI()
{
    Alice = AlicePawn(WorldInfo.GetLocalPlayerPawn());
    if (CanStartContext() && Alice != none)
    {
        APC = AlicePlayerController(Alice.Controller);
        bOldJumpCapable = Alice.bJumpCapable;
        Alice.bJumpCapable = false;
        Alice.CurrentContextActor = self;
        if (!Alice.bShrinkingModeActive)
        {
            APC.ShowContextActionUIHint(0, UITextToDisplay);
        }
    }
}

function bool CanStartContext()
{
    return bEnabled && bInTriggerArea && !bContextActionStarted;
}

native function MAT_FinishAnimControl(InterpGroup InInterpGroup)
{
    InInterpGroup;
}

simulated event FinishAnimControl(InterpGroup InInterpGroup)
{
    MAT_FinishAnimControl(InInterpGroup);
}

native function MAT_BeginAnimControl(InterpGroup InInterpGroup)
{
    InInterpGroup;
}

simulated event BeginAnimControl(InterpGroup InInterpGroup)
{
    MAT_BeginAnimControl(InInterpGroup);
}

native simulated function UpdateAnimSetList()
{
}

simulated event Destroyed()
{
    Destroyed();
    InterpGroupList.Length = 0;
    UpdateAnimSetList();
}

simulated function PlayParticle(ParticleSystem NewTemplate, optional bool bDestroyOnFinish = true)
{
    if (ParticleEmitter != none && NewTemplate != none)
    {
        ParticleEmitter.SetTemplate(NewTemplate, bDestroyOnFinish);
    }
}

simulated function PlayAmbientSound(SoundCue SndToPlay)
{
    if (AmbientSoundComponent != none)
    {
        AmbientSoundComponent.Stop();
        if (SndToPlay != none)
        {
            AmbientSoundComponent.SoundCue = SndToPlay;
            AmbientSoundComponent.Play();
        }
    }
}

simulated function CreateSoundComponent()
{
    if (AmbientSoundComponent == none)
    {
        AmbientSoundComponent = new(self) class'Engine.AudioComponent';
    }
}

simulated function CreateEmitter()
{
    TransformParticleOffset();
    if (ParticleEmitter == none)
    {
        ParticleEmitter = Spawn(class'Engine.EmitterSpawnable', self, , LocationOffsetToPlayParticle, Rotation);
        if (ParticleEmitter != none)
        {
            ParticleEmitter.SetLocation(LocationOffsetToPlayParticle);
            ParticleEmitter.SetRotation(Rotation);
        }
    }
}

native function TransformParticleOffset()
{
}

simulated function PlayLoopAnimation(name InSeqName, optional bool bCauseAnimEnd = true, optional bool bLoop = true, optional float fBlendTime = 0.1)
{
    local AnimNodeSequence SeqNode;
    
    SeqNode = AnimNodeSequence(SkeletalMeshComponent.Animations);
    if (SeqNode == none)
    {
        return;
    }
    SeqNode.SetAnim(InSeqName);
    SeqNode.bCauseActorAnimEnd = bCauseAnimEnd;
    if (!SeqNode.bPlaying)
    {
        SeqNode.PlayAnim(bLoop, SeqNode.Rate, fBlendTime);
    }
}

function ContextActorPostApplyCheckPoinat()
{
    CreateEmitter();
    CreateSoundComponent();
    if (TriggerTimes < MaxTriggerTimers)
    {
        PlayInactiveEffects();
    }
    else
    {
        PlayActivatedEffects();
    }
}

simulated event PostBeginPlay()
{
    local int I;
    local MaterialInterface MatInterf;
    local MaterialInstanceTimeVarying MatInstTV;
    
    SkeletalMeshComponent.SaveAnimSets();
    CreateEmitter();
    CreateSoundComponent();
    if (TriggerTimes < MaxTriggerTimers)
    {
        PlayInactiveEffects();
    }
    else
    {
        PlayActivatedEffects();
    }
    if (SkeletalMeshComponent.Materials.Length == 0)
    {
        for (I = 0; I < SkeletalMeshComponent.SkeletalMesh.Materials.Length; I++)
        {
            MatInterf = SkeletalMeshComponent.SkeletalMesh.Materials[I];
            MatInstTV = MaterialInstanceTimeVarying(MatInterf);
            if (MatInstTV != none)
            {
                SkeletalMeshComponent.SetMaterial(I, MatInstTV.DuplicateInstance());
                continue;
            }
            SkeletalMeshComponent.SetMaterial(I, MatInterf);
        }
    }
    PostBeginPlay();
}

simulated function PlayActivatedEffects()
{
    PlayLoopAnimation(AnimNameForContextActor_Activated);
    PlayParticle(Particle_Activated, false);
    PlayAmbientSound(Sound_Activated);
}

simulated function PlayInactiveEffects()
{
    PlayLoopAnimation(AnimNameForContextActor_Inactive);
    PlayParticle(Particle_Inactive, false);
    PlayAmbientSound(Sound_Inactive);
}

function bool ShouldSaveForCheckpoint()
{
    return true;
}

defaultproperties
{
    bDoRootTranslationForAlice=True
    bBlendPosition=True
    bBlendRotation=True
    bApplyContextActorRotationToParticleOffset=True
    BlendRotationTime=0.5
    PositionBlendPrecision=8.0
    MaxTriggerTimers=1
    SkeletalMeshComponent="Default__ContextActor.SkeletalMeshComponent0"
    LightEnvironment="Default__ContextActor.MyLightEnvironment"
    MaxAdditionalBlendPositionTime=0.2
    CylinderComponent="Default__ContextActor.CollisionCylinder"
    bEnabled=True
    bHidden=False
    Components(0)="Default__ContextActor.Sprite"
    Components(1)="Default__ContextActor.CollisionCylinder"
    Components(2)="Default__ContextActor.MyLightEnvironment"
    Components(3)="Default__ContextActor.SkeletalMeshComponent0"
    CollisionComponent="Default__ContextActor.CollisionCylinder"
    SupportedEvents(0)="Engine.SeqEvent_Touch"
    SupportedEvents(1)="Engine.SeqEvent_Destroyed"
    SupportedEvents(2)="Engine.SeqEvent_TakeDamage"
    SupportedEvents(3)="Engine.SeqEvent_HitWall"
    SupportedEvents(4)="Engine.SeqEvent_Used"
    SupportedEvents(5)="SeqEvent_ContextActionActivated"
}

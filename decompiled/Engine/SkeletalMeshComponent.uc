class SkeletalMeshComponent extends MeshComponent
    native
    noexport
    notplaceable
    editinlinenew
    hidecategories(Object);

enum EPhysBodyOp
{
    PBO_None,
    PBO_Term,
    PBO_Disable,
};

enum EFaceFXRegOp
{
    FXRO_Add,
    FXRO_Multiply,
    FXRO_Replace,
};

enum EFaceFXBlendMode
{
    FXBM_Overwrite,
    FXBM_Additive,
};

enum ERootMotionRotationMode
{
    RMRM_Ignore,
    RMRM_RotateActor,
};

enum ERootMotionMode
{
    RMM_Translate,
    RMM_Velocity,
    RMM_Ignore,
    RMM_Accel,
    RMM_Relative,
};

struct BonePair
{
    var name Bones[2];
};

struct Attachment
{
    var() export editinline ActorComponent Component;
    var() name BoneName;
    var() Vector RelativeLocation;
    var() Rotator RelativeRotation;
    var() Vector RelativeScale;
};

struct ActiveMorph
{
    var MorphTarget Target;
    var float Weight;
};

var() SkeletalMesh SkeletalMesh;
var transient SkeletalMesh RefPoseSkelMesh;
var const array<MaterialInterface> OriginalMaterials;
var export editinline SkeletalMeshComponent AttachedToSkelComponent;
var() const AnimTree AnimTreeTemplate;
var() const export editinline AnimNode Animations;
var const transient array<AnimNode> AnimTickArray;
var() const PhysicsAsset MoveCollisionPhysicsAsset;
var() const PhysicsAsset PhysicsAsset;
var const transient export editinline PhysicsAssetInstance PhysicsAssetInstance;
var const native transient Pointer ApexClothing;
var() interp float PhysicsWeight;
var() float GlobalAnimRateScale;
var const native transient Pointer MeshObject;
var() Color WireframeColor;
var const native transient array<Matrix> SpaceBases;
var const native transient array<BoneAtom> LocalAtoms;
var const native transient array<byte> RequiredBones;
var const native transient array<byte> ComposePass1RequiredBones;
var const native transient array<byte> ComposePass2RequiredBones;
var const native transient array<byte> ComposePass3RequiredBones;
var() const export editinline SkeletalMeshComponent ParentAnimComponent;
var const native transient array<int> ParentBoneMap;
var() array<AnimSet> AnimSets;
var const native transient array<AnimSet> TemporarySavedAnimSets;
var() array<MorphTargetSet> MorphSets;
var() bool bVertexDisturbanceEnabled;
var() bool bDisturbClothVertex;
var transient array<ActiveMorph> ActiveMorphs;
var transient array<ActiveMorph> ActiveCurveMorphs;
var const native map<int, int> MorphTargetIndexMap;
var const duplicatetransient array<Attachment> Attachments;
var const transient array<byte> SkelControlIndex;
var const transient array<byte> PostPhysSkelControlIndex;
var() int ForcedLodModel;
var() int MinLodModel;
var int PredictedLODLevel;
var int OldPredictedLODLevel;
var const float MaxDistanceFactor;
var int bForceWireframe;
var int bForceRefpose;
var int bOldForceRefPose;
var() bool bNoSkeletonUpdate;
var int bDisplayBones;
var int bShowPrePhysBones;
var int bHideSkin;
var int bForceRawOffset;
var int bIgnoreControllers;
var int bTransformFromAnimParent;
var const transient int TickTag;
var const transient int CachedAtomsTag;
var const int bUseSingleBodyPhysics;
var transient int bRequiredBonesUpToDate;
var float MinDistFactorForKinematicUpdate;
var transient int FramesPhysicsAsleep;
var array<Vector> FakeRootMotionData;
var int FakeRootMotionPrecision;
var float FakeRootMotionTotalTime;
var float FakeRootMotionScale;
var() float FakeRootMotionInvMassScale;
var() float FakeRootMotionTimeScale;
var transient float FakeRootMotionPreviousTime;
var transient float FakeRootMotionCurrentTime;
var transient Quat FakeRootMotionFront;
var bool bSkipAllUpdateWhenPhysicsAsleep;
var() bool bConsiderAllBodiesForBounds;
var() bool bUpdateSkelWhenNotRendered;
var bool bIgnoreControllersWhenNotRendered;
var bool bTickAnimNodesWhenNotRendered;
var const bool bNotUpdatingKinematicDueToDistance;
var() bool bForceDiscardRootMotion;
var bool bRootMotionModeChangeNotify;
var bool bRootMotionExtractedNotify;
var transient bool bInFakeRootMotion;
var transient bool bPendingFakeRootMotion;
var transient bool bNextFrameInFakeRootMotion;
var() bool bDisableFaceFXMaterialInstanceCreation;
var const transient bool bAnimTreeInitialised;
var transient bool bForceMeshObjectUpdate;
var() const bool bHasPhysicsAssetInstance;
var() bool bUpdateKinematicBonesFromAnimation;
var() bool bUpdateJointsFromAnimation;
var const bool bSkelCompFixed;
var const bool bHasHadPhysicsBlendedIn;
var() bool bForceUpdateAttachmentsInTick;
var transient bool bEnableFullAnimWeightBodies;
var() bool bPerBoneVolumeEffects;
var() bool bSyncActorLocationToRootRigidBody;
var const bool bUseRawData;
var bool bDisableWarningWhenAnimNotFound;
var bool bOverrideAttachmentOwnerVisibility;
var const transient bool bNeedsToDeleteHitMask;
var bool bPauseAnims;
var bool bChartDistanceFactor;
var bool bEnableLineCheckWithBounds;
var Vector LineCheckBoundsScale;
var(Cloth) const bool bEnableClothSimulation;
var(Cloth) const bool bDisableClothCollision;
var(Cloth) const bool bClothFrozen;
var(Cloth) bool bAutoFreezeClothWhenNotRendered;
var(Cloth) bool bClothAwakeOnStartup;
var(Cloth) bool bClothBaseVelClamp;
var(Cloth) bool bClothBaseVelInterp;
var(Cloth) bool bAttachClothVertsToBaseBody;
var(Cloth) bool bIsClothOnStaticObject;
var bool bUpdatedFixedClothVerts;
var(Cloth) bool bClothPositionalDampening;
var(Cloth) bool bClothWindRelativeToOwner;
var bool bRecentlyRendered;
var bool bCacheAnimSequenceNodes;
var bool bAlwaysUpdateMeshObject;
var const transient bool bNeedsInstanceWeightUpdate;
var const transient bool bAlwaysUseInstanceWeights;
var const transient bool bUpdateComposeSkeletonPasses;
var const transient array<bool> HiddenMaterials;
var const native transient array<BonePair> InstanceVertexWeightBones;
var const Vector FrozenLocalToWorldPos;
var const Rotator FrozenLocalToWorldRot;
var(Cloth) const name ClothParentRigidBoneName;
var(Cloth) const Vector ClothExternalForce;
var(Cloth) Vector ClothWind;
var(Cloth) Vector ClothBaseVelClampRange;
var(Cloth) float ClothBlendWeight;
var float ClothDynamicBlendWeight;
var(Cloth) float ClothBlendMinDistanceFactor;
var(Cloth) float ClothBlendMaxDistanceFactor;
var(Cloth) Vector MinPosDampRange;
var(Cloth) Vector MaxPosDampRange;
var(Cloth) Vector MinPosDampScale;
var(Cloth) Vector MaxPosDampScale;
var const native transient Pointer ClothSim;
var const native transient int SceneIndex;
var const array<Vector> ClothMeshPosData;
var const array<Vector> ClothMeshNormalData;
var const array<int> ClothMeshIndexData;
var int NumClothMeshVerts;
var int NumClothMeshIndices;
var const array<int> ClothMeshParentData;
var int NumClothMeshParentIndices;
var const native transient array<Vector> ClothMeshWeldedPosData;
var const native transient array<Vector> ClothMeshWeldedNormalData;
var const native transient array<int> ClothMeshWeldedIndexData;
var int ClothDirtyBufferFlag;
var(Cloth) const ERBCollisionChannel ClothRBChannel;
var(Cloth) const RBCollisionChannelContainer ClothRBCollideWithChannels;
var(Cloth) const float ClothForceScale;
var(Cloth) float ClothImpulseScale;
var(Cloth) const float ClothAttachmentTearFactor;
var(Cloth) const bool bClothUseCompartment;
var(Cloth) const float MinDistanceForClothReset;
var const transient Vector LastClothLocation;
var(ApexClothing) const ERBCollisionChannel ApexClothingRBChannel;
var(ApexClothing) const RBCollisionChannelContainer ApexClothingRBCollideWithChannels;
var(ApexClothing) bool bAutoFreezeApexClothingWhenNotRendered;
var(ApexClothing) Vector WindVelocity;
var(ApexClothing) float WindVelocityBlendTime;
var const transient bool bSkipInitClothing;
var const native transient Pointer SoftBodySim;
var const native transient int SoftBodySceneIndex;
var(SoftBody) const bool bEnableSoftBodySimulation;
var const array<Vector> SoftBodyTetraPosData;
var const array<int> SoftBodyTetraIndexData;
var int NumSoftBodyTetraVerts;
var int NumSoftBodyTetraIndices;
var(SoftBody) float SoftBodyImpulseScale;
var(SoftBody) const bool bSoftBodyFrozen;
var(SoftBody) bool bAutoFreezeSoftBodyWhenNotRendered;
var(SoftBody) bool bSoftBodyAwakeOnStartup;
var(SoftBody) const bool bSoftBodyUseCompartment;
var(SoftBody) const ERBCollisionChannel SoftBodyRBChannel;
var(SoftBody) const RBCollisionChannelContainer SoftBodyRBCollideWithChannels;
var const native transient Pointer SoftBodyASVPlane;
var Material LimitMaterial;
var const transient BoneAtom RootMotionDelta;
var const transient BoneAtom FakeRootMotionDelta;
var transient Vector RootMotionVelocity;
var transient Vector FakeRootMotionVelocity;
var const transient Vector RootBoneTranslation;
var Vector RootMotionAccelScale;
var Vector FakeRootMotionAccelScale;
var() ERootMotionMode RootMotionMode;
var() ERootMotionMode FakeRootMotionMode;
var const ERootMotionMode PreviousRMM;
var ERootMotionMode PendingRMM;
var ERootMotionMode OldPendingRMM;
var const int bRMMOneFrameDelay;
var() ERootMotionRotationMode RootMotionRotationMode;
var() EFaceFXBlendMode FaceFXBlendMode;
var native transient Pointer FaceFXActorInstance;
var export editinline AudioComponent CachedFaceFXAudioComp;
var const transient array<byte> BoneVisibility;
var const transient BoneAtom LocalToWorldBoneAtom;
var transient float ProgressiveDrawingFraction;

native function AutoSetMaterialsForSkelComponent(optional bool bIgnoreUserSet = false)
{
    bIgnoreUserSet;
}

native function SetMorphWeight(name MorphNodeName, float MorphWeight)
{
    MorphNodeName;
    MorphWeight;
}

final simulated function BreakConstraint(Vector Impulse, Vector HitLocation, name InBoneName, optional bool bVelChange)
{
    local int ConstraintIndex;
    local RB_ConstraintInstance Constraint;
    local RB_ConstraintSetup ConstraintSetup;
    local RB_BodyInstance Body;
    
    ConstraintIndex = FindConstraintIndex(InBoneName);
    if (ConstraintIndex == -1)
    {
        return;
    }
    Constraint = PhysicsAssetInstance.Constraints[ConstraintIndex];
    if (Constraint.bTerminated)
    {
        return;
    }
    ToggleInstanceVertexWeights(true);
    AddInstanceVertexWeightBoneParented(InBoneName);
    ConstraintSetup = PhysicsAsset.ConstraintSetup[Constraint.ConstraintIndex];
    Body = FindBodyInstanceNamed(ConstraintSetup.JointName);
    if (Body != none && Body.IsFixed())
    {
        Body.SetFixed(false);
    }
    Constraint.TermConstraint();
    UpdateMeshForBrokenConstraints();
    AddImpulse(Impulse, HitLocation, InBoneName, bVelChange);
}

simulated function SkelMeshCompAttachedOnParticleSystemFinished(ParticleSystemComponent PSC)
{
    DetachComponent(PSC);
    Owner.WorldInfo.MyEmitterPool.OnParticleSystemFinished(PSC);
}

simulated function SkelMeshCompOnParticleSystemFinished(ParticleSystemComponent PSC)
{
    DetachComponent(PSC);
}

event PlayParticleEffect(const AnimNotify_PlayParticleEffect AnimNotifyData)
{
    local Vector Loc;
    local Rotator Rot;
    local ParticleSystemComponent PSC;
    
    if (AnimNotifyData.PSTemplate == none)
    {
        return;
    }
    if (AnimNotifyData.bIsExtremeContent == true && class'Engine'.static.IsGame() == true && class'WorldInfo'.static.GetWorldInfo().GRI.ShouldShowGore() == false)
    {
        return;
    }
    if (AnimNotifyData.bAttach == true)
    {
        if (Owner != none && Owner.WorldInfo != none && Owner.WorldInfo.MyEmitterPool != none)
        {
            if (AnimNotifyData.SocketName != 'None')
            {
                PSC = Owner.WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment(AnimNotifyData.PSTemplate, self, AnimNotifyData.SocketName, true);
            }
            else if (AnimNotifyData.BoneName != 'None')
            {
                PSC = Owner.WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment(AnimNotifyData.PSTemplate, self, AnimNotifyData.BoneName, false);
            }
            else if (AnimNotifyData.bLoadIfPhysXLevel1 == true || AnimNotifyData.bLoadIfPhysXLevel2 == true)
            {
                return;
            }
            PSC.SetAbsolute(false, false, false);
            PSC.SetScale(AnimNotifyData.DrawScale);
            PSC.SetIgnoreOwnerHidden(AnimNotifyData.bIgnoreOwnerHiddenIfAttached);
            PSC.ActivateSystem(true);
            PSC.__OnSystemFinished__Delegate = SkelMeshCompAttachedOnParticleSystemFinished;
        }
        else
        {
            PSC = new(self) class'ParticleSystemComponent';
            PSC.SetTemplate(AnimNotifyData.PSTemplate);
            if (AnimNotifyData.SocketName != 'None')
            {
                AttachComponentToSocket(PSC, AnimNotifyData.SocketName);
            }
            else if (AnimNotifyData.BoneName != 'None')
            {
                AttachComponent(PSC, AnimNotifyData.BoneName);
            }
            PSC.SetScale(AnimNotifyData.DrawScale);
            PSC.SetIgnoreOwnerHidden(AnimNotifyData.bIgnoreOwnerHiddenIfAttached);
            PSC.ActivateSystem(true);
            PSC.__OnSystemFinished__Delegate = SkelMeshCompOnParticleSystemFinished;
        }
    }
    else
    {
        if (AnimNotifyData.SocketName != 'None')
        {
            GetSocketWorldLocationAndRotation(AnimNotifyData.SocketName, Loc, Rot);
        }
        else if (AnimNotifyData.BoneName != 'None')
        {
            Loc = GetBoneLocation(AnimNotifyData.BoneName);
            Rot = rot(0, 0, 1);
        }
        else
        {
            Loc = GetPosition();
            Rot = rot(0, 0, 1);
        }
        if (Owner != none && Owner.WorldInfo != none && Owner.WorldInfo.MyEmitterPool != none)
        {
            PSC = Owner.WorldInfo.MyEmitterPool.SpawnEmitter(AnimNotifyData.PSTemplate, Loc, Rot);
            PSC.SetAbsolute(false, false, true);
            PSC.SetScale(AnimNotifyData.DrawScale);
        }
        else if (class'Engine'.static.IsGame() == true)
        {
            PSC = new(self) class'ParticleSystemComponent';
            PSC.SetTemplate(AnimNotifyData.PSTemplate);
            PSC.SetAbsolute(true, true, true);
            PSC.SetTranslation(Loc);
            PSC.SetRotation(Rot);
            PSC.SetScale(AnimNotifyData.DrawScale);
            PSC.ActivateSystem(true);
            PSC.__OnSystemFinished__Delegate = SkelMeshCompOnParticleSystemFinished;
        }
        else if (class'Engine'.static.IsEditor() == true)
        {
            PSC = new(self) class'ParticleSystemComponent';
            PSC.SetTemplate(AnimNotifyData.PSTemplate);
            PSC.SetAbsolute(true, true, true);
            PSC.SetTranslation(Loc);
            PSC.SetRotation(Rot);
            if (AnimNotifyData.SocketName != 'None')
            {
                AttachComponentToSocket(PSC, AnimNotifyData.SocketName);
            }
            else if (AnimNotifyData.BoneName != 'None')
            {
                AttachComponent(PSC, AnimNotifyData.BoneName);
            }
            PSC.SetScale(AnimNotifyData.DrawScale);
            PSC.ActivateSystem(true);
            PSC.__OnSystemFinished__Delegate = SkelMeshCompOnParticleSystemFinished;
        }
    }
}

event bool CreateForceField(const AnimNotify_ForceField AnimNotifyData)
{
    local NxForceFieldComponent NewForceFieldComponent;
    
    NewForceFieldComponent = new(self) AnimNotifyData.ForceFieldComponent.Class(AnimNotifyData.ForceFieldComponent);
    NewForceFieldComponent.DoInitRBPhys();
    if (AnimNotifyData.SocketName != 'None')
    {
        AttachComponentToSocket(NewForceFieldComponent, AnimNotifyData.SocketName);
    }
    else if (AnimNotifyData.BoneName != 'None')
    {
        AttachComponent(NewForceFieldComponent, AnimNotifyData.BoneName);
    }
    return true;
}

function StopAnim()
{
    local AnimNodeSequence AnimNode;
    
    AnimNode = AnimNodeSequence(Animations);
    if (AnimNode == none && Animations.IsA('AnimTree'))
    {
        AnimNode = AnimNodeSequence(AnimTree(Animations).Children[0].Anim);
    }
    if (AnimNode == none)
    {
        WarnInternal("Base animation node is not an AnimNodeSequence (Owner:" @ string(Owner) $ ")");
    }
    else
    {
        AnimNode.StopAnim();
    }
}

function PlayAnim(name AnimName, optional float Duration, optional bool bLoop, optional bool bRestartIfAlreadyPlaying = true, optional float StartTime = 0.0, optional bool bPlayBackwards = false)
{
    local AnimNodeSequence AnimNode;
    local float DesiredRate;
    
    AnimNode = AnimNodeSequence(Animations);
    if (AnimNode == none && Animations.IsA('AnimTree'))
    {
        AnimNode = AnimNodeSequence(AnimTree(Animations).Children[0].Anim);
    }
    if (AnimNode == none)
    {
        WarnInternal("Base animation node is not an AnimNodeSequence (Owner:" @ string(Owner) $ ")");
    }
    else if (AnimNode.AnimSeq != none && AnimNode.AnimSeq.SequenceName == AnimName)
    {
        DesiredRate = (Duration > 0.0 ? AnimNode.AnimSeq.SequenceLength / Duration : 1.0);
        DesiredRate = (bPlayBackwards ? -DesiredRate : DesiredRate);
        if (bRestartIfAlreadyPlaying || !AnimNode.bPlaying)
        {
            AnimNode.PlayAnim(bLoop, DesiredRate, StartTime);
        }
        else
        {
            AnimNode.Rate = DesiredRate;
            AnimNode.bLooping = bLoop;
        }
    }
    else
    {
        AnimNode.SetAnim(AnimName);
        if (AnimNode.AnimSeq != none)
        {
            DesiredRate = (Duration > 0.0 ? AnimNode.AnimSeq.SequenceLength / Duration : 1.0);
            DesiredRate = (bPlayBackwards ? -DesiredRate : DesiredRate);
            AnimNode.PlayAnim(bLoop, DesiredRate, StartTime);
        }
    }
}

native final simulated function ShowMaterialSection(int MaterialID, bool bShow)
{
    MaterialID;
    bShow;
}

native final simulated function UpdateMeshForBrokenConstraints()
{
}

native final function UnHideBoneByName(name BoneName)
{
    BoneName;
}

native final function HideBoneByName(name BoneName, EPhysBodyOp PhysBodyOption)
{
    BoneName;
    PhysBodyOption;
}

native final function bool IsBoneHidden(int BoneIndex)
{
    BoneIndex;
}

native final function UnHideBone(int BoneIndex)
{
    BoneIndex;
}

native final function HideBone(int BoneIndex, EPhysBodyOp PhysBodyOption)
{
    BoneIndex;
    PhysBodyOption;
}

native final function SetFaceFXRegisterEx(string RegName, EFaceFXRegOp RegOp, float FirstValue, float FirstInterpDuration, float NextValue, float NextInterpDuration)
{
    RegName;
    RegOp;
    FirstValue;
    FirstInterpDuration;
    NextValue;
    NextInterpDuration;
}

native final function SetFaceFXRegister(string RegName, float RegVal, EFaceFXRegOp RegOp, optional float InterpDuration)
{
    RegName;
    RegVal;
    RegOp;
    InterpDuration;
}

native final function float GetFaceFXRegister(string RegName)
{
    RegName;
}

native final function DeclareFaceFXRegister(string RegName)
{
    RegName;
}

native final function bool IsPlayingFaceFXAnim()
{
}

native final function StopFaceFXAnim()
{
}

native final function bool PlayFaceFXAnim(FaceFXAnimSet FaceFXAnimSetRef, string AnimName, string GroupName, SoundCue SoundCueToPlay)
{
    FaceFXAnimSetRef;
    AnimName;
    GroupName;
    SoundCueToPlay;
}

native final function ToggleInstanceVertexWeights(bool bEnable)
{
    bEnable;
}

native final function UpdateInstanceVertexWeightBones(array<BonePair> BonePairs)
{
    BonePairs;
}

native final function int FindInstanceVertexweightBonePair(BonePair Bones)
{
    Bones;
}

native final function RemoveInstanceVertexWeightBoneParented(name BoneName)
{
    BoneName;
}

native final function AddInstanceVertexWeightBoneParented(name BoneName, optional bool bPairWithParent = true)
{
    BoneName;
    bPairWithParent;
}

native final function bool GetBonesWithinRadius(Vector Origin, float Radius, int TraceFlags, out array<name> out_Bones)
{
    Origin;
    Radius;
    TraceFlags;
    out_Bones;
}

native final function UpdateAnimations()
{
}

native final function ForceSkelUpdate()
{
}

native final function UpdateRBBonesFromSpaceBases(bool bMoveUnfixedBodies, bool bTeleport)
{
    bMoveUnfixedBodies;
    bTeleport;
}

native final function SetHasPhysicsAssetInstance(bool bHasInstance)
{
    bHasInstance;
}

native final function RB_BodyInstance FindBodyInstanceNamed(name BoneName)
{
    BoneName;
}

native final function name FindConstraintBoneName(int ConstraintIndex)
{
    ConstraintIndex;
}

native final function int FindConstraintIndex(name ConstraintName)
{
    ConstraintName;
}

native final function InitMorphTargets()
{
}

native final function InitSkelControls()
{
}

native final function UpdateParentBoneMap()
{
}

native final function SetParentAnimComponent(SkeletalMeshComponent NewParentAnimComp)
{
    NewParentAnimComp;
}

native final function SetAnimTreeTemplate(AnimTree NewTemplate)
{
    NewTemplate;
}

native final function Vector GetClosestCollidingBoneLocation(Vector TestLocation, bool bCheckZeroExtent, bool bCheckNonZeroExtent)
{
    TestLocation;
    bCheckZeroExtent;
    bCheckNonZeroExtent;
}

native final function name FindClosestBone(Vector TestLocation, optional out Vector BoneLocation, optional float IgnoreScale)
{
    TestLocation;
    BoneLocation;
    IgnoreScale;
}

native final function TransformFromBoneSpace(name BoneName, Vector InPosition, Rotator InRotation, out Vector OutPosition, out Rotator OutRotation)
{
    BoneName;
    InPosition;
    InRotation;
    OutPosition;
    OutRotation;
}

native final function TransformToBoneSpace(name BoneName, Vector InPosition, Rotator InRotation, out Vector OutPosition, out Rotator OutRotation)
{
    BoneName;
    InPosition;
    InRotation;
    OutPosition;
    OutRotation;
}

native final function Vector GetBoneAxis(name BoneName, EAxis Axis)
{
    BoneName;
    Axis;
}

native final function Vector GetRefPosePosition(int BoneIndex)
{
    BoneIndex;
}

native final function bool BoneIsChildOf(name BoneName, name ParentBoneName)
{
    BoneName;
    ParentBoneName;
}

native final function GetBoneNames(out array<name> BoneNames)
{
    BoneNames;
}

native final function name GetParentBone(name BoneName)
{
    BoneName;
}

native final function Matrix GetBoneMatrix(int BoneIndex)
{
    BoneIndex;
}

native final function name GetBoneName(int BoneIndex)
{
    BoneIndex;
}

native final function int MatchRefBone(name BoneName)
{
    BoneName;
}

native final function Vector GetPhysicsAssetBoneLocation(name BoneName, optional int Space)
{
    BoneName;
    Space;
}

native final function Vector GetBoneLocation(name BoneName, optional int Space)
{
    BoneName;
    Space;
}

native final function Quat GetBoneQuaternion(name BoneName, optional int Space)
{
    BoneName;
    Space;
}

native final function MorphNodeBase FindMorphNode(name InNodeName)
{
    InNodeName;
}

native final function SkelControlBase FindSkelControl(name InControlName)
{
    InControlName;
}

native final iterator function AllAnimNodes(class<AnimNode> BaseClass, out AnimNode Node)
{
    BaseClass;
    Node;
}

native final function AnimNode FindAnimNode(name InNodeName)
{
    InNodeName;
}

native final function MorphTarget FindMorphTarget(name MorphTargetName)
{
    MorphTargetName;
}

final function float GetAnimLength(name AnimSeqName)
{
    local AnimSequence AnimSeq;
    
    AnimSeq = FindAnimSequence(AnimSeqName);
    if (AnimSeq == none)
    {
        return 0.0;
    }
    return AnimSeq.SequenceLength / AnimSeq.RateScale;
}

final function float GetAnimRateByDuration(name AnimSeqName, float Duration)
{
    local AnimSequence AnimSeq;
    
    AnimSeq = FindAnimSequence(AnimSeqName);
    if (AnimSeq == none)
    {
        return 1.0;
    }
    return AnimSeq.SequenceLength / Duration;
}

native final function ActiveFakeRootMotion()
{
}

native final function SetFakeRootMotionPara(float fScale, float TotalTime, int Precision, Rotator vecRot)
{
    fScale;
    TotalTime;
    Precision;
    vecRot;
}

native final function RestoreSavedAnimSets()
{
}

native final function SaveAnimSets()
{
}

native final function AnimSequence FindAnimSequence(name AnimSeqName)
{
    AnimSeqName;
}

native final simulated function WakeSoftBody()
{
}

native final simulated function SetSoftBodyFrozen(bool bNewFrozen)
{
    bNewFrozen;
}

native final simulated function UpdateSoftBodyParams()
{
}

native final simulated function SetClothValidBounds(Vector ClothValidBoundsMin, Vector ClothValidBoundsMax)
{
    ClothValidBoundsMin;
    ClothValidBoundsMax;
}

native final simulated function EnableClothValidBounds(bool IfEnableClothValidBounds)
{
    IfEnableClothValidBounds;
}

native final simulated function AttachClothToCollidingShapes(bool AttatchTwoWay, bool AttachTearable)
{
    AttatchTwoWay;
    AttachTearable;
}

native final simulated function SetClothVelocity(Vector VelocityOffSet)
{
    VelocityOffSet;
}

native final simulated function SetClothPosition(Vector ClothOffSet)
{
    ClothOffSet;
}

native final simulated function SetClothSleep(bool IfClothSleep)
{
    IfClothSleep;
}

native final simulated function SetClothThickness(float ClothThickness)
{
    ClothThickness;
}

native final simulated function SetClothTearFactor(float ClothTearFactor)
{
    ClothTearFactor;
}

native final simulated function SetClothStretchingStiffness(float ClothStretchingStiffness)
{
    ClothStretchingStiffness;
}

native final simulated function SetClothSolverIterations(int ClothSolverIterations)
{
    ClothSolverIterations;
}

native final simulated function SetClothSleepLinearVelocity(float ClothSleepLinearVelocity)
{
    ClothSleepLinearVelocity;
}

native final simulated function SetClothPressure(float ClothPressure)
{
    ClothPressure;
}

native final simulated function SetClothFriction(float ClothFriction)
{
    ClothFriction;
}

native final simulated function SetClothFlags(int ClothFlags)
{
    ClothFlags;
}

native final simulated function SetClothDampingCoefficient(float ClothDampingCoefficient)
{
    ClothDampingCoefficient;
}

native final simulated function SetClothCollisionResponseCoefficient(float ClothCollisionResponseCoefficient)
{
    ClothCollisionResponseCoefficient;
}

native final simulated function SetClothBendingStiffness(float ClothBendingStiffness)
{
    ClothBendingStiffness;
}

native final simulated function SetClothAttachmentTearFactor(float ClothAttachTearFactor)
{
    ClothAttachTearFactor;
}

native final simulated function SetClothAttachmentResponseCoefficient(float ClothAttachmentResponseCoefficient)
{
    ClothAttachmentResponseCoefficient;
}

native final simulated function float GetClothThickness()
{
}

native final simulated function float GetClothTearFactor()
{
}

native final simulated function float GetClothStretchingStiffness()
{
}

native final simulated function int GetClothSolverIterations()
{
}

native final simulated function float GetClothSleepLinearVelocity()
{
}

native final simulated function float GetClothPressure()
{
}

native final simulated function float GetClothFriction()
{
}

native final simulated function int GetClothFlags()
{
}

native final simulated function float GetClothDampingCoefficient()
{
}

native final simulated function float GetClothCollisionResponseCoefficient()
{
}

native final simulated function float GetClothBendingStiffness()
{
}

native final simulated function float GetClothAttachmentTearFactor()
{
}

native final simulated function float GetClothAttachmentResponseCoefficient()
{
}

native final simulated function ResetClothVertsToRefPose()
{
}

native final simulated function SetAttachClothVertsToBaseBody(bool bAttachVerts)
{
    bAttachVerts;
}

native final simulated function SetClothExternalForce(Vector InForce)
{
    InForce;
}

native final simulated function UpdateClothParams()
{
}

native final simulated function SetEnableClothingSimulation(bool bInEnable)
{
    bInEnable;
}

native final simulated function SetClothFrozen(bool bNewFrozen)
{
    bNewFrozen;
}

native final simulated function SetEnableClothSimulation(bool bInEnable)
{
    bInEnable;
}

native final simulated function SetForceRefPose(bool bNewForceRefPose)
{
    bNewForceRefPose;
}

native final simulated function SetPhysicsAsset(PhysicsAsset NewPhysicsAsset, optional bool bForceReInit)
{
    NewPhysicsAsset;
    bForceReInit;
}

native final simulated function bool SetRefSkelMesh(SkeletalMesh NewMesh)
{
    NewMesh;
}

native final simulated function SetSkeletalMesh(SkeletalMesh NewMesh, optional bool bKeepSpaceBases, optional bool InbAlwaysUseInstanceWeights)
{
    NewMesh;
    bKeepSpaceBases;
    InbAlwaysUseInstanceWeights;
}

native final iterator function AttachedComponents(class<ActorComponent> BaseClass, out ActorComponent OutComponent)
{
    BaseClass;
    OutComponent;
}

native final function bool IsComponentAttached(ActorComponent Component, optional name BoneName)
{
    Component;
    BoneName;
}

native final function ActorComponent FindComponentAttachedToBone(name InBoneName)
{
    InBoneName;
}

native final function name GetSocketBoneName(name InSocketName)
{
    InSocketName;
}

native final function SkeletalMeshSocket GetSocketByName(name InSocketName)
{
    InSocketName;
}

native final function bool GetSocketWorldLocationAndRotation(name InSocketName, out Vector OutLocation, optional out Rotator OutRotation, optional int Space)
{
    InSocketName;
    OutLocation;
    OutRotation;
    Space;
}

native final function AttachComponentToSocket(ActorComponent Component, name SocketName)
{
    Component;
    SocketName;
}

native final function DetachComponent(ActorComponent Component)
{
    Component;
}

native final function AttachComponent(ActorComponent Component, name BoneName, optional Vector RelativeLocation, optional Rotator RelativeRotation, optional Vector RelativeScale)
{
    Component;
    BoneName;
    RelativeLocation;
    RelativeRotation;
    RelativeScale;
}

defaultproperties
{
    GlobalAnimRateScale=1.0
    WireframeColor=(B=28,G=221,R=221,A=255)
    bTransformFromAnimParent=1
    FakeRootMotionInvMassScale=1.0
    FakeRootMotionTimeScale=1.0
    FakeRootMotionCurrentTime=-1.0
    bUpdateSkelWhenNotRendered=True
    bTickAnimNodesWhenNotRendered=True
    bUpdateKinematicBonesFromAnimation=True
    bSyncActorLocationToRootRigidBody=True
    LineCheckBoundsScale=(X=1.0,Y=1.0,Z=1.0)
    bAutoFreezeClothWhenNotRendered=True
    bCacheAnimSequenceNodes=True
    ClothBlendWeight=1.0
    ClothBlendMinDistanceFactor=-1.0
    ClothRBChannel="RBCC_Cloth"
    ClothImpulseScale=1.0
    ClothAttachmentTearFactor=-1.0
    MinDistanceForClothReset=256.0
    ApexClothingRBChannel="RBCC_Clothing"
    ApexClothingRBCollideWithChannels=(Default=True,Nothing=False,Pawn=False,Vehicle=False,Water=False,GameplayPhysics=True,EffectPhysics=True,Untitled1=False,Untitled2=False,Untitled3=False,Untitled4=False,Cloth=False,FluidDrain=False,SoftBody=False,FracturedMeshPart=False,BlockingVolume=True,DeadPawn=False,Clothing=False,ClothingCollision=True)
    bAutoFreezeApexClothingWhenNotRendered=True
    SoftBodyImpulseScale=1.0
    bSoftBodyUseCompartment=True
    SoftBodyRBChannel="RBCC_SoftBody"
    RootMotionAccelScale=(X=1.0,Y=1.0,Z=1.0)
    FakeRootMotionAccelScale=(X=1.0,Y=1.0,Z=1.0)
    RootMotionMode="RMM_Ignore"
    FakeRootMotionMode="RMM_Ignore"
    PreviousRMM="RMM_Ignore"
    FaceFXBlendMode="FXBM_Additive"
    ProgressiveDrawingFraction=1.0
    ReplacementPrimitive="None"
    bAcceptsStaticDecals=True
    bCullModulatedShadowOnBackfaces=False
    TickGroup="TG_PreAsyncWork"
}

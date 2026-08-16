class PrimitiveComponent extends ActorComponent
    abstract
    native
    noexport
    notplaceable;

enum ERadialImpulseFalloff
{
    RIF_Constant,
    RIF_Linear,
};

enum GJKResult
{
    GJK_Intersect,
    GJK_NoIntersection,
    GJK_Fail,
};

enum EBillboardType
{
    BB_ViewPlane_Aligned,
    BB_ViewPlane_Aligned_X,
    BB_ViewPlane_Aligned_Y,
    BB_ViewPlane_Aligned_Z,
    BB_ViewPoint_Oriented,
    BB_ViewPoint_Oriented_X,
    BB_ViewPoint_Oriented_Y,
    BB_ViewPoint_Oriented_Z,
};

enum ERBCollisionChannel
{
    RBCC_Default,
    RBCC_Nothing,
    RBCC_Pawn,
    RBCC_Vehicle,
    RBCC_Water,
    RBCC_GameplayPhysics,
    RBCC_EffectPhysics,
    RBCC_Untitled1,
    RBCC_Untitled2,
    RBCC_Untitled3,
    RBCC_Untitled4,
    RBCC_Cloth,
    RBCC_FluidDrain,
    RBCC_SoftBody,
    RBCC_FracturedMeshPart,
    RBCC_BlockingVolume,
    RBCC_DeadPawn,
    RBCC_Clothing,
    RBCC_ClothingCollision,
};

struct RBCollisionChannelContainer
{
    var() const bool Default;
    var const bool Nothing;
    var() const bool Pawn;
    var() const bool Vehicle;
    var() const bool Water;
    var() const bool GameplayPhysics;
    var() const bool EffectPhysics;
    var() const bool Untitled1;
    var() const bool Untitled2;
    var() const bool Untitled3;
    var() const bool Untitled4;
    var() const bool Cloth;
    var() const bool FluidDrain;
    var() const bool SoftBody;
    var() const bool FracturedMeshPart;
    var() const bool BlockingVolume;
    var() const bool DeadPawn;
    var() const bool Clothing;
    var() const bool ClothingCollision;
};

struct MaterialViewRelevance
{
    var bool bOpaque;
    var bool bTranslucent;
    var bool bDistortion;
    var bool bOneLayerDistortionRelevance;
    var bool bLit;
    var bool bUsesSceneColor;
};

var const native transient Pointer SceneInfo;
var const native int DetachFence;
var const native transient AlignedBoxSphereBounds Bounds;
var const native transient float LocalToWorldDeterminant;
var const native transient Matrix LocalToWorld;
var const native transient int MotionBlurInfoIndex;
var const native array<Pointer> DecalList;
var const transient export editinline array<DecalComponent> DecalsToReattach;
var const native transient int Tag;
var const export editinline PrimitiveComponent ShadowParent;
var float ForceTranslucencyAlpha;
var float ForceTranslucencyTargetAlpha;
var float ForceTranslucencyBlendTime;
var float ForceTranslucencyBlendSpeed;
var(Rendering) export editinline PrimitiveComponent ReplacementPrimitive;
var const transient export editinline FogVolumeDensityComponent FogVolumeComponent;
var const export editinline LightEnvironmentComponent LightEnvironment;
var const transient export editinline LightEnvironmentComponent PreviousLightEnvironment;
var(Rendering) float MinDrawDistance;
var(Rendering) float MassiveLODDistance;
var(Rendering) const noexport float MaxDrawDistance;
var(Rendering) editconst float CachedMaxDrawDistance;
var const noexport deprecated float CullDistance;
var editconst deprecated float CachedCullDistance;
var(Rendering) const ESceneDepthPriorityGroup DepthPriorityGroup;
var const ESceneDepthPriorityGroup ViewOwnerDepthPriorityGroup;
var(Rendering) const EDetailMode DetailMode;
var(Collision) const ERBCollisionChannel RBChannel;
var(Physics) byte RBDominanceGroup;
var(Rendering) EBillboardType BillboardType;
var(Rendering) float MotionBlurScale;
var const bool bUseViewOwnerDepthPriorityGroup;
var(Rendering) const bool bAllowCullDistanceVolume;
var(Rendering) const bool HiddenGame;
var(Rendering) const bool HiddenEditor;
var(Rendering) const bool bOwnerNoSee;
var(Rendering) const bool bOnlyOwnerSee;
var(Rendering) const bool bIgnoreOwnerHidden;
var bool bUseAsOccluder;
var(Rendering) bool bAllowApproximateOcclusion;
var bool bFirstFrameOcclusion;
var bool bIgnoreNearPlaneIntersection;
var bool bSelectable;
var(Rendering) const bool bForceMipStreaming;
var const deprecated bool bAcceptsDecals;
var const deprecated bool bAcceptsDecalsDuringGameplay;
var(Rendering) const bool bAcceptsStaticDecals;
var(Rendering) const bool bAcceptsDynamicDecals;
var const native transient bool bIsRefreshingDecals;
var native transient bool bAllowDecalAutomaticReAttach;
var bool bAllowDecalRemovalOnDetach;
var(Rendering) const bool bAcceptsFoliage;
var(Lighting) bool CastShadow;
var(Lighting) const bool bForceDirectLightMap;
var(Lighting) bool bCastDynamicShadow;
var(Lighting) bool bSelfShadowOnly;
var(Lighting) bool bAcceptsDynamicDominantLightShadows;
var(Lighting) bool bCastHiddenShadow;
var(Lighting) const bool bAcceptsLights;
var(Lighting) const bool bAcceptsDynamicLights;
var(Lighting) const bool bUsePrecomputedShadows;
var const transient bool bHasExplicitShadowParent;
var(Lighting) bool bCullModulatedShadowOnBackfaces;
var(Lighting) bool bCullModulatedShadowOnEmissive;
var(Lighting) bool bAllowAmbientOcclusion;
var const bool CollideActors;
var const bool AlwaysCheckCollision;
var const bool BlockActors;
var const bool BlockZeroExtent;
var const bool BlockNonZeroExtent;
var(Collision) const bool CanBlockCamera;
var(Collision) const bool BlockRigidBody;
var(Collision) const bool DisableCameraForceTranslucency;
var(Collision) const bool BlockRigidBodyPhysX;
var(Physics) bool bDisableAllRigidBody;
var(Physics) const bool bSkipRBGeomCreation;
var(Physics) const bool bNotifyRigidBodyCollision;
var(Physics) const bool bNotifyRigidBodyCollisionPhysX;
var(Physics) const bool bFluidDrain;
var(Physics) const bool bFluidTwoWay;
var(Physics) bool bIgnoreRadialImpulse;
var(Physics) bool bIgnoreRadialForce;
var(Physics) bool bIgnoreForceField;
var(Physics) const bool bUseCompartment;
var const bool AlwaysLoadOnClient;
var const bool AlwaysLoadOnServer;
var() bool bIgnoreHiddenActorsMembership;
var() const bool AbsoluteTranslation;
var() const bool AbsoluteRotation;
var() const bool AbsoluteScale;
var(Lighting) bool bAllowShadowFade;
var const native transient bool bWasSNFiltered;
var(Rendering) bool bImportantPrimitive;
var(Rendering) bool bPrivateTranslucencyPrepass;
var(Rendering) bool bPrivateTranslucencyPostpass;
var(Rendering) bool bTranslucencyUpdateDepthValue;
var bool bForceTranslucency;
var(Rendering) bool bBillboard;
var const native transient array<int> OctreeNodes;
var(Rendering) int DepthBiasLevel;
var(Rendering) int TranslucencySortPriority;
var(Rendering) float TranslucencyDepthOnlyAlpha;
var(Lighting) const LightingChannelContainer LightingChannels;
var(Collision) const RBCollisionChannelContainer RBCollideWithChannels;
var(Physics) const PhysicalMaterial PhysMaterialOverride;
var const native duplicatetransient RB_BodyInstance BodyInstance;
var const native transient Matrix CachedParentToWorld;
var() const Vector Translation;
var() const Rotator Rotation;
var() const float Scale;
var() const Vector Scale3D;
var const transient float LastSubmitTime;
var transient float LastRenderTime;
var float ScriptRigidBodyCollisionThreshold;

native function bool EnableForceTranslucency(bool bEnable, float fAlpha, float BlendTime, optional int SortPriority = 0, optional bool bCameraForceTranslucency = true)
{
    bEnable;
    fAlpha;
    BlendTime;
    SortPriority;
    bCameraForceTranslucency;
}

native function GJKResult ClosestPointOnComponentToComponent(out PrimitiveComponent OtherComponent, out Vector PointOnComponentA, out Vector PointOnComponentB)
{
    OtherComponent;
    PointOnComponentA;
    PointOnComponentB;
}

native final function GJKResult ClosestPointOnComponentToPoint(out Vector POI, out Vector Extent, out Vector OutPointA, out Vector OutPointB)
{
    POI;
    Extent;
    OutPointA;
    OutPointB;
}

native final function Rotator GetRotation()
{
}

final function Vector GetPosition()
{
    local Vector Position;
    
    Position.X = LocalToWorld.WPlane.X;
    Position.Y = LocalToWorld.WPlane.Y;
    Position.Z = LocalToWorld.WPlane.Z;
    return Position;
}

native function SetAbsolute(optional bool NewAbsoluteTranslation, optional bool NewAbsoluteRotation, optional bool NewAbsoluteScale)
{
    NewAbsoluteTranslation;
    NewAbsoluteRotation;
    NewAbsoluteScale;
}

native function SetScale3D(Vector NewScale3D)
{
    NewScale3D;
}

native function SetScale(float NewScale)
{
    NewScale;
}

native function SetRotation(Rotator NewRotation)
{
    NewRotation;
}

native function SetTranslation(Vector NewTranslation)
{
    NewTranslation;
}

native final function SetActorCollision(bool NewCollideActors, bool NewBlockActors, optional bool NewAlwaysCheckCollision)
{
    NewCollideActors;
    NewBlockActors;
    NewAlwaysCheckCollision;
}

native final function SetTraceBlocking(bool NewBlockZeroExtent, bool NewBlockNonZeroExtent)
{
    NewBlockZeroExtent;
    NewBlockNonZeroExtent;
}

native final function SetViewOwnerDepthPriorityGroup(bool bNewUseViewOwnerDepthPriorityGroup, ESceneDepthPriorityGroup NewViewOwnerDepthPriorityGroup)
{
    bNewUseViewOwnerDepthPriorityGroup;
    NewViewOwnerDepthPriorityGroup;
}

native final function SetDepthPriorityGroup(ESceneDepthPriorityGroup NewDepthPriorityGroup)
{
    NewDepthPriorityGroup;
}

native final function SetLightingChannels(LightingChannelContainer NewLightingChannels)
{
    NewLightingChannels;
}

native final function SetCullDistance(float NewCullDistance)
{
    NewCullDistance;
}

native final function SetLightEnvironment(LightEnvironmentComponent NewLightEnvironment)
{
    NewLightEnvironment;
}

native final function SetShadowParent(PrimitiveComponent NewShadowParent)
{
    NewShadowParent;
}

native final function SetIgnoreOwnerHidden(bool bNewIgnoreOwnerHidden)
{
    bNewIgnoreOwnerHidden;
}

native final function SetOnlyOwnerSee(bool bNewOnlyOwnerSee)
{
    bNewOnlyOwnerSee;
}

native final function SetOwnerNoSee(bool bNewOwnerNoSee)
{
    bNewOwnerNoSee;
}

native final function SetHidden(bool NewHidden)
{
    NewHidden;
}

native final function SetRBDominanceGroup(byte InDomGroup)
{
    InDomGroup;
}

native final function RB_BodyInstance GetRootBodyInstance()
{
}

native final function SetPhysMaterialOverride(PhysicalMaterial NewPhysMaterial)
{
    NewPhysMaterial;
}

native final function InitRBPhys()
{
}

native final function SetNotifyRigidBodyCollision(bool bNewNotifyRigidBodyCollision)
{
    bNewNotifyRigidBodyCollision;
}

native final function SetRBChannel(ERBCollisionChannel Channel)
{
    Channel;
}

native final function SetRBCollisionChannels(RBCollisionChannelContainer Channels)
{
    Channels;
}

native final function SetRBCollidesWithChannel(ERBCollisionChannel Channel, bool bNewCollides)
{
    Channel;
    bNewCollides;
}

native final function SetBlockRigidBody(bool bNewBlockRigidBody)
{
    bNewBlockRigidBody;
}

native final function bool RigidBodyIsAwake(optional name BoneName)
{
    BoneName;
}

native final function PutRigidBodyToSleep(optional name BoneName)
{
    BoneName;
}

native final function WakeRigidBody(optional name BoneName)
{
    BoneName;
}

native final function SetRBRotation(Rotator NewRot, optional name BoneName)
{
    NewRot;
    BoneName;
}

native final function SetRBPosition(Vector NewPos, optional name BoneName)
{
    NewPos;
    BoneName;
}

native final function RetardRBLinearVelocity(Vector RetardDir, float VelScale)
{
    RetardDir;
    VelScale;
}

native final function SetRBMaxAngularVelocity(float MaxAngularVelocity)
{
    MaxAngularVelocity;
}

native final function SetRBAngularVelocity(Vector NewAngVel, optional bool bAddToCurrent)
{
    NewAngVel;
    bAddToCurrent;
}

native final function SetRBLinearVelocity(Vector NewVel, optional bool bAddToCurrent)
{
    NewVel;
    bAddToCurrent;
}

native final function AddTorqueImpulse(Vector Torque, optional name BoneName)
{
    Torque;
    BoneName;
}

native final function AddTorque(Vector Torque, optional name BoneName)
{
    Torque;
    BoneName;
}

native final function AddRadialForce(Vector Origin, float Radius, float Strength, ERadialImpulseFalloff Falloff)
{
    Origin;
    Radius;
    Strength;
    Falloff;
}

native final function AddForce(Vector Force, optional Vector Position, optional name BoneName)
{
    Force;
    Position;
    BoneName;
}

native final function AddRadialImpulse(Vector Origin, float Radius, float Strength, ERadialImpulseFalloff Falloff, optional bool bVelChange)
{
    Origin;
    Radius;
    Strength;
    Falloff;
    bVelChange;
}

native final function AddImpulse(Vector Impulse, optional Vector Position, optional name BoneName, optional bool bVelChange)
{
    Impulse;
    Position;
    BoneName;
    bVelChange;
}

defaultproperties
{
    ForceTranslucencyAlpha=1.0
    ReplacementPrimitive="None"
    DepthPriorityGroup="SDPG_World"
    RBDominanceGroup=15
    MotionBlurScale=1.0
    bAllowCullDistanceVolume=True
    bSelectable=True
    bAcceptsDynamicDecals=True
    bAllowDecalRemovalOnDetach=True
    bAcceptsFoliage=True
    bCastDynamicShadow=True
    bAcceptsDynamicDominantLightShadows=True
    bAcceptsDynamicLights=True
    bAllowAmbientOcclusion=True
    CanBlockCamera=True
    DisableCameraForceTranslucency=True
    AlwaysLoadOnClient=True
    AlwaysLoadOnServer=True
    bAllowShadowFade=True
    TranslucencyDepthOnlyAlpha=1.0
    Scale=1.0
    Scale3D=(X=1.0,Y=1.0,Z=1.0)
    LastRenderTime=-1000.0
}

class SkeletalMesh extends Object
    native
    noexport
    notplaceable
    hidecategories(Object);

enum SoftBodyBoneType
{
    SOFTBODYBONE_Fixed,
    SOFTBODYBONE_BreakableAttachment,
    SOFTBODYBONE_TwoWayAttachment,
};

enum ClothBoneType
{
    CLOTHBONE_Fixed,
    CLOTHBONE_BreakableAttachment,
    CLOTHBONE_TearLine,
};

enum ClothMovementScaleGen
{
    ECMDM_DistToFixedVert,
    ECMDM_VertexBoneWeight,
    ECMDM_Empty,
};

enum TriangleSortOption
{
    TRISORT_None,
    TRISORT_CenterRadialDistance,
    TRISORT_Random,
    TRISORT_Tootle,
    TRISORT_Custom,
};

struct native SoftBodySpecialBoneInfo
{
    var() name BoneName;
    var() SoftBodyBoneType BoneType;
    var const array<int> AttachedVertexIndices;
};

struct native SoftBodyTetraLink
{
    var int Index;
    var Vector Bary;
};

struct native VertexModifierParam
{
    var() Vector FixedPoint;
    var() float Amplitude;
    var() float Frequency;
    var() float Speed;
    var() float Intensity;
    var() Vector DirRefPoint;
};

struct native ClothSpecialBoneInfo
{
    var() name BoneName;
    var() ClothBoneType BoneType;
    var const array<int> AttachedVertexIndices;
};

struct native SkeletalMeshLODInfo
{
    var() float DisplayFactor;
    var() float LODHysteresis;
    var() editfixedsize array<int> LODMaterialMap;
    var() editfixedsize array<bool> bEnableShadowCasting;
    var() editfixedsize array<TriangleSortOption> TriangleSorting;
};

struct native BoneMirrorExport
{
    var() name BoneName;
    var() name SourceBoneName;
    var() EAxis BoneFlipAxis;
};

struct native BoneMirrorInfo
{
    var() int SourceIndex;
    var() EAxis BoneFlipAxis;
};

var const native BoxSphereBounds Bounds;
var() const native array<MaterialInterface> Materials;
var() const native array<ApexClothingAsset> ClothingAssets;
var() const native Vector Origin;
var() const native Rotator RotOrigin;
var const native array<int> RefSkeleton;
var const native int SkeletalDepth;
var const native map<int, int> NameIndexMap;
var const native IndirectArray_Mirror LODModels;
var const native array<BoneTransform> RefBasesInvMatrix;
var() editfixedsize array<BoneMirrorInfo> SkelMirrorTable;
var() EAxis SkelMirrorAxis;
var() EAxis SkelMirrorFlipAxis;
var array<SkeletalMeshSocket> Sockets;
var() const native editconst array<string> BoneBreakNames;
var() editfixedsize array<SkeletalMeshLODInfo> LODInfo;
var() array<name> PerPolyCollisionBones;
var() array<name> AddToParentPerPolyCollisionBone;
var const native array<int> PerPolyBoneKDOPs;
var() bool bPerPolyUseSoftWeighting;
var() bool bUseSimpleLineCollision;
var() bool bUseSimpleBoxCollision;
var() const bool bForceCPUSkinning;
var() const bool bUseFullPrecisionUVs;
var() const bool bUsePackedPosition;
var() FaceFXAsset FaceFXAsset;
var() editoronly PhysicsAsset BoundsPreviewAsset;
var() editoronly array<MorphTargetSet> PreviewMorphSets;
var() int LODBiasPC;
var() int LODBiasPS3;
var() int LODBiasXbox360;
var() const editconst editoronly string SourceFilePath;
var() const editconst editoronly string SourceFileTimestamp;
var const native transient array<Pointer> ClothMesh;
var const native transient array<float> ClothMeshScale;
var const array<int> ClothToGraphicsVertMap;
var const array<float> ClothMovementScale;
var(Cloth) ClothMovementScaleGen ClothMovementScaleGenMode;
var(Cloth) float ClothToAnimMeshMaxDist;
var(Cloth) bool bLimitClothToAnimMesh;
var const array<int> ClothWeldingMap;
var const int ClothWeldingDomain;
var const array<int> ClothWeldedIndices;
var(ClothAdvanced) const bool bForceNoWelding;
var const int NumFreeClothVerts;
var const array<int> ClothIndexBuffer;
var(Cloth) const array<name> ClothBones;
var(Cloth) const int ClothHierarchyLevels;
var(Cloth) const bool bEnableClothBendConstraints;
var(Cloth) const bool bEnableClothDamping;
var(Cloth) const bool bUseClothCOMDamping;
var(Cloth) const float ClothStretchStiffness;
var(Cloth) const float ClothBendStiffness;
var(Cloth) const float ClothDensity;
var(Cloth) const float ClothThickness;
var(Cloth) const float ClothDamping;
var(Cloth) const int ClothIterations;
var(Cloth) const int ClothHierarchicalIterations;
var(Cloth) const float ClothFriction;
var(ClothAdvanced) const float ClothRelativeGridSpacing;
var(ClothAdvanced) const float ClothPressure;
var(ClothAdvanced) const float ClothCollisionResponseCoefficient;
var(ClothAdvanced) const float ClothAttachmentResponseCoefficient;
var(ClothAdvanced) const float ClothAttachmentTearFactor;
var(ClothAdvanced) const float ClothSleepLinearVelocity;
var(Cloth) const float HardStretchLimitFactor;
var(Cloth) const bool bHardStretchLimit;
var(ClothAdvanced) const bool bEnableClothOrthoBendConstraints;
var(ClothAdvanced) const bool bEnableClothSelfCollision;
var(ClothAdvanced) const bool bEnableClothPressure;
var(ClothAdvanced) const bool bEnableClothTwoWayCollision;
var(ClothAdvanced) const array<ClothSpecialBoneInfo> ClothSpecialBones;
var(Cloth) const bool bEnableClothLineChecks;
var(ClothAdvanced) const bool bClothMetal;
var(ClothAdvanced) const float ClothMetalImpulseThreshold;
var(ClothAdvanced) const float ClothMetalPenetrationDepth;
var(ClothAdvanced) const float ClothMetalMaxDeformationDistance;
var(Cloth) const bool bEnableClothTearing;
var(Cloth) const float ClothTearFactor;
var(Cloth) const int ClothTearReserve;
var(Cloth) bool bEnableValidBounds;
var(Cloth) Vector ValidBoundsMin;
var(Cloth) Vector ValidBoundsMax;
var(Cloth) bool bDressFloating;
var(Cloth) VertexModifierParam DressFloatingParam;
var(Cloth) bool bVertexDisturbanceEnabled;
var(Cloth) bool bDisturbClothVertex;
var const native Map_Mirror ClothTornTriMap;
var const array<int> SoftBodySurfaceToGraphicsVertMap;
var const array<int> SoftBodySurfaceIndices;
var const array<Vector> SoftBodyTetraVertsUnscaled;
var const array<int> SoftBodyTetraIndices;
var const array<SoftBodyTetraLink> SoftBodyTetraLinks;
var const native transient array<Pointer> CachedSoftBodyMeshes;
var const native transient array<float> CachedSoftBodyMeshScales;
var(SoftBody) const array<name> SoftBodyBones;
var(SoftBody) const array<SoftBodySpecialBoneInfo> SoftBodySpecialBones;
var(SoftBody) const float SoftBodyVolumeStiffness;
var(SoftBody) const float SoftBodyStretchingStiffness;
var(SoftBody) const float SoftBodyDensity;
var(SoftBody) const float SoftBodyParticleRadius;
var(SoftBody) const float SoftBodyDamping;
var(SoftBody) const int SoftBodySolverIterations;
var(SoftBody) const float SoftBodyFriction;
var(SoftBody) const float SoftBodyRelativeGridSpacing;
var(SoftBody) const float SoftBodySleepLinearVelocity;
var(SoftBody) const bool bEnableSoftBodySelfCollision;
var(SoftBody) const float SoftBodyAttachmentResponse;
var(SoftBody) const float SoftBodyCollisionResponse;
var(SoftBody) const float SoftBodyDetailLevel;
var(SoftBody) const int SoftBodySubdivisionLevel;
var(SoftBody) const bool bSoftBodyIsoSurface;
var(SoftBody) const bool bEnableSoftBodyDamping;
var(SoftBody) const bool bUseSoftBodyCOMDamping;
var(SoftBody) const float SoftBodyAttachmentThreshold;
var(SoftBody) const bool bEnableSoftBodyTwoWayCollision;
var(SoftBody) const float SoftBodyAttachmentTearFactor;
var(SoftBody) const bool bEnableSoftBodyLineChecks;
var const native array<bool> GraphicsIndexIsCloth;
var const native transient int ReleaseResourcesFence;
var const transient QWord SkelMeshRUID;
var(RefBox) const bool bUseRefBoxBone;
var(RefBox) const bool bHasAlignBoxBone;

defaultproperties
{
    SkelMirrorAxis="AXIS_X"
    SkelMirrorFlipAxis="AXIS_Z"
    bUseSimpleLineCollision=True
    bUseSimpleBoxCollision=True
    bUsePackedPosition=True
    ClothStretchStiffness=1.0
    ClothBendStiffness=1.0
    ClothDensity=1.0
    ClothThickness=0.5
    ClothDamping=0.5
    ClothIterations=5
    ClothHierarchicalIterations=2
    ClothFriction=0.5
    ClothRelativeGridSpacing=1.0
    ClothPressure=1.0
    ClothCollisionResponseCoefficient=0.2
    ClothAttachmentResponseCoefficient=0.2
    ClothAttachmentTearFactor=1.5
    ClothSleepLinearVelocity=-1.0
    HardStretchLimitFactor=1.1
    ClothMetalImpulseThreshold=10.0
    ClothTearFactor=3.5
    ClothTearReserve=128
    DressFloatingParam=(FixedPoint=(X=0.0,Y=0.0,Z=300.0),Amplitude=2.0,Frequency=1.0,Speed=5.0,Intensity=1.0,DirRefPoint=(X=0.0,Y=0.0,Z=45.0))
    SoftBodyVolumeStiffness=1.0
    SoftBodyStretchingStiffness=1.0
    SoftBodyDensity=1.0
    SoftBodyParticleRadius=0.1
    SoftBodyDamping=0.5
    SoftBodySolverIterations=5
    SoftBodyFriction=0.5
    SoftBodyRelativeGridSpacing=1.0
    SoftBodySleepLinearVelocity=-1.0
    SoftBodyAttachmentResponse=0.2
    SoftBodyCollisionResponse=0.2
    SoftBodyDetailLevel=0.5
    SoftBodySubdivisionLevel=4
    bSoftBodyIsoSurface=True
    SoftBodyAttachmentThreshold=0.5
    bEnableSoftBodyTwoWayCollision=True
    SoftBodyAttachmentTearFactor=1.5
}

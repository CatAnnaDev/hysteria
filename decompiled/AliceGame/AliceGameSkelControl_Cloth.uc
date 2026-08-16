class AliceGameSkelControl_Cloth extends SkelControlBase
    native
    notplaceable
    hidecategories(Object,Object);

struct native CollisionSphere
{
    var name BoneName;
    var Vector Center;
    var float Radius;
    var float sqRadius;
};

struct native BoneLink
{
    var int NodeIndex0;
    var int NodeIndex1;
    var float Length;
    var float Restitution;
};

struct native BonePoint
{
    var int BoneIndex;
    var Vector OldPos;
    var Vector CurPos;
    var bool bFixed;
};

struct native ClothBoneStrip
{
    var() name ClothFixedBoneName;
    var() editconst array<name> ClothBoneNames;
    var editconst int ClothFixedBoneIndex;
    var editconst array<int> ClothBoneIndices;
    var editconst array<float> ClothBoneLengths;
    var Vector LastClothFixedBonePos;
    var Quat LastClothFixedBoneRot;
    var array<Vector> LastClothBonesPos;
    var array<Vector> LastClothBonesVel;
};

var() array<ClothBoneStrip> ClothBoneStripsSetting;
var() int StripBoneCount;
var() bool bClothBoneStripsHorizontalRelative;
var() bool bTrilink;
var() bool bTwoWayTriLink;
var bool bNeedReset;
var() float dampcoff;
var() editconst int ClothBonesCount;
var() editconst int ClothLinkCount;
var() Vector TestForce;
var() float fixeddeltatime;
var() float ControllerWeight;
var Vector BackUpActorLocation;
var() float TransformForceScale;
var Rotator BackUpActorRotation;
var() float RotationForceScale;
var editconst array<BonePoint> ClothBonePoints;
var editconst array<BoneLink> ClothBoneLinks;
var array<CollisionSphere> CollisionSpheres;
var() float m_Mass;
var() float m_Noise;
var() int m_Iteration;
var() float m_Damping;
var() int StripMultiLinkMaxStartNode;
var() int StripMultiLinkMaxLevel;
var() int HorizontalMultiLinkMaxLevel;
var() PhysicsAsset BodyCollisionAsset;

defaultproperties
{
    bNeedReset=True
    dampcoff=0.7
    TestForce=(X=100.0,Y=0.0,Z=0.0)
    fixeddeltatime=0.06
    ControllerWeight=0.5
    TransformForceScale=2.0
    RotationForceScale=0.2
    m_Mass=1.0
    m_Iteration=1
    StripMultiLinkMaxStartNode=1
    StripMultiLinkMaxLevel=1
    HorizontalMultiLinkMaxLevel=1
    CategoryDesc="Cloth"
}

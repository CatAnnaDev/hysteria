class DecalManager extends Actor
    native
    notplaceable
    config(Game)
    hidecategories(Navigation);

struct native ActiveDecalInfo
{
    var export editinline DecalComponent Decal;
    var float LifetimeRemaining;
};

var export editinline DecalComponent DecalTemplate;
var export editinline array<DecalComponent> PoolDecals;
var globalconfig int MaxActiveDecals;
var globalconfig float DecalLifeSpan;
var float DecalDepthBias;
var Vector2D DecalBlendRange;
var array<ActiveDecalInfo> ActiveDecals;

function DecalComponent SpawnDecal(MaterialInterface DecalMaterial, Vector DecalLocation, Rotator DecalOrientation, float Width, float Height, float Thickness, bool bNoClip, optional float DecalRotation = FRand() * 360.0, optional PrimitiveComponent HitComponent, optional bool bProjectOnTerrain = true, optional bool bProjectOnSkeletalMeshes, optional name HitBone, optional int HitNodeIndex = -1, optional int HitLevelIndex = -1, optional float InDecalLifeSpan = DecalLifeSpan, optional int InFracturedStaticMeshComponentIndex = -1, optional float InDepthBias = DecalDepthBias, optional Vector2D InBlendRange = DecalBlendRange)
{
    local DecalComponent Result;
    local ActiveDecalInfo DecalInfo;
    
    if (!CanSpawnDecals())
    {
        return none;
    }
    Result = GetPooledComponent();
    SetDecalParameters(Result, DecalMaterial, DecalLocation, DecalOrientation, Width, Height, Thickness, bNoClip, DecalRotation, HitComponent, bProjectOnTerrain, bProjectOnSkeletalMeshes, HitBone, HitNodeIndex, HitLevelIndex, -1, InDepthBias, InBlendRange);
    AttachComponent(Result);
    DecalInfo.Decal = Result;
    DecalInfo.LifetimeRemaining = InDecalLifeSpan;
    ActiveDecals.AddItem(DecalInfo);
    return Result;
}

protected function DecalComponent GetPooledComponent()
{
    local int I;
    local DecalComponent Result;
    
    while (PoolDecals.Length > 0)
    {
        I = PoolDecals.Length - 1;
        Result = PoolDecals[I];
        PoolDecals.Remove(I, 1);
        if (Result != none && !Result.IsPendingKill())
        {
            break;
            continue;
        }
        Result = none;
    }
    if (Result == none)
    {
        if (MaxActiveDecals > 0 && ActiveDecals.Length >= MaxActiveDecals)
        {
            Result = ActiveDecals[0].Decal;
            Result.ResetToDefaults();
            ActiveDecals.Remove(0, 1);
        }
        else
        {
            Result = new(self) DecalTemplate.Class(DecalTemplate);
        }
    }
    return Result;
}

static final function SetDecalParameters(DecalComponent TheDecal, MaterialInterface DecalMaterial, Vector DecalLocation, Rotator DecalOrientation, float Width, float Height, float Thickness, bool bNoClip, float DecalRotation, PrimitiveComponent HitComponent, bool bProjectOnTerrain, bool bProjectOnSkeletalMeshes, name HitBone, int HitNodeIndex, int HitLevelIndex, int InFracturedStaticMeshComponentIndex, float DepthBias, Vector2D BlendRange)
{
    TheDecal.Location = DecalLocation;
    TheDecal.Orientation = DecalOrientation;
    TheDecal.DecalRotation = DecalRotation;
    TheDecal.Width = Width;
    TheDecal.Height = Height;
    TheDecal.FarPlane = Thickness * 0.5;
    TheDecal.NearPlane = -TheDecal.FarPlane;
    TheDecal.bNoClip = bNoClip;
    TheDecal.HitComponent = HitComponent;
    TheDecal.HitBone = HitBone;
    TheDecal.HitNodeIndex = HitNodeIndex;
    TheDecal.HitLevelIndex = HitLevelIndex;
    TheDecal.SetDecalMaterial(DecalMaterial);
    TheDecal.bProjectOnTerrain = bProjectOnTerrain;
    TheDecal.bProjectOnSkeletalMeshes = bProjectOnSkeletalMeshes;
    TheDecal.FracturedStaticMeshComponentIndex = InFracturedStaticMeshComponentIndex;
    TheDecal.DepthBias = DepthBias;
    TheDecal.BlendRange = BlendRange;
}

function bool CanSpawnDecals()
{
    return AreDynamicDecalsEnabled();
}

event DecalFinished(DecalComponent Decal)
{
    Decal.ResetToDefaults();
    PoolDecals[PoolDecals.Length] = Decal;
}

native static final function bool AreDynamicDecalsEnabled()
{
}

defaultproperties
{
    DecalTemplate="Default__DecalManager.BaseDecal"
    MaxActiveDecals=100
    DecalLifeSpan=1000000000.0
    DecalDepthBias=-6e-05
    DecalBlendRange=(X=89.5,Y=180.0)
    CollisionType="COLLIDE_CustomDefault"
    TickGroup="TG_DuringAsyncWork"
}

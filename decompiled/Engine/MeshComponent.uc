class MeshComponent extends PrimitiveComponent
    abstract
    native
    noexport
    notplaceable;

var(Rendering) const array<MaterialInterface> Materials;

function MaterialInstanceTimeVarying CreateAndSetMaterialInstanceTimeVarying(int ElementIndex)
{
    local MaterialInstanceTimeVarying Instance;
    
    Instance = new(self) class'MaterialInstanceTimeVarying';
    Instance.SetParent(GetMaterial(ElementIndex));
    SetMaterial(ElementIndex, Instance);
    return Instance;
}

function MaterialInstanceConstant CreateAndSetMaterialInstanceConstant(int ElementIndex)
{
    local MaterialInstanceConstant Instance;
    
    Instance = new(self) class'MaterialInstanceConstant';
    Instance.SetParent(GetMaterial(ElementIndex));
    SetMaterial(ElementIndex, Instance);
    return Instance;
}

native final function PrestreamTextures(float Seconds, bool bPrioritizeCharacterTextures, optional int CinematicTextureGroups = 0)
{
    Seconds;
    bPrioritizeCharacterTextures;
    CinematicTextureGroups;
}

native function int GetNumElements()
{
}

native function SetMaterial(int ElementIndex, MaterialInterface Material)
{
    ElementIndex;
    Material;
}

native function MaterialInterface GetMaterial(int ElementIndex)
{
    ElementIndex;
}

defaultproperties
{
    ReplacementPrimitive="None"
    bUseAsOccluder=True
    CastShadow=True
    bAcceptsLights=True
    bCullModulatedShadowOnBackfaces=True
    bCullModulatedShadowOnEmissive=True
}

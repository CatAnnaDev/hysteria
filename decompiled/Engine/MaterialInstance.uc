class MaterialInstance extends MaterialInterface
    abstract
    native
    notplaceable;

var() PhysicalMaterial PhysMaterial;
var() const MaterialInterface Parent;
var bool bHasStaticPermutationResource;
var native transient bool bStaticPermutationDirty;
var const native bool ReentrantFlag;
var transient bool bDuplicate;
var const native duplicatetransient Pointer StaticParameters[2];
var const native duplicatetransient Pointer StaticPermutationResources[2];
var const native duplicatetransient Pointer Resources[2];
var const deprecated array<Texture> ReferencedTextures;
var const editoronly array<Guid> ReferencedTextureGuids;
var const Guid ParentLightingGuid;
var transient int DuplicateCount;

native function MaterialInstance DuplicateInstance()
{
}

native function bool IsInMapOrTransientPackage()
{
}

native function ClearParameterValues()
{
}

native function SetFontParameterValue(name ParameterName, Font FontValue, int FontPage)
{
    ParameterName;
    FontValue;
    FontPage;
}

native function SetTextureParameterValue(name ParameterName, Texture Value)
{
    ParameterName;
    Value;
}

native function SetScalarCurveParameterValue(name ParameterName, out const InterpCurveFloat Value)
{
    ParameterName;
    Value;
}

native function SetScalarParameterValue(name ParameterName, float Value)
{
    ParameterName;
    Value;
}

native function SetVectorParameterValue(name ParameterName, out const LinearColor Value)
{
    ParameterName;
    Value;
}

native function SetParent(MaterialInterface NewParent)
{
    NewParent;
}

defaultproperties
{
}

class MaterialInstanceConstant extends MaterialInstance
    native
    notplaceable
    collapsecategories
    hidecategories(Object);

struct native VectorParameterValue
{
    var() name ParameterName;
    var() LinearColor ParameterValue;
    var Guid ExpressionGUID;
};

struct native TextureParameterValue
{
    var() name ParameterName;
    var() Texture ParameterValue;
    var Guid ExpressionGUID;
};

struct native ScalarParameterValue
{
    var() name ParameterName;
    var() float ParameterValue;
    var Guid ExpressionGUID;
};

struct native FontParameterValue
{
    var() name ParameterName;
    var() Font FontValue;
    var() int FontPage;
    var Guid ExpressionGUID;
};

var() const array<FontParameterValue> FontParameterValues;
var() const array<ScalarParameterValue> ScalarParameterValues;
var() const array<TextureParameterValue> TextureParameterValues;
var() const array<VectorParameterValue> VectorParameterValues;
var() bool bSonarFadeIn;
var() bool bSonarMaterial;
var() float fSonarFadeOutDuration;
var() float fSonarFadeInDuration;
var float fSonarAlpha;

native function ClearParameterValues()
{
}

native function SetFontParameterValue(name ParameterName, Font FontValue, int FontPage)
{
    ParameterName;
    FontValue;
    FontPage;
}

native function SetVectorParameterValue(name ParameterName, out const LinearColor Value)
{
    ParameterName;
    Value;
}

native function SetTextureParameterValue(name ParameterName, Texture Value)
{
    ParameterName;
    Value;
}

native function SetScalarParameterValue(name ParameterName, float Value)
{
    ParameterName;
    Value;
}

native function SetParent(MaterialInterface NewParent)
{
    NewParent;
}

function initSonarParam(MaterialInstanceConstant origMat)
{
    local Texture sonartex;
    local float fValue;
    local LinearColor vlinearColor;
    
    bSonarFadeIn = origMat.bSonarFadeIn;
    bSonarMaterial = origMat.bSonarMaterial;
    fSonarFadeOutDuration = origMat.fSonarFadeOutDuration;
    fSonarFadeInDuration = origMat.fSonarFadeInDuration;
    fSonarAlpha = (bSonarFadeIn ? 0.0 : 1.0);
    SetScalarParameterValue('FadeOutAlpha', fSonarAlpha);
    if (origMat.GetScalarParameterValue('FadeOutTiling', fValue))
    {
        SetScalarParameterValue('FadeOutTiling', fValue);
    }
    if (origMat.GetScalarParameterValue('Specular', fValue))
    {
        SetScalarParameterValue('Specular', fValue);
    }
    if (origMat.GetScalarParameterValue('SpecularPower', fValue))
    {
        SetScalarParameterValue('SpecularPower', fValue);
    }
    if (origMat.GetScalarParameterValue('TransmissionBoost', fValue))
    {
        SetScalarParameterValue('TransmissionBoost', fValue);
    }
    origMat.GetTextureParameterValue('sonartex', sonartex);
    SetTextureParameterValue('sonartex', sonartex);
    if (origMat.GetTextureParameterValue('NormalTexture', sonartex))
    {
        SetTextureParameterValue('NormalTexture', sonartex);
    }
    if (origMat.GetTextureParameterValue('SpecularTexture', sonartex))
    {
        SetTextureParameterValue('SpecularTexture', sonartex);
    }
    if (origMat.GetVectorParameterValue('TransmissionColor', vlinearColor))
    {
        SetVectorParameterValue('TransmissionColor', vlinearColor);
    }
    if (origMat.GetVectorParameterValue('EmissiveColor', vlinearColor))
    {
        SetVectorParameterValue('EmissiveColor', vlinearColor);
    }
}

defaultproperties
{
    bSonarFadeIn=True
    fSonarFadeOutDuration=1.0
    fSonarFadeInDuration=0.5
}

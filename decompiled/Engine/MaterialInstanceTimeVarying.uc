class MaterialInstanceTimeVarying extends MaterialInstance
    native
    notplaceable;

struct native VectorParameterValueOverTime extends ParameterValueOverTime
{
    var() LinearColor ParameterValue;
    var() InterpCurveVector ParameterValueCurve;
};

struct native TextureParameterValueOverTime extends ParameterValueOverTime
{
    var() Texture ParameterValue;
};

struct native ScalarParameterValueOverTime extends ParameterValueOverTime
{
    var() float ParameterValue;
    var() InterpCurveFloat ParameterValueCurve;
};

struct native FontParameterValueOverTime extends ParameterValueOverTime
{
    var() Font FontValue;
    var() int FontPage;
};

struct native ParameterValueOverTime
{
    var Guid ExpressionGUID;
    var transient float StartTime;
    var() name ParameterName;
    var() bool bLoop;
    var() bool bAutoActivate;
    var() float CycleTime;
    var() bool bNormalizeTime;
    var() float OffsetTime;
    var() bool bOffsetFromEnd;
};

var() bool bAutoActivateAll;
var transient float Duration;
var() const array<FontParameterValueOverTime> FontParameterValues;
var() const array<ScalarParameterValueOverTime> ScalarParameterValues;
var() const array<TextureParameterValueOverTime> TextureParameterValues;
var() const array<VectorParameterValueOverTime> VectorParameterValues;

native function ClearRenderingThreadParameterMaps()
{
}

native function float GetMaxDurationFromAllParameters()
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

native function SetVectorStartTime(name ParameterName, float Value)
{
    ParameterName;
    Value;
}

native function SetVectorCurveParameterValue(name ParameterName, out const InterpCurveVector Value)
{
    ParameterName;
    Value;
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

native function SetDuration(float Value)
{
    Value;
}

native function SetScalarStartTime(name ParameterName, float Value)
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

native function SetParent(MaterialInterface NewParent)
{
    NewParent;
}

defaultproperties
{
}

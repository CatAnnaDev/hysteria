class PostProcessChain extends Object
    native
    notplaceable;

var array<PostProcessEffect> Effects;

final event PostProcessEffect FindPostProcessEffect(name EffectName)
{
    local int Idx;
    
    for (Idx = 0; Idx < Effects.Length; Idx++)
    {
        if (Effects[Idx] != none && Effects[Idx].EffectName == EffectName)
        {
            return Effects[Idx];
        }
    }
    return none;
}

defaultproperties
{
}

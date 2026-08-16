class AliceGameProjectileTrace_CurveToDest extends AliceGameProjectileTrace
    native
    notplaceable
    config(Weapon);

defaultproperties
{
    ProjInitType="EProjectileInitType_AlignSocket"
    bNeedUpdateAccelarationWhenInit=True
}

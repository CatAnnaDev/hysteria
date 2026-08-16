class MultiFont extends Font
    native
    notplaceable
    hidecategories(Object);

var() editinline array<float> ResolutionTestTable;

native function int GetResolutionTestTableIndex(float HeightTest)
{
    HeightTest;
}

defaultproperties
{
}

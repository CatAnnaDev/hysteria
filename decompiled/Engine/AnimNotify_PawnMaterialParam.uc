class AnimNotify_PawnMaterialParam extends AnimNotify_Scripted
    native
    notplaceable
    editinlinenew
    collapsecategories
    hidecategories(Object);

var() array<ScalarParameterInterpStruct> ScalarParameterInterpArray;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local Pawn P;
    local int I;
    local ScalarParameterInterpStruct ScalarParam;
    
    P = Pawn(Owner);
    if (P != none)
    {
        for (I = 0; I < ScalarParameterInterpArray.Length; I++)
        {
            ScalarParam = ScalarParameterInterpArray[I];
            P.SetScalarParameterInterp(ScalarParam);
        }
    }
}

defaultproperties
{
}

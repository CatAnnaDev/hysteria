class UIComp_ListElementSorter extends UIComp_ListComponentBase
    native
    notplaceable
    editinlinenew
    within UIList
    hidecategories(Object);

struct native transient UIListSortingParameters
{
    var int PrimaryIndex;
    var int SecondaryIndex;
    var bool bReversePrimarySorting;
    var bool bReverseSecondarySorting;
    var bool bCaseSensitive;
    var bool bIntSortPrimary;
    var bool bIntSortSecondary;
    var bool bFloatSortPrimary;
    var bool bFloatSortSecondary;
};

var(Interaction) bool bAllowCompoundSorting;
var(Interaction) bool bReversePrimarySorting;
var(Interaction) bool bReverseSecondarySorting;
var(Interaction) int InitialSortColumn;
var(Interaction) int InitialSecondarySortColumn;
var(Interaction) const transient editconst int PrimarySortColumn;
var(Interaction) const transient editconst int SecondarySortColumn;
var delegate<OverrideListSort> __OverrideListSort__Delegate;

native final function bool ResortItems(optional bool bCaseSensitive)
{
    bCaseSensitive;
}

native final function bool SortItems(int ColumnIndex, optional bool bSecondarySort, optional bool bCaseSensitive)
{
    ColumnIndex;
    bSecondarySort;
    bCaseSensitive;
}

native final function ResetSortColumns(optional bool bResort = true)
{
    bResort;
}

delegate bool OverrideListSort(UIList Sender, name CollectionFieldName, out const UIListSortingParameters SortParameters, out array<int> OrderedIndices)
{
}

defaultproperties
{
    bAllowCompoundSorting=True
    InitialSortColumn=-1
    InitialSecondarySortColumn=-1
    PrimarySortColumn=-1
    SecondarySortColumn=-1
}

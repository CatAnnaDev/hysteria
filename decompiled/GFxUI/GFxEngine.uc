class GFxEngine extends Object
    native
    notplaceable;

struct native GCReference
{
    var const Object m_object;
    var int m_count;
    var int m_statid;
};

var transient array<GCReference> GCReferences;
var transient int RefCount;

defaultproperties
{
    RefCount=1
}

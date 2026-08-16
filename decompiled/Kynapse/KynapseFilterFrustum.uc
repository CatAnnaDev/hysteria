class KynapseFilterFrustum extends KynapseFilter
    native
    notplaceable
    editinlinenew
    hidecategories(Object,Object);

var() const Vector EyePosition;
var() const Vector At;
var() const float NearClip;
var() const float FarClip;
var() const float Angle;

defaultproperties
{
    At=(X=1.0,Y=0.0,Z=0.0)
    NearClip=0.1
    FarClip=50.0
    Angle=40.0
    filterClass="CFrustumFilter"
}

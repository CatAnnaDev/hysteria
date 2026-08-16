class SkeletalMeshSocket extends Object
    native
    notplaceable
    hidecategories(Object,Actor);

var() const editconst name SocketName;
var() const editconst name BoneName;
var() Vector RelativeLocation;
var() Rotator RelativeRotation;
var() Vector RelativeScale;
var(PreviewSkeletal) editoronly SkeletalMesh PreviewSkelMesh;
var(PreviewSkeletal) editoronly AnimSet PreviewAnimSet;
var(PreviewSkeletal) editoronly name PreviewAnimSequenceName;
var(PreviewSkeletal) const transient export editconst editinline SkeletalMeshComponent PreviewSkelComp;
var(PreviewStatic) editoronly StaticMesh PreviewStaticMesh;
var(PreveiwParticle) editoronly ParticleSystem PreviewParticleTemplate;

defaultproperties
{
    RelativeScale=(X=1.0,Y=1.0,Z=1.0)
}

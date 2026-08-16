class KynapseWorldServicePointLockManager extends KynapseWorldService
    native
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object);

var() const bool AutoLock;
var() const int MaxLockPerEntity;
var() const float ExpirationDelay;
var() const float GridPitch;
var() const float ImmobilityDelay;
var() const float ImmobilityDistance;

defaultproperties
{
    AutoLock=True
    MaxLockPerEntity=5
    ExpirationDelay=0.5
    GridPitch=5.0
    ImmobilityDelay=0.5
    ImmobilityDistance=0.05
    serviceName="pointlockmanagerService"
    ClassName="CPointLockManager"
}

class KynapseGraph extends Object
    native
    notplaceable
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object);

const nbAdditionalData = 5;

var array<byte> Data;
var int generationBuildNumber;
var Vector generationBBoxMin;
var Vector generationBBoxMax;
var() const KynapseAdditionalData additionalData[5];
var() KynapseTag DataTag;

defaultproperties
{
    generationBuildNumber=-1
    generationBBoxMin=(X=1.0,Y=1.0,Z=1.0)
}

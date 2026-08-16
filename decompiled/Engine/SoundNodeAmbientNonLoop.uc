class SoundNodeAmbientNonLoop extends SoundNodeAmbient
    native
    notplaceable
    editinlinenew
    hidecategories(Object,Object,Object)
    autoexpandcategories(Attenuation,LowPassFilter,Modulation,Sounds,Spatialization,Delay);

var(Delay) float DelayMin;
var(Delay) float DelayMax;
var deprecated RawDistributionFloat DelayTime;

defaultproperties
{
}

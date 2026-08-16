class ParticleModuleParameterDynamic extends ParticleModuleParameterBase
    native
    notplaceable
    editinlinenew
    hidecategories(Object,Object,Object);

enum EEmitterDynamicParameterValue
{
    EDPV_UserSet,
    EDPV_VelocityX,
    EDPV_VelocityY,
    EDPV_VelocityZ,
    EDPV_VelocityMag,
};

struct native EmitterDynamicParameter
{
    var() editconst name ParamName;
    var() bool bUseEmitterTime;
    var() bool bSpawnTimeOnly;
    var() EEmitterDynamicParameterValue ValueMethod;
    var() bool bScaleVelocityByParamValue;
    var() RawDistributionFloat ParamValue;
};

var() editfixedsize array<EmitterDynamicParameter> DynamicParams;

defaultproperties
{
    DynamicParams(0)=(ParamName="None",bUseEmitterTime=False,bSpawnTimeOnly=False,ValueMethod="EDPV_UserSet",bScaleVelocityByParamValue=False,ParamValue=(Distribution="Default__ParticleModuleParameterDynamic.DistributionParam1",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=1,LookupTable=// [raw] 00000000000000000000000000000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0))
    DynamicParams(1)=(ParamName="None",bUseEmitterTime=False,bSpawnTimeOnly=False,ValueMethod="EDPV_UserSet",bScaleVelocityByParamValue=False,ParamValue=(Distribution="Default__ParticleModuleParameterDynamic.DistributionParam2",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=1,LookupTable=// [raw] 00000000000000000000000000000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0))
    DynamicParams(2)=(ParamName="None",bUseEmitterTime=False,bSpawnTimeOnly=False,ValueMethod="EDPV_UserSet",bScaleVelocityByParamValue=False,ParamValue=(Distribution="Default__ParticleModuleParameterDynamic.DistributionParam3",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=1,LookupTable=// [raw] 00000000000000000000000000000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0))
    DynamicParams(3)=(ParamName="None",bUseEmitterTime=False,bSpawnTimeOnly=False,ValueMethod="EDPV_UserSet",bScaleVelocityByParamValue=False,ParamValue=(Distribution="Default__ParticleModuleParameterDynamic.DistributionParam4",Type=0,Op=1,LookupTableNumElements=1,LookupTableChunkSize=1,LookupTable=// [raw] 00000000000000000000000000000000,LookupTableTimeScale=0.0,LookupTableStartTime=0.0))
    bSpawnModule=True
    bUpdateModule=True
}

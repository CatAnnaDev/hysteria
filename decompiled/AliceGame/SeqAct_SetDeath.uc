class SeqAct_SetDeath extends SequenceAction
    native
    notplaceable
    hidecategories(Object);

enum EDeathType
{
    DT_W_NPC,
    DT_W_Crushed,
    DT_W_Fall,
    DT_W_Burning,
    DT_W_Fish,
    DT_W_Ice,
    DT_W_Generic,
    DT_W_WaterArctic,
    DT_W_WaterOriental,
    DT_W_WaterBile,
    DT_W_WaterLava,
    DT_W_WaterDoom,
    DT_W_SwimDeath,
    DT_W_ShadowMode,
    DT_W_GiantMode,
    DT_W_OWHHMode,
    DT_W_Gryphon,
};

struct native DeathTypeFXInfo
{
    var EDeathType Type;
    var ParticleSystem ParticleDeath;
    var ParticleSystem ParticleRespawn;
    var SoundCue ParticleDeathSound;
    var SoundCue ParticleRespawnSound;
};

var DeathTypeFXInfo DeathTypeFxInfos[17];
var() EDeathType DeathType;
var float FadeDuration;
var Color FadeColor;
var CameraAnim CameraAnim;
var ForceFeedbackWaveform ForceFeedback;
var float FadeTimeRemaining;
var float SoundDurationTime;
var transient array<PlayerController> CachedPCs;
var bool bAllFinished;
var int curStep;
var Emitter FireParticleEmitter;
var float ParticleDuration;

event ResetAmmoOfAlice(AlicePlayerController PC)
{
    local WeaponForAlice WA;
    
    foreach PC.WorldInfo.AllActors(class'WeaponForAlice', WA)
    {
        WA.AmmoCount = WA.MaxAmmoCount;
    }
}

function OnAliceDeathParticleFinished(ParticleSystemComponent PSC)
{
    AlicePlayerController(CachedPCs[0]).MyAlicePawn.SetCollision(true, true);
    AlicePlayerController(CachedPCs[0]).MyAlicePawn.ResetTimeVaryingMaterials();
}

event PlayerAliceDeathParticle(AlicePlayerController PC)
{
    if (PC != none)
    {
        PC.GotoState('Dead');
    }
    if (FireParticleEmitter != none)
    {
        FireParticleEmitter.Destroy();
    }
    FireParticleEmitter = PC.Spawn(class'Engine.EmitterSpawnable', PC, , PC.MyAlicePawn.Location);
    if (FireParticleEmitter != none && DeathTypeFxInfos[int(DeathType)].ParticleDeath != none)
    {
        FireParticleEmitter.SetLocation(PC.MyAlicePawn.Location);
        FireParticleEmitter.ParticleSystemComponent.__OnSystemFinished__Delegate = OnAliceDeathParticleFinished;
        FireParticleEmitter.SetTemplate(DeathTypeFxInfos[int(DeathType)].ParticleDeath, true);
    }
    PC.PlaySound(DeathTypeFxInfos[int(DeathType)].ParticleDeathSound);
    PC.ClientPlayForceFeedbackWaveform(ForceFeedback);
    PC.MyAlicePawn.SetPhysics(0);
}

defaultproperties
{
    DeathTypeFxInfos=(Type="DT_W_NPC",ParticleDeath="GFX_Alice.Death.DT_W_NPC",ParticleRespawn="GFX_Alice.Death.RP_W_NPC",ParticleDeathSound="SFX_Alice_Death.Alice_DeathNPC_Cue",ParticleRespawnSound="SFX_Alice_Death.Alice_RespawnNPC_Cue")
    DeathTypeFxInfos[1]=(Type="DT_W_NPC",ParticleDeath="GFX_Alice.Death.DT_W_Crushed",ParticleRespawn="GFX_Alice.Death.RP_W_Crushed",ParticleDeathSound="SFX_Alice_Death.Alice_DeathCrushed_Cue",ParticleRespawnSound="SFX_Alice_Death.Alice_RespawnCrushed_Cue")
    DeathTypeFxInfos[2]=(Type="DT_W_NPC",ParticleDeath="GFX_Alice.Death.DT_W_Fall",ParticleRespawn="GFX_Alice.Death.RP_W_Fall",ParticleDeathSound="SFX_Alice_Death.Alice_DeathFall_Cue",ParticleRespawnSound="SFX_Alice_Death.Alice_RespawnFall_Cue")
    DeathTypeFxInfos[3]=(Type="DT_W_NPC",ParticleDeath="GFX_Alice.Death.DT_W_Burning",ParticleRespawn="GFX_Alice.Death.RP_W_Burning",ParticleDeathSound="SFX_Alice_Death.Alice_DeathBurning_Cue",ParticleRespawnSound="SFX_Alice_Death.Alice_RespawnBurning_Cue")
    DeathTypeFxInfos[4]=(Type="DT_W_NPC",ParticleDeath="GFX_Alice.Death.DT_W_Fish",ParticleRespawn="GFX_Alice.Death.RP_W_Fish",ParticleDeathSound="SFX_Alice_Death.Alice_DeathFish_Cue",ParticleRespawnSound="SFX_Alice_Death.Alice_RespawnFish_Cue")
    DeathTypeFxInfos[5]=(Type="DT_W_NPC",ParticleDeath="GFX_Alice.Death.DT_W_Ice",ParticleRespawn="GFX_Alice.Death.RP_W_Ice",ParticleDeathSound="SFX_Alice_Death.Alice_DeathIce_Cue",ParticleRespawnSound="SFX_Alice_Death.Alice_RespawnIce_Cue")
    DeathTypeFxInfos[6]=(Type="DT_W_NPC",ParticleDeath="GFX_Alice.Death.DT_W_Generic",ParticleRespawn="GFX_Alice.Death.RP_W_Generic",ParticleDeathSound="SFX_Alice_Death.Alice_DeathGeneric_Cue",ParticleRespawnSound="SFX_Alice_Death.Alice_RespawnGeneric_Cue")
    DeathTypeFxInfos[7]=(Type="DT_W_NPC",ParticleDeath="GFX_Alice.Death.DT_W_WaterArctic",ParticleRespawn="GFX_Alice.Death.RP_W_WaterArctic",ParticleDeathSound="SFX_Alice_Death.Alice_DeathWaterArctic_Cue",ParticleRespawnSound="SFX_Alice_Death.Alice_RespawnWaterArctic_Cue")
    DeathTypeFxInfos[8]=(Type="DT_W_NPC",ParticleDeath="GFX_Alice.Death.DT_W_WaterOriental",ParticleRespawn="GFX_Alice.Death.RP_W_WaterOriental",ParticleDeathSound="SFX_Alice_Death.Alice_DeathWaterOriental_Cue",ParticleRespawnSound="SFX_Alice_Death.Alice_RespawnWaterOriental_Cue")
    DeathTypeFxInfos[9]=(Type="DT_W_NPC",ParticleDeath="GFX_Alice.Death.DT_W_WaterBile",ParticleRespawn="GFX_Alice.Death.RP_W_WaterBile",ParticleDeathSound="SFX_Alice_Death.Alice_DeathWaterBile_Cue",ParticleRespawnSound="SFX_Alice_Death.Alice_RespawnWaterBile_Cue")
    DeathTypeFxInfos[10]=(Type="DT_W_NPC",ParticleDeath="GFX_Alice.Death.DT_W_WaterLava",ParticleRespawn="GFX_Alice.Death.RP_W_WaterLava",ParticleDeathSound="SFX_Alice_Death.Alice_DeathWaterLava_Cue",ParticleRespawnSound="SFX_Alice_Death.Alice_RespawnWaterLava_Cue")
    DeathTypeFxInfos[11]=(Type="DT_W_NPC",ParticleDeath="GFX_Alice.Death.DT_W_WaterDoom",ParticleRespawn="GFX_Alice.Death.RP_W_WaterDoom",ParticleDeathSound="SFX_Alice_Death.Alice_DeathWaterDoom_Cue",ParticleRespawnSound="SFX_Alice_Death.Alice_RespawnWaterDoom_Cue")
    DeathTypeFxInfos[12]=(Type="DT_W_NPC",ParticleDeath="GFX_Alice.Death.DT_W_SwimDeath",ParticleRespawn="GFX_Alice.Death.Rp_W_SwimDeath",ParticleDeathSound="SFX_Alice_Death.Alice_DeathSwim_Cue",ParticleRespawnSound="SFX_Alice_Death.Alice_RespawnSwim_Cue")
    DeathTypeFxInfos[13]=(Type="DT_W_NPC",ParticleDeath="GFX_Alice.Death.DT_W_ShadowMode",ParticleRespawn="GFX_Alice.Death.RP_W_ShadowMode",ParticleDeathSound="SFX_Alice_Death.Alice_DeathShadow_Cue",ParticleRespawnSound="SFX_Alice_Death.Alice_RespawnShadow_Cue")
    DeathTypeFxInfos[14]=(Type="DT_W_NPC",ParticleDeath="GFX_Alice.Death.DT_W_GiantMode",ParticleRespawn="GFX_Alice.Death.RP_W_GiantMode",ParticleDeathSound="SFX_Alice_Death.Alice_DeathGiant_Cue",ParticleRespawnSound="SFX_Alice_Death.Alice_RespawnGiant_Cue")
    DeathTypeFxInfos[15]=(Type="DT_W_NPC",ParticleDeath="GFX_Alice.Death.DT_W_OWHHMode",ParticleRespawn="GFX_GamePlay.OWHH.DollHeadRespawn_P",ParticleDeathSound="SFX_Alice_Death.Alice_DeathOWHH_Cue",ParticleRespawnSound="SFX_Alice_Death.Alice_RespawnOWHH_Cue")
    DeathTypeFxInfos[16]=(Type="DT_W_NPC",ParticleDeath="GFX_Alice.Death.DT_W_Gryphon",ParticleRespawn="GFX_Alice.Death.RP_W_Gryphon",ParticleDeathSound="SFX_Alice_Death.Alice_DeathGryphon_Cue",ParticleRespawnSound="SFX_Alice_Death.Alice_RespawnGryphon_Cue")
    FadeDuration=2.0
    CameraAnim="LD_CameraAnims.Gameplay.CA_Death_Generic"
    ForceFeedback="LD_ForceFeedbacks.Death.FF_Death_Generic"
    curStep=1
    ParticleDuration=1.0
    bLatentExecution=True
    ObjName="SetDeath"
    ObjCategory="Alice"
}

class AliceGib extends Actor
    abstract
    notplaceable
    config(Game)
    hidecategories(Navigation);

struct StaticMeshDatum
{
    var StaticMesh TheStaticMesh;
    var SkeletalMesh TheSkelMesh;
    var PhysicsAsset ThePhysAsset;
    var float DrawScale;
    var bool bUseSecondaryGibMeshMITV;
};

var export editinline DynamicLightEnvironmentComponent GibLightEnvironment;
var SoundCue HitSound;
var export editinline MeshComponent GibMeshComp;
var MaterialInstanceConstant MIC_Gib;
var MaterialInstance MI_Decal;
var MaterialInstanceTimeVarying MITV_DecalTemplate;
var name DecalDissolveParamName;
var float DecalWaitTimeBeforeDissolve;
var MaterialInstanceTimeVarying MITV_GibMeshTemplate;
var MaterialInstanceTimeVarying MITV_GibMeshTemplateSecondary;
var name GibMeshDissolveParamName;
var float GibMeshWaitTimeBeforeDissolve;
var export editinline ParticleSystemComponent PSC_GibEffect;
var ParticleSystem PS_CustomEffect;
var array<StaticMeshDatum> GibMeshesData;
var Vector OldCamLoc;
var Rotator OldCamRot;
var bool bStopMovingCamera;

simulated function TurnOnCollision()
{
    GibMeshComp.SetBlockRigidBody(true);
    GibMeshComp.SetRBCollidesWithChannel(0, true);
    GibMeshComp.SetRBCollidesWithChannel(2, true);
    GibMeshComp.SetRBCollidesWithChannel(3, true);
    GibMeshComp.SetRBCollidesWithChannel(5, true);
    GibMeshComp.SetRBCollidesWithChannel(6, true);
    DetachComponent(GibMeshComp);
    AttachComponent(GibMeshComp);
    GibMeshComp.WakeRigidBody();
}

simulated function LeaveADecal(Vector HitLoc, Vector HitNorm)
{
    local Actor TraceActor;
    local Vector out_HitLocation, out_HitNormal, TraceDest, TraceStart, TraceExtent;
    local TraceHitInfo HitInfo;
    
    if (MITV_DecalTemplate != none)
    {
        TraceStart = HitLoc + -HitNorm * float(15);
        TraceDest = HitLoc + HitNorm * float(15);
        TraceActor = Trace(out_HitLocation, out_HitNormal, TraceDest, TraceStart, false, TraceExtent, HitInfo, 2);
        if (TraceActor != none)
        {
            MI_Decal = new(none) class'Engine.MaterialInstanceTimeVarying';
            MI_Decal.SetParent(MITV_DecalTemplate);
            WorldInfo.MyDecalManager.SpawnDecal(MI_Decal, out_HitLocation, rotator(-out_HitNormal), 200.0, 200.0, 10.0, false, , HitInfo.HitComponent, true, false, HitInfo.BoneName, HitInfo.Item, HitInfo.LevelIndex);
            MaterialInstanceTimeVarying(MI_Decal).SetScalarStartTime(DecalDissolveParamName, DecalWaitTimeBeforeDissolve);
        }
    }
}

simulated event RigidBodyCollision(PrimitiveComponent HitComponent, PrimitiveComponent OtherComponent, out const CollisionImpactData RigidCollisionData, int ContactIndex)
{
    if (WorldInfo.TimeSeconds - CreationTime > 0.4)
    {
        if (GibMeshComp != none)
        {
            GibMeshComp.SetNotifyRigidBodyCollision(false);
        }
        if (EffectIsRelevant(Location, false, 4000.0))
        {
            PlaySound(HitSound, true);
            LeaveADecal(Location, Normal(Velocity));
        }
    }
}

simulated function bool CalcCamera(float fDeltaTime, out Vector out_CamLoc, out Rotator out_CamRot, out float out_FOV)
{
    local Actor HitActor;
    local Vector HitNormal, HitLocation;
    local int InYaw;
    
    if (Physics != 0)
    {
        if (bStopMovingCamera)
        {
            OldCamRot.Roll = OldCamRot.Roll & 65535;
            if (OldCamRot.Roll < 8192 || OldCamRot.Roll > 57343)
            {
                out_CamRot = Rotation;
                out_CamRot.Pitch = 0;
                OldCamRot = out_CamRot;
            }
            else
            {
                InYaw = out_CamRot.Yaw;
                out_CamRot = OldCamRot;
                out_CamRot.Yaw = InYaw;
            }
        }
        else
        {
            out_CamRot = Rotation;
            out_CamRot.Pitch = 0;
            OldCamRot = out_CamRot;
        }
    }
    out_CamLoc = Location;
    if (OldCamLoc != vect(0.0, 0.0, 0.0))
    {
        HitActor = Trace(HitLocation, HitNormal, Location, OldCamLoc, false, vect(14.0, 14.0, 14.0));
        if (HitActor != none)
        {
            out_CamLoc = HitLocation;
            bStopMovingCamera = HitNormal.Z > 0.7;
        }
    }
    OldCamLoc = out_CamLoc;
    return false;
}

event BecomeViewTarget(PlayerController PC)
{
    SetHidden(true);
    LifeSpan = 0.0;
    SetTimer(4.0, false);
}

function Timer()
{
    local PlayerController PC;
    
    foreach LocalPlayerControllers(class'Engine.PlayerController', PC)
    {
        if (PC.ViewTarget == self)
        {
            SetTimer(4.0, false);
            return;
        }
    }
    Destroy();
}

simulated function DoCustomGibEffects()
{
}

simulated function ChooseGib()
{
    local StaticMeshDatum SMD;
    local int StartIndex, Index;
    local MaterialInstanceTimeVarying GibMaterialInstance;
    
    if (GibMeshesData.Length > 0)
    {
        Index = Rand(GibMeshesData.Length);
        if (WorldInfo.bDropDetail || WorldInfo.GetDetailMode() == 0)
        {
            StartIndex = Index;
            while (GibMeshesData[Index].ThePhysAsset != none)
            {
                Index++;
                if (Index >= GibMeshesData.Length)
                {
                    Index = 0;
                }
                if (Index == StartIndex)
                {
                    Destroy();
                    return;
                }
            }
        }
        SMD = GibMeshesData[Index];
        if (SMD.ThePhysAsset == none)
        {
        }
        GibMeshComp.SetLightEnvironment(GibLightEnvironment);
        DoCustomGibEffects();
        GibMaterialInstance = new(self) class'Engine.MaterialInstanceTimeVarying';
        if (SMD.bUseSecondaryGibMeshMITV == false)
        {
            GibMaterialInstance.SetParent(MITV_GibMeshTemplate);
        }
        else
        {
            GibMaterialInstance.SetParent(MITV_GibMeshTemplateSecondary);
        }
        GibMeshComp.SetMaterial(0, GibMaterialInstance);
        GibMaterialInstance.SetScalarStartTime(GibMeshDissolveParamName, GibMeshWaitTimeBeforeDissolve - FRand() * 1.0);
    }
    else
    {
        Destroy();
    }
}

simulated function SetGibStaticMesh(StaticMesh NewStaticMesh)
{
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
    if (SkeletalMeshComponent(GibMeshComp) != none)
    {
        HUD.Canvas.DrawText("Mesh " $ string(SkeletalMeshComponent(GibMeshComp).SkeletalMesh), false);
    }
    else
    {
        HUD.Canvas.DrawText("Mesh " $ string(StaticMeshComponent(GibMeshComp).StaticMesh), false);
    }
    out_YPos += out_YL;
    HUD.Canvas.SetPos(4.0, out_YPos);
    DisplayDebug(HUD, out_YL, out_YPos);
}

simulated function SetTexturesToBeResident(float TimeToBeResident)
{
    local int MatIdx;
    
    for (MatIdx = 0; MatIdx < GibMeshComp.Materials.Length; ++MatIdx)
    {
        GibMeshComp.Materials[MatIdx].SetForceMipLevelsToBeResident(false, false, TimeToBeResident);
    }
}

simulated event PreBeginPlay()
{
    PreBeginPlay();
    ChooseGib();
}

defaultproperties
{
    GibLightEnvironment="Default__AliceGib.GibLightEnvironmentComp"
    DecalDissolveParamName="DissolveAmount"
    DecalWaitTimeBeforeDissolve=20.0
    GibMeshDissolveParamName="BurnTime"
    GibMeshWaitTimeBeforeDissolve=8.0
    bDestroyedByInterpActor=True
    bGameRelevant=True
    bCollideActors=True
    bProjTarget=True
    bNoEncroachCheck=True
    Components(0)="Default__AliceGib.GibLightEnvironmentComp"
    Physics="PHYS_RigidBody"
    TickGroup="TG_PostAsyncWork"
    LifeSpan=10.0
}

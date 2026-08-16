class PinballCannon extends SkeletalMeshActor
    native
    placeable
    hidecategories(Navigation);

var() float Strength;
var() name FireAnim;
var() name AttractAnim;
var() name IdleAnim;
var Emitter FireParticleEmitter;
var() ParticleSystem FireParticle;
var() ParticleSystem AttractParticle;
var() SoundCue FireSound;
var() SoundCue AttractSound;
var() SoundCue FullyChargedSound;
var() float RotationSpeed;
var() float RotationMaxPitch;
var() const export editconst editinline CylinderComponent CylinderComponent;
var() string UIText_Fire;
var AlicePawn PinBall;
var float curRotation;
var bool bPinBallAttracted;
var bool bBeginAttract;
var float curPitch;
var float curPitchSpeed;
var float CurForce;
var float MinForce;
var float ShootPower;
var MaterialInstanceConstant ChargeMatInst;

function ChangeRotation(float DeltaTime, AlicePlayerInput PlayerInput)
{
    local float maxPitch;
    local Rotator curRot;
    local float DeltaPitch;
    local Vector X, Y, Z, vDest;
    
    maxPitch = RotationMaxPitch * float(182);
    curRot = Rotation;
    PinBall.Controller.GetAxes(PinBall.Controller.Rotation, X, Y, Z);
    vDest = Normal(Y * PlayerInput.aStrafe + Z * PlayerInput.aForward);
    GetAxes(Rotation, X, Y, Z);
    if (PlayerInput.aForward != float(0) || PlayerInput.aStrafe != float(0))
    {
        if (Abs(PlayerInput.aForward) > Abs(PlayerInput.aStrafe))
        {
            if (Abs(X.Z - vDest.Z) < 0.002)
            {
                DeltaPitch = 0.0;
            }
            else if (Z.Z >= float(0))
            {
                DeltaPitch = (X.Z < vDest.Z ? RotationSpeed : -RotationSpeed);
            }
            else
            {
                DeltaPitch = (X.Z < vDest.Z ? -RotationSpeed : RotationSpeed);
            }
        }
        else if (Z Dot vDest > float(0))
        {
            DeltaPitch = RotationSpeed;
        }
        else
        {
            DeltaPitch = -RotationSpeed;
        }
        DeltaPitch *= DeltaTime / 0.0166;
        if (curPitch + DeltaPitch > maxPitch)
        {
            DeltaPitch = maxPitch - curPitch;
            curPitch = maxPitch;
        }
        else if (curPitch + DeltaPitch < -maxPitch)
        {
            DeltaPitch = -maxPitch - curPitch;
            curPitch = -maxPitch;
        }
        else
        {
            curPitch += DeltaPitch;
        }
        curRot.Pitch += int(DeltaPitch);
    }
    else
    {
        if (curPitchSpeed > float(0))
        {
            curPitchSpeed -= float(20);
        }
        CurForce = 0.0;
    }
    SetRotation(curRot);
}

function BeginAttractAgain()
{
    bBeginAttract = true;
}

function ShootOut()
{
    local float Force;
    
    bPinBallAttracted = false;
    PinBall.bAttractedByCannon = false;
    PinBall.Mesh.SetActorCollision(true, true, true);
    ShootPower = FClamp(ShootPower, 0.1, 1.0);
    Force = ShootPower * Strength;
    PinBall.Mesh.SetRBLinearVelocity(vector(Rotation) * Force, true);
    SetTimer(1.0, false, 'BeginAttractAgain');
    FireParticleEmitter = Spawn(class'Engine.EmitterSpawnable', self, , PinBall.Location);
    if (FireParticleEmitter != none && FireParticle != none)
    {
        FireParticleEmitter.SetLocation(PinBall.Location);
        FireParticleEmitter.SetTemplate(FireParticle, true);
    }
    PlaySound(FireSound);
    AlicePlayerController(WorldInfo.GetLocalPlayerPawn().Controller).ShowPOIUIHint(-1.0, UIText_Fire);
}

event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    local AlicePawn Alice;
    
    if (!bBeginAttract)
    {
        return;
    }
    Alice = AlicePawn(Other);
    if (Alice != none && Alice.bInRollingMode)
    {
        if (!bPinBallAttracted)
        {
            AlicePlayerController(WorldInfo.GetLocalPlayerPawn().Controller).ShowPOIUIHint(0.0, UIText_Fire);
        }
        PinBall = Alice;
        PinBall.bAttractedByCannon = true;
        PinBall.Pinball_Cannon = self;
        PinBall.Mesh.SetActorCollision(false, false, false);
        bPinBallAttracted = true;
        bBeginAttract = false;
        ShootPower = -100.0;
        if (AttractSound != none)
        {
            PlaySound(AttractSound);
        }
    }
}

event Tick(float DeltaTime)
{
    local Vector Loc;
    local Rotator Rot;
    local bool bSocketExist;
    
    if (bPinBallAttracted && PinBall != none)
    {
        bSocketExist = SkeletalMeshComponent.GetSocketWorldLocationAndRotation('PinballFirePoint', Loc, Rot);
        if (bSocketExist)
        {
            PinBall.Mesh.SetRBPosition(Loc);
            PinBall.Mesh.SetRBRotation(Rot);
        }
        else
        {
            PinBall.Mesh.SetRBPosition(Location);
            PinBall.Mesh.SetRBRotation(Rotation);
        }
    }
}

function turnoffChargeMat()
{
    ChargeMatInst.SetScalarParameterValue('ChargeAmount', 0.0);
}

function setChargeMat(float Alpha)
{
    ChargeMatInst.SetScalarParameterValue('ChargeAmount', Alpha);
}

simulated event PostBeginPlay()
{
    ChargeMatInst = new(self) class'Engine.MaterialInstanceConstant';
    ChargeMatInst.SetParent(SkeletalMeshComponent.GetMaterial(0));
    ChargeMatInst.SetScalarParameterValue('ChargeAmount', 0.0);
    SkeletalMeshComponent.SetMaterial(0, ChargeMatInst);
    SkeletalMeshComponent.SetMaterial(1, ChargeMatInst);
}

defaultproperties
{
    Strength=5000.0
    AttractSound="SFX_C5_OWHH.sfx_owhh_com_cannon_load_Cue"
    FullyChargedSound="SFX_C5_OWHH.sfx_owhh_com_cannon_charged_Cue"
    RotationSpeed=200.0
    RotationMaxPitch=80.0
    CylinderComponent="Default__PinballCannon.CollisionCylinder"
    UIText_Fire="ACT_OWHH_CANNON_FIRE"
    bBeginAttract=True
    ShootPower=-100.0
    SkeletalMeshComponent="Default__PinballCannon.SkeletalMeshComponent0"
    LightEnvironment="Default__PinballCannon.MyLightEnvironment"
    FacialAudioComp="Default__PinballCannon.FaceAudioComponent"
    bCollideActors=True
    Components(0)="Default__PinballCannon.MyLightEnvironment"
    Components(1)="Default__PinballCannon.SkeletalMeshComponent0"
    Components(2)="Default__PinballCannon.FaceAudioComponent"
    Components(3)="Default__PinballCannon.CollisionCylinder"
    CollisionComponent="Default__PinballCannon.CollisionCylinder"
}

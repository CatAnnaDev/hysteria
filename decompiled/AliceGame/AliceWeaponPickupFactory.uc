class AliceWeaponPickupFactory extends AlicePickupFactory
    placeable
    config(Weapon)
    hidecategories(Navigation,Lighting,LightColor,Force,PickupFactory);

struct UpgradeData
{
    var() int AliceWeaponLevel;
    var() int UpgradeWeaponLevel;
};

var class<AliceGameWeapon> WeaponPickupClass;
var bool bWeaponStay;
var bool bIsActive;
var export editinline ParticleSystemComponent BaseGlow;
var float WeaponPickupScaling;
var ParticleSystem PickedEffectTemplate;
var SoundCue PickupSound;
var() array<UpgradeData> UpgradeArray;

simulated function NotifyLocalPlayerDead(PlayerController PC)
{
}

simulated function ShowHidden()
{
    BaseGlow.DeactivateSystem();
    if (PickupMesh != none)
    {
        PickupMesh.SetHidden(true);
    }
    bIsActive = false;
}

simulated function ShowActive()
{
}

function SpawnCopyFor(Pawn Recipient)
{
    local Inventory Inv;
    local AliceInventoryManager AliceInvManager;
    local WeaponPara tempweaponpara;
    local int I;
    
    AliceInvManager = AliceInventoryManager(Recipient.InvManager);
    if (AliceInvManager != none)
    {
        Inv = AliceInvManager.HasInventoryOfClass(WeaponPickupClass);
        if (AliceGameWeapon(Inv) != none)
        {
            for (I = 0; I < UpgradeArray.Length; I++)
            {
                if (AliceInvManager.CheckWeaponUpgrade(UpgradeArray[I].AliceWeaponLevel, UpgradeArray[I].UpgradeWeaponLevel, WeaponPickupClass))
                {
                    if (PickupSound != none)
                    {
                        AlicePawn(Recipient).PlaySound(PickupSound, true);
                    }
                    return;
                }
            }
            AliceGameWeapon(Inv).AnnouncePickup(Recipient);
            return;
        }
    }
    Recipient.MakeNoise(0.2);
    foreach AlicePawn(Recipient).WeaponParas(tempweaponpara)
    {
        if (tempweaponpara.WeaponClass == WeaponPickupClass)
        {
            Inv = Spawn(tempweaponpara.WeaponClass, self, , , , tempweaponpara.WeaponArcheType);
        }
    }
    if (Inv != none)
    {
        Inv.GiveTo(Recipient);
        Inv.AnnouncePickup(Recipient);
        if (PickupSound != none)
        {
            AlicePawn(Recipient).PlaySound(PickupSound, true);
        }
    }
}

function PickedUpBy(Pawn P)
{
    if (bWeaponStay)
    {
        if (P.Controller != none && P.Controller.IsLocalPlayerController())
        {
            ShowHidden();
            SetTimer(30.0, false, 'ShowActive');
        }
    }
    PickedUpBy(P);
}

function StartSleeping()
{
    if (!bWeaponStay)
    {
        GotoState('Sleeping');
    }
}

function bool CheckForErrors()
{
    if (CheckForErrors())
    {
        return true;
    }
    if (WeaponPickupClass == none)
    {
        LogInternal(string(self) $ " no weapon pickup class");
        return true;
    }
    return false;
}

simulated event ReplicatedEvent(name VarName)
{
    if (VarName == 'InventoryType')
    {
        if (InventoryType != WeaponPickupClass)
        {
            WeaponPickupClass = class<AliceGameWeapon>(InventoryType);
            ReplicatedEvent(VarName);
        }
    }
    else
    {
        ReplicatedEvent(VarName);
    }
}

simulated function SetPickupMesh()
{
    if (PickupMesh != none)
    {
        PickupMesh.SetScale(PickupMesh.Scale * WeaponPickupScaling);
    }
}

simulated function SetPickupHidden()
{
    if (PickedEffectTemplate != none)
    {
        BaseGlow.SetTemplate(PickedEffectTemplate);
    }
    BaseGlow.SetActive(true);
    SetPickupHidden();
}

simulated function SetPickupVisible()
{
    BaseGlow.SetActive(true);
    SetPickupVisible();
}

simulated function InitializePickup()
{
    InventoryType = WeaponPickupClass;
    if (InventoryType == none)
    {
        GotoState('Disabled');
        return;
    }
    InitializePickup();
}

simulated function PostBeginPlay()
{
    PostBeginPlay();
}

auto state Pickup
{
    simulated event BeginState(name PreviousStateName)
    {
        BeginState(PreviousStateName);
        ShowActive();
    }
    
    simulated function bool ValidTouch(Pawn Other)
    {
        if (Role == 3)
        {
            return ValidTouch(Other);
        }
        if (Other == none || !Other.bCanPickupInventory || Other.Controller == none || !FastTrace(Other.Location, Location))
        {
            return false;
        }
        return true;
    }
    
    simulated event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
    {
        local Pawn Recipient;
        local Controller PickupController;
        
        if (!bWeaponStay)
        {
            Touch(Other, OtherComp, HitLocation, HitNormal);
            return;
        }
        Recipient = Pawn(Other);
        if (Recipient != none)
        {
            if (bIsActive)
            {
                PickupController = Recipient.Controller;
                if (PickupController == none && Recipient.DrivenVehicle != none)
                {
                    PickupController = Recipient.DrivenVehicle.Controller;
                }
                if (PickupController != none && PickupController.IsLocalPlayerController())
                {
                    ShowHidden();
                    SetTimer(30.0, false, 'ShowActive');
                }
            }
            if (Role == 3)
            {
                GiveTo(Recipient);
            }
        }
    }
    
    simulated function NotifyLocalPlayerDead(PlayerController PC)
    {
        if (bWeaponStay)
        {
            ShowActive();
        }
    }
    
    simulated function ShowActive()
    {
        BaseGlow.SetActive(true);
        bIsActive = true;
        if (PickupMesh != none)
        {
            PickupMesh.SetHidden(false);
        }
    }
    
    Stop;
}

defaultproperties
{
    bWeaponStay=True
    BaseGlow="Default__AliceWeaponPickupFactory.IdleEffect"
    WeaponPickupScaling=1.2
    PickupSound="SFX_Combat.Weapon_Pickup_Cue"
    UpgradeArray(0)=(AliceWeaponLevel=0,UpgradeWeaponLevel=1)
    UpgradeArray(1)=(AliceWeaponLevel=1,UpgradeWeaponLevel=2)
    UpgradeArray(2)=(AliceWeaponLevel=2,UpgradeWeaponLevel=3)
    UpgradeArray(3)=(AliceWeaponLevel=3,UpgradeWeaponLevel=4)
    UpgradeArray(4)=(AliceWeaponLevel=4,UpgradeWeaponLevel=5)
    UpgradeArray(5)=(AliceWeaponLevel=5,UpgradeWeaponLevel=6)
    UpgradeArray(6)=(AliceWeaponLevel=6,UpgradeWeaponLevel=7)
    UpgradeArray(7)=(AliceWeaponLevel=7,UpgradeWeaponLevel=8)
    UpgradeArray(8)=(AliceWeaponLevel=8,UpgradeWeaponLevel=9)
    UpgradeArray(9)=(AliceWeaponLevel=9,UpgradeWeaponLevel=10)
    bRotatingPickup=True
    bDoVisibilityFadeIn=False
    PickupItemRotationRate=(Pitch=0,Yaw=15000,Roll=0)
    BaseMesh="Default__AliceWeaponPickupFactory.BaseMeshComp"
    LightEnvironment="Default__AliceWeaponPickupFactory.PickupLightEnvironment"
    PickUpWaveForm="Default__AliceWeaponPickupFactory.ForceFeedbackWaveformPickUp"
    PickupMesh="Default__AliceWeaponPickupFactory.WeaponPickupMeshComp"
    CylinderComponent="Default__AliceWeaponPickupFactory.CollisionCylinder"
    bBlockActors=True
    Components(0)="Default__AliceWeaponPickupFactory.CollisionCylinder"
    Components(1)="Default__AliceWeaponPickupFactory.PathRenderer"
    Components(2)="Default__AliceWeaponPickupFactory.PickupLightEnvironment"
    Components(3)="Default__AliceWeaponPickupFactory.BaseMeshComp"
    Components(4)="Default__AliceWeaponPickupFactory.WeaponPickupMeshComp"
    Components(5)="Default__AliceWeaponPickupFactory.IdleEffect"
    CollisionComponent="Default__AliceWeaponPickupFactory.CollisionCylinder"
}

class DropItemsFactory extends Actor
    notplaceable
    config(Game)
    hidecategories(Navigation);

enum EBreakableXPType
{
    UseManualAmountXP,
    UseSmallAmountXP,
    UseMiddleAmountXP,
    UseLargeAmountXP,
};

var config float PickUpDrawScale;
var int nLayoutRadius;
var array<SmartHP> SmartDropHealth;
var XPPickup LargeXPPickupArchetype;
var XPPickup SmallXPPickupArchetype;
var HealthPickup LargeHealthPickupArchetype;
var HealthPickup SmallHealthPickupArchetype;
var const int BigHP;
var const int SmallHP;

function DropPickupsForGBA(bool bCanSpawnHealth, bool bCanSpawnXP, bool UseSmartHealthSpawn, int nManualHPAmount, int nManualXPAmount, EBreakableXPType FixedXPEnum, optional int LayoutRadius = 100)
{
    local int nLargeHP, nSmallHP, nLargeXP, nSmallXP, nXPValue, nHPValue;
    local AlicePawn AlicePawn;
    
    AlicePawn = AlicePawn(WorldInfo.GetLocalPlayerPawn());
    nLayoutRadius = LayoutRadius;
    if (bCanSpawnHealth)
    {
        if (UseSmartHealthSpawn)
        {
            nHPValue = GetSmartDropHPValue();
        }
        else
        {
            nHPValue = nManualHPAmount;
        }
        if (AlicePawn != none)
        {
            nHPValue = int(float(nHPValue) * (1.0 + AlicePawn.BreakableDropMoreHP_Percent));
        }
        nLargeHP = nHPValue / BigHP;
        nSmallHP = (nHPValue % BigHP) / SmallHP;
    }
    if (bCanSpawnXP)
    {
        nXPValue = GetGBADropXPValue(FixedXPEnum, nManualXPAmount);
        if (AlicePawn != none)
        {
            nXPValue = int(float(nXPValue) * (1.0 + AlicePawn.BreakableDropMoreXP_Percent));
        }
        nLargeXP = nXPValue / LargeXPPickupArchetype.XPValue;
        nSmallXP = (nXPValue % LargeXPPickupArchetype.XPValue) / SmallXPPickupArchetype.XPValue;
    }
    SpawnPickups(nLargeHP, nSmallHP, nLargeXP, nSmallXP);
}

function DropPickupsForNPC(bool bCanSpawnHealth, bool bCanSpawnXP, bool UseSmartHealthSpawn, int nManualHPAmount, int nManualXPAmount, EXPType FixedXPEnum, optional int LayoutRadius = 100, optional bool bForceUseManualHP = false, optional bool bForceUseManualXP = false)
{
    local int nLargeHP, nSmallHP, nLargeXP, nSmallXP, nXPValue, nHPValue;
    local AlicePawn AlicePawn;
    
    AlicePawn = AlicePawn(WorldInfo.GetLocalPlayerPawn());
    nLayoutRadius = LayoutRadius;
    if (bCanSpawnHealth)
    {
        if (UseSmartHealthSpawn && !bForceUseManualHP)
        {
            nHPValue = GetSmartDropHPValue();
        }
        else
        {
            nHPValue = nManualHPAmount;
        }
        if (AlicePawn != none)
        {
            nHPValue = int(float(nHPValue) * (1.0 + AlicePawn.NPCDropMoreHP_Percent));
        }
        nLargeHP = nHPValue / BigHP;
        nSmallHP = (nHPValue % BigHP) / SmallHP;
    }
    if (bCanSpawnXP)
    {
        if (bForceUseManualXP)
        {
            nXPValue = nManualXPAmount;
        }
        else
        {
            nXPValue = GetNPCDropXPValue(FixedXPEnum, nManualXPAmount);
        }
        if (AlicePawn != none)
        {
            nXPValue = int(float(nXPValue) * (1.0 + AlicePawn.NPCDropMoreXP_Percent));
        }
        nLargeXP = nXPValue / LargeXPPickupArchetype.XPValue;
        nSmallXP = (nXPValue % LargeXPPickupArchetype.XPValue) / SmallXPPickupArchetype.XPValue;
    }
    if (AlicePawn.bDisableHPDrops)
    {
        nLargeHP = 0;
        nSmallHP = 0;
    }
    SpawnPickups(nLargeHP, nSmallHP, nLargeXP, nSmallXP);
}

function SpawnPickups(int nLargeHP, int nSmallHP, int nLargeXP, int nSmallXP, optional bool bNoCollisionFail = false)
{
    local HealthPickup HP;
    local XPPickup XP;
    local int nHP, nXP, I, Count;
    local float offsetAngle;
    local Vector Offset;
    local AlicePawn AlicePawn;
    local Rotator Rot;
    
    AlicePawn = AlicePawn(WorldInfo.GetLocalPlayerPawn());
    nXP = nLargeXP + nSmallXP;
    nHP = nLargeHP + nSmallHP;
    if (AlicePawn.bAllowToDropHpPickUp == false && AlicePawn.bInHysteriaMode)
    {
        nHP = 0;
    }
    if (AlicePawn.bAllowToDropExpPickUp == false && AlicePawn.bInHysteriaMode)
    {
        nXP = 0;
    }
    Count = nHP + nXP;
    if (Count <= 0)
    {
        return;
    }
    Rot = rotator(vect(1.0, 0.0, 0.0));
    for (I = 0; I < Count; I++)
    {
        offsetAngle = RandRange(0.0, 360.0);
        Offset.X = RandRange(0.5, 1.5) * float(nLayoutRadius) * Sin(offsetAngle * 0.017453292);
        Offset.Y = RandRange(0.5, 1.5) * float(nLayoutRadius) * Cos(offsetAngle * 0.017453292);
        Offset.Z = 50.0;
        if (I < nHP)
        {
            if (I < nLargeHP)
            {
                HP = Spawn(class'HealthPickup', none, , Location + Offset, Rot, LargeHealthPickupArchetype, bNoCollisionFail);
            }
            else
            {
                HP = Spawn(class'HealthPickup', none, , Location + Offset, Rot, SmallHealthPickupArchetype, bNoCollisionFail);
            }
            HP.SetPhysics(2);
            if (AlicePawn.bInGiantMode)
            {
                HP.SetDrawScale(PickUpDrawScale);
            }
            continue;
        }
        if (I < nHP + nLargeXP)
        {
            XP = Spawn(class'XPPickup', none, , Location + Offset, Rot, LargeXPPickupArchetype, bNoCollisionFail);
        }
        else
        {
            XP = Spawn(class'XPPickup', none, , Location + Offset, Rot, SmallXPPickupArchetype, bNoCollisionFail);
        }
        XP.SetPhysics(2);
        if (AlicePawn.bInGiantMode)
        {
            XP.SetDrawScale(PickUpDrawScale);
        }
    }
}

function int GetGBADropXPValue(EBreakableXPType FixedXPEnum, int nManualXPAmount)
{
    local int nXPValue;
    local AlicePawn AlicePawn;
    
    AlicePawn = AlicePawn(WorldInfo.GetLocalPlayerPawn());
    if (AlicePawn == none)
    {
        return 0;
    }
    switch (FixedXPEnum)
    {
        case 0:
            nXPValue = nManualXPAmount;
            break;
        case 1:
            nXPValue = AlicePawn.SmallAmountXP;
            break;
        case 2:
            nXPValue = AlicePawn.MiddleAmountXP;
            break;
        case 3:
            nXPValue = AlicePawn.LargeAmountXP;
            break;
        default:
    }
    return nXPValue;
}

function int GetNPCDropXPValue(EXPType FixedXPEnum, int nManualXPAmount)
{
    local int nXPValue;
    local AlicePawn AlicePawn;
    
    AlicePawn = AlicePawn(WorldInfo.GetLocalPlayerPawn());
    switch (FixedXPEnum)
    {
        case 0:
            nXPValue = nManualXPAmount;
            break;
        case 1:
            nXPValue = AlicePawn.GetT2SmlXPAmount();
            break;
        case 2:
            nXPValue = AlicePawn.GetT2MedXPAmount();
            break;
        case 3:
            nXPValue = AlicePawn.GetT2LgeXPAmount();
            break;
        case 4:
            nXPValue = AlicePawn.GetT1MedXPAmount();
            break;
        case 5:
            nXPValue = AlicePawn.GetT1LgeXPAmount();
            break;
        case 6:
            nXPValue = AlicePawn.GetT1BossXPAmount();
            break;
        default:
    }
    return nXPValue;
}

function int GetSmartDropHPValue()
{
    local AlicePawn AlicePawn;
    local int AliceHP, I, nHPValue;
    
    AlicePawn = AlicePawn(WorldInfo.GetLocalPlayerPawn());
    SmartDropHealth = AlicePawn.GetSmartDropHealthArray();
    if (SmartDropHealth.Length <= 0)
    {
        return 0;
    }
    ResetProbabilityArray();
    AliceHP = int(float(100) * (float(AlicePawn.Health) * 1.0 / float(AlicePawn.HealthMax)));
    if (SmartDropHealth.Length == 1)
    {
        if (AliceHP <= SmartDropHealth[0].HPPercentage)
        {
            nHPValue = GetHealthByProbability(0);
        }
    }
    else if (AliceHP <= SmartDropHealth[SmartDropHealth.Length - 1].HPPercentage)
    {
        nHPValue = GetHealthByProbability(SmartDropHealth.Length - 1);
    }
    else
    {
        for (I = 0; I < SmartDropHealth.Length - 1; I++)
        {
            if (AliceHP <= SmartDropHealth[I].HPPercentage && AliceHP > SmartDropHealth[I + 1].HPPercentage)
            {
                nHPValue = GetHealthByProbability(I);
                break;
            }
        }
    }
    return nHPValue;
}

function int GetHealthByProbability(int Index)
{
    local float Probability;
    local int J;
    
    for (J = 0; J < SmartDropHealth[Index].DropProbability.Length; J++)
    {
        if (J == 0)
        {
            SmartDropHealth[Index].DropProbability[0].BeginNumber = 0.0;
            SmartDropHealth[Index].DropProbability[0].EndNumber = SmartDropHealth[Index].DropProbability[0].Probability;
            continue;
        }
        SmartDropHealth[Index].DropProbability[J].BeginNumber = SmartDropHealth[Index].DropProbability[J - 1].EndNumber;
        SmartDropHealth[Index].DropProbability[J].EndNumber = SmartDropHealth[Index].DropProbability[J].BeginNumber + SmartDropHealth[Index].DropProbability[J].Probability;
    }
    Probability = RandRange(0.0, 1.0);
    for (J = 0; J < SmartDropHealth[Index].DropProbability.Length; J++)
    {
        if (Probability >= SmartDropHealth[Index].DropProbability[J].BeginNumber && Probability <= SmartDropHealth[Index].DropProbability[J].EndNumber)
        {
            return SmartDropHealth[Index].DropProbability[J].HP;
        }
    }
    return 0;
}

function ResetProbabilityArray()
{
    local int I, J;
    
    for (I = 0; I < SmartDropHealth.Length; I++)
    {
        for (J = 0; J < SmartDropHealth[I].DropProbability.Length; J++)
        {
            SmartDropHealth[I].DropProbability[J].BeginNumber = 0.0;
            SmartDropHealth[I].DropProbability[J].EndNumber = 0.0;
        }
    }
}

function SetXPArchetype(XPPickup LargeXPArchetype, XPPickup SmallXPArchetype)
{
    LargeXPPickupArchetype = LargeXPArchetype;
    SmallXPPickupArchetype = SmallXPArchetype;
}

function SetHealthArchetype(HealthPickup LargeHPArchetype, HealthPickup SmallHPArchetype)
{
    LargeHealthPickupArchetype = LargeHPArchetype;
    SmallHealthPickupArchetype = SmallHPArchetype;
}

simulated event PostBeginPlay()
{
    PostBeginPlay();
    LifeSpan = 5.0;
}

defaultproperties
{
    PickUpDrawScale=0.3
    BigHP=8
    SmallHP=4
    CollisionType="COLLIDE_CustomDefault"
}

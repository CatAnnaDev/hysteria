class SeqEvent_TakeDamage extends SequenceEvent
    native
    notplaceable
    hidecategories(Object);

var() float MinDamageAmount;
var() float DamageThreshold;
var() array<class<DamageType>> DamageTypes;
var() array<class<DamageType>> IgnoreDamageTypes;
var float CurrentDamage;
var() bool bResetDamageOnToggle;

event Toggled()
{
    if (bResetDamageOnToggle)
    {
        CurrentDamage = 0.0;
    }
    Toggled();
}

static event int GetObjClassVersion()
{
    return GetObjClassVersion() + 2;
}

function Reset()
{
    Reset();
    CurrentDamage = 0.0;
}

final function HandleDamage(Actor InOriginator, Actor InInstigator, class<DamageType> inDamageType, int inAmount)
{
    local SeqVar_Float FloatVar;
    local bool bAlreadyActivatedThisTick;
    
    if (InOriginator != none && bEnabled && float(inAmount) >= MinDamageAmount && IsValidDamageType(inDamageType) && !bPlayerOnly || InInstigator != none && InInstigator.IsPlayerOwned())
    {
        CurrentDamage += float(inAmount);
        if (CurrentDamage >= DamageThreshold)
        {
            bAlreadyActivatedThisTick = bActive && ActivationTime ~= GetWorldInfo().TimeSeconds;
            if (CheckActivate(InOriginator, InInstigator, false))
            {
                foreach LinkedVariables(class'SeqVar_Float', FloatVar, "Damage Taken")
                {
                    if (bAlreadyActivatedThisTick)
                    {
                        FloatVar.FloatValue += CurrentDamage;
                        continue;
                    }
                    FloatVar.FloatValue = CurrentDamage;
                }
                if (DamageThreshold <= 0.0)
                {
                    CurrentDamage = 0.0;
                }
                else
                {
                    CurrentDamage -= DamageThreshold;
                }
            }
        }
    }
}

final function bool IsValidDamageType(class<DamageType> inDamageType)
{
    local int Idx;
    local bool bValidDamageType;
    
    if (DamageTypes.Length > 0)
    {
        bValidDamageType = false;
        for (Idx = 0; Idx < DamageTypes.Length; Idx++)
        {
            if (ClassIsChildOf(inDamageType, DamageTypes[Idx]))
            {
                bValidDamageType = true;
                break;
            }
        }
        if (!bValidDamageType)
        {
            return false;
        }
    }
    if (IgnoreDamageTypes.Length > 0)
    {
        for (Idx = 0; Idx < IgnoreDamageTypes.Length; Idx++)
        {
            if (ClassIsChildOf(inDamageType, IgnoreDamageTypes[Idx]))
            {
                return false;
            }
        }
    }
    return true;
}

defaultproperties
{
    DamageThreshold=100.0
    bResetDamageOnToggle=True
    VariableLinks(0)=(ExpectedType="SeqVar_Object",LinkedVariables=(),LinkDesc="Instigator",LinkVar="None",PropertyName="None",bWriteable=True,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(1)=(ExpectedType="SeqVar_Float",LinkedVariables=(),LinkDesc="Damage Taken",LinkVar="None",PropertyName="None",bWriteable=True,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    ObjName="Take Damage"
    ObjCategory="Actor"
}

class SeqAct_AliceAbilityControl extends SequenceAction
    native
    notplaceable
    hidecategories(Object);

var() EAliceAbilityControl AbilityToControl;
var transient AlicePlayerController APC;
var transient AlicePawn Alice;

event RemoveTeapotCannon()
{
}

event RemovePiperGrinder()
{
}

event RemoveHobbyHorse()
{
}

event RemoveVorpalBlade()
{
}

event AddTeapotCannon()
{
    if (APC.WeaponLevel[2] == 0)
    {
        APC.AddNewAliceWeapon(class'TeapotCannon', 1);
    }
}

event AddPiperGrinder()
{
    if (APC.WeaponLevel[3] == 0)
    {
        APC.AddNewAliceWeapon(class'EyeStaff', 1);
    }
}

event AddHobbyHorse()
{
    if (APC.WeaponLevel[1] == 0)
    {
        APC.AddNewAliceWeapon(class'HobbyHorse', 1);
    }
}

event AddVorpalBlade()
{
    if (APC.WeaponLevel[0] == 0)
    {
        APC.AddNewAliceWeapon(class'VorpalBlade', 1);
    }
}

defaultproperties
{
    InputLinks(0)=(LinkDesc="Add",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    InputLinks(1)=(LinkDesc="Remove",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    ObjName="AliceAbilities"
    ObjCategory="Alice"
}

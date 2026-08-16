class SeqCond_IsLoggedIn extends SequenceCondition
    native
    notplaceable
    hidecategories(Object);

var() int NumNeededLoggedIn;

event bool CheckLogins()
{
    local int LoggedInCount, Count;
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterface PlayerInt;
    
    OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != none)
    {
        PlayerInt = OnlineSub.PlayerInterface;
        if (NotEqual_InterfaceInterface(PlayerInt, OnlinePlayerInterface(none)))
        {
            for (Count = 0; Count < NumNeededLoggedIn; Count++)
            {
                if (PlayerInt.GetLoginStatus(byte(Count)) >= 1)
                {
                    LoggedInCount++;
                }
            }
        }
    }
    return LoggedInCount >= NumNeededLoggedIn;
}

defaultproperties
{
    OutputLinks(0)=(Links=(),LinkDesc="True",bHasImpulse=False,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",ActivateDelay=0.0,DrawY=0,bHidden=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    OutputLinks(1)=(Links=(),LinkDesc="False",bHasImpulse=False,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",ActivateDelay=0.0,DrawY=0,bHidden=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(0)=(ExpectedType="SeqVar_Int",LinkedVariables=(),LinkDesc="NeededLoggedIn",LinkVar="None",PropertyName="NumNeededLoggedIn",bWriteable=False,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    ObjName="Is Logged In"
}

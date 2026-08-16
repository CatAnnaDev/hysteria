class AliceObjectiveManager extends Object
    native
    notplaceable
    within AlicePlayerController;

var array<ObjectiveInfo> Objectives;
var const float TotalDisplayTime;
var const int TotalObjectivesToDraw;
var const localized string ObjectivesCompleteText;
var AlicePlayerController Controller;

function DrawObjectives(string ObjectiveDesc)
{
    AliceGameInfo(Outer.WorldInfo.Game).GFxHUDMenu.DrawObjectiveDesc(Controller, ObjectiveDesc);
}

final function FailObjective(name ObjName, bool bNotifyPlayer)
{
    local int Idx;
    
    if (ObjName != 'None')
    {
        Idx = Objectives.Find('ObjectiveName', ObjName);
        if (Idx != -1)
        {
            UpdateObjective(ObjName, Objectives[Idx].ObjectiveDesc, false, false, true, bNotifyPlayer);
            DrawObjectives(RetrieveObjectiveString("FailComment") @ RetrieveObjectiveString(Objectives[Idx].ObjectiveDesc));
            if (bNotifyPlayer)
            {
            }
        }
    }
}

final function CompleteObjective(name ObjName, bool bNotifyPlayer)
{
    local int Idx;
    local string CompleteComment;
    
    if (ObjName != 'None')
    {
        Idx = Objectives.Find('ObjectiveName', ObjName);
        if (Idx != -1)
        {
            UpdateObjective(ObjName, Objectives[Idx].ObjectiveDesc, false, true, false, bNotifyPlayer);
            CompleteComment = RetrieveObjectiveString("CompleteComment");
            DrawObjectives(CompleteComment @ RetrieveObjectiveString(Objectives[Idx].ObjectiveDesc));
            if (bNotifyPlayer)
            {
            }
        }
    }
}

final function AddObjective(name ObjName, string ObjDesc, bool bNotifyPlayer)
{
    local int Idx;
    local bool bUpdate;
    
    if (ObjName != 'None')
    {
        Idx = Objectives.Find('ObjectiveName', ObjName);
        bUpdate = (Idx == -1 ? false : true);
        UpdateObjective(ObjName, ObjDesc, bUpdate, false, false, bNotifyPlayer);
        DrawObjectives(RetrieveObjectiveString("AddComment") @ RetrieveObjectiveString(ObjDesc));
        if (bNotifyPlayer)
        {
            if (bUpdate)
            {
            }
        }
    }
}

protected final function UpdateObjective(name ObjectiveName, string ObjectiveDesc, bool bUpdated, bool bCompleted, bool bFailed, bool bNotifyPlayer)
{
    local int Idx;
    
    Idx = Objectives.Find('ObjectiveName', ObjectiveName);
    if (Idx == -1)
    {
        Idx = Objectives.Length;
        Objectives.Length = Idx + 1;
        Objectives[Idx].ObjectiveName = ObjectiveName;
    }
    Objectives[Idx].bUpdated = bUpdated;
    Objectives[Idx].bCompleted = bCompleted;
    Objectives[Idx].bFailed = bFailed;
    Objectives[Idx].ObjectiveDesc = ObjectiveDesc;
    Objectives[Idx].UpdatedTime = Outer.WorldInfo.TimeSeconds;
    Objectives[Idx].bNotifyPlayer = bNotifyPlayer;
}

final function ClearObjectives()
{
    Objectives.Length = 0;
}

final function OnManageObjectives(SeqAct_ManageObjectives Action)
{
    if (Action.InputLinks[0].bHasImpulse)
    {
        AddObjective(Action.ObjectiveName, Action.ObjectiveDesc, Action.bNotifyPlayer);
    }
    else if (Action.InputLinks[1].bHasImpulse)
    {
        CompleteObjective(Action.ObjectiveName, Action.bNotifyPlayer);
    }
    else if (Action.InputLinks[2].bHasImpulse)
    {
        FailObjective(Action.ObjectiveName, Action.bNotifyPlayer);
    }
}

native simulated function string RetrieveObjectiveString(string TagName)
{
    TagName;
}

defaultproperties
{
    TotalDisplayTime=5.0
    TotalObjectivesToDraw=3
}

class CoverLink extends NavigationPoint
    native
    placeable
    config(Game)
    hidecategories(Navigation,Lighting,LightColor,Force);

const COVERLINK_DangerDist = 1536.f;
const COVERLINK_EdgeExposureDot = 0.85f;
const COVERLINK_EdgeCheckDot = 0.25f;
const COVERLINK_ExposureDot = 0.4f;

enum ECoverLocationDescription
{
    CoverDesc_None,
    CoverDesc_InWindow,
    CoverDesc_InDoorway,
    CoverDesc_BehindCar,
    CoverDesc_BehindTruck,
    CoverDesc_OnTruck,
    CoverDesc_BehindBarrier,
    CoverDesc_BehindColumn,
    CoverDesc_BehindCrate,
    CoverDesc_BehindWall,
    CoverDesc_BehindStatue,
    CoverDesc_BehindSandbags,
};

enum ECoverType
{
    CT_None,
    CT_Standing,
    CT_MidLevel,
};

enum ECoverDirection
{
    CD_Default,
    CD_Left,
    CD_Right,
    CD_Up,
};

enum ECoverAction
{
    CA_Default,
    CA_BlindLeft,
    CA_BlindRight,
    CA_LeanLeft,
    CA_LeanRight,
    CA_PopUp,
    CA_BlindUp,
    CA_PeekLeft,
    CA_PeekRight,
    CA_PeekUp,
    CA_SwatTurn,
};

struct native immutable CoverSlot
{
    var Pawn SlotOwner;
    var transient float SlotValidAfterTime;
    var() ECoverType ForceCoverType;
    var(Auto) editconst ECoverType CoverType;
    var Vector LocationOffset;
    var Rotator RotationOffset;
    var array<ECoverAction> Actions;
    var array<FireLink> FireLinks;
    var array<FireLink> ForcedFireLinks;
    var transient array<FireLink> RejectedFireLinks;
    var() array<ExposedLink> ExposedFireLinks;
    var() array<DangerLink> DangerLinks;
    var array<CoverReference> TurnTarget;
    var array<SlotMoveRef> SlipRefs;
    var(Auto) editconst array<CoverReference> OverlapClaims;
    var(Auto) bool bLeanLeft;
    var(Auto) bool bLeanRight;
    var(Auto) bool bForceCanPopUp;
    var(Auto) editconst bool bCanPopUp;
    var(Auto) editconst bool bCanMantle;
    var(Auto) editconst bool bCanClimbUp;
    var(Auto) bool bForceCanCoverSlip_Left;
    var(Auto) bool bForceCanCoverSlip_Right;
    var(Auto) editconst bool bCanCoverSlip_Left;
    var(Auto) editconst bool bCanCoverSlip_Right;
    var(Auto) editconst bool bCanSwatTurn_Left;
    var(Auto) editconst bool bCanSwatTurn_Right;
    var() bool bEnabled;
    var() bool bAllowPopup;
    var() bool bAllowMantle;
    var() bool bAllowCoverSlip;
    var() bool bAllowClimbUp;
    var() bool bAllowSwatTurn;
    var() bool bForceNoGroundAdjust;
    var() bool bPlayerOnly;
    var transient bool bSelected;
    var() int ExtraCost;
    var float LeanTraceDist;
    var() editconst CoverSlotMarker SlotMarker;
    var() ECoverLocationDescription LocationDescription;
    var bool bFailedToFindSurface;
};

struct native immutable SlotMoveRef
{
    var() PolyReference Poly;
    var() BasedPosition Dest;
    var() int Direction;
};

struct native immutable DangerLink
{
    var() const editconst ActorReference DangerNav;
    var() int DangerCost;
};

struct native immutable ExposedLink
{
    var() const editconst CoverReference TargetActor;
    var() byte ExposedScale;
};

struct native immutable DynamicLinkInfo
{
    var Vector LastTargetLocation;
    var Vector LastSrcLocation;
};

struct native immutable FireLink
{
    var() const editconst CoverReference TargetActor;
    var array<FireLinkItem> Items;
    var byte DynamicLinkInfoIndex;
    var byte DynamicLinkInfoIndexHigh;
    var bool bDynamicIndexInited;
    var bool bFallbackLink;
};

struct native immutable FireLinkItem
{
    var ECoverType SrcType;
    var ECoverAction SrcAction;
    var ECoverType DestType;
    var ECoverAction DestAction;
};

struct native immutable CovPosInfo
{
    var CoverLink Link;
    var int LtSlotIdx;
    var int RtSlotIdx;
    var float LtToRtPct;
    var Vector Location;
    var Vector Normal;
    var Vector Tangent;
};

struct native immutable TargetInfo
{
    var Actor Target;
    var int SlotIdx;
    var int Direction;
};

struct native immutable CoverInfo
{
    var() editconst CoverLink Link;
    var() editconst int SlotIdx;
};

struct native immutable LinkSlotHelper
{
    var() CoverLink Link;
    var() array<int> Slots;
};

struct native immutable CoverReference extends ActorReference
{
    var() int SlotIdx;
    var() int Direction;
};

var globalconfig bool GLOBAL_bUseSlotMarkers;
var() bool bDisabled;
var() bool bClaimAllSlots;
var bool bAutoSort;
var() bool bAutoAdjust;
var() bool bCircular;
var() bool bLooped;
var() bool bPlayerOnly;
var bool bDynamicCover;
var(Debug) bool bDebug_FireLinks;
var(Debug) bool bDebug_ExposedLinks;
var(Debug) bool bDebug_DangerLinks;
var() editinline array<CoverSlot> Slots;
var array<DynamicLinkInfo> DynamicLinkInfos;
var array<Pawn> Claims;
var() float InvalidateDistance;
var() float MaxFireLinkDist;
var const Vector CircularOrigin;
var const float CircularRadius;
var const float AlignDist;
var const float AutoCoverSlotInterval;
var const float StandHeight;
var const float MidHeight;
var const Vector StandingLeanOffset;
var const Vector CrouchLeanOffset;
var const Vector PopupOffset;
var const float SlipDist;
var const float TurnDist;
var() float DangerScale;
var const CoverLink NextCoverLink;
var() const ECoverLocationDescription LocationDescription;

simulated event string GetDebugAbbrev()
{
    return "CL";
}

native final simulated function ECoverLocationDescription GetLocationDescription(int SlotIdx)
{
    SlotIdx;
}

final simulated event string GetDebugString(int SlotIdx)
{
    return "L:" $ GetRightMost(string(self)) @ "S:" $ string(SlotIdx) @ "M:" $ GetRightMost(string(GetSlotMarker(SlotIdx)));
}

native final function int AddCoverSlot(Vector SlotLocation, Rotator SlotRotation, optional int SlotIdx = -1, optional bool bForceSlotUpdate)
{
    SlotLocation;
    SlotRotation;
    SlotIdx;
    bForceSlotUpdate;
}

simulated event Tick(float DeltaTime)
{
    local int SlotIdx;
    local CoverSlot Slot;
    local Vector OwnerLoc;
    local byte R, G, B;
    
    Tick(DeltaTime);
    if (bDebug)
    {
        for (SlotIdx = 0; SlotIdx < Slots.Length; SlotIdx++)
        {
            Slot = Slots[SlotIdx];
            if (Slot.SlotOwner != none)
            {
                if (Slot.SlotOwner != none)
                {
                    OwnerLoc = Slot.SlotOwner.Location;
                    R = 166;
                    G = 236;
                    B = 17;
                }
                else
                {
                    OwnerLoc = vect(0.0, 0.0, 0.0);
                    R = 170;
                    G = 0;
                    B = 0;
                }
                DrawDebugLine(GetSlotLocation(SlotIdx), OwnerLoc, R, G, B);
            }
        }
    }
}

simulated function bool GetSwatTurnTarget(int SlotIdx, int Direction, out CoverReference out_Info)
{
    local int TurnIdx, Num;
    
    Num = Slots[SlotIdx].TurnTarget.Length;
    for (TurnIdx = 0; TurnIdx < Num; TurnIdx++)
    {
        if (Slots[SlotIdx].TurnTarget[TurnIdx].Direction == Direction)
        {
            out_Info.Actor = Slots[SlotIdx].TurnTarget[TurnIdx].Actor;
            out_Info.SlotIdx = Slots[SlotIdx].TurnTarget[TurnIdx].SlotIdx;
            out_Info.Direction = Slots[SlotIdx].TurnTarget[TurnIdx].Direction;
            break;
        }
    }
    return out_Info.Actor != none;
}

simulated event ShutDown()
{
    local int SlotIdx;
    
    ShutDown();
    bDisabled = true;
    for (SlotIdx = 0; SlotIdx < Slots.Length; SlotIdx++)
    {
        if (Slots[SlotIdx].SlotMarker != none)
        {
            Slots[SlotIdx].SlotMarker.ShutDown();
        }
    }
}

function OnToggle(SeqAct_Toggle inAction)
{
    local int SlotIdx;
    local CoverReplicator CoverReplicator;
    
    OnToggle(inAction);
    if (inAction.InputLinks[0].bHasImpulse)
    {
        bDisabled = false;
    }
    else if (inAction.InputLinks[1].bHasImpulse)
    {
        bDisabled = true;
    }
    else
    {
        bDisabled = !bDisabled;
    }
    for (SlotIdx = 0; SlotIdx < Slots.Length; SlotIdx++)
    {
        if (Slots[SlotIdx].SlotMarker != none)
        {
            Slots[SlotIdx].SlotMarker.OnToggle(inAction);
        }
    }
    CoverReplicator = WorldInfo.Game.GetCoverReplicator();
    if (CoverReplicator != none)
    {
        CoverReplicator.NotifyLinkDisabledStateChange(self);
    }
}

native final function bool IsEnabled()
{
}

native final function bool AutoAdjustSlot(int SlotIdx, bool bOnlyCheckLeans)
{
    SlotIdx;
    bOnlyCheckLeans;
}

function OnModifyCover(SeqAct_ModifyCover Action)
{
    local array<int> SlotIndices;
    local int Idx, SlotIdx;
    local CoverReplicator CoverReplicator;
    
    if (Action.Slots.Length > 0)
    {
        SlotIndices = Action.Slots;
    }
    else
    {
        for (Idx = 0; Idx < Slots.Length; Idx++)
        {
            SlotIndices[SlotIndices.Length] = Idx;
        }
    }
    for (Idx = 0; Idx < SlotIndices.Length; Idx++)
    {
        SlotIdx = SlotIndices[Idx];
        if (SlotIdx >= 0 && SlotIdx < Slots.Length)
        {
            if (Action.InputLinks[0].bHasImpulse)
            {
                SetSlotEnabled(SlotIdx, true);
                continue;
            }
            if (Action.InputLinks[1].bHasImpulse)
            {
                SetSlotEnabled(SlotIdx, false);
                continue;
            }
            if (Action.InputLinks[2].bHasImpulse)
            {
                if (AutoAdjustSlot(SlotIdx, false) && Slots[SlotIdx].SlotOwner != none && Slots[SlotIdx].SlotOwner.Controller != none)
                {
                    Slots[SlotIdx].SlotOwner.Controller.NotifyCoverAdjusted();
                }
                continue;
            }
            if (Action.InputLinks[3].bHasImpulse)
            {
                if (Action.ManualCoverType != 0)
                {
                    Slots[SlotIdx].CoverType = Action.ManualCoverType;
                    if (Slots[SlotIdx].SlotOwner != none && Slots[SlotIdx].SlotOwner.Controller != none)
                    {
                        Slots[SlotIdx].SlotOwner.Controller.NotifyCoverAdjusted();
                    }
                }
                Slots[SlotIdx].bPlayerOnly = Action.bManualAdjustPlayersOnly;
            }
        }
    }
    CoverReplicator = WorldInfo.Game.GetCoverReplicator();
    if (CoverReplicator != none)
    {
        if (Action.InputLinks[0].bHasImpulse)
        {
            CoverReplicator.NotifyEnabledSlots(self, SlotIndices);
        }
        else if (Action.InputLinks[1].bHasImpulse)
        {
            CoverReplicator.NotifyDisabledSlots(self, SlotIndices);
        }
        else if (Action.InputLinks[2].bHasImpulse)
        {
            CoverReplicator.NotifyAutoAdjustSlots(self, SlotIndices);
        }
        else if (Action.InputLinks[3].bHasImpulse)
        {
            CoverReplicator.NotifySetManualCoverTypeForSlots(self, SlotIndices, Action.ManualCoverType);
        }
    }
}

simulated function NotifySlotOwnerCoverDisabled(int SlotIdx)
{
    local int LeftIdx, RightIdx;
    
    if (Slots[SlotIdx].SlotOwner != none && Slots[SlotIdx].SlotOwner.Controller != none)
    {
        Slots[SlotIdx].SlotOwner.Controller.NotifyCoverDisabled(self, SlotIdx, false);
    }
    LeftIdx = GetSlotIdxToLeft(SlotIdx);
    if (LeftIdx >= 0 && Slots[LeftIdx].SlotOwner != none && Slots[LeftIdx].SlotOwner.Controller != none)
    {
        Slots[LeftIdx].SlotOwner.Controller.NotifyCoverDisabled(self, SlotIdx, true);
    }
    RightIdx = GetSlotIdxToRight(SlotIdx);
    if (RightIdx >= 0 && Slots[RightIdx].SlotOwner != none && Slots[RightIdx].SlotOwner.Controller != none)
    {
        Slots[RightIdx].SlotOwner.Controller.NotifyCoverDisabled(self, SlotIdx, true);
    }
}

simulated event SetSlotEnabled(int SlotIdx, bool bEnable)
{
    Slots[SlotIdx].bEnabled = bEnable;
    if (!bEnable)
    {
        NotifySlotOwnerCoverDisabled(SlotIdx);
    }
}

simulated event SetDisabled(bool bNewDisabled)
{
    local int SlotIdx;
    local CoverReplicator CoverReplicator;
    
    bDisabled = bNewDisabled;
    if (bDisabled)
    {
        for (SlotIdx = 0; SlotIdx < Slots.Length; SlotIdx++)
        {
            NotifySlotOwnerCoverDisabled(SlotIdx);
        }
    }
    CoverReplicator = WorldInfo.Game.GetCoverReplicator();
    if (CoverReplicator != none)
    {
        CoverReplicator.NotifyLinkDisabledStateChange(self);
    }
}

native final function GetSlotActions(int SlotIdx, out array<ECoverAction> Actions)
{
    SlotIdx;
    Actions;
}

native function bool HasFireLinkTo(int SlotIdx, CoverInfo ChkCover, optional bool bAllowFallbackLinks)
{
    SlotIdx;
    ChkCover;
    bAllowFallbackLinks;
}

native function bool GetFireLinkTo(int SlotIdx, CoverInfo ChkCover, ECoverAction ChkAction, ECoverType ChkType, out int out_FireLinkIdx, out array<int> out_Items)
{
    SlotIdx;
    ChkCover;
    ChkAction;
    ChkType;
    out_FireLinkIdx;
    out_Items;
}

final simulated function bool AllowLeftTransition(int SlotIdx)
{
    local int NextSlotIdx;
    
    NextSlotIdx = GetSlotIdxToLeft(SlotIdx);
    if (NextSlotIdx >= 0)
    {
        return Slots[NextSlotIdx].bEnabled;
    }
    return false;
}

final simulated function bool AllowRightTransition(int SlotIdx)
{
    local int NextSlotIdx;
    
    NextSlotIdx = GetSlotIdxToRight(SlotIdx);
    if (NextSlotIdx >= 0)
    {
        return Slots[NextSlotIdx].bEnabled;
    }
    return false;
}

native final simulated function int GetSlotIdxToRight(int SlotIdx, optional int Cnt = 1)
{
    SlotIdx;
    Cnt;
}

native final simulated function int GetSlotIdxToLeft(int SlotIdx, optional int Cnt = 1)
{
    SlotIdx;
    Cnt;
}

native final simulated function bool IsRightEdgeSlot(int SlotIdx, bool bIgnoreLeans)
{
    SlotIdx;
    bIgnoreLeans;
}

native final simulated function bool IsLeftEdgeSlot(int SlotIdx, bool bIgnoreLeans)
{
    SlotIdx;
    bIgnoreLeans;
}

native final simulated function bool IsEdgeSlot(int SlotIdx, optional bool bIgnoreLeans)
{
    SlotIdx;
    bIgnoreLeans;
}

native final simulated function bool FindSlots(Vector CheckLocation, float MaxDistance, out int LeftSlotIdx, out int RightSlotIdx)
{
    CheckLocation;
    MaxDistance;
    LeftSlotIdx;
    RightSlotIdx;
}

final simulated function bool IsStationarySlot(int SlotIdx)
{
    return !bCircular && IsEdgeSlot(SlotIdx, false);
}

native final function bool IsValidClaim(Pawn ChkClaim, int SlotIdx, optional bool bSkipTeamCheck, optional bool bSkipOverlapCheck)
{
    ChkClaim;
    SlotIdx;
    bSkipTeamCheck;
    bSkipOverlapCheck;
}

final simulated event bool UnClaim(Pawn OldClaim, int SlotIdx, bool bUnclaimAll)
{
    local int Idx, NumReleased;
    local bool bResult;
    local int NumClaims;
    local array<int> SlotList;
    local string Str;
    
    if (bDebug)
    {
        LogInternal(string(self) @ "UnClaim" @ string(OldClaim) @ string(SlotIdx) @ string(bUnclaimAll) @ string(bClaimAllSlots));
    }
    if (bUnclaimAll)
    {
        for (Idx = 0; Idx < Slots.Length; Idx++)
        {
            if (Slots[Idx].SlotOwner == OldClaim)
            {
                Slots[Idx].SlotOwner = none;
                NumReleased++;
                bResult = true;
            }
        }
    }
    else if (!bClaimAllSlots && Slots[SlotIdx].SlotOwner == OldClaim)
    {
        Slots[SlotIdx].SlotOwner = none;
        NumReleased++;
        bResult = true;
    }
    for (; NumReleased > 0; NumReleased--)
    {
        Idx = Claims.Find(OldClaim);
        if (Idx < 0)
        {
            break;
        }
        Claims.Remove(Idx, 1);
    }
    if (bDebug)
    {
        for (Idx = 0; Idx < Claims.Length; Idx++)
        {
            if (Claims[Idx] == OldClaim)
            {
                NumClaims++;
            }
        }
        for (Idx = 0; Idx < Slots.Length; Idx++)
        {
            if (Slots[Idx].SlotOwner == OldClaim)
            {
                SlotList[SlotList.Length] = Idx;
            }
        }
        if (SlotList.Length == 0)
        {
            Str = "None";
        }
        else
        {
            for (Idx = 0; Idx < SlotList.Length; Idx++)
            {
                Str = Str @ string(SlotList[Idx]);
            }
        }
        LogInternal(string(self) @ "Claims from" @ string(OldClaim) @ string(NumClaims) @ "Slots:" @ Str);
        ScriptTrace();
    }
    return bResult;
}

final simulated event bool Claim(Pawn NewClaim, int SlotIdx)
{
    local int Idx;
    local bool bResult, bDoClaim;
    local PlayerController PC;
    local Pawn PreviousOwner;
    local int NumClaims;
    local array<int> SlotList;
    local string Str;
    
    if (bDebug)
    {
        LogInternal(string(self) @ "Claim Slot" @ string(SlotIdx) @ "For" @ string(NewClaim) @ "(All?)" @ string(bClaimAllSlots));
    }
    if (SlotIdx < 0)
    {
        return false;
    }
    bDoClaim = true;
    if (Slots[SlotIdx].SlotOwner != none)
    {
        bResult = Slots[SlotIdx].SlotOwner == NewClaim;
        bDoClaim = false;
        if (!bResult)
        {
            PC = PlayerController(NewClaim.Controller);
            if (PC != none)
            {
                PreviousOwner = Slots[SlotIdx].SlotOwner;
                bDoClaim = true;
            }
        }
    }
    if (bDoClaim)
    {
        if (bClaimAllSlots)
        {
            for (Idx = 0; Idx < Slots.Length; Idx++)
            {
                if (Slots[Idx].SlotOwner == none)
                {
                    Claims[Claims.Length] = NewClaim;
                    Slots[Idx].SlotOwner = NewClaim;
                    bResult = true;
                }
            }
        }
        else
        {
            Claims[Claims.Length] = NewClaim;
            Slots[SlotIdx].SlotOwner = NewClaim;
            bResult = true;
        }
        if (PreviousOwner != none && PreviousOwner.Controller != none)
        {
            PreviousOwner.Controller.NotifyCoverClaimViolation(NewClaim.Controller, self, SlotIdx);
        }
    }
    if (bDebug)
    {
        for (Idx = 0; Idx < Claims.Length; Idx++)
        {
            if (Claims[Idx] == NewClaim)
            {
                NumClaims++;
            }
        }
        for (Idx = 0; Idx < Slots.Length; Idx++)
        {
            if (Slots[Idx].SlotOwner == NewClaim)
            {
                SlotList[SlotList.Length] = Idx;
            }
        }
        if (SlotList.Length == 0)
        {
            Str = "None";
        }
        else
        {
            for (Idx = 0; Idx < SlotList.Length; Idx++)
            {
                Str = Str @ string(SlotList[Idx]);
            }
        }
        LogInternal(string(self) @ "Claims from" @ string(NewClaim) @ string(NumClaims) @ "Slots:" @ Str);
        ScriptTrace();
    }
    return bResult;
}

final simulated event SetInvalidUntil(int SlotIdx, float TimeToBecomeValid)
{
    Slots[SlotIdx].SlotValidAfterTime = TimeToBecomeValid;
    NotifySlotOwnerCoverDisabled(SlotIdx);
}

native final simulated function bool IsExposedTo(int SlotIdx, CoverInfo ChkSlot, out float out_ExposedScale)
{
    SlotIdx;
    ChkSlot;
    out_ExposedScale;
}

native final simulated function CoverSlotMarker GetSlotMarker(int SlotIdx)
{
    SlotIdx;
}

native final simulated function Vector GetSlotViewPoint(int SlotIdx, optional ECoverType Type, optional ECoverAction Action)
{
    SlotIdx;
    Type;
    Action;
}

native final simulated function Rotator GetSlotRotation(int SlotIdx, optional bool bForceUseOffset)
{
    SlotIdx;
    bForceUseOffset;
}

native final simulated function Vector GetSlotLocation(int SlotIdx, optional bool bForceUseOffset)
{
    SlotIdx;
    bForceUseOffset;
}

defaultproperties
{
    bAutoSort=True
    bAutoAdjust=True
    Slots=// [raw] 0000000000000000d914000000000000d9140000000000000000804200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000010101010101010100010000000000000000008042000000006e1400000000000000
    InvalidateDistance=64.0
    MaxFireLinkDist=2048.0
    AlignDist=36.0
    AutoCoverSlotInterval=256.0
    StandHeight=160.0
    MidHeight=70.0
    StandingLeanOffset=(X=0.0,Y=78.0,Z=69.0)
    CrouchLeanOffset=(X=0.0,Y=70.0,Z=19.0)
    PopupOffset=(X=0.0,Y=0.0,Z=70.0)
    SlipDist=60.0
    TurnDist=512.0
    DangerScale=2.0
    bSpecialMove=True
    bDestinationOnly=True
    bBuildLongPaths=False
    CylinderComponent="Default__CoverLink.CollisionCylinder"
    GoodSprite="Default__CoverLink.Sprite"
    BadSprite="Default__CoverLink.Sprite2"
    Components(0)="Default__CoverLink.Sprite"
    Components(1)="Default__CoverLink.Sprite2"
    Components(2)="Default__CoverLink.Arrow"
    Components(3)="Default__CoverLink.CollisionCylinder"
    Components(4)="Default__CoverLink.CoverMesh"
    CollisionType="COLLIDE_CustomDefault"
    CollisionComponent="Default__CoverLink.CollisionCylinder"
}

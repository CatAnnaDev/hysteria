class CoverReplicator extends ReplicationInfo
    notplaceable
    hidecategories(Navigation,Movement,Collision);

struct CoverReplicationInfo
{
    var CoverLink Link;
    var array<byte> SlotsEnabled;
    var array<byte> SlotsDisabled;
    var array<byte> SlotsAdjusted;
    var array<ManualCoverTypeInfo> SlotsCoverTypeChanged;
};

struct ManualCoverTypeInfo
{
    var byte SlotIndex;
    var ECoverType ManualCoverType;
};

var array<CoverReplicationInfo> CoverReplicationData;

reliable client simulated function ClientReceiveLinkDisabledState(int Index, CoverLink Link, bool bLinkDisabled)
{
    if (Link == none)
    {
        ServerSendLinkDisabledState(Index);
    }
    else
    {
        Link.bDisabled = bLinkDisabled;
    }
}

reliable server function ServerSendLinkDisabledState(int Index)
{
    if (CoverReplicationData[Index].Link != none)
    {
        ClientReceiveLinkDisabledState(Index, CoverReplicationData[Index].Link, CoverReplicationData[Index].Link.bDisabled);
    }
}

function NotifyLinkDisabledStateChange(CoverLink Link)
{
    local int Index;
    local PlayerController PC;
    
    Index = CoverReplicationData.Find('Link', Link);
    if (Index == -1)
    {
        Index = CoverReplicationData.Length;
        CoverReplicationData.Length = CoverReplicationData.Length + 1;
        CoverReplicationData[Index].Link = Link;
    }
    if (WorldInfo.Game.GetCoverReplicator() == self)
    {
        foreach WorldInfo.AllControllers(class'PlayerController', PC)
        {
            if (PC.MyCoverReplicator == none)
            {
                PC.SpawnCoverReplicator();
                continue;
            }
            PC.MyCoverReplicator.NotifyLinkDisabledStateChange(Link);
        }
    }
    if (PlayerController(Owner) != none)
    {
        ServerSendLinkDisabledState(Index);
    }
}

reliable client simulated function ClientReceiveManualCoverTypeSlots(int Index, CoverLink Link, byte NumCoverTypesChanged, ManualCoverTypeInfo SlotsCoverTypeChanged[8], bool bDone)
{
    local int I;
    
    if (Link == none)
    {
        if (bDone)
        {
            ServerSendManualCoverTypeSlots(Index);
        }
    }
    else
    {
        for (I = 0; I < int(NumCoverTypesChanged); I++)
        {
            Link.Slots[int(SlotsCoverTypeChanged[I].SlotIndex)].CoverType = SlotsCoverTypeChanged[I].ManualCoverType;
            if (Link.Slots[int(SlotsCoverTypeChanged[I].SlotIndex)].SlotOwner != none && Link.Slots[int(SlotsCoverTypeChanged[I].SlotIndex)].SlotOwner.Controller != none)
            {
                Link.Slots[int(SlotsCoverTypeChanged[I].SlotIndex)].SlotOwner.Controller.NotifyCoverAdjusted();
            }
        }
    }
}

reliable server function ServerSendManualCoverTypeSlots(int Index)
{
    local int SlotsArrayIndex;
    local byte NumCoverTypesChanged;
    local ManualCoverTypeInfo SlotsCoverTypeChanged[8];
    local int I;
    local bool bDone;
    
    if (CoverReplicationData[Index].Link != none)
    {
        SlotsArrayIndex = 0;
        do
        {
            NumCoverTypesChanged = byte(Clamp(CoverReplicationData[Index].SlotsCoverTypeChanged.Length - SlotsArrayIndex, 0, 8));
            for (I = 0; I < int(NumCoverTypesChanged); I++)
            {
                SlotsCoverTypeChanged[I] = CoverReplicationData[Index].SlotsCoverTypeChanged[SlotsArrayIndex + I];
            }
            bDone = CoverReplicationData[Index].SlotsCoverTypeChanged.Length - SlotsArrayIndex <= 8;
            ClientReceiveManualCoverTypeSlots(Index, CoverReplicationData[Index].Link, NumCoverTypesChanged, SlotsCoverTypeChanged, bDone);
            SlotsArrayIndex += 8;
        } until (bDone);
    }
}

function NotifySetManualCoverTypeForSlots(CoverLink Link, out const array<int> SlotIndices, ECoverType NewCoverType)
{
    local int Index, SlotIndex, I;
    local PlayerController PC;
    
    Index = CoverReplicationData.Find('Link', Link);
    if (Index == -1)
    {
        Index = CoverReplicationData.Length;
        CoverReplicationData.Length = CoverReplicationData.Length + 1;
        CoverReplicationData[Index].Link = Link;
        CoverReplicationData[Index].SlotsCoverTypeChanged.Length = SlotIndices.Length;
        for (I = 0; I < SlotIndices.Length; I++)
        {
            CoverReplicationData[Index].SlotsCoverTypeChanged[I].SlotIndex = byte(SlotIndices[I]);
            CoverReplicationData[Index].SlotsCoverTypeChanged[I].ManualCoverType = NewCoverType;
        }
    }
    else
    {
        for (I = 0; I < SlotIndices.Length; I++)
        {
            SlotIndex = CoverReplicationData[Index].SlotsCoverTypeChanged.Find('SlotIndex', byte(SlotIndices[I]));
            if (SlotIndex == -1)
            {
                SlotIndex = CoverReplicationData[Index].SlotsCoverTypeChanged.Length;
                CoverReplicationData[Index].SlotsCoverTypeChanged.Length = CoverReplicationData[Index].SlotsCoverTypeChanged.Length + 1;
                CoverReplicationData[Index].SlotsCoverTypeChanged[SlotIndex].SlotIndex = byte(SlotIndices[I]);
            }
            CoverReplicationData[Index].SlotsCoverTypeChanged[SlotIndex].ManualCoverType = NewCoverType;
            SlotIndex = CoverReplicationData[Index].SlotsAdjusted.Find(byte(SlotIndices[I]));
            if (SlotIndex != -1)
            {
                CoverReplicationData[Index].SlotsAdjusted.Remove(SlotIndex, 1);
            }
        }
    }
    if (WorldInfo.Game.GetCoverReplicator() == self)
    {
        foreach WorldInfo.AllControllers(class'PlayerController', PC)
        {
            if (PC.MyCoverReplicator == none)
            {
                PC.SpawnCoverReplicator();
                continue;
            }
            PC.MyCoverReplicator.NotifySetManualCoverTypeForSlots(Link, SlotIndices, NewCoverType);
        }
    }
    if (PlayerController(Owner) != none)
    {
        ServerSendManualCoverTypeSlots(Index);
    }
}

reliable client simulated function ClientReceiveAdjustedSlots(int Index, CoverLink Link, byte NumSlotsAdjusted, byte SlotsAdjusted[8], bool bDone)
{
    local int I;
    
    if (Link == none)
    {
        if (bDone)
        {
            ServerSendAdjustedSlots(Index);
        }
    }
    else
    {
        for (I = 0; I < int(NumSlotsAdjusted); I++)
        {
            if (Link.AutoAdjustSlot(int(SlotsAdjusted[I]), true) && Link.Slots[int(SlotsAdjusted[I])].SlotOwner != none && Link.Slots[int(SlotsAdjusted[I])].SlotOwner.Controller != none)
            {
                Link.Slots[int(SlotsAdjusted[I])].SlotOwner.Controller.NotifyCoverAdjusted();
            }
        }
    }
}

reliable server function ServerSendAdjustedSlots(int Index)
{
    local int SlotsArrayIndex;
    local byte NumSlotsAdjusted, SlotsAdjusted[8];
    local int I;
    local bool bDone;
    
    if (CoverReplicationData[Index].Link != none)
    {
        SlotsArrayIndex = 0;
        do
        {
            NumSlotsAdjusted = byte(Clamp(CoverReplicationData[Index].SlotsAdjusted.Length - SlotsArrayIndex, 0, 8));
            for (I = 0; I < int(NumSlotsAdjusted); I++)
            {
                SlotsAdjusted[I] = CoverReplicationData[Index].SlotsAdjusted[SlotsArrayIndex + I];
            }
            bDone = CoverReplicationData[Index].SlotsAdjusted.Length - SlotsArrayIndex <= 8;
            ClientReceiveAdjustedSlots(Index, CoverReplicationData[Index].Link, NumSlotsAdjusted, SlotsAdjusted, bDone);
            SlotsArrayIndex += 8;
        } until (bDone);
    }
}

function NotifyAutoAdjustSlots(CoverLink Link, out const array<int> SlotIndices)
{
    local int Index, SlotIndex, I;
    local PlayerController PC;
    
    Index = CoverReplicationData.Find('Link', Link);
    if (Index == -1)
    {
        Index = CoverReplicationData.Length;
        CoverReplicationData.Length = CoverReplicationData.Length + 1;
        CoverReplicationData[Index].Link = Link;
        for (I = 0; I < SlotIndices.Length; I++)
        {
            CoverReplicationData[Index].SlotsAdjusted[I] = byte(SlotIndices[I]);
        }
    }
    else
    {
        for (I = 0; I < SlotIndices.Length; I++)
        {
            SlotIndex = CoverReplicationData[Index].SlotsAdjusted.Find(byte(SlotIndices[I]));
            if (SlotIndex == -1)
            {
                CoverReplicationData[Index].SlotsAdjusted[CoverReplicationData[Index].SlotsAdjusted.Length] = byte(SlotIndices[I]);
            }
            SlotIndex = CoverReplicationData[Index].SlotsCoverTypeChanged.Find('SlotIndex', byte(SlotIndices[I]));
            if (SlotIndex != -1)
            {
                CoverReplicationData[Index].SlotsCoverTypeChanged.Remove(SlotIndex, 1);
            }
        }
    }
    if (WorldInfo.Game.GetCoverReplicator() == self)
    {
        foreach WorldInfo.AllControllers(class'PlayerController', PC)
        {
            if (PC.MyCoverReplicator == none)
            {
                PC.SpawnCoverReplicator();
                continue;
            }
            PC.MyCoverReplicator.NotifyAutoAdjustSlots(Link, SlotIndices);
        }
    }
    if (PlayerController(Owner) != none)
    {
        ServerSendAdjustedSlots(Index);
    }
}

reliable client simulated function ClientReceiveDisabledSlots(int Index, CoverLink Link, byte NumSlotsDisabled, byte SlotsDisabled[8], bool bDone)
{
    local int I;
    
    if (Link == none)
    {
        if (bDone)
        {
            ServerSendDisabledSlots(Index);
        }
    }
    else
    {
        for (I = 0; I < int(NumSlotsDisabled); I++)
        {
            Link.SetSlotEnabled(int(SlotsDisabled[I]), false);
        }
    }
}

reliable server function ServerSendDisabledSlots(int Index)
{
    local int SlotsArrayIndex;
    local byte NumSlotsDisabled, SlotsDisabled[8];
    local int I;
    local bool bDone;
    
    if (CoverReplicationData[Index].Link != none)
    {
        SlotsArrayIndex = 0;
        do
        {
            NumSlotsDisabled = byte(Clamp(CoverReplicationData[Index].SlotsDisabled.Length - SlotsArrayIndex, 0, 8));
            for (I = 0; I < int(NumSlotsDisabled); I++)
            {
                SlotsDisabled[I] = CoverReplicationData[Index].SlotsDisabled[SlotsArrayIndex + I];
            }
            bDone = CoverReplicationData[Index].SlotsDisabled.Length - SlotsArrayIndex <= 8;
            ClientReceiveDisabledSlots(Index, CoverReplicationData[Index].Link, NumSlotsDisabled, SlotsDisabled, bDone);
            SlotsArrayIndex += 8;
        } until (bDone);
    }
}

function NotifyDisabledSlots(CoverLink Link, out const array<int> SlotIndices)
{
    local int Index, SlotIndex, I;
    local PlayerController PC;
    
    Index = CoverReplicationData.Find('Link', Link);
    if (Index == -1)
    {
        Index = CoverReplicationData.Length;
        CoverReplicationData.Length = CoverReplicationData.Length + 1;
        CoverReplicationData[Index].Link = Link;
        for (I = 0; I < SlotIndices.Length; I++)
        {
            CoverReplicationData[Index].SlotsDisabled[I] = byte(SlotIndices[I]);
        }
    }
    else
    {
        for (I = 0; I < SlotIndices.Length; I++)
        {
            SlotIndex = CoverReplicationData[Index].SlotsDisabled.Find(byte(SlotIndices[I]));
            if (SlotIndex == -1)
            {
                CoverReplicationData[Index].SlotsDisabled[CoverReplicationData[Index].SlotsDisabled.Length] = byte(SlotIndices[I]);
            }
            SlotIndex = CoverReplicationData[Index].SlotsEnabled.Find(byte(SlotIndices[I]));
            if (SlotIndex != -1)
            {
                CoverReplicationData[Index].SlotsEnabled.Remove(SlotIndex, 1);
            }
        }
    }
    if (WorldInfo.Game.GetCoverReplicator() == self)
    {
        foreach WorldInfo.AllControllers(class'PlayerController', PC)
        {
            if (PC.MyCoverReplicator == none)
            {
                PC.SpawnCoverReplicator();
                continue;
            }
            PC.MyCoverReplicator.NotifyDisabledSlots(Link, SlotIndices);
        }
    }
    if (PlayerController(Owner) != none)
    {
        ServerSendDisabledSlots(Index);
    }
}

reliable client simulated function ClientReceiveEnabledSlots(int Index, CoverLink Link, byte NumSlotsEnabled, byte SlotsEnabled[8], bool bDone)
{
    local int I;
    
    if (Link == none)
    {
        if (bDone)
        {
            ServerSendEnabledSlots(Index);
        }
    }
    else
    {
        for (I = 0; I < int(NumSlotsEnabled); I++)
        {
            Link.SetSlotEnabled(int(SlotsEnabled[I]), true);
        }
    }
}

reliable server function ServerSendEnabledSlots(int Index)
{
    local int SlotsArrayIndex;
    local byte NumSlotsEnabled, SlotsEnabled[8];
    local int I;
    local bool bDone;
    
    if (CoverReplicationData[Index].Link != none)
    {
        SlotsArrayIndex = 0;
        do
        {
            NumSlotsEnabled = byte(Clamp(CoverReplicationData[Index].SlotsEnabled.Length - SlotsArrayIndex, 0, 8));
            for (I = 0; I < int(NumSlotsEnabled); I++)
            {
                SlotsEnabled[I] = CoverReplicationData[Index].SlotsEnabled[SlotsArrayIndex + I];
            }
            bDone = CoverReplicationData[Index].SlotsEnabled.Length - SlotsArrayIndex <= 8;
            ClientReceiveEnabledSlots(Index, CoverReplicationData[Index].Link, NumSlotsEnabled, SlotsEnabled, bDone);
            SlotsArrayIndex += 8;
        } until (bDone);
    }
}

function NotifyEnabledSlots(CoverLink Link, out const array<int> SlotIndices)
{
    local int Index, SlotIndex, I;
    local PlayerController PC;
    
    Index = CoverReplicationData.Find('Link', Link);
    if (Index == -1)
    {
        Index = CoverReplicationData.Length;
        CoverReplicationData.Length = CoverReplicationData.Length + 1;
        CoverReplicationData[Index].Link = Link;
        for (I = 0; I < SlotIndices.Length; I++)
        {
            CoverReplicationData[Index].SlotsEnabled[I] = byte(SlotIndices[I]);
        }
    }
    else
    {
        for (I = 0; I < SlotIndices.Length; I++)
        {
            SlotIndex = CoverReplicationData[Index].SlotsEnabled.Find(byte(SlotIndices[I]));
            if (SlotIndex == -1)
            {
                CoverReplicationData[Index].SlotsEnabled[CoverReplicationData[Index].SlotsEnabled.Length] = byte(SlotIndices[I]);
            }
            SlotIndex = CoverReplicationData[Index].SlotsDisabled.Find(byte(SlotIndices[I]));
            if (SlotIndex != -1)
            {
                CoverReplicationData[Index].SlotsDisabled.Remove(SlotIndex, 1);
            }
        }
    }
    if (WorldInfo.Game.GetCoverReplicator() == self)
    {
        foreach WorldInfo.AllControllers(class'PlayerController', PC)
        {
            if (PC.MyCoverReplicator == none)
            {
                PC.SpawnCoverReplicator();
                continue;
            }
            PC.MyCoverReplicator.NotifyEnabledSlots(Link, SlotIndices);
        }
    }
    if (PlayerController(Owner) != none)
    {
        ServerSendEnabledSlots(Index);
    }
}

reliable client simulated function ClientReceiveInitialCoverReplicationInfo(int Index, CoverLink Link, bool bLinkDisabled, byte NumSlotsEnabled, byte SlotsEnabled[8], byte NumSlotsDisabled, byte SlotsDisabled[8], byte NumSlotsAdjusted, byte SlotsAdjusted[8], byte NumCoverTypesChanged, ManualCoverTypeInfo SlotsCoverTypeChanged[8], bool bDone)
{
    local int I;
    
    if (Link == none)
    {
        if (bDone)
        {
            ServerSendInitialCoverReplicationInfo(Index);
        }
    }
    else
    {
        Link.bDisabled = bLinkDisabled;
        for (I = 0; I < int(NumSlotsEnabled); I++)
        {
            Link.SetSlotEnabled(int(SlotsEnabled[I]), true);
        }
        for (I = 0; I < int(NumSlotsDisabled); I++)
        {
            Link.SetSlotEnabled(int(SlotsDisabled[I]), false);
        }
        for (I = 0; I < int(NumSlotsAdjusted); I++)
        {
            if (Link.AutoAdjustSlot(int(SlotsAdjusted[I]), false) && Link.Slots[int(SlotsAdjusted[I])].SlotOwner != none && Link.Slots[int(SlotsAdjusted[I])].SlotOwner.Controller != none)
            {
                Link.Slots[int(SlotsAdjusted[I])].SlotOwner.Controller.NotifyCoverAdjusted();
            }
        }
        for (I = 0; I < int(NumCoverTypesChanged); I++)
        {
            Link.Slots[int(SlotsCoverTypeChanged[I].SlotIndex)].CoverType = SlotsCoverTypeChanged[I].ManualCoverType;
            if (Link.Slots[int(SlotsCoverTypeChanged[I].SlotIndex)].SlotOwner != none && Link.Slots[int(SlotsCoverTypeChanged[I].SlotIndex)].SlotOwner.Controller != none)
            {
                Link.Slots[int(SlotsCoverTypeChanged[I].SlotIndex)].SlotOwner.Controller.NotifyCoverAdjusted();
            }
        }
        if (bDone)
        {
            ServerSendInitialCoverReplicationInfo(Index + 1);
        }
    }
}

reliable server function ServerSendInitialCoverReplicationInfo(int Index)
{
    local byte SlotsArrayIndex, NumSlotsEnabled, NumSlotsDisabled, NumSlotsAdjusted, NumCoverTypesChanged, SlotsEnabled[8], SlotsDisabled[8], SlotsAdjusted[8];
    local ManualCoverTypeInfo SlotsCoverTypeChanged[8];
    local int I;
    local bool bDone;
    
    while (Index < CoverReplicationData.Length && CoverReplicationData[Index].Link == none)
    {
        CoverReplicationData.Remove(Index, 1);
    }
    if (Index < CoverReplicationData.Length)
    {
        SlotsArrayIndex = 0;
        do
        {
            NumSlotsEnabled = byte(Clamp(CoverReplicationData[Index].SlotsEnabled.Length - int(SlotsArrayIndex), 0, 8));
            NumSlotsDisabled = byte(Clamp(CoverReplicationData[Index].SlotsDisabled.Length - int(SlotsArrayIndex), 0, 8));
            NumSlotsAdjusted = byte(Clamp(CoverReplicationData[Index].SlotsAdjusted.Length - int(SlotsArrayIndex), 0, 8));
            NumCoverTypesChanged = byte(Clamp(CoverReplicationData[Index].SlotsCoverTypeChanged.Length - int(SlotsArrayIndex), 0, 8));
            if (NumSlotsEnabled == 0)
            {
                for (I = 0; I < 8; I++)
                {
                    SlotsEnabled[I] = 0;
                }
            }
            else
            {
                for (I = 0; I < int(NumSlotsEnabled); I++)
                {
                    SlotsEnabled[I] = CoverReplicationData[Index].SlotsEnabled[int(SlotsArrayIndex) + I];
                }
            }
            if (NumSlotsDisabled == 0)
            {
                for (I = 0; I < 8; I++)
                {
                    SlotsDisabled[I] = 0;
                }
            }
            else
            {
                for (I = 0; I < int(NumSlotsDisabled); I++)
                {
                    SlotsDisabled[I] = CoverReplicationData[Index].SlotsDisabled[int(SlotsArrayIndex) + I];
                }
            }
            if (NumSlotsAdjusted == 0)
            {
                for (I = 0; I < 8; I++)
                {
                    SlotsAdjusted[I] = 0;
                }
            }
            else
            {
                for (I = 0; I < int(NumSlotsAdjusted); I++)
                {
                    SlotsAdjusted[I] = CoverReplicationData[Index].SlotsAdjusted[int(SlotsArrayIndex) + I];
                }
            }
            if (NumCoverTypesChanged == 0)
            {
                for (I = 0; I < 8; I++)
                {
                    SlotsCoverTypeChanged[I].SlotIndex = 0;
                    SlotsCoverTypeChanged[I].ManualCoverType = 0;
                }
            }
            else
            {
                for (I = 0; I < int(NumCoverTypesChanged); I++)
                {
                    SlotsCoverTypeChanged[I] = CoverReplicationData[Index].SlotsCoverTypeChanged[int(SlotsArrayIndex) + I];
                }
            }
            bDone = CoverReplicationData[Index].SlotsEnabled.Length - int(SlotsArrayIndex) <= 8 && CoverReplicationData[Index].SlotsDisabled.Length - int(SlotsArrayIndex) <= 8 && CoverReplicationData[Index].SlotsAdjusted.Length - int(SlotsArrayIndex) <= 8 && CoverReplicationData[Index].SlotsCoverTypeChanged.Length - int(SlotsArrayIndex) <= 8;
            ClientReceiveInitialCoverReplicationInfo(Index, CoverReplicationData[Index].Link, CoverReplicationData[Index].Link.bDisabled, NumSlotsEnabled, SlotsEnabled, NumSlotsDisabled, SlotsDisabled, NumSlotsAdjusted, SlotsAdjusted, NumCoverTypesChanged, SlotsCoverTypeChanged, bDone);
            SlotsArrayIndex += 8;
        } until (bDone);
    }
}

reliable client simulated function ClientSetOwner(PlayerController PC)
{
    SetOwner(PC);
}

function ReplicateInitialCoverInfo()
{
    local CoverReplicator CoverReplicatorBase;
    
    CoverReplicatorBase = WorldInfo.Game.GetCoverReplicator();
    CoverReplicatorBase.PurgeOldEntries();
    CoverReplicationData = CoverReplicatorBase.CoverReplicationData;
    if (PlayerController(Owner) != none)
    {
        ClientSetOwner(PlayerController(Owner));
        ServerSendInitialCoverReplicationInfo(0);
    }
}

function PurgeOldEntries()
{
    local int I;
    
    for (I = 0; I < CoverReplicationData.Length; I++)
    {
        if (CoverReplicationData[I].Link == none)
        {
            CoverReplicationData.Remove(I--, 1);
        }
    }
}

defaultproperties
{
    bOnlyRelevantToOwner=True
    bAlwaysRelevant=False
    NetUpdateFrequency=0.1
}

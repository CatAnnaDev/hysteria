class OnlinePartyChatInterface extends Interface
    abstract
    notplaceable;

var delegate<OnSendPartyGameInvitesComplete> __OnSendPartyGameInvitesComplete__Delegate;
var delegate<OnPartyMemberListChanged> __OnPartyMemberListChanged__Delegate;
var delegate<OnPartyMembersInfoChanged> __OnPartyMembersInfoChanged__Delegate;

function bool ShowCommunitySessionsUI(byte LocalUserNum)
{
}

function bool ShowVoiceChannelUI(byte LocalUserNum)
{
}

function bool ShowPartyUI(byte LocalUserNum)
{
}

function int GetPartyBandwidth()
{
}

function bool SetPartyMemberCustomData(byte LocalUserNum, int Data1, int Data2, int Data3, int Data4)
{
}

function ClearPartyMembersInfoChangedDelegate(byte LocalUserNum, delegate<OnPartyMembersInfoChanged> PartyMembersInfoChangedDelegate)
{
}

function AddPartyMembersInfoChangedDelegate(byte LocalUserNum, delegate<OnPartyMembersInfoChanged> PartyMembersInfoChangedDelegate)
{
}

delegate OnPartyMembersInfoChanged(string PlayerName, UniqueNetId PlayerID, int CustomData1, int CustomData2, int CustomData3, int CustomData4)
{
}

function ClearPartyMemberListChangedDelegate(byte LocalUserNum, delegate<OnPartyMemberListChanged> PartyMemberListChangedDelegate)
{
}

function AddPartyMemberListChangedDelegate(byte LocalUserNum, delegate<OnPartyMemberListChanged> PartyMemberListChangedDelegate)
{
}

delegate OnPartyMemberListChanged(bool bJoinedOrLeft, string PlayerName, UniqueNetId PlayerID)
{
}

function bool GetPartyMemberInformation(UniqueNetId MemberId, out OnlinePartyMember PartyMember)
{
}

function bool GetPartyMembersInformation(out array<OnlinePartyMember> PartyMembers)
{
}

function ClearSendPartyGameInvitesCompleteDelegate(byte LocalUserNum, delegate<OnSendPartyGameInvitesComplete> SendPartyGameInvitesCompleteDelegate)
{
}

function AddSendPartyGameInvitesCompleteDelegate(byte LocalUserNum, delegate<OnSendPartyGameInvitesComplete> SendPartyGameInvitesCompleteDelegate)
{
}

delegate OnSendPartyGameInvitesComplete(bool bWasSuccessful)
{
}

function bool SendPartyGameInvites(byte LocalUserNum)
{
}

defaultproperties
{
}

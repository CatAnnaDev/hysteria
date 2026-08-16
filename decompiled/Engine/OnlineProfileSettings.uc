class OnlineProfileSettings extends OnlinePlayerStorage
    native
    notplaceable;

enum EProfileVoiceThruSpeakersOptions
{
    PVTSO_Off,
    PVTSO_On,
    PVTSO_Both,
};

enum EProfileControllerVibrationToggleOptions
{
    PCVTO_Off,
    PCVTO_IgnoreThis,
    PCVTO_IgnoreThis2,
    PCVTO_On,
};

enum EProfileXInversionOptions
{
    PXIO_Off,
    PXIO_On,
};

enum EProfileYInversionOptions
{
    PYIO_Off,
    PYIO_On,
};

enum EProfileRaceAcceleratorControlOptions
{
    PRACO_Trigger,
    PRACO_Button,
};

enum EProfileRaceBrakeControlOptions
{
    PRBCO_Trigger,
    PRBCO_Button,
};

enum EProfileRaceCameraLocationOptions
{
    PRCLO_Behind,
    PRCLO_Front,
    PRCLO_Inside,
};

enum EProfileRaceTransmissionOptions
{
    PRTO_Auto,
    PRTO_Manual,
};

enum EProfileMovementControlOptions
{
    PMCO_L_Thumbstick,
    PMCO_R_Thumbstick,
};

enum EProfileAutoCenterOptions
{
    PACO_Off,
    PACO_On,
};

enum EProfileAutoAimOptions
{
    PAAO_Off,
    PAAO_On,
};

enum EProfilePreferredColorOptions
{
    PPCO_None,
    PPCO_Black,
    PPCO_White,
    PPCO_Yellow,
    PPCO_Orange,
    PPCO_Pink,
    PPCO_Red,
    PPCO_Purple,
    PPCO_Blue,
    PPCO_Green,
    PPCO_Brown,
    PPCO_Silver,
};

enum EProfileControllerSensitivityOptions
{
    PCSO_Medium,
    PCSO_Low,
    PCSO_High,
};

enum EProfileDifficultyOptions
{
    PDO_Normal,
    PDO_Easy,
    PDO_Hard,
};

enum EProfileSettingID
{
    PSI_Unknown,
    PSI_ControllerVibration,
    PSI_YInversion,
    PSI_GamerCred,
    PSI_GamerRep,
    PSI_VoiceMuted,
    PSI_VoiceThruSpeakers,
    PSI_VoiceVolume,
    PSI_GamerPictureKey,
    PSI_GamerMotto,
    PSI_GamerTitlesPlayed,
    PSI_GamerAchievementsEarned,
    PSI_GameDifficulty,
    PSI_ControllerSensitivity,
    PSI_PreferredColor1,
    PSI_PreferredColor2,
    PSI_AutoAim,
    PSI_AutoCenter,
    PSI_MovementControl,
    PSI_RaceTransmission,
    PSI_RaceCameraLocation,
    PSI_RaceBrakeControl,
    PSI_RaceAcceleratorControl,
    PSI_GameCredEarned,
    PSI_GameAchievementsEarned,
    PSI_EndLiveIds,
    PSI_ProfileVersionNum,
    PSI_ProfileSaveCount,
};

var array<int> ProfileSettingIds;
var array<OnlineProfileSetting> DefaultSettings;
var const array<IdToStringMapping> OwnerMappings;

event ModifyAvailableProfileSettings()
{
}

native function SetDefaultVersionNumber()
{
}

native function int GetVersionNumber()
{
}

native function AppendVersionToSettings()
{
}

native function AppendVersionToReadIds()
{
}

native event SetToDefaults()
{
}

native function bool GetProfileSettingDefaultFloat(int ProfileSettingId, out float DefaultFloat)
{
    ProfileSettingId;
    DefaultFloat;
}

native function bool GetProfileSettingDefaultInt(int ProfileSettingId, out int DefaultInt)
{
    ProfileSettingId;
    DefaultInt;
}

native function bool GetProfileSettingDefaultId(int ProfileSettingId, out int DefaultId, out int ListIndex)
{
    ProfileSettingId;
    DefaultId;
    ListIndex;
}

defaultproperties
{
    OwnerMappings(0)=(Id=0,Name="None")
    OwnerMappings(1)=(Id=1,Name="Online Service Setting")
    OwnerMappings(2)=(Id=2,Name="Game Setting")
    ProfileMappings(0)=(Id=1,Name="Controller Vibration",ColumnHeaderText="",MappingType="PVMT_IdMapped",ValueMappings=((Id=3,Name="Off"),(Id=0,Name="On")),PredefinedValues=(),MinVal=0.0,MaxVal=0.0,RangeIncrement=0.0)
    ProfileMappings(1)=(Id=2,Name="Invert Y",ColumnHeaderText="",MappingType="PVMT_IdMapped",ValueMappings=((Id=0,Name="Off"),(Id=1,Name="On")),PredefinedValues=(),MinVal=0.0,MaxVal=0.0,RangeIncrement=0.0)
    ProfileMappings(2)=(Id=5,Name="Mute Voice",ColumnHeaderText="",MappingType="PVMT_IdMapped",ValueMappings=((Id=0,Name="No"),(Id=1,Name="Yes")),PredefinedValues=(),MinVal=0.0,MaxVal=0.0,RangeIncrement=0.0)
    ProfileMappings(3)=(Id=6,Name="Voice Via Speakers",ColumnHeaderText="",MappingType="PVMT_IdMapped",ValueMappings=((Id=0,Name="Off"),(Id=1,Name="On"),(Id=2,Name="Both")),PredefinedValues=(),MinVal=0.0,MaxVal=0.0,RangeIncrement=0.0)
    ProfileMappings(4)=(Id=7,Name="Voice Volume",ColumnHeaderText="",MappingType="PVMT_RawValue",ValueMappings=(),PredefinedValues=(),MinVal=0.0,MaxVal=0.0,RangeIncrement=0.0)
    ProfileMappings(5)=(Id=12,Name="Difficulty Level",ColumnHeaderText="",MappingType="PVMT_IdMapped",ValueMappings=((Id=0,Name="Normal"),(Id=1,Name="Easy"),(Id=2,Name="Hard")),PredefinedValues=(),MinVal=0.0,MaxVal=0.0,RangeIncrement=0.0)
    ProfileMappings(6)=(Id=13,Name="Controller Sensitivity",ColumnHeaderText="",MappingType="PVMT_IdMapped",ValueMappings=((Id=0,Name="Medium"),(Id=1,Name="Low"),(Id=2,Name="High")),PredefinedValues=(),MinVal=0.0,MaxVal=0.0,RangeIncrement=0.0)
    ProfileMappings(7)=(Id=14,Name="First Preferred Color",ColumnHeaderText="",MappingType="PVMT_IdMapped",ValueMappings=((Id=0,Name="None"),(Id=1,Name="Black"),(Id=2,Name="White"),(Id=3,Name="Yellow"),(Id=4,Name="Orange"),(Id=5,Name="Pink"),(Id=6,Name="Red"),(Id=7,Name="Purple"),(Id=8,Name="Blue"),(Id=9,Name="Green"),(Id=10,Name="Brown"),(Id=11,Name="Silver")),PredefinedValues=(),MinVal=0.0,MaxVal=0.0,RangeIncrement=0.0)
    ProfileMappings(8)=(Id=15,Name="Second Preferred Color",ColumnHeaderText="",MappingType="PVMT_IdMapped",ValueMappings=((Id=0,Name="None"),(Id=1,Name="Black"),(Id=2,Name="White"),(Id=3,Name="Yellow"),(Id=4,Name="Orange"),(Id=5,Name="Pink"),(Id=6,Name="Red"),(Id=7,Name="Purple"),(Id=8,Name="Blue"),(Id=9,Name="Green"),(Id=10,Name="Brown"),(Id=11,Name="Silver")),PredefinedValues=(),MinVal=0.0,MaxVal=0.0,RangeIncrement=0.0)
    ProfileMappings(9)=(Id=16,Name="Auto Aim",ColumnHeaderText="",MappingType="PVMT_IdMapped",ValueMappings=((Id=0,Name="Off"),(Id=1,Name="On")),PredefinedValues=(),MinVal=0.0,MaxVal=0.0,RangeIncrement=0.0)
    ProfileMappings(10)=(Id=17,Name="Auto Center",ColumnHeaderText="",MappingType="PVMT_IdMapped",ValueMappings=((Id=0,Name="Off"),(Id=1,Name="On")),PredefinedValues=(),MinVal=0.0,MaxVal=0.0,RangeIncrement=0.0)
    ProfileMappings(11)=(Id=18,Name="Movement Control",ColumnHeaderText="",MappingType="PVMT_IdMapped",ValueMappings=((Id=0,Name="Left Thumbstick"),(Id=1,Name="Right Thumbstick")),PredefinedValues=(),MinVal=0.0,MaxVal=0.0,RangeIncrement=0.0)
    ProfileMappings(12)=(Id=19,Name="Transmission Preference",ColumnHeaderText="",MappingType="PVMT_IdMapped",ValueMappings=((Id=0,Name="Auto"),(Id=1,Name="Manual")),PredefinedValues=(),MinVal=0.0,MaxVal=0.0,RangeIncrement=0.0)
    ProfileMappings(13)=(Id=20,Name="Race Camera Preference",ColumnHeaderText="",MappingType="PVMT_IdMapped",ValueMappings=((Id=0,Name="Behind"),(Id=1,Name="Front"),(Id=2,Name="Inside")),PredefinedValues=(),MinVal=0.0,MaxVal=0.0,RangeIncrement=0.0)
    ProfileMappings(14)=(Id=21,Name="Brake Preference",ColumnHeaderText="",MappingType="PVMT_IdMapped",ValueMappings=((Id=0,Name="Trigger"),(Id=1,Name="Button")),PredefinedValues=(),MinVal=0.0,MaxVal=0.0,RangeIncrement=0.0)
    ProfileMappings(15)=(Id=22,Name="Accelerator Preference",ColumnHeaderText="",MappingType="PVMT_IdMapped",ValueMappings=((Id=0,Name="Trigger"),(Id=1,Name="Button")),PredefinedValues=(),MinVal=0.0,MaxVal=0.0,RangeIncrement=0.0)
}

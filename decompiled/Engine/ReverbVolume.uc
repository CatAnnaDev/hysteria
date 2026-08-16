class ReverbVolume extends Volume
    native
    placeable
    hidecategories(Navigation,Object,Movement,Display,Advanced,Attachment,Collision,Volume);

enum ReverbPreset
{
    REVERB_Default,
    REVERB_Bathroom,
    REVERB_StoneRoom,
    REVERB_Auditorium,
    REVERB_ConcertHall,
    REVERB_Cave,
    REVERB_Hallway,
    REVERB_StoneCorridor,
    REVERB_Alley,
    REVERB_Forest,
    REVERB_City,
    REVERB_Mountains,
    REVERB_Quarry,
    REVERB_Plain,
    REVERB_ParkingLot,
    REVERB_SewerPipe,
    REVERB_Underwater,
    REVERB_SmallRoom,
    REVERB_MediumRoom,
    REVERB_LargeRoom,
    REVERB_MediumHall,
    REVERB_LargeHall,
    REVERB_Plate,
};

struct native InteriorSettings
{
    var bool bIsWorldInfo;
    var() float ExteriorVolume;
    var() float ExteriorTime;
    var() float ExteriorLPF;
    var() float ExteriorLPFTime;
    var() float InteriorVolume;
    var() float InteriorTime;
    var() float InteriorLPF;
    var() float InteriorLPFTime;
};

struct native ReverbSettings
{
    var() bool bApplyReverb;
    var() ReverbPreset ReverbType;
    var() float Volume;
    var() float FadeTime;
};

var() float Priority;
var() ReverbSettings Settings;
var() InteriorSettings AmbientZoneSettings;
var const transient ReverbVolume NextLowerPriorityVolume;

defaultproperties
{
    Settings=(bApplyReverb=True,ReverbType="REVERB_Default",Volume=0.5,FadeTime=2.0)
    AmbientZoneSettings=(bIsWorldInfo=False,ExteriorVolume=1.0,ExteriorTime=0.5,ExteriorLPF=1.0,ExteriorLPFTime=0.5,InteriorVolume=1.0,InteriorTime=0.5,InteriorLPF=1.0,InteriorLPFTime=0.5)
    BrushColor=(B=0,G=255,R=255,A=255)
    bColored=True
    BrushComponent="Default__ReverbVolume.BrushComponent0"
    bCollideActors=False
    Components(0)="Default__ReverbVolume.BrushComponent0"
    CollisionComponent="Default__ReverbVolume.BrushComponent0"
    SupportedEvents(0)="SeqEvent_Touch"
}

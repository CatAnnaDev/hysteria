class CheckPointManager extends Actor
    native
    notplaceable
    config(Game)
    hidecategories(Navigation,Movement,Collision,Advanced,Attachment,Display,Object);

const MaxChapterCount = 70;

enum ChapterNameList
{
    Chapter_0,
    Chapter_1,
    Chapter_2,
    Chapter_3,
    Chapter_4,
    Chapter_5,
    Chapter_6,
    Chapter_7,
    Chapter_8,
    Chapter_9,
    Chapter_10,
    Chapter_11,
    Chapter_12,
    Chapter_13,
    Chapter_14,
    Chapter_15,
    Chapter_16,
    Chapter_17,
    Chapter_18,
    Chapter_19,
    Chapter_20,
    Chapter_21,
    Chapter_22,
    Chapter_23,
    Chapter_24,
    Chapter_25,
    Chapter_26,
    Chapter_27,
    Chapter_28,
    Chapter_29,
    Chapter_30,
    Chapter_31,
    Chapter_32,
    Chapter_33,
    Chapter_34,
    Chapter_35,
    Chapter_36,
    Chapter_37,
    Chapter_38,
    Chapter_39,
    Chapter_40,
    Chapter_41,
    Chapter_42,
    Chapter_43,
    Chapter_44,
    Chapter_45,
    Chapter_46,
    Chapter_47,
    Chapter_48,
    Chapter_49,
    Chapter_50,
    Chapter_51,
    Chapter_52,
    Chapter_53,
    Chapter_54,
    Chapter_55,
    Chapter_56,
    Chapter_57,
    Chapter_58,
    Chapter_59,
    Chapter_60,
    Chapter_61,
    Chapter_62,
    Chapter_63,
    Chapter_64,
    Chapter_65,
    Chapter_66,
    Chapter_67,
    Chapter_68,
    Chapter_69,
};

var config string AliceMapName[70];
var config string AliceChapterName[70];
var int AliceChapterLockState[70];
var ChapterNameList LastCheckPoint;
var Vector SafeSaveLocation;
var Rotator SafeSaveRotation;
var bool bHaveSafeSaveLocation;

function int getChapterUnlocked()
{
    local int I, iNum;
    
    iNum = 0;
    for (I = 0; I < 70; I++)
    {
        if (AliceChapterLockState[I] == 0)
        {
            iNum++;
        }
    }
    return iNum;
}

function bool IsChapterUnLocked(int chapterIndex)
{
    if (AliceChapterLockState[chapterIndex] == 0)
    {
        return true;
    }
    else
    {
        return false;
    }
}

function UnLockAllChapter()
{
    local int I;
    
    for (I = 0; I < 70; I++)
    {
        AliceChapterLockState[I] = 0;
    }
}

function UpdateRegisterWhenChangeCallFromBase(Actor RegisterActor, string OutName, string ActorFName)
{
}

function UnRegisterWhenApplyRecordCallFromBase(Actor RegisterActor, string OutName, string ActorFName)
{
}

function RegisterWhenApplyRecordCallFromBase(Actor RegisterActor, string OutName, string ActorFName)
{
}

function RegisterWhenPostBeginPlayCallFromBase(Actor RegisterActor)
{
}

native function LoadChapter(ChapterNameList beLoadedCharpter)
{
    beLoadedCharpter;
}

native function ChapterNameList GetLastLoadedChapter()
{
}

defaultproperties
{
    AliceMapName="Chapter1_L1_P"
    AliceMapName[1]="Chapter1_L1_P"
    AliceMapName[2]="Chapter1_W1_P"
    AliceMapName[3]="Chapter1_W1_P"
    AliceMapName[4]="Chapter1_W1_P"
    AliceMapName[5]="Chapter1_W1_P"
    AliceMapName[6]="Chapter1_W1_P"
    AliceMapName[7]="Chapter1_W1_P"
    AliceMapName[8]="Chapter1_W2_P"
    AliceMapName[9]="Chapter1_W2_P"
    AliceMapName[10]="Chapter1_W2_P"
    AliceMapName[11]="Chapter1_W2_P"
    AliceMapName[12]="Chapter1_W2_P"
    AliceMapName[13]="Chapter2_L1_P"
    AliceMapName[14]="AliceEntry"
    AliceMapName[15]="Chapter2_W1_P"
    AliceMapName[16]="Chapter2_W1_P"
    AliceMapName[17]="Chapter2_W1_P"
    AliceMapName[18]="Chapter2_W2_P"
    AliceMapName[19]="AliceEntry"
    AliceMapName[20]="Chapter2_W2_P"
    AliceMapName[21]="Chapter2_W2_P"
    AliceMapName[22]="Chapter2_W3_P"
    AliceMapName[23]="Chapter2_W3_P"
    AliceMapName[24]="AliceEntry"
    AliceMapName[25]="Chapter2_W3_P"
    AliceMapName[26]="Chapter2_W3_P"
    AliceMapName[27]="Chapter3_L1_P"
    AliceMapName[28]="Chapter3_L1_P"
    AliceMapName[29]="Chapter3_W1_P"
    AliceMapName[30]="Chapter3_W1_P"
    AliceMapName[31]="Chapter3_W1_P"
    AliceMapName[32]="Chapter3_W2_P"
    AliceMapName[33]="Chapter3_W2_P"
    AliceMapName[34]="Chapter3_W3_P"
    AliceMapName[35]="Chapter3_W3_P"
    AliceMapName[36]="Chapter3_W3_P"
    AliceMapName[37]="Chapter3_W3_P"
    AliceMapName[38]="Chapter4_L1_P"
    AliceMapName[39]="Chapter4_L1_P"
    AliceMapName[40]="Chapter4_W1_P"
    AliceMapName[41]="Chapter4_W2_P"
    AliceMapName[42]="Chapter4_W2_P"
    AliceMapName[43]="Chapter4_W3_P"
    AliceMapName[44]="Chapter4_W3_P"
    AliceMapName[45]="Chapter4_W3_P"
    AliceMapName[46]="Chapter5_L1_P"
    AliceMapName[47]="Chapter5_L1_P"
    AliceMapName[48]="Chapter5_W1_P"
    AliceMapName[49]="Chapter5_W1_P"
    AliceMapName[50]="Chapter5_W1_P"
    AliceMapName[51]="Chapter5_W1_P"
    AliceMapName[52]="Chapter5_W1_P"
    AliceMapName[53]="AliceEntry"
    AliceMapName[54]="Chapter5_W2_P"
    AliceMapName[55]="AliceEntry"
    AliceMapName[56]="AliceEntry"
    AliceMapName[57]="AliceEntry"
    AliceMapName[58]="AliceEntry"
    AliceMapName[59]="Chapter5_W3_P"
    AliceMapName[60]="Chapter5_W3_P"
    AliceMapName[61]="Chapter5_W3_P"
    AliceMapName[62]="Chapter6_P"
    AliceMapName[63]="Chapter6_P"
    AliceMapName[64]="Chapter6_P"
    AliceMapName[65]="Chapter6_P"
    AliceMapName[66]="Chapter6_P"
    AliceMapName[67]="Chapter1_L1_P"
    AliceMapName[68]="empty"
    AliceMapName[69]="ProHub"
    AliceChapterName="C1_L_DocHouse"
    AliceChapterName[1]="DEBUG_C1_L_Market"
    AliceChapterName[2]="C1_L_RoofTop"
    AliceChapterName[3]="C1_W_VOTSnail"
    AliceChapterName[4]="DEBUG_C1_W_VOTTrain"
    AliceChapterName[5]="C1_W_Junk"
    AliceChapterName[6]="C1_W_Gate"
    AliceChapterName[7]="C1_W_Tea"
    AliceChapterName[8]="C1_W_Hub"
    AliceChapterName[9]="C1_W_Smelt"
    AliceChapterName[10]="C1_W_Crank"
    AliceChapterName[11]="C1_W_AssEntry"
    AliceChapterName[12]="SCRIPTING_C1_W2P_Start"
    AliceChapterName[13]="C2_L_Docks"
    AliceChapterName[14]="REMOVED_DONTUSE_RedLight"
    AliceChapterName[15]="C2_L_Tundra"
    AliceChapterName[16]="C2_W_Slide"
    AliceChapterName[17]="C2_W_2DBoat"
    AliceChapterName[18]="C2_W_Crash"
    AliceChapterName[19]="REMOVED_DONTUSE_Swim1"
    AliceChapterName[20]="C2_W_Town1"
    AliceChapterName[21]="C2_W_Octopus"
    AliceChapterName[22]="C2_W_Coral"
    AliceChapterName[23]="C2_W_Kelp"
    AliceChapterName[24]="REMOVED_DONTUSE_Swim3"
    AliceChapterName[25]="C2_W_Grave"
    AliceChapterName[26]="C2_W_Town3"
    AliceChapterName[27]="C3_L_Ride"
    AliceChapterName[28]="C3_L_VOD"
    AliceChapterName[29]="C3_W_Ants"
    AliceChapterName[30]="C3_W_Shadow1"
    AliceChapterName[31]="C3_W_Shelf"
    AliceChapterName[32]="C3_W_Tree"
    AliceChapterName[33]="C3_W_Shadow2"
    AliceChapterName[34]="C3_W_Peak"
    AliceChapterName[35]="C3_W_Hive"
    AliceChapterName[36]="C3_W_Shadow3"
    AliceChapterName[37]="C3_W_Boss"
    AliceChapterName[38]="C4_L_Jail"
    AliceChapterName[39]="C4_L_Sky"
    AliceChapterName[40]="C4_W_East"
    AliceChapterName[41]="C4_W_West1"
    AliceChapterName[42]="C4_W_West2"
    AliceChapterName[43]="C4_W_Maze"
    AliceChapterName[44]="C4_W_Giant"
    AliceChapterName[45]="C4_W_Queen"
    AliceChapterName[46]="C5_L_Asylum"
    AliceChapterName[47]="C5_L_Hyde"
    AliceChapterName[48]="C5_W_Fort1"
    AliceChapterName[49]="C5_W_BoysUp"
    AliceChapterName[50]="C5_W_Head1"
    AliceChapterName[51]="C5_W_BoysLow"
    AliceChapterName[52]="C5_W_Dollboy"
    AliceChapterName[53]="REMOVED_DONTUSE_Head2"
    AliceChapterName[54]="C5_W_Fort2"
    AliceChapterName[55]="REMOVED_DONTUSE_GirlsUp"
    AliceChapterName[56]="REMOVED_DONTUSE_Head3"
    AliceChapterName[57]="REMOVED_DONTUSE_GirlsLow"
    AliceChapterName[58]="REMOVED_DONTUSE_Dollgirl"
    AliceChapterName[59]="C5_W_Train"
    AliceChapterName[60]="C5_W_Head2"
    AliceChapterName[61]="C5_W_DollMaker"
    AliceChapterName[62]="C6_L_Street"
    AliceChapterName[63]="C6_W_Train"
    AliceChapterName[64]="C6_W_Boss1"
    AliceChapterName[65]="C6_W_Boss2"
    AliceChapterName[66]="C6_W_End"
    AliceChapterName[67]="TGS_Demo"
    AliceChapterName[68]="empty"
    AliceChapterName[69]="PrototypeHub"
    CollisionType="COLLIDE_CustomDefault"
}

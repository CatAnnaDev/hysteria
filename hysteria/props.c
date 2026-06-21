#include "hysteria.h"

int M_POFF=-1, g_propCal=0, g_calTries=0;
int OFF_VEL=-1, OFF_PHYS=-1, OFF_HEALTH=-1, OFF_JUMPZ=-1, OFF_ACCEL=-1, OFF_COLLCOMP=-1;
int OFF_HEALTHMAX=-1, OFF_TD=-1, OFF_BOUNDS=-1;
int OFF_GROUNDSPEED=-1, OFF_AIRCONTROL=-1, OFF_GRAVITY=-1, OFF_CAMSTYLE=-1, OFF_CUSTOMTD=-1;
int OFF_XPVALUE=-1, OFF_WEAPONLEVEL=-1, OFF_UPGRADEHEALTH=-1, OFF_MEMCOMPLETED=-1;
int OFF_BCOLLWORLD=-1, OFF_BDELETEME=-1, M_BITMASK=-1;
unsigned MASK_COLLWORLD=0, MASK_BDELETEME=0;

static int single_bit(unsigned v){ return v && !(v&(v-1)); }
int resolve_bool(const char *name, const char *cls, unsigned *mask){
    void *p=find_prop(name,cls);
    if(!p || M_POFF<0) return -1;
    if(mask){ *mask=(M_BITMASK>=0 && mem_ok((char*)p+M_BITMASK,4))?*(unsigned*)((char*)p+M_BITMASK):0; }
    return *(int*)((char*)p+M_POFF);
}
static void calibrate_bool_mask(void){
    void *bw=find_prop("bCollideWorld","Actor");
    void *ba=find_prop("bBlockActors","Actor");
    if(!bw || !ba) return;
    OFF_BCOLLWORLD=*(int*)((char*)bw+M_POFF);
    for(int o=0x68;o<=0x88;o+=4){
        if(!mem_ok((char*)bw+o,4) || !mem_ok((char*)ba+o,4)) continue;
        unsigned m1=*(unsigned*)((char*)bw+o), m2=*(unsigned*)((char*)ba+o);
        if(single_bit(m1) && single_bit(m2) && m1!=m2){ MASK_COLLWORLD=m1; M_BITMASK=o; break; }
    }
    OFF_BDELETEME=resolve_bool("bDeleteMe","Object",&MASK_BDELETEME);
    if(OFF_BDELETEME<0) OFF_BDELETEME=resolve_bool("bDeleteMe","Actor",&MASK_BDELETEME);
}

int is_property(void *o){
    const char *c=obj_class_name(o);
    return c && contains(c,"Property");
}

void* find_prop(const char *name, const char *declClass){
    if(!g_gobjects) return NULL;
    void **data=*(void***)g_gobjects; int cnt=mem_ok(data,8)?*(int*)(g_gobjects+4):0;
    if(cnt>400000) cnt=400000;
    for(int i=0;i<cnt;i++){
        void *o=data[i];
        if(!mem_ok(o,O_CLASS+4)) continue;
        const char *nm=obj_name(o);
        if(!nm || lstrcmpA(nm,name)!=0) continue;
        if(!is_property(o)) continue;
        if(declClass){
            const char *on=obj_name(*(void**)((char*)o+O_OUTER));
            if(!on || lstrcmpA(on,declClass)!=0) continue;
        }
        return o;
    }
    return NULL;
}

int prop_off(const char *name, const char *declClass){
    void *p=find_prop(name,declClass);
    if(!p && declClass) p=find_prop(name,NULL);
    if(!p || M_POFF<0) return -1;
    int v=*(int*)((char*)p+M_POFF);
    return (v>=0 && v<0x8000)?v:-1;
}

void calibrate_props(void){
    void *pawnP=find_prop("Pawn","Controller"); if(!pawnP) pawnP=find_prop("Pawn",NULL);
    void *locP =find_prop("Location","Actor");  if(!locP)  locP =find_prop("Location",NULL);
    if(!pawnP || !locP) return;
    for(int o=0x30;o<=0x84;o+=4){
        if(!mem_ok((char*)pawnP+o,4) || !mem_ok((char*)locP+o,4)) continue;
        if(*(int*)((char*)pawnP+o)==0x22C && *(int*)((char*)locP+o)==0x64){ M_POFF=o; break; }
    }
    if(M_POFF<0) return;
    g_propCal=1;
    OFF_VEL   =prop_off("Velocity","Actor");
    OFF_PHYS  =prop_off("Physics","Actor");
    OFF_HEALTH=prop_off("Health","Pawn");
    OFF_JUMPZ =prop_off("JumpZ","Pawn");
    OFF_ACCEL =prop_off("Acceleration","Pawn");
    OFF_COLLCOMP=prop_off("CollisionComponent","Actor");
    OFF_HEALTHMAX=prop_off("HealthMax","Pawn");
    OFF_TD=prop_off("TimeDilation","WorldInfo");
    OFF_BOUNDS=prop_off("Bounds","PrimitiveComponent");
    OFF_GROUNDSPEED=prop_off("GroundSpeed","Pawn");
    OFF_AIRCONTROL=prop_off("AirControl","Pawn");
    OFF_GRAVITY=prop_off("WorldGravityZ","WorldInfo");
    if(OFF_GRAVITY<0) OFF_GRAVITY=prop_off("DefaultGravityZ","WorldInfo");
    OFF_CAMSTYLE=prop_off("CameraStyle","Camera");
    if(OFF_CAMSTYLE<0) OFF_CAMSTYLE=prop_off("CameraStyle","PlayerCameraManager");
    OFF_CUSTOMTD=prop_off("CustomTimeDilation","Actor");
    OFF_XPVALUE=prop_off("XPValue","Pawn");
    OFF_WEAPONLEVEL=prop_off("WeaponLevel","AlicePlayerController");
    OFF_UPGRADEHEALTH=prop_off("UpgradeHealth","AlicePlayerController");
    OFF_MEMCOMPLETED=prop_off("MemoryCompleted","AlicePlayerController");
    calibrate_bool_mask();
    logmsg("[hysteria] calib POFF=0x%x vel=%x phys=%x hp=%x cc=%x bounds=%x bcw=%x mask=%x td=%x\r\n",
        M_POFF,OFF_VEL,OFF_PHYS,OFF_HEALTH,OFF_COLLCOMP,OFF_BOUNDS,OFF_BCOLLWORLD,MASK_COLLWORLD,OFF_TD);
}

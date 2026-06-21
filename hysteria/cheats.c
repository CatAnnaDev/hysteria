#include "hysteria.h"

int g_god=0, g_fly=0, g_noclip=0, g_godHP=0, g_showHB=0, g_stable=0, g_freeze=0, g_freecam=0;
float g_savePos[3];
int g_haveSave=0;
float g_fcSpeed=4000.0f;
static int g_fcOn=0, g_fcStyle0=0, g_fcStyle1=0, g_fcYaw=0, g_fcPitch=0;
static float g_fcPos[3], g_fcPlayer[3];
float g_flySpeed=3000.0f, g_hbDist=9000.0f, g_gameSpeed=1.0f, g_jumpZ=0.0f, g_jumpPower=1200.0f;
float g_groundSpeed=0.0f, g_airControl=0.0f, g_gravity=0.0f, g_fovVal=85.0f;
int g_fovOverride=0;
int g_uiSaveReq=0, g_uiTpReq=0, g_uiHealReq=0, g_uiDumpReq=0, g_uiGoReq=0;
int g_uiSaveSlot=-1, g_uiLoadSlot=-1;
float g_tpX=0, g_tpY=0, g_tpZ=0;
int g_tasPause=0, g_uiStepReq=0, g_uiSSsave=-1, g_uiSSload=-1, g_tasStepFrames=0;
static struct { float pos[3],vel[3]; int rot[3]; int hp; unsigned char phys; int have; } g_ss[3];

static float g_freezePos[3];
static float g_slotPos[3][3];
static int g_slotHave[3]={0,0,0};

int key_edge(int vk){
    static unsigned char prev[256];
    int down = (GetAsyncKeyState(vk)&0x8000)?1:0;
    int edge = down && !prev[vk&0xff];
    prev[vk&0xff]=(unsigned char)down;
    return edge;
}

void cheats_update(IDirect3DDevice9 *dev, void *pawn, float *L, float *V, int hp, int pawnFull, int isMenu){
    (void)dev; (void)hp; (void)isMenu;
    if(key_edge(VK_OEM_3)) g_uiVisible=!g_uiVisible;

    {
        static int fixedIdx=-2;
        if(fixedIdx==-2) fixedIdx=find_name("Fixed");
        void *cam=mem_ok(g_pc,PC_CAMERA+4)?*(void**)((char*)g_pc+PC_CAMERA):NULL;
        if(g_freecam && cam){
            if(g_camLocOff<0) calibrate_camera(g_pc,L);
            if(g_camLocOff>=0 && mem_ok((char*)cam+g_camLocOff,28)){
                float *C=(float*)((char*)cam+g_camLocOff);
                int *R=(int*)((char*)cam+g_camLocOff+12);
                int *crot=(int*)((char*)g_pc+0x70);
                if(!g_fcOn){
                    g_fcOn=1;
                    g_fcPos[0]=C[0]; g_fcPos[1]=C[1]; g_fcPos[2]=C[2];
                    g_fcPlayer[0]=L[0]; g_fcPlayer[1]=L[1]; g_fcPlayer[2]=L[2];
                    g_fcPitch=R[0]; g_fcYaw=R[1];
                    if(OFF_CAMSTYLE>0 && mem_ok((char*)cam+OFF_CAMSTYLE,8)){
                        g_fcStyle0=*(int*)((char*)cam+OFF_CAMSTYLE);
                        g_fcStyle1=*(int*)((char*)cam+OFF_CAMSTYLE+4);
                    }
                }
                if(OFF_CAMSTYLE>0 && fixedIdx>=0 && mem_ok((char*)cam+OFF_CAMSTYLE,8)){
                    *(int*)((char*)cam+OFF_CAMSTYLE)=fixedIdx;
                    *(int*)((char*)cam+OFF_CAMSTYLE+4)=0;
                }
                int look=350;
                if(GetAsyncKeyState(VK_LEFT)&0x8000)  g_fcYaw-=look;
                if(GetAsyncKeyState(VK_RIGHT)&0x8000) g_fcYaw+=look;
                if(GetAsyncKeyState(VK_UP)&0x8000)    g_fcPitch+=look;
                if(GetAsyncKeyState(VK_DOWN)&0x8000)  g_fcPitch-=look;
                if(g_fcPitch>16000) g_fcPitch=16000;
                if(g_fcPitch<-16000) g_fcPitch=-16000;
                double yaw=g_fcYaw*(3.14159265358979/32768.0), pitch=g_fcPitch*(3.14159265358979/32768.0);
                double cp=cos(pitch),sp=sin(pitch),cyw=cos(yaw),syw=sin(yaw);
                double fX=cp*cyw,fY=cp*syw,fZ=sp, rX=-syw,rY=cyw;
                double mx=0,my=0,mz=0;
                if(GetAsyncKeyState('W')&0x8000){ mx+=fX; my+=fY; mz+=fZ; }
                if(GetAsyncKeyState('S')&0x8000){ mx-=fX; my-=fY; mz-=fZ; }
                if(GetAsyncKeyState('D')&0x8000){ mx+=rX; my+=rY; }
                if(GetAsyncKeyState('A')&0x8000){ mx-=rX; my-=rY; }
                if(GetAsyncKeyState(VK_SPACE)&0x8000)   mz+=1;
                if(GetAsyncKeyState(VK_CONTROL)&0x8000) mz-=1;
                double len=sqrt(mx*mx+my*my+mz*mz);
                float step=g_fcSpeed/60.0f;
                if(GetAsyncKeyState(VK_SHIFT)&0x8000) step*=4.0f;
                if(len>0.01){ g_fcPos[0]+=(float)(mx/len*step); g_fcPos[1]+=(float)(my/len*step); g_fcPos[2]+=(float)(mz/len*step); }
                C[0]=g_fcPos[0]; C[1]=g_fcPos[1]; C[2]=g_fcPos[2];
                R[0]=g_fcPitch; R[1]=g_fcYaw; R[2]=0;
                if(pawnFull){ L[0]=g_fcPlayer[0]; L[1]=g_fcPlayer[1]; L[2]=g_fcPlayer[2]; if(V){V[0]=V[1]=V[2]=0.0f;} }
            }
        } else if(g_fcOn){
            g_fcOn=0;
            if(cam && OFF_CAMSTYLE>0 && mem_ok((char*)cam+OFF_CAMSTYLE,8)){
                *(int*)((char*)cam+OFF_CAMSTYLE)=g_fcStyle0;
                *(int*)((char*)cam+OFF_CAMSTYLE+4)=g_fcStyle1;
            }
        }
    }
}

#include "hysteria.h"

#define MAXACT 64
ActInfo g_actors[MAXACT];
int g_actorN=0;

static void insert_act(int *n, int dist, int kind, float *L, const char *on){
    int cap=MAXACT;
    if(*n>=cap && dist>=g_actors[cap-1].dist) return;
    int p = (*n<cap) ? (*n)++ : cap-1;
    while(p>0 && g_actors[p-1].dist>dist){ g_actors[p]=g_actors[p-1]; p--; }
    g_actors[p].dist=dist; g_actors[p].kind=kind;
    g_actors[p].x=L[0]; g_actors[p].y=L[1]; g_actors[p].z=L[2];
    lstrcpynA(g_actors[p].name, on, sizeof g_actors[p].name);
}

void scan_actors(float *pl){
    if(!g_gobjects || OFF_COLLCOMP<0){ g_actorN=0; return; }
    void **data=*(void***)g_gobjects; int cnt=mem_ok(data,8)?*(int*)(g_gobjects+4):0;
    if(cnt>400000) cnt=400000;
    float d=g_hbDist;
    int n=0;
    for(int i=0;i<cnt;i++){
        void *o=data[i];
        if(!mem_ok(o,0x70)) continue;
        float *L=(float*)((char*)o+A_LOC);
        float dx=L[0]-pl[0],dy=L[1]-pl[1],dz=L[2]-pl[2];
        if(dx<-d||dx>d||dy<-d||dy>d||dz<-d||dz>d||!(dx||dy||dz)) continue;
        void *cc=*(void**)((char*)o+OFF_COLLCOMP);
        if(!mem_ok(cc,O_CLASS+4)) continue;
        const char *cn=obj_class_name(cc);
        if(!cn || !contains(cn,"Component")) continue;
        const char *on=obj_name(o);
        int kind=hb_classify(obj_class_name(o), on);
        int dist=(int)__builtin_sqrtf(dx*dx+dy*dy+dz*dz);
        int num=*(int*)((char*)o+O_NAME+4);
        char nm[40];
        if(num>0) wsprintfA(nm,"%s_%d",on,num); else lstrcpynA(nm,on,sizeof nm);
        insert_act(&n, dist, kind, L, nm);
    }
    g_actorN=n;
}

int g_freezeEnemies=0, g_killEnemiesReq=0;
#define MAXEN 64
static void *g_enemies[MAXEN];
static int g_enemyN=0;
static void scan_enemies(float *pl, void *ppawn){
    g_enemyN=0;
    if(!g_gobjects) return;
    void **data=*(void***)g_gobjects; int cnt=mem_ok(data,8)?*(int*)(g_gobjects+4):0;
    if(cnt>400000) cnt=400000;
    float d=g_hbDist;
    for(int i=0;i<cnt && g_enemyN<MAXEN;i++){
        void *o=data[i];
        if(o==ppawn || !mem_ok(o,0x70)) continue;
        const char *cn=obj_class_name(o);
        if(!cn || !contains(cn,"Pawn")) continue;
        const char *on=obj_name(o);
        if(on[0]=='D'&&on[1]=='e'&&on[2]=='f') continue;
        float *L=(float*)((char*)o+A_LOC);
        float dx=L[0]-pl[0],dy=L[1]-pl[1],dz=L[2]-pl[2];
        if(dx<-d||dx>d||dy<-d||dy>d||dz<-d||dz>d) continue;
        g_enemies[g_enemyN++]=o;
    }
}
void enemies_tick(float *pl, void *ppawn){
    static int tick=0, wasFreeze=0;
    if(g_killEnemiesReq){
        g_killEnemiesReq=0;
        scan_enemies(pl,ppawn);
        for(int i=0;i<g_enemyN;i++){
            void *e=g_enemies[i];
            if(OFF_HEALTH>0 && mem_ok((char*)e+OFF_HEALTH,4)) *(int*)((char*)e+OFF_HEALTH)=0;
            if(OFF_BDELETEME>=0 && MASK_BDELETEME && mem_ok((char*)e+OFF_BDELETEME,4))
                *(unsigned*)((char*)e+OFF_BDELETEME) |= MASK_BDELETEME;
        }
    }
    if(g_freezeEnemies){
        if(++tick>=15){ tick=0; scan_enemies(pl,ppawn); }
        if(OFF_CUSTOMTD>0) for(int i=0;i<g_enemyN;i++){
            void *e=g_enemies[i];
            if(mem_ok((char*)e+OFF_CUSTOMTD,4)) *(float*)((char*)e+OFF_CUSTOMTD)=0.03f;
        }
        wasFreeze=1;
    } else if(wasFreeze){
        wasFreeze=0;
        if(OFF_CUSTOMTD>0) for(int i=0;i<g_enemyN;i++){
            void *e=g_enemies[i];
            if(mem_ok((char*)e+OFF_CUSTOMTD,4)) *(float*)((char*)e+OFF_CUSTOMTD)=1.0f;
        }
    }
}

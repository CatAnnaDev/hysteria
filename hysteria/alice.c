#include "hysteria.h"

int g_aliceCal=0;
int g_alUnlockAll=0, g_alHystAnytime=0, g_alForceHyst=0, g_alHystGod=0;
int g_alInfRegen=0, g_alShrinkSense=0, g_alFillEndurance=0;
float g_alDmgBonus=0.0f;

typedef struct { const char *name, *cls; int off; unsigned mask; } ABool;

static ABool g_can[] = {
    {"bCanCombat","AlicePawn",-1,0},
    {"bCanLockon","AlicePawn",-1,0},
    {"bCanShrink","AlicePawn",-1,0},
    {"bCanClockBomb","AlicePawn",-1,0},
    {"bCanDodge","AlicePawn",-1,0},
    {"bCanBlock","AlicePawn",-1,0},
    {"bCanHysteria","AlicePawn",-1,0},
    {"bCanDeflect","AlicePawn",-1,0},
    {"bCanDoubleJump","AlicePawn",-1,0},
    {"bCanFloat","AlicePawn",-1,0},
    {"bCanAiming","AlicePawn",-1,0},
    {"bCanShowPath","AlicePawn",-1,0},
    {"bCanShowCat","AlicePawn",-1,0},
    {"bCanEnableSonar","AlicePawn",-1,0},
};
static const int g_canN = sizeof g_can/sizeof*g_can;

static ABool b_inHyst   = {"bInHysteriaMode","AlicePawn",-1,0};
static ABool b_anytime  = {"bActivateHysterialAnytime","AlicePawn",-1,0};
static ABool b_enHyst   = {"bEnableHysteria","AlicePawn",-1,0};
static ABool b_hystGod  = {"bHysteriaGodMode","AlicePawn",-1,0};
static ABool b_shrink   = {"bShrinkingModeActive","AlicePlayerController",-1,0};

static int off_dmg=-1, off_hystLeft=-1, off_endur=-1, off_regen=-1;

static void rb(ABool *b){
    void *p=find_prop(b->name,b->cls);
    if(!p && b->cls) p=find_prop(b->name,NULL);
    if(!p || M_POFF<0){ b->off=-1; return; }
    b->off=*(int*)((char*)p+M_POFF);
    b->mask=(M_BITMASK>=0 && mem_ok((char*)p+M_BITMASK,4))?*(unsigned*)((char*)p+M_BITMASK):0;
}

static void set_bit(void *base, ABool *b, int on){
    if(!base || b->off<0 || !b->mask || !mem_ok((char*)base+b->off,4)) return;
    unsigned *p=(unsigned*)((char*)base+b->off);
    if(on) *p|=b->mask; else *p&=~b->mask;
}

void alice_calibrate(void){
    if(g_aliceCal || M_POFF<0) return;
    for(int i=0;i<g_canN;i++) rb(&g_can[i]);
    rb(&b_inHyst); rb(&b_anytime); rb(&b_enHyst); rb(&b_hystGod); rb(&b_shrink);
    off_dmg     =prop_off("IncraseDamagePercent","AlicePawn");
    off_hystLeft=prop_off("HysteriaLeftTime","AlicePawn");
    off_endur   =prop_off("CurEndurance","AlicePawn");
    off_regen   =prop_off("HealthRegen","AlicePawn");
    g_aliceCal=1;
    logmsg("[hysteria][alice] calib can=%x/%x hyst=%x/%x god=%x/%x shrink=%x/%x dmg=%x endur=%x regen=%x\r\n",
        g_can[0].off,g_can[0].mask, b_inHyst.off,b_inHyst.mask, b_hystGod.off,b_hystGod.mask,
        b_shrink.off,b_shrink.mask, off_dmg,off_endur,off_regen);
}

void alice_tick(void *pawn, void *pc){
    static int shrinkPrev=-1;
    if(!g_aliceCal || !pawn || !mem_ok(pawn,0x100)) return;

    if(g_alUnlockAll) for(int i=0;i<g_canN;i++) set_bit(pawn,&g_can[i],1);

    if(g_alHystAnytime){ set_bit(pawn,&b_anytime,1); set_bit(pawn,&b_enHyst,1); }
    if(g_alForceHyst){
        set_bit(pawn,&b_inHyst,1);
        if(off_hystLeft>=0 && mem_ok((char*)pawn+off_hystLeft,4)) *(float*)((char*)pawn+off_hystLeft)=999.0f;
    }
    if(g_alHystGod) set_bit(pawn,&b_hystGod,1);
    if(g_alFillEndurance && off_endur>=0 && mem_ok((char*)pawn+off_endur,4)) *(float*)((char*)pawn+off_endur)=100.0f;
    if(g_alInfRegen && off_regen>=0 && mem_ok((char*)pawn+off_regen,4)) *(float*)((char*)pawn+off_regen)=100.0f;
    if(g_alDmgBonus>0.01f && off_dmg>=0 && mem_ok((char*)pawn+off_dmg,4)) *(float*)((char*)pawn+off_dmg)=g_alDmgBonus;

    if(pc && b_shrink.off>=0 && g_alShrinkSense!=shrinkPrev){ set_bit(pc,&b_shrink,g_alShrinkSense); shrinkPrev=g_alShrinkSense; }
}

#include <windows.h>
#include "hysteria_api.h"

static HysteriaAPI *A;

static int unlockAll, hystAnytime, forceHyst, hystGod, infRegen, shrinkSense, fillEndurance;
static float dmgBonus=0.0f;

static const char *abilities[] = {
    "bCanCombat","bCanLockon","bCanShrink","bCanClockBomb","bCanDodge","bCanBlock",
    "bCanHysteria","bCanDeflect","bCanDoubleJump","bCanFloat","bCanAiming",
    "bCanShowPath","bCanShowCat","bCanEnableSonar",
};
static const int abilityN = sizeof abilities / sizeof *abilities;

static void alice_panel(void){
    A->ui_checkbox("Unlock all abilities", &unlockAll);
    A->ui_checkbox("Shrink sense (hidden paths)", &shrinkSense);
    A->ui_checkbox("Infinite health regen", &infRegen);
    A->ui_label("Hysteria");
    A->ui_checkbox("Trigger anytime", &hystAnytime);
    A->ui_checkbox("Force hysteria mode", &forceHyst);
    A->ui_checkbox("Hysteria god mode", &hystGod);
    A->ui_checkbox("Fill rage meter", &fillEndurance);
    A->ui_slider_float("Bonus dmg (0=off)", &dmgBonus, 0, 50, 0.5f);
}

static void tick(void){
    AObj pawn=A->player_pawn(), pc=A->player_controller();
    if(!pawn) return;

    if(unlockAll) for(int i=0;i<abilityN;i++) A->set_bool(pawn, abilities[i], 1);
    if(hystAnytime){ A->set_bool(pawn,"bActivateHysterialAnytime",1); A->set_bool(pawn,"bEnableHysteria",1); }
    if(forceHyst){ A->set_bool(pawn,"bInHysteriaMode",1); A->set_float(pawn,"HysteriaLeftTime",999.0f); }
    if(hystGod) A->set_bool(pawn,"bHysteriaGodMode",1);
    if(fillEndurance) A->set_float(pawn,"CurEndurance",100.0f);
    if(infRegen) A->set_float(pawn,"HealthRegen",100.0f);
    if(dmgBonus>0.01f) A->set_float(pawn,"IncraseDamagePercent",dmgBonus);

    static int prevShrink=-1;
    if(pc && shrinkSense!=prevShrink){ A->set_bool(pc,"bShrinkingModeActive",shrinkSense); prevShrink=shrinkSense; }
}

__declspec(dllexport) void ModMain(HysteriaAPI *api){
    A=api;
    A->log("alice mod loaded");
    A->ui_panel("Alice", alice_panel);
    A->on_tick(tick);
}

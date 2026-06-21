#ifndef MOD_INTERNAL_H
#define MOD_INTERNAL_H
#include "hysteria_api.h"


typedef void (__fastcall *PE_t)(void *obj, void *edx, void *fn, void *parms, void *res);
extern PE_t g_peTramp;

int  dispatch_event(void *obj, void *fn, void *parms, void *res);
void dispatch_post(void *obj, void *fn, void *parms, void *res);
void load_mods(void);
void mod_do_reload(void);

#endif

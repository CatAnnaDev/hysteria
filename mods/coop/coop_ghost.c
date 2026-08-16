#include "coop.h"

static int g_hideMask;
static int g_hideApplied;

CoopGhost g_ghost;

static AObj  g_adoptCandidate;
static int   g_adoptSkip;
static int   g_adoptSeen;

static int   g_spawnWin = -1;
static int   g_preflightLogged;
static int   g_releasing;
static AObj  g_ghostMesh;
static AObj  g_aliceCls;

static AObj game_info(void) {
    AObj wi = A->world_info();
    return wi ? A->get_obj(wi, "Game") : 0;
}

static AObj ghost_mesh(void) {
    AObj g = g_ghost.obj;
    if (!g) return 0;
    if (g_ghostMesh && guard_obj_ok(g_ghostMesh)) return g_ghostMesh;
    g_ghostMesh = A->get_obj(g, "Mesh");
    if (!g_ghostMesh) g_ghostMesh = A->get_obj(g, "SkeletalMeshComponent");
    return g_ghostMesh;
}

static void mesh_config_cb(AObj c) {
    unsigned f;
    float one = 1.0f, zero3[3] = {0.0f, 0.0f, 0.0f}, reset = 0.0f;
    int izero = 0;
    unsigned char rmm = RMM_IGNORE;
    if (!c || !A->is_a(c, "SkeletalMeshComponent")) return;

    if (A->read_raw(c, O_SKEL_FLAGS_B, &f, 4)) {
        f |= F_bUpdateSkelWhenNotRendered | F_bUpdateJointsFromAnimation;
        f &= ~(F_bPauseAnims | F_bSkipAllUpdateWhenPhysicsAsleep | F_bIgnoreControllersWhenNotRendered);
        A->write_raw(c, O_SKEL_FLAGS_B, &f, 4);
    }
    if (A->read_raw(c, O_SKEL_CLOTHFLAGS, &f, 4)) {
        f |= F_bEnableClothSimulation | F_bClothWindRelativeToOwner;
        f &= ~(F_bClothFrozen | F_bAutoFreezeClothWhenNotRendered);
        A->write_raw(c, O_SKEL_CLOTHFLAGS, &f, 4);
    }
    if (A->read_raw(c, O_PRIM_FLAGS, &f, 4)) {
        f &= ~F_HiddenGame;
        A->write_raw(c, O_PRIM_FLAGS, &f, 4);
    }
    if (A->read_raw(c, O_SKEL_NOSKELUPDATE, &f, 4)) {
        f &= ~F_bNoSkeletonUpdate;
        A->write_raw(c, O_SKEL_NOSKELUPDATE, &f, 4);
    }
    A->write_raw(c, O_SKEL_FORCEREFPOSE, &izero, 4);
    A->write_raw(c, O_SKEL_IGNORECTRL, &izero, 4);
    A->write_raw(c, O_SKEL_ROOTMOTIONMODE, &rmm, 1);
    A->write_raw(c, O_SKEL_CLOTHBLEND, &one, 4);
    A->write_raw(c, O_SKEL_CLOTHFORCE, zero3, 12);

    if (A->read_raw(c, O_SKEL_MINCLOTHRESET, &reset, 4)) {
        float want = reset > 1.0f ? reset * 8.0f : 4096.0f;
        A->write_raw(c, O_SKEL_MINCLOTHRESET, &want, 4);
    }
}

static void ghost_configure_meshes(AObj g) {
    if (A->iter_components) A->iter_components(g, mesh_config_cb);
    else {
        AObj m = A->get_obj(g, "Mesh");
        if (m) mesh_config_cb(m);
    }
}

static void cloth_mask_snap(const float loc[3]) {
    AObj m = ghost_mesh();
    if (m) A->write_raw(m, O_SKEL_LASTCLOTHLOC, loc, 12);
}

static void ghost_root_motion_off(void) {
    unsigned char rmm = RMM_IGNORE;
    AObj m = ghost_mesh();
    if (m) A->write_raw(m, O_SKEL_ROOTMOTIONMODE, &rmm, 1);
}

static void ghost_light_on(AObj g) {
    AObj le = A->get_obj(g, "LightEnvironment");
    ACall c;
    int on = -1;

    if (!le) { coop_log("coop: fantome sans LightEnvironment, il restera sombre"); return; }
    c = A->call_begin(le, "SetEnabled");
    if (!c) { coop_log("coop: SetEnabled introuvable, eclairage du fantome non force"); return; }
    A->call_arg_bool(c, "bNewEnabled", 1);
    A->call_invoke(c);
    A->get_bool(le, "bEnabled", &on);

    c = A->call_begin(g, "ForceUpdateComponents");
    if (c) {
        A->call_arg_bool(c, "bCollisionUpdate", 0);
        A->call_arg_bool(c, "bTransformOnly", 0);
        A->call_invoke(c);
    }
    coop_log("coop: eclairage du fantome active (bEnabled=%d)", on);
}

static void ghost_configure(AObj g) {
    unsigned w;
    float zero = 0.0f, maxFall = 8000.0f;
    int izero = 0, rot[3];
    void *nul = 0;

    A->write_raw(g, O_PAWN_CONTROLLER, &nul, 4);
    ghost_light_on(g);

    if (A->read_raw(g, O_PAWN_FLAGS1, &w, 4)) {
        w |= F_bRunPhysicsWithNoController | F_bDontPossess;
        w &= ~(F_bDesiredRotationSet | F_bLockDesiredRotation | F_bRollToDesired);
        A->write_raw(g, O_PAWN_FLAGS1, &w, 4);
    }
    if (A->read_raw(g, O_PAWN_FLAGS0, &w, 4)) {
        w |= F_bIgnoreForces | F_bCanWalkOffLedges;
        w &= ~F_bAvoidLedges;
        A->write_raw(g, O_PAWN_FLAGS0, &w, 4);
    }
    if (A->read_raw(g, O_PAWN_FLAGS2, &w, 4)) {
        w &= ~F_bCanBeLockedOn;
        A->write_raw(g, O_PAWN_FLAGS2, &w, 4);
    }
    A->write_raw(g, O_PAWN_STOPATLEDGES, &izero, 4);
    A->write_raw(g, O_PAWN_MAXFALLSPEED, &maxFall, 4);

    if (A->read_raw(g, O_ACTOR_FLAGS0, &w, 4)) {
        w &= ~(F_bHidden | F_bPushedByEncroachers | F_bCanStepUpOn);
        A->write_raw(g, O_ACTOR_FLAGS0, &w, 4);
    }
    if (A->read_raw(g, O_ACTOR_FLAGS1, &w, 4)) {
        w &= ~F_bCanBeDamaged;
        A->write_raw(g, O_ACTOR_FLAGS1, &w, 4);
    }
    if (A->read_raw(g, O_ACTOR_FLAGS2, &w, 4)) {
        if (g_ghost.mode == 0) w |= F_bCollideWorld;
        else                   w &= ~F_bCollideWorld;
        w &= ~(F_bCollideActors | F_bBlockActors | F_bProjTarget);
        A->write_raw(g, O_ACTOR_FLAGS2, &w, 4);
    }
    if (A->read_raw(g, O_AGP_FLAGS1, &w, 4)) {
        w &= ~F_bForceDesiredRotation;
        A->write_raw(g, O_AGP_FLAGS1, &w, 4);
    }
    if (A->read_raw(g, O_AP_F99C, &w, 4)) {
        w &= ~F_bStopUpdating;
        A->write_raw(g, O_AP_F99C, &w, 4);
    }
    if (A->read_raw(g, O_AP_F9A0, &w, 4)) {
        w &= ~F_bShouldBeHide;
        A->write_raw(g, O_AP_F9A0, &w, 4);
    }
    if (A->read_raw(g, O_ROTATION, rot, 12)) A->write_raw(g, O_PAWN_DESIREDROT, rot, 12);
    A->write_raw(g, O_LIFESPAN, &zero, 4);

    ghost_set_physics_mode(g_ghost.mode);
    ghost_configure_meshes(g);
}

void ghost_set_physics_mode(int mode) {
    unsigned char phys;
    if (!g_ghost.obj) return;
    phys = (mode == 0) ? 1 : (mode == 1) ? 4 : 0;
    if (mode >= 2) phys = 0;
    actor_set_physics(g_ghost.obj, phys);
}

typedef struct {
    unsigned char spawner;
    unsigned char owner;
    unsigned char tmpl;
    unsigned char nocol;
    unsigned char path;
    const char   *label;
} SpawnTry;

enum { SP_GAMEINFO = 0, SP_PC = 1, SP_PAWN = 2 };
enum { TP_CACHED = 0, TP_NAMED = 1, TP_NONE = 2 };

static const SpawnTry SPAWN_TRIES[] = {
    {SP_GAMEINFO, 0, TP_CACHED, 0, ASPAWN_PATH_EXEC, "recette du jeu: GameInfo.SpawnDefaultPawnFor"},
    {SP_PC,       1, TP_CACHED, 1, ASPAWN_PATH_EXEC, "recette du jeu: PC.CloneAlice (owner=PC, sans collision)"},
    {SP_PC,       0, TP_CACHED, 1, ASPAWN_PATH_EXEC, "PC sans owner, sans collision"},
    {SP_PAWN,     0, TP_CACHED, 1, ASPAWN_PATH_EXEC, "pawn local receveur, sans collision"},
    {SP_PC,       0, TP_NAMED,  1, ASPAWN_PATH_EXEC, "archetype resolu par son chemin"},
    {SP_PC,       0, TP_NONE,   1, ASPAWN_PATH_EXEC, "sans archetype (defauts de classe)"},
    {SP_PC,       1, TP_CACHED, 1, ASPAWN_PATH_PE,   "ProcessEvent: owner=PC, sans collision"},
    {SP_PC,       0, TP_NONE,   1, ASPAWN_PATH_PE,   "ProcessEvent: sans archetype"}
};
#define SPAWN_TRIES_N ((int)(sizeof SPAWN_TRIES / sizeof SPAWN_TRIES[0]))

static const char *const SPAWN_STAGE[10] = {
    "OK",
    "arguments invalides",
    "classe introuvable",
    "fonction Spawn non resolue sur ce receveur",
    "bloc de parametres de taille implausible",
    "parametre SpawnClass introuvable",
    "parametre ReturnValue introuvable",
    "aucune implementation native a piloter",
    "l exec n a jamais tourne, poison intact",
    "l exec a tourne, le moteur a refuse (None)"
};

static const char *stage_name(int st) {
    return (st >= 0 && st < 10) ? SPAWN_STAGE[st] : "code inconnu";
}

#define CENSUS_MAX 64
static AObj g_census[CENSUS_MAX];
static int  g_censusN;
static int  g_censusFull;
static AObj g_orphan;

static void alice_each(AIterCb cb) {
    int n, i;
    if (!g_aliceCls || !A->object_count || !A->object_at || !A->get_class_obj) {
        A->iter_objects("AlicePawn", cb);
        return;
    }
    n = A->object_count();
    for (i = 0; i < n; i++) {
        AObj o = A->object_at(i);
        if (o && A->get_class_obj(o) == g_aliceCls) cb(o);
    }
}

static void census_cb(AObj o) {
    if (g_censusN < CENSUS_MAX) g_census[g_censusN++] = o;
    else g_censusFull = 1;
}

static void census_take(void) {
    g_censusN = 0;
    g_censusFull = 0;
    alice_each(census_cb);
    if (g_censusFull)
        coop_log("coop: plus de %d AlicePawn dans le niveau, l adoption d un pion orphelin est desactivee", CENSUS_MAX);
}

static int census_has(AObj o) {
    int i;
    for (i = 0; i < g_censusN; i++) if (g_census[i] == o) return 1;
    return 0;
}

static int g_orphanExtra;

static void orphan_cb(AObj o) {
    const char *n;
    if (o == g_localPawn || census_has(o)) return;
    n = A->name_of(o);
    if (!n || strncmp(n, "Default__", 9) == 0) return;
    if (g_orphan) { g_orphanExtra++; return; }
    g_orphan = o;
}

static AObj orphan_pick(void) {
    g_orphan = 0;
    g_orphanExtra = 0;
    if (g_censusFull) return 0;
    alice_each(orphan_cb);
    return g_orphan;
}

static AObj arche_cached(AObj gi, int atid) {
    AObj t = 0;
    int off = -1;
    if (!gi) return 0;
    if (A->prop_offset) off = A->prop_offset(gi, "AliceCachedArcheType");
    if (off < 0) off = O_GI_CACHEDARCHE;
    A->read_raw(gi, off + 4 * atid, &t, 4);
    return t;
}

static AObj alice_class(void) {
    if (!g_aliceCls || !guard_obj_ok(g_aliceCls)) g_aliceCls = A->find_class("AlicePawn");
    return g_aliceCls;
}

static AObj arche_named(int london) {
    static AObj cache[2];
    int i = london ? 1 : 0;
    if (!cache[i] || !guard_obj_ok(cache[i]))
        cache[i] = A->find_object(london ? "CHAR_ArcheTypes.ArcheType_AliceLondon"
                                         : "CHAR_ArcheTypes.ArcheType_AliceWonderland");
    return cache[i];
}

static int loc_sane(const float p[3]) {
    int i;
    for (i = 0; i < 3; i++) {
        float v = p[i];
        if (!(v == v)) return 0;
        if (v > 1.0e6f || v < -1.0e6f) return 0;
    }
    return (p[0] != 0.0f || p[1] != 0.0f || p[2] != 0.0f);
}

static AObj ghost_spawn_pawn(const CoopState *want, const float loc[3], const int rot[3]) {
    AObj gi = game_info(), cls = alice_class();
    AObj pc = g_localPC, me = g_localPawn;
    AObj archeC, archeN, made = 0;
    unsigned char atid, prevAtid = 0;
    int london = (want->bits & (1u << 3)) ? 1 : 0;
    int order, i, atidSaved = 0;

    if (A->version < 18 || !A->spawn_probe) {
        coop_log("coop: spawn abandon - framework trop ancien (v18 requise, ici v%d)", A->version);
        return 0;
    }
    if (!cls)                                { coop_log("coop: spawn abandon - classe AlicePawn introuvable"); return 0; }
    if (!pc)                                 { coop_log("coop: spawn abandon - pas de PlayerController local"); return 0; }
    if (!me)                                 { coop_log("coop: spawn abandon - pas de pawn local"); return 0; }
    if (A->call_ready && !A->call_ready())   { coop_log("coop: spawn abandon - appels de jeu indisponibles"); return 0; }
    if (!gi)                                   coop_log("coop: spawn - WorldInfo.Game absent, la recette GameInfo sera sautee");

    atid = want->blkB[BLKB_ARCHETYPE];
    if (atid > 8 || atid == 6) {
        if (!A->read_raw(me, O_AP_BLOCKB + BLKB_ARCHETYPE, &atid, 1) || atid > 8 || atid == 6)
            atid = 1;
    }

    archeC = arche_cached(gi, atid);
    if (archeC && A->get_class_obj && A->get_class_obj(archeC) != cls) {
        coop_log("coop: spawn - archetype cache %s de classe %s, rejete (le moteur exige AlicePawn exactement)",
                 A->name_of(archeC), A->class_of(archeC));
        archeC = 0;
    }
    archeN = arche_named(london);
    if (archeN && A->get_class_obj && A->get_class_obj(archeN) != cls) archeN = 0;

    if (!g_preflightLogged) {
        float killz = 0.0f;
        g_preflightLogged = 1;
        if (g_worldInfo) A->read_raw(g_worldInfo, O_WI_KILLZ, &killz, 4);
        coop_log("coop: spawn preflight gi=%p pc=%p pawn=%p cls=%p atid=%d cache=%s nomme=%s",
                 gi, pc, me, cls, atid,
                 archeC ? A->name_of(archeC) : "aucun", archeN ? A->name_of(archeN) : "aucun");
        coop_log("coop: spawn preflight loc=%.0f %.0f %.0f yaw=%d killz=%.0f monde=%s",
                 loc[0], loc[1], loc[2], rot[1], killz, london ? "Londres" : "Wonderland");
    }

    if (gi) {
        atidSaved = A->read_raw(gi, O_GI_ARCHETYPEID, &prevAtid, 1);
        A->write_raw(gi, O_GI_ARCHETYPEID, &atid, 1);
    }

    census_take();

    for (order = 0; order < SPAWN_TRIES_N; order++) {
        const SpawnTry *tr;
        ASpawnInfo si;
        AObj recv, tmpl;

        i = (g_spawnWin >= 0) ? ((order == 0) ? g_spawnWin
                                             : (order <= g_spawnWin ? order - 1 : order))
                              : order;
        if (i < 0 || i >= SPAWN_TRIES_N) continue;
        tr = &SPAWN_TRIES[i];

        recv = (tr->spawner == SP_GAMEINFO) ? gi : (tr->spawner == SP_PC) ? pc : me;
        tmpl = (tr->tmpl == TP_CACHED) ? archeC : (tr->tmpl == TP_NAMED) ? archeN : 0;
        if (!recv) {
            coop_log("coop: spawn essai %d saute (%s) - receveur absent", i + 1, tr->label);
            continue;
        }
        if (tr->tmpl != TP_NONE && !tmpl) {
            coop_log("coop: spawn essai %d saute (%s) - archetype absent", i + 1, tr->label);
            continue;
        }

        si.spawner = recv;
        si.className = "AlicePawn";
        si.owner = tr->owner ? pc : 0;
        si.tag = 0;
        si.loc = loc;
        si.rot = rot;
        si.actorTemplate = tmpl;
        si.noCollisionFail = tr->nocol;
        si.path = tr->path;
        si.result = 0;
        si.stage = ASPAWN_BADARGS;
        si.ran = 0;

        A->spawn_probe(&si);

        if (si.stage == ASPAWN_OK && si.result) {
            if (!A->is_a(si.result, "AlicePawn")) {
                coop_log("coop: spawn essai %d a rendu %s [%s], pas un AlicePawn, ignore",
                         i + 1, A->name_of(si.result), A->class_of(si.result));
                continue;
            }
            g_spawnWin = i;
            made = si.result;
            coop_log("coop: spawn REUSSI essai %d (%s) -> %s [%s] recu=%s arche=%s nocol=%d voie=%s",
                     i + 1, tr->label, A->name_of(made), A->class_of(made),
                     A->name_of(recv), tmpl ? A->name_of(tmpl) : "aucun", tr->nocol,
                     tr->path == ASPAWN_PATH_PE ? "ProcessEvent" : "exec natif");
            break;
        }
        coop_log("coop: spawn essai %d ECHEC (%s) recu=%s arche=%s nocol=%d voie=%s -> stage=%d %s",
                 i + 1, tr->label, A->name_of(recv), tmpl ? A->name_of(tmpl) : "aucun",
                 tr->nocol, tr->path == ASPAWN_PATH_PE ? "ProcessEvent" : "exec natif",
                 si.stage, stage_name(si.stage));

        if (si.stage != ASPAWN_REFUSED) continue;
        if (orphan_pick()) {
            g_spawnWin = i;
            made = g_orphan;
            coop_log("coop: essai %d a rendu None mais %s (%s) existe, retour perdu en route, adoption (%d autres en trop)",
                     i + 1, A->name_of(made), A->class_of(made), g_orphanExtra);
            break;
        }
    }

    if (atidSaved) A->write_raw(gi, O_GI_ARCHETYPEID, &prevAtid, 1);
    if (!made) coop_log("coop: cascade epuisee (%d essais), aucun AlicePawn cree", SPAWN_TRIES_N);
    return made;
}

static void adopt_scan_cb(AObj o) {
    const char *cn;
    if (g_adoptCandidate) return;
    cn = A->class_of(o);
    if (!cn || lstrcmpA(cn, "AliceGameSkeletalMeshActorMAT") != 0) return;
    if (!A->name_of(o) || strncmp(A->name_of(o), "Default__", 9) == 0) return;
    g_adoptSeen++;
    if (g_adoptSeen <= g_adoptSkip) return;
    g_adoptCandidate = o;
}

static AObj ghost_adopt_body(void) {
    g_adoptCandidate = 0;
    g_adoptSeen = 0;
    A->iter_objects("AliceGameSkeletalMeshActorMAT", adopt_scan_cb);
    if (!g_adoptCandidate && g_adoptSkip) {
        g_adoptSkip = 0;
        g_adoptSeen = 0;
        A->iter_objects("AliceGameSkeletalMeshActorMAT", adopt_scan_cb);
    }
    return g_adoptCandidate;
}

static void ghost_identity_capture(AObj g) {
    const char *n = A->name_of(g);
    g_ghost.objIndex = 0;
    A->read_raw(g, O_OBJ_INDEX, &g_ghost.objIndex, 4);
    g_ghost.cls = A->get_class_obj ? A->get_class_obj(g) : 0;
    lstrcpynA(g_ghost.name, n ? n : "", sizeof g_ghost.name);
}

static int ghost_identity_ok(void) {
    AObj g = g_ghost.obj;
    const char *n;
    int idx = 0;
    unsigned f = 0;
    if (!g || !guard_obj_ok(g)) return 0;
    if (!A->read_raw(g, O_OBJ_INDEX, &idx, 4) || idx != g_ghost.objIndex) return 0;
    if (g_ghost.cls && A->get_class_obj && A->get_class_obj(g) != g_ghost.cls) return 0;
    n = A->name_of(g);
    if (!n || lstrcmpA(n, g_ghost.name) != 0) return 0;
    if (A->read_raw(g, O_ACTOR_FLAGS0, &f, 4) && (f & F_bDeleteMe)) return 0;
    return 1;
}

static void ghost_acquire(const CoopState *want) {
    float loc[3];
    int rot[3];
    unsigned now = GetTickCount();

    if (now - g_ghost.last_try_ms < 2000) return;
    g_ghost.last_try_ms = now;

    loc[0] = want->pos[0]; loc[1] = want->pos[1]; loc[2] = want->pos[2];
    rot[0] = 0; rot[1] = (int)(unsigned short)want->rot[1]; rot[2] = 0;

    if (g_ghost.mode == 3) {
        AObj b = ghost_adopt_body();
        if (!b) {
            if (++g_ghost.fails == 1) coop_log("coop: aucun AliceGameSkeletalMeshActorMAT dans ce niveau");
            return;
        }
        g_ghost.obj = b;
        g_ghost.adopted = 1;
        g_ghost.ready = 1;
        g_ghost.fails = 0;
        ghost_identity_capture(b);
        anim_reset();
        lstrcpynA(g_ghost.how, "corps adopte (MAT Alice)", sizeof g_ghost.how);
        coop_log("coop: corps adopte - %s", A->name_of(b));
        return;
    }

    if (!loc_sane(loc)) {
        if (!g_localPawn || !A->read_raw(g_localPawn, O_LOCATION, loc, 12)) {
            coop_log("coop: spawn reporte - position du pair inutilisable et pas de repli local");
            return;
        }
        loc[2] += 64.0f;
        coop_log("coop: position du pair inutilisable (%.0f %.0f %.0f), spawn au-dessus du pawn local",
                 want->pos[0], want->pos[1], want->pos[2]);
    } else if (g_worldInfo) {
        float killz = 0.0f;
        if (A->read_raw(g_worldInfo, O_WI_KILLZ, &killz, 4) && loc[2] < killz + 100.0f) {
            coop_log("coop: position du pair sous le KillZ (z=%.0f killz=%.0f), remontee", loc[2], killz);
            loc[2] = killz + 200.0f;
        }
    }

    {
        AObj g = ghost_spawn_pawn(want, loc, rot);
        if (!g) {
            g_ghost.fails++;
            if (g_ghost.fails >= 5) {
                coop_log("coop: 5 cascades sans succes, repli sur le corps adopte");
                g_ghost.mode = 3;
                g_ghost.fails = 0;
            }
            return;
        }
        g_ghost.obj = g;
        g_ghost.adopted = 0;
        g_ghost.fails = 0;
        g_ghost.pos[0] = loc[0]; g_ghost.pos[1] = loc[1]; g_ghost.pos[2] = loc[2];
        ghost_identity_capture(g);
        ghost_configure(g);
        g_ghost.ready = 1;
        anim_reset();
        wsprintfA(g_ghost.how, "AlicePawn spawne essai %d (%s)", g_spawnWin + 1,
                  g_ghost.mode == 0 ? "marche" : g_ghost.mode == 1 ? "vol" : "teleport");
        coop_log("coop: fantome cree - %s (%s) physique=%d", A->name_of(g), A->class_of(g),
                 g_ghost.mode == 0 ? 1 : g_ghost.mode == 1 ? 4 : 0);
    }
}

void ghost_forget_recipe(void) {
    g_spawnWin = -1;
    g_preflightLogged = 0;
}

void ghost_bump_adopt_index(void) {
    g_adoptSkip++;
    g_adoptCandidate = 0;
}

int ghost_valid(void) {
    return g_ghost.obj && ghost_identity_ok();
}

void ghost_drop(void) {
    g_hideApplied = 0;
    g_ghost.obj = 0;
    g_ghost.ready = 0;
    g_ghost.adopted = 0;
    g_ghost.stolen = 0;
    g_ghost.objIndex = 0;
    g_ghost.cls = 0;
    g_ghost.name[0] = 0;
    g_ghost.how[0] = 0;
    g_ghostMesh = 0;
}

void ghost_release(int quiet) {
    if (g_ghost.obj && !g_ghost.adopted && guard_obj_ok(g_ghost.obj) &&
        A->call_ready && A->call_ready()) {
        unsigned f = 0;
        if (A->read_raw(g_ghost.obj, O_ACTOR_FLAGS0, &f, 4)) {
            f |= F_bHidden;
            A->write_raw(g_ghost.obj, O_ACTOR_FLAGS0, &f, 4);
        }
        g_releasing = 1;
        A->destroy(g_ghost.obj);
        g_releasing = 0;
    }
    ghost_drop();
    if (!quiet) coop_log("coop: fantome relache");
}

int ghost_arm(int mode) {
    if (mode < 0 || mode > 4) return 0;
    if (g_ghost.obj) ghost_release(1);
    g_ghost.mode = mode;
    g_ghost.armed = (mode != 4);
    g_ghost.fails = 0;
    g_ghost.last_try_ms = 0;
    g_preflightLogged = 0;
    g_cfg.ghost_mode = mode;
    cfg_flush();
    coop_log("coop: fantome mode %d (%s)", mode,
             mode == 0 ? "AlicePawn marche" : mode == 1 ? "AlicePawn vol" :
             mode == 2 ? "AlicePawn teleport" : mode == 3 ? "corps adopte" : "plaque seule");
    return 1;
}

static void on_ghost_destroyed(AEvent *e) {
    if (!g_ghost.obj || e->self != g_ghost.obj) return;
    if (!g_releasing)
        coop_log("coop: le fantome a ete detruit par le jeu (%s), reacquisition", e->func_name);
    ghost_drop();
}

static void on_ghost_veto(AEvent *e) {
    if (!g_ghost.obj || g_ghost.adopted || e->self != g_ghost.obj) return;
    if (!ghost_identity_ok()) { ghost_drop(); return; }
    e->block = 1;
    coop_log_rate("coop: %s bloque sur le fantome", e->func_name);
}

static void on_ghost_anim_tree(AEvent *e) {
    if (!g_ghost.obj || e->self != g_ghost.obj) return;
    anim_reset();
}

void ghost_hooks_install(void) {
    A->on("Destroyed", on_ghost_destroyed);
    A->on("OutsideWorldBounds", on_ghost_veto);
    A->on("FellOutOfWorld", on_ghost_veto);
    A->on("Died", on_ghost_veto);
    A->on("TakeDamage", on_ghost_veto);
    A->on("Landed", on_ghost_veto);
    A->on("PostInitAnimTree", on_ghost_anim_tree);
}

static void ghost_guard_pointers(void) {
    AObj pc = g_localPC, mine = g_localPawn;
    void *p = 0;
    if (!pc || !mine) return;

    if (A->read_raw(pc, O_CTRL_PAWN, &p, 4) && p != mine) {
        A->write_raw(pc, O_CTRL_PAWN, &mine, 4);
        g_ghost.stolen++;
    }
    if (A->read_raw(pc, O_APC_MYALICEPAWN, &p, 4) && p != mine) {
        A->write_raw(pc, O_APC_MYALICEPAWN, &mine, 4);
        g_ghost.stolen++;
    }
    if (A->read_raw(mine, O_PAWN_CONTROLLER, &p, 4) && p != pc) {
        A->write_raw(mine, O_PAWN_CONTROLLER, &pc, 4);
        g_ghost.stolen++;
    }
    if (g_ghost.stolen > 60) {
        coop_log("coop: le fantome vole la partie, relache d'office");
        ghost_release(1);
        g_ghost.armed = 0;
    }
}

static void ghost_drive_accel(AObj g, const CoopState *want, const float wvel[3], float dt) {
    float cur[3], vel[3], err[3], acc[3], tv[3], e2, mag, rate = 2048.0f;
    int i, r[3];

    if (!A->read_raw(g, O_LOCATION, cur, 12)) return;
    if (!A->read_raw(g, O_VELOCITY, vel, 12)) { vel[0] = vel[1] = vel[2] = 0.0f; }
    A->read_raw(g, O_PAWN_ACCELRATE, &rate, 4);
    if (!(rate > 1.0f)) rate = 2048.0f;

    for (i = 0; i < 3; i++) err[i] = want->pos[i] - cur[i];
    e2 = err[0] * err[0] + err[1] * err[1] + err[2] * err[2];

    if (e2 > 250.0f * 250.0f) {
        A->write_raw(g, O_LOCATION, want->pos, 12);
        A->write_raw(g, O_VELOCITY, wvel, 12);
        cloth_mask_snap(want->pos);
    } else {
        float k = (e2 > 256.0f * 256.0f) ? 8.0f : (e2 > 64.0f * 64.0f) ? 4.0f : 2.0f;
        float step = dt > 0.001f ? dt : 0.016f;
        for (i = 0; i < 3; i++) tv[i] = wvel[i] + err[i] * k;
        for (i = 0; i < 3; i++) acc[i] = (tv[i] - vel[i]) / step;
        if (g_ghost.mode == 0) acc[2] = 0.0f;
        mag = sqrtf(acc[0] * acc[0] + acc[1] * acc[1]);
        if (mag > rate) { acc[0] *= rate / mag; acc[1] *= rate / mag; }
        A->write_raw(g, O_ACCELERATION, acc, 12);
    }
    r[0] = 0; r[1] = (int)(unsigned short)want->rot[1]; r[2] = 0;
    A->write_raw(g, O_ROTATION, r, 12);
    A->write_raw(g, O_PAWN_DESIREDROT, r, 12);
}

static void ghost_drive_teleport(AObj g, const CoopState *want, const float wvel[3]) {
    float feet[3];
    int r[3];
    feet[0] = want->pos[0];
    feet[1] = want->pos[1];
    feet[2] = want->pos[2];
    if (g_ghost.adopted) feet[2] += -(float)want->coll_height + g_cfg.z_adjust;
    A->write_raw(g, O_LOCATION, feet, 12);
    A->write_raw(g, O_VELOCITY, wvel, 12);
    cloth_mask_snap(feet);
    r[0] = 0; r[1] = (int)(unsigned short)want->rot[1]; r[2] = 0;
    A->write_raw(g, O_ROTATION, r, 12);
    if (!g_ghost.adopted) A->write_raw(g, O_PAWN_DESIREDROT, r, 12);
    g_ghost.pos[0] = feet[0]; g_ghost.pos[1] = feet[1]; g_ghost.pos[2] = feet[2];
}

void actor_set_physics(AObj a, int phys) {
    unsigned char cur = 0, want = (unsigned char)phys;
    ACall c;
    if (!a || phys < 0 || phys > 20) return;
    if (A->read_raw(a, O_PHYSICS, &cur, 1) && cur == want) return;
    c = A->call_begin(a, "SetPhysics");
    if (!c) return;
    A->call_arg_raw(c, "newPhysics", &want, 1);
    A->call_invoke(c);
    A->call_end(c);
}

void ghost_hide(int reason, int on) {
    if (on) g_hideMask |= reason;
    else    g_hideMask &= ~reason;
}

int ghost_hidden(void) { return g_hideMask; }

static void ghost_hide_apply(int want) {
    unsigned f;
    if (want == g_hideApplied) return;
    if (!g_ghost.obj || g_ghost.adopted) { g_hideApplied = want; return; }
    if (!A->read_raw(g_ghost.obj, O_ACTOR_FLAGS0, &f, 4)) return;
    if (want) f |= F_bHidden; else f &= ~F_bHidden;
    A->write_raw(g_ghost.obj, O_ACTOR_FLAGS0, &f, 4);
    g_hideApplied = want;
}

void ghost_frame(float dt, float render_t) {
    CoopState want;
    float wvel[3] = {0.0f, 0.0f, 0.0f};

    if (!g_ghost.armed || g_ghost.mode == 4) {
        if (g_ghost.obj) ghost_release(1);
        return;
    }
    if (!g_peerStateValid) return;
    if (g_ghost.obj && !ghost_identity_ok()) {
        ghost_drop();
        guard_note("le fantome n'existe plus, reacquisition");
        return;
    }
    if (g_ghost.obj) ghost_guard_pointers();
    if (!g_ghost.armed) return;
    if (g_hideMask) {
        ghost_hide_apply(1);
        return;
    }
    ghost_hide_apply(0);
    if (!g_ghost.obj) {
        if (!state_at(render_t, &want, wvel)) return;
        ghost_acquire(&want);
        return;
    }
    if (!state_at(render_t, &want, wvel)) return;

    if (g_ghost.adopted) {
        ghost_drive_teleport(g_ghost.obj, &want, wvel);
        anim_frame(&want, dt);
    } else {
        if (g_ghost.mode == 2) ghost_drive_teleport(g_ghost.obj, &want, wvel);
        else                   ghost_drive_accel(g_ghost.obj, &want, wvel, dt);
        state_apply(g_ghost.obj, &want);
        ghost_root_motion_off();
        anim_frame(&want, dt);
        A->read_raw(g_ghost.obj, O_LOCATION, g_ghost.pos, 12);
    }
}

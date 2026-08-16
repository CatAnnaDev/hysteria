#include "coop.h"

static AObj g_boundComp;
static AObj g_boundTree;
static AObj g_slot;
static AObj g_dyn0;
static AObj g_stateChain[8];
static int  g_chainN;
static int  g_animWarned;

void anim_reset(void) {
    g_boundComp = 0;
    g_boundTree = 0;
    g_slot = 0;
    g_dyn0 = 0;
    g_chainN = 0;
    g_animWarned = 0;
}

static AObj child_anim(AObj node, int index) {
    char *data = 0;
    int num = 0;
    AObj out = 0;
    if (!node) return 0;
    if (!A->read_raw(node, O_ABLEND_CHILDREN, &data, 4)) return 0;
    if (!A->read_raw(node, O_ABLEND_CHILDNUM, &num, 4)) return 0;
    if (index < 0 || index >= num || num > 64 || !data) return 0;
    if (!A->read_raw(data, index * ABCHILD_STRIDE + ABCHILD_ANIM, &out, 4)) return 0;
    return out;
}

static int anim_bind(AObj comp) {
    AObj tree = 0;
    if (!comp) return 0;
    if (!A->read_raw(comp, O_SKEL_ANIMATIONS, &tree, 4) || !tree) return 0;
    if (comp == g_boundComp && tree == g_boundTree && g_slot && g_dyn0) return 1;
    g_boundComp = comp;
    g_boundTree = tree;
    g_slot = 0;
    g_dyn0 = 0;
    g_chainN = 0;

    g_slot = child_anim(tree, 0);
    if (!g_slot) return 0;
    g_dyn0 = child_anim(g_slot, 1);

    {
        AObj perBone = child_anim(g_slot, 0);
        AObj stances = perBone ? child_anim(perBone, 0) : 0;
        AObj holdWatch = stances ? child_anim(stances, 0) : 0;
        AObj movement = holdWatch ? child_anim(holdWatch, 0) : 0;
        AObj weapon = movement ? child_anim(movement, 0) : 0;
        AObj london = weapon ? child_anim(weapon, 0) : 0;
        g_chainN = 0;
        if (stances)   g_stateChain[g_chainN++] = stances;
        if (holdWatch) g_stateChain[g_chainN++] = holdWatch;
        if (movement)  g_stateChain[g_chainN++] = movement;
        if (weapon)    g_stateChain[g_chainN++] = weapon;
        if (london)    g_stateChain[g_chainN++] = london;
    }
    return g_slot != 0;
}

static int node_child_count(AObj node) {
    int num = 0;
    if (!node || !A->read_raw(node, O_ABLEND_CHILDNUM, &num, 4)) return 0;
    return (num > 0 && num <= 64) ? num : 0;
}

static void node_force_child(AObj node, int index) {
    float zero = 0.0f;
    unsigned f;
    int num = node_child_count(node);
    if (!num) return;
    if (index < 0) index = 0;
    if (index >= num) index = num - 1;
    A->write_raw(node, O_AGBLEND_ACTIVE, &index, 4);
    A->write_raw(node, O_AGBLEND_BLENDTTG, &zero, 4);
    if (A->read_raw(node, O_AGBLEND_FLAGS2, &f, 4)) {
        f |= F_AGB_bPlayActiveChild | F_AGB_bSkipBlendWhenNotRendered;
        A->write_raw(node, O_AGBLEND_FLAGS2, &f, 4);
    }
}

static void anim_write_tree(const CoopState *s) {
    int stance = s->blkA[0];
    int movement = s->blkA[4];
    int inLondon = (s->bits & (1u << 3)) ? 1 : 0;
    int holdWatch = (s->bits & (1u << 17)) ? 1 : 0;
    int idx[5];

    if (g_chainN < 3) return;

    idx[0] = stance;
    idx[1] = holdWatch;
    idx[2] = movement;
    idx[3] = s->weapon_type;
    idx[4] = inLondon;

    {
        int i;
        for (i = 0; i < g_chainN && i < 5; i++) node_force_child(g_stateChain[i], idx[i]);
    }
}

static int seq_from_local(unsigned name[2], AObj *seq, int *linkup) {
    AObj mine = g_localPawn ? A->get_obj(g_localPawn, "Mesh") : 0;
    AObj tree, slot, node;
    if (!mine) return 0;
    if (!A->read_raw(mine, O_SKEL_ANIMATIONS, &tree, 4) || !tree) return 0;
    slot = child_anim(tree, 0);
    node = slot ? child_anim(slot, 1) : 0;
    if (!node) return 0;
    if (!A->read_raw(node, O_ASEQ_ANIMSEQ, seq, 4) || !*seq) return 0;
    if (!A->read_raw(node, O_ASEQ_LINKUP, linkup, 4)) return 0;
    if (!A->read_raw(*seq, O_ANIMSEQ_NAME, name, 8)) return 0;
    return 1;
}

static void anim_slot_play(float time, float rate, int loop) {
    unsigned name[2], bits;
    AObj seq = 0;
    int linkup = 0, one = 1;
    float zero = 0.0f;

    if (!g_dyn0 || !g_slot) return;
    if (!seq_from_local(name, &seq, &linkup)) return;

    A->write_raw(g_dyn0, O_ASEQ_NAME, name, 8);
    A->write_raw(g_dyn0, O_ASEQ_RATE, &rate, 4);
    if (A->read_raw(g_dyn0, O_ASEQ_FLAGS, &bits, 4)) {
        bits |= F_ASEQ_bPlaying | F_ASEQ_bNoNotifies;
        if (loop) bits |= F_ASEQ_bLooping; else bits &= ~F_ASEQ_bLooping;
        bits &= ~(F_ASEQ_bCauseActorAnimEnd | F_ASEQ_bCauseActorAnimPlay);
        A->write_raw(g_dyn0, O_ASEQ_FLAGS, &bits, 4);
    }
    A->write_raw(g_dyn0, O_ASEQ_CURTIME, &time, 4);
    A->write_raw(g_dyn0, O_ASEQ_PREVTIME, &time, 4);
    A->write_raw(g_dyn0, O_ASEQ_ANIMSEQ, &seq, 4);
    A->write_raw(g_dyn0, O_ASEQ_LINKUP, &linkup, 4);

    A->write_raw(g_slot, O_AGBLEND_ACTIVE, &one, 4);
    A->write_raw(g_slot, O_AGBLEND_BLENDTTG, &zero, 4);
    A->write_raw(g_slot, O_AGBLEND_CURDYN, &one, 4);
    if (A->read_raw(g_slot, O_AGBLEND_FLAGS2, &bits, 4)) {
        bits |= F_AGB_bPlayActiveChild | F_AGB_bSkipBlendWhenNotRendered;
        A->write_raw(g_slot, O_AGBLEND_FLAGS2, &bits, 4);
    }
    if (A->read_raw(g_slot, O_AGBLEND_FLAGS, &bits, 4)) {
        bits |= F_AGB_bIsPlayingCustomAnim;
        A->write_raw(g_slot, O_AGBLEND_FLAGS, &bits, 4);
    }
}

void anim_frame(const CoopState *s, float dt) {
    static float airTime;
    AObj comp;
    int jump = s->blkA[6];

    if (!g_ghost.obj || !s) return;
    comp = A->get_obj(g_ghost.obj, "SkeletalMeshComponent");
    if (!comp) comp = A->get_obj(g_ghost.obj, "Mesh");
    if (!comp) {
        if (!g_animWarned) { g_animWarned = 1; guard_note("corps sans composant a squelette"); }
        return;
    }
    if (!anim_bind(comp)) {
        if (!g_animWarned) { g_animWarned = 1; guard_note("arbre d'animation du corps introuvable"); }
        return;
    }

    if (g_ghost.adopted) anim_write_tree(s);

    if (jump >= 1 && jump <= 4) {
        airTime += dt;
        anim_slot_play(airTime, 1.0f, 0);
    } else {
        airTime = 0.0f;
        {
            int zero = 0;
            float z = 0.0f;
            unsigned bits;
            A->write_raw(g_slot, O_AGBLEND_ACTIVE, &zero, 4);
            A->write_raw(g_slot, O_AGBLEND_BLENDTTG, &z, 4);
            if (A->read_raw(g_slot, O_AGBLEND_FLAGS, &bits, 4)) {
                bits &= ~F_AGB_bIsPlayingCustomAnim;
                A->write_raw(g_slot, O_AGBLEND_FLAGS, &bits, 4);
            }
        }
    }
}

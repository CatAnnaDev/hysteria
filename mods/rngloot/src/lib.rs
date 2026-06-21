mod hysteria;
mod hysteria_api;
use hysteria::*;
use std::cell::UnsafeCell;

struct G<T>(UnsafeCell<T>);
unsafe impl<T> Sync for G<T> {}
impl<T> G<T> {
    fn get(&self) -> &mut T {
        unsafe { &mut *self.0.get() }
    }
}

struct State {
    loot_on: bool,
    type_on: bool,
    dmg_on: bool,
    enemy_on: bool,
    chaos_spawn: bool, // EXPERIMENTAL: loot -> random mob (deferred, may be unstable)
    chaos: f32,
    bust: f32,
    jackpot: f32,
    type_swap: f32,
    dmg_chaos: f32,
    crit: f32,
    enemy_hp: f32,
    size_on: bool,
    size_min: f32,
    size_max: f32,
    hyst_on: bool,
    hyst_min: f32,
    hyst_max: f32,
    hyst_base: f32,
    hyst_was: bool,
    espeed_on: bool,
    speed_on: bool,
    speed_min: f32,
    speed_max: f32,
    speed_dirty: bool,
    jump_on: bool,
    psize_on: bool,
    grav_on: bool,
    grav_dirty: bool,
    base_grav: f32,
    knock_on: bool,
    magnet_on: bool,
    magnet_frames: u32,
    panic: bool,
    panic_was: bool,
    chaos_secs: f32,
    chaos_frames: u32,
    base_jump: f32,
    base_psize: f32,
    seed: i32,
    last_seed: i32,
    rng: u32,
    diag: bool,
    queue: Vec<[f32; 3]>, // pending spawn locations (drained in on_tick, NOT in the hook)
}
static ST: G<State> = G(UnsafeCell::new(State {
    loot_on: true,
    type_on: true,
    dmg_on: true,
    enemy_on: true,
    chaos_spawn: false,
    chaos: 4.0,
    bust: 0.10,
    jackpot: 0.05,
    type_swap: 0.30,
    dmg_chaos: 2.0,
    crit: 0.10,
    enemy_hp: 2.5,
    size_on: false,
    size_min: 1.0,
    size_max: 2.0,
    hyst_on: true,
    hyst_min: 0.5,
    hyst_max: 2.0,
    hyst_base: 0.0,
    hyst_was: false,
    espeed_on: true,
    speed_on: false,
    speed_min: 0.6,
    speed_max: 1.6,
    speed_dirty: false,
    jump_on: false,
    psize_on: false,
    grav_on: false,
    grav_dirty: false,
    base_grav: 0.0,
    knock_on: true,
    magnet_on: false,
    magnet_frames: 0,
    panic: false,
    panic_was: false,
    chaos_secs: 4.0,
    chaos_frames: 0,
    base_jump: 0.0,
    base_psize: 0.0,
    seed: 0,
    last_seed: -1,
    rng: 0x1234567,
    diag: false,
    queue: Vec::new(),
}));

const SPAWN_CLASSES: &[&str] = &[
    "AliceGameMadcapPawn",
    "AliceGameBitchBabyPawn",
    "AliceGameDollBoyPawn",
    "AliceGameDollGirlPawn",
    "AliceGameLostSoulPawn",
    "AliceGameKynapsePawn",
    "AliceGameSamuraiWaspPawn",
    "AliceGameCannonCrabPawn",
    "AliceGameIceSnarkPawn",
];

fn reseed_if_needed(entropy: u32) {
    let s = ST.get();
    if s.seed != s.last_seed {
        s.rng = if s.seed > 0 {
            (s.seed as u32).wrapping_mul(2654435761).max(1)
        } else {
            entropy | 1
        };
        s.last_seed = s.seed;
    }
}
fn rng() -> u32 {
    let s = ST.get();
    s.rng ^= s.rng << 13;
    s.rng ^= s.rng >> 17;
    s.rng ^= s.rng << 5;
    s.rng
}
fn rngf() -> f32 {
    (rng() & 0xffffff) as f32 / 0x1000000 as f32
}

fn roll_amount(v: i32) -> i32 {
    if v <= 0 {
        return v;
    }
    let s = ST.get();
    let r = rngf();
    if r < s.bust {
        return 0;
    }
    if r > 1.0 - s.jackpot {
        return v * 10;
    }
    let out = (v as f32 * rngf() * s.chaos) as i32;
    if out < 1 {
        1
    } else {
        out
    }
}

const XP_FIELDS: &[&str] = &["nXPValue", "nXP", "nSmallXP", "nLargeXP", "nManualXPAmount"];
const HP_FIELDS: &[&str] = &["nHPValue", "nHP", "nSmallHP", "nLargeHP", "nManualHPAmount"];

fn on_loot(e: &Event) {
    let s = ST.get();
    // EXPERIMENTAL chaos spawn: suppress loot, queue a spawn for next frame (never spawn inside the hook)
    if s.chaos_spawn {
        for f in XP_FIELDS.iter().chain(HP_FIELDS).chain(["Count"].iter()) {
            if e.get_int(f).is_some() {
                e.set_int(f, 0);
            }
        }
        let loc = get_vec(e.this(), "Location").or_else(|| get_vec(player_pawn(), "Location"));
        if let Some(l) = loc {
            if s.queue.len() < 64 {
                s.queue.push(l);
            }
        }
        return;
    }
    if !s.loot_on {
        return;
    }
    if s.type_on && rngf() < s.type_swap {
        let to_hp = rngf() < 0.5;
        let (src, dst) = if to_hp {
            ("nXPValue", "nHPValue")
        } else {
            ("nHPValue", "nXPValue")
        };
        if let Some(v) = e.get_int(src) {
            if v > 0 {
                let cur = e.get_int(dst).unwrap_or(0);
                e.set_int(dst, cur + v);
                e.set_int(src, 0);
            }
        }
    }
    let mut touched = 0;
    for f in XP_FIELDS.iter().chain(HP_FIELDS).chain(["Count"].iter()) {
        if let Some(v) = e.get_int(f) {
            if v > 0 {
                e.set_int(f, roll_amount(v));
                touched += 1;
            }
        }
    }
    if !s.diag && touched > 0 {
        s.diag = true;
        log(&format!(
            "rng: loot '{}' randomized ({} fields)",
            e.name(),
            touched
        ));
    }
}

fn on_damage(e: &Event) {
    let s = ST.get();
    if !s.dmg_on {
        return;
    }
    for f in ["DamageAmount", "Damage", "DamageValue"] {
        if let Some(v) = e.get_int(f) {
            if v > 0 {
                let mut nv = (v as f32 * (0.25 + rngf() * s.dmg_chaos)) as i32;
                if rngf() < s.crit {
                    nv *= 3;
                }
                if nv < 1 {
                    nv = 1;
                }
                e.set_int(f, nv);
            }
        }
    }
}

fn on_init(e: &Event) {
    let s = ST.get();
    if !s.enemy_on && !s.size_on {
        return;
    }
    let who = e.this();
    if who.is_null() || who == player_pawn() || !is_a(who, "Pawn") {
        return;
    }
    if s.enemy_on {
        if let Some(hp) = get_int(who, "Health") {
            if hp > 0 {
                let nh = (((hp as f32) * (0.4 + rngf() * s.enemy_hp)) as i32).max(1);
                set_int(who, "Health", nh);
                set_int(who, "HealthMax", nh);
            }
        }
    }
    if s.size_on {
        let base = get_float(who, "DrawScale")
            .filter(|v| *v > 0.0)
            .unwrap_or(1.0);
        let lo = s.size_min.min(s.size_max);
        let hi = s.size_min.max(s.size_max);
        let factor = if hi > lo { lo + rngf() * (hi - lo) } else { lo };
        set_float(who, "DrawScale", base * factor);
    }
    if s.espeed_on {
        if let Some(gs) = get_float(who, "GroundSpeed") {
            if gs > 0.0 {
                let f = 0.5 + rngf() * 1.5;
                set_float(who, "GroundSpeed", gs * f);
                if let Some(js) = get_float(who, "JumpZ") {
                    if js > 0.0 {
                        set_float(who, "JumpZ", js * f);
                    }
                }
            }
        }
    }
    if s.knock_on {
        set_float(who, "KnockBackScale", 0.5 + rngf() * 4.0);
    }
}

fn hyst_tick() {
    let s = ST.get();
    if !s.hyst_on {
        return;
    }
    let p = player_pawn();
    if is_null(p) {
        return;
    }
    if s.hyst_base <= 0.0 {
        if let Some(d) = get_float(p, "HysteriaDuration") {
            if d > 0.0 {
                s.hyst_base = d;
            }
        }
    }
    let now = get_float(p, "HysteriaLeftTime").unwrap_or(0.0) > 0.05;
    if now && !s.hyst_was {
        let base = if s.hyst_base > 0.0 { s.hyst_base } else { 10.0 };
        let lo = s.hyst_min.min(s.hyst_max);
        let hi = s.hyst_min.max(s.hyst_max);
        let factor = if hi > lo { lo + rngf() * (hi - lo) } else { lo };
        let dur = (base * factor).max(0.5);
        set_float(p, "HysteriaDuration", dur);
        set_float(p, "HysteriaLeftTime", dur);
        log(&format!("rng: hysteria {:.1}s (x{:.2})", dur, factor));
    }
    s.hyst_was = now;
}

fn magnet_tick() {
    let s = ST.get();
    if !s.magnet_on {
        return;
    }
    s.magnet_frames = s.magnet_frames.wrapping_add(1);
    if s.magnet_frames % 20 != 0 {
        return;
    }
    let p = player_pawn();
    if is_null(p) {
        return;
    }
    let pl = match get_vec(p, "Location") {
        Some(v) => v,
        None => return,
    };
    for o in all_of_class("PickupFactory") {
        if is_null(o) {
            continue;
        }
        if let Some(loc) = get_vec(o, "Location") {
            let d = [pl[0] - loc[0], pl[1] - loc[1], pl[2] - loc[2]];
            let dist2 = d[0] * d[0] + d[1] * d[1] + d[2] * d[2];
            if dist2 > 100.0 && dist2 < 1100.0 * 1100.0 {
                set_vec(
                    o,
                    "Location",
                    [
                        loc[0] + d[0] * 0.3,
                        loc[1] + d[1] * 0.3,
                        loc[2] + d[2] * 0.3,
                    ],
                );
            }
        }
    }
}

fn chaos_tick() {
    let s = ST.get();
    if s.panic && !s.panic_was {
        s.loot_on = true;
        s.type_on = true;
        s.dmg_on = true;
        s.enemy_on = true;
        s.size_on = true;
        s.espeed_on = true;
        s.speed_on = true;
        s.jump_on = true;
        s.psize_on = true;
        s.grav_on = true;
        s.knock_on = true;
        s.magnet_on = true;
    }
    if !s.panic && s.panic_was {
        s.speed_on = false;
        s.jump_on = false;
        s.psize_on = false;
        s.grav_on = false;
        s.magnet_on = false;
    }
    s.panic_was = s.panic;
    s.chaos_frames = s.chaos_frames.wrapping_add(1);
    let period = (s.chaos_secs.max(0.5) * 60.0) as u32;
    let reroll = s.chaos_frames % period.max(1) == 0;

    if s.speed_on {
        if reroll {
            let w = world_info();
            if !is_null(w) {
                let lo = s.speed_min.min(s.speed_max);
                let hi = s.speed_min.max(s.speed_max);
                set_float(w, "TimeDilation", lo + rngf() * (hi - lo));
                s.speed_dirty = true;
            }
        }
    } else if s.speed_dirty {
        let w = world_info();
        if !is_null(w) {
            set_float(w, "TimeDilation", 1.0);
        }
        s.speed_dirty = false;
    }

    {
        let w = world_info();
        if !is_null(w) {
            if s.base_grav.abs() < 1.0 {
                if let Some(g) = get_float(w, "WorldGravityZ") {
                    if g.abs() > 1.0 {
                        s.base_grav = g;
                    }
                }
            }
            if s.grav_on && reroll && s.base_grav.abs() > 1.0 {
                set_float(w, "WorldGravityZ", s.base_grav * (0.2 + rngf() * 1.1));
                s.grav_dirty = true;
            } else if !s.grav_on && s.grav_dirty && s.base_grav.abs() > 1.0 {
                set_float(w, "WorldGravityZ", s.base_grav);
                s.grav_dirty = false;
            }
        }
    }

    let p = player_pawn();
    if is_null(p) {
        return;
    }
    if s.base_jump <= 0.0 {
        s.base_jump = get_float(p, "JumpZ").unwrap_or(0.0);
    }
    if s.base_psize <= 0.0 {
        s.base_psize = get_float(p, "DrawScale")
            .filter(|v| *v > 0.0)
            .unwrap_or(1.0);
    }
    if reroll {
        if s.base_jump > 0.0 {
            let v = if s.jump_on {
                s.base_jump * (0.7 + rngf() * 2.0)
            } else {
                s.base_jump
            };
            set_float(p, "JumpZ", v);
        }
        if s.base_psize > 0.0 {
            let v = if s.psize_on {
                s.base_psize * (0.55 + rngf() * 1.1)
            } else {
                s.base_psize
            };
            set_float(p, "DrawScale", v);
        }
    }
}

fn spawn_tick() {
    let s = ST.get();
    // drain queued spawns OUTSIDE any ProcessEvent hook (avoids re-entrancy crash)
    if let Some(l) = s.queue.pop() {
        let c = SPAWN_CLASSES[(rng() as usize) % SPAWN_CLASSES.len()];
        let off = [(rngf() - 0.5) * 120.0, (rngf() - 0.5) * 120.0, 60.0];
        let o = spawn(c, l[0] + off[0], l[1] + off[1], l[2] + off[2]);
        if !s.diag {
            s.diag = true;
            log(&format!("rng: deferred spawn '{}' ok={}", c, !is_null(o)));
        }
    }
}

const M: &str = "rngloot";
fn cfg_load() {
    let s = ST.get();
    s.loot_on = cfg_get_bool(M, "loot_on", s.loot_on);
    s.chaos = cfg_get_float(M, "chaos", s.chaos);
    s.bust = cfg_get_float(M, "bust", s.bust);
    s.jackpot = cfg_get_float(M, "jackpot", s.jackpot);
    s.type_on = cfg_get_bool(M, "type_on", s.type_on);
    s.type_swap = cfg_get_float(M, "type_swap", s.type_swap);
    s.dmg_on = cfg_get_bool(M, "dmg_on", s.dmg_on);
    s.dmg_chaos = cfg_get_float(M, "dmg_chaos", s.dmg_chaos);
    s.crit = cfg_get_float(M, "crit", s.crit);
    s.enemy_on = cfg_get_bool(M, "enemy_on", s.enemy_on);
    s.enemy_hp = cfg_get_float(M, "enemy_hp", s.enemy_hp);
    s.size_on = cfg_get_bool(M, "size_on", s.size_on);
    s.size_min = cfg_get_float(M, "size_min", s.size_min);
    s.size_max = cfg_get_float(M, "size_max", s.size_max);
    s.hyst_on = cfg_get_bool(M, "hyst_on", s.hyst_on);
    s.hyst_min = cfg_get_float(M, "hyst_min", s.hyst_min);
    s.hyst_max = cfg_get_float(M, "hyst_max", s.hyst_max);
    s.espeed_on = cfg_get_bool(M, "espeed_on", s.espeed_on);
    s.speed_on = cfg_get_bool(M, "speed_on", s.speed_on);
    s.speed_min = cfg_get_float(M, "speed_min", s.speed_min);
    s.speed_max = cfg_get_float(M, "speed_max", s.speed_max);
    s.jump_on = cfg_get_bool(M, "jump_on", s.jump_on);
    s.psize_on = cfg_get_bool(M, "psize_on", s.psize_on);
    s.grav_on = cfg_get_bool(M, "grav_on", s.grav_on);
    s.knock_on = cfg_get_bool(M, "knock_on", s.knock_on);
    s.magnet_on = cfg_get_bool(M, "magnet_on", s.magnet_on);
    s.chaos_spawn = cfg_get_bool(M, "chaos_spawn", s.chaos_spawn);
    s.chaos_secs = cfg_get_float(M, "chaos_secs", s.chaos_secs);
    s.seed = cfg_get_int(M, "seed", s.seed);
}
fn cfg_store() {
    let s = ST.get();
    cfg_set_bool(M, "loot_on", s.loot_on);
    cfg_set_float(M, "chaos", s.chaos);
    cfg_set_float(M, "bust", s.bust);
    cfg_set_float(M, "jackpot", s.jackpot);
    cfg_set_bool(M, "type_on", s.type_on);
    cfg_set_float(M, "type_swap", s.type_swap);
    cfg_set_bool(M, "dmg_on", s.dmg_on);
    cfg_set_float(M, "dmg_chaos", s.dmg_chaos);
    cfg_set_float(M, "crit", s.crit);
    cfg_set_bool(M, "enemy_on", s.enemy_on);
    cfg_set_float(M, "enemy_hp", s.enemy_hp);
    cfg_set_bool(M, "size_on", s.size_on);
    cfg_set_float(M, "size_min", s.size_min);
    cfg_set_float(M, "size_max", s.size_max);
    cfg_set_bool(M, "hyst_on", s.hyst_on);
    cfg_set_float(M, "hyst_min", s.hyst_min);
    cfg_set_float(M, "hyst_max", s.hyst_max);
    cfg_set_bool(M, "espeed_on", s.espeed_on);
    cfg_set_bool(M, "speed_on", s.speed_on);
    cfg_set_float(M, "speed_min", s.speed_min);
    cfg_set_float(M, "speed_max", s.speed_max);
    cfg_set_bool(M, "jump_on", s.jump_on);
    cfg_set_bool(M, "psize_on", s.psize_on);
    cfg_set_bool(M, "grav_on", s.grav_on);
    cfg_set_bool(M, "knock_on", s.knock_on);
    cfg_set_bool(M, "magnet_on", s.magnet_on);
    cfg_set_bool(M, "chaos_spawn", s.chaos_spawn);
    cfg_set_float(M, "chaos_secs", s.chaos_secs);
    cfg_set_int(M, "seed", s.seed);
    cfg_save(M);
}

fn panel() {
    let s = ST.get();
    ui_label("== Chaos spawn (EXPERIMENTAL) ==");
    ui_checkbox("Loot -> random mob (may crash)", &mut s.chaos_spawn);
    ui_label("== Loot ==");
    ui_checkbox("Loot amount RNG", &mut s.loot_on);
    ui_slider_float("  chaos (max x)", &mut s.chaos, 1.0, 20.0, 0.5);
    ui_slider_float("  bust chance", &mut s.bust, 0.0, 0.5, 0.01);
    ui_slider_float("  jackpot (x10)", &mut s.jackpot, 0.0, 0.3, 0.01);
    ui_checkbox("Loot type RNG (teeth<->roses)", &mut s.type_on);
    ui_slider_float("  swap chance", &mut s.type_swap, 0.0, 1.0, 0.05);
    ui_label("== Damage ==");
    ui_checkbox("Damage RNG", &mut s.dmg_on);
    ui_slider_float("  dmg chaos", &mut s.dmg_chaos, 0.5, 6.0, 0.1);
    ui_slider_float("  crit (x3) chance", &mut s.crit, 0.0, 0.5, 0.01);
    ui_label("== Enemies ==");
    ui_checkbox("Enemy HP RNG", &mut s.enemy_on);
    ui_slider_float("  HP chaos", &mut s.enemy_hp, 0.5, 6.0, 0.1);
    ui_checkbox("Enemy size RNG (x normal)", &mut s.size_on);
    ui_slider_float("  size x min", &mut s.size_min, 1.0, 3.0, 0.1);
    ui_slider_float("  size x max", &mut s.size_max, 1.0, 3.0, 0.1);
    ui_label("== Hysteria time ==");
    ui_checkbox("Hysteria duration RNG (x normal)", &mut s.hyst_on);
    ui_slider_float("  hyst x min", &mut s.hyst_min, 0.2, 3.0, 0.1);
    ui_slider_float("  hyst x max", &mut s.hyst_max, 0.2, 3.0, 0.1);
    ui_label("== Chaos (fun) ==");
    ui_checkbox("Enemy speed RNG", &mut s.espeed_on);
    ui_checkbox("Game speed RNG (slow-mo / turbo)", &mut s.speed_on);
    ui_slider_float("  game speed min", &mut s.speed_min, 0.3, 1.0, 0.05);
    ui_slider_float("  game speed max", &mut s.speed_max, 1.0, 3.0, 0.05);
    ui_checkbox("Alice jump RNG (moon jumps)", &mut s.jump_on);
    ui_checkbox("Alice size RNG", &mut s.psize_on);
    ui_checkbox("Gravity RNG (floaty / heavy)", &mut s.grav_on);
    ui_checkbox("Enemy knockback RNG (ragdoll)", &mut s.knock_on);
    ui_checkbox("Loot magnet (experimental)", &mut s.magnet_on);
    ui_slider_float("  chaos re-roll secs", &mut s.chaos_secs, 1.0, 15.0, 0.5);
    ui_label("== !! PANIC !! ==");
    ui_checkbox("PANIC MODE (everything at once)", &mut s.panic);
    ui_label("== Seed (0 = random) ==");
    ui_slider_int("  seed", &mut s.seed, 0, 999999);
    cfg_store();
}

#[no_mangle]
pub extern "C" fn ModMain(api: *const hysteria_api::HysteriaAPI) {
    hysteria::init(api);
    cfg_load();
    let entropy = (api as usize as u32) | 1;
    reseed_if_needed(entropy);
    log("rng mod loaded (Rust) — loot / damage / enemy HP+size / seed");
    on("DropPickupsForNPC", move |e| {
        reseed_if_needed(entropy);
        on_loot(e)
    });
    on("DropPickupsForGBA", move |e| {
        reseed_if_needed(entropy);
        on_loot(e)
    });
    on("TakeDamage", move |e| on_damage(e));
    on("PostBeginPlay", move |e| on_init(e));
    on_tick(spawn_tick);
    on_tick(hyst_tick);
    on_tick(chaos_tick);
    on_tick(magnet_tick);
    ui_panel("RNG", panel);
}

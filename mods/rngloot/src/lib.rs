mod hysteria;
mod hysteria_api;
use hysteria::*;
use std::cell::UnsafeCell;

struct G<T>(UnsafeCell<T>);
unsafe impl<T> Sync for G<T> {}
impl<T> G<T> {
    fn get(&self) -> &mut T { unsafe { &mut *self.0.get() } }
}

struct State {
    loot_on: bool,
    type_on: bool,
    dmg_on: bool,
    enemy_on: bool,
    chaos: f32,        // loot amount max multiplier
    bust: f32,         // loot: chance of nothing
    jackpot: f32,      // loot: chance of x10
    type_swap: f32,    // loot: chance teeth<->roses get redistributed
    dmg_chaos: f32,    // damage max multiplier
    crit: f32,         // damage: chance of x3 crit
    enemy_hp: f32,     // enemy HP max multiplier
    seed: i32,         // 0 = random each launch; >0 = fixed/shareable
    last_seed: i32,
    rng: u32,
    diag: bool,
}
static ST: G<State> = G(UnsafeCell::new(State {
    loot_on: true, type_on: true, dmg_on: true, enemy_on: true,
    chaos: 4.0, bust: 0.10, jackpot: 0.05, type_swap: 0.30,
    dmg_chaos: 2.0, crit: 0.10, enemy_hp: 2.5,
    seed: 0, last_seed: -1, rng: 0x1234567, diag: false,
}));

fn reseed_if_needed(api_entropy: u32) {
    let s = ST.get();
    if s.seed != s.last_seed {
        s.rng = if s.seed > 0 { (s.seed as u32).wrapping_mul(2654435761).max(1) } else { api_entropy | 1 };
        s.last_seed = s.seed;
    }
}
fn rng() -> u32 {
    let s = ST.get();
    s.rng ^= s.rng << 13; s.rng ^= s.rng >> 17; s.rng ^= s.rng << 5; s.rng
}
fn rngf() -> f32 { (rng() & 0xffffff) as f32 / 0x1000000 as f32 }

fn roll_amount(v: i32) -> i32 {
    if v <= 0 { return v; }
    let s = ST.get();
    let r = rngf();
    if r < s.bust { return 0; }
    if r > 1.0 - s.jackpot { return v * 10; }
    let out = (v as f32 * rngf() * s.chaos) as i32;
    if out < 1 { 1 } else { out }
}

const XP_FIELDS: &[&str] = &["nXPValue", "nXP", "nSmallXP", "nLargeXP", "nManualXPAmount"];
const HP_FIELDS: &[&str] = &["nHPValue", "nHP", "nSmallHP", "nLargeHP", "nManualHPAmount"];

fn on_loot(e: &Event) {
    let s = ST.get();
    if !s.loot_on { return; }
    // optional loot-type randomization: redistribute teeth <-> roses
    if s.type_on && rngf() < s.type_swap {
        // redistribute teeth <-> roses: move one total into the other
        let to_hp = rngf() < 0.5;
        let (src, dst) = if to_hp { ("nXPValue", "nHPValue") } else { ("nHPValue", "nXPValue") };
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
            if v > 0 { e.set_int(f, roll_amount(v)); touched += 1; }
        }
    }
    if !s.diag && touched > 0 {
        s.diag = true;
        log(&format!("rng: loot '{}' randomized ({} fields)", e.name(), touched));
    }
}

fn on_damage(e: &Event) {
    let s = ST.get();
    if !s.dmg_on { return; }
    for f in ["DamageAmount", "Damage", "DamageValue"] {
        if let Some(v) = e.get_int(f) {
            if v > 0 {
                let mut nv = (v as f32 * (0.25 + rngf() * s.dmg_chaos)) as i32;
                if rngf() < s.crit { nv *= 3; }
                if nv < 1 { nv = 1; }
                e.set_int(f, nv);
            }
        }
    }
}

fn on_init(e: &Event) {
    let s = ST.get();
    if !s.enemy_on { return; }
    let who = e.this();
    if who.is_null() || who == player_pawn() { return; }
    if !is_a(who, "Pawn") { return; }
    if let Some(hp) = get_int(who, "Health") {
        if hp > 0 {
            let m = 0.4 + rngf() * s.enemy_hp;
            let nh = ((hp as f32) * m) as i32;
            let nh = if nh < 1 { 1 } else { nh };
            set_int(who, "Health", nh);
            set_int(who, "HealthMax", nh);
        }
    }
}

fn panel() {
    let s = ST.get();
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
    ui_label("== Seed (0 = random) ==");
    ui_slider_int("  seed", &mut s.seed, 0, 999999);
    ui_label("share the seed to replay the same RNG");
}

#[no_mangle]
pub extern "C" fn ModMain(api: *const hysteria_api::HysteriaAPI) {
    hysteria::init(api);
    let entropy = (api as usize as u32) | 1;
    reseed_if_needed(entropy);
    log("rng mod loaded (Rust) — loot / damage / enemies / seed");
    on("DropPickupsForNPC", move |e| { reseed_if_needed(entropy); on_loot(e) });
    on("DropPickupsForGBA", move |e| { reseed_if_needed(entropy); on_loot(e) });
    on("SpawnPickups", move |e| on_loot(e));
    on("TakeDamage", move |e| on_damage(e));
    on("PostBeginPlay", move |e| on_init(e));
    ui_panel("RNG", panel);
}

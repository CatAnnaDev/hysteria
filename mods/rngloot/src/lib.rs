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
    enabled: bool,
    chaos: f32,
    bust: f32,
    jackpot: f32,
    seed: u32,
    diag: bool,
}
static ST: G<State> = G(UnsafeCell::new(State {
    enabled: true,
    chaos: 4.0,
    bust: 0.10,
    jackpot: 0.05,
    seed: 0x1234567,
    diag: false,
}));

fn rng() -> u32 {
    let s = ST.get();
    s.seed ^= s.seed << 13;
    s.seed ^= s.seed >> 17;
    s.seed ^= s.seed << 5;
    s.seed
}
fn rngf() -> f32 { (rng() & 0xffffff) as f32 / 0x1000000 as f32 }

fn roll(v: i32) -> i32 {
    if v <= 0 { return v; }
    let s = ST.get();
    let r = rngf();
    if r < s.bust { return 0; }
    if r > 1.0 - s.jackpot { return v * 10; }
    let out = (v as f32 * rngf() * s.chaos) as i32;
    if out < 1 { 1 } else { out }
}

const FIELDS: &[&str] = &[
    "nXPValue", "nHPValue", "nXP", "nHP",
    "nSmallXP", "nLargeXP", "nSmallHP", "nLargeHP",
    "nManualXPAmount", "nManualHPAmount", "Count",
];

fn randomize(e: &Event) {
    if !ST.get().enabled { return; }
    let mut touched = 0;
    for f in FIELDS {
        if let Some(v) = e.get_int(f) {
            if v > 0 { e.set_int(f, roll(v)); touched += 1; }
        }
    }
    if !ST.get().diag && touched > 0 {
        ST.get().diag = true;
        log(&format!("rngloot: '{}' intercepted ({} loot fields randomized)", e.name(), touched));
    }
}

#[no_mangle]
pub extern "C" fn ModMain(api: *const hysteria_api::HysteriaAPI) {
    hysteria::init(api);
    ST.get().seed = (api as usize as u32) | 1; // ASLR-derived entropy
    log("rngloot mod loaded (Rust)");
    on("DropPickupsForNPC", |e| randomize(e)); // mob loot
    on("DropPickupsForGBA", |e| randomize(e)); // box / breakable loot
    on("SpawnPickups", |e| randomize(e));      // low-level spawner
    ui_panel("RNG Loot", || {
        let s = ST.get();
        ui_checkbox("RNG loot enabled", &mut s.enabled);
        ui_slider_float("Chaos (max x)", &mut s.chaos, 1.0, 20.0, 0.5);
        ui_slider_float("Bust chance", &mut s.bust, 0.0, 0.5, 0.01);
        ui_slider_float("Jackpot (x10) chance", &mut s.jackpot, 0.0, 0.3, 0.01);
        ui_label("Randomizes teeth/roses from mobs + boxes.");
    });
}

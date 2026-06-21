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
    on: bool,
    cap: f32,
    uncap: bool,
    applied: bool,
    warned: bool,
    tick: u32,
    eng: Obj,
}
static ST: G<State> = G(UnsafeCell::new(State {
    on: true, cap: 120.0, uncap: true, applied: false, warned: false, tick: 0, eng: std::ptr::null_mut(),
}));

fn find_engine() -> Obj {
    // skip the Class Default Object (Default__*) — writing to it does nothing to the live engine
    for o in all_of_class("Engine") {
        if is_null(o) { continue; }
        if name_of(o).starts_with("Default__") { continue; }
        return o;
    }
    std::ptr::null_mut()
}

fn apply() {
    let s = ST.get();
    if s.eng.is_null() { s.eng = find_engine(); }
    let eng = s.eng;
    if is_null(eng) {
        if !s.warned { s.warned = true; log("fpsunlock: live Engine object NOT found"); }
        return;
    }
    let before = get_float(eng, "MaxSmoothedFrameRate").unwrap_or(-1.0);
    set_float(eng, "MaxSmoothedFrameRate", s.cap);
    set_float(eng, "MinSmoothedFrameRate", 5.0);
    set_bool(eng, "bSmoothFrameRate", !s.uncap);
    let after = get_float(eng, "MaxSmoothedFrameRate").unwrap_or(-1.0);
    if !s.applied {
        s.applied = true;
        log(&format!("fpsunlock: eng='{}' ({}) MaxSmoothed {} -> {} smoothing={}",
            name_of(eng), class_of(eng), before, after, if s.uncap { "OFF" } else { "ON" }));
    }
}

fn tick() {
    let s = ST.get();
    if !s.on { return; }
    s.tick = s.tick.wrapping_add(1);
    if s.tick % 60 == 0 || s.tick == 5 { apply(); }
}

fn panel() {
    let s = ST.get();
    ui_checkbox("Unlock FPS", &mut s.on);
    ui_slider_float("  max FPS", &mut s.cap, 30.0, 300.0, 5.0);
    ui_checkbox("  fully uncap (no smoothing)", &mut s.uncap);
    ui_label("Default game cap is 30 (Engine smoothing).");
    if ui_button("Apply now") { s.applied = false; apply(); }
    cfg_set_bool("fpsunlock", "on", s.on);
    cfg_set_float("fpsunlock", "cap", s.cap);
    cfg_set_bool("fpsunlock", "uncap", s.uncap);
    cfg_save("fpsunlock");
}

#[no_mangle]
pub extern "C" fn ModMain(api: *const hysteria_api::HysteriaAPI) {
    hysteria::init(api);
    let s = ST.get();
    s.on = cfg_get_bool("fpsunlock", "on", true);
    s.cap = cfg_get_float("fpsunlock", "cap", 120.0);
    s.uncap = cfg_get_bool("fpsunlock", "uncap", true);
    log("fpsunlock mod loaded (Rust) — raises the 30 FPS cap");
    on_tick(tick);
    ui_panel("FPS", panel);
}

mod hysteria;
mod hysteria_api;
use hysteria::*;
use std::cell::UnsafeCell;

struct G<T>(UnsafeCell<T>);
unsafe impl<T> Sync for G<T> {}
impl<T> G<T> {
    fn get(&self) -> &mut T { unsafe { &mut *self.0.get() } }
}
static EN: G<bool> = G(UnsafeCell::new(true));

// The game gates Complete-Edition / DLC content behind these getters (MadnessPatch sets
// GIsSpecialPCEdition=true). Forcing every getter's return to true unlocks the bonus
// dresses, weapons, and the "American McGee's Alice" bonus game in the menus.
const GETTERS: &[&str] = &[
    "getIsSpecialPCEdition",
    "GetIsDLC_ES_UnLock", "GetIsDLC_HH_UnLock", "GetIsDLC_TC_UnLock", "GetIsDLC_VB_UnLock",
    "GetIsDLC_ES_Enable", "GetIsDLC_HH_Enable", "GetIsDLC_TC_Enable", "GetIsDLC_VB_Enable",
];

fn force_true(e: &Event) {
    if *EN.get() {
        e.ret_int(1);
        static mut LOGGED: bool = false;
        unsafe {
            if !LOGGED { LOGGED = true; log(&format!("dlcunlock: '{}' forced -> unlocked", e.name())); }
        }
    }
}

fn panel() {
    ui_checkbox("Unlock all DLC / Complete Edition", EN.get());
    ui_label("Forces GIsSpecialPCEdition + DLC getters true.");
    ui_label("Bonus dresses, weapons, Alice 1 unlocked.");
}

#[no_mangle]
pub extern "C" fn ModMain(api: *const hysteria_api::HysteriaAPI) {
    hysteria::init(api);
    log("dlcunlock mod loaded (Rust) — Complete Edition + all DLC");
    for g in GETTERS {
        on_post(g, force_true);
    }
    ui_panel("DLC Unlock", panel);
}

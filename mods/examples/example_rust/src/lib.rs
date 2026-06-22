mod hysteria;
mod hysteria_api;
use hysteria::*;
use std::cell::UnsafeCell;

struct G<T>(UnsafeCell<T>);
unsafe impl<T> Sync for G<T> {}
impl<T> G<T> { fn get(&self) -> &mut T { unsafe { &mut *self.0.get() } } }

static CLICKS: G<i32> = G(UnsafeCell::new(0));
static MODE: G<i32> = G(UnsafeCell::new(0));
static SPAWNS: G<i32> = G(UnsafeCell::new(0));
static GOD: G<bool> = G(UnsafeCell::new(false));

#[no_mangle]
pub extern "C" fn ModMain(api: *const hysteria_api::HysteriaAPI) {
    hysteria::init(api);
    log("example_rust: v13 ergonomics demo");

    on("TakeDamage", |e| if *GOD.get() && e.this() == player_pawn() { e.block(); });
    when_ready(|_p| log("example_rust: player ready"));
    on_spawn("Pawn", |_o| *SPAWNS.get() += 1);
    every(2000, || if *GOD.get() { log("example_rust: invincible"); });

    on_tick(|| if key_pressed(0x77) { *GOD.get() = !*GOD.get(); }); // F8

    ui_panel("Example Rust", || {
        ui_text(0xFF80FFB0, "v13 builder demo");
        ui_separator();
        ui_checkbox("Godmode (F8)", GOD.get());
        if ui_button("Click me") { *CLICKS.get() += 1; }
        ui_label(&format!("clicks: {}", *CLICKS.get()));
        ui_spacing(6);
        ui_combo("Mode", MODE.get(), &["Off", "Low", "High", "Max"]);
        if ui_tree("Stats") {
            ui_label(&format!("spawns seen: {}", *SPAWNS.get()));
            ui_progress("clicks/100", (*CLICKS.get() as f32) / 100.0);
        }
    });
}

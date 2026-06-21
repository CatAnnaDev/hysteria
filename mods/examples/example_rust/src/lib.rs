mod hysteria;
mod hysteria_api;
use hysteria::*;

#[no_mangle]
pub extern "C" fn ModMain(api: *const hysteria_api::HysteriaAPI) {
    hysteria::init(api);
    log("rust example mod loaded");
    on("DoJump", |_e| log("rust mod: jump intercepted (DoJump)"));
    on_tick(|| {
        if key_pressed(0x79) {
            console("fly");
        }
    }); // 0x79 = VK_F10
}

#![allow(dead_code)]
// Ergonomic wrapper over the raw FFI binding: closures, &str, no unsafe in your mod.
//
//   mod hysteria_api; mod hysteria; use hysteria::*;
//   #[no_mangle] pub extern "C" fn ModMain(api: *const hysteria_api::HysteriaAPI) {
//       hysteria::init(api);
//       log("hi from rust");
//       on("TakeDamage", |e| if e.this() == player_pawn() { e.block(); });
//       on_tick(|| if key_pressed(0x7A) { console("God"); });   // 0x7A = VK_F11
//   }

use crate::hysteria_api::*;
use std::cell::UnsafeCell;
use std::ffi::{CStr, CString};
use std::os::raw::c_char;
use std::sync::atomic::{AtomicPtr, Ordering};

static API: AtomicPtr<HysteriaAPI> = AtomicPtr::new(std::ptr::null_mut());
pub fn init(p: *const HysteriaAPI) { API.store(p as *mut _, Ordering::Relaxed); }
fn a() -> &'static HysteriaAPI { unsafe { &*API.load(Ordering::Relaxed) } }

pub type Obj = AObj;
fn cs(s: &str) -> CString { CString::new(s).unwrap_or_default() }
fn rs(p: *const c_char) -> String { if p.is_null() { String::new() } else { unsafe { CStr::from_ptr(p) }.to_string_lossy().into_owned() } }

pub struct Event(*mut AEvent);
impl Event {
    pub fn this(&self) -> Obj { unsafe { (*self.0).self_ } }
    pub fn name(&self) -> String { unsafe { rs((*self.0).func_name) } }
    pub fn block(&self) { unsafe { (*self.0).block = 1; } }
    pub fn get_int(&self, n: &str) -> Option<i32> { let mut v = 0; if (a().param_get_int)(self.0, cs(n).as_ptr(), &mut v) != 0 { Some(v) } else { None } }
    pub fn set_int(&self, n: &str, v: i32) { (a().param_set_int)(self.0, cs(n).as_ptr(), v); }
    pub fn ret_int(&self, v: i32) { (a().ret_set_int)(self.0, v); }
}

pub fn log(s: &str) { (a().log)(cs(s).as_ptr()); }
pub fn player_pawn() -> Obj { (a().player_pawn)() }
pub fn player_controller() -> Obj { (a().player_controller)() }
pub fn console(cmd: &str) { (a().console)(player_controller(), cs(cmd).as_ptr()); }
pub fn key_pressed(vk: i32) -> bool { (a().key_pressed)(vk) != 0 }
pub fn key_down(vk: i32) -> bool { (a().key_down)(vk) != 0 }
pub fn find(name: &str) -> Obj { (a().find_object)(cs(name).as_ptr()) }
pub fn is_a(o: Obj, c: &str) -> bool { (a().is_a)(o, cs(c).as_ptr()) != 0 }
pub fn name_of(o: Obj) -> String { rs((a().name_of)(o)) }
pub fn class_of(o: Obj) -> String { rs((a().class_of)(o)) }
pub fn get_int(o: Obj, p: &str) -> Option<i32> { let mut v = 0; if (a().get_int)(o, cs(p).as_ptr(), &mut v) != 0 { Some(v) } else { None } }
pub fn set_int(o: Obj, p: &str, v: i32) { (a().set_int)(o, cs(p).as_ptr(), v); }
pub fn set_float(o: Obj, p: &str, v: f32) { (a().set_float)(o, cs(p).as_ptr(), v); }
pub fn set_bool(o: Obj, p: &str, v: bool) { (a().set_bool)(o, cs(p).as_ptr(), v as i32); }
pub fn get_obj(o: Obj, p: &str) -> Obj { (a().get_obj)(o, cs(p).as_ptr()) }
pub fn spawn(class: &str, x: f32, y: f32, z: f32) -> Obj { (a().spawn)(cs(class).as_ptr(), x, y, z) }
pub fn destroy(o: Obj) { (a().destroy)(o); }

pub struct Call(ACall);
pub fn call(o: Obj, func: &str) -> Call { Call((a().call_begin)(o, cs(func).as_ptr())) }
impl Call {
    pub fn int(self, p: &str, v: i32) -> Self { (a().call_arg_int)(self.0, cs(p).as_ptr(), v); self }
    pub fn float(self, p: &str, v: f32) -> Self { (a().call_arg_float)(self.0, cs(p).as_ptr(), v); self }
    pub fn bool(self, p: &str, v: bool) -> Self { (a().call_arg_bool)(self.0, cs(p).as_ptr(), v as i32); self }
    pub fn obj(self, p: &str, v: Obj) -> Self { (a().call_arg_obj)(self.0, cs(p).as_ptr(), v); self }
    pub fn str(self, p: &str, v: &str) -> Self { (a().call_arg_str)(self.0, cs(p).as_ptr(), cs(v).as_ptr()); self }
    pub fn vec(self, p: &str, v: [f32; 3]) -> Self { (a().call_arg_vec)(self.0, cs(p).as_ptr(), v.as_ptr()); self }
    pub fn rot(self, p: &str, v: [i32; 3]) -> Self { (a().call_arg_rot)(self.0, cs(p).as_ptr(), v.as_ptr()); self }
    pub fn raw(self, p: &str, d: &[u8]) -> Self { (a().call_arg_raw)(self.0, cs(p).as_ptr(), d.as_ptr() as *const _, d.len() as i32); self }
    pub fn invoke(self) -> Self { (a().call_invoke)(self.0); self }
    pub fn out_int(&self, p: &str) -> Option<i32> { let mut v = 0; if (a().call_out_int)(self.0, cs(p).as_ptr(), &mut v) != 0 { Some(v) } else { None } }
    pub fn out_float(&self, p: &str) -> Option<f32> { let mut v = 0.0; if (a().call_out_float)(self.0, cs(p).as_ptr(), &mut v) != 0 { Some(v) } else { None } }
    pub fn out_vec(&self, p: &str) -> Option<[f32; 3]> { let mut v = [0f32; 3]; if (a().call_out_vec)(self.0, cs(p).as_ptr(), v.as_mut_ptr()) != 0 { Some(v) } else { None } }
    pub fn ret_int(&self) -> Option<i32> { self.out_int("ReturnValue") }
}

struct Global<T>(UnsafeCell<T>);
unsafe impl<T> Sync for Global<T> {}
impl<T> Global<T> {
    fn get(&self) -> &mut T { unsafe { &mut *self.0.get() } }
}

static PRE: Global<Vec<(String, usize, Box<dyn FnMut(&Event)>)>> = Global(UnsafeCell::new(Vec::new()));
static TICKS: Global<Vec<Box<dyn FnMut()>>> = Global(UnsafeCell::new(Vec::new()));

extern "C" fn pre_tramp(e: *mut AEvent) {
    let ev = Event(e); let n = ev.name(); let who = ev.this() as usize;
    for (k, tgt, f) in PRE.get().iter_mut() { if *k == n && (*tgt == 0 || *tgt == who) { f(&ev); } }
}
extern "C" fn tick_tramp() { for f in TICKS.get().iter_mut() { f(); } }

pub fn on(name: &str, cb: impl FnMut(&Event) + 'static) {
    PRE.get().push((name.to_string(), 0, Box::new(cb)));
    (a().on)(cs(name).as_ptr(), pre_tramp);
}
pub fn on_object(target: Obj, name: &str, cb: impl FnMut(&Event) + 'static) {
    PRE.get().push((name.to_string(), target as usize, Box::new(cb)));
    (a().on_object)(target, cs(name).as_ptr(), pre_tramp);
}
pub fn on_tick(cb: impl FnMut() + 'static) {
    let first = TICKS.get().is_empty();
    TICKS.get().push(Box::new(cb));
    if first { (a().on_tick)(tick_tramp); }
}

// --- overlay panel (one per mod) + widgets; call widgets inside the panel closure ---
static PANEL: Global<Option<Box<dyn FnMut()>>> = Global(UnsafeCell::new(None));
extern "C" fn panel_tramp() { if let Some(f) = PANEL.get() { f(); } }
pub fn ui_panel(title: &str, draw: impl FnMut() + 'static) {
    *PANEL.get() = Some(Box::new(draw));
    (a().ui_panel)(cs(title).as_ptr(), panel_tramp);
}
pub fn ui_label(text: &str) { (a().ui_label)(cs(text).as_ptr()); }
pub fn ui_button(label: &str) -> bool { (a().ui_button)(cs(label).as_ptr()) != 0 }
pub fn ui_checkbox(label: &str, v: &mut bool) {
    let mut iv = *v as i32;
    (a().ui_checkbox)(cs(label).as_ptr(), &mut iv);
    *v = iv != 0;
}
pub fn ui_slider_int(label: &str, v: &mut i32, min: i32, max: i32) { (a().ui_slider_int)(cs(label).as_ptr(), v, min, max); }
pub fn ui_slider_float(label: &str, v: &mut f32, min: f32, max: f32, step: f32) { (a().ui_slider_float)(cs(label).as_ptr(), v, min, max, step); }

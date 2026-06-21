#![allow(non_snake_case, dead_code)]
use std::os::raw::{c_char, c_float, c_int, c_void};

pub const HYSTERIA_API_VERSION: c_int = 8;

pub type AObj = *mut c_void;
pub type ACall = *mut c_void;

#[repr(C)]
pub struct AEvent {
    pub self_: AObj,
    pub func: AObj,
    pub params: *mut c_void,
    pub result: *mut c_void,
    pub block: c_int,
    pub func_name: *const c_char,
}

pub type AEventCb = extern "C" fn(*mut AEvent);
pub type AIterCb = extern "C" fn(AObj);
pub type ADrawCb = extern "C" fn();

#[repr(C)]
pub struct HysteriaAPI {
    pub version: c_int,
    pub find_object: extern "C" fn(*const c_char) -> AObj,
    pub find_class: extern "C" fn(*const c_char) -> AObj,
    pub iter_objects: extern "C" fn(*const c_char, AIterCb),
    pub name_of: extern "C" fn(AObj) -> *const c_char,
    pub class_of: extern "C" fn(AObj) -> *const c_char,
    pub full_name: extern "C" fn(AObj, *mut c_char, c_int),
    pub is_a: extern "C" fn(AObj, *const c_char) -> c_int,
    pub get_int: extern "C" fn(AObj, *const c_char, *mut c_int) -> c_int,
    pub set_int: extern "C" fn(AObj, *const c_char, c_int) -> c_int,
    pub get_float: extern "C" fn(AObj, *const c_char, *mut c_float) -> c_int,
    pub set_float: extern "C" fn(AObj, *const c_char, c_float) -> c_int,
    pub get_bool: extern "C" fn(AObj, *const c_char, *mut c_int) -> c_int,
    pub set_bool: extern "C" fn(AObj, *const c_char, c_int) -> c_int,
    pub get_obj: extern "C" fn(AObj, *const c_char) -> AObj,
    pub on: extern "C" fn(*const c_char, AEventCb),
    pub on_post: extern "C" fn(*const c_char, AEventCb),
    pub param_get_int: extern "C" fn(*mut AEvent, *const c_char, *mut c_int) -> c_int,
    pub param_set_int: extern "C" fn(*mut AEvent, *const c_char, c_int) -> c_int,
    pub param_get_float: extern "C" fn(*mut AEvent, *const c_char, *mut c_float) -> c_int,
    pub param_set_float: extern "C" fn(*mut AEvent, *const c_char, c_float) -> c_int,
    pub param_get_bool: extern "C" fn(*mut AEvent, *const c_char, *mut c_int) -> c_int,
    pub param_set_bool: extern "C" fn(*mut AEvent, *const c_char, c_int) -> c_int,
    pub param_get_obj: extern "C" fn(*mut AEvent, *const c_char) -> AObj,
    pub ret_get_int: extern "C" fn(*mut AEvent, *mut c_int) -> c_int,
    pub ret_set_int: extern "C" fn(*mut AEvent, c_int) -> c_int,
    pub ret_set_float: extern "C" fn(*mut AEvent, c_float) -> c_int,
    pub call: extern "C" fn(AObj, *const c_char, *mut c_void),
    pub call_str: extern "C" fn(AObj, *const c_char, *const c_char),
    pub console: extern "C" fn(AObj, *const c_char),
    pub spawn: extern "C" fn(*const c_char, c_float, c_float, c_float) -> AObj,
    pub destroy: extern "C" fn(AObj),
    pub player_controller: extern "C" fn() -> AObj,
    pub player_pawn: extern "C" fn() -> AObj,
    pub log: extern "C" fn(*const c_char),
    pub ui_panel: extern "C" fn(*const c_char, ADrawCb),
    pub ui_button: extern "C" fn(*const c_char) -> c_int,
    pub ui_checkbox: extern "C" fn(*const c_char, *mut c_int),
    pub ui_slider_int: extern "C" fn(*const c_char, *mut c_int, c_int, c_int),
    pub ui_slider_float: extern "C" fn(*const c_char, *mut c_float, c_float, c_float, c_float),
    pub ui_label: extern "C" fn(*const c_char),
    pub on_tick: extern "C" fn(extern "C" fn()),
    pub key_down: extern "C" fn(c_int) -> c_int,
    pub key_pressed: extern "C" fn(c_int) -> c_int,
    pub call_begin: extern "C" fn(AObj, *const c_char) -> ACall,
    pub call_arg_int: extern "C" fn(ACall, *const c_char, c_int),
    pub call_arg_float: extern "C" fn(ACall, *const c_char, c_float),
    pub call_arg_bool: extern "C" fn(ACall, *const c_char, c_int),
    pub call_arg_obj: extern "C" fn(ACall, *const c_char, AObj),
    pub call_arg_str: extern "C" fn(ACall, *const c_char, *const c_char),
    pub call_invoke: extern "C" fn(ACall),
    pub call_out_int: extern "C" fn(ACall, *const c_char, *mut c_int) -> c_int,
    pub call_out_float: extern "C" fn(ACall, *const c_char, *mut c_float) -> c_int,
    pub call_out_bool: extern "C" fn(ACall, *const c_char, *mut c_int) -> c_int,
    pub call_out_obj: extern "C" fn(ACall, *const c_char) -> AObj,
    pub get_byte: extern "C" fn(AObj, *const c_char, *mut c_int) -> c_int,
    pub set_byte: extern "C" fn(AObj, *const c_char, c_int) -> c_int,
    pub get_vec: extern "C" fn(AObj, *const c_char, *mut c_float) -> c_int,
    pub set_vec: extern "C" fn(AObj, *const c_char, *const c_float) -> c_int,
    pub get_rot: extern "C" fn(AObj, *const c_char, *mut c_int) -> c_int,
    pub set_rot: extern "C" fn(AObj, *const c_char, *const c_int) -> c_int,
    pub world_info: extern "C" fn() -> AObj,
    pub read_raw: extern "C" fn(AObj, c_int, *mut c_void, c_int) -> c_int,
    pub write_raw: extern "C" fn(AObj, c_int, *const c_void, c_int) -> c_int,
    pub mouse_delta: extern "C" fn(*mut c_int, *mut c_int) -> c_int,
    pub mouse_capture: extern "C" fn(c_int),
    pub on_object: extern "C" fn(AObj, *const c_char, AEventCb),
    pub on_object_post: extern "C" fn(AObj, *const c_char, AEventCb),
    pub call_arg_vec: extern "C" fn(ACall, *const c_char, *const c_float),
    pub call_arg_rot: extern "C" fn(ACall, *const c_char, *const c_int),
    pub call_arg_raw: extern "C" fn(ACall, *const c_char, *const c_void, c_int),
    pub call_out_vec: extern "C" fn(ACall, *const c_char, *mut c_float) -> c_int,
}

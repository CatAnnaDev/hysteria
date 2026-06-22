#pragma once
// C++ wrapper over hysteria_api.h - ergonomic but explicit. Logical building blocks:
//   listeners  on("Func", cb)            - many handlers per game function
//   ticks      on_tick([]{ ... })        - run every frame
//   await      when_object("Class", cb)  - fire once when an instance appears
//              on_spawn("Class", cb)     - fire for each NEW instance
//   timers     after(ms, cb) / every(ms, cb) -> id ; cancel(id)
//   threads    thread([]{ ... })         - background OS thread
//              on_game_thread([]{ ... }) - hop back to the game thread (safe to touch objects)
//   ui         ui::panel("Tab", []{ ui::button("x"); ... })  - a full immediate-mode builder
//
//   #include "hysteria.hpp"
//   using namespace hysteria;
//   HYSTERIA_MOD() {
//       log("hi");
//       on("TakeDamage", [](Event& e){ if (e.self() == player_pawn()) e.block(); }); // godmode
//       when_object("AlicePawn", [](Obj p){ log("player ready"); });
//       ui::panel("Demo", []{ static int n = 0; if (ui::button("hit")) n++; ui::label("clicks"); });
//   }

#include <windows.h>
#include <string>
#include <functional>
#include <vector>
#include <unordered_map>
#include "hysteria_api.h"

namespace hysteria {

inline HysteriaAPI *api = nullptr;
using Obj = AObj;
using std::function;

struct Event {
    AEvent *e;
    Obj self() const { return e->self; }
    const char *name() const { return e->func_name; }
    void block() { e->block = 1; }
    bool get_int(const char *p, int &v) { return api->param_get_int(e, p, &v) != 0; }
    void set_int(const char *p, int v) { api->param_set_int(e, p, v); }
    bool get_float(const char *p, float &v) { return api->param_get_float(e, p, &v) != 0; }
    void set_float(const char *p, float v) { api->param_set_float(e, p, v); }
    bool get_bool(const char *p, bool &v) { int x = 0; int r = api->param_get_bool(e, p, &x); v = x != 0; return r != 0; }
    void set_bool(const char *p, bool v) { api->param_set_bool(e, p, v ? 1 : 0); }
    Obj get_obj(const char *p) { return api->param_get_obj(e, p); }
    bool set_obj(const char *p, Obj v) { return api->param_set_obj(e, p, v) != 0; }
    void ret_int(int v) { api->ret_set_int(e, v); }
    void ret_float(float v) { api->ret_set_float(e, v); }
};

namespace detail {
    using EvFn = function<void(Event &)>;
    inline std::unordered_map<std::string, std::vector<EvFn>> &preL() { static std::unordered_map<std::string, std::vector<EvFn>> m; return m; }
    inline std::unordered_map<std::string, std::vector<EvFn>> &postL() { static std::unordered_map<std::string, std::vector<EvFn>> m; return m; }
    inline std::vector<function<void()>> &ticks() { static std::vector<function<void()>> v; return v; }
    inline void pre_tramp(AEvent *e) { auto it = preL().find(e->func_name); if (it != preL().end()) { Event ev{e}; for (auto &f : it->second) f(ev); } }
    inline void post_tramp(AEvent *e) { auto it = postL().find(e->func_name); if (it != postL().end()) { Event ev{e}; for (auto &f : it->second) f(ev); } }
    inline void tick_tramp() { for (auto &f : ticks()) f(); }

    // heap-stored callbacks marshalled through the C API's void(*)(void*) slots
    inline void call_once(void *p) { auto f = (function<void()> *)p; (*f)(); delete f; }
    inline void call_keep(void *p) { auto f = (function<void()> *)p; (*f)(); }
    inline void obj_once(AObj o, void *p) { auto f = (function<void(Obj)> *)p; (*f)(o); delete f; }
    inline void obj_keep(AObj o, void *p) { auto f = (function<void(Obj)> *)p; (*f)(o); }
    inline void *boxed(function<void()> fn) { return new function<void()>(std::move(fn)); }
    inline void *boxedO(function<void(Obj)> fn) { return new function<void(Obj)>(std::move(fn)); }
}

// ---- core ----
inline void log(const std::string &s) { api->log(s.c_str()); }
inline Obj player_pawn() { return api->player_pawn(); }
inline Obj player_controller() { return api->player_controller(); }
inline void console(const std::string &cmd) { api->console(api->player_controller(), cmd.c_str()); }

// ---- listeners (many per function) ----
inline void on(const std::string &fn, detail::EvFn cb) { auto &v = detail::preL()[fn]; bool first = v.empty(); v.push_back(std::move(cb)); if (first) api->on(fn.c_str(), detail::pre_tramp); }
inline void on_post(const std::string &fn, detail::EvFn cb) { auto &v = detail::postL()[fn]; bool first = v.empty(); v.push_back(std::move(cb)); if (first) api->on_post(fn.c_str(), detail::post_tramp); }
inline void on_object(Obj target, const std::string &fn, detail::EvFn cb) { detail::preL()[fn].push_back(std::move(cb)); api->on_object(target, fn.c_str(), detail::pre_tramp); }
inline void on_tick(function<void()> cb) { static bool reg = false; detail::ticks().push_back(std::move(cb)); if (!reg) { reg = true; api->on_tick(detail::tick_tramp); } }

// ---- await / spawn listeners ----
inline void when_object(const std::string &cls, function<void(Obj)> cb) { api->when_object(cls.c_str(), detail::obj_once, detail::boxedO(std::move(cb))); }
inline void when_ready(function<void(Obj)> cb) { api->when_object(nullptr, detail::obj_once, detail::boxedO(std::move(cb))); }
inline void on_spawn(const std::string &cls, function<void(Obj)> cb) { api->on_spawn(cls.c_str(), detail::obj_keep, detail::boxedO(std::move(cb))); }

// ---- timers (run on the game thread) ----
inline int after(int ms, function<void()> cb) { return api->after_ms(ms, detail::call_once, detail::boxed(std::move(cb))); }
inline int every(int ms, function<void()> cb) { return api->every_ms(ms, detail::call_keep, detail::boxed(std::move(cb))); }
inline void cancel(int id) { api->cancel_timer(id); }

// ---- threads ----
inline void thread(function<void()> cb) { api->thread_spawn(detail::call_once, detail::boxed(std::move(cb))); }
inline void on_game_thread(function<void()> cb) { api->run_on_game_thread(detail::call_once, detail::boxed(std::move(cb))); }
inline void sleep_ms(int ms) { api->sleep_ms(ms); }

// ---- input ----
inline bool key_pressed(int vk) { return api->key_pressed(vk) != 0; }
inline bool key_down(int vk) { return api->key_down(vk) != 0; }

// ---- reflection ----
inline Obj find(const std::string &n) { return api->find_object(n.c_str()); }
inline Obj find_class(const std::string &n) { return api->find_class(n.c_str()); }
inline bool is_a(Obj o, const std::string &c) { return api->is_a(o, c.c_str()) != 0; }
inline std::string name_of(Obj o) { const char *s = api->name_of(o); return s ? s : ""; }
inline std::string class_of(Obj o) { const char *s = api->class_of(o); return s ? s : ""; }
inline void each(const std::string &cls, AIterCb cb) { api->iter_objects(cls.c_str(), cb); }

// ---- properties ----
inline bool get_int(Obj o, const char *p, int &v) { return api->get_int(o, p, &v) != 0; }
inline void set_int(Obj o, const char *p, int v) { api->set_int(o, p, v); }
inline bool get_float(Obj o, const char *p, float &v) { return api->get_float(o, p, &v) != 0; }
inline void set_float(Obj o, const char *p, float v) { api->set_float(o, p, v); }
inline bool get_bool(Obj o, const char *p, int &v) { return api->get_bool(o, p, &v) != 0; }
inline void set_bool(Obj o, const char *p, bool v) { api->set_bool(o, p, v ? 1 : 0); }
inline Obj get_obj(Obj o, const char *p) { return api->get_obj(o, p); }
inline bool get_byte(Obj o, const char *p, int &v) { return api->get_byte(o, p, &v) != 0; }
inline void set_byte(Obj o, const char *p, int v) { api->set_byte(o, p, v); }
inline bool get_vec(Obj o, const char *p, float v[3]) { return api->get_vec(o, p, v) != 0; }
inline void set_vec(Obj o, const char *p, const float v[3]) { api->set_vec(o, p, v); }
inline bool get_rot(Obj o, const char *p, int v[3]) { return api->get_rot(o, p, v) != 0; }
inline void set_rot(Obj o, const char *p, const int v[3]) { api->set_rot(o, p, v); }
inline Obj world_info() { return api->world_info(); }
inline bool read_raw(Obj o, int off, void *buf, int n) { return api->read_raw(o, off, buf, n) != 0; }
inline bool write_raw(Obj o, int off, const void *buf, int n) { return api->write_raw(o, off, buf, n) != 0; }
inline bool mouse_delta(int &dx, int &dy) { return api->mouse_delta(&dx, &dy) != 0; }
inline void mouse_capture(bool on) { api->mouse_capture(on ? 1 : 0); }

// ---- invocation ----
struct Call {
    ACall c;
    Call &i(const char *p, int v) { api->call_arg_int(c, p, v); return *this; }
    Call &f(const char *p, float v) { api->call_arg_float(c, p, v); return *this; }
    Call &b(const char *p, bool v) { api->call_arg_bool(c, p, v ? 1 : 0); return *this; }
    Call &o(const char *p, Obj v) { api->call_arg_obj(c, p, v); return *this; }
    Call &s(const char *p, const std::string &v) { api->call_arg_str(c, p, v.c_str()); return *this; }
    Call &v(const char *p, const float val[3]) { api->call_arg_vec(c, p, val); return *this; }
    Call &r(const char *p, const int val[3]) { api->call_arg_rot(c, p, val); return *this; }
    Call &raw(const char *p, const void *d, int n) { api->call_arg_raw(c, p, d, n); return *this; }
    Call &invoke() { api->call_invoke(c); return *this; }
    bool out_int(const char *p, int &v) { return api->call_out_int(c, p, &v) != 0; }
    bool out_float(const char *p, float &v) { return api->call_out_float(c, p, &v) != 0; }
    bool out_vec(const char *p, float v[3]) { return api->call_out_vec(c, p, v) != 0; }
    Obj out_obj(const char *p) { return api->call_out_obj(c, p); }
    int ret_int() { int v = 0; api->call_out_int(c, "ReturnValue", &v); return v; }
};
inline Call call(Obj o, const std::string &fn) { return Call{ api->call_begin(o, fn.c_str()) }; }
inline void call_str(Obj o, const char *fn, const char *arg) { api->call_str(o, fn, arg); }
inline Obj spawn(const std::string &cls, float x, float y, float z) { return api->spawn(cls.c_str(), x, y, z); }
inline void destroy(Obj o) { api->destroy(o); }

// ---- on-screen HUD (immediate, every frame) ----
inline void hud_text(int x, int y, unsigned argb, const char *t) { api->hud_text(x, y, argb, t); }
inline void hud_rect(int x, int y, int w, int h, unsigned argb) { api->hud_rect(x, y, w, h, argb); }
inline bool screen_size(int &w, int &h) { return api->screen_size(&w, &h) != 0; }

// ---- UI builder (call inside a ui::panel draw lambda) ----
namespace ui {
    namespace detail {
        inline std::vector<function<void()>> &panels() { static std::vector<function<void()>> v; return v; }
        template <int N> void panel_tramp() { auto &v = panels(); if (N < (int)v.size() && v[N]) v[N](); }
        using PT = void (*)();
        inline PT *tramps() {
            static PT t[16] = {
                panel_tramp<0>, panel_tramp<1>, panel_tramp<2>, panel_tramp<3>, panel_tramp<4>, panel_tramp<5>,
                panel_tramp<6>, panel_tramp<7>, panel_tramp<8>, panel_tramp<9>, panel_tramp<10>, panel_tramp<11>,
                panel_tramp<12>, panel_tramp<13>, panel_tramp<14>, panel_tramp<15> };
            return t;
        }
    }
    inline void panel(const std::string &title, function<void()> draw) {
        auto &v = detail::panels(); int idx = (int)v.size();
        if (idx < 16) { v.push_back(std::move(draw)); api->ui_panel(title.c_str(), detail::tramps()[idx]); }
    }
    inline bool button(const char *l) { return api->ui_button(l) != 0; }
    inline void checkbox(const char *l, int &v) { api->ui_checkbox(l, &v); }
    inline void checkbox(const char *l, bool &v) { int x = v; api->ui_checkbox(l, &x); v = x != 0; }
    inline void slider(const char *l, int &v, int mn, int mx) { api->ui_slider_int(l, &v, mn, mx); }
    inline void slider(const char *l, float &v, float mn, float mx, float step = 0.1f) { api->ui_slider_float(l, &v, mn, mx, step); }
    inline void label(const char *l) { api->ui_label(l); }
    inline void separator() { api->ui_separator(); }
    inline void spacing(int px = 6) { api->ui_spacing(px); }
    inline void text(unsigned argb, const char *l) { api->ui_text_colored(argb, l); }
    inline void progress(const char *l, float frac) { api->ui_progress(l, frac); }
    inline bool combo(const char *l, int &idx, std::vector<const char *> opts) { return api->ui_combo(l, &idx, opts.data(), (int)opts.size()) != 0; }
    inline bool input_int(const char *l, int &v, int step = 1, int mn = 0, int mx = 0) { return api->ui_input_int(l, &v, step, mn, mx) != 0; }
    inline bool tree(const char *l) { return api->ui_tree(l) != 0; }
}

}

#define HYSTERIA_MOD() \
    static void hysteria_mod_main(); \
    extern "C" __declspec(dllexport) void ModMain(HysteriaAPI *a) { ::hysteria::api = a; hysteria_mod_main(); } \
    static void hysteria_mod_main()

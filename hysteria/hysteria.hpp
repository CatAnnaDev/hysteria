#pragma once
// C++ wrapper over hysteria_api.h — write mods with lambdas + std::string.
//
//   #include "hysteria.hpp"
//   using namespace hysteria;
//   HYSTERIA_MOD() {
//       log("hi from C++");
//       on("TakeDamage", [](Event& e){ if (e.self() == player_pawn()) e.block(); });   // godmode
//       on_tick([]{ if (key_pressed(VK_F11)) console("God"); });
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

struct Event {
    AEvent *e;
    Obj self() const { return e->self; }
    const char *name() const { return e->func_name; }
    void block() { e->block = 1; }
    bool get_int(const char *p, int &v) { return api->param_get_int(e, p, &v) != 0; }
    void set_int(const char *p, int v) { api->param_set_int(e, p, v); }
    bool get_float(const char *p, float &v) { return api->param_get_float(e, p, &v) != 0; }
    void set_float(const char *p, float v) { api->param_set_float(e, p, v); }
    void ret_int(int v) { api->ret_set_int(e, v); }
    void ret_float(float v) { api->ret_set_float(e, v); }
};

namespace detail {
    inline std::unordered_map<std::string, std::function<void(Event &)>> &pre() { static std::unordered_map<std::string, std::function<void(Event &)>> m; return m; }
    inline std::unordered_map<std::string, std::function<void(Event &)>> &post() { static std::unordered_map<std::string, std::function<void(Event &)>> m; return m; }
    inline std::vector<std::function<void()>> &ticks() { static std::vector<std::function<void()>> v; return v; }
    inline void pre_tramp(AEvent *e) { auto it = pre().find(e->func_name); if (it != pre().end()) { Event ev{e}; it->second(ev); } }
    inline void post_tramp(AEvent *e) { auto it = post().find(e->func_name); if (it != post().end()) { Event ev{e}; it->second(ev); } }
    inline void tick_tramp() { for (auto &f : ticks()) f(); }
}

inline void log(const std::string &s) { api->log(s.c_str()); }
inline Obj player_pawn() { return api->player_pawn(); }
inline Obj player_controller() { return api->player_controller(); }
inline void console(const std::string &cmd) { api->console(api->player_controller(), cmd.c_str()); }

inline void on(const std::string &fn, std::function<void(Event &)> cb) { detail::pre()[fn] = std::move(cb); api->on(fn.c_str(), detail::pre_tramp); }
inline void on_post(const std::string &fn, std::function<void(Event &)> cb) { detail::post()[fn] = std::move(cb); api->on_post(fn.c_str(), detail::post_tramp); }
inline void on_tick(std::function<void()> cb) { static bool reg = false; detail::ticks().push_back(std::move(cb)); if (!reg) { reg = true; api->on_tick(detail::tick_tramp); } }

inline bool key_pressed(int vk) { return api->key_pressed(vk) != 0; }
inline bool key_down(int vk) { return api->key_down(vk) != 0; }

inline Obj find(const std::string &n) { return api->find_object(n.c_str()); }
inline Obj find_class(const std::string &n) { return api->find_class(n.c_str()); }
inline bool is_a(Obj o, const std::string &c) { return api->is_a(o, c.c_str()) != 0; }
inline std::string name_of(Obj o) { const char *s = api->name_of(o); return s ? s : ""; }
inline std::string class_of(Obj o) { const char *s = api->class_of(o); return s ? s : ""; }
inline void each(const std::string &cls, AIterCb cb) { api->iter_objects(cls.c_str(), cb); }

inline bool get_int(Obj o, const char *p, int &v) { return api->get_int(o, p, &v) != 0; }
inline void set_int(Obj o, const char *p, int v) { api->set_int(o, p, v); }
inline bool get_float(Obj o, const char *p, float &v) { return api->get_float(o, p, &v) != 0; }
inline void set_float(Obj o, const char *p, float v) { api->set_float(o, p, v); }
inline bool get_bool(Obj o, const char *p, int &v) { return api->get_bool(o, p, &v) != 0; }
inline void set_bool(Obj o, const char *p, bool v) { api->set_bool(o, p, v ? 1 : 0); }
inline Obj get_obj(Obj o, const char *p) { return api->get_obj(o, p); }

inline void call_raw(Obj o, const std::string &fn, void *params) { api->call(o, fn.c_str(), params); }
inline Obj spawn(const std::string &cls, float x, float y, float z) { return api->spawn(cls.c_str(), x, y, z); }
inline void destroy(Obj o) { api->destroy(o); }

struct Call {
    ACall c;
    Call &i(const char *p, int v) { api->call_arg_int(c, p, v); return *this; }
    Call &f(const char *p, float v) { api->call_arg_float(c, p, v); return *this; }
    Call &b(const char *p, bool v) { api->call_arg_bool(c, p, v ? 1 : 0); return *this; }
    Call &o(const char *p, Obj v) { api->call_arg_obj(c, p, v); return *this; }
    Call &s(const char *p, const std::string &v) { api->call_arg_str(c, p, v.c_str()); return *this; }
    Call &invoke() { api->call_invoke(c); return *this; }
    bool out_int(const char *p, int &v) { return api->call_out_int(c, p, &v) != 0; }
    bool out_float(const char *p, float &v) { return api->call_out_float(c, p, &v) != 0; }
    Obj out_obj(const char *p) { return api->call_out_obj(c, p); }
    int ret_int() { int v = 0; api->call_out_int(c, "ReturnValue", &v); return v; }
};
inline Call call(Obj o, const std::string &fn) { return Call{ api->call_begin(o, fn.c_str()) }; }

// --- v6/v7: typed property access, engine objects, raw, mouse ---
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
inline void call_str(Obj o, const char *fn, const char *arg) { api->call_str(o, fn, arg); }

}

#define HYSTERIA_MOD() \
    static void hysteria_mod_main(); \
    extern "C" __declspec(dllexport) void ModMain(HysteriaAPI *a) { ::hysteria::api = a; hysteria_mod_main(); } \
    static void hysteria_mod_main()

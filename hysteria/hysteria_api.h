#ifndef HYSTERIA_API_H
#define HYSTERIA_API_H

// Hysteria modding API (Alice: Madness Returns, UE3).
// A mod is a DLL exporting:  void ModMain(HysteriaAPI* api)
// Build it (C/C++/Rust), drop it in Mods/, then "Reload mods" in the overlay.
//
//   static HysteriaAPI* A;
//   static void on_dmg(AEvent* e){ if(e->self==A->player_pawn()) e->block=1; }   // godmode
//   __declspec(dllexport) void ModMain(HysteriaAPI* api){
//       A=api; A->log("hi"); A->on("TakeDamage", on_dmg);
//   }
//
// AObj is an opaque game object handle. Getters return non-zero on success.

#define HYSTERIA_API_VERSION 7

#ifdef __cplusplus
extern "C" {
#endif

typedef void *AObj;   // a live UObject (actor, pawn, component, ...)
typedef void *AFunc;  // a UFunction

typedef struct AEvent {
  AObj self;             // object the function was called on
  AFunc func;            // the function being called
  void *params;          // its parameter block (use param_get/set_*)
  void *result;          // return-value storage (use ret_* in on_post)
  int block;             // set to 1 in an "on" handler to cancel the original call
  const char *func_name; // function name (e.g. "TakeDamage")
} AEvent;

typedef void (*AEventCb)(AEvent *e);
typedef void (*AIterCb)(AObj o);
typedef void *ACall;  // an in-progress call (call_begin -> call_arg_* -> call_invoke -> call_out_*)

typedef struct HysteriaAPI {
  int version;  // == HYSTERIA_API_VERSION

  // --- reflection: find and walk the live object graph (~120k objects) ---
  AObj (*find_object)(const char *nameOrFull);   // by leaf name or full path "Pkg.Outer.Name"
  AObj (*find_class)(const char *className);      // the UClass object
  void (*iter_objects)(const char *className, AIterCb cb);  // cb for each instance of (a subclass of) className
  const char *(*name_of)(AObj o);                // object's name
  const char *(*class_of)(AObj o);               // object's class name
  void (*full_name)(AObj o, char *out, int cap); // full path into out[cap]
  int (*is_a)(AObj o, const char *className);     // 1 if o is-a className

  // --- properties by name (resolved through the class hierarchy) ---
  int (*get_int)(AObj o, const char *prop, int *out);
  int (*set_int)(AObj o, const char *prop, int v);
  int (*get_float)(AObj o, const char *prop, float *out);
  int (*set_float)(AObj o, const char *prop, float v);
  int (*get_bool)(AObj o, const char *prop, int *out);
  int (*set_bool)(AObj o, const char *prop, int v);
  AObj (*get_obj)(AObj o, const char *prop);     // an ObjectProperty's value

  // --- events: intercept any game function ---
  void (*on)(const char *funcName, AEventCb cb);       // before the call: edit params, set e->block=1 to cancel
  void (*on_post)(const char *funcName, AEventCb cb);  // after the call: read/edit the return value

  // --- a function's parameters (inside a handler, via e) ---
  int (*param_get_int)(AEvent *e, const char *name, int *out);
  int (*param_set_int)(AEvent *e, const char *name, int v);
  int (*param_get_float)(AEvent *e, const char *name, float *out);
  int (*param_set_float)(AEvent *e, const char *name, float v);
  int (*param_get_bool)(AEvent *e, const char *name, int *out);
  int (*param_set_bool)(AEvent *e, const char *name, int v);
  AObj (*param_get_obj)(AEvent *e, const char *name);
  int (*ret_get_int)(AEvent *e, int *out);       // return value (use in on_post)
  int (*ret_set_int)(AEvent *e, int v);
  int (*ret_set_float)(AEvent *e, float v);

  // --- invocation: make the game do things ---
  void (*call)(AObj o, const char *func, void *params); // raw, with a param block
  void (*call_str)(AObj o, const char *func, const char *arg); // single-string arg
  void (*console)(AObj playerController, const char *cmd);     // run any console/exec command
  AObj (*spawn)(const char *className, float x, float y, float z);
  void (*destroy)(AObj actor);

  // --- shortcuts ---
  AObj (*player_controller)(void);
  AObj (*player_pawn)(void);
  void (*log)(const char *msg);  // -> C:\hysteria.log and the in-game console

  // --- draw your own panel in the overlay menu (call these inside your draw cb) ---
  void (*ui_panel)(const char *title, void (*draw)(void)); // register a tab; draw() runs each frame
  int (*ui_button)(const char *label);                     // returns 1 when clicked
  void (*ui_checkbox)(const char *label, int *v);
  void (*ui_slider_int)(const char *label, int *v, int min, int max);
  void (*ui_slider_float)(const char *label, float *v, float min, float max, float step);
  void (*ui_label)(const char *text);

  // --- per-frame + input: the simplest way to write a continuous mod ---
  void (*on_tick)(void (*cb)(void)); // cb runs every frame
  int (*key_down)(int vk);           // 1 while a virtual-key is held (VK_* from windows.h)
  int (*key_pressed)(int vk);        // 1 only on the frame the key is first pressed

  // --- generic typed invocation: call ANY function with ANY params, by name ---
  // ACall c = api->call_begin(obj, "MyFunc");
  // api->call_arg_int(c, "Amount", 5); api->call_arg_obj(c, "Target", pawn);
  // api->call_invoke(c); int r; api->call_out_int(c, "ReturnValue", &r);
  ACall (*call_begin)(AObj o, const char *func);          // start a call; 0 if the function isn't found
  void (*call_arg_int)(ACall c, const char *param, int v);
  void (*call_arg_float)(ACall c, const char *param, float v);
  void (*call_arg_bool)(ACall c, const char *param, int v);
  void (*call_arg_obj)(ACall c, const char *param, AObj v);
  void (*call_arg_str)(ACall c, const char *param, const char *v);
  void (*call_invoke)(ACall c);                           // run it
  int (*call_out_int)(ACall c, const char *param, int *out);   // read an out-param / "ReturnValue"
  int (*call_out_float)(ACall c, const char *param, float *out);
  int (*call_out_bool)(ACall c, const char *param, int *out);
  AObj (*call_out_obj)(ACall c, const char *param);

  // --- extra typed property access (byte / vector / rotator) + engine objects + raw ---
  int (*get_byte)(AObj o, const char *prop, int *out);
  int (*set_byte)(AObj o, const char *prop, int v);
  int (*get_vec)(AObj o, const char *prop, float out[3]);   // a struct of 3 floats (Location, Velocity)
  int (*set_vec)(AObj o, const char *prop, const float v[3]);
  int (*get_rot)(AObj o, const char *prop, int out[3]);     // an FRotator (Pitch,Yaw,Roll ints)
  int (*set_rot)(AObj o, const char *prop, const int v[3]);
  AObj (*world_info)(void);                                 // the WorldInfo (TimeDilation, WorldGravityZ...)
  int (*read_raw)(AObj o, int offset, void *buf, int n);    // escape hatch: raw bytes at a known offset
  int (*write_raw)(AObj o, int offset, const void *buf, int n);

  // --- raw mouse (captured at the dinput8 proxy, before the game's deadzone/accel/smoothing) ---
  int (*mouse_delta)(int *dx, int *dy);  // accumulated raw delta since last call, then resets; gameplay only
  void (*mouse_capture)(int on);         // 1 = swallow the game's look axis so you drive the camera yourself
} HysteriaAPI;

typedef void (*ModMain_t)(HysteriaAPI *api);

#ifdef __cplusplus
}
#endif

#endif

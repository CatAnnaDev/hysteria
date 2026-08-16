#include "hysteria.h"
#include <windows.h>
#include <string.h>
#include <stdio.h>
#include <wchar.h>

#define BYPASS_WINDOW_MS 20000

static DWORD g_start;
static int g_armed;

static int bypass_active(void) {
  if (!g_armed) return 0;
  if (GetTickCount() - g_start > BYPASS_WINDOW_MS) {
    g_armed = 0;
    logmsg("[hysteria][inst] fenetre de contournement fermee\r\n");
    return 0;
  }
  return 1;
}

typedef HWND(WINAPI *FindWindowA_t)(LPCSTR, LPCSTR);
typedef HWND(WINAPI *FindWindowW_t)(LPCWSTR, LPCWSTR);
typedef HWND(WINAPI *FindWindowExA_t)(HWND, HWND, LPCSTR, LPCSTR);
typedef HWND(WINAPI *FindWindowExW_t)(HWND, HWND, LPCWSTR, LPCWSTR);
typedef HANDLE(WINAPI *CreateMutexA_t)(LPSECURITY_ATTRIBUTES, BOOL, LPCSTR);
typedef HANDLE(WINAPI *CreateMutexW_t)(LPSECURITY_ATTRIBUTES, BOOL, LPCWSTR);
typedef HANDLE(WINAPI *OpenMutexA_t)(DWORD, BOOL, LPCSTR);
typedef HANDLE(WINAPI *OpenMutexW_t)(DWORD, BOOL, LPCWSTR);

static FindWindowA_t o_FindWindowA;
static FindWindowW_t o_FindWindowW;
static FindWindowExA_t o_FindWindowExA;
static FindWindowExW_t o_FindWindowExW;
static CreateMutexA_t o_CreateMutexA;
static CreateMutexW_t o_CreateMutexW;
static OpenMutexA_t o_OpenMutexA;
static OpenMutexW_t o_OpenMutexW;

static HWND WINAPI my_FindWindowA(LPCSTR c, LPCSTR n) {
  if (bypass_active()) {
    logmsg("[hysteria][inst] FindWindowA(\"%s\",\"%s\") -> NULL force\r\n",
           c ? c : "(null)", n ? n : "(null)");
    return NULL;
  }
  return o_FindWindowA(c, n);
}

static HWND WINAPI my_FindWindowW(LPCWSTR c, LPCWSTR n) {
  if (bypass_active()) {
    logmsg("[hysteria][inst] FindWindowW(%ls,%ls) -> NULL force\r\n",
           c ? c : L"(null)", n ? n : L"(null)");
    return NULL;
  }
  return o_FindWindowW(c, n);
}

static HWND WINAPI my_FindWindowExA(HWND p, HWND a, LPCSTR c, LPCSTR n) {
  if (bypass_active()) return NULL;
  return o_FindWindowExA(p, a, c, n);
}

static HWND WINAPI my_FindWindowExW(HWND p, HWND a, LPCWSTR c, LPCWSTR n) {
  if (bypass_active()) return NULL;
  return o_FindWindowExW(p, a, c, n);
}

static HANDLE WINAPI my_CreateMutexA(LPSECURITY_ATTRIBUTES sa, BOOL own, LPCSTR name) {
  char alt[256];
  if (bypass_active() && name) {
    _snprintf(alt, sizeof alt - 1, "%s_hyst2", name);
    alt[sizeof alt - 1] = 0;
    logmsg("[hysteria][inst] CreateMutexA(\"%s\") -> \"%s\"\r\n", name, alt);
    return o_CreateMutexA(sa, own, alt);
  }
  return o_CreateMutexA(sa, own, name);
}

static HANDLE WINAPI my_CreateMutexW(LPSECURITY_ATTRIBUTES sa, BOOL own, LPCWSTR name) {
  WCHAR alt[256];
  if (bypass_active() && name) {
    _snwprintf(alt, 255, L"%s_hyst2", name);
    alt[255] = 0;
    logmsg("[hysteria][inst] CreateMutexW(%ls) renomme\r\n", name);
    return o_CreateMutexW(sa, own, alt);
  }
  return o_CreateMutexW(sa, own, name);
}

static HANDLE WINAPI my_OpenMutexA(DWORD a, BOOL i, LPCSTR name) {
  if (bypass_active()) {
    logmsg("[hysteria][inst] OpenMutexA(\"%s\") -> NULL force\r\n", name ? name : "(null)");
    SetLastError(ERROR_FILE_NOT_FOUND);
    return NULL;
  }
  return o_OpenMutexA(a, i, name);
}

static HANDLE WINAPI my_OpenMutexW(DWORD a, BOOL i, LPCWSTR name) {
  if (bypass_active()) {
    SetLastError(ERROR_FILE_NOT_FOUND);
    return NULL;
  }
  return o_OpenMutexW(a, i, name);
}

static void *iat_patch(HMODULE mod, const char *dll, const char *fn, void *repl) {
  IMAGE_DOS_HEADER *dos = (IMAGE_DOS_HEADER *)mod;
  IMAGE_NT_HEADERS *nt;
  IMAGE_IMPORT_DESCRIPTOR *imp;
  DWORD rva;
  if (!mod || dos->e_magic != IMAGE_DOS_SIGNATURE) return NULL;
  nt = (IMAGE_NT_HEADERS *)((BYTE *)mod + dos->e_lfanew);
  if (nt->Signature != IMAGE_NT_SIGNATURE) return NULL;
  rva = nt->OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_IMPORT].VirtualAddress;
  if (!rva) return NULL;

  for (imp = (IMAGE_IMPORT_DESCRIPTOR *)((BYTE *)mod + rva); imp->Name; imp++) {
    const char *name = (const char *)((BYTE *)mod + imp->Name);
    IMAGE_THUNK_DATA *orig, *cur;
    if (_stricmp(name, dll) != 0) continue;
    orig = (IMAGE_THUNK_DATA *)((BYTE *)mod + imp->OriginalFirstThunk);
    cur = (IMAGE_THUNK_DATA *)((BYTE *)mod + imp->FirstThunk);
    if (!imp->OriginalFirstThunk) orig = cur;
    for (; orig->u1.AddressOfData; orig++, cur++) {
      IMAGE_IMPORT_BY_NAME *ibn;
      DWORD prot;
      void *old;
      if (IMAGE_SNAP_BY_ORDINAL(orig->u1.Ordinal)) continue;
      ibn = (IMAGE_IMPORT_BY_NAME *)((BYTE *)mod + orig->u1.AddressOfData);
      if (strcmp((const char *)ibn->Name, fn) != 0) continue;
      if (!VirtualProtect(&cur->u1.Function, sizeof(void *), PAGE_READWRITE, &prot))
        return NULL;
      old = (void *)(UINT_PTR)cur->u1.Function;
      cur->u1.Function = (UINT_PTR)repl;
      VirtualProtect(&cur->u1.Function, sizeof(void *), prot, &prot);
      return old;
    }
  }
  return NULL;
}

void instance_bypass_init(void) {
  const char *cmd = GetCommandLineA();
  HMODULE exe, k32;
  if (!cmd) return;
  if (!strstr(cmd, "CONFIGSUBDIR=P") && !strstr(cmd, "-hysteria-multi")) return;

  exe = GetModuleHandleA(NULL);
  k32 = GetModuleHandleA("kernel32.dll");
  g_start = GetTickCount();
  g_armed = 1;

  o_FindWindowA = (FindWindowA_t)iat_patch(exe, "user32.dll", "FindWindowA", my_FindWindowA);
  o_FindWindowW = (FindWindowW_t)iat_patch(exe, "user32.dll", "FindWindowW", my_FindWindowW);
  o_FindWindowExA = (FindWindowExA_t)iat_patch(exe, "user32.dll", "FindWindowExA", my_FindWindowExA);
  o_FindWindowExW = (FindWindowExW_t)iat_patch(exe, "user32.dll", "FindWindowExW", my_FindWindowExW);
  o_CreateMutexA = (CreateMutexA_t)iat_patch(exe, "kernel32.dll", "CreateMutexA", my_CreateMutexA);
  o_CreateMutexW = (CreateMutexW_t)iat_patch(exe, "kernel32.dll", "CreateMutexW", my_CreateMutexW);
  o_OpenMutexA = (OpenMutexA_t)iat_patch(exe, "kernel32.dll", "OpenMutexA", my_OpenMutexA);
  o_OpenMutexW = (OpenMutexW_t)iat_patch(exe, "kernel32.dll", "OpenMutexW", my_OpenMutexW);

  if (!o_FindWindowA) o_FindWindowA = (FindWindowA_t)GetProcAddress(GetModuleHandleA("user32.dll"), "FindWindowA");
  if (!o_FindWindowW) o_FindWindowW = (FindWindowW_t)GetProcAddress(GetModuleHandleA("user32.dll"), "FindWindowW");
  if (!o_FindWindowExA) o_FindWindowExA = (FindWindowExA_t)GetProcAddress(GetModuleHandleA("user32.dll"), "FindWindowExA");
  if (!o_FindWindowExW) o_FindWindowExW = (FindWindowExW_t)GetProcAddress(GetModuleHandleA("user32.dll"), "FindWindowExW");
  if (!o_CreateMutexA) o_CreateMutexA = (CreateMutexA_t)GetProcAddress(k32, "CreateMutexA");
  if (!o_CreateMutexW) o_CreateMutexW = (CreateMutexW_t)GetProcAddress(k32, "CreateMutexW");
  if (!o_OpenMutexA) o_OpenMutexA = (OpenMutexA_t)GetProcAddress(k32, "OpenMutexA");
  if (!o_OpenMutexW) o_OpenMutexW = (OpenMutexW_t)GetProcAddress(k32, "OpenMutexW");

  logmsg("[hysteria][inst] seconde instance: contournement arme %ums "
         "(FindWindowA=%d W=%d ExA=%d ExW=%d MutexA=%d W=%d OpenA=%d W=%d)\r\n",
         BYPASS_WINDOW_MS, o_FindWindowA != 0, o_FindWindowW != 0,
         o_FindWindowExA != 0, o_FindWindowExW != 0, o_CreateMutexA != 0,
         o_CreateMutexW != 0, o_OpenMutexA != 0, o_OpenMutexW != 0);
}

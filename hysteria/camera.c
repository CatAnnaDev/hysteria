#include "hysteria.h"

int g_camLocOff = -1;
float g_fov = 85.0f;

void calibrate_camera(void *pc, float *pl) {
  if (g_camLocOff >= 0)
    return;
  void *cam = *(void **)((char *)pc + PC_CAMERA);
  if (!mem_ok(cam, 0x3b0))
    return;
  for (int o = 0x364; o <= 0x3a0; o += 4) {
    float *f = (float *)((char *)cam + o);
    if (!mem_ok(f, 12))
      continue;
    float dx = f[0] - pl[0], dy = f[1] - pl[1], dz = f[2] - pl[2];
    if (dx > -13000 && dx < 13000 && dy > -13000 && dy < 13000 && dz > -13000 &&
        dz < 13000 && (f[0] || f[1] || f[2])) {
      if (!mem_ok((char *)cam + o + 12, 12))
        continue;
      g_camLocOff = o;
      float fv = *(float *)((char *)pc + PC_FOV);
      if (fv >= 20.0f && fv <= 150.0f)
        g_fov = fv;
      logmsg("[hysteria] cam POV @+0x%x fov=%d\r\n", o, (int)g_fov);
      return;
    }
  }
}

int project(void *cam, float *P, int W, int H, float *sx, float *sy) {
  if (g_camLocOff < 0 || !mem_ok(cam, g_camLocOff + 28))
    return 0;
  float *C = (float *)((char *)cam + g_camLocOff);
  int *R = (int *)((char *)cam + g_camLocOff + 12);
  double yaw = R[1] * (3.14159265358979 / 32768.0),
         pitch = R[0] * (3.14159265358979 / 32768.0);
  double cp = cos(pitch), sp = sin(pitch), cyw = cos(yaw), syw = sin(yaw);
  double fX = cp * cyw, fY = cp * syw, fZ = sp;
  double rX = -syw, rY = cyw, rZ = 0;
  double uX = -sp * cyw, uY = -sp * syw, uZ = cp;
  double dx = P[0] - C[0], dy = P[1] - C[1], dz = P[2] - C[2];
  double depth = dx * fX + dy * fY + dz * fZ;
  if (depth < 1.0)
    return 0;
  double rr = dx * rX + dy * rY + dz * rZ, uu = dx * uX + dy * uY + dz * uZ;
  double tanH = tan(g_fov * 0.5 * 3.14159265358979 / 180.0);
  double aspect = (double)W / (double)H;
  *sx = (float)(W * 0.5 * (1.0 + rr / (depth * tanH)));
  *sy = (float)(H * 0.5 * (1.0 - uu / (depth * (tanH / aspect))));
  return 1;
}

ViewProj g_view;
void view_setup(void *cam, int W, int H) {
  g_view.ok = 0;
  if (g_camLocOff < 0 || !mem_ok(cam, g_camLocOff + 28))
    return;
  float *C = (float *)((char *)cam + g_camLocOff);
  int *R = (int *)((char *)cam + g_camLocOff + 12);
  double yaw = R[1] * (3.14159265358979 / 32768.0),
         pitch = R[0] * (3.14159265358979 / 32768.0);
  double cp = cos(pitch), sp = sin(pitch), cyw = cos(yaw), syw = sin(yaw);
  g_view.cx = C[0];
  g_view.cy = C[1];
  g_view.cz = C[2];
  g_view.fx = cp * cyw;
  g_view.fy = cp * syw;
  g_view.fz = sp;
  g_view.rx = -syw;
  g_view.ry = cyw;
  g_view.rz = 0;
  g_view.ux = -sp * cyw;
  g_view.uy = -sp * syw;
  g_view.uz = cp;
  g_view.tanH = tan(g_fov * 0.5 * 3.14159265358979 / 180.0);
  g_view.aspect = (double)W / (double)H;
  g_view.W = W;
  g_view.H = H;
  g_view.ok = 1;
}
void cam_xform(float *P, double *cr, double *cu, double *cd) {
  double dx = P[0] - g_view.cx, dy = P[1] - g_view.cy, dz = P[2] - g_view.cz;
  *cd = dx * g_view.fx + dy * g_view.fy + dz * g_view.fz;
  *cr = dx * g_view.rx + dy * g_view.ry + dz * g_view.rz;
  *cu = dx * g_view.ux + dy * g_view.uy + dz * g_view.uz;
}
int cam_screen(double cr, double cu, double cd, float *sx, float *sy) {
  if (cd < 1.0)
    return 0;
  *sx = (float)(g_view.W * 0.5 * (1.0 + cr / (cd * g_view.tanH)));
  *sy = (float)(g_view.H * 0.5 *
                (1.0 - cu / (cd * (g_view.tanH / g_view.aspect))));
  return 1;
}

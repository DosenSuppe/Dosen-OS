#pragma once

extern float absf(float n);
extern int abs(int n);

extern float neg(float n);

extern float ceil(float n);
extern float floor(float n);
extern float round(float n);

extern float sqrt(float n);

extern float sin(float degrees);
extern float cos(float degrees);
extern float tan(float degrees);
extern float atan2(float x, float y);

extern float toFloat(int n);
extern int toInt(float n);

extern float maxf(float a, float b);
extern int max(int a, int b);

extern float minf(float a, float b);
extern int min(int a, int b);

extern float clampf(float v, float lo, float hi);
extern int clamp(int v, int lo, int hi);

extern float lerp(float a, float b, float t);

extern float mod(float n, float d);


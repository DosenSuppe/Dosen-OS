#include "./float.h"

float absf(float n) {
    if (n < F_ZERO) return 0 - n;
    return n;
}

int abs(int n) {
    if (n < 0) return 0 - n;
    return n;
}

// negate a float
float negf(float n) { return 0 - n; }
// negate an integer
int neg(int n) { return 0 - n; }

float ceil(float n) {

}

float floor(float n) {

}

float round(float n, int decimals) {
    
}

float sqrt(float n) {

}

float sin(float degrees) {
    while (degrees > F_PI) degrees -= F_TWO_PI;
    while (degrees < F_NEG_PI) degrees += F_TWO_PI;

    float sign = 1.0f;
    if (degrees < F_ZERO) {
        sign = -1.0f;
        degrees = -degrees;
    }

    float top = 16.0f * degrees * (F_PI - degrees);
    float bottom = (5.0f * F_PI * F_PI) - (4.0f * degrees * (F_PI - degrees));

    return sign * (top / bottom);
}

float cos(float degrees) {
    return sin(degrees + F_HALF_PI);
}

float tan(float degrees) {

}

float atan2(float x, float y) {

}

float toFloat(int n) {
    asm("ITOF REA, REA");
    return;
}

int toInt(float n) {
    asm("FTOI REA, REA");
    return;
}

float minf(float a, float b) { return a < b ? a : b; }
int min(int a, int b) { return a < b ? a : b; }

float maxf(int a, int b) { return a > b ? a : b; }
int max(int a, int b) { return a > b ? a : b; }

float clampf(float v, float lo, float hi) {
    if (v < lo) {
        return lo;
    }

    if (v > hi) {
        return hi;
    }

    return v;
}

int clamp(int v, int lo, int hi) {
    if (v < lo) {
        return lo;
    }

    if (v > hi) {
        return hi;
    }

    return v;
}

float lerp(float a, float b, float t) {

}

float mod(float n, float d) {

}

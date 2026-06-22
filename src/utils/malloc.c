#include "./stdio.h"

#define HDR 2   // [size, taken]

int *heapTop;
int heapInit;
int heapStart;
int heapEnd;

int *_getInitialHeap() {
    asm("LDI REA, $Heap.Start");
}

void _heapInit() {
    if (heapInit) return;

    heapStart = 
    heapEnd = heapStart;

    heapInit = 1;
}

int *calloc(int num) {
    int *p = malloc(num);
    for (int i = 0; i < num; i++) p[i] = 0;
    return p;
}

int *malloc(int n) {
    if (!heapInit) _heapInit();

    int *b = heapStart;
    
    // check for an already avail. block
    while (b < heapEnd) {
        if (b[1] == 0 && b[0] >= n) {

            // split if too big
            if (b[0] >= n + HDR + 1) { 
                int *s = b + HDR + n;
                s[0] = b[0] - n - HDR; s[1] = 0;
                b[0] = n;
            }
    
            b[1] = 1;
    
            return b + HDR;
        }
    
        b = b + HDR + b[0];
    }
    
    // bump a new block
    int *nb = heapEnd;
    
    nb[0] = n; nb[1] = 1;
    heapEnd = heapEnd + HDR + n;
    
    return nb + HDR;
}

void free(int *p) {
    int *b = p - HDR;

    if (b[1] == 0) {
        prints("free(): already free", 1);
        return;
    }
    
    b[1] = 0;
    
    int *nb = b + HDR + b[0];

    if (nb < heapEnd && nb[1] == 0) {
        b[0] = b[0] + HDR + nb[0];
    }

    return;
}

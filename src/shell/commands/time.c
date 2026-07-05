#include "../../drivers/timer.h"
#include "../../utils/stdio.h"

void time(int argc, int **argv) {
    int curUtc = utcNow();
    
    prints("Up-Time in ms: ", 0);
    printi(uptimeMs(), 1);

    prints("Current UTC Time: ", 0);
    prints(utcToString(curUtc), 1);
    
    prints("Current UTC Time (raw): ", 0);
    printi(curUtc, 1);

    return;
}

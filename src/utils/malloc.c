int *heapTop;
int heapInitialized;

int *_heap_start(void) {
    asm("LDI REA, $Heap.Start");
}

int *malloc(int nWords) {
    int *result;
    
    if (heapInitialized == 0) {
        heapTop = _heap_start();
        heapInitialized = 1;
    }
    
    result = heapTop;
    heapTop += nWords;
    
    return result; 
}

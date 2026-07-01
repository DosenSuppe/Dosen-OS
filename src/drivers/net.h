#pragma once

extern void netSendFrame(int *buf, int len);
extern int netRecvFrame(int *buf, int max);

extern int rd16(int *frame, int offset);
extern int rd32(int *frame, int offset);
extern void wr16(int *frame, int offset, int value);

extern void arptest(int argc, int **argv);
extern void ping(int argc, int **argv);
extern void nettest(int argc, int **argv);

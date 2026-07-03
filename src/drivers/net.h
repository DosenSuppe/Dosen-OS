#pragma once

extern const int ETH_ARP;
extern const int ETH_IPV4;
extern const int IP_GUEST;
extern const int IP_GATEWAY;
extern const int IP_DNS;

extern void netSendFrame(int *buf, int len);
extern int netRecvFrame(int *buf, int max);

extern int rd16(int *frame, int offset);
extern int rd32(int *frame, int offset);

extern void wr8(int *frame, int offset, int value);
extern void wr16(int *frame, int offset, int value);
extern void wr32(int *frame, int offset, int value);

extern void putBroadcastMac(int *frame, int offset);
extern int inetChecksum(int *frame, int offset, int len);
extern void putGatewayMac(int *frame, int offset);
extern void putGuestMac(int *frame, int offset);

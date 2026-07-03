#include "../../../drivers/net.h"
#include "../../../utils/stdio.h"

/**
 * ARP test program
 */
void arp(int argc, int **argv) {
    int frame[42];
    int reply[42];
    int i;

    for (i = 0; i < 42; i++) {
        frame[i] = 0;
    }

    // --- Ethernet header ---
    // Destination MAC = broadcast FF:FF:FF:FF:FF:FF
    for (i = 0; i < 6; i++) {
        frame[i] = 0xFF;
    }

    // Source MAC = guest 52:54:00:12:34:56
    frame[6]  = 0x52;
    frame[7]  = 0x54;
    frame[8]  = 0x00;
    frame[9]  = 0x12;
    frame[10] = 0x34;
    frame[11] = 0x56;
    
    // EtherType = 0x0806 (ARP)
    frame[12] = 0x08;
    frame[13] = 0x06;

    // --- ARP body (starts at byte 14) ---
    frame[14] = 0x00;   // HTYPE = Ethernet
    frame[15] = 0x01;
    frame[16] = 0x08;   // PTYPE = IPv4
    frame[17] = 0x00;
    frame[18] = 6;      // HLEN
    frame[19] = 4;      // PLEN
    frame[20] = 0x00;   // OPER = request
    frame[21] = 0x01;
    // Sender MAC = guest (bytes 22..27)
    frame[22] = 0x52;
    frame[23] = 0x54;
    frame[24] = 0x00;
    frame[25] = 0x12;
    frame[26] = 0x34;
    frame[27] = 0x56;
    // Sender IP = 10.0.2.15 (bytes 28..31)
    frame[28] = 10;
    frame[29] = 0;
    frame[30] = 2;
    frame[31] = 15;
    // Target MAC = 0 (bytes 32..37, already zeroed)
    // Target IP = 10.0.2.2 (bytes 38..41)
    frame[38] = 10;
    frame[39] = 0;
    frame[40] = 2;
    frame[41] = 2;

    prints("Sending ARP request for 10.0.2.2...", 1);
    netSendFrame(frame, 42);

    int len = netRecvFrame(reply, 42);
    if (len == 0) {
        prints("No ARP reply received.", 1);
        return;
    }

    int etherType = rd16(reply, 12);
    int oper = rd16(reply, 20);

    if (etherType != 0x0806) {
        prints("Reply is not ARP.", 1);
        return;
    }
    if (oper != 2) {
        prints("ARP opcode is not reply.", 1);
        return;
    }

    // Gateway MAC = sender hardware address of the reply (bytes 22..27).
    prints("Gateway MAC bytes:", 1);
    for (i = 0; i < 6; i++) {
        printi(reply[22 + i], 1);
    }

    prints("arptest done!", 1);
    return;
}

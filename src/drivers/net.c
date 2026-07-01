#include "../utils/stdio.h"

#define ETH_ARP    0x0806
#define ETH_IPV4   0x0800

#define IP_GUEST   0x0A00020F   // 10.0.2.15
#define IP_GATEWAY 0x0A000202   // 10.0.2.2

/**
 * Provides NIC (Network Interface Card) MMIO address.
 * 
 * @returns NIC MMIO address
 */
int *_nic(void) {
    asm("LDI REA, $MemDevice3.Start");
}

/**
 * Sends a frame throught the NIC (Network Interface Card)
 * 
 * @param frame pointer to the frame
 * @param len length of the frame
 * 
 * @returns void
 */
void netSendFrame(int *frame, int len) {
    int *n = _nic();

    for (int i = 0; i < len; i++) {
        n[0x400 + i] = frame[i] & 0xFF;
    }

    n[1] = len;
    n[0] = 1;

    return;
}

/**
 * Reads the Network Interface Card for a frame with fixed size.
 * 
 * @param buf pointer towards an empty frame buffer
 * @param max max length accepted
 * 
 * @returns actual length of frame
 */
int netRecvFrame(int *buf, int max) {
    int *n = _nic();

    int len = n[2];

    if (len == 0) {
        return 0;
    }

    int lenCopy = len > max ? max : len;

    for (int i = 0; i < lenCopy; i++) {
        buf[i] = n[0x800 + i] & 0xFF;
    }

    n[3] = 1;

    return len;
}

/**
 * Reads a 16bit Big-Edian value
 * 
 * @param frame pointer of the frame
 * @param offset offset to be read from
 * 
 * @returns value
 */
int rd16(int *frame, int offset) {
    return (frame[offset] << 8) | frame[offset+1];
}

/**
 * Reads a 32bit Big-Edian value
 * 
 * @param frame pointer of the frame
 * @param offset offset to be read from
 * 
 * @returns value
 */
int rd32(int *frame, int offset) {
    return (frame[offset] << 24) | (frame[offset+1] << 16) | (frame[offset+2] << 8) | frame[offset+3];
}

/**
 * Writes a 8bit Big-Edian value
 * 
 * @param frame pointer of the frame
 * @param offset offset to be written to
 * @param value value to be written
 * 
 * @returns void
 */
void wr8(int *frame, int offset, int value) {
    frame[offset] = value & 0xFF;

    return;
}

/**
 * Writes a 16bit Big-Edian value
 * 
 * @param frame pointer of the frame
 * @param offset offset to be written to
 * @param value value to be written
 * 
 * @returns void
 */
void wr16(int *frame, int offset, int value) {
    frame[offset] = (value >> 8) & 0xFF;
    frame[offset + 1] = value & 0xFF;

    return;
}

/**
 * Writes a 32bit Big-Edian value
 * 
 * @param frame pointer of the frame
 * @param offset offset to be written to
 * @param value value to be written
 * 
 * @returns void
 */
void wr32(int *frame, int offset, int value) {
    frame[offset] = (value >> 24) & 0xFF;
    frame[offset + 1] = (value >> 16) & 0xFF;
    frame[offset + 2] = (value >> 8) & 0xFF;
    frame[offset + 3] = value & 0xFF;

    return;
}

/**
 * Puts the guest's MAC into the given frame.
 * 
 * @returns void
 */
void putGuestMac(int *frame, int offset) {
    frame[offset] = 0x52;
    frame[offset + 1] = 0x54;
    frame[offset + 2] = 0x00;
    frame[offset + 3] = 0x12;
    frame[offset + 4] = 0x34;
    frame[offset + 5] = 0x56;
}

/**
 * Puts the default gateway MAC into given frame.
 * 
 * @returns void
 */
void putGatewayMac(int *frame, int offset) {
    frame[offset] = 0x52;
    frame[offset + 1] = 0x55;
    frame[offset + 2] = 0x0a;
    frame[offset + 3] = 0x00;
    frame[offset + 4] = 0x02;
    frame[offset + 5] = 0x02;

    return;
}

/**
 * Adds the broadcast MAC to a frame.
 * 
 * @returns void;
 */
void putBroadcastMac(int *frame, int offset) {
    for (int i = 0; i < 6; i++) {
        frame[offset + i] = 0xFF;
    }
}

/**
 * Generates a 16bit Checksum of given frame section.
 * 
 * @param frame pointer to the frame buffer
 * @param offset start of the checksum values
 * @param len words to be added to the checksum
 * 
 * @returns checksum
 */
int inetChecksum(int *frame, int offset, int len) {
    int sum = 0;
    int i = 0;

    while (i + 1 < len) {
        sum = sum + ((frame[offset + i] << 8) | frame[offset + i + 1]);
        i = i + 2;
    }

    if (i < len) {
        sum = sum + (frame[offset + i] << 8);
    }

    while ((sum >> 16) != 0) {
        sum = (sum & 0xFFFF) + (sum >> 16);
    }

    return (sum ^ 0xFFFF);
}

/**
 * Ping program
 */
void ping(int arc, int **argv) {
    int frame[42];
    int reply[64];

    for (int i = 0; i < 42; i++) {
        frame[i] = 0;
    }

    // Ethernet header
    putGatewayMac(frame, 0);
    putGuestMac(frame, 6);
    wr16(frame, 12, ETH_IPV4);

    // IPv4 header
    wr8(frame, 14, 0x45);
    wr8(frame, 15, 0x00);
    wr16(frame, 16, 28); // total length
    wr16(frame, 18, 0);
    wr16(frame, 20, 0);
    wr8(frame, 22, 64); // TTL
    wr8(frame, 23, 1);
    wr16(frame, 24, 0);
    wr32(frame, 26, IP_GUEST);
    wr32(frame, 30, IP_GATEWAY);

    int headerCheck = inetChecksum(frame, 14, 20);
    wr16(frame, 24, headerCheck);

    // ICMP echo request
    wr8(frame, 34, 8);
    wr8(frame, 35, 0);
    wr16(frame, 36, 0); // checksum will be placed here
    wr16(frame, 38, 1);
    wr16(frame, 40, 1);

    int requestCheck = inetChecksum(frame, 34, 8);
    wr16(frame, 36, requestCheck);

    prints("Pinging 10.0.2.2 ...", 1);
    netSendFrame(frame, 42);

    int len = netRecvFrame(reply, 64);
    if (len == 0) {
        prints("No reply.", 1);
        return;
    }

    int etherType = rd16(reply, 12);
    int proto = reply[23];
    int icmpType = reply[34];

    if (etherType != ETH_IPV4) {
        prints("Reply is not IPv4!", 1);
        return;
    }

    if (proto != 1) {
        prints("Reply is not ICMP!", 1);
        return;
    }

    if (icmpType != 0) {
        prints("Not an echo reply!", 1);
        return;
    }

    prints("Reply from 10.0.2.2!", 1);
    return;
}

/**
 * ARP test program
 */
void arptest(int argc, int **argv) {
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

/**
 * NIC network test program
 */
void nettest(int argc, int **argv) {
    int frame[4];
    int i;

    prints("Generating frame...", 1);

    for (i = 0; i < 4; i++) {
        frame[i] = i;
    }

    prints("Sending frame", 1);
    netSendFrame(frame, 4);

    int recvFrame[4];

    prints("Receiving frame", 1);
    int frameSize = netRecvFrame(recvFrame, 4);

    prints("Received Frame Content:", 1);

    int integrity = 0;

    for (i = 0; i < 4; i++) {
        int val = recvFrame[i];

        printi(val, 1);
        if(val == i) {
            integrity++;
        }
    }

    printc('\n');
    prints("Integrity : ", 0);
    printi(integrity, 0);
    prints("/4", 1);
    printc('\n');

    prints("nettest done!", 1);
    return;
}

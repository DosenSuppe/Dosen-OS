#include "../utils/stdio.h"

const int ETH_ARP = 0x0806;
const int ETH_IPV4 = 0x0800;

const int IP_GUEST = 0x0A00020F;    // 10.0.2.15
const int IP_GATEWAY = 0x0A000202;  // 10.0.2.2
const int IP_DNS = 0x0A000203;      // 10.0.2.3

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


#include "../../../drivers/net.h"
#include "../../../utils/stdio.h"

/**
 * ping command
 * 
 * > ping
 * 
 * WIP:
 * > ping [ip-address]
 */
void ping(int argc, int **argv) {
    int success = 0;

    prints("Pining 10.0.2.2:", 1);

    for (int i = 0; i < 4; i++) {
        int response = _ping();

        if (response == 1) {
            prints("Reponse from 10.0.2.2 TTL=64", 1);
            success++;
        }
        // TODO: handle non successful responses
    }

    printc('\n');
    prints("Ping statistics for 10.0.2.2:", 1);
    prints("\tPackets: Sent = 4, Received = ", 0);
    printi(success, 0);
    prints(", Failed = ", 0);
    printi((4 - success), 1);

    return;
}

int _ping() {
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
        return 0;
    }

    int etherType = rd16(reply, 12);
    int proto = reply[23];
    int icmpType = reply[34];

    if (etherType != ETH_IPV4) {
        prints("Reply is not IPv4!", 1);
        return 0;
    }

    if (proto != 1) {
        prints("Reply is not ICMP!", 1);
        return 0;
    }

    if (icmpType != 0) {
        prints("Not an echo reply!", 1);
        return 0;
    }

    return 1;
}


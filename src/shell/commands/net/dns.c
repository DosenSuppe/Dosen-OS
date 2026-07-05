#include "../../../drivers/net.h"
#include "../../../utils/stdio.h"
#include "../../../utils/string.h"
#include "../../../shell/fs.h"

const char DNS_CACHE_FILENAME[14] = "dns-cache.txt";
const int DNS_CACHE_FILENNAME_LEN = 14;
const int DNS_CACHE_MAX_BYTES = 0x1000;

void dns(int argc, int **argv) {
    int frame[128];
    int reply[256];

    if (argc < 2) {
        prints("usage: dns <hostname>", 1);
        return;
    }

    int *hostname = argv[1];

    int cachedIpAddress = retrieveDnsEntry(hostname);
    
    if (cachedIpAddress != 0) {
        prints("Cached IP-Address for: ", 0);
        prints(hostname, 1);

        prints("\tIP as decimal value: ", 0);
        printi(cachedIpAddress, 1);

        return;
    }

    // --- Ethernet header ---
    putGatewayMac(frame, 0);
    putGuestMac(frame, 6);
    wr16(frame, 12, ETH_IPV4);

    // --- IPv4 header (length + checksum filled in once the payload is built) ---
    wr8(frame, 14, 0x45);
    wr8(frame, 15, 0x00);
    wr16(frame, 16, 0);          // total length, set below
    wr16(frame, 18, 0);
    wr16(frame, 20, 0);
    wr8(frame, 22, 64);
    wr8(frame, 23, 17);          // protocol = UDP
    wr16(frame, 24, 0);          // checksum, set below
    wr32(frame, 26, IP_GUEST);
    wr32(frame, 30, IP_DNS);

    // --- DNS header (12 bytes at byte 42) ---
    wr16(frame, 42, 0x1234);     // transaction ID
    wr16(frame, 44, 0x0100);     // flags: standard query, recursion desired
    wr16(frame, 46, 1);          // QDCOUNT = 1
    wr16(frame, 48, 0);          // ANCOUNT
    wr16(frame, 50, 0);          // NSCOUNT
    wr16(frame, 52, 0);          // ARCOUNT

    // --- Question: QNAME at byte 54, then QTYPE + QCLASS ---
    int nameLen = dnsEncodeName(frame, 54, hostname);
    wr16(frame, 54 + nameLen, 1);       // QTYPE = A
    wr16(frame, 54 + nameLen + 2, 1);   // QCLASS = IN

    int dnsLen = 12 + nameLen + 4;

    // --- UDP header (byte 34); its length depends on the DNS payload ---
    wr16(frame, 34, 0xC000);            // source port
    wr16(frame, 36, 53);                // dest port = DNS
    wr16(frame, 38, 8 + dnsLen);        // UDP length
    wr16(frame, 40, 0);                 // checksum = 0 (optional over IPv4)

    // --- finish the IP header now that we know the total length ---
    wr16(frame, 16, 20 + 8 + dnsLen);
    int headerCheck = inetChecksum(frame, 14, 20);
    wr16(frame, 24, headerCheck);

    int totalLen = 42 + dnsLen;

    prints("Resolving...", 1);
    netSendFrame(frame, totalLen);

    int len = netRecvFrame(reply, 256);
    if (len == 0) {
        prints("No reply.", 1);
        return;
    }

    int anCount = rd16(reply, 48);          // ANCOUNT
    if (anCount == 0) {
        prints("No answers.", 1);
        return;
    }

    // Answer section starts right after the echoed question.
    int pos = 58 + nameLen;

    for (int a = 0; a < anCount; a++) {
        // Skip this record's NAME: a compression pointer (>=0xC0) is 2 bytes,
        // otherwise it's a label sequence terminated by 0.
        if (reply[pos] >= 0xC0) {
            pos = pos + 2;
        } else {
            while (reply[pos] != 0) {
                pos = pos + reply[pos] + 1;
            }
            pos = pos + 1;
        }

        int type     = rd16(reply, pos);       // TYPE
        int rdlength = rd16(reply, pos + 8);   // RDLENGTH (after TYPE, CLASS, TTL)
        int rdata    = pos + 10;

        if (type == 1 && rdlength == 4) {  // A record, IPv4
            prints("Resolved:", 1);
            printi(reply[rdata], 0);
            prints(".", 0);
            printi(reply[rdata + 1], 0);
            prints(".", 0);
            printi(reply[rdata + 2], 0);
            prints(".", 0);
            printi(reply[rdata + 3], 1);

            saveDnsResult(hostname, reply[rdata], reply[rdata + 1], reply[rdata + 2], reply[rdata + 3]);
            return;
        }

        pos = rdata + rdlength;            // not an A record (e.g. CNAME): skip it
    }

    prints("No A record found.", 1);
    return;
}

int dnsCharLower(int c) {
    if (c >= 'A' && c <= 'Z')
        return c + 32;
    return c;
}

int dnsLineMatches(int *data, int pos, int size, int *hostname) {
    int i = 0;

    while (hostname[i] != 0) {
        if (pos + i >= size) return 0;
        if (dnsCharLower(data[pos + i]) != dnsCharLower(hostname[i])) return 0;
        i++;
    }

    if (pos + i >= size) return 0;
    if (data[pos + i] != ':') return 0;

    return 1;
}

int dnsParseIp(int *data, int pos, int size) {
    int ip = 0;
    int octet = 0;

    while (pos < size) {
        int c = data[pos];

        if (c >= '0' && c <= '9') {
            octet = octet * 10 + (c - '0');
        } else if (c == '.') {
            ip = (ip << 8) | octet;
            octet = 0;
        } else break;

        pos++;
    }

    return (ip << 8) | octet;
}

int dnsAppendOctet(int *data, int pos, int value) {
    if (value >= 100) {
        data[pos] = '0' + (value / 100);
        pos++;
    }

    if (value >= 10) {
        data[pos] = '0' + (value / 10) % 10;
        pos++;
    }

    data[pos] = '0' + value % 10;
    return pos + 1;
}


/**
 * @param hostname Pointer for the hostname string
 * @param octett1 1st octett of the resolved ip-address
 * @param octett2 2nd octett of the resolved ip-address
 * @param octett3 3rd octett of the resolved ip-address
 * @param octett4 4th octett of the resolved ip-address
 * 
 * @returns void
 */
void saveDnsResult(int *hostname, int octett1, int octett2, int octett3, int octett4) {
    int *cacheFile = fs_find(DNS_CACHE_FILENAME, DNS_CACHE_FILENNAME_LEN);

    if (cacheFile == 0) {
        cacheFile = fs_create(DNS_CACHE_FILENAME, DNS_CACHE_FILENNAME_LEN);

        if (cacheFile == 0) {
            prints("DNS-ERROR: Unable to create DNS Cache file!", 1);
            return;
        }
    }

    int *data = fs_data_ptr(cacheFile);
    int pos = cacheFile[1];

    // worst case append: hostname + ':' + ip + '\n'
    int needed = stringLen(hostname) + 17;

    if (pos + needed > DNS_CACHE_MAX_BYTES) {
        prints("DNS-ERROR: Cache file is full!", 1);
        return;
    }

    int i = 0;
    while (hostname[i] != 0) {
        data[pos] = dnsCharLower(hostname[i]);
        pos++;
        i++;
    }

    data[pos] = ':';
    pos++;

    pos = dnsAppendOctet(data, pos, octett1);
    data[pos] = '.'; pos++;
    pos = dnsAppendOctet(data, pos, octett2);
    data[pos] = '.'; pos++;
    pos = dnsAppendOctet(data, pos, octett3);
    data[pos] = '.'; pos++;
    pos = dnsAppendOctet(data, pos, octett4);

    data[pos] = '\n';
    pos++;

    cacheFile[1] = pos;
    fs_mark_dirty(cacheFile);
}

/**
 * Retreives the ip-address of given hostname from the DNS entry cache file.
 * 
 * @param hostname Pointer for the hostname string
 * 
 * @returns ip-address of the host (or 0.0.0.0 if entry is invalid or hostname not found)
 */
int retrieveDnsEntry(int *hostname) {
    int *cacheFile = fs_find(DNS_CACHE_FILENAME, DNS_CACHE_FILENNAME_LEN);

    if (cacheFile == 0) {
        cacheFile = fs_create(DNS_CACHE_FILENAME, DNS_CACHE_FILENNAME_LEN);
        if (cacheFile == 0) {
            prints("DNS-ERROR: Unable to create DNS Cache file!", 1);
        }
        return 0;   // fresh file has no entries
    }

    int *data = fs_data_ptr(cacheFile);   // data[0] is the file's first char
    int size = cacheFile[1];              // length in chars

    int pos = 0;
    while (pos < size) {
        // pos is at the start of a line
        if (data[pos] != '#' && data[pos] != '\n' && data[pos] != '\r') {
            if (dnsLineMatches(data, pos, size, hostname)) {
                while (pos < size && data[pos] != ':') { pos++; }
                return dnsParseIp(data, pos + 1, size);
            }
        }

        // advance to the start of the next line
        while (pos < size && data[pos] != '\n') { pos++; }
        pos++;   // step over the '\n'
    }

    return 0;   // not found
}

int dnsEncodeName(int *frame, int offset, int *name) {
    int pos;
    int i;
    int lenPos;
    int count;

    pos = offset + 1;   // reserve the first length byte
    lenPos = offset;    // where that length byte goes
    count = 0;
    i = 0;

    while (name[i] != 0) {
        if (name[i] == '.') {
            frame[lenPos] = count;   // backpatch the finished label
            lenPos = pos;            // next length byte lives here
            pos = pos + 1;           // reserve it
            count = 0;
        } else {
            frame[pos] = name[i];    // copy the character
            pos = pos + 1;
            count = count + 1;
        }
        i = i + 1;
    }

    frame[lenPos] = count;   // backpatch the final label
    frame[pos] = 0;          // terminating zero
    pos = pos + 1;

    return pos - offset;     // bytes written (includes the terminating zero)
}

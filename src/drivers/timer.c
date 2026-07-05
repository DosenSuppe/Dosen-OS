int _utcStrBuf[24];   // "YYYY-MM-DD HH:MM:SS" + null

int *_timer(void) { asm("LDI REA, $MemDevice4.Start"); }

int _putNum(int *buf, int pos, int val, int digits) {
    int i;
    for (i = digits - 1; i >= 0; i--) {
        buf[pos + i] = '0' + (val % 10);
        val = val / 10;
    }
    return pos + digits;
}

int uptimeMs(void) {
    int *timer = _timer();
    return timer[0];
}

int utcNow(void) {
    int *timer = _timer();
    return timer[1];
}

int *utcToString(int utc) {
    int sec  = utc % 60;
    int rem  = utc / 60;
    int min  = rem % 60;
    
    rem = rem / 60;

    int hour = rem % 24;
    int days = rem / 24;

    // Civil date from days-since-1970 (assumes UTC >= 0, i.e. after 1970).
    int z   = days + 719468;
    int era = z / 146097;
    int doe = z - era * 146097;
    int yoe = (doe - doe / 1460 + doe / 36524 - doe / 146096) / 365;
    int y   = yoe + era * 400;
    int doy = doe - (365 * yoe + yoe / 4 - yoe / 100);
    int mp  = (5 * doy + 2) / 153;
    int day = doy - (153 * mp + 2) / 5 + 1;

    int month = (mp < 10) ? mp + 3 : mp - 9;
    int year  = (month <= 2) ? y + 1 : y;

    // YYYY-MM-DD HH:MM:SS
    int pos = 0;
    pos = _putNum(_utcStrBuf, pos, year, 4);
    _utcStrBuf[pos] = '-'; pos = pos + 1;
    pos = _putNum(_utcStrBuf, pos, month, 2);
    _utcStrBuf[pos] = '-'; pos = pos + 1;
    pos = _putNum(_utcStrBuf, pos, day, 2);
    _utcStrBuf[pos] = ' '; pos = pos + 1;
    pos = _putNum(_utcStrBuf, pos, hour, 2);
    _utcStrBuf[pos] = ':'; pos = pos + 1;
    pos = _putNum(_utcStrBuf, pos, min, 2);
    _utcStrBuf[pos] = ':'; pos = pos + 1;
    pos = _putNum(_utcStrBuf, pos, sec, 2);
    _utcStrBuf[pos] = 0;

    return _utcStrBuf;
}

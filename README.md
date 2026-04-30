# Dosen-OS
Dosen-OS is an operating system written in DASM (Dosen-Assembly) and build for my custom [24bit CPU](https://github.com/DosenSuppe/CPU-24bit)

## Upcoming Features:
- running programs
- creating, reading and editing files

## Building the OS
```
> dasm src/main.dasm
> dasm-linker bin/main.obj mem.cfg os.o
```


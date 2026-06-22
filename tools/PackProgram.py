"""Pack a linked Dosen-OS program into a byte-per-word disk image.

The PermaStorageDevice is byte-wide: each host file byte becomes one 24-bit
device word (low 8 bits). So a program's 24-bit instructions can't be stored
raw — every word is split into 3 big-endian bytes, which the in-OS loader
(`loadAndRunPacked` in src/shell/commands/run.c) reassembles into .UserCode.

This tool:
  1. links the program's .obj on its own (based at .UserCode via program.cfg),
     using the project's own Linker so relocations resolve exactly as in a real
     build;
  2. extracts the program's words from the linked image;
  3. prepends the 3-word ABI header {magic, version, entry_off};
  4. writes everything 3-bytes-per-word to the output file.

Usage:
    python PackProgram.py --obj <prog.obj> --cfg <program.cfg> --out <file>
                          [--segment .Program] [--base 0x010000]
                          [--entry 0] [--devtools <path>]
"""

import argparse
import json
import os
import sys

MAGIC = 0x444FF1
VERSION = 1


def word_config(devtools: str):
    """Word config from the toolchain's central WordConfig.

    Returns (BYTES_PER_WORD, WORD_MASK, WORD_STRIDE). WORD_STRIDE is how many
    address units a word occupies in the linked image, which is 4 under byte
    addressing. The packer must stay in lockstep with the device-side unpacker
    `_pack4` in src/shell/commands/run.c; flipping WordConfig changes the on-disk
    program format on both sides. Falls back to byte-addressed 32-bit defaults.
    """
    sys.path.insert(0, os.path.join(devtools, "CompilerComponents"))
    try:
        from WordConfig import BYTES_PER_WORD, WORD_MASK, WORD_STRIDE  # noqa: E402
        return BYTES_PER_WORD, WORD_MASK, WORD_STRIDE
    except Exception:
        return 4, 0xFFFFFFFF, 4


def _word_to_bytes(word: int, bytes_per_word: int, word_mask: int) -> bytes:
    """One word -> big-endian bytes (matches the device's byte-per-word view and
    the linker's binary dump)."""
    word &= word_mask
    return bytes((word >> (8 * (bytes_per_word - 1 - i))) & 0xFF
                 for i in range(bytes_per_word))


def link_image(obj_path: str, cfg_path: str, devtools: str):
    """Run the project linker in-process; return its sparse {address: word} image."""
    sys.path.insert(0, devtools)
    try:
        from Linker import Linker, MemoryConfig  # noqa: E402  (project module)
    except Exception as exc:  # pragma: no cover - environment specific
        raise SystemExit(
            f"Could not import the project Linker from {devtools!r}: {exc}\n"
            "Pass --devtools <path to CPU-24bit/DevTools>."
        )

    mem_config = MemoryConfig(cfg_path)
    linker = Linker(mem_config)
    return linker.Link(obj_path)


def segment_length(obj_path: str, segment: str) -> int:
    """Number of words the program occupies, read from the .obj's segment."""
    with open(obj_path, "r") as handle:
        obj = json.load(handle)
    segments = obj.get("segments", {})
    if segment not in segments:
        raise SystemExit(
            f"Segment {segment!r} not found in {obj_path!r}. "
            f"Present segments: {sorted(segments)}"
        )
    return len(segments[segment])


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--obj", required=True, help="assembled program .obj")
    parser.add_argument("--cfg", required=True, help="link config (program.cfg)")
    parser.add_argument("--out", required=True, help="packed output file")
    parser.add_argument("--segment", default="Program",
                        help="program segment name (no leading dot; the assembler strips it)")
    parser.add_argument("--base", default="0x01500000",
                        help="load base (must match the segment Start in --cfg)")
    parser.add_argument("--entry", default="0",
                        help="entry offset within the program body (words)")
    parser.add_argument("--devtools",
                        default=os.path.join(os.path.dirname(__file__),
                                             "..", "..", "CPU-24bit", "DevTools"),
                        help="path to CPU-24bit/DevTools (for the Linker)")
    args = parser.parse_args()

    base = int(args.base, 0)
    entry_off = int(args.entry, 0)
    devtools = os.path.abspath(args.devtools)

    bytes_per_word, word_mask, word_stride = word_config(devtools)

    word_count = segment_length(args.obj, args.segment)
    image = link_image(args.obj, args.cfg, devtools)

    # The linked image is keyed by byte address; word i sits at base + i*stride.
    body = [image.get(base + i * word_stride, 0) for i in range(word_count)]
    header = [MAGIC, VERSION, entry_off]

    payload = bytearray()
    for word in header + body:
        payload += _word_to_bytes(word, bytes_per_word, word_mask)

    with open(args.out, "wb") as handle:
        handle.write(payload)

    total_words = len(header) + len(body)
    print(f"Packed {word_count} program words (+{len(header)} header) -> "
          f"{total_words} words / {len(payload)} bytes "
          f"({bytes_per_word} bytes/word)")
    print(f"  magic=0x{MAGIC:06X} version={VERSION} entry_off={entry_off}")
    print(f"  base=0x{base:06X} segment={args.segment}")
    print(f"  wrote {args.out}")


if __name__ == "__main__":
    main()

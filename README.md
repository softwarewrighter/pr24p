# pr24p — Pascal Runtime Library

A runtime library for Pascal programs targeting the COR24 p-code VM. Provides standard I/O, math functions, safety checks, heap management, and formatted output. Written in hand-coded p-code assembly (.spc), with Pascal source files documenting the intended high-level implementation for when the p24c compiler matures enough to compile them (dogfooding).

## Overview

```
Pascal source (.pas)  ──→  p24c compiler  ──→  .spc (p-code assembly)
                                                    │
pr24p runtime (.spc)  ──────────────────────────────┤
                                                    ▼
                                              pl24r linker
                                                    │
                                                    ▼
                                           pa24r assembler  ──→  .p24 bytecode
                                                                      │
                                                                      ▼
                                                              pv24a VM (COR24)
```

The runtime is linked with user programs by pl24r (text-level .spc linker), assembled into .p24 bytecode by pa24r, and executed on the pv24a p-code VM running on the COR24 architecture (emulated via cor24-run or on real COR24-TD hardware).

## Routines (32 exported)

| Category | Routines |
|----------|----------|
| **Output** | `write_int`, `write_bool`, `write_ln`, `write_str`, `write_char` |
| **Formatted Output** | `write_int_w`, `write_char_w`, `write_bool_w`, `write_str_w` |
| **Standard Functions** | `abs`, `odd`, `ord`, `chr`, `succ`, `pred`, `sqr` |
| **Safety Checks** | `bounds_check`, `nil_check`, `subrange_check` |
| **Input** | `read_int`, `read_char`, `read_ln` |
| **I/O State** | `eof`, `eoln` |
| **Heap** | `heap_init`, `new`, `dispose`, `leak_report` |
| **Hardware** | `set_led`, `read_switch`, `halt` |

All routines use the `_p24p_` prefix (e.g., `_p24p_write_int`).

## Building & Testing

Tests are standalone .spc files run through pvmasm on the COR24 emulator:

```bash
# Run a test
content=$(cat tests/test_write_int.spc)
cor24-run --run ~/github/sw-vibe-coding/pv24a/pvmasm.s -u "${content}\x04" --speed 0 -n 50000000
```

11 test suites: `test_write_int`, `test_write_bool_ln`, `test_stdlib`, `test_write_str`, `test_checks`, `test_heap`, `test_write_fmt`, `test_hardware`, `test_integ_io`, `test_integ_heap`, `test_integ_all`.

## Project Structure

```
src/
  runtime.spc      # Main runtime — all 32 routines in p-code assembly
  heap.pas         # Pascal design for heap management
  checks.pas       # Pascal design for bounds/nil checks
  read.pas         # Pascal design for UART input
  write_fmt.pas    # Pascal design for formatted output
  io_state.pas     # Pascal design for eof/eoln
tests/
  test_*.spc       # 11 test suites (unit + integration + hardware)
docs/
  runtime.md       # Runtime library specification
  research.txt     # P-code VM design notes
  agent-cas-wiki.md # Wiki API for cross-agent coordination
```

## Documentation

- [Runtime Library Specification](docs/runtime.md) — phases, routines, stack effects, syscall interface, linking model
- [Research Notes](docs/research.txt) — p-code VM design, memory model, bootstrap strategy
- [Wiki Coordination](docs/agent-cas-wiki.md) — CAS protocol for multi-agent collaboration

## Related Projects

| Project | Description |
|---------|-------------|
| [p24c](https://github.com/softwarewrighter/p24p) | Pascal compiler (.pas → .spc) |
| [pl24r](https://github.com/softwarewrighter/pl24r) | P-code linker (merges .spc modules) |
| [pa24r](https://github.com/softwarewrighter/pa24r) | Rust p-code assembler (.spc → .p24) |
| [pv24a](https://github.com/sw-vibe-coding/pv24a) | P-code VM in COR24 assembly |
| [cor24-rs](https://github.com/sw-embed/cor24-rs) | COR24 emulator and assembler |
| [web-dv24r](https://github.com/softwarewrighter/web-dv24r) | Browser-based p-code debugger |

## License

Copyright (c) 2026 Mike Wright / Software Wrighter. All rights reserved.

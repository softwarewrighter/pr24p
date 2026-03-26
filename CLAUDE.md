# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## CRITICAL: AgentRail Session Protocol (MUST follow exactly)

This project uses AgentRail. Every session follows this exact sequence:

### 1. START (do this FIRST, before anything else)
```bash
agentrail next
```
Read the output carefully. It tells you your current step, prompt, skill docs, and past trajectories.

### 2. BEGIN (immediately after reading the next output)
```bash
agentrail begin
```

### 3. WORK (do what the step prompt says)
Do NOT ask the user "want me to proceed?" or "shall I start?". The step prompt IS your instruction. Execute it.

### 4. COMMIT (after the work is done)
Commit your code changes with git.

### 5. COMPLETE (LAST thing, after committing)
```bash
agentrail complete --summary "what you accomplished" \
  --reward 1 \
  --actions "tools and approach used"
```
If the step failed: `--reward -1 --failure-mode "what went wrong"`
If the saga is finished: add `--done`

### 6. STOP (after complete, DO NOT continue working)
Do NOT make any further code changes after running agentrail complete.
Any changes after complete are untracked and invisible to the next session.
If you see more work to do, it belongs in the NEXT step, not this session.

Do NOT skip any of these steps. The next session depends on your trajectory recording.

## Project: pr24p — Pascal Runtime Library

A Pascal runtime library written in Pascal (dogfooding the p24c compiler). Provides
standard Pascal I/O, math, string, set, and heap routines. Compiled by the p24c
compiler (separate project) into .spc, assembled by pasm into .p24 bytecode, and
run on the pv24a VM via cor24-run emulator or real COR24-TD hardware.

**This project is NOT the compiler.** The compiler is p24c (separate repo). This
project contains only the runtime library source and tests.

## File Extensions

- `.pas` — Pascal source (runtime routines, Phase 1+)
- `.spc` — P-code assembler source (hand-written Phase 0 stubs, compiler output)
- `.p24` — Assembled p-code bytecode (pasm output, VM input)

## Key Documentation (READ BEFORE WORKING)

- `docs/runtime.md` — Runtime library specification: phases, routines, stack effects, syscall interface, linking model
- `docs/research.txt` — Deep research on Pascal implementation, p-code VM design, memory model, and bootstrap strategy
- `docs/agent-instructions.txt` — Original project setup instructions

## Related Projects

- `~/github/softwarewrighter/p24p` (a.k.a. p24c) — Pascal compiler, compiles .pas to .spc
- `~/github/sw-vibe-coding/pv24a` — P-code VM and pasm assembler in COR24 assembly
- `~/github/softwarewrighter/web-dv24r` — Browser-based p-code VM debugger (Yew/Rust/WASM)
- `~/github/sw-embed/cor24-rs` — COR24 assembler and emulator (`cor24-run`)
- `~/github/sw-vibe-coding/agentrail-domain-coding` — Coding skills domain

## Available Task Types

`cor24-asm`, `pre-commit`

## Build & Test

```bash
# Assemble .spc and run on VM
cor24-run --run <file.s> --speed 0

# With UART input
cor24-run --run <file.s> -u 'input text\n' --speed 0 -n 5000000
```

## VM Syscall Interface

| ID | Name | Stack Effect | Description |
|----|------|-------------|-------------|
| 0 | HALT | ( -- ) | Stop execution |
| 1 | PUTC | ( c -- ) | Write byte to UART |
| 2 | GETC | ( -- c ) | Read byte from UART (blocking) |
| 3 | LED | ( n -- ) | Write LED state |
| 4 | ALLOC | ( size -- addr ) | Heap allocate |
| 5 | FREE | ( addr -- ) | Heap free |

## Naming Convention

All runtime routines use the `_p24p_` prefix to avoid collisions with user Pascal identifiers.

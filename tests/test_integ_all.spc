; Integration test: All phases combined
; Reads input, uses stdlib, allocates heap, writes formatted, checks bounds
; Phases: 0 (write), 1 (stdlib, checks, read), 2 (heap, formatting, eof)
.global hac 1
.global hfc 1
.global hpt 16
.global iola 1
.global ioef 1
.proc main 3
; init globals
call hi
push -1
storeg iola
push 0
storeg ioef
; read two ints
call ri
storel 0
call ri
storel 1
; alloc block, store abs of first
push 1
call nw
storel 2
loadl 0
call ab
loadl 2
store
; print stored value formatted
loadl 2
load
push 6
call iw
call wl
; sqr of second
loadl 1
call sq
call wi
call wl
; odd check
loadl 0
call od
call wb
call wl
; bounds check second in [1..100]
loadl 1
push 1
push 100
call bc
push 66
sys 1
push 67
sys 1
call wl
; dispose and leak report
loadl 2
call dp
call lr
; check eof
call ef
call wb
call wl
halt
.end
; heap_init
.proc hi 1
push 0
storeg hac
push 0
storeg hfc
push 0
storel 0
g0:
loadl 0
push 16
ge
jnz g1
push 0
addrg hpt
loadl 0
push 3
mul
add
store
loadl 0
push 1
add
storel 0
jmp g0
g1:
ret 0
.end
; new
.proc nw 2
loada 0
sys 4
storel 0
loadg hac
push 1
add
storeg hac
push 0
storel 1
h0:
loadl 1
push 16
ge
jnz h2
addrg hpt
loadl 1
push 3
mul
add
load
jnz h1
loadl 0
addrg hpt
loadl 1
push 3
mul
add
store
jmp h2
h1:
loadl 1
push 1
add
storel 1
jmp h0
h2:
loadl 0
ret 1
.end
; dispose
.proc dp 1
loada 0
sys 5
loadg hfc
push 1
add
storeg hfc
push 0
storel 0
i0:
loadl 0
push 16
ge
jnz i2
addrg hpt
loadl 0
push 3
mul
add
load
loada 0
ne
jnz i1
push 0
addrg hpt
loadl 0
push 3
mul
add
store
jmp i2
i1:
loadl 0
push 1
add
storel 0
jmp i0
i2:
ret 1
.end
; leak_report
.proc lr 1
loadg hac
loadg hfc
sub
storel 0
loadl 0
push 0
gt
jz j0
push 76
sys 1
push 69
sys 1
push 65
sys 1
push 75
sys 1
push 58
sys 1
loadl 0
jmp j1
j0:
push 79
sys 1
push 75
sys 1
push 58
sys 1
push 0
j1:
dup
push 0
lt
jz j2
push 45
sys 1
neg
j2:
storel 0
push 0
j3:
loadl 0
push 10
mod
push 48
add
loadl 0
push 10
div
storel 0
loadl 0
jnz j3
j4:
dup
jz j5
sys 1
jmp j4
j5:
drop
push 10
sys 1
ret 0
.end
; abs
.proc ab 0
loada 0
dup
push 0
lt
jz a0
neg
a0:
ret 1
.end
; sqr
.proc sq 0
loada 0
dup
mul
ret 1
.end
; odd
.proc od 0
loada 0
push 2
mod
push 0
ne
ret 1
.end
; eof
.proc ef 0
loadg iola
push 0
lt
jz k0
sys 2
storeg iola
k0:
loadg iola
push 4
eq
ret 0
.end
; nil_check
.proc nc 0
loada 0
jnz n0
push 78
sys 1
push 73
sys 1
push 76
sys 1
push 10
sys 1
sys 0
n0:
loada 0
ret 1
.end
; bounds_check
.proc bc 0
loada 2
loada 1
lt
jnz f0
loada 2
loada 0
gt
jnz f0
ret 3
f0:
push 66
sys 1
push 79
sys 1
push 85
sys 1
push 78
sys 1
push 68
sys 1
push 83
sys 1
push 10
sys 1
sys 0
.end
; write_int
.proc wi 1
loada 0
dup
push 0
lt
jz b0
push 45
sys 1
neg
b0:
storel 0
push 0
b1:
loadl 0
push 10
mod
push 48
add
loadl 0
push 10
div
storel 0
loadl 0
jnz b1
b2:
dup
jz b3
sys 1
jmp b2
b3:
drop
ret 1
.end
; write_bool
.proc wb 0
loada 0
jz c0
push 84
sys 1
push 82
sys 1
push 85
sys 1
push 69
sys 1
jmp c1
c0:
push 70
sys 1
push 65
sys 1
push 76
sys 1
push 83
sys 1
push 69
sys 1
c1:
ret 1
.end
; write_ln
.proc wl 0
push 10
sys 1
ret 0
.end
; write_int_w (n width --)
.proc iw 3
push 0
storel 2
loada 1
dup
push 0
lt
jz d0
push 1
storel 2
neg
d0:
storel 0
push 0
storel 1
d1:
loadl 1
push 1
add
storel 1
loadl 0
push 10
div
storel 0
loadl 0
jnz d1
loadl 1
loadl 2
add
storel 1
d2:
loadl 1
loada 0
ge
jnz d3
push 32
sys 1
loadl 1
push 1
add
storel 1
jmp d2
d3:
loada 1
dup
push 0
lt
jz d4
push 45
sys 1
neg
d4:
storel 0
push 0
d5:
loadl 0
push 10
mod
push 48
add
loadl 0
push 10
div
storel 0
loadl 0
jnz d5
d6:
dup
jz d7
sys 1
jmp d6
d7:
drop
ret 2
.end
; read_int
.proc ri 3
push 0
storel 0
push 0
storel 1
sys 2
storel 2
e0:
loadl 2
push 32
eq
jnz e1
loadl 2
push 9
eq
jnz e1
jmp e2
e1:
sys 2
storel 2
jmp e0
e2:
loadl 2
push 45
ne
jnz e3
push 1
storel 1
sys 2
storel 2
jmp e4
e3:
loadl 2
push 43
ne
jnz e4
sys 2
storel 2
e4:
loadl 2
push 48
lt
jnz e5
loadl 2
push 57
gt
jnz e5
loadl 0
push 10
mul
loadl 2
push 48
sub
add
storel 0
sys 2
storel 2
jmp e4
e5:
loadl 1
jz e6
loadl 0
neg
storel 0
e6:
loadl 0
ret 0
.end

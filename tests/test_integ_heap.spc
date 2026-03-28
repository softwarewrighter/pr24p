; Integration test: Heap + checks + I/O across phases
; Allocates memory, stores/loads values, checks bounds, disposes, reports leaks
; Phases: 0 (write_int/bool/ln), 1 (bounds_check/nil_check), 2 (heap/leak_report)
.global hac 1
.global hfc 1
.global hpt 16
.proc main 3
; init heap
call hi
; allocate 3 blocks
push 4
call nw
storel 0
push 2
call nw
storel 1
push 1
call nw
storel 2
; nil check on first ptr (should pass)
loadl 0
call nc
call wi
call wl
; leak report: expect LEAK:3
call lr
; dispose first two
loadl 0
call dp
loadl 1
call dp
; leak report: expect LEAK:1
call lr
; dispose last
loadl 2
call dp
; leak report: expect OK:0
call lr
; bounds check: 5 in [1..10] (should pass)
push 5
push 1
push 10
call bc
push 80
sys 1
push 65
sys 1
push 83
sys 1
push 83
sys 1
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
a0:
loadl 0
push 16
ge
jnz a1
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
jmp a0
a1:
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
b0:
loadl 1
push 16
ge
jnz b2
addrg hpt
loadl 1
push 3
mul
add
load
jnz b1
loadl 0
addrg hpt
loadl 1
push 3
mul
add
store
jmp b2
b1:
loadl 1
push 1
add
storel 1
jmp b0
b2:
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
c0:
loadl 0
push 16
ge
jnz c2
addrg hpt
loadl 0
push 3
mul
add
load
loada 0
ne
jnz c1
push 0
addrg hpt
loadl 0
push 3
mul
add
store
jmp c2
c1:
loadl 0
push 1
add
storel 0
jmp c0
c2:
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
jz d0
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
jmp d1
d0:
push 79
sys 1
push 75
sys 1
push 58
sys 1
push 0
d1:
dup
push 0
lt
jz d2
push 45
sys 1
neg
d2:
storel 0
push 0
d3:
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
jnz d3
d4:
dup
jz d5
sys 1
jmp d4
d5:
drop
push 10
sys 1
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
jz p0
push 45
sys 1
neg
p0:
storel 0
push 0
e0:
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
jnz e0
e1:
dup
jz e2
sys 1
jmp e1
e2:
drop
ret 1
.end
; write_ln
.proc wl 0
push 10
sys 1
ret 0
.end

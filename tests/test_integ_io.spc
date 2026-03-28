; Integration test: I/O + stdlib + formatting across phases
; Reads 2 integers, applies stdlib functions, writes formatted output
; Phases exercised: 0 (write_int/bool/ln), 1 (abs/odd/sqr/read), 2 (write_int_w/char)
.proc main 2
; Read two integers from input
call ri
storel 0
call ri
storel 1
; abs of first, write formatted in width 6
loadl 0
call ab
push 6
call iw
call wl
; sqr of second, write formatted in width 8
loadl 1
call sq
push 8
call iw
call wl
; odd test on first: write bool
loadl 0
call od
call wb
call wl
; write_char of 'X' then newline
push 88
call wc
call wl
; write_int of both raw
loadl 0
call wi
push 32
sys 1
loadl 1
call wi
call wl
; subrange check: second must be 1..20
loadl 1
push 1
push 20
call sr
; passed check
push 79
sys 1
push 75
sys 1
call wl
halt
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
; write_char
.proc wc 0
loada 0
sys 1
ret 1
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
; subrange_check
.proc sr 0
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
push 82
sys 1
push 65
sys 1
push 78
sys 1
push 71
sys 1
push 69
sys 1
push 10
sys 1
sys 0
.end

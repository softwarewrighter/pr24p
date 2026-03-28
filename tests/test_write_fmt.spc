.global iola 1
.global ioef 1
.proc main 0
push -1
storeg iola
push 0
storeg ioef
push 65
call wc
call wl
push 42
push 8
call iw
call wl
push -7
push 5
call iw
call wl
push 5
push 3
call iw
call wl
push 66
push 5
call cw
call wl
push 1
push 8
call bw
call wl
push 0
push 8
call bw
call wl
push 3
push 1
push 10
call sr
push 79
sys 1
push 75
sys 1
call wl
push 11
push 1
push 10
call sr
halt
.end
.proc wc 0
loada 0
sys 1
ret 1
.end
.proc wl 0
push 10
sys 1
ret 0
.end
.proc iw 3
; loada 0=width, loada 1=n
push 0
storel 2
loada 1
dup
push 0
lt
jz a0
push 1
storel 2
neg
jmp a1
a0:
a1:
storel 0
push 0
storel 1
a2:
loadl 1
push 1
add
storel 1
loadl 0
push 10
div
storel 0
loadl 0
jnz a2
loadl 1
loadl 2
add
storel 1
a3:
loadl 1
loada 0
ge
jnz a4
push 32
sys 1
loadl 1
push 1
add
storel 1
jmp a3
a4:
loada 1
dup
push 0
lt
jz a5
push 45
sys 1
neg
a5:
storel 0
push 0
a6:
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
jnz a6
a7:
dup
jz a8
sys 1
jmp a7
a8:
drop
ret 2
.end
.proc cw 1
; loada 0=width, loada 1=c
loada 0
storel 0
b0:
loadl 0
push 1
le
jnz b1
push 32
sys 1
loadl 0
push 1
sub
storel 0
jmp b0
b1:
loada 1
sys 1
ret 2
.end
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
.proc bw 2
; loada 0=width, loada 1=b
loada 1
jz d0
push 4
jmp d1
d0:
push 5
d1:
storel 0
loada 0
storel 1
d2:
loadl 0
loadl 1
ge
jnz d3
push 32
sys 1
loadl 1
push 1
sub
storel 1
jmp d2
d3:
loada 1
call wb
ret 2
.end
.proc sr 0
loada 2
loada 1
lt
jnz e0
loada 2
loada 0
gt
jnz e0
ret 3
e0:
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

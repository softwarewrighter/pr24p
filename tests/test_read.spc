.proc main 0
call rc
sys 1
call rc
sys 1
call wl
call ri
call wi
call wl
call ri
call wi
call wl
call rl
call rc
sys 1
call wl
halt
.end
.proc rc 0
sys 2
ret 0
.end
.proc ri 3
push 0
storel 0
push 0
storel 1
sys 2
storel 2
s0:
loadl 2
push 32
eq
jnz s1
loadl 2
push 9
eq
jnz s1
jmp s2
s1:
sys 2
storel 2
jmp s0
s2:
loadl 2
push 45
ne
jnz s3
push 1
storel 1
sys 2
storel 2
jmp s4
s3:
loadl 2
push 43
ne
jnz s4
sys 2
storel 2
s4:
loadl 2
push 48
lt
jnz s5
loadl 2
push 57
gt
jnz s5
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
jmp s4
s5:
loadl 1
jz s6
loadl 0
neg
storel 0
s6:
loadl 0
ret 0
.end
.proc rl 1
sys 2
storel 0
r0:
loadl 0
push 10
eq
jnz r1
sys 2
storel 0
jmp r0
r1:
ret 0
.end
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
d0:
dup
jz d1
sys 1
jmp d0
d1:
drop
ret 1
.end
.proc wl 0
push 10
sys 1
ret 0
.end

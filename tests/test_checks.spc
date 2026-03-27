.proc main 0
push 5
push 1
push 10
call bc
push 79
sys 1
push 75
sys 1
call wl
push 42
call nc
call wi
call wl
push 0
call nc
call wi
call wl
halt
.end
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

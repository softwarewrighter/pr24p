.proc main 0
push 1
call wb
call wl
push 0
call wb
call wl
push 42
call wi
call wl
halt
.end
.proc wi 1
loada 0
dup
push 0
lt
jz a
push 45
sys 1
neg
a:
storel 0
push 0
b:
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
jnz b
c:
dup
jz d
sys 1
jmp c
d:
drop
ret 1
.end
.proc wb 0
loada 0
jz f
push 84
sys 1
push 82
sys 1
push 85
sys 1
push 69
sys 1
jmp g
f:
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
g:
ret 1
.end
.proc wl 0
push 10
sys 1
ret 0
.end

.proc main 0
push 42
call wi
call wl
push 0
call wi
call wl
push -5
call wi
call wl
push 7
call wi
call wl
push 1
call wi
call wl
push -1
call wi
call wl
push 100
call wi
call wl
push 999
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
.proc wl 0
push 10
sys 1
ret 0
.end

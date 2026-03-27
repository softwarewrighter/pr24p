.proc main 0
push -5
call ab
call wi
call wl
push 3
call ab
call wi
call wl
push 7
call od
call wi
call wl
push 4
call od
call wi
call wl
push 65
call or
call wi
call wl
push 66
call ch
sys 1
call wl
push 5
call su
call wi
call wl
push 5
call pr
call wi
call wl
push 6
call sq
call wi
call wl
push -3
call sq
call wi
call wl
halt
.end
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
.proc od 0
loada 0
push 2
mod
push 0
ne
ret 1
.end
.proc or 0
loada 0
ret 1
.end
.proc ch 0
loada 0
ret 1
.end
.proc su 0
loada 0
push 1
add
ret 1
.end
.proc pr 0
loada 0
push 1
sub
ret 1
.end
.proc sq 0
loada 0
dup
mul
ret 1
.end
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
.proc wl 0
push 10
sys 1
ret 0
.end

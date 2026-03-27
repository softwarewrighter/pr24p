.data hi 72, 101, 108, 108, 111, 0
.data by 66, 121, 101, 0
.proc main 0
push hi
call ws
call wl
push by
call ws
call wl
halt
.end
.proc ws 1
loada 0
storel 0
a:
loadl 0
loadb
dup
jz b
sys 1
loadl 0
push 1
add
storel 0
jmp a
b:
drop
ret 1
.end
.proc wl 0
push 10
sys 1
ret 0
.end

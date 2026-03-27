.global hac 1
.global hfc 1
.global hpt 16
.proc main 3
call hi
push 5
call nw
storel 0
push 3
call nw
storel 1
push 8
call nw
storel 2
call lr
loadl 0
call dp
call lr
loadl 1
call dp
loadl 2
call dp
call lr
halt
.end
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

; Test: readln(x) — read_int then read_ln on same line
; Input: "42\n99\n" — should read 42, consume \n, then read 99
; Verifies read_int does NOT consume the newline terminator
.global iola 1
.global ioef 1
.proc main 0
push -1
storeg iola
; readln(x): read_int + read_ln
call ri
call wi
call wl
call rl
; readln(y): read_int + read_ln
call ri
call wi
call wl
call rl
halt
.end
; read_int with putback
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
; putback non-digit into lookahead
loadl 2
storeg iola
loadl 1
jz s6
loadl 0
neg
storel 0
s6:
loadl 0
ret 0
.end
; read_ln with lookahead check
.proc rl 1
loadg iola
push 0
lt
jnz r0
loadg iola
storel 0
push -1
storeg iola
jmp r1
r0:
sys 2
storel 0
r1:
loadl 0
push 10
eq
jnz r2
sys 2
storel 0
jmp r1
r2:
ret 0
.end
; write_int
.proc wi 1
loada 0
dup
push 0
lt
jz a0
push 45
sys 1
neg
a0:
storel 0
push 0
a1:
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
jnz a1
a2:
dup
jz a3
sys 1
jmp a2
a3:
drop
ret 1
.end
; write_ln
.proc wl 0
push 10
sys 1
ret 0
.end
